(* Keccak-f[1600], rate 136 bytes, capacity 512 bits, suffix 0x01.
   Coordinates use x + 5*y.  Lanes and output bytes are little endian.
   Reference: https://keccak.team/keccak_specs_summary.html *)
include (struct
  type index = I0 | I1 | I2 | I3 | I4

  let next = function I0 -> I1 | I1 -> I2 | I2 -> I3 | I3 -> I4 | I4 -> I0
  let prev = function I0 -> I4 | I1 -> I0 | I2 -> I1 | I3 -> I2 | I4 -> I3
  let get i (a, b, c, d, e) =
    match i with I0 -> a | I1 -> b | I2 -> c | I3 -> d | I4 -> e
  let tab f = (f I0, f I1, f I2, f I3, f I4)
  let at a x y = get x (get y a)
  let grid f = tab (fun y -> tab (fun x -> f x y))
  let xor = Int64.logxor
  let rot a n =
    if n = 0 then a
    else Int64.logor (Int64.shift_left a n) (Int64.shift_right_logical a (64 - n))
  let zero = grid (fun _x _y -> 0L)
  let offsets = ((0, 1, 62, 28, 27), (36, 44, 6, 55, 20),
                 (3, 10, 43, 25, 39), (41, 45, 15, 21, 8), (18, 2, 61, 56, 14))
  let constants = [
    0x0000000000000001L; 0x0000000000008082L; 0x800000000000808aL;
    0x8000000080008000L; 0x000000000000808bL; 0x0000000080000001L;
    0x8000000080008081L; 0x8000000000008009L; 0x000000000000008aL;
    0x0000000000000088L; 0x0000000080008009L; 0x000000008000000aL;
    0x000000008000808bL; 0x800000000000008bL; 0x8000000000008089L;
    0x8000000000008003L; 0x8000000000008002L; 0x8000000000000080L;
    0x000000000000800aL; 0x800000008000000aL; 0x8000000080008081L;
    0x8000000000008080L; 0x0000000080000001L; 0x8000000080008008L]

  let round a rc =
    let c = tab (fun x ->
      List.fold_left xor 0L (List.map (at a x) [I0; I1; I2; I3; I4])) in
    let d x = xor (get (prev x) c) (rot (get (next x) c) 1) in
    let theta = grid (fun x y -> xor (at a x y) (d x)) in
    (* Invert pi: source y = target x, source x = target x + 3*target y. *)
    let times3 = function I0 -> I0 | I1 -> I3 | I2 -> I1 | I3 -> I4 | I4 -> I2 in
    let add x = function
      | I0 -> x | I1 -> next x | I2 -> next (next x)
      | I3 -> prev (prev x) | I4 -> prev x in
    let b = grid (fun x y ->
      let sx = add x (times3 y) in rot (at theta sx x) (at offsets sx x)) in
    let chi = grid (fun x y -> xor (at b x y)
      (Int64.logand (Int64.lognot (at b (next x) y)) (at b (next (next x)) y))) in
    grid (fun x y -> if x = I0 && y = I0 then xor (at chi x y) rc else at chi x y)

  let permute a = List.fold_left round a constants
  let absorb a bytes =
    let step (state, x, y, shift) byte =
      let lane = Int64.shift_left (Int64.of_int byte) shift in
      let state = grid (fun i j ->
        if i = x && j = y then xor (at state i j) lane else at state i j) in
      if shift = 56 then (state, next x, (if x = I4 then next y else y), 0)
      else (state, x, y, shift + 8) in
    let (state, _x, _y, _shift) = List.fold_left step (a, I0, I0, 0) bytes in
    permute state

  (* Consume at most one rate block.  A full final block needs another
     block of padding.  A 135-byte tail combines the suffix and end bit. *)
  let rec take left count acc input =
    if left = 0 then (List.rev acc, count, input)
    else match input () with
      | Seq.Nil -> (List.rev acc, count, Seq.empty)
      | Seq.Cons (c, rest) -> take (left - 1) (count + 1) (Char.code c :: acc) rest
  let suffix = 0x01
  let rec sponge state input =
    let (bytes, count, rest) = take 136 0 [] input in
    if count = 136 then sponge (absorb state bytes) rest
    else
      let padding = List.init (136 - count) (fun i ->
        (if i = 0 then suffix else 0) lor (if i = 135 - count then 0x80 else 0)) in
      absorb state (bytes @ padding)

  let lane_hex lane = List.init 8 (fun i ->
    Printf.sprintf "%02x" (Int64.to_int
      (Int64.logand 0xffL (Int64.shift_right_logical lane (8 * i)))))
    |> String.concat ""
  let keccak256 input =
    let state = sponge zero (String.to_seq input) in
    [I0; I1; I2; I3] |> List.map (fun x -> lane_hex (at state x I0)) |> String.concat ""
  let selector signature =
    keccak256 signature |> String.to_seq |> Seq.take 8 |> String.of_seq
end : sig
  (** Hash arbitrary bytes.  Return 64 lowercase hex digits without a prefix. *)
  val keccak256 : string -> string
  (** Hash a canonical function or error signature.  Return eight hex digits.
      The caller supplies canonical ABI spelling; this function does not parse it. *)
  val selector : string -> string
end)

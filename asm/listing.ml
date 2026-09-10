(* Decode bytes, not the assembly IR, so PC and immediate errors are visible. *)
include (struct
  type row = { pc : int; bytes : string; mnemonic : string; immediate : string }
  type error = Invalid_hex | Unknown_opcode of int * int
             | Truncated_push of int * int * int
  let ( let* ) = Result.bind
  let hex_char c = (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')
  let nibble c = if c <= '9' then Char.code c - Char.code '0'
                 else Char.code c - Char.code 'a' + 10
  let rec take count acc chars =
    if count = 0 then (List.rev acc, chars)
    else match chars with
      | [] -> (List.rev acc, [])
      | c :: rest -> take (count - 1) (c :: acc) rest
  let text chars = String.of_seq (List.to_seq chars)
  let decode hex =
    if String.length hex land 1 <> 0 || not (String.for_all hex_char hex) then Error Invalid_hex
    else
      let rec walk pc acc = function
        | [] -> Ok (List.rev acc)
        | [_last] -> Error Invalid_hex
        | a :: b :: rest ->
          let byte = 16 * nibble a + nibble b in
          let* op = Asm.decode_opcode byte |> Option.to_result ~none:(Unknown_opcode (pc, byte)) in
          let width = if byte >= 0x60 && byte <= 0x7f then byte - 0x5f else 0 in
          let (digits, rest) = take (2 * width) [] rest in
          let got = List.length digits lsr 1 in
          if got <> width then Error (Truncated_push (pc, width, got))
          else let row = { pc; bytes = text (a :: b :: digits);
                           mnemonic = op.name; immediate = text digits } in
            walk (pc + 1 + width) (row :: acc) rest in
      walk 0 [] (List.of_seq (String.to_seq hex))
  let render_row row =
    Printf.sprintf "%08x: %s%s" row.pc row.mnemonic
      (if row.immediate = "" then "" else " 0x" ^ row.immediate)
  let render hex =
    let* rows = decode hex in
    Ok (String.concat "" (List.map (fun row -> render_row row ^ "\n") rows))
  let error_text = function
    | Invalid_hex -> "INVALID-HEX"
    | Unknown_opcode (pc, byte) -> Printf.sprintf "UNKNOWN-OPCODE pc=%d byte=%02x" pc byte
    | Truncated_push (pc, width, got) ->
      Printf.sprintf "TRUNCATED-PUSH pc=%d width=%d got=%d" pc width got
end : sig
  type row = { pc : int; bytes : string; mnemonic : string; immediate : string }
  type error = Invalid_hex | Unknown_opcode of int * int
             | Truncated_push of int * int * int
  (** Strict lowercase, prefix-free hex.  Unknown bytes and incomplete PUSH
      operands return errors, including post-Cancun opcodes.  Empty input is valid. *)
  val decode : string -> (row list, error) result
  (** Eight hex PC digits, mnemonic, optional 0x immediate, one row per line. *)
  val render : string -> (string, error) result
  val error_text : error -> string
end)

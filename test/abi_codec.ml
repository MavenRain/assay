module A = Assay_abi.Abi
module S = A.Schema
module C = A.Codec
let ( let* ) = Result.bind
let hex text = String.concat "" (List.map (fun c -> Printf.sprintf "%02x" (Char.code c))
  (List.of_seq (String.to_seq text)))
let unhex text =
  let digit c = if c >= '0' && c <= '9' then Ok (Char.code c - 48)
    else if c >= 'a' && c <= 'f' then Ok (Char.code c - 87)
    else Error "ADAPTER-HEX" in
  let rec pairs result = function
    | [] -> Ok (String.of_seq (List.to_seq (List.rev result)))
    | [_] -> Error "ADAPTER-HEX"
    | a :: b :: rest -> let* a = digit a in let* b = digit b in
      let bytes = String.to_seq (Z.to_bits (Z.of_int (a * 16 + b))) in
      let c = Option.fold ~none:'\000' ~some:fst (Seq.uncons bytes) in
      pairs (c :: result) rest
  in pairs [] (List.of_seq (String.to_seq text))
let number text =
  let rec digits n = function
    | [] -> Ok n
    | c :: rest -> if c < '0' || c > '9' then Error "ADAPTER-NUMBER"
      else digits (Z.add (Z.mul n (Z.of_int 10)) (Z.of_int (Char.code c - 48))) rest in
  match List.of_seq (String.to_seq text) with
  | [] | ['-'] -> Error "ADAPTER-NUMBER"
  | '-' :: rest -> let* n = digits Z.zero rest in Ok (Z.neg n)
  | c :: rest -> digits Z.zero (c :: rest)
let types text =
  let rec parse result = function
    | [] -> Ok (List.rev result)
    | name :: rest ->
      let* typ = match () with
        | () when name = "uint8" -> Ok S.Uint8
        | () when name = "uint256" -> Ok S.Uint256
        | () when name = "address" -> Ok S.Address
        | () when name = "bool" -> Ok S.Bool
        | () when name = "string" -> Ok S.String
        | () -> Error "ADAPTER-TYPE" in
      parse (typ :: result) rest in
  parse [] (if text = "-" then [] else String.split_on_char ',' text)
let value typ text = match typ with
  | S.Uint8 -> let* n = number text in
    if Z.fits_int n then Ok (C.Uint8 (Z.to_int n)) else Error "ADAPTER-UINT8"
  | S.Uint256 -> let* n = number text in Ok (C.Uint256 n)
  | S.Address -> let* n = number text in Ok (C.Address n)
  | S.Bool -> (match () with
    | () when text = "true" -> Ok (C.Bool true)
    | () when text = "false" -> Ok (C.Bool false)
    | () -> Error "ADAPTER-BOOL")
  | S.String -> let* text = unhex text in Ok (C.String text)
let rec values ts args = match ts, args with
  | [], [] -> Ok []
  | typ :: ts, text :: args -> let* v = value typ text in
    let* rest = values ts args in Ok (v :: rest)
  | [], _ :: _ | _ :: _, [] -> Error "ADAPTER-ARITY"
let error = function
  | C.Out_of_range typ -> "RANGE-" ^ S.type_name typ
  | C.Too_large -> "TOO-LARGE" | C.Truncated -> "TRUNCATED"
  | C.Invalid_bool -> "INVALID-BOOL" | C.Invalid_offset -> "INVALID-OFFSET"
  | C.Nonzero_padding -> "NONZERO-PADDING" | C.Trailing_data -> "TRAILING-DATA"
let show_value = function
  | C.Uint8 n -> string_of_int n | C.Uint256 n | C.Address n -> Z.to_string n
  | C.Bool b -> string_of_bool b | C.String text -> hex text
let output show = Result.fold ~ok:(fun value -> "OK " ^ show value)
  ~error:(fun e -> "ERROR " ^ error e)
let main = function
  | [] | [_] | [_; _] -> Error "ADAPTER-USAGE"
  | _ :: mode :: ts :: args ->
    let* ts = types ts in
    match () with
    | () when mode = "encode" -> let* vs = values ts args in Ok (output hex (C.encode vs))
    | () when mode = "decode" -> (match args with
      | [] | _ :: _ :: _ -> Error "ADAPTER-USAGE"
      | [data] -> let* data = unhex data in
        Ok (output (fun vs -> "[" ^ String.concat "," (List.map
          (fun v -> A.quote (show_value v)) vs) ^ "]") (C.decode ts data)))
    | () -> Error "ADAPTER-USAGE"
let () = Result.fold ~ok:print_endline
  ~error:(fun message -> prerr_endline message; exit 64) (main (Array.to_list Sys.argv))

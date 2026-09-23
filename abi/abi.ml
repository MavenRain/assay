(* The JSON encoder is shared with layout. *)
let quote text =
  let escape c = match () with
    | () when c = '"' -> "\\\""
    | () when c = '\\' -> "\\\\"
    | () when Char.code c < 32 -> Printf.sprintf "\\u%04x" (Char.code c)
    | () -> String.make 1 c
  in "\"" ^ String.concat "" (List.map escape (List.of_seq (String.to_seq text))) ^ "\""

let empty = "[]\n"

(* These rows also drive specialization and selector dispatch. *)
type mutability = View | Nonpayable | Payable
type entry = { name : string; inputs : string list; mutability : mutability }
type custom_error = { error_name : string; arguments : string list }
let mutability_name = function
  | View -> "view" | Nonpayable -> "nonpayable" | Payable -> "payable"

(* Metadata types for the ERC-20 slice. Runtime encoding is separate. *)
module Schema = struct
  type value_type = Uint8 | Uint256 | Address | Bool | String
  type parameter = { name : string; typ : value_type }
  type function_ = {
    name : string; inputs : parameter list; outputs : parameter list;
    mutability : mutability;
  }
  type event_parameter = { parameter : parameter; indexed : bool }
  type declaration =
    | Constructor of parameter list * bool
    | Function of function_
    | Error of string * parameter list
    | Event of string * event_parameter list * bool
    | Fallback of bool

  let type_name = function
    | Uint8 -> "uint8" | Uint256 -> "uint256" | Address -> "address"
    | Bool -> "bool" | String -> "string"
  let signature name parameters = name ^ "(" ^
    String.concat "," (List.map (fun p -> type_name p.typ) parameters) ^ ")"
  let function_signature (fn : function_) = signature fn.name fn.inputs
  let event_signature name inputs =
    signature name (List.map (fun p -> p.parameter) inputs)
  let parameter_fields (p : parameter) =
    "\"name\":" ^ quote p.name ^ ",\"type\":" ^ quote (type_name p.typ)
  let parameter p = "{" ^ parameter_fields p ^ "}"
  let parameters ps = "[" ^ String.concat "," (List.map parameter ps) ^ "]"
  let value_mutability payable = if payable then Payable else Nonpayable
  let print declarations =
    let row = function
      | Constructor (inputs, payable) ->
        "{\"type\":\"constructor\",\"inputs\":" ^ parameters inputs ^
        ",\"stateMutability\":" ^ quote (mutability_name (value_mutability payable)) ^ "}"
      | Function fn -> "{\"type\":\"function\",\"name\":" ^ quote fn.name ^
        ",\"inputs\":" ^ parameters fn.inputs ^ ",\"outputs\":" ^ parameters fn.outputs ^
        ",\"stateMutability\":" ^ quote (mutability_name fn.mutability) ^ "}"
      | Error (name, inputs) -> "{\"type\":\"error\",\"name\":" ^ quote name ^
        ",\"inputs\":" ^ parameters inputs ^ "}"
      | Event (name, inputs, anonymous) ->
        let argument p = "{" ^ parameter_fields p.parameter ^
          ",\"indexed\":" ^ string_of_bool p.indexed ^ "}" in
        "{\"type\":\"event\",\"name\":" ^ quote name ^
        ",\"anonymous\":" ^ string_of_bool anonymous ^ ",\"inputs\":[" ^
        String.concat "," (List.map argument inputs) ^ "]}"
      | Fallback payable -> "{\"type\":\"fallback\",\"stateMutability\":" ^
        quote (mutability_name (value_mutability payable)) ^ "}" in
    "[" ^ String.concat "," (List.map row declarations) ^ "]\n"
end

(* Raw ABI tuples, without a selector. Decode requires the canonical encoding:
   tails in declaration order, no gaps or aliases, zero padding, no suffix. *)
module Codec : sig
  type value = Uint8 of int | Uint256 of Z.t | Address of Z.t
    | Bool of bool | String of string
  type error = Out_of_range of Schema.value_type | Too_large | Truncated
    | Invalid_bool | Invalid_offset | Nonzero_padding | Trailing_data
  val encode : value list -> (string, error) result
  val decode : Schema.value_type list -> string -> (value list, error) result
end = struct
  type value = Uint8 of int | Uint256 of Z.t | Address of Z.t
    | Bool of bool | String of string
  type error = Out_of_range of Schema.value_type | Too_large | Truncated
    | Invalid_bool | Invalid_offset | Nonzero_padding | Trailing_data
  let ( let* ) = Result.bind
  let within bits n = Z.sign n >= 0 && Z.compare n (Z.shift_left Z.one bits) < 0
  let word n =
    let bytes = Z.to_bits n in
    let reversed = String.of_seq (List.to_seq (List.rev (List.of_seq (String.to_seq bytes)))) in
    String.make (32 - String.length bytes) '\000' ^ reversed
  let slice data pos length =
    if pos < 0 || length < 0 || pos > String.length data ||
       length > String.length data - pos then Error Truncated
    else Ok (String.sub data pos length) (* @total-accessor *)
  let read_word data offset =
    let* bytes = slice data offset 32 in
    Ok (String.fold_left (fun n c -> Z.add (Z.shift_left n 8) (Z.of_int (Char.code c))) Z.zero bytes)
  let padding length = (32 - (length land 31)) land 31
  let scalar typ bits n =
    if within bits n then Ok (word n) else Error (Out_of_range typ)
  let encode values =
    let count = List.length values in
    if count > Sys.max_string_length lsr 5 then Error Too_large else
    let rec build offset heads tails = function
      | [] -> Ok (String.concat "" (List.rev heads @ List.rev tails))
      | value :: rest ->
        let append result =
          let* head = result in build offset (head :: heads) tails rest in
        match value with
        | String data ->
          let length = String.length data in
          let pad = padding length in
          let available = Sys.max_string_length - offset in
          if available < 32 || length > available - 32 ||
             pad > available - 32 - length then Error Too_large else
          let tail = word (Z.of_int length) ^ data ^ String.make pad '\000' in
          build (offset + 32 + length + pad)
            (word (Z.of_int offset) :: heads) (tail :: tails) rest
        | Uint8 n -> append (scalar Schema.Uint8 8 (Z.of_int n))
        | Uint256 n -> append (scalar Schema.Uint256 256 n)
        | Address n -> append (scalar Schema.Address 160 n)
        | Bool b -> append (Ok (word (if b then Z.one else Z.zero)))
    in build (count * 32) [] [] values
  let decode types data =
    let size = String.length data in
    let count = List.length types in
    if count > size lsr 5 then Error Truncated else
    let rec read head tail values = function
      | [] -> if tail = size then Ok (List.rev values) else Error Trailing_data
      | typ :: rest ->
        let* n = read_word data head in
        let* value, next = match typ with
          | Schema.Uint8 -> if within 8 n then Ok (Uint8 (Z.to_int n), tail)
            else Error (Out_of_range Schema.Uint8)
          | Schema.Uint256 -> Ok (Uint256 n, tail)
          | Schema.Address -> if within 160 n then Ok (Address n, tail)
            else Error (Out_of_range Schema.Address)
          | Schema.Bool ->
            if Z.equal n Z.zero then Ok (Bool false, tail)
            else if Z.equal n Z.one then Ok (Bool true, tail)
            else Error Invalid_bool
          | Schema.String ->
            if not (Z.equal n (Z.of_int tail)) then Error Invalid_offset
            else if size - tail < 32 then Error Truncated else
            let* length = read_word data tail in
            let available = size - tail - 32 in
            if Z.compare length (Z.of_int available) > 0 then Error Truncated else
            let length = Z.to_int length in
            let pad = padding length in
            if pad > available - length then Error Truncated else
            let start = tail + 32 in
            let* suffix = slice data (start + length) pad in
            if suffix <> String.make pad '\000' then Error Nonzero_padding else
            let* text = slice data start length in
            Ok (String text, start + length + pad)
        in read (head + 32) next (value :: values) rest
    in read 0 (count * 32) [] types
end

let word name : Schema.parameter = { name; typ = Schema.Uint256 }
let accepts_value entry = match entry.mutability with
  | Payable -> true
  | View | Nonpayable -> false
let signature entry = Schema.signature entry.name (List.map word entry.inputs)
let error_signature row = Schema.signature row.error_name (List.map word row.arguments)

let print ?(errors=[]) ?(fallback=false) entries =
  let row entry = Schema.Function { name = entry.name;
    inputs = List.map word entry.inputs; outputs = [word ""]; mutability = entry.mutability } in
  let error row = Schema.Error (row.error_name, List.map word row.arguments) in
  let fallback = if fallback then [Schema.Fallback false] else [] in
  Schema.print (Schema.Constructor ([], false) ::
    List.map row entries @ List.map error errors @ fallback)

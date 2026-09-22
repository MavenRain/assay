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

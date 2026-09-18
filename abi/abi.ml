(* M0 has an empty ABI. The JSON encoder is shared with layout. *)
let quote text =
  let escape c = match () with
    | () when c = '"' -> "\\\""
    | () when c = '\\' -> "\\\\"
    | () when Char.code c < 32 -> Printf.sprintf "\\u%04x" (Char.code c)
    | () -> String.make 1 c
  in "\"" ^ String.concat "" (List.map escape (List.of_seq (String.to_seq text))) ^ "\""

let empty = "[]\n"

(* These rows also drive specialization and selector dispatch. *)
type entry = { name : string; inputs : string list; readonly : bool }
type custom_error = { error_name : string; arguments : string list }
let signature entry = entry.name ^ "(" ^
  String.concat "," (List.map (fun _name -> "uint256") entry.inputs) ^ ")"
let error_signature row = row.error_name ^ "(" ^
  String.concat "," (List.map (fun _name -> "uint256") row.arguments) ^ ")"

let print ?(errors=[]) ?(fallback=false) entries =
  let argument name = "{\"name\":" ^ quote name ^ ",\"type\":\"uint256\"}" in
  let row entry = "{\"type\":\"function\",\"name\":" ^ quote entry.name ^
    ",\"inputs\":[" ^ String.concat "," (List.map argument entry.inputs) ^
    "],\"outputs\":[" ^ argument "" ^ "],\"stateMutability\":" ^
    quote (if entry.readonly then "view" else "nonpayable") ^ "}" in
  let constructor = "{\"type\":\"constructor\",\"inputs\":[],\"stateMutability\":\"nonpayable\"}" in
  let error row = "{\"type\":\"error\",\"name\":" ^ quote row.error_name ^
    ",\"inputs\":[" ^ String.concat "," (List.map argument row.arguments) ^ "]}" in
  let fallback = if fallback then ["{\"type\":\"fallback\",\"stateMutability\":\"nonpayable\"}"] else [] in
  "[" ^ String.concat "," (constructor :: List.map row entries @ List.map error errors @ fallback) ^ "]\n"

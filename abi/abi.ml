(* M0 has no entry dispatcher.  The JSON encoder is shared with layout. *)
let quote text =
  let escape c = match () with
    | () when c = '"' -> "\\\""
    | () when c = '\\' -> "\\\\"
    | () when Char.code c < 32 -> Printf.sprintf "\\u%04x" (Char.code c)
    | () -> String.make 1 c
  in "\"" ^ String.concat "" (List.map escape (List.of_seq (String.to_seq text))) ^ "\""

let empty = "[]\n"

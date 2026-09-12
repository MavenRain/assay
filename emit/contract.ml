(* Contract sugar over the checked M1 protocol. No source token is copied
   into core code before its spelling, scope and role have been validated. *)
open Kanon_kernel

let ( let* ) = Result.bind
type token = { text : string; line : int; col : int }
type word = Literal of token | Local of token
type step =
  | Load of token * token
  | Add of token * word * word
  | Sub of token * word * word
  | Store of token * word
  | Guard of word * word
  | Bind of token * word
type ending = Return of word | Unit of token | Revert of token
type body = step list * ending
type entry = { name : token; args : token list; body : body }

let fail at code detail =
  Error (Error.Parse ("SURFACE_" ^ code ^ ": " ^ detail, at.line, at.col))
let here = function at :: _rest -> at | [] -> { text = ""; line = 1; col = 1 }
let letter c = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c = '_'
let digit c = c >= '0' && c <= '9'
let word_char c = letter c || digit c
let rec span predicate acc = function
  | c :: rest when predicate c -> span predicate (c :: acc) rest
  | [] -> String.of_seq (List.to_seq (List.rev acc)), []
  | c :: rest -> String.of_seq (List.to_seq (List.rev acc)), c :: rest
let rec comment col = function
  | [] -> col, []
  | '\n' :: _rest as chars -> col, chars
  | _c :: rest -> comment (col + 1) rest
let rec space line col = function
  | (' ' | '\t' | '\r') :: rest -> space line (col + 1) rest
  | '\n' :: rest -> space (line + 1) 1 rest
  | '-' :: '-' :: rest ->
    let col, rest = comment (col + 2) rest in space line col rest
  | [] -> line, col, []
  | c :: rest -> line, col, c :: rest

let lex chars =
  let rec scan count line col acc chars =
    let line, col, chars = space line col chars in
    let at text = { text; line; col } in
    if count > 8192 then fail (at "") "LIMIT" "at most 8192 tokens" else
    let next text rest = scan (count + 1) line (col + String.length text) (at text :: acc) rest in
    match chars with
    | [] -> Ok (List.rev (at "" :: acc))
    | c :: rest when word_char c ->
      let text, rest = span word_char [c] rest in next text rest
    | ':' :: '=' :: rest -> next ":=" rest
    | '<' :: '-' :: rest -> next "<-" rest
    | ('(' | ')' | '{' | '}' | ':' | ';' as c) :: rest -> next (String.make 1 c) rest
    | _c :: _rest -> fail (at "") "TOKEN" "unexpected character" in
  scan 0 1 1 [] chars

let reserved = String.split_on_char ' '
  "contract where storage entry constructor do sload sstore add sub guard le let pure revert Word Eff Sig Tx ResultWord Storage Entry main word ret put read EvmOpcodes done store load abort def axiom fun inj of case match as return with tuple sum prod absurd Prop Type in auto mu mutual end nu and rec natAdd natSub natMul natEq natLt"
let identifier tokens = match tokens with
  | at :: rest when Recognize.identifier at.text && at.text <> "_" &&
      String.length at.text <= 64 && not (List.mem at.text reserved) &&
      not (String.starts_with ~prefix:"_assay" at.text) -> Ok (at, rest)
  | [] | _ :: _ -> fail (here tokens) "NAME" "expected an unreserved identifier of at most 64 characters"
let expect text tokens = match tokens with
  | at :: rest when at.text = text -> Ok rest
  | [] | _ :: _ -> fail (here tokens) "SYNTAX" ("expected " ^ text)
let rec sequence words tokens = match words with
  | [] -> Ok tokens
  | text :: rest -> let* tokens = expect text tokens in sequence rest tokens

let literal at =
  if String.length at.text > 78 then fail at "WORD" "expected a decimal uint256" else
  let* n = Bignum.of_decimal at.text
    |> Option.to_result ~none:(Error.Parse ("SURFACE_WORD: expected a decimal uint256", at.line, at.col)) in
  if Bignum.compare n (Z.shift_left Z.one 256) < 0 then Ok (Literal at)
  else fail at "WORD" "expected a decimal uint256"
let rec value depth tokens =
  if depth > 128 then fail (here tokens) "LIMIT" "value nesting exceeds 128" else
  match tokens with
  | { text = "("; _ } :: rest ->
    let* word, rest = value (depth + 1) rest in
    let* rest = expect ")" rest in Ok (word, rest)
  | { text = "word"; _ } :: at :: rest ->
    let* word = literal at in Ok (word, rest)
  | [] | _ :: _ -> let* name, rest = identifier tokens in Ok (Local name, rest)
let binary tokens =
  let* a, rest = value 0 tokens in
  let* b, rest = value 0 rest in Ok ((a, b), rest)

let body tokens =
  let* tokens = expect "do" tokens in
  let rec steps count acc tokens =
    if count > 128 then fail (here tokens) "LIMIT" "at most 128 effect steps" else
    let next step rest =
      let* rest = expect ";" rest in steps (count + 1) (step :: acc) rest in
    match tokens with
    | { text = "pure"; _ } :: ({ text = "("; _ } as at) :: { text = ")"; _ } :: rest ->
      Ok ((List.rev acc, Unit at), rest)
    | { text = "pure"; _ } :: rest ->
      let* word, rest = value 0 rest in Ok ((List.rev acc, Return word), rest)
    | ({ text = "revert"; _ } as at) :: rest -> Ok ((List.rev acc, Revert at), rest)
    | { text = "sstore"; _ } :: rest ->
      let* slot, rest = identifier rest in
      let* word, rest = value 0 rest in next (Store (slot, word)) rest
    | { text = "guard"; _ } :: rest ->
      let* rest = expect "le" rest in
      let* (a, b), rest = binary rest in next (Guard (a, b)) rest
    | { text = "let"; _ } :: rest ->
      let* name, rest = identifier rest in
      let* rest = sequence [":"; "Word"; ":="] rest in
      let* word, rest = value 0 rest in next (Bind (name, word)) rest
    | [] | _ :: _ ->
      let* name, rest = identifier tokens in
      let* rest = expect "<-" rest in
      (match rest with
       | { text = "sload"; _ } :: rest ->
         let* slot, rest = identifier rest in next (Load (name, slot)) rest
       | { text = "add"; _ } :: rest ->
         let* (a, b), rest = binary rest in next (Add (name, a, b)) rest
       | { text = "sub"; _ } :: rest ->
         let* (a, b), rest = binary rest in next (Sub (name, a, b)) rest
       | [] | _ :: _ -> fail (here rest) "EFFECT" "expected sload, add or sub") in
  steps 0 [] tokens

let named_word tokens =
  let* name, rest = identifier tokens in
  let* rest = sequence [":"; "Word"] rest in Ok (name, rest)
let add_name name names =
  if List.exists (fun prior -> prior.text = name.text) names
  then fail name "DUPLICATE" ("duplicate name " ^ name.text)
  else if List.length names >= 32 then fail name "LIMIT" "at most 32 members"
  else Ok (name :: names)
let fields tokens =
  let rec more acc tokens =
    let* name, rest = named_word tokens in
    let* acc = add_name name acc in
    match rest with
    | { text = "}"; _ } :: rest -> Ok (List.rev acc, rest)
    | { text = ";"; _ } :: { text = "}"; _ } :: rest -> Ok (List.rev acc, rest)
    | { text = ";"; _ } :: rest -> more acc rest
    | [] | _ :: _ -> fail (here rest) "SYNTAX" "expected ; or }" in
  let* tokens = expect "{" tokens in more [] tokens
let arguments tokens =
  let rec more acc tokens =
    let* tokens = expect "(" tokens in
    match tokens with
    | { text = ")"; _ } :: rest when acc = [] -> Ok ([], rest)
    | [] | _ :: _ ->
      let* name, rest = named_word tokens in
      let* acc = add_name name acc in
      let* rest = expect ")" rest in
      (match rest with
       | { text = "("; _ } :: _rest -> more acc rest
       | [] | _ :: _ -> Ok (List.rev acc, rest)) in
  more [] tokens

let slot fields name =
  List.assoc_opt name.text fields
  |> Option.to_result ~none:(Error.Parse ("SURFACE_SLOT: unknown field " ^ name.text, name.line, name.col))
let word env = function
  | Literal at -> Ok ("(word 256 " ^ at.text ^ ")")
  | Local at ->
    List.assoc_opt at.text env
    |> Option.to_result ~none:(Error.Parse ("SURFACE_SCOPE: unbound word " ^ at.text, at.line, at.col))
let app name args = "(" ^ name ^ " " ^ String.concat " " args ^ ")"
let lambda name ty term = "(fun (" ^ name ^ " : " ^ ty ^ ") => " ^ term ^ ")"
let transaction fields env (steps, ending) =
  let rec lower index env = function
    | [] -> (match ending with
      | Return v -> let* v = word env v in Ok (app "done" [v])
      | Revert _at -> Ok "abort"
      | Unit at -> fail at "RETURN" "an entry must return Word")
    | step :: rest ->
      let fresh = "_assay_v" ^ string_of_int index in
      let bind name = lower (index + 1) ((name.text, fresh) :: env) rest in
      let arithmetic op name a b =
        let* a = word env a in let* b = word env b in
        let* next = bind name in
        Ok (app op [a; b; lambda "_assay_result" "ResultWord"
          ("case _assay_result with | 0 (" ^ fresh ^ " : Word 256) => " ^ next ^
           " | 1 (_assay_error : prod ()) => abort")]) in
      match step with
      | Load (name, field) ->
        let* field = slot fields field in let* next = bind name in
        Ok (app "load" [field; lambda fresh "Word 256" next])
      | Add (name, a, b) -> arithmetic "add" name a b
      | Sub (name, a, b) -> arithmetic "sub" name a b
      | Bind (name, v) ->
        let* v = word env v in let* next = bind name in
        Ok ("(let " ^ fresh ^ " : Word 256 := " ^ v ^ " in " ^ next ^ ")")
      | Store (field, v) ->
        let* field = slot fields field in let* v = word env v in
        let* next = lower index env rest in Ok (app "store" [field; v; next])
      | Guard (a, b) ->
        let* a = word env a in let* b = word env b in
        let* next = lower index env rest in Ok (app "le" [a; b; next; "abort"]) in
  lower 0 env steps

let constructor fields (steps, ending) =
  let* () = match ending with
    | Unit _ -> Ok ()
    | Return (Literal at | Local at) | Revert at ->
      fail at "CONSTRUCTOR" "constructor must end in pure ()" in
  List.fold_right (fun step result ->
    let* next = result in
    match step with
    | Store (field, Literal at) ->
      let* field = slot fields field in let* v = word [] (Literal at) in
      Ok (app "put" [field; v; next])
    | Store (at, Local _) | Load (at, _) | Add (at, _, _) | Sub (at, _, _) | Bind (at, _) ->
      fail at "CONSTRUCTOR" "constructor accepts literal stores only"
    | Guard ((Literal at | Local at), _) ->
      fail at "CONSTRUCTOR" "constructor accepts literal stores only")
    steps (Ok "(ret (word 256 0))")

let generate state fields entries init =
  let aliases = List.sort_uniq String.compare
    (List.map (fun at -> at.text) (fields @ List.concat_map (fun row -> row.args) entries)) in
  let names = state :: List.map (fun row -> row.name) entries in
  let* _names = List.fold_left (fun result name ->
    let* seen = result in
    if List.mem name.text (aliases @ seen) then fail name "DUPLICATE" ("conflicting global " ^ name.text)
    else Ok (name.text :: seen)) (Ok []) names in
  let field_slots = List.mapi (fun i at -> at.text, "storage." ^ string_of_int i) fields in
  let* init = Option.fold ~none:(Ok "(ret (word 256 0))") ~some:(constructor field_slots) init in
  let* branches = List.fold_left (fun result (i, row) ->
    let* branches = result in
    let env = List.mapi (fun i at -> at.text, "_assay_args." ^ string_of_int i) row.args in
    let* term = transaction field_slots env row.body in
    Ok (branches @ ["| " ^ string_of_int i ^ " (_assay_args : " ^ row.name.text ^ ") => " ^ term]))
    (Ok []) (List.mapi (fun i row -> i, row) entries) in
  let decl = Recognize.declaration in
  let collection former ats = Recognize.collection_source former (List.map (fun at -> at.text) ats) in
  Ok (Recognize.m1_protocol ^
    String.concat "" (List.map (fun name -> decl name "Word 256") aliases) ^
    decl "Storage" (collection "prod" fields) ^ decl state.text "Storage" ^
    "def storage : Storage := tuple (" ^ String.concat ", "
      (List.mapi (fun i _at -> "word 256 " ^ string_of_int i) fields) ^ ")\n" ^
    String.concat "" (List.map (fun row -> decl row.name.text (collection "prod" row.args)) entries) ^
    decl "Entry" (collection "sum" (List.map (fun row -> row.name) entries)) ^
    "def constructor : Eff := " ^ init ^ "\n" ^
    "def main : Entry -> Tx := fun (_assay_entry : Entry) => case _assay_entry with\n" ^
    String.concat "\n" branches ^ "\n")

let parse tokens =
  let* tokens = expect "contract" tokens in
  let* name, tokens = identifier tokens in
  let* tokens = sequence ["where"; "storage"] tokens in
  let* state, tokens = identifier tokens in
  let* tokens = expect ":=" tokens in
  let* fields, tokens = fields tokens in
  let rec declarations entries init tokens = match tokens with
    | { text = "entry"; _ } :: rest ->
      let* name, rest = identifier rest in
      let* _names = add_name name (List.map (fun row -> row.name) entries) in
      let* args, rest = arguments rest in
      let* rest = sequence [":"; "Eff"; "Sig"; "Word"; ":="] rest in
      let* body, rest = body rest in declarations (entries @ [{ name; args; body }]) init rest
    | ({ text = "constructor"; _ } as at) :: rest ->
      if Option.is_some init then fail at "DUPLICATE" "duplicate constructor" else
      let* rest = expect ":=" rest in
      let* init, rest = body rest in declarations entries (Some init) rest
    | [{ text = ""; _ }] ->
      if entries = [] then fail name "ENTRY" "at least one entry is required"
      else if List.for_all (fun row -> row.args = []) entries then
        fail name "ENTRY" "the carried erasure requires at least one entry with a Word argument"
      else let* core = generate state fields entries init in Ok (Some name.text, core)
    | [] | _ :: _ -> fail (here tokens) "DECLARATION" "expected entry, constructor or end of input" in
  declarations [] None tokens

(* The route is decided on the byte sequence, so a core file never pays a list cell per byte. *)
let rec skip_comment seq = match seq () with
  | Seq.Nil -> seq
  | Seq.Cons ('\n', _rest) -> seq
  | Seq.Cons (_c, rest) -> skip_comment rest
let rec skip_space seq = match seq () with
  | Seq.Nil -> seq
  | Seq.Cons ((' ' | '\t' | '\r' | '\n'), rest) -> skip_space rest
  | Seq.Cons ('-', rest) -> skip_dashes seq rest
  | Seq.Cons (_c, _rest) -> seq
and skip_dashes seq rest = match rest () with
  | Seq.Cons ('-', tail) -> skip_space (skip_comment tail)
  | Seq.Nil -> seq
  | Seq.Cons (_c, _rest) -> seq

let rec keyword expected seq = match expected, seq () with
  | [], Seq.Nil -> true
  | [], Seq.Cons (c, _rest) -> not (word_char c)
  | want :: rest, Seq.Cons (c, tail) -> c = want && keyword rest tail
  | _ :: _, Seq.Nil -> false

let lower source =
  let contract = keyword ['c'; 'o'; 'n'; 't'; 'r'; 'a'; 'c'; 't'] (skip_space (String.to_seq source)) in
  if not contract then Ok (None, source)
  else if String.length source > 65536 then fail (here []) "LIMIT" "contract source exceeds 65536 bytes"
  else let* tokens = lex (List.of_seq (String.to_seq source)) in parse tokens

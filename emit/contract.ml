(* Contract sugar over the checked M1 protocol. No source token is copied
   into core code before its spelling, scope and role have been validated. *)
open Kanon_kernel

let ( let* ) = Result.bind
type token = { text : string; line : int; col : int }
type word = Literal of token | Local of token
type predicate = Ordered of word * word | Fits of word * word
type proof =
  | Proof_unit
  | Proof_name of token
  | Proof_word of word
  | Proof_call of token * proof list
  | Proof_ann of proof * predicate
  | Proof_let of token * predicate * proof * proof
type parameter = Word_parameter of token | Proof_parameter of token * predicate
type helper = { helper_name : token; parameters : parameter list; conclusion : predicate; proof_body : proof }
type binding = Word_value of string | Proof_value of string
type step =
  | Load of token * token
  | Add of token * word * word
  | Sub of token * word * word
  | Store of token * word
  | Guard of word * word
  | Bind of token * word
  | Prove of token * predicate * (token * word list) option * predicate
  | Proven of token * token * word * word * proof
  | Proof_bind of token * predicate * proof
type ending = Return of word | Unit of token | Revert of token | Reject of token * word list
type body = step list * ending
type entry = { name : token; args : token list; body : body }
type error_row = { error_name : token; error_args : token list }
type invariant = { invariant_name : token; claim : predicate }

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
    | ('(' | ')' | '{' | '}' | ':' | ';' | '.' | ',' as c) :: rest -> next (String.make 1 c) rest
    | _c :: _rest -> fail (at "") "TOKEN" "unexpected character" in
  scan 0 1 1 [] chars

let reserved = String.split_on_char ' '
  "contract where storage entry constructor error invariant proof do sload sstore add sub guard le let pure revert Word Eff Sig Tx ResultWord Storage Entry Error main word ret put read EvmOpcodes done store load abort reject def axiom fun inj of case match as return with tuple sum prod absurd Prop Type in auto mu mutual end nu and rec natAdd natSub natMul natEq natLt Le Lt256 AddFits leWord lt256 wordNat guardLe guardAdd addLt subLe"
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
let opens_value tokens = match tokens with
  | { text = "("; _ } :: _rest -> true
  | [] | _ :: _ -> false
let opens_condition tokens = match tokens with
  | { text = "("; _ } :: at :: _rest -> at.text = "leWord" || at.text = "lt256"
  | [] | _ :: _ -> false
(* Review round 2026-09-12 (B-1):  `()` is the empty payload only when it is the
   whole payload.  A `()` beside values, in any position, is the same wrong
   argument count refusal that a plain count mismatch raises. *)
let error_values tokens =
  let rec more acc tokens = match tokens with
    | { text = "("; _ } :: { text = ")"; _ } :: rest ->
      if acc = [] && not (opens_value rest) then Ok ([], rest)
      else fail (here tokens) "ERROR" "wrong error argument count"
    | { text = "("; _ } :: _rest ->
      if List.length acc >= 32 then fail (here tokens) "LIMIT" "at most 32 error arguments" else
      let* v, rest = value 0 tokens in more (v :: acc) rest
    | [] | _ :: _ -> Ok (List.rev acc, tokens) in
  more [] tokens

let bound operand runtime tokens =
  let binary tokens = let* a, rest = operand tokens in
    let* b, rest = operand rest in Ok ((a, b), rest) in
  match tokens with
  | at :: rest when at.text = (if runtime then "leWord" else "Le") ->
    let* (a, b), rest = binary rest in Ok (Ordered (a, b), rest)
  | at :: rest when at.text = (if runtime then "lt256" else "Lt256") ->
    let* rest = sequence ["("; "add"] rest in
    let* (a, b), rest = binary rest in
    let* rest = expect ")" rest in Ok (Fits (a, b), rest)
  | [] | _ :: _ -> fail (here tokens) "PROOF" "expected an ordering or addition bound"
let predicate runtime tokens = bound (value 0) runtime tokens
let proof_binder tokens =
  let* rest = sequence ["("; "0"] tokens in
  let* name, rest = identifier rest in let* rest = expect ":" rest in
  let* claim, rest = predicate false rest in
  let* rest = expect ")" rest in Ok ((name, claim), rest)
let rec proof_term depth tokens =
  if depth > 128 then fail (here tokens) "LIMIT" "proof nesting exceeds 128" else
  match tokens with
  | { text = "("; _ } :: { text = ")"; _ } :: rest -> Ok (Proof_unit, rest)
  | { text = "("; _ } :: rest ->
    let* term, rest = proof_term (depth + 1) rest in
    let* term, rest = match rest with
      | { text = ":"; _ } :: rest ->
        let* claim, rest = predicate false rest in Ok (Proof_ann (term, claim), rest)
      | [] | _ :: _ -> Ok (term, rest) in
    let* rest = expect ")" rest in Ok (term, rest)
  | { text = "let"; _ } :: rest ->
    let* (name, claim), rest = proof_binder rest in
    let* rest = expect ":=" rest in
    let* value, rest = proof_term (depth + 1) rest in
    let* rest = expect "in" rest in
    let* body, rest = proof_term (depth + 1) rest in
    Ok (Proof_let (name, claim, value, body), rest)
  | { text = "word"; _ } :: _ ->
    let* v, rest = value 0 tokens in Ok (Proof_word v, rest)
  | [] | _ :: _ ->
    let* name, rest = identifier tokens in
    (match rest with
     | { text = "("; _ } :: rest ->
       let rec arguments acc tokens =
         if List.length acc >= 16 then fail (here tokens) "LIMIT" "at most 16 proof helper arguments" else
         let* arg, rest = proof_term (depth + 1) tokens in
         match rest with
         | { text = ","; _ } :: rest ->
           (match rest with
            | { text = ")"; _ } :: _ | { text = ","; _ } :: _ ->
              fail (here rest) "SYNTAX" "expected a proof helper argument after ,"
            | [] | _ :: _ -> arguments (acc @ [arg]) rest)
         | [] | _ :: _ -> let* rest = expect ")" rest in Ok (Proof_call (name, acc @ [arg]), rest) in
       (match rest with
        | { text = ")"; _ } :: rest -> Ok (Proof_call (name, []), rest)
        | { text = ","; _ } :: _ ->
          fail (here rest) "SYNTAX" "expected a proof helper argument before ,"
        | [] | _ :: _ -> arguments [] rest)
     | [] | _ :: _ -> Ok (Proof_name name, rest))
let proof_guard tokens =
  let* (name, claim), rest = proof_binder tokens in
  let* rest = sequence ["<-"; "guard"] rest in
  let* error, rest = match rest with
    | { text = "("; _ } :: _tail -> Ok (None, rest)
    | [] | _ :: _ ->
      let* name, rest = identifier rest in
      let rec args acc rest = match rest with
        | { text = "("; _ } :: at :: _tail when at.text = "leWord" || at.text = "lt256" ->
          Ok (Some (name, List.rev acc), rest)
        (* Review round 2026-09-13 (A-1):  a guard payload carries the same rule
           as an ending payload.  `()` is the empty payload only when the runtime
           condition follows it, so a `()` beside a value, in either position, is
           the wrong argument count refusal. *)
        | { text = "("; _ } :: { text = ")"; _ } :: tail when acc = [] ->
          if opens_value tail && not (opens_condition tail)
          then fail (here rest) "ERROR" "wrong error argument count"
          else Ok (Some (name, []), tail)
        | { text = "("; _ } :: { text = ")"; _ } :: _tail ->
          fail (here rest) "ERROR" "wrong error argument count"
        | [] | _ :: _ ->
          if List.length acc >= 32 then fail (here rest) "LIMIT" "at most 32 error arguments" else
          let* rest = expect "(" rest in let* v, rest = value 0 rest in
          let* rest = expect ")" rest in args (v :: acc) rest in
      args [] rest in
  let* rest = expect "(" rest in let* condition, rest = predicate true rest in
  let* rest = expect ")" rest in Ok (Prove (name, claim, error, condition), rest)

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
    | ({ text = "revert"; _ } as at) :: rest ->
      (match rest with
       | name :: _tail when Recognize.identifier name.text && not (List.mem name.text reserved) ->
         let* name, rest = identifier rest in
         let* args, rest = error_values rest in Ok ((List.rev acc, Reject (name, args)), rest)
       | [] | _ :: _ -> Ok ((List.rev acc, Revert at), rest))
    | { text = "sstore"; _ } :: rest ->
      let* slot, rest = identifier rest in
      let* word, rest = value 0 rest in next (Store (slot, word)) rest
    | { text = "guard"; _ } :: rest ->
      let* rest = expect "le" rest in
      let* (a, b), rest = binary rest in next (Guard (a, b)) rest
    | { text = "let"; _ } :: ({ text = "("; _ } :: _tail as rest) ->
      let* (name, claim), rest = proof_binder rest in
      let* rest = expect ":=" rest in
      let* proof, rest = proof_term 0 rest in next (Proof_bind (name, claim, proof)) rest
    | { text = "let"; _ } :: rest ->
      let* name, rest = identifier rest in
      let* rest = sequence [":"; "Word"; ":="] rest in
      (match rest with
       | op :: rest when op.text = "addLt" || op.text = "subLe" ->
         let* (a, b), rest = binary rest in let* proof, rest = proof_term 0 rest in
         next (Proven (op, name, a, b, proof)) rest
       | [] | _ :: _ -> let* word, rest = value 0 rest in next (Bind (name, word)) rest)
    | { text = "("; _ } :: _rest ->
      let* proof, rest = proof_guard tokens in next proof rest
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

let helper tokens =
  let* helper_name, rest = identifier tokens in
  let rec parameters names acc tokens = match tokens with
    | { text = "("; _ } :: rest ->
      if List.length acc >= 16 then fail (here tokens) "LIMIT" "at most 16 proof helper parameters" else
      let* rest = expect "0" rest in let* name, rest = identifier rest in
      let* names = add_name name names in let* rest = expect ":" rest in
      let* parameter, rest = match rest with
        | { text = "Word"; _ } :: rest -> Ok (Word_parameter name, rest)
        | [] | _ :: _ -> let* claim, rest = predicate false rest in Ok (Proof_parameter (name, claim), rest) in
      let* rest = expect ")" rest in parameters names (acc @ [parameter]) rest
    | [] | _ :: _ -> Ok (acc, tokens) in
  let* parameters, rest = parameters [] [] rest in
  let* rest = expect ":" rest in let* conclusion, rest = predicate false rest in
  let* rest = expect ":=" rest in let* proof_body, rest = proof_term 0 rest in
  Ok ({ helper_name; parameters; conclusion; proof_body }, rest)

let invariant state fields tokens =
  let* invariant_name, rest = identifier tokens in
  let* rest = expect "(" rest in let* snapshot, rest = identifier rest in
  let* rest = sequence [":"; state.text; ")"; ":"; "Prop"; ":="] rest in
  let rec operand depth tokens =
    if depth > 128 then fail (here tokens) "LIMIT" "invariant nesting exceeds 128" else
    match tokens with
    | { text = "("; _ } :: rest ->
      let* v, rest = operand (depth + 1) rest in let* rest = expect ")" rest in Ok (v, rest)
    | { text = "word"; _ } :: at :: rest -> let* v = literal at in Ok (v, rest)
    | at :: { text = "."; _ } :: rest when at.text = snapshot.text ->
      let* field, rest = identifier rest in
      if List.exists (fun at -> at.text = field.text) fields then Ok (Local field, rest)
      else fail field "SLOT" ("unknown invariant field " ^ field.text)
    | [] | _ :: _ -> fail (here tokens) "INVARIANT" "expected a snapshot field or literal" in
  let* claim, rest = bound (operand 0) false rest in Ok ({ invariant_name; claim }, rest)

let slot fields name =
  List.assoc_opt name.text fields
  |> Option.to_result ~none:(Error.Parse ("SURFACE_SLOT: unknown field " ^ name.text, name.line, name.col))
let word env = function
  | Literal at -> Ok ("(word 256 " ^ at.text ^ ")")
  | Local at ->
    let* binding = List.assoc_opt at.text env
      |> Option.to_result ~none:(Error.Parse ("SURFACE_SCOPE: unbound word " ^ at.text, at.line, at.col)) in
    (match binding with Word_value v -> Ok v | Proof_value _ -> fail at "PROOF" "an erased proof is not a Word")
let app name args = "(" ^ name ^ " " ^ String.concat " " args ^ ")"
let lambda name ty term = "(fun (" ^ name ^ " : " ^ ty ^ ") => " ^ term ^ ")"
let erased_apply name ty result value body =
  app ("(" ^ lambda ("0 " ^ name) ty body ^ " : (0 " ^ name ^ " : " ^ ty ^ ") -> " ^ result ^ ")") [value]
let resolved_predicate env condition =
  let a, b, ty, op = match condition with
    | Ordered (a, b) -> a, b, "Le", "guardLe"
    | Fits (a, b) -> a, b, "AddFits", "guardAdd" in
  let* a = word env a in let* b = word env b in Ok (app ty [a; b], op, a, b)
(* Annotations preserve obligations even for unused erased arguments and
   declarations. Only kernel erasure may discard their checked terms. *)
let rec proof ?(erased=true) helpers depth env expected term =
  let* term = match term with
    | Proof_unit -> Ok "(tuple ())"
    | Proof_word (Literal at | Local at) -> fail at "PROOF" "a Word is not an erased proof"
    | Proof_name at ->
      let refusal = fail at "PROOF" "expected an in-scope erased proof" in
      Option.fold ~none:refusal ~some:(function
        | Proof_value p -> Ok p | Word_value _ -> refusal) (List.assoc_opt at.text env)
    | Proof_ann (term, claim) ->
      let* ty, _op, _a, _b = resolved_predicate env claim in proof ~erased helpers (depth + 1) env ty term
    | Proof_let (name, claim, value, body) ->
      let* ty, _op, _a, _b = resolved_predicate env claim in
      let* value = proof ~erased helpers (depth + 1) env ty value in
      let fresh = "_assay_p" ^ string_of_int depth in
      let* body = proof ~erased helpers (depth + 1) ((name.text, Proof_value fresh) :: env) expected body in
      Ok (if erased then erased_apply fresh ty expected value body else
        app ("(" ^ lambda fresh ty body ^ " : (" ^ fresh ^ " : " ^ ty ^ ") -> " ^ expected ^ ")") [value])
    | Proof_call (at, args) ->
      let* core_name, row = List.assoc_opt at.text helpers
        |> Option.to_result ~none:(Error.Parse ("SURFACE_PROOF: unknown or forward proof helper " ^ at.text, at.line, at.col)) in
      if List.mem_assoc at.text env then fail at "PROOF" "a local binding shadows this proof helper" else
      let rec arguments substitution values parameters args = match parameters, args with
        | [], [] -> Ok (List.rev values)
        | Word_parameter name :: parameters, arg :: args ->
          let* v = match arg with
            | Proof_word v -> word env v
            | Proof_name at -> word env (Local at)
            | Proof_unit | Proof_call _ | Proof_ann _ | Proof_let _ -> fail at "PROOF" "expected a Word helper argument" in
          arguments ((name.text, Word_value v) :: substitution) (v :: values) parameters args
        | Proof_parameter (_name, claim) :: parameters, arg :: args ->
          let* ty, _op, _a, _b = resolved_predicate substitution claim in
          let* v = proof ~erased helpers (depth + 1) env ty arg in
          arguments substitution (v :: values) parameters args
        | [], _ :: _ | _ :: _, [] -> fail at "PROOF" "wrong proof helper argument count" in
      let* args = arguments [] [] row.parameters args in
      Ok (if args = [] then core_name else app core_name args) in
  Ok ("(" ^ term ^ " : " ^ expected ^ ")")

let helpers_source rows =
  let rec lower index helpers source = function
    | [] -> Ok (helpers, String.concat "" (List.rev source))
    | row :: rest ->
      let rec parameters index env = function
        | [] ->
          let* ty, _op, _a, _b = resolved_predicate env row.conclusion in
          let* term = proof ~erased:false helpers 0 env ty row.proof_body in Ok (ty, term)
        | parameter :: rest ->
          let fresh = "_assay_harg" ^ string_of_int index in
          let* name, ty, binding = match parameter with
            | Word_parameter name -> Ok (name, "Word 256", Word_value fresh)
            | Proof_parameter (name, claim) ->
              let* ty, _op, _a, _b = resolved_predicate env claim in Ok (name, ty, Proof_value fresh) in
          let* result, term = parameters (index + 1) ((name.text, binding) :: env) rest in
          (* Top-level core definitions check in runtime mode. These pure
             functions have ordinary core parameters, and the surface only
             permits their applications inside erased proof positions. *)
          Ok ("(" ^ fresh ^ " : " ^ ty ^ ") -> " ^ result, lambda fresh ty term) in
      let* ty, term = parameters 0 [] row.parameters in
      let name = "_assay_helper" ^ string_of_int index in
      let declaration = "def " ^ name ^ " : " ^ ty ^ " := " ^ term ^ "\n" in
      lower (index + 1) ((row.helper_name.text, (name, row)) :: helpers) (declaration :: source) rest in
  lower 0 [] [] rows

let invariant_fields row =
  let a, b = match row.claim with Ordered (a, b) | Fits (a, b) -> a, b in
  List.filter_map (function Literal _ -> None | Local at -> Some at.text) [a; b]
let obligations invariants state evidence result next =
  List.fold_right (fun row result_body ->
    let* body = result_body in
    let* () = List.fold_left (fun result field -> let* () = result in
      if List.mem_assoc field state then Ok () else
      fail row.invariant_name "INVARIANT" ("load or store field " ^ field ^ " before proving the final state"))
      (Ok ()) (invariant_fields row) in
    let* ty, _op, _a, _b = resolved_predicate state row.claim in
    let proof = Option.value (List.assoc_opt ty evidence) ~default:"(tuple ())" in
    Ok (erased_apply ("_assay_inv_" ^ row.invariant_name.text) ty result proof body)) invariants (Ok next)
let transaction fields errors invariants helpers env (steps, ending) =
  let reject env (name, args) =
    let* index, row = List.find_opt (fun (_i, row) -> row.error_name.text = name.text)
      (List.mapi (fun i row -> i, row) errors)
      |> Option.to_result ~none:(Error.Parse ("SURFACE_ERROR: unknown error " ^ name.text, name.line, name.col)) in
    if List.length args <> List.length row.error_args then fail name "ERROR" "wrong error argument count" else
    let* args = List.fold_left (fun result v -> let* args = result in
      let* v = word env v in Ok (args @ [v])) (Ok []) args in
    Ok (app "reject" ["(inj " ^ string_of_int index ^ " of " ^ string_of_int (List.length errors) ^
      " (tuple (" ^ String.concat ", " args ^ ")) : Error)"]) in
  let predicate = resolved_predicate in
  let proof = proof helpers in
  let rec lower index env state written evidence = function
    | [] -> (match ending with
      | Return v -> let* v = word env v in
        let changed = List.filter (fun row -> List.exists (fun field -> List.mem field written)
          (invariant_fields row)) invariants in
        obligations changed state evidence "Tx" (app "done" [v])
      | Revert _at -> Ok "abort"
      | Reject (name, args) -> reject env (name, args)
      | Unit at -> fail at "RETURN" "an entry must return Word")
    | step :: rest ->
      let fresh = "_assay_v" ^ string_of_int index in
      let bind name = lower (index + 1) ((name.text, Word_value fresh) :: env) state written evidence rest in
      let arithmetic op name a b =
        let* a = word env a in let* b = word env b in
        let* next = bind name in
        Ok (app op [a; b; lambda "_assay_result" "ResultWord"
          ("case _assay_result with | 0 (" ^ fresh ^ " : Word 256) => " ^ next ^
           " | 1 (_assay_error : prod ()) => abort")]) in
      match step with
      | Load (name, field) ->
        let* key = slot fields field in
        let* next = lower (index + 1) ((name.text, Word_value fresh) :: env)
          ((field.text, Word_value fresh) :: List.remove_assoc field.text state) written evidence rest in
        Ok (app "load" [key; lambda fresh "Word 256" next])
      | Add (name, a, b) -> arithmetic "add" name a b
      | Sub (name, a, b) -> arithmetic "sub" name a b
      | Prove (name, claim, error, condition) ->
        let* ty, _op, _a, _b = predicate env claim in
        let* _ty, op, a, b = predicate env condition in
        let* no = Option.fold ~none:(Ok "abort") ~some:(reject env) error in
        let* yes = lower (index + 1) ((name.text, Proof_value fresh) :: env) state written ((ty, fresh) :: evidence) rest in
        let success = "(" ^ lambda ("0 " ^ fresh) ty yes ^ " : (0 " ^ fresh ^ " : " ^ ty ^ ") -> Tx)" in
        Ok (app op [a; b; success; no])
      | Proof_bind (name, claim, term) ->
        let* ty, _op, _a, _b = predicate env claim in
        let* term = proof 0 env ty term in
        let* next = lower (index + 1) ((name.text, Proof_value fresh) :: env) state written ((ty, fresh) :: evidence) rest in
        Ok (erased_apply fresh ty "Tx" term next)
      | Proven (op, name, a, b, term) ->
        let* a = word env a in let* b = word env b in
        let ty = if op.text = "addLt" then app "AddFits" [a; b] else app "Le" [b; a] in
        let* term = proof 0 env ty term in
        let* next = bind name in Ok (app op.text [a; b; term; lambda fresh "Word 256" next])
      | Bind (name, v) ->
        let* v = word env v in let* next = bind name in
        Ok ("(let " ^ fresh ^ " : Word 256 := " ^ v ^ " in " ^ next ^ ")")
      | Store (field, v) ->
        let* key = slot fields field in let* v = word env v in
        let* next = lower index env ((field.text, Word_value v) :: List.remove_assoc field.text state)
          (field.text :: written) evidence rest in Ok (app "store" [key; v; next])
      | Guard (a, b) ->
        let* a = word env a in let* b = word env b in
        let* next = lower index env state written evidence rest in Ok (app "le" [a; b; next; "abort"]) in
  lower 0 env [] [] [] steps

let constructor fields (steps, ending) =
  let* () = match ending with
    | Unit _ -> Ok ()
    | Return (Literal at | Local at) | Revert at | Reject (at, _) ->
      fail at "CONSTRUCTOR" "constructor must end in pure ()" in
  List.fold_right (fun step result ->
    let* next = result in
    match step with
    | Store (field, Literal at) ->
      let* field = slot fields field in let* v = word [] (Literal at) in
      Ok (app "put" [field; v; next])
    | Store (at, Local _) | Load (at, _) | Add (at, _, _) | Sub (at, _, _) | Bind (at, _)
    | Prove (at, _, _, _) | Proven (at, _, _, _, _) | Proof_bind (at, _, _) ->
      fail at "CONSTRUCTOR" "constructor accepts literal stores only"
    | Guard ((Literal at | Local at), _) ->
      fail at "CONSTRUCTOR" "constructor accepts literal stores only")
    steps (Ok "(ret (word 256 0))")

let generate state fields entries errors invariants helpers init =
  let aliases = List.sort_uniq String.compare
    (List.map (fun at -> at.text) (fields @ List.concat_map (fun row -> row.args) entries @
      List.concat_map (fun row -> row.error_args) errors)) in
  let names = state :: List.map (fun row -> row.name) entries @ List.map (fun row -> row.error_name) errors @
    List.map (fun row -> row.invariant_name) invariants @ List.map (fun row -> row.helper_name) helpers in
  let* _names = List.fold_left (fun result name ->
    let* seen = result in
    if List.mem name.text (aliases @ seen) then fail name "DUPLICATE" ("conflicting global " ^ name.text)
    else Ok (name.text :: seen)) (Ok []) names in
  let field_slots = List.mapi (fun i at -> at.text, "storage." ^ string_of_int i) fields in
  let* helper_scope, helper_source = helpers_source helpers in
  let* init_term = Option.fold ~none:(Ok "(ret (word 256 0))") ~some:(constructor field_slots) init in
  let initial = List.map (fun at -> at.text, Word_value "(word 256 0)") fields in
  let* initial = List.fold_left (fun result step -> let* state = result in match step with
    | Store (field, v) -> let* v = word [] v in
      Ok ((field.text, Word_value v) :: List.remove_assoc field.text state)
    | Load _ | Add _ | Sub _ | Guard _ | Bind _ | Prove _ | Proven _ | Proof_bind _ -> Ok state)
    (Ok initial) (Option.fold ~none:[] ~some:fst init) in
  (* Constructor obligations live in its type, so the closed Eff backend never
     receives a proof closure. The kernel checks them before type erasure. *)
  let* init_ty = obligations invariants initial [] "Type 0" "Eff" in
  let init = "(" ^ init_term ^ " : " ^ init_ty ^ ")" in
  let* branches = List.fold_left (fun result (i, row) ->
    let* branches = result in
    let env = List.mapi (fun i at -> at.text, Word_value ("_assay_args." ^ string_of_int i)) row.args in
    let* term = transaction field_slots errors invariants helper_scope env row.body in
    Ok (branches @ ["| " ^ string_of_int i ^ " (_assay_args : " ^ row.name.text ^ ") => " ^ term]))
    (Ok []) (List.mapi (fun i row -> i, row) entries) in
  let decl = Recognize.declaration in
  let collection former ats = Recognize.collection_source former (List.map (fun at -> at.text) ats) in
  let nullary = List.for_all (fun row -> row.args = []) entries in
  let arguments row =
    if nullary then "(prod () : Type 0)" else collection "prod" row.args in
  let aliases = String.concat "" (List.map (fun name -> decl name "Word 256") aliases) in
  let error_source = String.concat "" (List.map (fun row ->
    decl row.error_name.text (if row.error_args = [] then "(prod () : Type 0)"
      else collection "prod" row.error_args)) errors) ^
    decl "Error" (collection "sum" (List.map (fun row -> row.error_name) errors)) in
  let proofs = helpers <> [] || invariants <> [] || List.exists (fun row -> List.exists (function
    | Prove _ | Proven _ | Proof_bind _ -> true
    | Load _ | Add _ | Sub _ | Store _ | Guard _ | Bind _ -> false) (fst row.body)) entries in
  Ok ((if errors = [] then Recognize.m1_protocol_for ~proofs "" ^ aliases
    else Recognize.m1_protocol_for ~proofs (aliases ^ error_source)) ^ helper_source ^
    decl "Storage" (collection "prod" fields) ^ decl state.text "Storage" ^
    "def storage : Storage := tuple (" ^ String.concat ", "
      (List.mapi (fun i _at -> "word 256 " ^ string_of_int i) fields) ^ ")\n" ^
    String.concat "" (List.map (fun row -> decl row.name.text (arguments row)) entries) ^
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
  let rec declarations entries errors invariants helpers init tokens = match tokens with
    | { text = "entry"; _ } :: rest ->
      let* name, rest = identifier rest in
      let* _names = add_name name (List.map (fun row -> row.name) entries) in
      let* args, rest = arguments rest in
      let* rest = sequence [":"; "Eff"; "Sig"; "Word"; ":="] rest in
      let* body, rest = body rest in declarations (entries @ [{ name; args; body }]) errors invariants helpers init rest
    | { text = "error"; _ } :: rest ->
      let* error_name, rest = identifier rest in
      let* _names = add_name error_name (List.map (fun row -> row.error_name) errors) in
      let* error_args, rest = arguments rest in
      declarations entries (errors @ [{error_name; error_args}]) invariants helpers init rest
    | { text = "invariant"; _ } :: rest ->
      let* row, rest = invariant state fields rest in
      let* _names = add_name row.invariant_name (List.map (fun row -> row.invariant_name) invariants) in
      declarations entries errors (invariants @ [row]) helpers init rest
    | { text = "proof"; _ } :: rest ->
      let* row, rest = helper rest in
      let* _names = add_name row.helper_name (List.map (fun row -> row.helper_name) helpers) in
      declarations entries errors invariants (helpers @ [row]) init rest
    | ({ text = "constructor"; _ } as at) :: rest ->
      if Option.is_some init then fail at "DUPLICATE" "duplicate constructor" else
      let* rest = expect ":=" rest in
      let* init, rest = body rest in declarations entries errors invariants helpers (Some init) rest
    | [{ text = ""; _ }] ->
      if entries = [] then fail name "ENTRY" "at least one entry is required"
      else let* core = generate state fields entries errors invariants helpers init in Ok (Some name.text, core)
    | [] | _ :: _ -> fail (here tokens) "DECLARATION" "expected entry, error, invariant, proof, constructor or end of input" in
  declarations [] [] [] [] None tokens

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

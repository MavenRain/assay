(* Contract sugar over the checked M1 protocol. No source token is copied
   into core code before its spelling, scope and role have been validated. *)
open Kanon_kernel

let ( let* ) = Result.bind
type token = { text : string; line : int; col : int }
type word = Literal of token | Local of token
type predicate = Ordered of word * word | Fits of word * word
type condition = Check of predicate | Conjoin of condition * condition | Satisfy of token * word list
type runtime_condition = Runtime_check of string * string * string | Runtime_both of runtime_condition * runtime_condition
type claim = Bound of predicate | Both of claim * claim | Named of token * word list
type predicate_row = { predicate_name : token; words : token list; definition : claim }
type resolved_claim = Atomic of string | Bundle of resolved_claim * resolved_claim
type proof =
  | Proof_unit
  | Proof_hole of token
  | Proof_name of token
  | Proof_word of word
  | Proof_call of token * proof list
  | Proof_ann of proof * claim
  | Proof_let of token * claim option * proof * proof
  | Proof_pair of token * proof * proof
  | Proof_project of token * bool * proof
type parameter = Word_parameter of token | Proof_parameter of token * claim
type helper = { helper_name : token; parameters : parameter list; conclusion : claim; proof_body : proof }
type binding = Word_value of string | Proof_value of string * resolved_claim
type step =
  | Load of token * token
  | Caller of token
  | Deployer of token
  | Add of token * word * word
  | Sub of token * word * word
  | Store of token * word
  | Guard of word * word
  | Bind of token * word
  | Prove of token * claim * (token * word list) option * condition
  | Proven of token * token * word * word * proof option
  | Proof_bind of token * claim option * proof
type ending = Return of word | Unit of token | Revert of token | Reject of token * word list
type body = step list * ending
type entry = { name : token; args : token list; body : body }
type error_row = { error_name : token; error_args : token list }
type invariant = { invariant_name : token; claim : claim }

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

let reserved = ["Both"; "EqWord"; "eqWord"; "predicate"; "caller"; "deployer"] @ String.split_on_char ' '
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
  let hexadecimal = String.starts_with ~prefix:"0x" (String.lowercase_ascii at.text) in
  let base, first, maximum = if hexadecimal then 16, 2, 66 else 10, 0, 78 in
  let size = String.length at.text in
  let error = Error.Parse ("SURFACE_WORD: expected a decimal or hexadecimal uint256", at.line, at.col) in
  let accumulate parsed c = Option.bind parsed (fun n ->
    Option.bind (String.index_opt "0123456789abcdef" (Char.lowercase_ascii c)) (fun digit ->
      if digit >= base then None else Some (Z.add (Z.mul n (Z.of_int base)) (Z.of_int digit)))) in
  let parsed = if size <= first || size > maximum then None
    else Seq.fold_left accumulate (Some Z.zero) (Seq.drop first (String.to_seq at.text)) in
  let* n = Option.to_result ~none:error parsed in
  if Z.compare n (Z.shift_left Z.one 256) < 0 then Ok (Literal { at with text = Z.to_string n })
  else Error error
let rec value depth tokens =
  if depth > 128 then fail (here tokens) "LIMIT" "value nesting exceeds 128" else
  match tokens with
  | { text = "("; _ } :: rest ->
    let* word, rest = value (depth + 1) rest in
    let* rest = expect ")" rest in Ok (word, rest)
  | { text = "word"; _ } :: at :: rest ->
    let* word = literal at in Ok (word, rest)
  | [] | _ :: _ -> let* name, rest = identifier tokens in Ok (Local name, rest)
let binary operand tokens =
  let* a, rest = operand tokens in
  let* b, rest = operand rest in Ok ((a, b), rest)
let opens_value tokens = match tokens with
  | { text = "("; _ } :: _rest -> true
  | [] | _ :: _ -> false
let opens_condition tokens = match tokens with
  | { text = "("; _ } :: { text = "both"; _ } :: { text = "("; _ } :: _rest -> true
  | { text = "("; _ } :: name :: { text = "("; _ } :: _rest
    when Recognize.identifier name.text && not (List.mem name.text reserved) -> true
  | { text = "("; _ } :: at :: _rest -> List.mem at.text ["leWord"; "lt256"; "eqWord"]
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
  match tokens with
  | at :: rest when at.text = (if runtime then "leWord" else "Le") ->
    let* (a, b), rest = binary operand rest in Ok (Ordered (a, b), rest)
  | at :: rest when at.text = (if runtime then "lt256" else "Lt256") ->
    let* rest = sequence ["("; "add"] rest in
    let* (a, b), rest = binary operand rest in
    let* rest = expect ")" rest in Ok (Fits (a, b), rest)
  | [] | _ :: _ -> fail (here tokens) "PROOF" "expected an ordering or addition bound"
let predicate_arguments operand name tokens =
  let* name, _rest = identifier [name] in
  let rec arguments acc tokens =
    if List.length acc >= 16 then fail name "LIMIT" "at most 16 predicate arguments" else
    let* v, rest = operand tokens in
    match rest with
    | { text = ","; _ } :: rest -> arguments (v :: acc) rest
    | [] | _ :: _ -> let* rest = expect ")" rest in Ok (List.rev (v :: acc), rest) in
  match tokens with
  | { text = ")"; _ } :: rest -> Ok ([], rest)
  | [] | _ :: _ -> arguments [] tokens
let condition tokens =
  let rec parse depth remaining tokens =
    if depth > 32 || remaining = 0 then
      fail (here tokens) "LIMIT" "guard condition exceeds depth 32 or 64 bounds" else
    match tokens with
    | { text = "both"; _ } :: rest when opens_condition rest || not (opens_value rest) ->
      let component remaining tokens =
        let* rest = expect "(" tokens in
        let* c, remaining, rest = parse (depth + 1) remaining rest in
        let* rest = expect ")" rest in Ok (c, remaining, rest) in
      let* a, remaining, rest = component remaining rest in
      let* b, remaining, rest = component remaining rest in
      Ok (Conjoin (a, b), remaining, rest)
    | ({ text = "eqWord"; _ } as at) :: rest ->
      let* (a, b), rest = binary (value 0) rest in
      if depth > 31 || remaining < 2 then fail at "LIMIT" "guard condition exceeds depth 32 or 64 bounds" else
      Ok (Conjoin (Check (Ordered (a, b)), Check (Ordered (b, a))), remaining - 2, rest)
    | name :: { text = "("; _ } :: rest when not (List.mem name.text reserved) ->
      let* args, rest = predicate_arguments (value 0) name rest in
      Ok (Satisfy (name, args), remaining - 1, rest)
    | [] | _ :: _ ->
      let* p, rest = bound (value 0) true tokens in Ok (Check p, remaining - 1, rest) in
  let* c, _remaining, rest = parse 0 64 tokens in Ok (c, rest)
let rec claim_with operand depth tokens =
  if depth > 32 then fail (here tokens) "LIMIT" "claim nesting exceeds 32" else
  match tokens with
  | { text = "Both"; _ } :: rest ->
    let component tokens = let* rest = expect "(" tokens in
      let* c, rest = claim_with operand (depth + 1) rest in let* rest = expect ")" rest in Ok (c, rest) in
    let* a, rest = component rest in let* b, rest = component rest in Ok (Both (a, b), rest)
  | { text = "EqWord"; _ } :: rest ->
    if depth = 32 then fail (here tokens) "LIMIT" "claim nesting exceeds 32" else
    let* a, rest = operand rest in let* b, rest = operand rest in
    Ok (Both (Bound (Ordered (a, b)), Bound (Ordered (b, a))), rest)
  | name :: { text = "("; _ } :: rest when name.text <> "Le" && name.text <> "Lt256" ->
    let* args, rest = predicate_arguments operand name rest in Ok (Named (name, args), rest)
  | [] | _ :: _ -> let* p, rest = bound operand false tokens in Ok (Bound p, rest)
let claim = claim_with (value 0)
let proof_binding tokens =
  let* rest = sequence ["("; "0"] tokens in
  let* name, rest = identifier rest in
  let* claim, rest = match rest with
    | { text = ":"; _ } :: rest -> let* ty, rest = claim 0 rest in Ok (Some ty, rest)
    | [] | _ :: _ -> Ok (None, rest) in
  let* rest = expect ")" rest in Ok ((name, claim), rest)
let rec proof_term depth tokens =
  if depth > 128 then fail (here tokens) "LIMIT" "proof nesting exceeds 128" else
  match tokens with
  | ({ text = "_"; _ } as at) :: rest -> Ok (Proof_hole at, rest)
  | { text = "("; _ } :: { text = ")"; _ } :: rest -> Ok (Proof_unit, rest)
  | { text = "("; _ } :: rest ->
    let* term, rest = proof_term (depth + 1) rest in
    let* term, rest = match rest with
      | { text = ":"; _ } :: rest ->
        let* claim, rest = claim 0 rest in Ok (Proof_ann (term, claim), rest)
      | [] | _ :: _ -> Ok (term, rest) in
    let* rest = expect ")" rest in Ok (term, rest)
  | { text = "let"; _ } :: rest ->
    let* (name, claim), rest = proof_binding rest in
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
let guard_condition rest =
  let* error, rest = match rest with
    | { text = "("; _ } :: _tail -> Ok (None, rest)
    | [] | _ :: _ ->
      let* name, rest = identifier rest in
      let rec args acc rest = match rest with
        | _ when opens_condition rest ->
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
  let* rest = expect "(" rest in let* condition, rest = condition rest in
  let* rest = expect ")" rest in Ok ((error, condition), rest)

let rec condition_claim = function
  | Check predicate -> Bound predicate
  | Conjoin (left, right) -> Both (condition_claim left, condition_claim right)
  | Satisfy (name, args) -> Named (name, args)

let proof_guard tokens =
  let* (name, annotation), rest = proof_binding tokens in
  let* rest = sequence ["<-"; "guard"] rest in
  let* (error, condition), rest = guard_condition rest in
  let claim = Option.fold ~none:(fun () -> condition_claim condition)
    ~some:(fun claim () -> claim) annotation () in
  Ok (Prove (name, claim, error, condition), rest)

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
    | { text = "deployer"; _ } :: rest ->
      let* slot, rest = identifier rest in next (Deployer slot) rest
    | { text = "guard"; _ } :: { text = "le"; _ } :: rest ->
      let* (a, b), rest = binary (value 0) rest in next (Guard (a, b)) rest
    | ({ text = "guard"; _ } as at) :: rest ->
      let* (error, condition), rest = guard_condition rest in
      (* Source identifiers cannot use this prefix. The checked evidence stays
         available to checked obligations without adding a source binding. *)
      let name = { at with text = "_assay_guard" } in
      next (Prove (name, condition_claim condition, error, condition)) rest
    | { text = "let"; _ } :: ({ text = "("; _ } :: _tail as rest) ->
      let* (name, claim), rest = proof_binding rest in
      let* rest = expect ":=" rest in
      let* proof, rest = proof_term 0 rest in next (Proof_bind (name, claim, proof)) rest
    | { text = "let"; _ } :: rest ->
      let* name, rest = identifier rest in
      let* rest = sequence [":"; "Word"; ":="] rest in
      (match rest with
       | op :: rest when op.text = "addLt" || op.text = "subLe" ->
         let* (a, b), rest = binary (value 0) rest in
         let* proof, rest = match rest with
           | { text = ";"; _ } :: _tail -> Ok (None, rest)
           | [] | _ :: _ -> let* term, rest = proof_term 0 rest in Ok (Some term, rest) in
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
       | { text = "caller"; _ } :: rest -> next (Caller name) rest
       | { text = "add"; _ } :: rest ->
         let* (a, b), rest = binary (value 0) rest in next (Add (name, a, b)) rest
       | { text = "sub"; _ } :: rest ->
         let* (a, b), rest = binary (value 0) rest in next (Sub (name, a, b)) rest
       | [] | _ :: _ -> fail (here rest) "EFFECT" "expected sload, caller, add or sub") in
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
        | [] | _ :: _ -> let* claim, rest = claim 0 rest in Ok (Proof_parameter (name, claim), rest) in
      let* rest = expect ")" rest in parameters names (acc @ [parameter]) rest
    | [] | _ :: _ -> Ok (acc, tokens) in
  let* parameters, rest = parameters [] [] rest in
  let* rest = expect ":" rest in let* conclusion, rest = claim 0 rest in
  let* rest = expect ":=" rest in let* proof_body, rest = proof_term 0 rest in
  Ok ({ helper_name; parameters; conclusion; proof_body }, rest)

let predicate_declaration tokens =
  let* predicate_name, rest = identifier tokens in
  let rec parameters names tokens = match tokens with
    | { text = "("; _ } :: rest ->
      if List.length names >= 16 then fail predicate_name "LIMIT" "at most 16 predicate parameters" else
      let* rest = expect "0" rest in let* name, rest = named_word rest in
      let* names = add_name name names in let* rest = expect ")" rest in parameters names rest
    | [] | _ :: _ -> Ok (List.rev names, tokens) in
  let* words, rest = parameters [] rest in
  let* rest = sequence [":"; "Prop"; ":="] rest in
  let* definition, rest = claim 0 rest in Ok ({ predicate_name; words; definition }, rest)

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
  let* claim, rest = claim_with (operand 0) 0 rest in
  Ok ({ invariant_name; claim }, rest)

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
let rec claim_type = function
  | Atomic ty -> ty
  | Bundle (a, b) -> "(prod (" ^ claim_type a ^ ", " ^ claim_type b ^ ") : Prop)"
let proof_claim_limit at inferred ty =
  let rec count depth remaining ty =
    if (inferred && depth > 32) || remaining = 0 then fail at "LIMIT" "inferred proof claim exceeds depth 32 or 4096 nodes" else
    match ty with
    | Atomic _ -> Ok (remaining - 1)
    | Bundle (a, b) ->
      let* remaining = count (depth + 1) (remaining - 1) a in count (depth + 1) remaining b in
  let* _remaining = count 0 4096 ty in Ok ty
let resolve_claim leaf pair predicates env claim =
  let rec site = function
    | Named (at, _) -> Some at
    | Bound _ -> None
    | Both (a, b) -> let left = site a in if Option.is_none left then site b else left in
  let rec resolve predicates env expanded enclosing depth remaining claim =
    let at = match claim with Named (at, _) -> at | Bound _ | Both _ -> enclosing in
    if (expanded && depth > 32) || remaining = 0 then fail at "LIMIT" "expanded claim exceeds depth 32 or 4096 nodes" else
    let remaining = remaining - 1 in
    match claim with
    | Bound p -> let* ty, op, a, b = resolved_predicate env p in Ok (leaf ty op a b, remaining)
    | Both (a, b) ->
      let* a, remaining = resolve predicates env expanded enclosing (depth + 1) remaining a in
      let* b, remaining = resolve predicates env expanded enclosing (depth + 1) remaining b in Ok (pair a b, remaining)
    | Named (at, args) ->
      if List.mem_assoc at.text env then fail at "PREDICATE" "a local binding shadows this predicate" else
      let rec lookup = function
        | [] -> fail at "PREDICATE" ("unknown or forward predicate " ^ at.text)
        | row :: earlier when row.predicate_name.text = at.text -> Ok (row, earlier)
        | _row :: earlier -> lookup earlier in
      let* row, earlier = lookup predicates in
      let rec arguments substitution parameters args = match parameters, args with
        | [], [] -> Ok substitution
        | name :: parameters, arg :: args ->
          let* v = word env arg in arguments ((name.text, Word_value v) :: substitution) parameters args
        | [], _ :: _ | _ :: _, [] -> fail at "PREDICATE" "wrong predicate argument count" in
      let* substitution = arguments [] row.words args in
      resolve earlier substitution true at (depth + 1) remaining row.definition in
  let start = Option.value (site claim) ~default:(here []) in
  let* ty, _remaining = resolve predicates env false start 0 4096 claim in Ok ty

let resolved_claim predicates env claim =
  resolve_claim (fun ty _op _a _b -> Atomic ty) (fun a b -> Bundle (a, b)) predicates env claim

let optional_claim predicates env claim =
  Option.fold ~none:(Ok None)
    ~some:(fun claim -> let* ty = resolved_claim predicates env claim in Ok (Some ty)) claim

let resolved_condition predicates env at condition =
  let* condition = resolve_claim (fun _ty op a b -> Runtime_check (op, a, b))
    (fun a b -> Runtime_both (a, b)) predicates env (condition_claim condition) in
  let rec budget depth remaining condition =
    if depth > 32 || remaining = 0 then
      fail at "LIMIT" "expanded guard condition exceeds depth 32 or 64 bounds" else
    match condition with
    | Runtime_check _ -> Ok (remaining - 1)
    | Runtime_both (a, b) ->
      let* remaining = budget (depth + 1) remaining a in budget (depth + 1) remaining b in
  let* _remaining = budget 0 64 condition in Ok condition

let predicates_scope rows =
  List.fold_left (fun result row ->
    let* earlier = result in
    let env = List.mapi (fun i name -> name.text, Word_value ("_assay_pred" ^ string_of_int i)) row.words in
    let* _ty = resolved_claim earlier env row.definition in Ok (row :: earlier)) (Ok []) rows
let project first term = "(" ^ term ^ ")." ^ (if first then "0" else "1")
let rec evidence_for term ty evidence =
  let evidence = (claim_type ty, term) :: evidence in
  match ty with
  | Atomic _ -> evidence
  | Bundle (a, b) -> evidence_for (project false term) b (evidence_for (project true term) a evidence)
let rec invariant_proof evidence ty =
  let components () = match ty with
    | Atomic _ -> "(tuple ())"
    | Bundle (a, b) -> "(tuple (" ^ invariant_proof evidence a ^ ", " ^ invariant_proof evidence b ^ "))" in
  Option.fold ~none:components ~some:(fun term () -> term)
    (List.assoc_opt (claim_type ty) evidence) ()
(* Annotations preserve obligations even for unused erased arguments and
   declarations. Only kernel erasure may discard their checked terms. *)
let rec proof ?(erased=true) ?(evidence=[]) predicates helpers depth env expected term =
  let resolved_claim = resolved_claim predicates in
  let proof ?(evidence=evidence) ~erased helpers depth env expected term =
    proof ~erased ~evidence predicates helpers depth env expected term in
  let* actual, term = match term with
    | Proof_unit -> Ok (Atomic "(prod ())", "(tuple ())")
    | Proof_hole at ->
      Option.fold ~none:(fail at "PROOF" "a proof placeholder requires an expected claim")
        ~some:(fun ty -> Ok (ty, invariant_proof evidence ty)) expected
    | Proof_word (Literal at | Local at) -> fail at "PROOF" "a Word is not an erased proof"
    | Proof_name at ->
      let refusal = fail at "PROOF" "expected an in-scope erased proof" in
      Option.fold ~none:refusal ~some:(function
        | Proof_value (p, ty) -> Ok (ty, p) | Word_value _ -> refusal) (List.assoc_opt at.text env)
    | Proof_ann (term, claim) ->
      let* ty = resolved_claim env claim in proof ~erased helpers (depth + 1) env (Some ty) term
    | Proof_let (name, claim, value, body) ->
      let* expected_value = optional_claim predicates env claim in
      let* claim, value = proof ~erased helpers (depth + 1) env expected_value value in
      let ty = claim_type claim in
      let fresh = "_assay_p" ^ string_of_int depth in
      let* result, body = proof ~erased ~evidence:(evidence_for fresh claim evidence)
        helpers (depth + 1) ((name.text, Proof_value (fresh, claim)) :: env) expected body in
      let result_type = claim_type result in
      Ok (result, if erased then erased_apply fresh ty result_type value body else
        app ("(" ^ lambda fresh ty body ^ " : (" ^ fresh ^ " : " ^ ty ^ ") -> " ^ result_type ^ ")") [value])
    | Proof_pair (at, a, b) ->
      let* a_type, b_type = Option.fold ~none:(Ok (None, None)) ~some:(function
        | Bundle (a, b) -> Ok (Some a, Some b)
        | Atomic _ -> fail at "PROOF" "a proof pair requires a Both claim") expected in
      let* a_type, a = proof ~erased helpers (depth + 1) env a_type a in
      let* b_type, b = proof ~erased helpers (depth + 1) env b_type b in
      let* ty = proof_claim_limit at (Option.is_none expected) (Bundle (a_type, b_type)) in
      Ok (ty, "(tuple (" ^ a ^ ", " ^ b ^ "))")
    | Proof_project (at, first, term) ->
      let* ty, term = proof ~erased helpers (depth + 1) env None term in
      (match ty with
       | Bundle (a, b) -> Ok ((if first then a else b), project first term)
       | Atomic _ -> fail at "PROOF" "a proof projection requires a Both claim")
    | Proof_call (at, args) when not (List.mem_assoc at.text helpers) &&
        List.mem at.text ["pair"; "first"; "second"] ->
      if List.mem_assoc at.text env then fail at "PROOF" "a local binding shadows this proof operation" else
      let* term = match at.text, args with
        | "pair", [a; b] -> Ok (Proof_pair (at, a, b))
        | ("first" | "second"), [term] -> Ok (Proof_project (at, at.text = "first", term))
        | _, ([] | _ :: _) -> fail at "PROOF" "wrong proof operation argument count" in
      proof ~erased helpers depth env expected term
    | Proof_call (at, args) ->
      let* core_name, row = List.assoc_opt at.text helpers
        |> Option.to_result ~none:(Error.Parse ("SURFACE_PROOF: unknown or forward proof helper " ^ at.text, at.line, at.col)) in
      if List.mem_assoc at.text env then fail at "PROOF" "a local binding shadows this proof helper" else
      let rec arguments substitution values evidence bindings parameters args =
        let bind_proof ty value parameters args =
          let used_later = List.exists (function Proof_parameter _ -> true | Word_parameter _ -> false) parameters in
          if not used_later then arguments substitution (value :: values) evidence bindings parameters args else
          let fresh = "_assay_arg" ^ string_of_int depth ^ "_" ^ string_of_int (List.length values) in
          arguments substitution (fresh :: values) (evidence_for fresh ty evidence)
            ((fresh, ty, value) :: bindings) parameters args in
        match parameters, args with
        | [], [] -> Ok (substitution, List.rev values, List.rev bindings)
        | Word_parameter name :: parameters, arg :: args ->
          let* v = match arg with
            | Proof_word v -> word env v
            | Proof_name at -> word env (Local at)
            | Proof_unit | Proof_hole _ | Proof_call _ | Proof_ann _ | Proof_let _ | Proof_pair _ | Proof_project _ ->
              fail at "PROOF" "expected a Word helper argument" in
          arguments ((name.text, Word_value v) :: substitution) (v :: values) evidence bindings parameters args
        | Proof_parameter (_name, claim) :: parameters, arg :: args ->
          let* ty = resolved_claim substitution claim in
          let* _ty, v = proof ~erased ~evidence helpers (depth + 1) env (Some ty) arg in
          bind_proof ty v parameters args
        | Proof_parameter (_name, claim) :: parameters, [] ->
          let* ty = resolved_claim substitution claim in
          let v = "(" ^ invariant_proof evidence ty ^ " : " ^ claim_type ty ^ ")" in
          bind_proof ty v parameters []
        | [], _ :: _ | Word_parameter _ :: _, [] -> fail at "PROOF" "wrong proof helper argument count" in
      let* substitution, args, bindings = arguments [] [] evidence [] row.parameters args in
      let* ty = resolved_claim substitution row.conclusion in
      let result = claim_type ty in
      let body = if args = [] then core_name else app core_name args in
      (* Bind each proof once so nested calls cannot duplicate its expression
         when later arguments reuse its evidence. *)
      let body = List.fold_right (fun (fresh, ty, value) body ->
        let ty = claim_type ty in
        if erased then erased_apply fresh ty result value body else
          app ("(" ^ lambda fresh ty body ^ " : (" ^ fresh ^ " : " ^ ty ^ ") -> " ^ result ^ ")") [value]) bindings body in
      Ok (ty, body) in
  let ty = Option.value expected ~default:actual in
  Ok (ty, "(" ^ term ^ " : " ^ claim_type ty ^ ")")

let helpers_source predicates rows =
  let resolved_claim = resolved_claim predicates in
  let proof ~erased ~evidence = proof ~erased ~evidence predicates in
  let rec lower index helpers source = function
    | [] -> Ok (helpers, String.concat "" (List.rev source))
    | row :: rest ->
      let rec parameters index env evidence = function
        | [] ->
          let* ty = resolved_claim env row.conclusion in
          let* _ty, term = proof ~erased:false ~evidence helpers 0 env (Some ty) row.proof_body in Ok (claim_type ty, term)
        | parameter :: rest ->
          let fresh = "_assay_harg" ^ string_of_int index in
          let* name, ty, binding = match parameter with
            | Word_parameter name -> Ok (name, "Word 256", Word_value fresh)
            | Proof_parameter (name, claim) ->
              let* ty = resolved_claim env claim in Ok (name, claim_type ty, Proof_value (fresh, ty)) in
          let evidence = match binding with
            | Word_value _ -> evidence
            | Proof_value (term, ty) -> evidence_for term ty evidence in
          let* result, term = parameters (index + 1) ((name.text, binding) :: env) evidence rest in
          (* Top-level core definitions check in runtime mode. These pure
             functions have ordinary core parameters, and the surface only
             permits their applications inside erased proof positions. *)
          Ok ("(" ^ fresh ^ " : " ^ ty ^ ") -> " ^ result, lambda fresh ty term) in
      let* ty, term = parameters 0 [] [] row.parameters in
      let name = "_assay_helper" ^ string_of_int index in
      let declaration = "def " ^ name ^ " : " ^ ty ^ " := " ^ term ^ "\n" in
      lower (index + 1) ((row.helper_name.text, (name, row)) :: helpers) (declaration :: source) rest in
  lower 0 [] [] rows

let invariant_fields row =
  let rec operands = function
    | Bound (Ordered (a, b) | Fits (a, b)) -> [a; b]
    | Named (_at, args) -> args
    | Both (a, b) -> operands a @ operands b in
  List.filter_map (function Literal _ -> None | Local at -> Some at.text) (operands row.claim)
let obligations predicates invariants state evidence result next =
  List.fold_right (fun row result_body ->
    let* body = result_body in
    let* () = List.fold_left (fun result field -> let* () = result in
      if List.mem_assoc field state then Ok () else
      fail row.invariant_name "INVARIANT" ("load or store field " ^ field ^ " before proving the final state"))
      (Ok ()) (invariant_fields row) in
    let* ty = resolved_claim predicates state row.claim in
    let proof = invariant_proof evidence ty in
    Ok (erased_apply ("_assay_inv_" ^ row.invariant_name.text) (claim_type ty) result proof body)) invariants (Ok next)
let transaction fields errors invariants predicates helpers env (steps, ending) =
  let resolved_claim = resolved_claim predicates in
  let obligations = obligations predicates in
  let reject env (name, args) =
    let* index, row = List.find_opt (fun (_i, row) -> row.error_name.text = name.text)
      (List.mapi (fun i row -> i, row) errors)
      |> Option.to_result ~none:(Error.Parse ("SURFACE_ERROR: unknown error " ^ name.text, name.line, name.col)) in
    if List.length args <> List.length row.error_args then fail name "ERROR" "wrong error argument count" else
    let* args = List.fold_left (fun result v -> let* args = result in
      let* v = word env v in Ok (args @ [v])) (Ok []) args in
    Ok (app "reject" ["(inj " ^ string_of_int index ^ " of " ^ string_of_int (List.length errors) ^
      " (tuple (" ^ String.concat ", " args ^ ")) : Error)"]) in
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
      let proof = proof ~evidence predicates helpers in
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
      | Caller name ->
        let* next = bind name in Ok (app "caller" [lambda fresh "Word 256" next])
      | Deployer at -> fail at "EFFECT" "deployer is available only in constructors"
      | Add (name, a, b) -> arithmetic "add" name a b
      | Sub (name, a, b) -> arithmetic "sub" name a b
      | Prove (name, claim, error, condition) ->
        let* condition = resolved_condition predicates env name condition in
        let* ty = resolved_claim env claim in
        let* no = Option.fold ~none:(Ok "abort") ~some:(reject env) error in
        let* yes = lower (index + 1) ((name.text, Proof_value (fresh, ty)) :: env)
          state written (evidence_for fresh ty evidence) rest in
        let rec guards ty condition local continue = match ty, condition with
          | Atomic ty, Runtime_check (op, a, b) ->
            let* next = continue local in
            let success = "(" ^ lambda ("0 " ^ local) ty next ^ " : (0 " ^ local ^ " : " ^ ty ^ ") -> Tx)" in
            Ok (app op [a; b; success; no])
          | Bundle (a, b), Runtime_both (left, right) ->
            guards a left (local ^ "a") (fun p ->
              guards b right (local ^ "b") (fun q ->
                continue ("(tuple (" ^ p ^ ", " ^ q ^ "))")))
          | Atomic _, Runtime_both _ | Bundle _, Runtime_check _ ->
            fail name "PROOF" "guard condition and proof bundle have different shapes" in
        guards ty condition (fresh ^ "_guard") (fun term ->
          Ok (erased_apply fresh (claim_type ty) "Tx" term yes))
      | Proof_bind (name, claim, term) ->
        let* expected_value = optional_claim predicates env claim in
        let* ty, term = proof 0 env expected_value term in
        let* next = lower (index + 1) ((name.text, Proof_value (fresh, ty)) :: env) state written (evidence_for fresh ty evidence) rest in
        Ok (erased_apply fresh (claim_type ty) "Tx" term next)
      | Proven (op, name, a, b, term) ->
        let* a = word env a in let* b = word env b in
        let ty = if op.text = "addLt" then app "AddFits" [a; b] else app "Le" [b; a] in
        (* The kernel checks the selected evidence against these operands.
           A unit witness succeeds only when the bound reduces to true. *)
        let* term = Option.fold
          ~none:(fun () -> Ok ("(" ^ invariant_proof evidence (Atomic ty) ^ " : " ^ ty ^ ")"))
          ~some:(fun term () -> let* _ty, term = proof 0 env (Some (Atomic ty)) term in Ok term) term () in
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
    | Deployer field ->
      let* field = slot fields field in Ok (app "deployer" [field; next])
    | Store (at, Local _) | Load (at, _) | Add (at, _, _) | Sub (at, _, _) | Bind (at, _)
    | Caller at | Prove (at, _, _, _) | Proven (at, _, _, _, _) | Proof_bind (at, _, _) ->
      fail at "CONSTRUCTOR" "constructor accepts literal stores and deployer initialization only"
    | Guard ((Literal at | Local at), _) ->
      fail at "CONSTRUCTOR" "constructor accepts literal stores and deployer initialization only")
    steps (Ok "(ret (word 256 0))")

let generate state fields entries errors invariants predicates helpers init =
  let aliases = List.sort_uniq String.compare
    (List.map (fun at -> at.text) (fields @ List.concat_map (fun row -> row.args) entries @
      List.concat_map (fun row -> row.error_args) errors)) in
  let names = state :: List.map (fun row -> row.name) entries @ List.map (fun row -> row.error_name) errors @
    List.map (fun row -> row.invariant_name) invariants @ List.map (fun row -> row.helper_name) helpers @
    List.map (fun row -> row.predicate_name) predicates in
  let* _names = List.fold_left (fun result name ->
    let* seen = result in
    if List.mem name.text (aliases @ seen) then fail name "DUPLICATE" ("conflicting global " ^ name.text)
    else Ok (name.text :: seen)) (Ok []) names in
  let field_slots = List.mapi (fun i at -> at.text, "storage." ^ string_of_int i) fields in
  let* predicates = predicates_scope predicates in
  let* helper_scope, helper_source = helpers_source predicates helpers in
  let* init_term = Option.fold ~none:(Ok "(ret (word 256 0))") ~some:(constructor field_slots) init in
  let initial = List.map (fun at -> at.text, Word_value "(word 256 0)") fields in
  let* initial = List.fold_left (fun result step -> let* state = result in match step with
    | Store (field, v) -> let* v = word [] v in
      Ok ((field.text, Word_value v) :: List.remove_assoc field.text state)
    | Deployer field -> Ok (List.remove_assoc field.text state)
    | Caller _ | Load _ | Add _ | Sub _ | Guard _ | Bind _ | Prove _ | Proven _ | Proof_bind _ -> Ok state)
    (Ok initial) (Option.fold ~none:[] ~some:fst init) in
  let* () = List.fold_left (fun result row -> let* () = result in
    List.fold_left (fun result field -> let* () = result in
      if List.mem_assoc field initial then Ok () else
      fail row.invariant_name "INVARIANT"
        ("constructor invariant requires a literal final value for field " ^ field))
      (Ok ()) (invariant_fields row)) (Ok ()) invariants in
  (* Constructor obligations live in its type, so the closed Eff backend never
     receives a proof closure. The kernel checks them before type erasure. *)
  let* init_ty = obligations predicates invariants initial [] "Type 0" "Eff" in
  let deployer = List.exists (function
    | Deployer _ -> true
    | Caller _ | Load _ | Add _ | Sub _ | Store _ | Guard _ | Bind _
    | Prove _ | Proven _ | Proof_bind _ -> false) (Option.fold ~none:[] ~some:fst init) in
  let init = "(" ^ init_term ^ " : " ^ init_ty ^ ")" in
  let* branches = List.fold_left (fun result (i, row) ->
    let* branches = result in
    let env = List.mapi (fun i at -> at.text, Word_value ("_assay_args." ^ string_of_int i)) row.args in
    let* term = transaction field_slots errors invariants predicates helper_scope env row.body in
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
    | Caller _ | Deployer _ | Load _ | Add _ | Sub _ | Store _ | Guard _ | Bind _ -> false) (fst row.body)) entries in
  let caller = List.exists (fun row -> List.exists (function
    | Caller _ -> true
    | Deployer _ | Load _ | Add _ | Sub _ | Store _ | Guard _ | Bind _
    | Prove _ | Proven _ | Proof_bind _ -> false) (fst row.body)) entries in
  Ok ((if errors = [] then Recognize.m1_protocol_for ~proofs ~caller ~deployer "" ^ aliases
    else Recognize.m1_protocol_for ~proofs ~caller ~deployer (aliases ^ error_source)) ^ helper_source ^
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
  let rec declarations entries errors invariants predicates helpers init tokens =
    let continue = declarations in match tokens with
    | { text = "entry"; _ } :: rest ->
      let* name, rest = identifier rest in
      let* _names = add_name name (List.map (fun row -> row.name) entries) in
      let* args, rest = arguments rest in
      let* rest = sequence [":"; "Eff"; "Sig"; "Word"; ":="] rest in
      let* body, rest = body rest in continue (entries @ [{ name; args; body }]) errors invariants predicates helpers init rest
    | { text = "error"; _ } :: rest ->
      let* error_name, rest = identifier rest in
      let* _names = add_name error_name (List.map (fun row -> row.error_name) errors) in
      let* error_args, rest = arguments rest in
      continue entries (errors @ [{error_name; error_args}]) invariants predicates helpers init rest
    | { text = "invariant"; _ } :: rest ->
      let* row, rest = invariant state fields rest in
      let* _names = add_name row.invariant_name (List.map (fun row -> row.invariant_name) invariants) in
      continue entries errors (invariants @ [row]) predicates helpers init rest
    | { text = "predicate"; _ } :: rest ->
      let* row, rest = predicate_declaration rest in
      let* _names = add_name row.predicate_name (List.map (fun row -> row.predicate_name) predicates) in
      continue entries errors invariants (predicates @ [row]) helpers init rest
    | { text = "proof"; _ } :: rest ->
      let* row, rest = helper rest in
      let* _names = add_name row.helper_name (List.map (fun row -> row.helper_name) helpers) in
      continue entries errors invariants predicates (helpers @ [row]) init rest
    | ({ text = "constructor"; _ } as at) :: rest ->
      if Option.is_some init then fail at "DUPLICATE" "duplicate constructor" else
      let* rest = expect ":=" rest in
      let* init, rest = body rest in continue entries errors invariants predicates helpers (Some init) rest
    | [{ text = ""; _ }] ->
      if entries = [] then fail name "ENTRY" "at least one entry is required"
      else let* core = generate state fields entries errors invariants predicates helpers init in Ok (Some name.text, core)
    | [] | _ :: _ -> fail (here tokens) "DECLARATION" "expected entry, error, invariant, predicate, proof, constructor or end of input" in
  declarations [] [] [] [] [] None tokens

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

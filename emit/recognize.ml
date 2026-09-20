(* M0 protocol over the inherited grammar.  Names are conventions; checked
   declarations must equal this schema before any name receives EVM meaning.
   The index is erased.  Every concrete payload is range checked here. *)
open Kanon_kernel

let base_protocol ~deployer = {|mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> Nat -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
|} ^ (if deployer then "  | deployer : Word 256 -> Eff -> Eff\n" else "") ^
  "axiom EvmOpcodes : Prop\n"
let protocol = base_protocol ~deployer:false

type error =
  | Protocol of string | Word_shape | Word_range | Word_boxed
  | Storage_closure | Storage_shape | Storage_slot

let error = function
  | Protocol name -> "M0_PROTOCOL: " ^ name
  | Word_shape -> "WORD_UNBOX_SHAPE"
  | Word_range -> "WORD_UNBOX_RANGE: expected 0 <= payload < 2^256"
  | Word_boxed -> "WORD_UNBOX_BOXED"
  | Storage_closure -> "STORAGE_NOCLOS: closure or tail application in storage field (M1)"
  | Storage_shape -> "STORAGE_SHAPE: expected a record of Word 256 slots"
  | Storage_slot -> "STORAGE_SLOT: slots must be consecutive from zero"

let ( let* ) = Result.bind
let word_tid = Eterm.Tid "mu<Word>"
let eff_tid = Eterm.Tid "mu<Eff>"

let constructor_tag globals family name =
  Option.bind (Global.find_family family globals) (fun family ->
    List.find_index (fun ctor -> ctor.Positivity.c_name = name) family.Positivity.f_ctors)
let has_constructor globals family name = Option.is_some (constructor_tag globals family name)
let check_protocol ~parse_error ~prefix families globals source =
  let* expected, rows = Kanon_surface.Elab.check_in Global.initial source |> Result.map_error parse_error in
  let* () = List.fold_left (fun result (name, _entry) ->
    let* () = result in
    if Global.find name globals = Global.find name expected then Ok ()
    else Error (Protocol (prefix ^ name))) (Ok ()) rows in
  if List.for_all (fun family -> Global.find_family family globals = Global.find_family family expected) families
  then Ok () else Error (Protocol (prefix ^ String.concat "/" families ^ " family"))
let schema ?(deployer=false) globals = check_protocol ~parse_error:(fun e -> Protocol (Error.to_string e))
  ~prefix:"" ["Word"; "Eff"] globals (base_protocol ~deployer)

type value =
  | Nat of Z.t | Word of Z.t | Erased
  | Runtime_word of int | Closure of string * int * value list
  | Struct of Eterm.tid * value list | Tag of Eterm.tid * int * value list

let tag tid index fields =
  if tid <> word_tid then Ok (Tag (tid, index, fields))
  else match index, fields with
    | 0, [Nat n] ->
      if Z.sign n < 0 || Z.numbits n > 256 then Error Word_range
      else Ok (Word n)
    | _, [] | _, _ :: _ -> Error Word_shape

let struct_value tid fields =
  if tid = word_tid then Error Word_boxed else Ok (Struct (tid, fields))

let rec unboxed = function
  | Nat _ | Word _ | Runtime_word _ | Erased -> Ok ()
  | Closure (_, _, fields) ->
    List.fold_left (fun result field -> let* () = result in unboxed field) (Ok ()) fields
  | Struct (tid, fields) | Tag (tid, _, fields) ->
    if tid = word_tid then Error Word_boxed
    else List.fold_left (fun result field -> let* () = result in unboxed field) (Ok ()) fields

(* Follow global references too, so an alias cannot conceal a closure. *)
let rec no_closure lookup seen term =
  let many terms = List.fold_left
    (fun result child -> let* () = result in no_closure lookup seen child) (Ok ()) terms in
  match term with
  | Eterm.KClos _ | Eterm.KTail _ -> Error Storage_closure
  | Eterm.KGlobal name ->
    if List.mem name seen then Error Storage_closure
    else Option.fold ~none:(Ok ())
      ~some:(fun body -> no_closure lookup (name :: seen) body) (lookup name)
  | Eterm.KVar _ | Eterm.KLit _ | Eterm.KErased -> Ok ()
  | Eterm.KLet (_, bound, body) -> many [bound; body]
  | Eterm.KApp (head, args) -> many (head :: args)
  | Eterm.KStruct (_, fields) | Eterm.KTag (_, _, fields) -> many fields
  | Eterm.KProj (_, _, head) | Eterm.KForce head -> many [head]
  | Eterm.KCase (_, head, branches) -> many (head :: List.map (fun b -> b.Eterm.body) branches)
  | Eterm.KDelay _ -> Error Storage_closure

let storage = function
  | Struct (_, fields) ->
    List.fold_left (fun result field ->
      let* names = result in
      match field with
      | Word slot when Z.equal slot (Z.of_int (List.length names)) ->
        Ok (names @ ["field" ^ string_of_int (List.length names)])
      | Word _ -> Error Storage_slot
      | Nat _ | Erased | Struct _ | Tag _ | Runtime_word _ | Closure _ -> Error Storage_shape) (Ok []) fields
  | Nat _ | Word _ | Erased | Tag _ | Runtime_word _ | Closure _ -> Error Storage_shape

let storage_type globals count =
  let source = protocol ^ "def Storage : Type 0 := prod (" ^
    String.concat ", " (List.init count (fun _index -> "Word 256")) ^ ")\n" in
  let* expected, _rows = Kanon_surface.Elab.check_in Global.initial source
    |> Result.map_error (fun _error -> Storage_shape) in
  let annotated = Global.find_def "storage" globals
    |> Option.fold ~none:false ~some:(fun d -> d.Global.ty = Term.Global "Storage") in
  if annotated && Global.find "Storage" globals = Global.find "Storage" expected
  then Ok () else Error Storage_shape

(* M1 arithmetic exposes only a success Word or an empty error leg.
   Continuations are specialized before assembly. *)
let tx_protocol = {|def ResultWord : Type 0 := sum (Word 256, prod ())
mu Tx : Type 0 :=
  | done : Word 256 -> Tx
  | store : Word 256 -> Word 256 -> Tx -> Tx
  | load : Word 256 -> (Word 256 -> Tx) -> Tx
  | add : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | sub : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | le : Word 256 -> Word 256 -> Tx -> Tx -> Tx
  | abort : Tx
|}
let proof_protocol = {|def wordNat : Word 256 -> Nat := fun (w : Word 256) =>
  case w as x in Word bits return Nat with | word 0 bits n => n
def Le : Word 256 -> Word 256 -> Prop := fun (a : Word 256) (b : Word 256) =>
  case natLt (wordNat b) (wordNat a) as flag return Prop with
  | 0 (_u : prod ()) => prod () | 1 (_u : prod ()) => sum ()
def AddFits : Word 256 -> Word 256 -> Prop := fun (a : Word 256) (b : Word 256) =>
  case natLt (natAdd (wordNat a) (wordNat b)) 115792089237316195423570985008687907853269984665640564039457584007913129639936 as flag return Prop with
  | 0 (_u : prod ()) => sum () | 1 (_u : prod ()) => prod ()
|}
let proof_effects = {|  | guardLe : (a : Word 256) -> (b : Word 256) -> ((0 p : Le a b) -> Tx) -> Tx -> Tx
  | guardAdd : (a : Word 256) -> (b : Word 256) -> ((0 p : AddFits a b) -> Tx) -> Tx -> Tx
  | addLt : (a : Word 256) -> (b : Word 256) -> (0 p : AddFits a b) -> (Word 256 -> Tx) -> Tx
  | subLe : (a : Word 256) -> (b : Word 256) -> (0 p : Le b a) -> (Word 256 -> Tx) -> Tx
|}
let proof_names = ["wordNat"; "Le"; "AddFits"; "guardLe"; "guardAdd"; "addLt"; "subLe"]
let has_proofs globals = List.exists (fun name -> Option.is_some (Global.find name globals)) proof_names
let m1_protocol_for ?(proofs=false) ?(caller=false) ?(deployer=false) ?(payable=false) error_source =
  base_protocol ~deployer ^
  (if proofs then proof_protocol else "") ^ error_source ^ tx_protocol ^
  (if error_source = "" then "" else "  | reject : Error -> Tx\n") ^
  (if proofs then proof_effects else "") ^
  (if caller then "  | caller : (Word 256 -> Tx) -> Tx\n" else "") ^
  (if payable then "  | payable : Tx -> Tx\n" else "")

let checked_schema globals source = check_protocol ~parse_error:(fun _error -> Protocol "M1 schema")
  ~prefix:"M1 " ["Tx"] globals source

let definition globals name =
  Global.find_def name globals |> Option.to_result ~none:(Protocol ("M1 " ^ name))

let identifier name =
  let initial c = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c = '_' in
  let rest c = initial c || (c >= '0' && c <= '9') in
  match List.of_seq (String.to_seq name) with
  | [] -> false
  | head :: tail -> initial head && List.for_all rest tail

let names_in_diagram name count = function
  | Term.Sec (Shape.SColl actual, legs) when actual = count && List.length legs = count ->
    List.fold_left (fun result leg ->
      let* names = result in
      match leg.Term.l_binders, leg.Term.l_body with
      | [], Term.Global field when identifier field && not (List.mem field names) ->
        Ok (names @ [field])
      | [], _ | _ :: _, _ -> Error (Protocol ("M1 " ^ name))) (Ok []) legs
  | Term.Var _ | Term.Univ _ | Term.Lan _ | Term.Ran _ | Term.In _ | Term.Elim _
  | Term.Sec _ | Term.Out _ | Term.Let _ | Term.Ann _ | Term.Global _ | Term.Lit _ | Term.Auto ->
    Error (Protocol ("M1 " ^ name))

let collection globals ~variant name =
  let* decl = definition globals name in
  match decl.Global.def with
  | Term.Lan (Shape.SColl count, diagram) when variant && count > 0 && count <= 32 ->
    names_in_diagram name count diagram
  | Term.Ran (Shape.SColl count, diagram) when not variant && count >= 0 && count <= 32 ->
    names_in_diagram name count diagram
  | Term.Ann (Term.Ran (Shape.SColl 0, Term.Sec (Shape.SColl 0, [])), Term.Univ level)
    when not variant && level = Level.one -> Ok []
  | Term.Var _ | Term.Univ _ | Term.Lan _ | Term.Ran _ | Term.In _ | Term.Elim _
  | Term.Sec _ | Term.Out _ | Term.Let _ | Term.Ann _ | Term.Global _ | Term.Lit _ | Term.Auto ->
    Error (Protocol ("M1 " ^ name))

let declaration name body = "def " ^ name ^ " : Type 0 := " ^ body ^ "\n"
let collection_source former names = former ^ " (" ^ String.concat ", " names ^ ")"

(* An explicit universe on an empty argument record keeps an all-nullary
   Entry sum at Type 0. Its payload still erases by the width-zero rule. *)
let typed_unit globals name = Global.find_def name globals
  |> Option.fold ~none:false ~some:(fun d -> d.Global.def = Rules.unit_ty Level.one)
let argument_source globals (name, args) =
  let body = collection_source "prod" args in
  declaration name (if typed_unit globals name then "(" ^ body ^ " : Type 0)" else body)

let variant globals name =
  let* names = collection globals ~variant:true name in
  List.fold_left (fun result name ->
    let* entries = result in
    let* args = collection globals ~variant:false name in
    Ok (entries @ [name, args])) (Ok []) names
let variant_source globals name rows =
  String.concat "" (List.map (argument_source globals) rows) ^
  declaration name (collection_source "sum" (List.map fst rows))
let m1_schema globals =
  let deployer = has_constructor globals "Eff" "deployer" in
  let* () = schema ~deployer globals in
  let* fields = collection globals ~variant:false "Storage" in
  let* entries = variant globals "Entry" in
  let* errors = if Option.is_some (Global.find "Error" globals)
    then variant globals "Error" else Ok [] in
  let words = List.sort_uniq String.compare (fields @ List.concat_map snd (entries @ errors)) in
  let aliases = String.concat "" (List.map (fun name -> declaration name "Word 256") words) in
  let proofs = has_proofs globals in
  let* () = Global.StringMap.fold (fun name entry result -> let* () = result in
    match entry with
    | Global.Axiom _ when proofs && name <> "Nat" && name <> "EvmOpcodes" ->
      Error (Protocol ("M1 proof assumption " ^ name))
    | Global.Axiom _ | Global.Def _ | Global.Prim _ -> Ok ()) globals.Global.entries (Ok ()) in
  let caller = has_constructor globals "Tx" "caller" in
  let payable = has_constructor globals "Tx" "payable" in
  let source = (if errors = [] then m1_protocol_for ~proofs ~caller ~deployer ~payable "" ^ aliases
    else m1_protocol_for ~proofs ~caller ~deployer ~payable (aliases ^ variant_source globals "Error" errors)) ^
    declaration "Storage" (collection_source "prod" fields) ^
    variant_source globals "Entry" entries in
  let* () = checked_schema globals source in
  let* () = if List.for_all (fun (name, args) -> args = [] && not (typed_unit globals name)) entries
    then Error (Protocol "M1 nullary Entry needs an explicit (prod () : Type 0) argument record")
    else Ok () in
  let* () = if errors <> [] && List.for_all (fun (name, args) -> args = [] && not (typed_unit globals name)) errors
    then Error (Protocol "M1 nullary Error needs an explicit (prod () : Type 0) argument record")
    else Ok () in
  let* storage = definition globals "storage" in
  if storage.Global.ty = Term.Global "Storage" then Ok (fields, entries, errors)
  else Error Storage_shape

let m1_export globals name =
  let* decl = definition globals name in
  match decl.Global.ty with
  | Term.Ran (Shape.SPi ((Quantity.Many | Quantity.One), _, Term.Global "Entry"),
      Term.Lan (Shape.SMu ("Tx", []), Term.Sec (Shape.SColl 0, []))) -> Ok ()
  | Term.Var _ | Term.Univ _ | Term.Lan _ | Term.Ran _ | Term.In _ | Term.Elim _
  | Term.Sec _ | Term.Out _ | Term.Let _ | Term.Ann _ | Term.Global _ | Term.Lit _ | Term.Auto ->
    Error (Protocol "M1 export must have type Entry -> Tx")

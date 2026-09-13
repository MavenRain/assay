(* M0 protocol over the inherited grammar.  Names are conventions; checked
   declarations must equal this schema before any name receives EVM meaning.
   The index is erased.  Every concrete payload is range checked here. *)
open Kanon_kernel

let protocol = {|mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> Nat -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
axiom EvmOpcodes : Prop
|}

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

let schema globals =
  let* expected, rows = Kanon_surface.Elab.check_in Global.initial protocol
    |> Result.map_error (fun e -> Protocol (Error.to_string e)) in
  let* () = List.fold_left (fun result (name, _entry) ->
    let* () = result in
    if Global.find name globals = Global.find name expected then Ok ()
    else Error (Protocol name)) (Ok ()) rows in
  if Global.find_family "Word" globals = Global.find_family "Word" expected &&
     Global.find_family "Eff" globals = Global.find_family "Eff" expected
  then Ok () else Error (Protocol "Word/Eff family")

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
let m1_protocol = protocol ^ {|def ResultWord : Type 0 := sum (Word 256, prod ())
mu Tx : Type 0 :=
  | done : Word 256 -> Tx
  | store : Word 256 -> Word 256 -> Tx -> Tx
  | load : Word 256 -> (Word 256 -> Tx) -> Tx
  | add : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | sub : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | le : Word 256 -> Word 256 -> Tx -> Tx -> Tx
  | abort : Tx
|}

let checked_schema globals source =
  let* expected, rows = Kanon_surface.Elab.check_in Global.initial source
    |> Result.map_error (fun _error -> Protocol "M1 schema") in
  let* () = List.fold_left (fun result (name, _entry) ->
    let* () = result in
    if Global.find name globals = Global.find name expected then Ok ()
    else Error (Protocol ("M1 " ^ name))) (Ok ()) rows in
  if Global.find_family "Tx" globals = Global.find_family "Tx" expected
  then Ok () else Error (Protocol "M1 Tx family")

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

let m1_schema globals =
  let* () = schema globals in
  let* fields = collection globals ~variant:false "Storage" in
  let* entries = collection globals ~variant:true "Entry" in
  let* entries = List.fold_left (fun result name ->
    let* entries = result in
    let* args = collection globals ~variant:false name in
    Ok (entries @ [name, args])) (Ok []) entries in
  let words = List.sort_uniq String.compare (fields @ List.concat_map snd entries) in
  let source = m1_protocol ^
    String.concat "" (List.map (fun name -> declaration name "Word 256") words) ^
    declaration "Storage" (collection_source "prod" fields) ^
    String.concat "" (List.map (argument_source globals) entries) ^
    declaration "Entry" (collection_source "sum" (List.map fst entries)) in
  let* () = checked_schema globals source in
  let* () = if List.for_all (fun (name, args) -> args = [] && not (typed_unit globals name)) entries
    then Error (Protocol "M1 nullary Entry needs an explicit (prod () : Type 0) argument record")
    else Ok () in
  let* storage = definition globals "storage" in
  if storage.Global.ty = Term.Global "Storage" then Ok (fields, entries)
  else Error Storage_shape

let m1_export globals name =
  let* decl = definition globals name in
  match decl.Global.ty with
  | Term.Ran (Shape.SPi ((Quantity.Many | Quantity.One), _, Term.Global "Entry"),
      Term.Lan (Shape.SMu ("Tx", []), Term.Sec (Shape.SColl 0, []))) -> Ok ()
  | Term.Var _ | Term.Univ _ | Term.Lan _ | Term.Ran _ | Term.In _ | Term.Elim _
  | Term.Sec _ | Term.Out _ | Term.Let _ | Term.Ann _ | Term.Global _ | Term.Lit _ | Term.Auto ->
    Error (Protocol "M1 export must have type Entry -> Tx")

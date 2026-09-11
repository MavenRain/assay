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
  | Nat _ | Word _ | Erased -> Ok ()
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
      | Nat _ | Erased | Struct _ | Tag _ -> Error Storage_shape) (Ok []) fields
  | Nat _ | Word _ | Erased | Tag _ -> Error Storage_shape

let storage_type globals count =
  let source = protocol ^ "def Storage : Type 0 := prod (" ^
    String.concat ", " (List.init count (fun _index -> "Word 256")) ^ ")\n" in
  let* expected, _rows = Kanon_surface.Elab.check_in Global.initial source
    |> Result.map_error (fun _error -> Storage_shape) in
  let annotated = Global.find_def "storage" globals
    |> Option.fold ~none:false ~some:(fun d -> d.Global.ty = Term.Global "Storage") in
  if annotated && Global.find "Storage" globals = Global.find "Storage" expected
  then Ok () else Error Storage_shape

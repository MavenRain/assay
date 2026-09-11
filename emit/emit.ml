(* Closed first-order specialization, followed by the M0 effect lowering.
   Every erased constructor has an explicit arm.  Higher-order values have
   a named M1 refusal.  Nat values are compile-time data only. *)
open Kanon_kernel
module R = Recognize
module A = Assay_asm.Asm
let ( let* ) = Result.bind

type error =
  | Recognizer of R.error | Missing of string | Postulate of string
  | Higher_order | Later of string | Invalid_ir of string | Nat_runtime
  | Budget | Effect_shape | Unknown_slot | Assembly of A.error

let error = function
  | Recognizer e -> R.error e
  | Missing name -> "EMIT_MISSING: " ^ name
  | Postulate name -> "EMIT_POSTULATE: " ^ name
  | Higher_order -> "EMIT_HIGHER_ORDER (M1)"
  | Later name -> "EMIT_" ^ name ^ " (M2)"
  | Invalid_ir name -> "EMIT_INVALID_IR: " ^ name
  | Nat_runtime -> "NAT_REFUSE: unbounded Nat cannot reach runtime"
  | Budget -> "EMIT_BUDGET: closed specialization limit"
  | Effect_shape -> "M0_EFFECT: expected a closed Eff program"
  | Unknown_slot -> "STORAGE_SLOT: effect references a slot outside storage"
  | Assembly e -> "EMIT_ASSEMBLY: " ^ A.error_text e

let recognize result = Result.map_error (fun e -> Recognizer e) result
type fn = { params : Eterm.repr list; result : Eterm.repr; body : Eterm.ktm }
type environment = { functions : (string * fn) list; postulates : string list }

let environment rows =
  List.fold_left (fun env (name, entry) -> match entry with
    | Erase.Dropped -> env
    | Erase.Postulate _ -> { env with postulates = name :: env.postulates }
    | Erase.Code decls -> List.fold_left (fun env decl -> match decl with
      | Eterm.KRec _ -> env
      | Eterm.KFun (Eterm.Fid name, params, result, body) ->
        { env with functions = (name, {params; result; body}) :: env.functions }) env decls)
    { functions = []; postulates = [] } rows

let at index values = Rules.at index values |> Option.to_result ~none:(Invalid_ir "index")
let tick fuel = if fuel <= 0 then Error Budget else Ok (fuel - 1)
let result_repr = function
  | Eterm.RThunk _ -> Error (Later "RTHUNK")
  | Eterm.RI31 | Eterm.RStruct _ | Eterm.RUnion _ | Eterm.RFunc _ -> Ok ()

let rec eval env locals fuel term =
  let* fuel = tick fuel in
  match term with
  | Eterm.KVar index -> let* value = at index locals in Ok (value, fuel)
  | Eterm.KLit (Literal.LInt n) -> bounded fuel n
  | Eterm.KLit (Literal.LString _) -> Error (Later "STRING")
  | Eterm.KErased -> Ok (R.Erased, fuel)
  | Eterm.KGlobal name -> call env fuel name []
  | Eterm.KLet (_, bound, body) ->
    let* value, fuel = eval env locals fuel bound in eval env (value :: locals) fuel body
  | Eterm.KClos _ -> Error Higher_order
  | Eterm.KApp (head, args) | Eterm.KTail (head, args) ->
    (match head with
     | Eterm.KGlobal name -> let* args, fuel = values env locals fuel args in call env fuel name args
     | Eterm.KVar _ | Eterm.KLit _ | Eterm.KErased | Eterm.KLet _
     | Eterm.KClos _ | Eterm.KApp _ | Eterm.KTail _ | Eterm.KStruct _
     | Eterm.KProj _ | Eterm.KTag _ | Eterm.KCase _ | Eterm.KDelay _
     | Eterm.KForce _ -> Error Higher_order)
  | Eterm.KStruct (tid, fields) ->
    let* fields, fuel = values env locals fuel fields in
    let* value = recognize (R.struct_value tid fields) in Ok (value, fuel)
  | Eterm.KTag (tid, index, fields) ->
    let* fields, fuel = values env locals fuel fields in
    let* value = recognize (R.tag tid index fields) in Ok (value, fuel)
  | Eterm.KProj (tid, index, head) ->
    let* value, fuel = eval env locals fuel head in
    (match value with
     | R.Struct (actual, fields) when actual = tid ->
       let* value = at index fields in Ok (value, fuel)
     | R.Struct _ | R.Tag _ | R.Nat _ | R.Word _ | R.Erased -> Error (Invalid_ir "projection"))
  | Eterm.KCase (tid, head, branches) ->
    let* value, fuel = eval env locals fuel head in
    (match value with
     | R.Tag (actual, tag, fields) when actual = tid ->
       branch env locals fuel tag fields branches
     | R.Word n when tid = R.word_tid -> branch env locals fuel 0 [R.Nat n] branches
     | R.Tag _ | R.Struct _ | R.Word _ | R.Nat _ | R.Erased -> Error (Invalid_ir "case"))
  | Eterm.KDelay _ -> Error (Later "KDELAY")
  | Eterm.KForce _ -> Error (Later "KFORCE")
and values env locals fuel terms =
  List.fold_left (fun result term ->
    let* values, fuel = result in let* value, fuel = eval env locals fuel term in
    Ok (values @ [value], fuel)) (Ok ([], fuel)) terms
and branch env locals fuel tag fields branches =
  let* branch = List.find_opt (fun b -> b.Eterm.tag = tag) branches
    |> Option.to_result ~none:(Invalid_ir "missing branch") in
  if List.length fields <> branch.Eterm.arity then Error (Invalid_ir "branch arity")
  else eval env (List.rev fields @ locals) fuel branch.Eterm.body
and call env fuel name args =
  let* fuel = tick fuel in
  Option.fold
    ~some:(fun fn () ->
      let* () = result_repr fn.result in
      if List.length args <> List.length fn.params then Error Higher_order
      else eval env (List.rev args) fuel fn.body)
    ~none:(fun () ->
      if List.mem name env.postulates then Error (Postulate name)
      else primitive fuel name args)
    (List.assoc_opt name env.functions) ()
and primitive fuel name args =
  match name, args with
  | "natAdd", [R.Nat a; R.Nat b] -> bounded fuel (Z.add a b)
  | "natSub", [R.Nat a; R.Nat b] -> bounded fuel (Z.max Z.zero (Z.sub a b))
  | "natMul", [R.Nat a; R.Nat b] -> bounded fuel (Z.mul a b)
  | ("natEq" | "natLt"), [R.Nat a; R.Nat b] ->
    let yes = if name = "natEq" then Z.equal a b else Z.lt a b in
    let tid = Eterm.Tid "sum<unit|unit>" in
    Ok (R.Tag (tid, (if yes then 1 else 0), []), fuel)
  | _, [] | _, _ :: _ -> Error (Missing name)
and bounded fuel value =
  if Z.numbits value > 4096 then Error Budget else Ok (R.Nat value, fuel)

type effect = Return of Z.t | Read of Z.t | Put of Z.t * Z.t * effect
let rec effect slots = function
  | R.Tag (tid, tag, fields) when tid = R.eff_tid ->
    (match tag, fields with
     | 0, [R.Word value] -> Ok (Return value)
     | 1, [R.Word slot; R.Word value; next] ->
       let* () = slot_in slots slot in let* next = effect slots next in Ok (Put (slot, value, next))
     | 2, [R.Word slot] -> let* () = slot_in slots slot in Ok (Read slot)
     | _, [] | _, _ :: _ -> Error Effect_shape)
  | R.Nat _ -> Error Nat_runtime
  | R.Word _ | R.Struct _ | R.Tag _ | R.Erased -> Error Effect_shape
and slot_in slots slot =
  if Z.sign slot >= 0 && Z.lt slot (Z.of_int slots) then Ok () else Error Unknown_slot

let push n =
  if Z.equal n Z.zero then A.Push ""
  else let hex = Z.format "%x" n in A.Push (if String.length hex land 1 = 0 then hex else "0" ^ hex)
let number n = push (Z.of_int n)
let block ?(destination=false) label body ending : A.block =
  { label; destination; stack_in = 0; body; ending }
let assemble blocks = A.assemble blocks |> Result.map_error (fun e -> Assembly e)
let return_body value = value @ [A.Push ""; A.Op "MSTORE"; number 32; A.Push ""]

(* Four unreachable guards after each write make the M0 reference layout
   explicit.  Labels and PUSH widths are resolved by the assembler. *)
let rec blocks width index marked = function
  | Return value -> [block ~destination:marked ("step" ^ string_of_int index)
      (return_body [push value]) (A.Halt A.Return)]
  | Read slot -> [block ~destination:marked ("step" ^ string_of_int index)
      (return_body [push slot; A.Op "SLOAD"]) (A.Halt A.Return)]
  | Put (slot, value, next) ->
    block ~destination:marked ("step" ^ string_of_int index)
      [push value; push slot; A.Op "SSTORE"] (A.Goto (width, "step" ^ string_of_int (index + 1))) ::
    List.init 4 (fun n -> block (Printf.sprintf "guard%d_%d" index n) [] (A.Halt A.Invalid)) @
    blocks width (index + 1) true next

let init runtime =
  let size = String.length runtime lsr 1 in
  let prefix offset = assemble [block "init"
    [number size; number offset; A.Push ""; A.Op "CODECOPY"; number size; A.Push ""] (A.Halt A.Return)] in
  let rec settle fuel offset =
    if fuel = 0 then Error Budget else
    let* program = prefix offset in
    let hex = A.hex program in let actual = String.length hex lsr 1 in
    if actual = offset then Ok (hex ^ runtime) else settle (fuel - 1) actual
  in settle 4 0

type output = { runtime : string; init : string; abi : string; layout : string;
                axioms : string; listing : string; fields : int }

let program ~contract ~export globals rows erased =
  let* () = recognize (R.schema globals) in
  let env = environment erased in
  let lookup name = Option.map (fun fn -> fn.body) (List.assoc_opt name env.functions) in
  let* storage_body = lookup "storage" |> Option.to_result ~none:(Missing "storage") in
  let* () = recognize (R.no_closure lookup [] storage_body) in
  let* storage, fuel = call env 100000 "storage" [] in
  let* fields = recognize (R.storage storage) in
  let* () = recognize (R.storage_type globals (List.length fields)) in
  let* value, _fuel = call env fuel export [] in
  let* () = recognize (R.unboxed value) in
  let* effect = effect (List.length fields) value in
  let* wide = assemble (blocks 2 0 false effect) in
  let size = String.length (A.hex wide) lsr 1 in
  let* program = if size <= 255 then assemble (blocks 1 0 false effect) else Ok wide in
  let runtime = A.hex program in
  let* () = if String.length runtime > 2 * 24576 then Error Budget else Ok () in
  let* init = init runtime in
  let* listing = Assay_asm.Listing.render runtime
    |> Result.map_error (fun _error -> Invalid_ir "generated listing") in
  let axioms = Kanon_surface.Elab.axiom_names rows in
  Ok { runtime; init; abi = Assay_abi.Abi.empty;
       layout = Assay_abi.Layout.print ~contract fields;
       axioms = String.concat "" (List.map (fun name -> name ^ "\n") axioms);
       listing; fields = List.length fields }

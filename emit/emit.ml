(* Closed specialization for M0, and static continuations for M1 entries.
   Every erased constructor has an explicit arm. Nat values remain
   compile-time data; runtime Word values become memory snapshots. *)
open Kanon_kernel
module R = Recognize
module A = Assay_asm.Asm
let ( let* ) = Result.bind

type error =
  | Recognizer of R.error | Missing of string | Postulate of string
  | Higher_order | Later of string | Invalid_ir of string | Nat_runtime
  | Budget | Effect_shape | Unknown_slot | Assembly of A.error
  | M1_shape of string | Selector_collision of string

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
  | M1_shape detail -> "M1_EMIT: " ^ detail
  | Selector_collision selector -> "ABI_SELECTOR_COLLISION: " ^ selector
let recognize result = Result.map_error (fun e -> Recognizer e) result
type fn = { params : Eterm.repr list; result : Eterm.repr; body : Eterm.ktm }
type environment = { functions : (string * fn) list; postulates : string list; runtime : bool;
                     context_tags : (int * unit R.context) list; payable_tag : int option }
let environment ?(runtime=false) rows =
  List.fold_left (fun env (name, entry) -> match entry with
    | Erase.Dropped -> env
    | Erase.Postulate _ -> { env with postulates = name :: env.postulates }
    | Erase.Code decls -> List.fold_left (fun env decl -> match decl with
      | Eterm.KRec _ -> env
      | Eterm.KFun (Eterm.Fid name, params, result, body) ->
        { env with functions = (name, {params; result; body}) :: env.functions }) env decls)
    { functions = []; postulates = []; runtime; context_tags = []; payable_tag = None } rows
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
  | Eterm.KClos (Eterm.Fid name, arity, captures) ->
    if not env.runtime then Error Higher_order else
    let* captures, fuel = values env locals fuel captures in
    Ok (R.Closure (name, arity, captures), fuel)
  | Eterm.KApp (head, args) | Eterm.KTail (head, args) ->
    (match head with
     | Eterm.KGlobal name -> let* args, fuel = values env locals fuel args in call env fuel name args
     | Eterm.KVar _ | Eterm.KLit _ | Eterm.KErased | Eterm.KLet _
     | Eterm.KClos _ | Eterm.KApp _ | Eterm.KTail _ | Eterm.KStruct _
     | Eterm.KProj _ | Eterm.KTag _ | Eterm.KCase _ | Eterm.KDelay _
     | Eterm.KForce _ ->
       if not env.runtime then Error Higher_order else
       let* head, fuel = eval env locals fuel head in
       let* args, fuel = values env locals fuel args in apply env fuel head args)
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
     | R.Struct _ | R.Tag _ | R.Nat _ | R.Word _ | R.Erased | R.Runtime_word _ | R.Closure _ ->
       Error (Invalid_ir "projection"))
  | Eterm.KCase (tid, head, branches) ->
    let* value, fuel = eval env locals fuel head in
    (match value with
     | R.Tag (actual, tag, fields) when actual = tid ->
       branch env locals fuel tag fields branches
     | R.Word n when tid = R.word_tid -> branch env locals fuel 0 [R.Nat n] branches
     | R.Runtime_word _ -> Error Nat_runtime
     | R.Tag _ | R.Struct _ | R.Word _ | R.Nat _ | R.Erased | R.Closure _ -> Error (Invalid_ir "case"))
  | Eterm.KDelay _ -> Error (Later "KDELAY")
  | Eterm.KForce _ -> Error (Later "KFORCE")
and values env locals fuel terms =
  List.fold_left (fun result term ->
    let* values, fuel = result in let* value, fuel = eval env locals fuel term in
    Ok (values @ [value], fuel)) (Ok ([], fuel)) terms
and apply env fuel head args =
  match head with
  | R.Closure (name, arity, captures) when env.runtime && arity = List.length args ->
    call env fuel name (captures @ args)
  | R.Nat _ | R.Word _ | R.Runtime_word _ | R.Erased | R.Struct _ | R.Tag _ | R.Closure _ ->
    Error Higher_order
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
            | Deployer of Z.t * effect
let rec effect slots = function
  | R.Tag (tid, tag, fields) when tid = R.eff_tid ->
    (match tag, fields with
     | 0, [R.Word value] -> Ok (Return value)
     | 1, [R.Word slot; R.Word value; next] ->
       let* () = slot_in slots slot in let* next = effect slots next in Ok (Put (slot, value, next))
     | 2, [R.Word slot] -> let* () = slot_in slots slot in Ok (Read slot)
     | 3, [R.Word slot; next] ->
       let* () = slot_in slots slot in let* next = effect slots next in Ok (Deployer (slot, next))
     | _, [] | _, _ :: _ -> Error Effect_shape)
  | R.Nat _ -> Error Nat_runtime
  | R.Word _ | R.Struct _ | R.Tag _ | R.Erased | R.Runtime_word _ | R.Closure _ -> Error Effect_shape
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
  | Deployer (slot, next) ->
    block ~destination:marked ("step" ^ string_of_int index)
      [A.Op "CALLER"; push slot; A.Op "SSTORE"] (A.Goto (width, "step" ^ string_of_int (index + 1))) ::
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

let prepare_m0 ~export globals erased =
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
  Ok (effect, fields)

let output ~contract ~listing_error ~make_init ~abi fields rows program =
  let runtime = A.hex program in
  let* () = if String.length runtime > 2 * 24576 then Error Budget else Ok () in
  let* init = make_init runtime in
  let* listing = Assay_asm.Listing.render runtime
    |> Result.map_error (fun _error -> Invalid_ir listing_error) in
  Ok {runtime; init; abi; listing; fields = List.length fields;
      layout = Assay_abi.Layout.print ~contract fields;
      axioms = String.concat "" (List.map (fun name -> name ^ "\n") (Kanon_surface.Elab.axiom_names rows))}
let program_m0 ~contract ~export globals rows erased =
  let* effect, fields = prepare_m0 ~export globals erased in
  let* wide = assemble (blocks 2 0 false effect) in
  let size = String.length (A.hex wide) lsr 1 in
  let* program = if size <= 255 then assemble (blocks 1 0 false effect) else Ok wide in
  output ~contract ~listing_error:"generated listing" ~make_init:init ~abi:Assay_abi.Abi.empty fields rows program

type operand = Constant of Z.t | Memory of int
type arithmetic = Add | Sub
type transaction = Finish of operand | Abort
  | Reject of string * operand list
  | Store of Z.t * operand * transaction
  | Load of Z.t * int * transaction
  | Context of operand R.context * int * transaction
  | Arithmetic of arithmetic * operand * operand * int * transaction * transaction
  | Compute of arithmetic * operand * operand * int * transaction
  | Compare of operand * operand * transaction * transaction
let operand = function
  | R.Word value -> Ok (Constant value)
  | R.Runtime_word offset -> Ok (Memory offset)
  | R.Nat _ -> Error Nat_runtime
  | R.Struct _ | R.Tag _ | R.Erased | R.Closure _ -> Error (M1_shape "expected Word operand")
let static_slot slots = function
  | R.Word slot -> let* () = slot_in slots slot in Ok slot
  | R.Nat _ | R.Runtime_word _ | R.Struct _ | R.Tag _ | R.Erased | R.Closure _ ->
    Error Unknown_slot
let result_tid = Eterm.Tid "sum<union mu<Word>|unit>"
let tuple_tid count = Eterm.Tid ("tuple<" ^
  String.concat "," (List.init count (fun _index -> "union mu<Word>")) ^ ">")
let entry_tid entries = Eterm.Tid ("sum<" ^ String.concat "|"
  (List.map (fun (_name, inputs) -> if inputs = [] then "unit"
    else "struct " ^ Eterm.tid_text (tuple_tid (List.length inputs))) entries) ^ ">")
let error_table declarations =
  List.fold_left (fun result (error_name, arguments) ->
    let* errors = result in
    let row : Assay_abi.Abi.custom_error = {error_name; arguments} in
    let selector = Assay_keccak.Keccak.selector (Assay_abi.Abi.error_signature row) in
    if selector = "00000000" || selector = "ffffffff" then Error (M1_shape "reserved error selector")
    else if List.exists (fun (_row, prior) -> prior = selector) errors then Error (Selector_collision selector)
    else Ok (errors @ [row, selector])) (Ok []) declarations
let error_value errors = function
  | R.Tag (tid, index, fields) ->
    let declarations = List.map (fun (row, _selector) -> row.Assay_abi.Abi.error_name, row.arguments) errors in
    if tid <> entry_tid declarations then Error (M1_shape "Error variant") else
    let* row, selector = at index errors in
    let count = List.length row.Assay_abi.Abi.arguments in
    let* values = match fields with
      | [] when count = 0 -> Ok []
      | [R.Struct (tid, values)] when tid = tuple_tid count && List.length values = count -> Ok values
      | [] | _ :: _ -> Error (M1_shape "Error arguments") in
    let* values = List.fold_left (fun result value ->
      let* values = result in let* value = operand value in Ok (values @ [value])) (Ok []) values in
    Ok (Reject (selector, values))
  | R.Word _ | R.Runtime_word _ | R.Struct _ | R.Nat _ | R.Erased | R.Closure _ ->
    Error (M1_shape "expected Error variant")

(* Both result legs are specialized. Fresh memory words hold snapshots,
   so a later store cannot change the value of an earlier load. *)
let rec transaction env errors slots depth fuel fresh value =
  let* fuel = tick fuel in
  if depth > 128 || fresh > 1024 then Error Budget else
  let lower = transaction env errors slots (depth + 1) in
  let continuation fuel fresh fn arg =
    let* value, fuel = apply env fuel fn [arg] in lower fuel fresh value in
  match value with
  | R.Tag (Eterm.Tid "mu<Tx>", tag, fields) ->
    (match tag, fields with
     | 0, [value] -> let* value = operand value in Ok (Finish value, fuel, fresh)
     | 1, [slot; value; next] ->
       let* slot = static_slot slots slot in let* value = operand value in
       let* next, fuel, fresh = lower fuel fresh next in Ok (Store (slot, value, next), fuel, fresh)
     | 2, [slot; fn] ->
       let* slot = static_slot slots slot in
       let* next, fuel, next_fresh = continuation fuel (fresh + 1) fn (R.Runtime_word fresh) in
       Ok (Load (slot, fresh, next), fuel, next_fresh)
     | (3 | 4), [left; right; fn] ->
       let* left = operand left in let* right = operand right in
       let* yes, fuel, next_fresh = continuation fuel (fresh + 1) fn
         (R.Tag (result_tid, 0, [R.Runtime_word fresh])) in
       let* no, fuel, next_fresh = continuation fuel next_fresh fn (R.Tag (result_tid, 1, [])) in
       Ok (Arithmetic ((if tag = 3 then Add else Sub), left, right, fresh, yes, no), fuel, next_fresh)
     | 5, [left; right; yes; no] ->
       let* left = operand left in let* right = operand right in
       let* yes, fuel, fresh = lower fuel fresh yes in
       let* no, fuel, fresh = lower fuel fresh no in Ok (Compare (left, right, yes, no), fuel, fresh)
     | 6, [] -> Ok (Abort, fuel, fresh)
     | tag, _fields when Some tag = env.payable_tag ->
       Error (M1_shape "payable must wrap the complete entry")
     | tag, fields when List.mem_assoc tag env.context_tags ->
       let* source = List.assoc_opt tag env.context_tags |> Option.to_result ~none:(M1_shape "context tag") in
       let* source, fn = match source, fields with
         | R.Caller, [fn] -> Ok (R.Caller, fn)
         | R.Callvalue, [fn] -> Ok (R.Callvalue, fn)
         | R.Calldatasize, [fn] -> Ok (R.Calldatasize, fn)
         | R.Calldataload (), [offset; fn] -> let* offset = operand offset in Ok (R.Calldataload offset, fn)
         | (R.Caller | R.Callvalue | R.Calldatasize | R.Calldataload ()), _ -> Error (M1_shape "context arguments") in
       let* next, fuel, next_fresh = continuation fuel (fresh + 1) fn (R.Runtime_word fresh) in
       Ok (Context (source, fresh, next), fuel, next_fresh)
     | 7, [value] -> let* tx = error_value errors value in Ok (tx, fuel, fresh)
     | tag, [left; right; fn; no] when tag = (if errors = [] then 7 else 8) || tag = (if errors = [] then 8 else 9) ->
       let addition = tag = (if errors = [] then 8 else 9) in
       let* left = operand left in let* right = operand right in
       let* value, fuel = apply env fuel fn [] in
       let index = fresh in
       let* yes, fuel, fresh = lower fuel (fresh + if addition then 1 else 0) value in
       let* no, fuel, fresh = lower fuel fresh no in
       Ok ((if addition then Arithmetic (Add, left, right, index, yes, no)
         else Compare (left, right, yes, no)), fuel, fresh)
     | tag, [left; right; fn] when tag = (if errors = [] then 9 else 10) || tag = (if errors = [] then 10 else 11) ->
       let op = if tag = (if errors = [] then 9 else 10) then Add else Sub in
       let* left = operand left in let* right = operand right in
       let* next, fuel, next_fresh = continuation fuel (fresh + 1) fn (R.Runtime_word fresh) in
       Ok (Compute (op, left, right, fresh, next), fuel, next_fresh)
     | _, [] | _, _ :: _ -> Error (M1_shape "Tx constructor"))
  | R.Nat _ -> Error Nat_runtime
  | R.Word _ | R.Runtime_word _ | R.Struct _ | R.Tag _ | R.Erased | R.Closure _ ->
    Error (M1_shape "expected Tx")
let memory index = number (32 * index)
let read_operand = function
  | Constant value -> [push value]
  | Memory index -> [memory index; A.Op "MLOAD"]
let save index = [memory index; A.Op "MSTORE"]
let goto label = A.Goto (2, label)
let branch_to yes no = A.Branch (2, yes, no)
let marked label body ending = block ~destination:true label body ending

let rec transaction_blocks label tx =
  let continue body next = marked label body (goto (label ^ "n")) :: transaction_blocks (label ^ "n") next in
  match tx with
  | Finish value -> [marked label (return_body (read_operand value)) (A.Halt A.Return)]
  | Abort -> [marked label [number 0; number 0] (A.Halt A.Revert)]
  | Reject (selector, values) ->
    (* The error buffer follows all 1024 snapshot words, including aliased arguments. *)
    let base = 32 * 1024 in
    let header = [A.Push selector; number 224; A.Op "SHL"; number base; A.Op "MSTORE"] in
    let payload = List.concat (List.mapi (fun index value ->
      read_operand value @ [number (base + 4 + 32 * index); A.Op "MSTORE"]) values) in
    [marked label (header @ payload @ [number (4 + 32 * List.length values); number base]) (A.Halt A.Revert)]
  | Store (slot, value, next) -> continue (read_operand value @ [push slot; A.Op "SSTORE"]) next
  | Load (slot, index, next) -> continue ([push slot; A.Op "SLOAD"] @ save index) next
  | Context (source, index, next) ->
    let prefix = match source with R.Calldataload offset -> read_operand offset
      | R.Caller | R.Callvalue | R.Calldatasize -> [] in
    continue (prefix @ [A.Op (String.uppercase_ascii (R.context_name source))] @ save index) next
  | Compute (op, left, right, index, next) ->
    let compute = match op with
      | Add -> read_operand left @ read_operand right @ [A.Op "ADD"]
      | Sub -> read_operand right @ read_operand left @ [A.Op "SUB"] in
    continue (compute @ save index) next
  | Arithmetic (op, left, right, index, yes, no) ->
    let compute, rejected = match op with
      | Add -> read_operand left @ read_operand right @ [A.Op "ADD"],
          read_operand left @ read_operand (Memory index) @ [A.Op "LT"]
      | Sub -> read_operand right @ read_operand left @ [A.Op "SUB"],
          read_operand left @ read_operand right @ [A.Op "GT"] in
    marked label (compute @ save index @ rejected) (branch_to (label ^ "e") (label ^ "v")) ::
    transaction_blocks (label ^ "v") yes @ transaction_blocks (label ^ "e") no
  | Compare (left, right, yes, no) ->
    marked label (read_operand right @ read_operand left @ [A.Op "GT"])
      (branch_to (label ^ "e") (label ^ "v")) ::
    transaction_blocks (label ^ "v") yes @ transaction_blocks (label ^ "e") no
let rec readonly = function
  | Finish _ | Abort | Reject _ -> true
  | Store _ -> false
  | Load (_, _, next) | Context (_, _, next) | Compute (_, _, _, _, next) -> readonly next
  | Arithmetic (_, _, _, _, yes, no) | Compare (_, _, yes, no) -> readonly yes && readonly no

type entry = { abi_entry : Assay_abi.Abi.entry; selector : string; tx : transaction }
let entries env errors slots fuel export declarations =
  let tid = entry_tid declarations in
  let* fn = List.assoc_opt export env.functions |> Option.to_result ~none:(Missing export) in
  if fn.params <> [Eterm.RUnion tid] || fn.result <> Eterm.RUnion (Eterm.Tid "mu<Tx>")
  then Error (M1_shape "export must have type Entry -> Tx") else
  List.fold_left (fun result (index, (name, inputs)) ->
    let* entries, fuel = result in
    let args = List.mapi (fun index _name -> R.Runtime_word (index + 1)) inputs in
    let payload = if args = [] then [] else [R.Struct (tuple_tid (List.length args), args)] in
    let* value, fuel = call env fuel export [R.Tag (tid, index, payload)] in
    let* () = recognize (R.unboxed value) in
    let payable, value = match value with
      | R.Tag (Eterm.Tid "mu<Tx>", tag, [next]) when Some tag = env.payable_tag -> true, next
      | R.Tag _ | R.Nat _ | R.Word _ | R.Erased | R.Runtime_word _ | R.Closure _ | R.Struct _ -> false, value in
    let* tx, fuel, _fresh = transaction env errors slots 0 fuel (List.length args + 1) value in
    let mutability = if payable then Assay_abi.Abi.Payable
      else if readonly tx then Assay_abi.Abi.View else Assay_abi.Abi.Nonpayable in
    let abi_entry : Assay_abi.Abi.entry = { name; inputs; mutability } in
    let selector = Assay_keccak.Keccak.selector (Assay_abi.Abi.signature abi_entry) in
    if List.exists (fun entry -> entry.selector = selector) entries then Error (Selector_collision selector)
    else Ok (entries @ [{abi_entry; selector; tx}], fuel)) (Ok ([], fuel))
    (List.mapi (fun index row -> index, row) declarations)

let dispatch_blocks ?fallback entries =
  let mixed = List.exists (fun entry -> Assay_abi.Abi.accepts_value entry.abi_entry) entries in
  let default, fallback_blocks = match Option.value fallback ~default:Abort with
    | Abort -> "reject", []
    | (Finish _ | Reject _ | Load _ | Context _ | Store _ | Arithmetic _ | Compare _ | Compute _) as tx ->
      "fallback", transaction_blocks "fallback" tx in
  let default, fallback_blocks = if mixed && default <> "reject" then
    "fallbackValue", marked "fallbackValue" [A.Op "CALLVALUE"]
      (branch_to "reject" default) :: fallback_blocks
    else default, fallback_blocks in
  let entry_label index = "entry" ^ string_of_int index in
  let select_label index = "select" ^ string_of_int index in
  let selects = List.concat (List.mapi (fun index entry ->
    let next = if index + 1 = List.length entries then default else select_label (index + 1) in
    [marked (select_label index) [memory 0; A.Op "MLOAD"; A.Push entry.selector; A.Op "EQ"]
      (branch_to (entry_label index) next)]) entries) in
  let bodies = List.concat (List.mapi (fun index entry ->
    let label = entry_label index in
    let guards, arity_label = if mixed && not (Assay_abi.Abi.accepts_value entry.abi_entry) then
      [marked label [A.Op "CALLVALUE"] (branch_to "reject" (label ^ "arity"))], label ^ "arity"
      else [], label in
    let decoder = List.concat (List.mapi (fun index _input ->
      [number (4 + 32 * index); A.Op "CALLDATALOAD"] @ save (index + 1)) entry.abi_entry.inputs) in
    guards @ [marked arity_label [number (4 + 32 * List.length entry.abi_entry.inputs); A.Op "CALLDATASIZE"; A.Op "LT"]
      (branch_to "reject" (label ^ "decode"));
    marked (label ^ "decode") decoder (goto (label ^ "body"))] @
    transaction_blocks (label ^ "body") entry.tx) entries) in
  (if mixed then [] else [block "nonpayable" [A.Op "CALLVALUE"] (branch_to "reject" "head")]) @
  [block ~destination:(not mixed) "head" [number 4; A.Op "CALLDATASIZE"; A.Op "LT"] (branch_to default "selector");
   marked "selector" [number 0; A.Op "CALLDATALOAD"; number 224; A.Op "SHR"; memory 0; A.Op "MSTORE"]
     (goto (select_label 0))] @ selects @ bodies @
  [marked "reject" [number 0; number 0] (A.Halt A.Revert)] @ fallback_blocks
let rec constructor_body = function
  | Return value when Z.equal value Z.zero -> Ok []
  | Put (slot, value, next) ->
    let* next = constructor_body next in Ok ([push value; push slot; A.Op "SSTORE"] @ next)
  | Deployer (slot, next) ->
    let* next = constructor_body next in Ok ([A.Op "CALLER"; push slot; A.Op "SSTORE"] @ next)
  | Return _ | Read _ -> Error (M1_shape "constructor must end with ret zero")

let init_m1 runtime constructor =
  let* body = constructor_body constructor in
  let size = String.length runtime lsr 1 in
  let prefix offset = assemble
    [block "constructor" [A.Op "CALLVALUE"] (branch_to "reject" "initialize");
     marked "initialize" (body @ [number size; number offset; number 0; A.Op "CODECOPY"; number size; number 0])
       (A.Halt A.Return);
     marked "reject" [number 0; number 0] (A.Halt A.Revert)] in
  let rec settle fuel offset =
    let* fuel = tick fuel in
    let* program = prefix offset in
    let hex = A.hex program in let actual = String.length hex lsr 1 in
    if actual = offset then Ok (hex ^ runtime) else settle fuel actual in
  settle 4 0

let prepare_m1 ~export globals erased =
  let* fields, declarations, errors = recognize (R.m1_schema globals) in
  let* errors = error_table errors in
  let* () = recognize (R.m1_export globals export) in
  let env = environment erased in
  let lookup name = Option.map (fun fn -> fn.body) (List.assoc_opt name env.functions) in
  let* body = lookup "storage" |> Option.to_result ~none:(Missing "storage") in
  let* () = recognize (R.no_closure lookup [] body) in
  let* storage, fuel = call env 100000 "storage" [] in
  let* slots = recognize (R.storage storage) in
  if List.length slots <> List.length fields then Error (Recognizer R.Storage_shape) else
  let* constructor, fuel = call env fuel "constructor" [] in
  let* constructor = effect (List.length fields) constructor in
  let context_tags = List.filter_map (fun source ->
    Option.map (fun tag -> tag, source) (R.constructor_tag globals "Tx" (R.context_name source))) R.contexts in
  let env = {env with runtime = true; context_tags; payable_tag = R.constructor_tag globals "Tx" "payable"} in
  let* entries, fuel = entries env errors (List.length fields) fuel export declarations in
  let* fallback = if Option.is_none (Global.find "fallback" globals) then Ok None else
    let* value, fuel = call env fuel "fallback" [] in
    let* () = recognize (R.unboxed value) in
    let* tx, _fuel, _fresh = transaction env errors (List.length fields) 0 fuel 1 value in
    match tx with
    | Abort -> Ok (Some tx)
    | Reject (_, values) when List.for_all (function Constant _ -> true | Memory _ -> false) values -> Ok (Some tx)
    | Finish _ | Reject _ | Load _ | Context _ | Store _ | Arithmetic _ | Compare _ | Compute _ ->
      Error (M1_shape "fallback must be a closed revert") in
  Ok (entries, constructor, fields, errors, fallback)

let program_m1 ~contract ~export globals rows erased =
  let* entries, constructor, fields, errors, fallback = prepare_m1 ~export globals erased in
  let* program = assemble (dispatch_blocks ?fallback entries) in
  let abi = Assay_abi.Abi.print ~fallback:(Option.is_some fallback) ~errors:(List.map fst errors)
    (List.map (fun entry -> entry.abi_entry) entries) in
  output ~contract ~listing_error:"generated M1 listing" ~make_init:(fun runtime -> init_m1 runtime constructor)
    ~abi fields rows program

let program ~contract ~export globals rows erased =
  if Option.is_some (Global.find "Entry" globals)
  then program_m1 ~contract ~export globals rows erased
  else program_m0 ~contract ~export globals rows erased

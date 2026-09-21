(* Interpret specialized effects with immutable storage. This shares source
   checking and specialization with Emit, but uses no opcode or assembler. *)
module E = Emit
let ( let* ) = Result.bind
type storage = (Z.t * Z.t) list
type outcome = { reverted : bool; output : string; storage : storage }
type program = Closed of E.effect | Entries of E.entry list * E.transaction
type input = { data : string; value : Z.t; caller : Z.t; initial : storage }
type error = Source of E.error | Input of string | Missing_memory of int

let error = function
  | Source e -> E.error e
  | Input detail -> "RUN_INPUT: " ^ detail
  | Missing_memory index -> "RUN_MEMORY: missing snapshot " ^ string_of_int index
let segment offset length text =
  String.to_seq text |> Seq.drop offset |> Seq.take length |> String.of_seq
let unprefix text =
  if String.starts_with ~prefix:"0x" text then segment 2 (String.length text - 2) text else text
let word text = Recognize.parse_word ~invalid:(Input "expected a decimal or 0x-prefixed uint256")
  ~overflow:(Input "word exceeds uint256") text
let calldata text =
  let digits = unprefix (String.lowercase_ascii text) in
  if String.length digits > 65536 || Int.rem (String.length digits) 2 <> 0 ||
     not (String.for_all (fun c -> (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')) digits)
  then Error (Input "calldata requires at most 32768 whole hex bytes") else Ok digits
let calldata_word data offset =
  if Z.geq offset (Z.of_int (Int.div (String.length data) 2)) then Z.zero else
  let start = 2 * Z.to_int offset in
  let length = min 64 (String.length data - start) in
  Z.of_string_base 16 (segment start length data ^ String.make (64 - length) '0')
let parse_storage rows =
  if List.length rows > 1024 then Error (Input "at most 1024 initial storage slots") else
  List.fold_left (fun result row ->
    let* slots = result in
    match String.split_on_char '=' row with
    | [key; value] ->
      let* key = word key in let* value = word value in
      if List.exists (fun (slot, _value) -> Z.equal slot key) slots
      then Error (Input "duplicate storage slot") else Ok ((key, value) :: slots)
    | [] | [_] | _ :: _ :: _ :: _ -> Error (Input "storage requires SLOT=WORD")) (Ok []) rows

let put storage slot value =
  let rest = List.filter (fun (key, _value) -> not (Z.equal key slot)) storage in
  if Z.equal value Z.zero then rest else (slot, value) :: rest
let get storage slot =
  List.find_opt (fun (key, _value) -> Z.equal key slot) storage
  |> Option.fold ~none:Z.zero ~some:snd
let canonical storage =
  List.filter (fun (_key, value) -> not (Z.equal value Z.zero)) storage
  |> List.sort (fun (left, _a) (right, _b) -> Z.compare left right)
let success storage value = { reverted = false; output = "0x" ^ Z.format "%064x" value; storage }
let revert storage = { reverted = true; output = "0x"; storage }

let inputs_with_caller ~data ~value ~storage ~caller =
  let* data = calldata data in let* value = word value in let* initial = parse_storage storage in
  let* caller = word caller in
  if Z.numbits caller > 160 then Error (Input "caller exceeds uint160")
  else Ok {data; value; caller; initial = canonical initial}

let inputs ~data ~value ~storage = inputs_with_caller ~data ~value ~storage ~caller:"0"

let rec closed caller storage = function
  | E.Return value -> success storage value
  | E.Read slot -> success storage (get storage slot)
  | E.Put (slot, value, next) -> closed caller (put storage slot value) next
  | E.Deployer (slot, next) -> closed caller (put storage slot caller) next
let operand memory = function
  | E.Constant value -> Ok value
  | E.Memory index -> List.assoc_opt index memory |> Option.to_result ~none:(Missing_memory index)

let rec transaction input storage memory = function
  | E.Finish value -> let* value = operand memory value in Ok (success storage value)
  | E.Abort -> Ok (revert input.initial)
  | E.Reject (selector, values) ->
    let* words = List.fold_left (fun result value ->
      let* words = result in let* value = operand memory value in
      Ok (words ^ Z.format "%064x" value)) (Ok "") values in
    Ok {reverted = true; output = "0x" ^ selector ^ words; storage = input.initial}
  | E.Store (slot, value, next) ->
    let* value = operand memory value in transaction input (put storage slot value) memory next
  | E.Load (slot, index, next) ->
    transaction input storage ((index, get storage slot) :: memory) next
  | E.Context (source, index, next) ->
    let* value = match source with Recognize.Caller -> Ok input.caller | Recognize.Callvalue -> Ok input.value
      | Recognize.Calldatasize -> Ok (Z.of_int (Int.div (String.length input.data) 2))
      | Recognize.Calldataload offset -> let* offset = operand memory offset in Ok (calldata_word input.data offset) in
    transaction input storage ((index, value) :: memory) next
  | E.Arithmetic (operation, left, right, index, yes, no) ->
    let* left = operand memory left in let* right = operand memory right in
    let result = match operation with E.Add -> Z.add left right | E.Sub -> Z.sub left right in
    if Z.sign result < 0 || Z.numbits result > 256
    then transaction input storage memory no
    else transaction input storage ((index, result) :: memory) yes
  | E.Compare (left, right, yes, no) ->
    let* left = operand memory left in let* right = operand memory right in
    transaction input storage memory (if Z.leq left right then yes else no)
  | E.Compute (operation, left, right, index, next) ->
    let* left = operand memory left in let* right = operand memory right in
    let result = match operation with E.Add -> Z.add left right | E.Sub -> Z.sub left right in
    if Z.sign result < 0 || Z.numbits result > 256 then Error (Source (E.M1_shape "proved arithmetic bound"))
    else transaction input storage ((index, result) :: memory) next

let prepare ~export globals erased =
  let source result = Result.map_error (fun e -> Source e) result in
  if Option.is_some (Kanon_kernel.Global.find "Entry" globals) then
    let* entries, constructor, _fields, _errors, fallback = source (E.prepare_m1 ~export globals erased) in
    let rec valid = function
      | E.Return value when Z.equal value Z.zero -> Ok ()
      | E.Put (_, _, next) -> valid next
      | E.Deployer (_, next) -> valid next
      | E.Return _ | E.Read _ -> Error (Source (E.M1_shape "constructor must end with ret zero")) in
    let* () = valid constructor in Ok (Entries (entries, Option.value fallback ~default:E.Abort))
  else let* effect, _fields = source (E.prepare_m0 ~export globals erased) in Ok (Closed effect)

(* Input is an already deployed storage image. Constructors are validated
   during preparation and are never applied to that image. *)
let run program input =
  match program with
  | Closed effect -> Ok (closed input.caller input.initial effect)
  | Entries (entries, fallback) ->
    let has_value = not (Z.equal input.value Z.zero) in
    let default = if has_value then Ok (revert input.initial)
      else transaction input input.initial [] fallback in
    if String.length input.data < 8 then default else
    let selector = segment 0 8 input.data in
    Option.fold ~none:default ~some:(fun entry ->
      if has_value && not (Assay_abi.Abi.accepts_value entry.E.abi_entry) then Ok (revert input.initial) else
      let count = List.length entry.E.abi_entry.inputs in
      if String.length input.data < 8 + 64 * count then Ok (revert input.initial) else
      let memory = List.init count (fun index ->
        index + 1, Z.of_string_base 16 (segment (8 + 64 * index) 64 input.data)) in
      transaction input input.initial memory entry.E.tx)
      (List.find_opt (fun entry -> entry.E.selector = selector) entries)
let print outcome =
  let quote = Assay_abi.Abi.quote in
  let entries = canonical outcome.storage |> List.map (fun (key, value) ->
    quote (Z.to_string key) ^ ":" ^ quote ("0x" ^ Z.format "%x" value)) in
  "{\"status\":" ^ quote (if outcome.reverted then "revert" else "success") ^
  ",\"output\":" ^ quote outcome.output ^ ",\"storage\":{" ^ String.concat "," entries ^ "}}\n"

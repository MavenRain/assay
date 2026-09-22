(* Legacy Cancun assembly.  Layout collects labels once; fixed-width label
   operands are resolved after layout. Optional compaction preserves M0's size rule.
   Stack reference: go-ethereum v1.14.12 core/vm/jump_table.go. *)
include (struct
  type instruction = Op of string | Push of string | Dup of int | Swap of int
  type halt = Stop | Return | Revert | Invalid | Selfdestruct
  type ending = Halt of halt | Goto of int * string
              | Branch of int * string * string | Next of string
  type block = { label : string; destination : bool; stack_in : int;
                 body : instruction list; ending : ending }
  type operation = { byte : int; name : string; pops : int; pushes : int }
  type error =
    | Empty_program | Empty_label | Duplicate_label of string
    | Unknown_opcode of string | Control_in_body of string
    | Invalid_push of string | Invalid_depth of string * int
    | Invalid_width of int | Invalid_height of string * int
    | Entry_height of int | Unknown_label of string
    | Not_destination of string | Label_overflow of string * int
    | Invalid_next of string * string | Code_overflow
    | Underflow of string * string * int * int
    | Overflow of string * string * int
    | Height_mismatch of string * string * int * int
  type height = { label : string; incoming : int; outgoing : int; peak : int }
  type t = { bytes : string; positions : (string * int) list; stacks : height list }
  module Labels = Map.Make (String)
  let ( let* ) = Result.bind
  let op byte name pops pushes = { byte; name; pops; pushes }
  let table = [
    op 0x00 "STOP" 0 0; op 0x01 "ADD" 2 1; op 0x02 "MUL" 2 1;
    op 0x03 "SUB" 2 1; op 0x04 "DIV" 2 1; op 0x05 "SDIV" 2 1;
    op 0x06 "MOD" 2 1; op 0x07 "SMOD" 2 1; op 0x08 "ADDMOD" 3 1;
    op 0x09 "MULMOD" 3 1; op 0x0a "EXP" 2 1; op 0x0b "SIGNEXTEND" 2 1;
    op 0x10 "LT" 2 1; op 0x11 "GT" 2 1; op 0x12 "SLT" 2 1;
    op 0x13 "SGT" 2 1; op 0x14 "EQ" 2 1; op 0x15 "ISZERO" 1 1;
    op 0x16 "AND" 2 1; op 0x17 "OR" 2 1; op 0x18 "XOR" 2 1;
    op 0x19 "NOT" 1 1; op 0x1a "BYTE" 2 1; op 0x1b "SHL" 2 1;
    op 0x1c "SHR" 2 1; op 0x1d "SAR" 2 1; op 0x20 "KECCAK256" 2 1;
    op 0x30 "ADDRESS" 0 1; op 0x31 "BALANCE" 1 1; op 0x32 "ORIGIN" 0 1;
    op 0x33 "CALLER" 0 1; op 0x34 "CALLVALUE" 0 1; op 0x35 "CALLDATALOAD" 1 1;
    op 0x36 "CALLDATASIZE" 0 1; op 0x37 "CALLDATACOPY" 3 0;
    op 0x38 "CODESIZE" 0 1; op 0x39 "CODECOPY" 3 0; op 0x3a "GASPRICE" 0 1;
    op 0x3b "EXTCODESIZE" 1 1; op 0x3c "EXTCODECOPY" 4 0;
    op 0x3d "RETURNDATASIZE" 0 1; op 0x3e "RETURNDATACOPY" 3 0;
    op 0x3f "EXTCODEHASH" 1 1; op 0x40 "BLOCKHASH" 1 1;
    op 0x41 "COINBASE" 0 1; op 0x42 "TIMESTAMP" 0 1; op 0x43 "NUMBER" 0 1;
    op 0x44 "PREVRANDAO" 0 1; op 0x45 "GASLIMIT" 0 1; op 0x46 "CHAINID" 0 1;
    op 0x47 "SELFBALANCE" 0 1; op 0x48 "BASEFEE" 0 1;
    op 0x49 "BLOBHASH" 1 1; op 0x4a "BLOBBASEFEE" 0 1;
    op 0x50 "POP" 1 0; op 0x51 "MLOAD" 1 1; op 0x52 "MSTORE" 2 0;
    op 0x53 "MSTORE8" 2 0; op 0x54 "SLOAD" 1 1; op 0x55 "SSTORE" 2 0;
    op 0x56 "JUMP" 1 0; op 0x57 "JUMPI" 2 0; op 0x58 "PC" 0 1;
    op 0x59 "MSIZE" 0 1; op 0x5a "GAS" 0 1; op 0x5b "JUMPDEST" 0 0;
    op 0x5c "TLOAD" 1 1; op 0x5d "TSTORE" 2 0; op 0x5e "MCOPY" 3 0;
    op 0xa0 "LOG0" 2 0; op 0xa1 "LOG1" 3 0; op 0xa2 "LOG2" 4 0;
    op 0xa3 "LOG3" 5 0; op 0xa4 "LOG4" 6 0; op 0xf0 "CREATE" 3 1;
    op 0xf1 "CALL" 7 1; op 0xf2 "CALLCODE" 7 1; op 0xf3 "RETURN" 2 0;
    op 0xf4 "DELEGATECALL" 6 1; op 0xf5 "CREATE2" 4 1;
    op 0xfa "STATICCALL" 6 1; op 0xfd "REVERT" 2 0;
    op 0xfe "INVALID" 0 0; op 0xff "SELFDESTRUCT" 1 0]
  let decode_opcode byte =
    match () with
    | () when byte >= 0x5f && byte <= 0x7f ->
      Some (op byte ("PUSH" ^ string_of_int (byte - 0x5f)) 0 1)
    | () when byte >= 0x80 && byte <= 0x8f ->
      let n = byte - 0x7f in Some (op byte ("DUP" ^ string_of_int n) n (n + 1))
    | () when byte >= 0x90 && byte <= 0x9f ->
      let n = byte - 0x8f in Some (op byte ("SWAP" ^ string_of_int n) (n + 1) (n + 1))
    | () -> List.find_opt (fun row -> row.byte = byte) table
  let control name = List.mem name
    ["STOP"; "JUMP"; "JUMPI"; "JUMPDEST"; "RETURN"; "REVERT"; "INVALID"; "SELFDESTRUCT"]
  let hex_char c = (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')
  let valid_hex s = String.length s land 1 = 0 && String.for_all hex_char s
  let byte_hex byte = Printf.sprintf "%02x" byte
  let instruction = function
    | Op name ->
      if control name then Error (Control_in_body name)
      else
        let* row = List.find_opt (fun row -> row.name = name) table
          |> Option.to_result ~none:(Unknown_opcode name) in
        Ok (row, byte_hex row.byte)
    | Push bytes ->
      if String.length bytes > 64 || not (valid_hex bytes) then Error (Invalid_push bytes)
      else let n = String.length bytes lsr 1 in
        let row = op (0x5f + n) ("PUSH" ^ string_of_int n) 0 1 in
        Ok (row, byte_hex row.byte ^ bytes)
    | Dup n ->
      if n < 1 || n > 16 then Error (Invalid_depth ("DUP", n))
      else let row = op (0x7f + n) ("DUP" ^ string_of_int n) n (n + 1) in
        Ok (row, byte_hex row.byte)
    | Swap n ->
      if n < 1 || n > 16 then Error (Invalid_depth ("SWAP", n))
      else let row = op (0x8f + n) ("SWAP" ^ string_of_int n) (n + 1) (n + 1) in
        Ok (row, byte_hex row.byte)
  let halt = function
    | Stop -> op 0x00 "STOP" 0 0 | Return -> op 0xf3 "RETURN" 2 0
    | Revert -> op 0xfd "REVERT" 2 0 | Invalid -> op 0xfe "INVALID" 0 0
    | Selfdestruct -> op 0xff "SELFDESTRUCT" 1 0
  let width n = if n < 1 || n > 32 then Error (Invalid_width n) else Ok n
  let ending_size = function
    | Halt _halt -> Ok 1 | Next _label -> Ok 0
    | Goto (n, _label) -> let* n = width n in Ok (n + 2)
    | Branch (n, _yes, _no) -> let* n = width n in Ok (2 * (n + 2))
  let step label (height, peak) row =
    if height < row.pops then Error (Underflow (label, row.name, height, row.pops))
    else let next = height - row.pops + row.pushes in
      if next > 1024 then Error (Overflow (label, row.name, next))
      else Ok (next, max peak next)
  let body (block : block) =
    List.fold_left (fun acc item ->
      let* (state, chunks, size) = acc in
      let* (row, bytes) = instruction item in
      let* state = step block.label state row in
      let length = String.length bytes lsr 1 in
      if size > max_int - length then Error Code_overflow
      else Ok (state, bytes :: chunks, size + length))
      (Ok ((block.stack_in, block.stack_in), [], 0)) block.body
  let layout blocks =
    List.fold_left (fun acc (block : block) ->
      let* (pc, labels, prepared) = acc in
      match () with
      | () when block.label = "" -> Error Empty_label
      | () when Labels.mem block.label labels -> Error (Duplicate_label block.label)
      | () when block.stack_in < 0 || block.stack_in > 1024 ->
        Error (Invalid_height (block.label, block.stack_in))
      | () ->
        let* (state, chunks, size) = body block in
        let* tail = ending_size block.ending in
        let overhead = tail + (if block.destination then 1 else 0) in
        if size > max_int - overhead || pc > max_int - size - overhead then Error Code_overflow
        else Ok (pc + size + overhead, Labels.add block.label (pc, block) labels,
                 (block, state, List.rev chunks) :: prepared))
      (Ok (0, Labels.empty, [])) blocks
  let target labels source height name =
    let* (pc, block) = Labels.find_opt name labels |> Option.to_result ~none:(Unknown_label name) in
    if height <> block.stack_in then
      Error (Height_mismatch (source, name, height, block.stack_in))
    else Ok (pc, block)
  let address labels source height n name =
    let* (pc, block) = target labels source height name in
    if not block.destination then Error (Not_destination name)
    else let digits = Printf.sprintf "%x" pc in
      if String.length digits > n * 2 then Error (Label_overflow (name, n))
      else Ok (byte_hex (0x5f + n) ^ String.make (n * 2 - String.length digits) '0' ^ digits)
  let finish labels (block : block) state next =
    let (height, _peak) = state in
    match block.ending with
    | Halt ending ->
      let row = halt ending in
      let* state = step block.label state row in Ok (state, byte_hex row.byte)
    | Next name ->
      if next <> Some name then Error (Invalid_next (block.label, name))
      else let* _target = target labels block.label height name in Ok (state, "")
    | Goto (n, name) ->
      let* pushed = step block.label state (op (0x5f + n) "PUSH-label" 0 1) in
      let* state = step block.label pushed (op 0x56 "JUMP" 1 0) in
      let* bytes = address labels block.label height n name in Ok (state, bytes ^ "56")
    | Branch (n, yes, no) ->
      let* pushed = step block.label state (op (0x5f + n) "PUSH-label" 0 1) in
      let* state = step block.label pushed (op 0x57 "JUMPI" 2 0) in
      let (outgoing, _peak) = state in
      let* yes_bytes = address labels block.label outgoing n yes in
      let* no_bytes = address labels block.label outgoing n no in
      Ok (state, yes_bytes ^ "57" ^ no_bytes ^ "56")
  let assemble blocks =
    match blocks with
    | [] -> Error Empty_program
    | first :: _rest ->
      if first.stack_in <> 0 then Error (Entry_height first.stack_in)
      else
        let* (_size, labels, reverse) = layout blocks in
        let rec encode acc stacks = function
          | [] -> Ok { bytes = String.concat "" (List.rev acc);
                       positions = Labels.bindings labels |> List.map (fun (name, (pc, _b)) -> name, pc);
                       stacks = List.rev stacks }
          | ((block : block), state, chunks) :: rest ->
            let next = match rest with [] -> None | (b, _s, _c) :: _tail -> Some b.label in
            let* ((outgoing, peak), tail) = finish labels block state next in
            let bytes = (if block.destination then "5b" else "") ^ String.concat "" chunks ^ tail in
            encode (bytes :: acc)
              ({ label = block.label; incoming = block.stack_in; outgoing; peak } :: stacks) rest in
        encode [] [] (List.rev reverse)
  (* Size valid instructions without assembling a second program. Invalid
     inputs still go through assemble, which retains the original diagnostic.
     M0 shrinks two-byte labels only when the complete wide code fits in 255 bytes. *)
  let assemble_compact blocks =
    let size, reverse = List.fold_left (fun (size, acc) (block : block) ->
      let bytes = List.fold_left (fun total -> function
        | Push bytes -> total + 1 + (String.length bytes lsr 1)
        | Op _ | Dup _ | Swap _ -> total + 1)
        ((if block.destination then 1 else 0) + Result.value (ending_size block.ending) ~default:256) block.body in
      let ending = match block.ending with
        | Goto (2, label) -> Goto (1, label)
        | Branch (2, yes, no) -> Branch (1, yes, no)
        | Goto _ | Branch _ | Halt _ | Next _ -> block.ending in
      min 256 (size + bytes), { block with ending } :: acc) (0, []) blocks in
    let wide () = assemble blocks in
    if size > 255 then wide () else
    assemble (List.rev reverse) |> Result.fold ~error:(fun _error -> wide ()) ~ok:Result.ok
  let hex program = program.bytes
  let labels program = program.positions
  let heights program = program.stacks
  let error_text = function
    | Empty_program -> "EMPTY-PROGRAM" | Empty_label -> "EMPTY-LABEL"
    | Duplicate_label s -> "DUPLICATE-LABEL " ^ s
    | Unknown_opcode s -> "UNKNOWN-OPCODE " ^ s | Control_in_body s -> "CONTROL-IN-BODY " ^ s
    | Invalid_push s -> "INVALID-PUSH " ^ s
    | Invalid_depth (s, n) -> Printf.sprintf "INVALID-DEPTH %s %d" s n
    | Invalid_width n -> Printf.sprintf "INVALID-WIDTH %d" n
    | Invalid_height (s, n) -> Printf.sprintf "INVALID-HEIGHT %s %d" s n
    | Entry_height n -> Printf.sprintf "ENTRY-HEIGHT %d" n
    | Unknown_label s -> "UNKNOWN-LABEL " ^ s | Not_destination s -> "NOT-DESTINATION " ^ s
    | Label_overflow (s, n) -> Printf.sprintf "LABEL-OVERFLOW %s PUSH%d" s n
    | Invalid_next (s, t) -> Printf.sprintf "INVALID-NEXT %s %s" s t
    | Code_overflow -> "CODE-OVERFLOW"
    | Underflow (s, op, got, need) -> Printf.sprintf "UNDERFLOW %s %s got=%d need=%d" s op got need
    | Overflow (s, op, got) -> Printf.sprintf "OVERFLOW %s %s got=%d" s op got
    | Height_mismatch (s, t, got, want) ->
      Printf.sprintf "HEIGHT-MISMATCH %s %s got=%d want=%d" s t got want
end : sig
  type instruction = Op of string | Push of string | Dup of int | Swap of int
  type halt = Stop | Return | Revert | Invalid | Selfdestruct
  type ending = Halt of halt | Goto of int * string
              | Branch of int * string * string | Next of string
  type block = { label : string; destination : bool; stack_in : int;
                 body : instruction list; ending : ending }
  type operation = { byte : int; name : string; pops : int; pushes : int }
  type error =
    | Empty_program | Empty_label | Duplicate_label of string
    | Unknown_opcode of string | Control_in_body of string
    | Invalid_push of string | Invalid_depth of string * int
    | Invalid_width of int | Invalid_height of string * int
    | Entry_height of int | Unknown_label of string
    | Not_destination of string | Label_overflow of string * int
    | Invalid_next of string * string | Code_overflow
    | Underflow of string * string * int * int
    | Overflow of string * string * int
    | Height_mismatch of string * string * int * int
  type height = { label : string; incoming : int; outgoing : int; peak : int }
  type t
  (** Byte strings use lowercase, prefix-free hex.  Push "" emits PUSH0.
      Each block declares its incoming height, including unreachable blocks.
      The first block starts with an empty stack.  A marked block emits JUMPDEST.
      Every edge must match the destination height.  Next must name the next
      physical block.  Goto and Branch require marked targets and explicit
      PUSH widths in 1..32.  Branch consumes its condition on both paths.
      All stack heights, including temporary label pushes, stay in 0..1024.
      Dynamic jumps and control instructions in a body are refused. *)
  val assemble : block list -> (t, error) result
  val assemble_compact : block list -> (t, error) result
  val hex : t -> string
  val labels : t -> (string * int) list
  val heights : t -> height list
  val error_text : error -> string
  (** Complete Cancun opcode metadata, including PUSH, DUP and SWAP families. *)
  val decode_opcode : int -> operation option
end)

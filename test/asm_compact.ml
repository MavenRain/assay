module A = Assay_asm.Asm

let block ?(destination=false) ?(body=[]) label ending : A.block =
  { label; destination; stack_in = 0; body; ending }
let padding count = List.init count (fun index ->
  block ("padding" ^ string_of_int index) (A.Halt A.Invalid))
let jump width count =
  block "start" (A.Goto (width, "finish")) :: padding count @
  [block ~destination:true "finish" (A.Halt A.Stop)]
let branch width count =
  block ~body:[A.Push ""] "start" (A.Branch (width, "yes", "no")) :: padding count @
  [block ~destination:true "yes" (A.Halt A.Stop);
   block ~destination:true "no" (A.Halt A.Stop)]
let observe = Result.map (fun program -> A.hex program, A.labels program, A.heights program)
let check name wide narrow =
  (* The previous emitter assembled wide first, then selected compact code
     using the total wide byte length, including unreachable padding. *)
  let expected = Result.bind (A.assemble wide) (fun program ->
    if String.length (A.hex program) <= 510 then A.assemble narrow else Ok program) in
  if observe (A.assemble_compact wide) = observe expected then 1
  else (prerr_endline ("ASM-COMPACT FAIL " ^ name); exit 1)
let mixed width =
  [block "start" (A.Goto (3, "middle"));
   block ~destination:true "middle" (A.Goto (width, "finish"));
   block ~destination:true "finish" (A.Halt A.Stop)]
let payload width count bytes =
  block ~body:[A.Push (String.make (2 * bytes) 'a'); A.Op "POP"] "start" (A.Goto (width, "finish")) ::
  padding count @ [block ~destination:true "finish" (A.Halt A.Stop)]
let () =
  let cases = List.fold_left (fun total count ->
    total + check ("jump-" ^ string_of_int count) (jump 2 count) (jump 1 count)
    + check ("branch-" ^ string_of_int count) (branch 2 count) (branch 1 count))
    0 (List.init 271 Fun.id) in
  let cases = List.fold_left (fun total bytes ->
    total + check ("payload-255-" ^ string_of_int bytes)
      (payload 2 (247 - bytes) bytes) (payload 1 (247 - bytes) bytes)
    + check ("payload-256-" ^ string_of_int bytes)
      (payload 2 (248 - bytes) bytes) (payload 1 (248 - bytes) bytes)) cases (List.init 33 Fun.id) in
  let stop = block "stop" (A.Halt A.Stop) in
  let fixed name blocks = name, blocks, blocks in
  let extra = [
    fixed "empty" [];
    fixed "unknown-opcode" [{ stop with body = [A.Op "NOPE"] }];
    fixed "duplicate" [stop; stop];
    "missing-label", [block "start" (A.Goto (2, "missing"))],
      [block "start" (A.Goto (1, "missing"))];
    "not-destination", [block "start" (A.Goto (2, "stop")); stop],
      [block "start" (A.Goto (1, "stop")); stop];
    fixed "entry-height" [{ stop with stack_in = 1 }];
    fixed "invalid-width" [block ~destination:true "start" (A.Goto (0, "start"))];
    fixed "underflow" [{ stop with body = [A.Op "POP"] }];
    fixed "invalid-next" [block "start" (A.Next "missing"); stop];
    "mixed", mixed 2, mixed 1
  ] in
  let cases = List.fold_left (fun total (name, wide, narrow) ->
    total + check name wide narrow) cases extra in
  A.assemble_compact (jump 2 0) |> Result.fold
    ~error:(fun error -> prerr_endline (A.error_text error); exit 1)
    ~ok:(fun program -> if A.hex program <> "6003565b00" then exit 1);
  Printf.printf "ASM-COMPACT cases=%d OK\n" cases

(** Assay checker, erasure, axiom disclosure and M0 EVM emission.
    Exit 2 names an emission refusal;
    exit 3 names a subcommand that is declared and not yet implemented;
    exit 64 names invalid arguments, an unaccepted suffix or a missing
    input. *)

let usage () : unit =
  prerr_endline
    "usage: assay check [--print|--erased] FILE | axioms FILE | spec-count | \
     emit FILE -o DIR | trace FILE --calldata HEX [--prestate FILE] | diff FILE --calldata HEX [--prestate FILE] | \
     run FILE [--calldata HEX] [--storage SLOT=WORD]... [--value WORD] [--caller ADDRESS] [--export NAME] | deploy FILE | \
     test FILE"

let bad_usage () : unit = usage (); exit 64

(* R-M0-1: a source file ends in .asy.  The inherited .kan fixtures stay
   readable, so the carried examples check unchanged. *)
let accepted_suffix (path : string) : bool =
  List.exists
    (fun suffix -> Filename.check_suffix path suffix)
    [ ".asy"; ".kan" ]

(* Preserve the inherited file boundary.  The existence check is not an
   atomic read; OS failures during the read retain the inherited behavior. *)
let read_file (path : string) : string =
  match () with
  | () when not (Sys.file_exists path) || Sys.is_directory path ->
      prerr_endline ("assay: cannot read " ^ path); exit 64
  | () when not (accepted_suffix path) ->
      prerr_endline ("assay: " ^ path ^ ": expected a .asy or .kan source");
      exit 64
  | () -> In_channel.with_open_bin path In_channel.input_all

let checked_in (path : string) :
    string * Kanon_kernel.Global.t * (string * Kanon_kernel.Global.entry) list =
  let source = Assay_emit.Contract.lower (read_file path) in
  Result.bind source (fun (name, source) ->
    Kanon_surface.Elab.check_in Kanon_kernel.Global.initial source
    |> Result.map (fun (globals, rows) ->
      Option.value ~default:(Filename.remove_extension (Filename.basename path)) name,
      globals, rows))
  |> Result.fold ~ok:Fun.id
       ~error:(fun e ->
         prerr_endline (Kanon_kernel.Error.to_string e); exit 1)

let run_check (print_form : bool) (path : string) : unit =
  let _contract, _globals, rows = checked_in path in
  if print_form then print_string (Kanon_surface.Elab.checked_form rows) else ()

let run_erased (path : string) : unit =
  let _contract, globals, rows = checked_in path in
  Kanon_kernel.Erase.program globals rows
  |> Result.fold
       ~ok:(fun out -> print_string (Kanon_kernel.Erase.print out))
       ~error:(fun e ->
         prerr_endline (Kanon_kernel.Error.to_string e); exit 1)

let run_axioms (path : string) : unit =
  let _contract, _globals, rows = checked_in path in
  List.iter print_endline
    (Kanon_surface.Elab.axiom_names rows)

let checked_erased path =
  let contract, globals, rows = checked_in path in
  let erased = Kanon_kernel.Erase.program globals rows
    |> Result.fold ~ok:Fun.id
       ~error:(fun e ->
          prerr_endline (Kanon_kernel.Error.to_string e); exit 1) in
  contract, globals, rows, erased

let compile (command : string) (path : string) (export : string) : Assay_emit.Emit.output =
  let contract, globals, rows, erased = checked_erased path in
  Assay_emit.Emit.program ~contract ~export globals rows erased
    |> Result.fold ~ok:Fun.id ~error:(fun e ->
      prerr_endline ("assay: " ^ command ^ ": " ^ Assay_emit.Emit.error e); exit 2)

(* The output directory must be new.  All compilation finishes before
   file creation, so a named compiler refusal writes nothing. *)
let run_emit (path : string) (directory : string) (export : string) : unit =
  let out = compile "emit" path export in
  let parent = Filename.dirname directory in
  if Sys.file_exists directory || not (Sys.file_exists parent && Sys.is_directory parent) then
    (prerr_endline "assay: emit: OUTPUT_PATH: use a new directory under an existing parent"; exit 64)
  else ();
  Unix.mkdir directory 0o755;
  List.iter (fun (name, contents) ->
    Out_channel.with_open_bin (Filename.concat directory name)
      (fun channel -> output_string channel contents))
    ["runtime.hex", out.runtime ^ "\n"; "init.hex", out.init ^ "\n";
     "abi.json", out.abi; "layout.json", out.layout; "axioms.txt", out.axioms]

let run_trace (path : string) (input : string) (prestate : string) : unit =
  Option.fold
    ~none:(fun () -> prerr_endline "assay: trace: CALLDATA_HEX: expected whole hex bytes"; exit 64)
    ~some:(fun input () ->
      let out = compile "trace" path "main" in
      Trace.run ~runtime:out.runtime ~input ~prestate
      |> Result.fold ~ok:Fun.id ~error:(fun e ->
        prerr_endline ("assay: trace: " ^ Trace.error e); exit 2))
    (Trace.calldata input) ()

let dispatch_trace (args : string list) : unit =
  match args with
  | [ path; "--calldata"; input ] -> run_trace path input (Trace.prestate ())
  | [ path; "--calldata"; input; "--prestate"; prestate ] -> run_trace path input prestate
  | [] | _ :: _ -> bad_usage ()

let run_diff (path : string) (input : string) (prestate : string) : unit =
  Option.fold
    ~none:(fun () -> prerr_endline "assay: diff: CALLDATA_HEX: expected whole hex bytes"; exit 64)
    ~some:(fun input () ->
      let out = compile "diff" path "main" in
      Differential.run ~runtime:out.runtime ~input ~prestate
      |> Result.fold ~ok:Fun.id ~error:(fun e ->
        prerr_endline ("assay: diff: " ^ Differential.error e); exit 2))
    (Trace.calldata input) ()

let dispatch_diff (args : string list) : unit =
  match args with
  | [ path; "--calldata"; input ] -> run_diff path input (Trace.prestate ())
  | [ path; "--calldata"; input; "--prestate"; prestate ] -> run_diff path input prestate
  | [] | _ :: _ -> bad_usage ()

let run_model path options storage =
  let module M = Assay_emit.Model in
  let option name fallback = List.assoc_opt name options |> Option.value ~default:fallback in
  let refuse code e = prerr_endline ("assay: run: " ^ M.error e); exit code in
  let input = M.inputs_with_caller ~data:(option "--calldata" "") ~value:(option "--value" "0")
    ~caller:(option "--caller" "0") ~storage
    |> Result.fold ~ok:Fun.id ~error:(refuse 64) in
  let _contract, globals, _rows, erased = checked_erased path in
  let program = M.prepare ~export:(option "--export" "main") globals erased
    |> Result.fold ~ok:Fun.id ~error:(refuse 2) in
  M.run program input
  |> Result.fold ~ok:(fun outcome -> print_string (M.print outcome)) ~error:(refuse 2)

let dispatch_run args =
  let rec options path seen storage = function
    | [] -> run_model path seen storage
    | "--storage" :: row :: rest -> options path seen (row :: storage) rest
    | ("--calldata" | "--value" | "--caller" | "--export" as flag) :: value :: rest ->
      if List.mem_assoc flag seen then bad_usage ()
      else options path ((flag, value) :: seen) storage rest
    | _ :: _ -> bad_usage () in
  match args with
  | path :: rest when not (String.starts_with ~prefix:"-" path) -> options path [] [] rest
  | [] | _ :: _ -> bad_usage ()

let dispatch_emit (args : string list) : unit =
  match args with
  | [ path; "-o"; directory ] -> run_emit path directory "main"
  | [ path; "-o"; directory; "--export"; name ] -> run_emit path directory name
  | [] | _ :: _ -> bad_usage ()

let dispatch_check (args : string list) : unit =
  match args with
  | [ "--print"; path ] -> run_check true path
  | [ "--erased"; path ] -> run_erased path
  | [ path ] ->
      if String.starts_with ~prefix:"-" path then bad_usage ()
      else run_check false path
  | [] | _ :: _ -> bad_usage ()

(* Pending commands keep a distinct exit code. *)
let run_pending (name : string) (stage : string) : unit =
  prerr_endline ("assay: " ^ name ^ ": PENDING (" ^ stage ^ ")"); exit 3

let dispatch (cmd : string) (args : string list) : unit =
  match cmd with
  | "spec-count" ->
      if args = [] then print_string (Kanon_kernel.Spec_count.print ())
      else bad_usage ()
  | "check" -> dispatch_check args
  | "axioms" ->
      (match args with
       | [ path ] -> run_axioms path
       | [] | _ :: _ -> bad_usage ())
  | "emit" -> dispatch_emit args
  | "trace" -> dispatch_trace args
  | "diff" -> dispatch_diff args
  | "run" -> dispatch_run args
  | "deploy" | "test" -> run_pending cmd "M1"
  | _unknown -> bad_usage ()

let () =
  match Array.to_list Sys.argv with
  | _prog :: cmd :: args -> dispatch cmd args
  | [] | [ _ ] -> bad_usage ()

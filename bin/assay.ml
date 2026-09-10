(** Assay Stage A: the inherited checker, erasure and axiom disclosure.
    EVM emission arrives in Stage E.  Exit 2 names an unavailable backend;
    exit 3 names a subcommand that is declared and not yet implemented;
    exit 64 names invalid arguments, an unaccepted suffix or a missing
    input. *)

let usage () : unit =
  prerr_endline
    "usage: assay check [--print|--erased] FILE | axioms FILE | spec-count | \
     emit FILE -o DIR | trace FILE | diff FILE | run FILE | deploy FILE | \
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
    Kanon_kernel.Global.t * (string * Kanon_kernel.Global.entry) list =
  Kanon_surface.Elab.check_in Kanon_kernel.Global.initial (read_file path)
  |> Result.fold ~ok:(fun rows -> rows)
       ~error:(fun e ->
         prerr_endline (Kanon_kernel.Error.to_string e); exit 1)

let run_check (print_form : bool) (path : string) : unit =
  let rows = snd (checked_in path) in
  if print_form then print_string (Kanon_surface.Elab.checked_form rows) else ()

let run_erased (path : string) : unit =
  let globals, rows = checked_in path in
  Kanon_kernel.Erase.program globals rows
  |> Result.fold
       ~ok:(fun out -> print_string (Kanon_kernel.Erase.print out))
       ~error:(fun e ->
         prerr_endline (Kanon_kernel.Error.to_string e); exit 1)

let run_axioms (path : string) : unit =
  List.iter print_endline
    (Kanon_surface.Elab.axiom_names (snd (checked_in path)))

(* The M0 plan interface is `assay emit FILE -o DIR`.  The inherited
   `--export NAME` arity stays accepted as a deprecated alias until the
   Stage E backend lands. *)
let emit_refusal (path : string) : unit =
  let globals, rows = checked_in path in
  Kanon_kernel.Erase.program globals rows
  |> Result.fold
       ~ok:(fun _erased ->
         prerr_endline "assay: emit: EVM_BACKEND_UNAVAILABLE (Stage E)";
         exit 2)
       ~error:(fun e ->
         prerr_endline (Kanon_kernel.Error.to_string e); exit 1)

let dispatch_emit (args : string list) : unit =
  match args with
  | [ path; "-o"; _ ] | [ path; "-o"; _; "--export"; _ ] -> emit_refusal path
  | [] | _ :: _ -> bad_usage ()

let dispatch_check (args : string list) : unit =
  match args with
  | [ "--print"; path ] -> run_check true path
  | [ "--erased"; path ] -> run_erased path
  | [ path ] ->
      if String.starts_with ~prefix:"-" path then bad_usage ()
      else run_check false path
  | [] | _ :: _ -> bad_usage ()

(* Declared at M0 and implemented later:  R-M0-8 names `diff`, and R-M0-9
   names `evm t8n --state.fork Cancun` as the second executor of `diff`.
   These names exit 3, so a declared subcommand is never reported as a
   typo. *)
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
  | "trace" -> run_pending cmd "Stage F"
  | "diff" -> run_pending cmd "Stage F"
  | "run" | "deploy" | "test" -> run_pending cmd "M1"
  | _unknown -> bad_usage ()

let () =
  match Array.to_list Sys.argv with
  | _prog :: cmd :: args -> dispatch cmd args
  | [] | [ _ ] -> bad_usage ()

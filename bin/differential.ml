(** Offline differential execution.  Python owns the JSON and process
    boundary; the compiler supplies only checked runtime bytes. *)
type error = Invalid_value of string | Missing_python | Missing_helper | Runner_exit of int
  | Runner_signal of int | Runner_stopped of int

(* Unix.WSIGNALED carries the OCaml signal encoding, not the host number.
   The table names the signal, so a report never mixes the two encodings. *)
let signal_name (signal : int) : string =
  let table = [ (Sys.sigabrt, "SIGABRT"); (Sys.sigalrm, "SIGALRM");
                (Sys.sigfpe, "SIGFPE"); (Sys.sighup, "SIGHUP");
                (Sys.sigill, "SIGILL"); (Sys.sigint, "SIGINT");
                (Sys.sigkill, "SIGKILL"); (Sys.sigpipe, "SIGPIPE");
                (Sys.sigquit, "SIGQUIT"); (Sys.sigsegv, "SIGSEGV");
                (Sys.sigterm, "SIGTERM"); (Sys.sigusr1, "SIGUSR1");
                (Sys.sigusr2, "SIGUSR2"); (Sys.sigchld, "SIGCHLD");
                (Sys.sigcont, "SIGCONT"); (Sys.sigstop, "SIGSTOP");
                (Sys.sigtstp, "SIGTSTP"); (Sys.sigttin, "SIGTTIN");
                (Sys.sigttou, "SIGTTOU"); (Sys.sigvtalrm, "SIGVTALRM");
                (Sys.sigprof, "SIGPROF"); (Sys.sigbus, "SIGBUS");
                (Sys.sigpoll, "SIGPOLL"); (Sys.sigsys, "SIGSYS");
                (Sys.sigtrap, "SIGTRAP"); (Sys.sigurg, "SIGURG");
                (Sys.sigxcpu, "SIGXCPU"); (Sys.sigxfsz, "SIGXFSZ") ] in
  List.assoc_opt signal table
  |> Option.value ~default:("OCaml signal " ^ string_of_int signal)

let error : error -> string = function
  | Invalid_value detail -> "DIFF_VALUE: " ^ detail
  | Missing_python -> "DIFF_TOOL: python3 is not on PATH"
  | Missing_helper -> "DIFF_HELPER: cannot read evm/diff.py"
  | Runner_exit code -> "DIFF_RUNNER: exit " ^ string_of_int code
  | Runner_signal signal -> "DIFF_RUNNER: killed by " ^ signal_name signal
  | Runner_stopped signal -> "DIFF_RUNNER: stopped by " ^ signal_name signal

(* The model separates the spelling and the range, so the report carries
   its detail instead of one merged sentence. *)
let detail : Assay_emit.Model.error -> string = function
  | Assay_emit.Model.Input text -> text
  | Assay_emit.Model.Source _ | Assay_emit.Model.Missing_memory _ as other ->
    Assay_emit.Model.error other

(* Reuse the source model's bounded Word grammar, including uppercase hex.
   The Python adapter accepts a lowercase prefix, so normalize it here. *)
let value (text : string) : (string, error) result =
  Assay_emit.Model.inputs ~data:"" ~value:text ~storage:[]
  |> Result.map (fun _ -> String.lowercase_ascii text)
  |> Result.map_error (fun e -> Invalid_value (detail e))

let run ~(runtime : string) ~(input : string) ~(prestate : string) ~(value : string) : (unit, error) result =
  let helper = Filename.concat
      (Filename.dirname (Filename.dirname (Trace.prestate ()))) "diff.py" in
  let paths = Option.value ~default:"" (Sys.getenv_opt "PATH") in
  let python = String.split_on_char ':' paths
    |> List.filter (fun path -> path <> "")
    |> List.map (fun path -> Filename.concat path "python3")
    |> List.find_opt Trace.runnable in
  if not (Trace.regular helper) then Error Missing_helper else
  Option.fold ~none:(Error Missing_python) ~some:(fun program ->
    let argv = [program; "-P"; helper; "--runtime"; runtime;
                "--calldata"; input; "--prestate"; prestate; "--value"; value] in
    let process = Unix.open_process_args_in program (Array.of_list argv) in
    let output = In_channel.input_all process in
    let status = Unix.close_process_in process in
    match status with
    | Unix.WEXITED 0 -> print_string output; Ok ()
    | Unix.WEXITED code -> Error (Runner_exit code)
    | Unix.WSIGNALED signal -> Error (Runner_signal signal)
    | Unix.WSTOPPED signal -> Error (Runner_stopped signal)) python

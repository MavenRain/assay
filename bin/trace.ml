(** Run geth with literal argv and an explicit prestate.  File and
    process races retain the driver's OS boundary. *)
type error = Missing_tool | Missing_prestate of string
  | Executor_exit of int | Executor_signal of int | Execution_error

let error : error -> string = function
  | Missing_tool -> "TRACE_TOOL: evm is not on PATH"
  | Missing_prestate path -> "TRACE_PRESTATE: cannot read " ^ path
  | Executor_exit code -> "TRACE_EXECUTOR: exit " ^ string_of_int code
  | Executor_signal signal -> "TRACE_EXECUTOR: signal " ^ string_of_int signal
  | Execution_error -> "TRACE_EXECUTION: geth reported an EVM error"

let calldata (text : string) : string option =
  let text = String.lowercase_ascii text in
  let text = if String.starts_with ~prefix:"0x" text
    then String.of_seq (Seq.drop 2 (String.to_seq text)) else text in
  let hex = String.for_all (fun c ->
    (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')) text in
  if hex && Int.rem (String.length text) 2 = 0 then Some text else None

let regular (path : string) : bool =
  Sys.file_exists path && not (Sys.is_directory path)

(* Review round 2026-09-11 (B-1):  a readable file named evm is not a
   tool.  The lookup requires an execute bit, so a non-executable entry
   is skipped and the next PATH directory is tried, and an empty PATH
   entry no longer resolves to the working directory.  The stat call
   sits on the same documented OS boundary as the process calls below. *)
let runnable (path : string) : bool =
  regular path && Int.logand (Unix.stat path).st_perm 0o111 <> 0

let executable () : string option =
  let paths = Option.value ~default:"" (Sys.getenv_opt "PATH") in
  String.split_on_char ':' paths
  |> List.filter (fun path -> path <> "")
  |> List.map (fun path -> Filename.concat path "evm")
  |> List.find_opt runnable

let prestate () : string =
  let binary = if Filename.is_relative Sys.executable_name
    then Filename.concat (Sys.getcwd ()) Sys.executable_name else Sys.executable_name in
  let root = List.fold_left (fun path () -> Filename.dirname path)
      binary [(); (); (); ()] in
  Filename.concat root "evm/fixtures/cancun.json"

(* Geth's trace has an error field for a fault even when it exits zero.
   Only the field name and its following colon matter here.  This is
   a detector for geth traces, not a general JSON parser. *)
let has_error (text : string) : bool =
  let compact text = String.to_seq text
    |> Seq.filter (fun c -> not (List.mem c [' '; '\n'; '\r'; '\t']))
    |> String.of_seq in
  let rec scan : string list -> bool = function
    | "error" :: after :: tail ->
        let after = compact after in
        (match () with
         | () when after = ":" ->
             Option.fold ~none:true ~some:(fun value -> value <> "" || scan tail)
               (List.find_opt (Fun.const true) tail)
         | () when String.starts_with ~prefix:":null" after -> scan tail
         | () when String.starts_with ~prefix:":" after -> true
         | () -> scan tail)
    | _part :: tail -> scan tail
    | [] -> false in
  scan (String.split_on_char '"' text)

let run ~(runtime : string) ~(input : string) ~(prestate : string) : (unit, error) result =
  if not (regular prestate) then Error (Missing_prestate prestate) else
  Option.fold ~none:(Error Missing_tool) ~some:(fun program ->
      let argv = [program; "--verbosity"; "0"; "run"; "--prestate"; prestate;
        "--gas"; "16777216"; "--sender"; "0x000000000000000000000000000073656e646572";
        "--receiver"; "0x0000000000000000000000007265636569766572";
        "--code"; runtime; "--input"; input; "--json"; "--dump"] in
      let channel = Unix.open_process_args_in program (Array.of_list argv) in
      let output = In_channel.input_all channel in
      let status = Unix.close_process_in channel in
      print_string output;
      match status with
      | Unix.WEXITED 0 -> if has_error output then Error Execution_error else Ok ()
      | Unix.WEXITED code -> Error (Executor_exit code)
      | Unix.WSIGNALED signal | Unix.WSTOPPED signal -> Error (Executor_signal signal))
    (executable ())

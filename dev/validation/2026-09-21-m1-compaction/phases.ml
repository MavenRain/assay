let kernel_result result = Result.fold ~ok:Fun.id
  ~error:(fun error -> prerr_endline (Kanon_kernel.Error.to_string error); exit 1) result
let rec repeat remaining f =
  if remaining = 0 then () else (ignore (f ()); repeat (remaining - 1) f)
let sample name f =
  repeat 10 f;
  let started = Unix.gettimeofday () in
  repeat 2000 f;
  Printf.printf "%s us/compile=%.3f\n%!" name ((Unix.gettimeofday () -. started) *. 500.)
let () =
  let source = In_channel.with_open_bin "corpus/contracts/Ref20.asy" In_channel.input_all in
  let check () = Kanon_surface.Elab.check_in Kanon_kernel.Global.initial source |> kernel_result in
  let globals, rows = check () in
  let erase () = Kanon_kernel.Erase.program globals rows |> kernel_result in
  let erased = erase () in
  sample "lower" (fun () -> Assay_emit.Contract.lower source |> kernel_result);
  sample "check" check;
  sample "erase" erase;
  sample "emit" (fun () -> Assay_emit.Emit.program ~contract:"Ref20" ~export:"main" globals rows erased
    |> Result.fold ~ok:Fun.id ~error:(fun error -> prerr_endline (Assay_emit.Emit.error error); exit 2))

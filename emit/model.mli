(* Only validated inputs and prepared source programs can be executed. *)
type input
type program
type outcome
type error = Source of Emit.error | Input of string | Missing_memory of int
val error : error -> string
val inputs : data:string -> value:string -> storage:string list -> (input, error) result
val inputs_with_caller : data:string -> value:string -> storage:string list -> caller:string -> (input, error) result
val prepare : export:string -> Kanon_kernel.Global.t ->
  (string * Kanon_kernel.Erase.entry) list -> (program, error) result
val run : program -> input -> (outcome, error) result
val print : outcome -> string

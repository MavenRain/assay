(** Optional contract syntax, lowered to the carried grammar before checking.
    The declared contract name labels emitted layout metadata. *)
val lower : string -> (string option * string, Kanon_kernel.Error.t) result

contract Errors where
  storage State := { cell : Word }
  error Denied ()
  error InsufficientBalance (available : Word) (required : Word)
  error Snapshot (first : Word) (second : Word) (again : Word)
  entry deny () : Eff Sig Word := do revert Denied ()
  entry fail (amount : Word) : Eff Sig Word :=
    do before <- sload cell ;
       sstore cell amount ;
       revert InsufficientBalance (before) (amount)
  entry snapshot (a : Word) (b : Word) : Eff Sig Word :=
    do c <- add a b ; revert Snapshot (b) (a) (b)
  entry get () : Eff Sig Word := do c <- sload cell ; pure c
  constructor := do sstore cell (word 7) ; pure ()

contract Fallback where
  storage State := { cell : Word }
  error MalformedCalldata ()
  error Denied (code : Word)
  entry get () : Eff Sig Word := do value <- sload cell ; pure value
  entry set (amount : Word) : Eff Sig Word :=
    do sstore cell amount ; pure amount
  entry fail () : Eff Sig Word :=
    do sstore cell (word 99) ; revert Denied (word 7)
  fallback : Eff Sig Never := revert MalformedCalldata
  constructor := do sstore cell (word 7) ; pure ()

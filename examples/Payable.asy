contract Payable where
  storage State := { cell : Word }
  error TooLarge (amount : Word)
  error UnknownCall ()
  payable entry deposit (amount : Word) : Eff Sig Word := do
    sstore cell amount ;
    (0 bounded : Le amount (word 10)) <- guard TooLarge (amount) (leWord amount (word 10)) ;
    sender <- caller ; pure sender
  payable entry ping () : Eff Sig Word := do pure (word 17)
  entry set (amount : Word) : Eff Sig Word := do sstore cell amount ; pure amount
  entry get () : Eff Sig Word := do value <- sload cell ; pure value
  fallback : Eff Sig Never := revert UnknownCall
  constructor := do sstore cell (word 7) ; pure ()

contract CallValue where
  storage State := { cell : Word }
  error TooLarge (amount : Word)
  error Observed (amount : Word)
  payable entry deposit (cap : Word) : Eff Sig Word := do
    amount <- callvalue ;
    sstore cell amount ;
    (0 bounded : Le amount cap) <- guard TooLarge (amount) (leWord amount cap) ;
    again <- callvalue ; pure again
  payable entry observe () : Eff Sig Word := do amount <- callvalue ; pure amount
  payable entry sender () : Eff Sig Word := do
    amount <- callvalue ; sstore cell amount ; who <- caller ; pure who
  payable entry fail () : Eff Sig Word := do
    amount <- callvalue ; sstore cell amount ; revert Observed (amount)
  entry zero () : Eff Sig Word := do amount <- callvalue ; pure amount
  constructor := do sstore cell (word 7) ; pure ()

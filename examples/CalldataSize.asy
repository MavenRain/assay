contract CalldataSize where
  storage State := { cell : Word }
  error TooLarge (size : Word)
  error Observed (size : Word)
  payable entry deposit (cap : Word) : Eff Sig Word := do
    size <- calldatasize ; sstore cell size ;
    (0 bounded : Le size cap) <- guard TooLarge (size) (leWord size cap) ;
    again <- calldatasize ; pure again
  payable entry observe () : Eff Sig Word := do size <- calldatasize ; pure size
  payable entry mixed () : Eff Sig Word := do
    size <- calldatasize ; amount <- callvalue ; who <- caller ;
    sstore cell amount ; pure size
  payable entry sender () : Eff Sig Word := do
    size <- calldatasize ; sstore cell size ; who <- caller ; pure who
  payable entry fail () : Eff Sig Word := do
    size <- calldatasize ; sstore cell size ; revert Observed (size)
  entry plain () : Eff Sig Word := do size <- calldatasize ; pure size
  constructor := do sstore cell (word 7) ; pure ()

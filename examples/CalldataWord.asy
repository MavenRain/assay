contract CalldataWord where
  storage State := { cell : Word }
  error TooLarge (value : Word)
  error Observed (first : Word) (second : Word)
  entry observe (offset : Word) : Eff Sig Word := do
    value <- calldataload offset ; pure value
  payable entry deposit (offset : Word) (cap : Word) : Eff Sig Word := do
    value <- calldataload offset ; sstore cell value ;
    (0 bounded : Le value cap) <- guard TooLarge (value) (leWord value cap) ;
    pure value
  payable entry snapshot (offset : Word) : Eff Sig Word := do
    first <- calldataload offset ; second <- calldataload (word 0) ;
    amount <- callvalue ; size <- calldatasize ; who <- caller ;
    sstore cell amount ; pure first
  entry indirect () : Eff Sig Word := do
    offset <- calldataload (word 4) ; value <- calldataload offset ; pure value
  entry computed (offset : Word) : Eff Sig Word := do
    next <- add offset (word 1) ; value <- calldataload next ; pure value
  entry stored () : Eff Sig Word := do
    offset <- sload cell ; value <- calldataload offset ; pure value
  entry fail (offset : Word) : Eff Sig Word := do
    first <- calldataload offset ; sstore cell first ;
    second <- calldataload (word 0) ; revert Observed (first) (second)
  entry plain () : Eff Sig Word := do value <- calldataload (word 0) ; pure value
  entry atEnd () : Eff Sig Word := do
    size <- calldatasize ; value <- calldataload size ; pure value
  constructor := do sstore cell (word 7) ; pure ()

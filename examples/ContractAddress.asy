contract ContractAddress where
  storage State := { cell : Word }
  error Unexpected (actual : Word)
  error Observed (self : Word) (sender : Word)
  entry observe () : Eff Sig Word := do
    self <- address ; pure self
  payable entry snapshot (offset : Word) : Eff Sig Word := do
    first <- address ; sender <- caller ; amount <- callvalue ;
    size <- calldatasize ; loaded <- calldataload offset ;
    old <- sload cell ; second <- address ; sstore cell loaded ; pure first
  entry remember () : Eff Sig Word := do
    self <- address ; sstore cell self ; pure self
  entry checked (expected : Word) : Eff Sig Word := do
    self <- address ; sstore cell self ;
    guard Unexpected (self) (eqWord self expected) ; pure self
  entry increment () : Eff Sig Word := do
    self <- address ; guard (lt256 (add self (word 1))) ;
    let result := addLt self (word 1) ; pure result
  entry fail () : Eff Sig Word := do
    self <- address ; sender <- caller ; sstore cell self ;
    revert Observed (self) (sender)
  constructor := do pure ()

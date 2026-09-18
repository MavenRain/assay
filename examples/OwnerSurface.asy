-- The deployer becomes owner. Failed access checks roll back earlier writes.
contract OwnerSurface where
  storage State := { owner : Word ; visits : Word }
  error Denied (sender : Word) (owner : Word)
  entry set (next : Word) : Eff Sig Word := do
    old <- sload owner ; sender <- caller ;
    sstore visits (word 99) ;
    guard Denied (sender) (old) (eqWord sender old) ;
    sstore owner next ; sstore visits (word 1) ; pure next
  constructor := do deployer owner ; pure ()

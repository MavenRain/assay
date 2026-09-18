-- Context snapshots and deployment initialization through the contract surface.
contract ContextSurface where
  storage State := { owner : Word ; last : Word }
  error Denied ()
  entry who () : Eff Sig Word := do
    old <- sload owner ;
    sender <- caller ;
    later <- sload last ;
    again <- caller ;
    pure sender
  entry remember () : Eff Sig Word := do
    sender <- caller ; sstore last sender ; pure sender
  entry bounded (bound : Word) : Eff Sig Word := do
    sender <- caller ; sstore last sender ;
    guard Denied () (leWord sender bound) ; pure sender
  constructor := do
    sstore owner (word 7) ; deployer owner ;
    sstore last (word 9) ; pure ()

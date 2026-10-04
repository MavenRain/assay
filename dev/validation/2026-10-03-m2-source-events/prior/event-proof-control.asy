contract EventProofControl where
storage State := { cell : Word }
invariant bounded (s : State) : Prop := Le s.cell (word 0)
entry go () : Eff Sig Word := do
  sstore cell (word 1) ; pure (word 1)

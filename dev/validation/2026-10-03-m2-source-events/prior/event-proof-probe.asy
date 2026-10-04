contract EventProofProbe where
storage State := { cell : Word }
event Tick ()
invariant bounded (s : State) : Prop := Le s.cell (word 0)
entry go () : Eff Sig Word := do
  emit Tick () ; sstore cell (word 1) ; pure (word 1)

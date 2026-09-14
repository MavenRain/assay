contract Effects where storage State := { cell : Word }
entry mix (a : Word) (b : Word) : Eff Sig Word := do sstore cell (word 0) ; pure a

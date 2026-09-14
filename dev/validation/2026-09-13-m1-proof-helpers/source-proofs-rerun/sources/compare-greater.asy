contract Effects where storage State := { cell : Word }
entry mix (a : Word) (b : Word) : Eff Sig Word := do sstore cell (word 9) ; guard le a b ; pure a

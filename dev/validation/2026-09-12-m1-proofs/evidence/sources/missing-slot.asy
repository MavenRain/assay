contract Effects where storage State := { cell : Word }
entry mix (a : Word) (b : Word) : Eff Sig Word := do value <- sload cell ; pure value

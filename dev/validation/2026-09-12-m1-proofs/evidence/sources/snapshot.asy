contract Effects where storage State := { cell : Word }
entry mix (a : Word) (b : Word) : Eff Sig Word := do old <- sload cell ; sstore cell (word 9) ; now <- sload cell ; value <- add old now ; pure value

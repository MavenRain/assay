contract Checked where storage State := { cell : Word }
entry mix (a : Word) (b : Word) : Eff Sig Word := do
  sstore cell (word 9) ; total <- add a b ; sstore cell total ; pure total

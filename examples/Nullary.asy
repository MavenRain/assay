contract Nullary where
  storage State := { count : Word }
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  entry increment () : Eff Sig Word :=
    do c <- sload count ; next <- add c (word 1) ; sstore count next ; pure next
  entry reset () : Eff Sig Word := do sstore count (word 0) ; pure (word 0)
  constructor := do sstore count (word 7) ; pure ()

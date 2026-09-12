-- Contract sugar lowers to the checked core counter protocol.
contract Counter where
  storage State := { count : Word ; limit : Word }

  entry increment (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       s <- add c n ;
       bound <- sload limit ;
       guard le s bound ;
       sstore count s ; pure s

  entry decrement (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       d <- sub c n ;
       sstore count d ; pure d

  entry get () : Eff Sig Word := do c <- sload count ; pure c

  constructor := do sstore limit (word 100) ; pure ()

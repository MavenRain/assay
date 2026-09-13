contract CounterProofs where
  storage State := { count : Word ; limit : Word }
  error OverflowRevert ()
  error BoundRevert (attempted : Word) (bound : Word)
  error UnderflowRevert ()
  entry increment (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       (0 p : Lt256 (add c n)) <- guard OverflowRevert (lt256 (add c n)) ;
       let s : Word := addLt c n p ;
       bound <- sload limit ;
       (0 q : Le s bound) <- guard BoundRevert (s) (bound) (leWord s bound) ;
       sstore count s ; pure s
  entry decrement (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       (0 p : Le n c) <- guard UnderflowRevert () (leWord n c) ;
       let d : Word := subLe c n p ;
       sstore count d ; pure d
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  constructor := do sstore limit (word 100) ; pure ()

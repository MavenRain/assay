contract InferredArithmetic where
  storage State := { count : Word ; limit : Word }
  error OverflowRevert ()
  error BoundRevert (attempted : Word) (bound : Word)
  error UnderflowRevert ()
  entry increment (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       guard OverflowRevert (lt256 (add c n)) ;
       let s : Word := addLt c n ;
       bound <- sload limit ;
       guard BoundRevert (s) (bound) (leWord s bound) ;
       sstore count s ; pure s
  entry decrement (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       guard UnderflowRevert () (leWord n c) ;
       let d : Word := subLe c n ;
       sstore count d ; pure d
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  constructor := do sstore limit (word 100) ; pure ()

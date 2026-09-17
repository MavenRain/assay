contract ProofHoles where
  storage State := { count : Word ; limit : Word }
  error OverflowRevert ()
  error BoundRevert (attempted : Word) (bound : Word)
  error UnderflowRevert ()
  proof fits (0 closed : Le (word 0) (word 1)) (0 x : Word) (0 y : Word)
    (0 p : Lt256 (add x y)) : Lt256 (add x y) := _
  proof ordered (0 closed : Le (word 0) (word 1)) (0 x : Word) (0 y : Word)
    (0 p : Le x y) : Le x y := _
  entry increment (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       guard OverflowRevert (lt256 (add c n)) ;
       let s : Word := addLt c n fits(_, c, n, _) ;
       bound <- sload limit ;
       guard BoundRevert (s) (bound) (leWord s bound) ;
       sstore count s ; pure s
  entry decrement (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       guard UnderflowRevert () (leWord n c) ;
       let d : Word := subLe c n ordered(_, n, c, _) ;
       sstore count d ; pure d
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  constructor := do sstore limit (word 100) ; pure ()

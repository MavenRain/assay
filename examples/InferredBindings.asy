contract InferredBindings where
  storage State := { count : Word ; limit : Word }
  error OverflowRevert ()
  error BoundRevert (attempted : Word) (bound : Word)
  error UnderflowRevert ()
  proof fits (0 x : Word) (0 y : Word) (0 p : Lt256 (add x y))
    : Lt256 (add x y) := (let (0 checked) := p in checked)
  proof ordered (0 x : Word) (0 y : Word) (0 p : Le x y)
    : Le x y := (let (0 checked) := p in checked)
  entry increment (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       guard OverflowRevert (lt256 (add c n)) ;
       let (0 bounded) := fits(c, n) ;
       let s : Word := addLt c n bounded ;
       bound <- sload limit ;
       guard BoundRevert (s) (bound) (leWord s bound) ;
       sstore count s ; pure s
  entry decrement (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       guard UnderflowRevert () (leWord n c) ;
       let (0 bounded) := ordered(n, c) ;
       let d : Word := subLe c n bounded ;
       sstore count d ; pure d
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  constructor := do sstore limit (word 100) ; pure ()

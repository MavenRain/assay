-- Each successful write must establish the declared storage bound.
contract CounterInvariant where
  storage State := { count : Word ; limit : Word }
  invariant bounded (s : State) : Prop := Le s.count s.limit
  error OverflowRevert ()
  error BoundRevert (attempted : Word) (bound : Word)
  error UnderflowRevert ()
  entry increment (n : Word) : Eff Sig Word := do
    c <- sload count ;
    (0 p : Lt256 (add c n)) <- guard OverflowRevert (lt256 (add c n)) ;
    let s : Word := addLt c n p ;
    bound <- sload limit ;
    (0 q : Le s bound) <- guard BoundRevert (s) (bound) (leWord s bound) ;
    sstore count s ; pure s
  entry decrement (n : Word) : Eff Sig Word := do
    c <- sload count ;
    (0 p : Le n c) <- guard UnderflowRevert () (leWord n c) ;
    let d : Word := subLe c n p ;
    bound <- sload limit ;
    (0 q : Le d bound) <- guard BoundRevert (d) (bound) (leWord d bound) ;
    sstore count d ; pure d
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  constructor := do sstore limit (word 100) ; pure ()

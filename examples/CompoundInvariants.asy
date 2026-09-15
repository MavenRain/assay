contract CompoundInvariants where
  storage State := { low : Word ; high : Word }
  predicate Below (0 x : Word) (0 y : Word) : Prop := Le x y
  predicate Room (0 x : Word) (0 y : Word) : Prop := Lt256 (add x y)
  predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
    Both (Below(x, y)) (Room(x, y))
  invariant bounded (s : State) : Prop := Bounds(s.low, s.high)
  proof collect (0 x : Word) (0 y : Word)
    (0 p : Below(x, y)) (0 q : Room(x, y)) : Bounds(x, y) := pair(p, q)
  entry set (a : Word) (b : Word) : Eff Sig Word := do
    sstore low (word 9) ;
    (0 p : Below(a, b)) <- guard (leWord a b) ;
    (0 q : Room(a, b)) <- guard (lt256 (add a b)) ;
    let (0 bundle : Bounds(a, b)) := collect(a, b, p, q) ;
    sstore low a ; sstore high b ; pure a

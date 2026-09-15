contract CompoundGuards where
  storage State := { low : Word ; high : Word }
  error Denied (left : Word) (right : Word)
  predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
    Both (Le x y) (Lt256 (add x y))
  invariant bounded (s : State) : Prop := Bounds(s.low, s.high)
  entry set (a : Word) (b : Word) : Eff Sig Word := do
    sstore low (word 9) ;
    (0 bounds : Bounds(a, b)) <- guard Denied (a) (b)
      (both (leWord a b) (lt256 (add a b))) ;
    sstore low a ; sstore high b ; pure a

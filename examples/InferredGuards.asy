contract InferredGuards where
  storage State := { low : Word ; high : Word }
  error Denied (left : Word) (right : Word)
  predicate Below (0 x : Word) (0 y : Word) : Prop := Le x y
  predicate Room (0 x : Word) (0 y : Word) : Prop := Lt256 (add x y)
  predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
    Both (Below(x, y)) (Room(x, y))
  invariant bounded (s : State) : Prop := Bounds(s.low, s.high)
  entry set (a : Word) (b : Word) : Eff Sig Word := do
    sstore low (word 9) ;
    guard Denied (a) (b) (Bounds(a, b)) ;
    sstore low a ; sstore high b ; pure a

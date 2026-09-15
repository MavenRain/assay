-- Named claims expand before the existing kernel checks and erases proofs.
contract Predicates where
  storage State := { cell : Word }
  predicate Ordered (0 x : Word) (0 y : Word) : Prop := Le y x
  predicate Room (0 x : Word) (0 y : Word) : Prop := Lt256 (add x y)
  predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
    Both (Ordered(x, y)) (Room(x, y))
  proof collect (0 x : Word) (0 y : Word)
    (0 p : Ordered(x, y)) (0 q : Room(x, y)) : Bounds(x, y) := pair(p, q)
  error Denied (left : Word) (right : Word)
  entry mix (a : Word) (b : Word) : Eff Sig Word := do
    sstore cell (word 9) ;
    (0 ordered : Ordered(a, b)) <- guard Denied (a) (b) (leWord b a) ;
    (0 fits : Room(a, b)) <- guard Denied (a) (b) (lt256 (add a b)) ;
    let (0 bundle : Bounds(a, b)) := collect(a, b, ordered, fits) ;
    let difference : Word := subLe a b first(bundle) ;
    let total : Word := addLt a b second(bundle) ;
    sstore cell difference ; pure total
  constructor := do sstore cell (word 7) ; pure ()

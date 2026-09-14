-- A checked bundle supplies independent bounds for addition and subtraction.
contract ProofBundles where
  storage State := { cell : Word }
  error Denied (left : Word) (right : Word)
  proof bounds (0 x : Word) (0 y : Word)
    (0 ordered : Le y x) (0 fits : Lt256 (add x y)) :
    Both (Le y x) (Lt256 (add x y)) := pair(ordered, fits)
  proof relay (0 x : Word) (0 y : Word)
    (0 bundle : Both (Le y x) (Lt256 (add x y))) :
    Both (Le y x) (Lt256 (add x y)) := pair(first(bundle), second(bundle))
  entry mix (a : Word) (b : Word) : Eff Sig Word := do
    sstore cell (word 9) ;
    (0 ordered : Le b a) <- guard Denied (a) (b) (leWord b a) ;
    (0 fits : Lt256 (add a b)) <- guard Denied (a) (b) (lt256 (add a b)) ;
    let (0 bundle : Both (Le b a) (Lt256 (add a b))) :=
      relay(a, b, bounds(a, b, ordered, fits)) ;
    let difference : Word := subLe a b first(bundle) ;
    let total : Word := addLt a b second(bundle) ;
    sstore cell difference ; pure total
  constructor := do sstore cell (word 7) ; pure ()

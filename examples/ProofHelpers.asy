-- Reusable proof helpers and all their arguments are checked and erased.
contract ProofHelpers where
storage State := { cell : Word }
error Denied (left : Word) (right : Word)

proof ordered (0 a : Word) (0 b : Word) (0 p : Le a b) : Le a b := p
proof relay (0 a : Word) (0 b : Word) (0 p : Le a b) : Le a b :=
  ordered(a, b, (let (0 q : Le a b) := p in q))
proof fits (0 a : Word) (0 b : Word) (0 p : Lt256 (add a b)) : Lt256 (add a b) := p
proof five : Lt256 (add (word 2) (word 3)) := ()

entry closed () : Eff Sig Word := do
  let v : Word := addLt (word 2) (word 3) five() ;
  sstore cell v ; pure v

entry subtract (a : Word) (b : Word) : Eff Sig Word := do
  sstore cell (word 9) ;
  (0 p : Le b a) <- guard Denied (a) (b) (leWord b a) ;
  let v : Word := subLe a b relay(b, a, p) ;
  sstore cell v ; pure v

entry combine (a : Word) (b : Word) : Eff Sig Word := do
  (0 p : Lt256 (add a b)) <- guard Denied (a) (b) (lt256 (add a b)) ;
  let v : Word := addLt a b fits(a, b, p) ;
  sstore cell v ; pure v

constructor := do sstore cell (word 7) ; pure ()

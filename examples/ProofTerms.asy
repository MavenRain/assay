-- Closed bounds and scoped aliases are checked and erased before execution.
contract ProofTerms where
storage State := { cell : Word }
error Denied (left : Word) (right : Word)

entry closed () : Eff Sig Word := do
  let (0 p : Lt256 (add (word 2) (word 3))) := () ;
  let v : Word := addLt (word 2) (word 3)
    (let (0 q : Lt256 (add (word 2) (word 3))) := p in q) ;
  sstore cell v ; pure v

entry subtract (a : Word) (b : Word) : Eff Sig Word := do
  sstore cell (word 9) ;
  (0 p : Le b a) <- guard Denied (a) (b) (leWord b a) ;
  let (0 q : Le b a) := (p : Le b a) ;
  let v : Word := subLe a b (let (0 p : Le b a) := q in p) ;
  sstore cell v ; pure v

constructor := do sstore cell (word 7) ; pure ()

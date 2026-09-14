-- Explicit M1 core protocol, before contract and entry surface sugar.
mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> Nat -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
axiom EvmOpcodes : Prop

def ResultWord : Type 0 := sum (Word 256, prod ())
mu Tx : Type 0 :=
  | done : Word 256 -> Tx
  | store : Word 256 -> Word 256 -> Tx -> Tx
  | load : Word 256 -> (Word 256 -> Tx) -> Tx
  | add : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | sub : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | le : Word 256 -> Word 256 -> Tx -> Tx -> Tx
  | abort : Tx

def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def a : Type 0 := Word 256
def b : Type 0 := Word 256
def mix : Type 0 := prod (a, b)
def Entry : Type 0 := sum (mix)
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) =>
  case entry with | 0 (args : mix) => store storage.0 (word 256 9)
  (add args.0 args.1 (fun (result : ResultWord) =>
    case result with
    | 0 (value : Word 256) => store storage.0 value (done value)
    | 1 (err : prod ()) => done (word 256 77)))

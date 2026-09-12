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

-- Alias names label the collection fields and ABI arguments.
def count : Type 0 := Word 256
def limit : Type 0 := Word 256
def Storage : Type 0 := prod (count, limit)
def storage : Storage := tuple (word 256 0, word 256 1)
def n : Type 0 := Word 256
def increment : Type 0 := prod (n)
def decrement : Type 0 := prod (n)
def get : Type 0 := prod ()
def Entry : Type 0 := sum (increment, decrement, get)

def constructor : Eff := put storage.1 (word 256 100) (ret (word 256 0))
def main : Entry -> Tx := fun (entry : Entry) =>
  case entry with
  | 0 (args : increment) =>
    load storage.0 (fun (c : Word 256) =>
      add c args.0 (fun (result : ResultWord) =>
        case result with
        | 0 (s : Word 256) =>
          load storage.1 (fun (bound : Word 256) =>
            le s bound (store storage.0 s (done s)) abort)
        | 1 (err : prod ()) => abort))
  | 1 (args : decrement) =>
    load storage.0 (fun (c : Word 256) =>
      sub c args.0 (fun (result : ResultWord) =>
        case result with
        | 0 (d : Word 256) => store storage.0 d (done d)
        | 1 (err : prod ()) => abort))
  | 2 (args : get) => load storage.0 (fun (c : Word 256) => done c)

-- Explicit proof protocol with a closed proof and no runtime guard.
mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> Nat -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
axiom EvmOpcodes : Prop
def wordNat : Word 256 -> Nat := fun (w : Word 256) =>
  case w as x in Word bits return Nat with | word 0 bits n => n
def Le : Word 256 -> Word 256 -> Prop := fun (a : Word 256) (b : Word 256) =>
  case natLt (wordNat b) (wordNat a) as flag return Prop with
  | 0 (_u : prod ()) => prod () | 1 (_u : prod ()) => sum ()
def AddFits : Word 256 -> Word 256 -> Prop := fun (a : Word 256) (b : Word 256) =>
  case natLt (natAdd (wordNat a) (wordNat b)) 115792089237316195423570985008687907853269984665640564039457584007913129639936 as flag return Prop with
  | 0 (_u : prod ()) => sum () | 1 (_u : prod ()) => prod ()
def ResultWord : Type 0 := sum (Word 256, prod ())
mu Tx : Type 0 :=
  | done : Word 256 -> Tx
  | store : Word 256 -> Word 256 -> Tx -> Tx
  | load : Word 256 -> (Word 256 -> Tx) -> Tx
  | add : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | sub : Word 256 -> Word 256 -> (ResultWord -> Tx) -> Tx
  | le : Word 256 -> Word 256 -> Tx -> Tx -> Tx
  | abort : Tx
  | guardLe : (a : Word 256) -> (b : Word 256) -> ((0 p : Le a b) -> Tx) -> Tx -> Tx
  | guardAdd : (a : Word 256) -> (b : Word 256) -> ((0 p : AddFits a b) -> Tx) -> Tx -> Tx
  | addLt : (a : Word 256) -> (b : Word 256) -> (0 p : AddFits a b) -> (Word 256 -> Tx) -> Tx
  | subLe : (a : Word 256) -> (b : Word 256) -> (0 p : Le b a) -> (Word 256 -> Tx) -> Tx
def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def get : Type 0 := (prod () : Type 0)
def Entry : Type 0 := sum (get)
def constructor : Eff := ret (word 256 0)
def safe : AddFits (word 256 2) (word 256 3) := tuple ()
def main : Entry -> Tx := fun (entry : Entry) => case entry with
  | 0 (args : get) => addLt (word 256 2) (word 256 3) safe
    (fun (v : Word 256) => done v)

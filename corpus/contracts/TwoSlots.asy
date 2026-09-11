-- M0 protocol.  Concrete Word payloads are checked by the emitter.
mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> Nat -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
axiom EvmOpcodes : Prop

def Storage : Type 0 := prod (Word 256, Word 256)
def storage : Storage := tuple (word 256 0, word 256 1)

def main : Eff := put storage.0 (word 256 11) (put storage.1 (word 256 22) (read storage.1))

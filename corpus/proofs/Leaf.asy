-- M0 protocol.  Concrete Word payloads are checked by the emitter.
mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> Nat -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
axiom EvmOpcodes : Prop

def Storage : Type 0 := prod (Word 256)
def storage : Storage := tuple (word 256 0)
axiom witness : EvmOpcodes
def identityProof : EvmOpcodes -> EvmOpcodes := fun (p : EvmOpcodes) => p
def withProof : (0 p : EvmOpcodes) -> Word 256 -> Word 256 := fun (0 p : EvmOpcodes) (x : Word 256) => x

def main : Eff := ret (withProof (witness) (word 256 42))

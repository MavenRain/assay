def InRange : Nat -> Nat -> Prop := fun (bits : Nat) (n : Nat) =>
  case natEq bits 256 as w return Prop with
  | 0 (_u : prod ()) => sum ()
  | 1 (_u : prod ()) => case natLt n 115792089237316195423570985008687907853269984665640564039457584007913129639936 as flag return Prop with
    | 0 (_v : prod ()) => sum () | 1 (_v : prod ()) => prod ()
mu Word : (0 bits : Nat) -> Type 0 :=
  | word : (0 bits : Nat) -> (n : Nat) -> (0 p : InRange bits n) -> Word bits
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
axiom EvmOpcodes : Prop
def bad : Word 256 := word 256 115792089237316195423570985008687907853269984665640564039457584007913129639936 (tuple ())

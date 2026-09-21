-- Hex constants share the checked Word representation used by decimal literals.
contract HexWords where
  storage State := { cell : Word }
  error TooLarge (value : Word) (limit : Word)
  invariant bounded (s : State) : Prop := Le s.cell (word 0xFF)
  entry set (next : Word) : Eff Sig Word := do
    sstore cell (word 0x01) ;
    (0 bound : Le next (word 255)) <- guard TooLarge (next) (word 0xff) (leWord next (word 0XFF)) ;
    sstore cell next ; pure next
  entry literalAddress () : Eff Sig Word := do
    pure (word 0x1234567890aBcDEF1234567890abcdef12345678)
  entry mask () : Eff Sig Word := do
    pure (word 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
  constructor := do sstore cell (word 0x0A) ; pure ()

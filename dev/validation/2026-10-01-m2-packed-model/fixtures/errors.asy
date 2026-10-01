contract PackedStorage where
  storage State := { count : Uint8 ; enabled : Bool ; owner : Address ; total : Uint256 }

  error Denied (code : Word)
  entry denyPacked () : Eff Sig Word := do sstore count (word 9) ; revert Denied (word 9)
  entry dirtyAfterWrite () : Eff Sig Word := do
    sstore count (word 9) ; value <- sload enabled ; pure value
  entry repairThenRead () : Eff Sig Word := do
    sstore enabled (word 1) ; value <- sload enabled ; pure value
  entry skipDirty () : Eff Sig Word := do pure (word 42)

  constructor := do pure ()

contract PackedStorage where
  storage State := { count : Uint8 ; enabled : Bool ; owner : Address ; total : Uint256 }

  error Denied (code : Word)
  entry addCount (delta : Word) : Eff Sig Word := do
    old <- sload count ; value <- add old delta ; sstore count value ; pure value
  entry readCount () : Eff Sig Word := do value <- sload count ; pure value
  fallback : Eff Sig Never := revert Denied (word 23)

  constructor := do pure ()

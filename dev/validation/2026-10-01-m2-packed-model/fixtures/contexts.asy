contract PackedStorage where
  storage State := { count : Uint8 ; enabled : Bool ; owner : Address ; total : Uint256 }

  error Denied (code : Word)
  payable entry amount () : Eff Sig Word := do
    value <- callvalue ; sstore count value ; size <- calldatasize ; pure size
  entry loadArg (offset : Word) : Eff Sig Word := do value <- calldataload offset ; pure value
  entry self () : Eff Sig Word := do value <- address ; sstore total value ; pure value
  entry sender () : Eff Sig Word := do value <- caller ; sstore owner value ; pure value

  constructor := do pure ()

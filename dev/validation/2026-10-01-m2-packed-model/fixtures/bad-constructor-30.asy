contract PackedStorage where
  storage State := { count : Uint8 ; enabled : Bool ; owner : Address ; total : Uint256 }

  entry readCount () : Eff Sig Word := do value <- sload count ; pure value
  entry readEnabled () : Eff Sig Word := do value <- sload enabled ; pure value
  entry readOwner () : Eff Sig Word := do value <- sload owner ; pure value
  entry readTotal () : Eff Sig Word := do value <- sload total ; pure value
  entry setCount (value : Word) : Eff Sig Word := do sstore count value ; pure value
  entry setEnabled (value : Word) : Eff Sig Word := do sstore enabled value ; pure value
  entry setOwner (value : Word) : Eff Sig Word := do sstore owner value ; pure value
  entry setTotal (value : Word) : Eff Sig Word := do sstore total value ; pure value
  entry setPair (countValue : Word) (boolValue : Word) : Eff Sig Word := do
    sstore count countValue ; sstore enabled boolValue ; pure countValue

  constructor := do
    sstore count (word 256) ; sstore enabled (word 1) ; deployer owner ; pure ()

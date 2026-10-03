contract FunctionCalldata where
  storage State := { flag : Bool ; amount : Uint256 }
  entry narrow (value : Uint8) : Eff Sig Word := do pure value
  entry addressOf (value : Address) : Eff Sig Word := do pure value
  entry boolean (value : Bool) : Eff Sig Word := do sstore flag value ; pure value
  entry wide (value : Uint256) : Eff Sig Word := do sstore amount value ; pure value
  entry lengthOf (message : String) : Eff Sig Word := do
    size <- stringlength message ; pure size
  entry firstWord (message : String) : Eff Sig Word := do
    start <- stringdata message ; value <- calldataload start ; pure value
  entry secondLength (first : String) (second : String) (enabled : Bool) : Eff Sig Word := do
    size <- stringlength second ; sstore flag enabled ; pure size
  entry legacy (value : Word) : Eff Sig Word := do pure value
  constructor := do sstore amount (word 7) ; pure ()

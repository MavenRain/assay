contract ReturnData where
  storage State := { cell : Word }
  error Denied ()
  error Narrow (value : Uint8)
  error Wrapped (amount : Uint8) (owner : Address) (enabled : Bool) (message : String)
  error Pair (first : String) (second : String)
  entry narrow (value : Word) : Eff Sig Uint8 := do sstore cell value ; pure value
  entry addressOf (value : Word) : Eff Sig Address := do pure value
  entry boolean (value : Word) : Eff Sig Bool := do pure value
  entry wide (value : Uint256) : Eff Sig Uint256 := do pure value
  entry echo (message : String) : Eff Sig String := do sstore cell (word 9) ; pure message
  entry echoLast (first : String) (last : String) : Eff Sig String := do pure (last)
  entry deny () : Eff Sig Word := do revert Denied ()
  entry fail (amount : Uint8) (owner : Address) (enabled : Bool) (message : String) : Eff Sig Word :=
    do sstore cell amount ; revert Wrapped (amount) (owner) (enabled) (message)
  entry failPair (first : String) (second : String) : Eff Sig Word :=
    do sstore cell (word 99) ; revert Pair (first) (second)
  entry duplicate (message : String) : Eff Sig Word := do revert Pair (message) (message)
  entry narrowError (value : Word) : Eff Sig Word := do sstore cell value ; revert Narrow (value)
  entry legacy (value : Word) : Eff Sig Word := do pure value
  constructor := do sstore cell (word 7) ; pure ()

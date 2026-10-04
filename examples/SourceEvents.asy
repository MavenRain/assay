contract SourceEvents where
  storage State := { count : Uint8 ; neighbor : Uint8 }
  event Transfer (from : Address indexed) (to : Address indexed) (amount : Uint256)
  event Text (tag : String indexed) (message : String)
  event Hidden (first : Uint256 indexed) (second : Address indexed) (third : Bool indexed) (fourth : Uint8 indexed) anonymous
  event Tick ()
  event Data (amount : Uint8) (enabled : Bool) (owner : Address)
  error Denied ()
  entry transfer (from : Address) (to : Address) (amount : Uint256) : Eff Sig Word :=
    do emit Transfer (from) (to) (amount) ; pure amount
  entry text (tag : String) (message : String) : Eff Sig String :=
    do emit Text (tag) (message) ; pure message
  entry hidden (a : Uint256) (b : Address) (c : Bool) (d : Uint8) : Eff Sig Word :=
    do emit Hidden (a) (b) (c) (d) ; pure a
  entry tick () : Eff Sig Word := do emit Tick () ; pure (word 0)
  entry data (amount : Word) (enabled : Word) (owner : Word) : Eff Sig Word :=
    do emit Data (amount) (enabled) (owner) ; pure amount
  entry twice (value : Uint8) : Eff Sig Word :=
    do emit Tick () ; sstore count value ; emit Data (value) (word 1) (word 2) ; pure value
  entry fail (value : Uint8) : Eff Sig Word :=
    do emit Tick () ; sstore count value ; emit Data (value) (word 1) (word 2) ; revert Denied ()
  entry narrowReturn (value : Word) : Eff Sig Uint8 := do emit Tick () ; pure value
  entry get () : Eff Sig Word := do value <- sload count ; pure value
  constructor := do sstore count (word 7) ; sstore neighbor (word 3) ; pure ()

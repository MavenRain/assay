contract Invalid where storage State := { balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) }
entry get (key : Word) : Eff Sig Word := do value <- sload balances key ; pure value
constructor := do deployer balances ; pure ()

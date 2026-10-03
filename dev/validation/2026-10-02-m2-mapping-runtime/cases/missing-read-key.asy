contract Invalid where storage State := { balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) }
entry bad () : Eff Sig Word := do value <- sload balances ; pure value

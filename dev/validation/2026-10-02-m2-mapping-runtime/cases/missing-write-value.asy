contract Invalid where storage State := { balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) }
entry bad (key : Word) : Eff Sig Word := do sstore balances key ; pure key

contract Invalid where storage State := { balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) }
entry echo (balances : Word) : Eff Sig Word := do pure balances

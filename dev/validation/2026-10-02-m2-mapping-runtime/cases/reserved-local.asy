contract Invalid where storage State := { balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) }
entry bad (assayMap0 : Word) : Eff Sig Word := do pure assayMap0

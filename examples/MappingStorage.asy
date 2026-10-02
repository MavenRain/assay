contract MappingStorage where
  storage State := {
    enabled : Bool ;
    owner : Address ;
    balances : Mapping Address Uint256 ;
    allowances : Mapping Address (Mapping Address Uint256) ;
    total : Uint256 ;
    count : Uint8
  }

  entry zero () : Eff Sig Word := do pure 0

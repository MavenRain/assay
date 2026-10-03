contract MappingAccess where
  storage State := {
    enabled : Bool ; owner : Address ;
    balances : Mapping Address Uint256 ;
    allowances : Mapping Address (Mapping Address Uint256) ;
    narrow : Mapping Uint8 Uint8 ;
    flags : Mapping Bool Bool ;
    triple : Mapping Address (Mapping Address (Mapping Bool Uint256)) ;
    wide : Mapping Uint256 Address ;
    count : Uint8
  }

  entry balanceOf (account : Word) : Eff Sig Word := do
    value <- sload balances account ; pure value
  entry allowance (account : Word) (spender : Word) : Eff Sig Word := do
    value <- sload allowances account spender ; pure value
  entry setBalance (account : Word) (amount : Word) : Eff Sig Word := do
    sstore balances account amount ; pure amount
  entry approve (account : Word) (spender : Word) (amount : Word) : Eff Sig Word := do
    sstore allowances account spender amount ; pure amount
  entry move (sender : Word) (receiver : Word) (amount : Word) : Eff Sig Word := do
    before <- sload balances sender ;
    debited <- sub before amount ; sstore balances sender debited ;
    destination <- sload balances receiver ; credited <- add destination amount ;
    sstore balances receiver credited ; pure credited
  entry setNarrow (key : Word) (amount : Word) : Eff Sig Word := do
    sstore count (word 7) ; sstore narrow key amount ; pure amount
  entry readNarrow (key : Word) : Eff Sig Word := do
    value <- sload narrow key ; pure value
  entry setFlag (key : Word) (value : Word) : Eff Sig Word := do
    sstore flags key value ; pure value
  entry readFlag (key : Word) : Eff Sig Word := do
    value <- sload flags key ; pure value
  entry setTriple (account : Word) (spender : Word) (key : Word) (amount : Word) : Eff Sig Word := do
    sstore triple account spender key amount ; pure amount
  entry readTriple (account : Word) (spender : Word) (key : Word) : Eff Sig Word := do
    value <- sload triple account spender key ; pure value
  entry setWide (key : Word) (value : Word) : Eff Sig Word := do
    sstore wide key value ; pure value
  entry readWide (key : Word) : Eff Sig Word := do
    value <- sload wide key ; pure value
  entry setEnabled (value : Word) : Eff Sig Word := do
    sstore enabled value ; pure value
  entry readOwner () : Eff Sig Word := do value <- sload owner ; pure value

  constructor := do
    sstore enabled (word 1) ; deployer owner ;
    sstore balances (word 1) (word 42) ;
    sstore allowances (word 1) (word 2) (word 9) ; pure ()

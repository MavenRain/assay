-- Fixed supply ERC20 fixture. The genesis holder is the reference test account.
-- Allowances are always spent, including the maximum word and owner calls.
contract ERC20 where
  storage State := {
    supply : Uint256 ;
    balances : Mapping Address Uint256 ;
    allowances : Mapping Address (Mapping Address Uint256)
  }
  event Transfer (from : Address indexed) (to : Address indexed) (value : Uint256)
  event Approval (owner : Address indexed) (spender : Address indexed) (value : Uint256)

  entry name () : Eff Sig String := do pure (string 0x41737361792054657374)
  entry symbol () : Eff Sig String := do pure (string 0x415359)
  entry decimals () : Eff Sig Uint8 := do pure (word 18)
  entry totalSupply () : Eff Sig Uint256 := do value <- sload supply ; pure value
  entry balanceOf (owner : Address) : Eff Sig Uint256 :=
    do value <- sload balances owner ; pure value
  entry allowance (owner : Address) (spender : Address) : Eff Sig Uint256 :=
    do value <- sload allowances owner spender ; pure value

  entry transfer (to : Address) (value : Uint256) : Eff Sig Bool := do
    sender <- caller ;
    guard le (word 1) sender ; guard le (word 1) to ;
    before <- sload balances sender ; debited <- sub before value ;
    sstore balances sender debited ;
    destination <- sload balances to ; credited <- add destination value ;
    sstore balances to credited ;
    emit Transfer (sender) (to) (value) ; pure (word 1)

  entry approve (spender : Address) (value : Uint256) : Eff Sig Bool := do
    sender <- caller ; sstore allowances sender spender value ;
    emit Approval (sender) (spender) (value) ; pure (word 1)

  entry transferFrom (from : Address) (to : Address) (value : Uint256) : Eff Sig Bool := do
    sender <- caller ;
    guard le (word 1) from ; guard le (word 1) to ;
    approved <- sload allowances from sender ; remaining <- sub approved value ;
    sstore allowances from sender remaining ;
    before <- sload balances from ; debited <- sub before value ;
    sstore balances from debited ;
    destination <- sload balances to ; credited <- add destination value ;
    sstore balances to credited ;
    emit Transfer (from) (to) (value) ; pure (word 1)

  constructor := do
    sstore supply (word 1000) ;
    sstore balances (word 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf) (word 1000) ; pure ()

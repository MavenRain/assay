contract PackedStorage where
  storage State := { count : Uint8 ; enabled : Bool ; owner : Address ; total : Uint256 }

  error Denied (code : Word)
  entry addCount (delta : Word) : Eff Sig Word := do
    old <- sload count ; value <- add old delta ; sstore count value ; pure value
  entry bumpAfterWrite (delta : Word) : Eff Sig Word := do
    sstore count (word 9) ; old <- sload count ; value <- add old delta ; sstore total value ; pure value
  entry subCount (delta : Word) : Eff Sig Word := do
    old <- sload count ; value <- sub old delta ; sstore count value ; pure value
  entry proven (delta : Word) : Eff Sig Word := do
    old <- sload count ; guard (lt256 (add old delta)) ;
    let value := addLt old delta ; sstore count value ; pure value
  entry guarded (cap : Word) : Eff Sig Word := do
    sstore count (word 7) ; guard (leWord (word 7) cap) ; pure (word 7)

  constructor := do pure ()

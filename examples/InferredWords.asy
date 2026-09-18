contract InferredWords where
  storage State := { cell : Word }
  error TooSmall (actual : Word)
  entry test (a : Word) : Eff Sig Word :=
    do let floor := word 0x0A ;
       guard TooSmall (a) (leWord floor a) ;
       let result := subLe a floor ;
       sstore cell result ; pure result
  constructor := do sstore cell (word 7) ; pure ()

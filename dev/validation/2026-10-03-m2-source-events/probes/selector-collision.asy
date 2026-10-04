contract EventCollision where
storage State := { cell : Word }
event Collision64007 ()
error DeniedCollision973 ()
entry fail () : Eff Sig Word := do
  guard DeniedCollision973 () (leWord (word 1) (word 0)) ; pure (word 0)
entry log () : Eff Sig Word := do emit Collision64007 () ; pure (word 0)

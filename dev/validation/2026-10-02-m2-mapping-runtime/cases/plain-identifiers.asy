contract Plain where storage State := { count : Word }
entry echo (Mapping : Word) (assayMapUser : Word) : Eff Sig Word := do pure Mapping

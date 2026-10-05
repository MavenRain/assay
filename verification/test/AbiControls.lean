import AssayProofs.Storage

open AssayProofs AssayProofs.Storage

namespace AbiControls

def byteValue : Refined .uint8 := ⟨255, of_decide_eq_true rfl⟩
def wordValue : Refined .uint256 := ⟨modulus - 1, of_decide_eq_true rfl⟩
def addressValue : Refined .address := ⟨2 ^ 160 - 1, of_decide_eq_true rfl⟩
def boolValue : Refined .bool := ⟨1, of_decide_eq_true rfl⟩
def zero : Word := ⟨0, of_decide_eq_true rfl⟩
def lastByte : Field := ⟨.uint8, 31, zero, of_decide_eq_true rfl⟩
def slotCell : Cell := { slot := zero, value := zero }
def valueCell : Cell := { slot := zero, value := zero }
theorem accepted : (refine .uint8 255).val = .ok byteValue := rfl
theorem rejected : (refine .uint8 256).val = .error (.outOfRange .uint8) := rfl

end AbiControls

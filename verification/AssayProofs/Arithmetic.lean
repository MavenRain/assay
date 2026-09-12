import Init

namespace AssayProofs

def modulus : Nat := 2 ^ 256
abbrev Word := Fin modulus

inductive Arithmetic where
  | add
  | sub
  deriving BEq, Repr

inductive ArithmeticError where
  | overflow
  | underflow
  deriving BEq, Repr

/-- Exact natural arithmetic, with an explicit rejection boundary. -/
def Meaning (op : Arithmetic) (a b : Word) : Except ArithmeticError Word → Prop
  | .ok value => match op with
    | .add => value.val = a.val + b.val
    | .sub => b.val ≤ a.val ∧ value.val = a.val - b.val
  | .error error => match op, error with
    | .add, .overflow => ¬ a.val + b.val < modulus
    | .sub, .underflow => ¬ b.val ≤ a.val
    | .add, .underflow | .sub, .overflow => False

/-- The certificate is in Prop and is erased by Lean compilation. -/
abbrev Checked (op : Arithmetic) (a b : Word) :=
  { result : Except ArithmeticError Word // Meaning op a b result }

def checked (op : Arithmetic) (a b : Word) : Checked op a b :=
  match op with
  | .add =>
    if bound : a.val + b.val < modulus then
      ⟨.ok ⟨a.val + b.val, bound⟩, rfl⟩
    else ⟨.error .overflow, bound⟩
  | .sub =>
    if order : b.val ≤ a.val then
      ⟨.ok ⟨a.val - b.val, Nat.sub_lt_of_lt a.isLt⟩, order, rfl⟩
    else ⟨.error .underflow, order⟩

theorem checked_meaning (op : Arithmetic) (a b : Word) :
    Meaning op a b (checked op a b).val :=
  (checked op a b).property

theorem checked_add_exact (a b value : Word)
    (accepted : (checked .add a b).val = .ok value) :
    value.val = a.val + b.val :=
  Eq.mp (congrArg (Meaning .add a b) accepted) (checked_meaning .add a b)

theorem checked_sub_exact (a b value : Word)
    (accepted : (checked .sub a b).val = .ok value) :
    b.val ≤ a.val ∧ value.val = a.val - b.val :=
  Eq.mp (congrArg (Meaning .sub a b) accepted) (checked_meaning .sub a b)

theorem checked_add_rejects (a b : Word)
    (rejected : (checked .add a b).val = .error .overflow) :
    ¬ a.val + b.val < modulus :=
  Eq.mp (congrArg (Meaning .add a b) rejected) (checked_meaning .add a b)

theorem checked_sub_rejects (a b : Word)
    (rejected : (checked .sub a b).val = .error .underflow) :
    ¬ b.val ≤ a.val :=
  Eq.mp (congrArg (Meaning .sub a b) rejected) (checked_meaning .sub a b)

theorem word_bounded (value : Word) : value.val < modulus := value.isLt

end AssayProofs

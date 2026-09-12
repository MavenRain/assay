import AssayProofs.Arithmetic

namespace AssayProofs

abbrev Storage := List (Word × Word)
abbrev Memory := List (Nat × Word)

def zero : Word := ⟨0, Nat.zero_lt_succ _⟩

def readStorage (storage : Storage) (slot : Word) : Word :=
  match storage with
  | [] => zero
  | (key, value) :: rest => if key == slot then value else readStorage rest slot

def writeStorage (storage : Storage) (slot value : Word) : Storage :=
  let rest := storage.filter (fun row => row.1 != slot)
  if value == zero then rest else (slot, value) :: rest

inductive Operand where
  | literal (value : Word)
  | memory (index : Nat)

inductive SourceError where
  | missingMemory (index : Nat)
  deriving BEq, Repr

def readMemory (memory : Memory) (index : Nat) : Except SourceError Word :=
  match memory with
  | [] => .error (.missingMemory index)
  | (key, value) :: rest => if key == index then .ok value else readMemory rest index

def operand (memory : Memory) : Operand → Except SourceError Word
  | .literal value => .ok value
  | .memory index => readMemory memory index

/-- Both Result continuations are present at every arithmetic node. -/
inductive Transaction where
  | finish (value : Operand)
  | abort
  | store (slot : Word) (value : Operand) (next : Transaction)
  | load (slot : Word) (index : Nat) (next : Transaction)
  | arithmetic (op : Arithmetic) (left right : Operand) (index : Nat)
      (yes no : Transaction)
  | compare (left right : Operand) (yes no : Transaction)

inductive Outcome where
  | success (value : Word) (storage : Storage)
  | revert (storage : Storage)

/-- An observable arithmetic step, without embedded evidence. -/
structure Event where
  operation : Arithmetic
  left : Word
  right : Word
  result : Except ArithmeticError Word

structure Execution where
  outcome : Outcome
  events : List Event

/-- Overflow freedom covers every arithmetic event, including handled errors. -/
def OverflowFree (execution : Execution) : Prop :=
  ∀ event, event ∈ execution.events →
    Meaning event.operation event.left event.right event.result

abbrev CertifiedExecution := { execution : Execution // OverflowFree execution }

def terminal (outcome : Outcome) : CertifiedExecution :=
  ⟨⟨outcome, []⟩, fun _event member => False.elim (List.not_mem_nil member)⟩

def record (op : Arithmetic) (a b : Word) (result : Checked op a b)
    (tail : CertifiedExecution) : CertifiedExecution :=
  ⟨⟨tail.val.outcome, ⟨op, a, b, result.val⟩ :: tail.val.events⟩,
    fun event member => Or.elim (List.mem_cons.mp member)
      (fun same => Eq.mp (congrArg
        (fun step => Meaning step.operation step.left step.right step.result) same.symm) result.property)
      (fun rest => tail.property event rest)⟩

def executeCertified (initial storage : Storage) (memory : Memory) :
    Transaction → Except SourceError CertifiedExecution
  | .finish value => do
    let value ← operand memory value
    return terminal (.success value storage)
  | .abort => .ok (terminal (.revert initial))
  | .store slot value next => do
    let value ← operand memory value
    executeCertified initial (writeStorage storage slot value) memory next
  | .load slot index next =>
    executeCertified initial storage ((index, readStorage storage slot) :: memory) next
  | .arithmetic op left right index yes no => do
    let a ← operand memory left
    let b ← operand memory right
    let result := checked op a b
    let tail ← match result.val with
      | .ok value => executeCertified initial storage ((index, value) :: memory) yes
      | .error .overflow | .error .underflow => executeCertified initial storage memory no
    return record op a b result tail
  | .compare left right yes no => do
    let a ← operand memory left
    let b ← operand memory right
    if a.val ≤ b.val then executeCertified initial storage memory yes
    else executeCertified initial storage memory no

def execute (initial storage : Storage) (memory : Memory) (program : Transaction) :
    Except SourceError Execution :=
  (executeCertified initial storage memory program).map Subtype.val

theorem execution_overflow_free (result : Except SourceError CertifiedExecution)
    (execution : Execution) (evaluated : result.map Subtype.val = .ok execution) :
    OverflowFree execution :=
  match result with
  | .error (_error) => nomatch evaluated
  | .ok certified =>
    Eq.mp (congrArg OverflowFree (Except.ok.inj evaluated)) certified.property

theorem source_overflow_free (initial storage : Storage) (memory : Memory)
    (program : Transaction) (execution : Execution)
    (evaluated : execute initial storage memory program = .ok execution) :
    OverflowFree execution :=
  execution_overflow_free (executeCertified initial storage memory program) execution evaluated

theorem abort_restores (initial storage : Storage) (memory : Memory) :
    execute initial storage memory .abort = .ok ⟨.revert initial, []⟩ := rfl

theorem event_add_exact (event : Event) (value : Word)
    (sound : Meaning event.operation event.left event.right event.result)
    (operation : event.operation = .add) (result : event.result = .ok value) :
    value.val = event.left.val + event.right.val :=
  Eq.mp (congrArg (Meaning .add event.left event.right) result)
    (Eq.mp (congrArg (fun op => Meaning op event.left event.right event.result) operation) sound)

theorem event_sub_exact (event : Event) (value : Word)
    (sound : Meaning event.operation event.left event.right event.result)
    (operation : event.operation = .sub) (result : event.result = .ok value) :
    event.right.val ≤ event.left.val ∧ value.val = event.left.val - event.right.val :=
  Eq.mp (congrArg (Meaning .sub event.left event.right) result)
    (Eq.mp (congrArg (fun op => Meaning op event.left event.right event.result) operation) sound)

end AssayProofs

import AssayProofs.Arithmetic

namespace AssayProofs.Storage

inductive Scalar where
  | uint8 | uint256 | address | bool
  deriving BEq, Repr

def Scalar.width : Scalar → Nat
  | .uint8 | .bool => 1
  | .uint256 => 32
  | .address => 20

def Scalar.limit : Scalar → Nat
  | .uint8 => 2 ^ 8
  | .uint256 => modulus
  | .address => 2 ^ 160
  | .bool => 2

abbrev Refined (scalar : Scalar) := Fin scalar.limit

inductive Error where
  | invalidLocation
  | outOfRange (scalar : Scalar)
  | certificateFailure
  deriving Repr

def RefinementMeaning (scalar : Scalar) (value : Nat) :
    Except Error (Refined scalar) → Prop
  | .ok refined => refined.val = value
  | .error (.outOfRange rejected) => rejected = scalar ∧ ¬ value < scalar.limit
  | .error .invalidLocation | .error .certificateFailure => False

abbrev CheckedRefinement (scalar : Scalar) (value : Nat) :=
  { result : Except Error (Refined scalar) // RefinementMeaning scalar value result }

def refine (scalar : Scalar) (value : Nat) : CheckedRefinement scalar value :=
  if bound : value < scalar.limit then ⟨.ok ⟨value, bound⟩, rfl⟩
  else ⟨.error (.outOfRange scalar), rfl, bound⟩

theorem refinement_exact (scalar : Scalar) (value : Nat) (refined : Refined scalar)
    (accepted : (refine scalar value).val = .ok refined) : refined.val = value :=
  Eq.mp (congrArg (RefinementMeaning scalar value) accepted) (refine scalar value).property

theorem refinement_rejects (scalar : Scalar) (value : Nat)
    (rejected : (refine scalar value).val = .error (.outOfRange scalar)) :
    ¬ value < scalar.limit :=
  (Eq.mp (congrArg (RefinementMeaning scalar value) rejected)
    (refine scalar value).property).2

theorem refined_bounded (scalar : Scalar) (value : Refined scalar) :
    value.val < scalar.limit := value.isLt

/-- Field allocation is evidence in Prop; slots and stored values are Words. -/
structure Field where
  scalar : Scalar
  offset : Nat
  slot : Word
  fits : offset + scalar.width ≤ 32

def field (scalar : Scalar) (offset : Nat) (slot : Word) : Except Error Field :=
  if fits : offset + scalar.width ≤ 32 then .ok ⟨scalar, offset, slot, fits⟩
  else .error .invalidLocation

theorem field_fits (location : Field) :
    location.offset + location.scalar.width ≤ 32 := location.fits

def shift (location : Field) : Nat := 2 ^ (location.offset * 8)
def lane (location : Field) : Nat := 2 ^ (location.scalar.width * 8)
def rawRead (location : Field) (word : Word) : Nat :=
  word.val / shift location % lane location

def read (location : Field) (word : Word) : CheckedRefinement location.scalar
    (rawRead location word) := refine location.scalar (rawRead location word)

/-- Reads preserve the extracted integer and certify its scalar bound. -/
theorem read_exact (location : Field) (word : Word) (value : Refined location.scalar)
    (accepted : (read location word).val = .ok value) :
    value.val = rawRead location word :=
  refinement_exact location.scalar (rawRead location word) value accepted

def candidate (location : Field) (word : Word) (value : Refined location.scalar) : Nat :=
  word.val - rawRead location word * shift location + value.val * shift location

/-- Both sides of the entire storage lane are preserved, including unused bits. -/
def WriteMeaning (location : Field) (before : Word) (value : Refined location.scalar)
    (after : Word) : Prop :=
  after.val = candidate location before value ∧
  rawRead location after = value.val ∧
  after.val % shift location = before.val % shift location ∧
  after.val / (shift location * lane location) =
    before.val / (shift location * lane location)

abbrev CertifiedWrite (location : Field) (before : Word)
    (value : Refined location.scalar) :=
  { after : Word // WriteMeaning location before value after }

/-- Check the production replacement formula against explicit lane obligations. -/
def write (location : Field) (before : Word) (value : Refined location.scalar) :
    Except Error (CertifiedWrite location before value) :=
  let result := candidate location before value
  if certificate : result < modulus ∧
      result / shift location % lane location = value.val ∧
      result % shift location = before.val % shift location ∧
      result / (shift location * lane location) =
        before.val / (shift location * lane location) then
    .ok ⟨⟨result, certificate.1⟩, rfl, certificate.2⟩
  else .error .certificateFailure

theorem write_exact (location : Field) (before : Word) (value : Refined location.scalar)
    (after : CertifiedWrite location before value) :
    after.val.val = candidate location before value := after.property.1

theorem write_readback (location : Field) (before : Word) (value : Refined location.scalar)
    (after : CertifiedWrite location before value) :
    rawRead location after.val = value.val := after.property.2.1

theorem write_preserves_low (location : Field) (before : Word)
    (value : Refined location.scalar) (after : CertifiedWrite location before value) :
    after.val.val % shift location = before.val % shift location := after.property.2.2.1

theorem write_preserves_high (location : Field) (before : Word)
    (value : Refined location.scalar) (after : CertifiedWrite location before value) :
    after.val.val / (shift location * lane location) =
      before.val / (shift location * lane location) := after.property.2.2.2

theorem write_bounded (location : Field) (before : Word) (value : Refined location.scalar)
    (after : CertifiedWrite location before value) : after.val.val < modulus :=
  after.val.isLt

/-- Scalar and mapping storage share a first-order Word cell representation. -/
private theorem Scalar.limit_le_lane : (scalar : Scalar) → scalar.limit ≤ 2 ^ (scalar.width * 8)
  | .uint8 => Nat.le_of_ble_eq_true rfl
  | .uint256 => Nat.le_of_ble_eq_true rfl
  | .address => Nat.le_of_ble_eq_true rfl
  | .bool => Nat.le_of_ble_eq_true rfl

private theorem lane_split (w s L v : Nat) :
    w - w / s % L * s + v * s = w % s + v * s + w / s / L * L * s :=
  have whole : w = w % s + w / s / L * L * s + w / s % L * s :=
    ((Nat.mod_add_div' w s).symm.trans
      (congrArg (fun t => w % s + t * s) (Nat.div_add_mod' (w / s) L).symm)).trans
      ((congrArg (w % s + ·) (Nat.add_mul (w / s / L * L) (w / s % L) s)).trans
        (Nat.add_assoc _ _ _).symm)
  (congrArg (· + v * s) ((congrArg (· - w / s % L * s) whole).trans (Nat.add_sub_cancel _ _))).trans
    (Nat.add_right_comm _ _ _)

private theorem lane_bound (a v s L : Nat) (ha : a < s) (hv : v < L) : a + v * s < s * L :=
  Nat.lt_of_lt_of_le (Nat.add_lt_add_right ha (v * s))
    (Nat.le_trans (Nat.le_of_eq ((Nat.add_comm s (v * s)).trans (Nat.succ_mul v s).symm))
      (Nat.le_trans (Nat.mul_le_mul_right s (Nat.succ_le_of_lt hv))
        (Nat.le_of_eq (Nat.mul_comm L s))))

private theorem split_mod (a v q s L : Nat) : (a + v * s + q * L * s) % s = a % s :=
  (Nat.add_mul_mod_self_right (a + v * s) (q * L) s).trans (Nat.add_mul_mod_self_right a v s)

private theorem split_div (a v q s L : Nat) (spos : 0 < s) (ha : a < s) :
    (a + v * s + q * L * s) / s = v + q * L :=
  (Nat.add_mul_div_right (a + v * s) (q * L) spos).trans
    (congrArg (· + q * L) ((Nat.add_mul_div_right a v spos).trans
      ((congrArg (· + v) (Nat.div_eq_of_lt ha)).trans (Nat.zero_add v))))

private theorem split_read (a v q s L : Nat) (spos : 0 < s) (ha : a < s) (hv : v < L) :
    (a + v * s + q * L * s) / s % L = v :=
  (congrArg (· % L) (split_div a v q s L spos ha)).trans
    ((Nat.add_mul_mod_self_right v q L).trans (Nat.mod_eq_of_lt hv))

private theorem regroup (q s L : Nat) : q * L * s = q * (s * L) :=
  (Nat.mul_assoc q L s).trans (congrArg (q * ·) (Nat.mul_comm L s))

private theorem split_high (a v q s L : Nat) (pos : 0 < s * L) (bound : a + v * s < s * L) :
    (a + v * s + q * L * s) / (s * L) = q :=
  (congrArg (fun t => (a + v * s + t) / (s * L)) (regroup q s L)).trans
    ((Nat.add_mul_div_right (a + v * s) q pos).trans
      ((congrArg (· + q) (Nat.div_eq_of_lt bound)).trans (Nat.zero_add q)))

private theorem split_lt (a v q s L M : Nat) (bound : a + v * s < s * L) (hq : q < M) :
    a + v * s + q * L * s < s * L * M :=
  Nat.lt_of_lt_of_le (Nat.add_lt_add_right bound (q * L * s))
    (Nat.le_trans (Nat.le_of_eq ((congrArg (s * L + ·) (regroup q s L)).trans
        ((Nat.add_comm (s * L) (q * (s * L))).trans (Nat.succ_mul q (s * L)).symm)))
      (Nat.le_trans (Nat.mul_le_mul_right (s * L) (Nat.succ_le_of_lt hq))
        (Nat.le_of_eq (Nat.mul_comm M (s * L)))))

private theorem lane_pow (location : Field) :
    shift location * lane location = 2 ^ (location.offset * 8 + location.scalar.width * 8) :=
  (Nat.pow_add 2 _ _).symm

private theorem lane_exponent (location : Field) :
    location.offset * 8 + location.scalar.width * 8 ≤ 256 :=
  Nat.le_trans (Nat.le_of_eq (Nat.add_mul location.offset location.scalar.width 8).symm)
    (Nat.mul_le_mul_right 8 location.fits)

private theorem modulus_split (location : Field) :
    modulus = shift location * lane location *
      2 ^ (256 - (location.offset * 8 + location.scalar.width * 8)) :=
  ((congrArg (2 ^ ·) (Nat.add_sub_of_le (lane_exponent location)).symm).trans
    (Nat.pow_add 2 _ _)).trans
    (congrArg (· * 2 ^ (256 - (location.offset * 8 + location.scalar.width * 8)))
      (lane_pow location).symm)

private theorem write_certificate (location : Field) (before : Word)
    (value : Refined location.scalar) :
    candidate location before value < modulus ∧
    candidate location before value / shift location % lane location = value.val ∧
    candidate location before value % shift location = before.val % shift location ∧
    candidate location before value / (shift location * lane location) =
      before.val / (shift location * lane location) :=
  have spos : 0 < shift location := Nat.two_pow_pos _
  have pos : 0 < shift location * lane location :=
    Nat.lt_of_lt_of_le (Nat.two_pow_pos _) (Nat.le_of_eq (lane_pow location).symm)
  have low : before.val % shift location < shift location := Nat.mod_lt _ spos
  have fits : value.val < lane location :=
    Nat.lt_of_lt_of_le value.isLt (Scalar.limit_le_lane location.scalar)
  have bound := lane_bound (before.val % shift location) value.val (shift location)
    (lane location) low fits
  have split : candidate location before value =
      before.val % shift location + value.val * shift location +
        before.val / shift location / lane location * lane location * shift location :=
    lane_split before.val (shift location) (lane location) value.val
  have above : before.val / shift location / lane location <
      2 ^ (256 - (location.offset * 8 + location.scalar.width * 8)) :=
    Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.div_div_eq_div_mul _ _ _))
      (Nat.div_lt_of_lt_mul (Nat.lt_of_lt_of_le before.isLt (Nat.le_of_eq (modulus_split location))))
  ⟨Nat.lt_of_le_of_lt (Nat.le_of_eq split)
     (Nat.lt_of_lt_of_le (split_lt _ _ _ _ _ _ bound above)
       (Nat.le_of_eq (modulus_split location).symm)),
   (congrArg (· / shift location % lane location) split).trans
     (split_read _ _ _ _ _ spos low fits),
   (congrArg (· % shift location) split).trans ((split_mod _ _ _ _ _).trans (Nat.mod_mod _ _)),
   (congrArg (· / (shift location * lane location)) split).trans
     ((split_high _ _ _ _ _ pos bound).trans (Nat.div_div_eq_div_mul _ _ _))⟩

/-- The production formula always meets its certificate, so write never reports a failure. -/
theorem write_total (location : Field) (before : Word) (value : Refined location.scalar) :
    ∃ after : CertifiedWrite location before value, write location before value = .ok after :=
  ⟨⟨⟨candidate location before value, (write_certificate location before value).1⟩, rfl,
    (write_certificate location before value).2⟩, dif_pos (write_certificate location before value)⟩

structure Cell where
  slot : Word
  value : Word

theorem cell_slot_bounded (cell : Cell) : cell.slot.val < modulus := cell.slot.isLt
theorem cell_value_bounded (cell : Cell) : cell.value.val < modulus := cell.value.isLt

end AssayProofs.Storage

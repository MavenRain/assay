# M2 storage and refinement evidence

M2 group 5 adds `AssayProofs.Storage` to the reusable Lean verification
library. It checks Uint8, Uint256, Address and Bool refinements, packed
field locations, and replacement of a lane in a 256-bit storage word.
The production Bend implementation remains in `src/layout.bend`.

## Checked representation

`Refined scalar` is a `Fin` at the scalar's actual limit: 256, 2^256,
2^160 or 2. `refine` returns an explicit result and an erased certificate.
Acceptance preserves the original integer. Rejection certifies that the
integer does not satisfy the strict bound. A Bool occupies a full byte
in storage while its value remains zero or one.

`Field` contains a Word slot, byte offset, scalar type, and proof that
the field ends within the 32-byte word. `field` rejects invalid offsets.
`read` extracts the whole lane and applies the scalar refinement, so a
noncanonical boolean byte is rejected.

`write` uses the production replacement formula, subtracting the old
lane and adding the new value at the field's shift. Before returning a
`CertifiedWrite`, it checks the Word bound, exact readback, and equality
of the lower remainder and upper quotient with the original word. This
check runs at run time. When it fails, `write` returns
`certificateFailure`. Invalid previous boolean bytes can be repaired by
replacing the whole byte.

Thirteen theorems expose refinement acceptance and rejection, refined
bounds, field bounds, read exactness, write exactness, readback, lower
and upper preservation, write bounds, write totality, and storage-cell
slot and value bounds. The five write projection theorems hold for a
write that the runtime check accepted. The theorem `write_total` closes
the gap between them and the runtime check: for every field, every word
below the Word bound and every value below the scalar limit, `write`
returns a `CertifiedWrite` and never `certificateFailure`. Preservation
of the bits outside the lane is therefore a proved property of `write`
on valid input. The executable comparison below is an independent check
of the same formula, not the only evidence for it.
Proofs use term expressions and the package has no external dependencies.

`StorageAxioms.lean` prints the axiom inventory of all thirteen
theorems. The gate oracle is strict. Twelve theorems must report `does
not depend on any axioms`, and any axiom name in one of their rows fails
the gate. Only `write_total` may list a non-empty subset of the Lean
core axioms `propext`, `Quot.sound` and `Classical.choice`, which it
inherits from core `Nat` division lemmas. That allowlist is the
per-theorem constant `CLASSICAL` in `dev/storage-proof-test.py`. The
oracle refuses `sorryAx` and unknown axiom names on every theorem. A
row with an empty axiom list also fails, and the report must list the
thirteen theorems in the declared order. Seven
negative controls exercise the oracle, including `propext` and
`Classical.choice` rows on `refinement_exact` and the live `write_total`
row with `sorryAx` prepended; each control must fail. The erasure leg
checks that none of the thirteen theorems reaches the compiled program
and that the four executable definitions do (`erasure=13`).

`Cell` declares the storage representation as a slot Word and a value
Word. Its two theorems are bound projections. The `storageModel` adapter
does not construct a `Cell`, and no gate connects it to the mapping slot
computation. The claim that mapping fields never lower to closures rests
on two facts outside this gate: the surface grammar admits only `Scalar`
and `Mapping` storage types (`Mapping.Source.Type` in
`src/frontend.bend`), and the emitter refuses closure storage with
`Recognize.Error.Storage_closure` (`src/emitter.bend`) before assembly.
The checks retain the existing production mapping model, constructor,
rollback and Cancun execution tests.

## Validation

Run `python3 -P dev/storage-proof-test.py` with the compiler pinned in
`dev/toolchain.json`. The gate compares 2,395 distinct access probes
against both production Bend results and independent Python bit masks.
They cover every legal offset, maximal words and values, unused bits,
readback, dirty boolean bytes, invalid slots, invalid words and invalid
locations.
Another 533 probes check scalar refinement, including exhaustive byte
values and each type's strict upper boundary.

The `storageModel` adapter reads every value text with `natural`, which
accepts a non-empty all-digit text and refuses every other text under
the label `invalid-value`, on both `refine` and `write`. There is no
length limit. An in-range value with leading zeros, such as `007` or 79
zeros, is accepted, and a 79-digit value reaches the scalar bound check
and is refused as `out-of-range`, not as a lexical error. These lexical
probes run only in the Lean adapter lane (`lean_cases` over the lexical
corpus in `dev/storage-proof-test.py`) against Python expectations; they
are not compared with the Bend result. Offsets and slots keep the label
`invalid-location` and the storage word keeps `invalid-word`. The text
`-1` is no longer a value in the access or refinement corpora. The four
refinement rows and the four write-value rows that carried it moved to
a separate lexical corpus of 17 rows (`lexical=17`), which also covers
`+1`, `abc`, an empty text, ` 1`, `007`, 79 zeros and a 79-digit top
value for `refine`, and `007` and `abc` for `write`. Six location and
word probes with `-1` stay in the access corpus as `invalid-location`
and `invalid-word` refusals.

Two source fixtures replace the mapping value type or the scalar field
type with `Word -> Word`. The compiler refuses both with the lexer
diagnostic `SURFACE_TOKEN: unexpected character` at `->`, while the
original mapping contract remains accepted. The oracle requires a
nonzero exit and the `SURFACE_TOKEN` diagnostic in stderr for each
fixture (`grammar=2`). These fixtures show that the surface grammar has
no arrow type; they do not exercise a schema or emitter rule. Seven Lean
mutations must be killed (`mutants=7`). Six must fail compilation:
relaxed refinement, field bounds, Word bounds, a `Cell` value of
function type, an incorrect write shift, and a `write` that refuses
valid input. The `Cell` mutation is a shape control on the declared
representation, not a behavioral kill. One compiling mutation, a
widened boolean limit, must fail a live witness. Seven corrupted axiom
reports must be refused (`controls=7`), as listed above. The erasure
leg compiles the module to C and searches the generated code for the
Lean-mangled symbol of each theorem; Lean mangles an underscore as
`__`, so the search uses the mangled form. All thirteen theorem symbols
must be absent, the four executable definitions must be present, and a
positive control confirms that the same search finds a probe marker
that is present. `erasure=13` is the measured count of absent theorem
symbols.

The full success marker is:

```text
STORAGE-PROOFS theorems=13 accesses=2395 refinements=533 lexical=17 grammar=2 mutants=7 controls=7 erasure=13 OK
```

`make test` includes this gate. The cumulative `--m2-storage-proofs` mode
preserves the 105 earlier legs and adds the storage gate with a 600-second
deadline, for 106 legs. `--m2-source-erc20` adds
[ERC20-SOURCE](M2-SOURCE-ERC20.md), for 107 legs. `make gates` and
`dev/gates.sh` now select `--m2-abi`, which adds
[M2-ABI](M2-ABI-GOLDENS.md), for 108 legs.

## Scope

The certificates prove obligations for operations that the runtime
checks accepted. The executable cross-check connects the production
formula with the independent certificate checker on the recorded corpus.
This is not a universal compiler-correctness or Keccak theorem, and
there is no theorem that the certificate-failure branch is unreachable
for every valid input.

The ratified M2 kernel item for a Prop-valued Word refinement over a
Type 0 index (design verdict Q-A, finding F-1) is discharged by group 8
with no change to `src/kernel.bend`: the source defines `InRange` as a
Prop-valued predicate and `word` carries an erased witness, which the
kernel checks by the literal fast path (the M0 protocol in
[EMISSION.md](EMISSION.md)). `Refined` models that refinement in Lean.
Group 5 discharges the Lean and gate half of its row, and group 8 the
kernel half. The refinement covers width 256 only.

M2 remains open for ERC20 composition, ABI goldens and mutation coverage,
audit reconciliation and the cumulative M2-ABI closure gate.

The [validation archive](validation/2026-10-03-m2-storage-proofs/README.md)
pins the final source hashes, full gate records and regression results.
Its driver, `validate.py`, reruns the six suites from the tree with the
compiler in `.tools/bend` and rewrites the record; `check-gate-integration.py`
compares every gate mode with the fixed base commit `7ec1b8a`.

# Assay M2 build log

## M2 group 9: closure, 2026-10-06 to 2026-10-07

Group 9 closed M2. Battery 6, the closure battery, ran `make gates` with
110 legs on the committed tree `2798cf59afb44d5a2f0f57da886aadd853231677`
under a 4096 MB memory guard. 110 of 110 legs passed. The
battery took 7563.5 seconds. The peak memory of the process tree was
2266 MB.

The record keeps the failures and the reruns. Battery 1 ran on `092fa7a`
and completed 76 legs: 63 passed and 13 failed.
Run 1b ran the legs that battery 1 did not reach and six suspect legs. It
stopped before its last three legs. Group 10 repaired the failures, and
focused runs tested each repair. Battery 2 ran on the repaired tree.
106 of 110 legs passed. HOUSE failed, and group 10 repaired it.
PAYABLE, CALLVALUE and ADDRESS stopped at the leg deadline in battery 2.
Each passed when run alone in run-6a. Battery 3 ran on the staged tree
`553a927a`. 105 of 110 legs passed. EVM-CONTEXT, SURFACE-CONTEXT and
WORD-EQUALITY stopped at the leg deadline. INFERRED-BINDINGS and
INFERRED-GUARD-BINDINGS failed when one inner command reached its own time
limit. Each passed when run alone in run-6b. These focused passes do not
close M2, so commit `30feb7b` recorded M2 as open. Battery 4 ran on
`30feb7b`. 109 of 110 legs passed. INFERRED-BINDINGS failed when one
inner `assay check` reached its 30 second time limit. Battery 5 ran on
the same tree. A user ruling stopped it after 70 legs passed. Commit
`b8d5716` raised that limit to 120 seconds.

The record is in
[validation/2026-10-06-m2-close](validation/2026-10-06-m2-close/README.md).
[M2-CLOSE.md](M2-CLOSE.md) gives the user rulings and the limits.

## M2 group 10: repairs for the closure battery, 2026-10-05 to 2026-10-06

Group 10 used the repair reserve for the failures of batteries 1 and 2.

- Mutations: the anchors in `dev/mutations/` match the current emitted
  text. The ADDRESS SCHEMA mutant text is repaired for the HOUSE leg.
- Return ABI: `src/return_abi.bend` has the repair for the FALLBACK
  mutant.
- Ruling D2: `src/tests.bend` has refusal tests for `SPar`, `SNu`,
  `RThunk` and level variables. `src/frontend.bend` refuses level
  variables with a named refusal. LEXER-DIRECT counts 288 cases.
- Ruling D3: `corpus/m2/ERC20.asy` is a corpus row with its manifest
  entries and measurements.
- Bend 2: the pins follow Bend 2 `v2.0.32`, commit `573002f`.
- Pins: `dev/cli_delta.py`, `dev/native-carry.json` and
  `dev/DENOMINATORS.sha256` follow the changed sources.
  `dev/carried_text.py` holds the exact rewrites of carried test lines.
- Limits: the inferred legs use longer emit timeouts.
  `dev/toolchain.json` sets the stack limit to 131072 KiB.
- ADDRESS uses `examples/ContractAddress.asy` as its fixture.

## M2 group 8: coverage and audit reconciliation, 2026-10-04

Parts R2, R1 and C are complete. Group 9 closed M2.

Deviation M2-G8-D1. USER ruling 2026-10-04, pending formal ratification.
SPEC.md marked these kan-lang carry-over constructs M2: `SPar`, `SNu`
and `nu`, families that are not strictly positive (nested inductives),
a right former at a mu shape, `Auto` instances, level variables, and
`KDelay`, `KForce` and `RThunk`. The verdict M2 gate needs none of them.
They are now deferred. Each construct keeps its explicit refusal, and no
refusal test is removed. Only the milestone words change:

| construct | old word | new word |
| --- | --- | --- |
| `SPar` | `SPar arrives at M1` | `SPar is deferred` |
| `SNu` | `SNu arrives at M2` | `SNu is deferred` |
| `nu`, term and declaration | `nu arrives at M2` | `nu is deferred` |
| nested inductive | `a family that is not strictly positive arrives at M2` | `a family that is not strictly positive is deferred` |
| right former at a mu shape | `a right former at a mu shape arrives at M2` | `a right former at a mu shape is deferred` |
| `Auto` | `instances arrive at M2` | `instances are deferred` |
| `KDelay`, `KForce`, `RThunk` | `EMIT_<NAME> (M2)` | `EMIT_<NAME> (deferred)` |

The `SPar` word said M1, but SPEC.md has marked `SPar` M2 since SG-D6.
The emitter tag is shared, so `EMIT_STRING` also changes from `(M2)` to
`(deferred)`. Groups 9 and 10 do not add runtime string literals, so the
new tag is also correct for strings. Level variables have no surface
syntax: the grammar admits `Type` with a numeral only. Their SPEC.md
prose now says deferred. The SPEC.md rows now say deferred, and a note
under the shape table defines the word. src/tests.bend and two negative
fixtures pin the new words. The source hashes in dev/native-carry.json
and dev/DENOMINATORS.sha256 are refreshed. This narrows item 5 of the
closure plan. Part C checks that each deferred refusal has a test. Earlier sections of this log and the M1 log keep the old
words as history.

R0-AUDIT accepted only `M<digit>` in the SPEC.md shape table. It now also
accepts `deferred`. Each row still needs a refusing module. The
R0-AUDIT-SPEC mutant now edits the first deferred row, because no
`| M2 | kernel.bend |` row remains.

Validation passed: the Bend build; core tests (18 adapters, 24 commands);
the kernel suite; one-paths (22/22); stage-A mutants (13/13);
MILESTONE-SPEED (57 schedules, 9 controls); R0-COUNT; R0-AUDIT; house
rules; trusted-line budgets; carry-check (16/16, diff 0); DENOMINATORS;
and whitespace checks. Peak RSS was 375 MB. The first R0-AUDIT run and
the first mutants run failed on the two old `M2` patterns above. Both
passed after the fixes. Part C writes the validation record of the group.

Part R1: the kernel half of the Prop-valued Word refinement over a
Type 0 index (design verdict Q-A, finding F-1). No new kernel former
and no change to `src/kernel.bend`. The source defines
`InRange : Nat -> Nat -> Prop` as `case natEq bits 256 ... case natLt n
2^256 ... return Prop`, and `word` takes a third binder
`(0 p : InRange bits n)`. The kernel checks the witness by the literal
fast path: a payload at or above 2^256, a witness for another value and
a width other than 256 are refused by the kernel. The witness is
erased. The recognizer in `src/emitter.bend` accepts the refined
protocol as a second canonical text when `Word.word` has three binders
(`Recognize.refined`, `Recognize.refined_word`, `base_protocol`,
`proof_protocol` with the arm `| word 0 bits n 0 p => n`, and a sixth
`refined` argument of `m1_protocol_for`); `src/frontend.bend` passes it
from `Recognize.Mapping.schema`. The unrefined text is unchanged, so
every existing contract and golden emits the same bytes. The refined
`Ref20.asy` and `GuardCore.asy` fixtures emit bytes identical to the
unrefined originals. An axiom witness passes the kernel and is refused
by the emitter range check with `WORD_UNBOX_RANGE`, which stays as the
backstop. Limit: `Nat` has no eliminator, so the bound is the literal
2^256 and the refinement covers width 256 only.

Files: `dev/refined-word-data/` (two valid and four negative fixtures
with `.err` texts) and `dev/refined-word-test.py`, which prints
`REFINED-WORD valid=2 kernel_refused=3 emitter_refused=1 OK` and checks
four legacy contracts with unrelated or canonical `InRange` helpers. Part C
wires it as a gate leg. The emitter trusted lines move from 1792 to
1798 of 1800; the budget does not move. The catch-all registry
`dev/bend-catchalls.json` records the shifted emitter lines (159 rows,
same arms). The source hashes in `dev/native-carry.json` and
`dev/DENOMINATORS.sha256` are refreshed.

R1 validation passed: the Bend build (peak RSS 1748 MB); core tests (18
adapters, 24 commands); the kernel suite; one-paths (22/22); stage-A
mutants (14/14); MILESTONE-SPEED (57 schedules, 9 controls); R0-COUNT;
R0-AUDIT; house rules; trusted-line budgets (3190/3550); carry-check
(16/16, diff 0); DENOMINATORS (325 lines); whitespace checks; and
`dev/refined-word-test.py`. Peak RSS of the checks was 370 MB. One
repair outside R1: fa19053 raised the MUTANTS marker of
`dev/stage-a-gates.py` to 14/14, and `dev/milestone-speed-test.py`
compared the carried modes against the 80bc4c6 baseline marker 13/13,
so MILESTONE-SPEED failed at HEAD before R1. The test now adjusts that
historical marker, as it already adjusts the SPEED legs.

R1 staged review, 2026-10-05: fixed one medium compatibility regression.
Selecting the refined protocol by the presence of `InRange` rejected
legacy M0 and M1 contracts that defined that helper. Four cases passed
on fa19053 and failed on the original staged compiler. Selection now
uses the three-binder `word` constructor, followed by the existing
canonical schema checks. The four cases emit unchanged artifact bytes.
The expanded refined-word test, kernel suite, 18 adapters / 24 commands,
14 stage-A mutants, MILESTONE-SPEED, R0-COUNT, R0-AUDIT, house rules,
trusted-line budgets, carry-check, denominator hashes and whitespace
checks passed. No CI weakening or unresolved review findings remain.

Part C: the audit, 2026-10-05. `dev/M2-RECONCILE.md` records the
deferred-construct refusal matrix and the audit table.
`dev/m2-reconcile-test.py` checks both without a build and prints
`M2-RECONCILE deferred=9 tested=5 open=4 docs=17 legs=110 mutants=15 fixtures=10 controls=3 OK`.
The new default gate mode `--m2-reconcile` keeps the 108 `--m2-abi` legs
and adds M2-RECONCILE (60-second floor) and REFINED-WORD (600-second
floor), for 110 legs. `make test` runs both scripts. A fifteenth stage-A
mutant, R0-AUDIT-MILESTONE, makes the `SPar` milestone label invalid, and
R0-AUDIT must report that `SPar` names no milestone.

Two stale source texts changed and no line moved: `src/kernel.bend` now
says "string types are deferred" and `src/emitter.bend` now says
`EMIT_HIGHER_ORDER (deferred)`. Trusted lines are unchanged at 3190 of
3550 (emitter 1798 of 1800). 17 documents name the new default mode and
the 110-leg count. `dev/native-carry.json` pins the two changed sources
and `dev/DENOMINATORS.sha256` has 327 rows (325 before).

Deviation M2-G8-D2. Pending USER ruling. The group brief requires a test
for each explicit refusal. Four deferred constructs have none: `SPar` and
`SNu` (kernel refusal text, no test), `RThunk` (emitter refusal, no test)
and level variables (no named refusal site and no test). They are OPEN
rows of the matrix, and the test does not require them.

Deviation M2-G8-D3. Pending USER ruling. The group brief asks for corpus
rows for coverage gaps. Part C added none. Each of the 11 files in
`corpus/contracts` and `corpus/proofs` has a row in
`corpus/MANIFEST.json`, but no row is an M2 source contract. The audit
compared files with rows only.

One more audit row is OPEN. The compiler sources `frontend`,
`function_abi`, `return_abi`, `event_source` and `string_literal` (4792
lines) have no line budget. Earlier entries asked group 8 to review this
boundary. `dev/trusted-lines.py` names each source and the
TRUSTED-UNPRICED mutant is killed. A price needs a USER ruling.

Part C validation passed: the Bend build (peak RSS 1368 MB);
M2-RECONCILE; REFINED-WORD (187 s in one run against the 600-second
floor); core tests (18 adapters, 24 commands); the kernel suite;
ONE-PATHS 22/22; 15 of 15 stage-A mutants; MILESTONE-SPEED (57
schedules, 9 controls); R0-COUNT; R0-AUDIT; house rules; trusted-line
budgets; carry-check (16 files); 327 denominator hashes; and the
whitespace check. No leg failed. The largest check used 343 MB. The
record is `dev/validation/2026-10-05-m2-reconcile/`. The 110-leg battery
was not run. It belongs to group 9. No deadline, marker, allowlist or
golden was relaxed.

## 2026-10-04: ABI goldens and negative witnesses

Completed M2 group 7. The unchanged, provenance-pinned ERC20 golden now
equals the complete emitted ABI under live `jq -S -c` normalization.
The comparison exposed mapping reads incorrectly marked `nonpayable`.
Mapping entry classification now distinguishes temporary key stores from
persistent writes; event classification separately adds log effects.
Payable entries retain their classification. The emitted ERC20 runtime
and creation bytes equal the predecessor artifacts in the primary checkout.

The new M2-ABI gate rejects sixteen ABI controls: fifteen altered schemas
that differ after `jq` normalization, and one schema with a conflicting
repeated key that `jq` alone makes equal to the golden, which a strict
parse rejects. It also checks twenty mutability cases. Eight direct Lean witness mutants must fail with a type
error at the edited line, between successful unchanged controls. The gate
also reruns seven storage implementation mutants, seven axiom-report
controls and thirteen theorem erasure checks with executable controls.
The per-theorem axiom allowlist and source budgets are unchanged.

Validation passed: the Bend build; core tests (18 adapters, 24 commands);
M2-ABI; function ABI (47 cases); source events (34 cases, 16 refusals);
house rules; trusted-line budgets; Python compilation; and whitespace
checks. Mapping runtime (40 live cases, 27 refusals) and source ERC20
(85 cases, four creates) passed before the equivalent catch-all cases
were expanded into explicit variants. The final M2-ABI run covers the
same mapping mutability behavior after that expansion. A schedule
inspection preserves every command, deadline and marker in the previous
107 legs and adds M2-ABI as leg 108 with a 600-second deadline floor.
`make test`, `make gates` and `dev/gates.sh` include the new gate.

Initial Bend matches on a computed expression and a lambda binder were
rejected and moved into named functions. House rejected two new catch-all
matches, which were replaced by exhaustive cases. Harness development
caught an incorrect manifest field name and a reserved source identifier;
both were corrected. An initial direct budget-script call lacked its root
argument; the supported wrapper passed. These failures and successful
reruns are retained in the [validation archive](validation/2026-10-04-m2-abi/).

See [ABI goldens](M2-ABI-GOLDENS.md) for the oracle and controls. This is a
scoped group completion, not the cumulative M2 closure run. The kernel
Word refinement over a Type 0 index, audit reconciliation and milestone
closure remain open.

## 2026-10-03: Storage and refinement evidence

Added the Lean and gate half of M2 group 5: the reusable
`AssayProofs.Storage` library and the `storageModel` checker. Thirteen
term-mode theorems cover strict scalar refinements, packed field
locations, Word bounds and the slot and value bounds of a declared
`Cell`. The five write theorems (exact replacement, readback,
preservation of neighboring bits and the Word bound) are projections of
a runtime-checked certificate, so they hold for every write that the
check accepts, and `write_total` proves that the check accepts every
valid input. The axiom oracle in `dev/storage-proof-test.py` reads the
report line by line: the lines must name exactly the thirteen theorems
in order, and a theorem passes when it depends on no axioms or when its
listed axioms are a nonempty subset of its allowlist. Only `write_total`
has an allowlist, `propext`, `Classical.choice` and `Quot.sound`, which
it needs through the core `Nat` lemmas; the other twelve theorems must
depend on no axioms, and any other axiom on any theorem fails the gate.
See [storage evidence](M2-STORAGE-PROOFS.md).

The storage gate compares 2,395 access probes with production Bend and
independent bit-mask expectations, plus 533 refinement probes. The
adapter has no length limit: it labels text that is not a natural
number `invalid-value` on refine and write, and a natural number outside
the declared type `out-of-range:<typ>`. The text `-1` and the other
malformed literals moved out of the access and refinement corpora into
a 17-row lexical corpus, where `007` and `+1` are compared in the Lean
lane; six `-1` location and word probes remain in the access corpus as
`invalid-location` and `invalid-word` refusals (`lexical=17`). The gate
refuses two closure-storage fixtures at the lexer and requires the
`SURFACE_TOKEN` diagnostic, because `->` is not a surface token
(`grammar=2`). It applies seven Lean mutations: six must fail to compile
(a relaxed refinement, the field and Word bounds, a function value in
the unused `Cell` type as a shape control, the write shift and a write
refusal) and one compiling mutation with a widened boolean limit must be
caught by a live witness (`mutants=7`). It refuses seven corrupted axiom
reports (`controls=7`). The erasure leg requires the generated C to hold
none of the thirteen mangled theorem symbols and all four executable
symbols, and a positive probe marker shows that the symbol scan can
fail (`erasure=13`).
Existing source-proof and storage execution regressions are recorded
with the focused gate in the
[validation archive](validation/2026-10-03-m2-storage-proofs/README.md).

The first production attempt stopped at the compiler provenance guard:
the default `.tools/bend` checkout was at `bc17840` while the project
pins `573002f`. A separate checkout of the pinned revision was fetched
and built for validation. The provenance guard remained in force.
The corrected rerun is the recorded run. The refused first attempt and
the other command captures of that session are not part of the record,
and this entry is their only description. Two harness defects found
before the recorded run are kept in the record as `FAILED-ATTEMPT-1`
(a storage-closure fixture survived) and `FAILED-ATTEMPT-2` (the
executable `write` symbol was missing).
Afterward, `dev/bootstrap-bend.py --upgrade` restored the default local
checkout to the declared pin, and a normal packed-adapter build passed.

Gate inventory comparison preserves all 65 existing modes, including
their commands, markers and deadlines. The new mode retains the previous
105 cumulative legs and adds one storage-proof leg.

`make test` includes the new test, and `make gates` and `dev/gates.sh`
advance to cumulative `--m2-storage-proofs` while retaining earlier M2
checks and deadlines, for 106 legs. This scoped group does not close M2.
The ratified Prop-valued Word refinement over a Type 0 index is an open
kernel item with no implementation yet and no owning group. `rg Word
src/kernel.bend` finds no hit; the `Contract.Word` syntax type lives at
`src/emitter.bend:4`, outside the kernel. ERC20 composition and the
remaining golden, audit and cumulative acceptance groups remain open.

## 2026-10-03: Return and error ABI source integration

Completed M2 group 3. Source entries return Uint8, Uint256, Address, Bool,
String or Word, and custom errors retain their declared parameter types.
String operands refer to the active entry's String inputs. The model and EVM
emitter encode canonical tuples, enforce scalar bounds and a 131072-byte
payload cap, and preserve rollback on rejection. Packed storage and mappings
remain available. See [source return and error ABI](M2-RETURN-ABI.md) and
[ReturnData.asy](../examples/ReturnData.asy).

The feature suite passed 49 ordinary and cap cases, eight layout and isolated
error cases, and 30 source refusals. Expected bytes come from cast; the model,
geth run and Cancun t8n agree. The cap fixture has a bounded local oracle
adapter so the shared differential domain is unchanged. Native, function ABI,
mapping, packed-source and public calldata/returndata CLI regressions passed.
The pinned build and source audits passed. The default cumulative schedule
adds mandatory RETURN-ABI to all 103 carried legs, for 104. Its simulation
preserves commands, deadlines and markers and refuses a missing new marker.
The complete cumulative battery was not run.

Review fixed the scanner's activation for typed errors in contracts with
only Word results. Isolated Uint8 and String error programs cover that path.
Explicit local type annotations also prevent excessive Bend inference cost.
Three source declaration pins changed in `dev/cli_delta.py`; source inventory
hashes and existing catch-all line records were refreshed without changing
their reasons. `src/return_abi.bend` follows the unpriced compiler source
boundary of `src/function_abi.bend`; M2 group 8 still owes boundary review.
Artifact budgets and denominator prices are unchanged.

Review of the staged slice fixed seven findings. The output cap fixture now
sits at the 131072-byte boundary and a near-cap case accepts a full payload,
so the suite has 49 cases. Each refusal leg pins the full message of its
rule. The model run of the cap fixture has a 90 s timeout.
`dev/milestone-speed-test.py` expects the `--m2-return-abi` default.
README.md and ten dev pages name the 104-leg default gate mode. The feature
guide discloses the scratch cursor at base+131104 and its gas cost. The
record README discloses the build clone paths and the nonzero attempts.
The feature suite and the schedule simulation reran green after the fixes.

The [validation record](validation/2026-10-03-m2-return-abi/README.md)
retains successful checks and earlier failures. M2 remains open; source
event emission is the next group.

## 2026-10-03: Function ABI source integration

Completed M2 group 2. Source entries accept Uint8, Uint256, Address, Bool and
String parameters. Typed selectors, ABI printing, canonical calldata checks
and the model share the declared schema. String length and data-address
operations lower to checked calldata access. Existing packed and mapping
storage plans remain usable. Word results retain the current return ABI.
See [source function calldata](M2-FUNCTION-ABI.md) and
[FunctionCalldata.asy](../examples/FunctionCalldata.asy).

The feature suite passed 47 calldata cases, one typed mapping program, three
size-cap checks, two independently pinned selector-collision refusals and
12 source refusals. Ordinary calldata cases compare cast encodings, the model,
geth run and Cancun t8n. Native, mapping runtime, packed-source and public
calldata CLI regressions passed during the change and again on the final
build. The final pinned compiler build, house, carry, R0, trusted-line and
schedule audits passed. The first CALLDATA-CLI run failed its compatibility
pins. Four pins in dev/cli_delta.py (Cli.run, Case.Packed.switch_35,
Case.Packed.switch_38, Cli.Packed.read_file) were updated for the function ABI
plan and the new Cli.run input order.
The [validation record](validation/2026-10-03-m2-function-abi/README.md)
preserves full command captures, source hashes and revision scope.

Review fixed hex-to-byte model decoding, inclusive scalar bounds, dynamic
padding arithmetic and refusal command arguments. Typed input uses the
codec's 131072-byte cap. Selector collisions fail before execution. New
matches enumerate their variants; existing catch-all arms only moved lines.

A second review fixed seven findings. A String parameter name now stays in
its own entry, so a later declaration can reuse it. Typed-source diagnostics
keep the source line and column. The suite adds one valid case and three
string padding refusals. The denominator hashes, the validation record and
the gate documentation now match the final staged tree. The record binds each
final capture to the built program hash.

The default schedule `--m2-function-abi` adds mandatory FUNCTION-ABI to all
102 carried legs, for 103 total. `--m2-mapping-runtime` keeps its 102 legs.
Historical schedules, markers, deadlines, mutants and trusted artifact limits
remain unchanged. dev/trusted-lines.py now admits src/function_abi.bend as a
source without a line budget, the same as src/frontend.bend. That file
generates calldata check instructions for the emitter. No trusted artifact
budget counts its 348 lines. M2 group 8 must review this boundary, and a
change to its price needs a user ruling. The complete battery was not run and
M2 is still open. Return and error ABI source integration is the next group.

## 2026-10-02: Mapping runtime access and grouped milestone plan

Completed M2 group 1, mapping runtime access. Scalar and nested source keys
now reach `check`, `emit` and `run`. Constructors and entries share computed
Keccak slots, checked key and value bounds, packed scalar neighbors and
transaction rollback. Temporary key cells stay in memory. Physical layout
metadata preserves the original field names and recursively describes mappings.
See [mapping runtime](M2-MAPPING-RUNTIME.md) and
[MappingAccess.asy](../examples/MappingAccess.asy).

The [grouped plan](MILESTONE-GROUPS.md) allocates nine work turns plus one
repair turn to M2, seven plus three to M3, and eight plus two to M4. Each group
includes validation, review and staged changes. Milestone closure still requires
the original acceptance gates and external evidence where applicable.

Scoped validation passed: 40 live mapping cases in the model, geth run and
Cancun t8n; 27 source refusals; exact constructor and layout checks; native
tests; the complete packed-source suite with all six compiled mutants; mapping
source and CLI regressions; calldata, return-data, event and event-decode CLI
suites; schedule controls; and house, carry, R0 and trusted-line audits.
The new default schedule extends the 101 carried legs to 102 with a mandatory
MAPPING-RUNTIME leg. Historical schedules and required markers remain intact.
Review fixes count only user fields toward the 32-member limit, refuse `deployer`
on a mapping root, bound mapping scratch memory by the highest memory word of the
program, check exact refusal text, Uint256 keys, Address values and peak memory,
and reseal the pin files.
One detached run measured the Bend 2 baseline again at a load average near
13, with a ratio of 1.894 against the 1.0 limit; the 102-leg battery was
not run.

Final review made duplicate-baseline preservation controls run even when an
older baseline lacks a reviewed helper. All nine changed CLI declarations are
digest pinned, and arbitrary reachable changes still fail the comparison.
Packed mutant compilation is serialized after a parallel compiler was killed
with exit -9; all mutants, assertions and deadlines remain enabled.
The [validation record](validation/2026-10-02-m2-mapping-runtime/README.md)
preserves command captures, failures, live traces and hashes.

M2 remains open. The complete 102-leg milestone battery was not run in this
group. Function ABI source integration is next, followed by return and error
ABI, source events, storage and refinement evidence, the complete ERC20,
negative Lean mutants, audit reconciliation and the final M2-ABI gate.
The frontend integration has no individual line budget in the current audit;
M2 group 8 must review that boundary explicitly.


## 2026-10-02: Mapping declarations and layout inspection

Base: af364d5. mapping-layout FILE parses typed scalar and nested mapping
declarations into a native source schema and prints physical layout metadata.
Mapping roots reserve complete slots; scalar neighbors use the existing
packed planner. Mapping source reads and writes remain pending.

The new check passes 13 independent layout goldens, 26 source refusals,
four command or file refusals, and two compiled semantic mutants. It also
checks exact historical CLI preservation and the new 100-leg schedule,
which appends one leg to the 99 carried checks. Existing mapping, event
encoding, event decoding and calldata CLI checks pass. House, carry and
trusted-line audits pass with the same fixed budgets. A review made the
command refuse text after the storage block and sources above 65536 bytes.
It also added depth boundary cases, and each mutant must now fail the
erc20 golden.

The first event decoder run exceeds its unchanged local 30-second deadline
on maximum-size data. The unchanged test passes on rerun, and a paired
committed/current boundary probe gives the expected refusal within that
deadline on both compilers. The probe and the interrupted broader test run
are retained in the validation record.
The full milestone battery and the remaining M2 closure work stay open.

See dev/M2-MAPPING-SOURCE.md and
dev/validation/2026-10-02-m2-mapping-source/README.md for scope and evidence.

## 2026-10-02: Public typed function calldata

Base: `4cf4ebc`. `calldata-encode NAME [TYPE VALUE]...` and
`calldata-decode NAME HEX [TYPE]...` expose the existing `Abi.Call` codec
through compact JSON. Supported types are uint8, uint256, address, bool
and string. Decoding validates the selector and canonical argument tuple;
string results preserve arbitrary bytes. Malformed input exits 64 with a
command-specific diagnostic and empty stdout. Hexadecimal calldata and
encoded calldata are each limited to 131072 bytes, including the selector.

The final CLI checks pass 53 encodings, 55 decodings, 196 refusals and two
altered help/dispatch pin controls. A review added the encoded calldata
limit, because long string arguments stopped the process with a Bend
memory fault. The review also added checks on both sides of each cap and
exact diagnostics for truncated tuples. Static carry, R0, house, trusted-line,
denominator and schedule checks pass. The trusted total remains 3184/3550.
The default schedule now has 99 legs and includes CALLDATA-CLI.

The source remains within the existing CLI module, with the declaration
order of the verified compiler bundle. Failed compiler builds now report
their exit code and final diagnostic lines. Two full test attempts retain
their failures: packed-storage mutant compilation, then a 180-second
timeout in the cached kernel batch. The standalone kernel retry passes.
Follow-up checks pass all eleven CLI regressions and the packed-source
check's 66 cases and six mutants. The kernel suite, packed-source check,
CLI regressions and calldata checks pass when run alone. The runtest
roundtrip and adapter commands passed only in the first full invocation.
Both failed full invocations remain in the record.
No test deadlines or success criteria changed. Full milestone validation
remains pending. The record is
`dev/validation/2026-10-01-m2-calldata-cli/`.

## 2026-10-01: Public typed event encoding

Base: `10f1f96`. The `event-encode` command exposes the existing typed event
codec through the production CLI. It prints compact JSON with hexadecimal
topics and data. The command supports uint8, uint256, address, bool and
UTF-8 string fields, indexed and non-indexed placement, and anonymous events.
Names, field triples, numeric ranges and topic limits have explicit refusals.

The new process suite passes 56 cast-backed encoding cases and 36 refusal
cases. It covers the ERC-20 Transfer and Approval events, field order,
numeric boundaries, empty and Unicode strings, string byte hashes, ABI padding
boundaries and the three/four indexed-field limits. Dynamic bytes encodings
provide identical string ABI layouts for cast inputs containing quotes and
control characters. Two declaration-pin controls refuse modified CLI entry
bodies, and restoring the pins leaves the predecessor CLI bundle identical.

The full `make test` run exits zero: native kernel tests, 24 commands across
18 adapters, the 66-case packed source suite with six compiled mutants,
244 mapping CLI cases, the new event CLI suite, and all eight existing lexer
and conversion checks. Schedule controls preserve the 57 historical modes.
The M2 source-packing schedule adds the mandatory `EVENT-CLI` leg; all carried
commands, markers and deadlines are preserved. The M4 speed schedule is
unchanged.

House and carry checks pass. Three rejecting string-parser catch-alls have
specific rationales, and the seven shifted existing CLI records retain
their approved arms. Denominator hashes are refreshed for the changed
inputs and new suite. Trusted source counts remain kernel=3767/4000 and
artifacts=3184/3550. The ABI module remains 495/495 lines.

Source event declarations and EVM log emission remain pending. This slice
does not close M2. Sources, expected logs and complete validation output
are pinned in `dev/validation/2026-10-01-m2-event-cli/`.

## 2026-10-01: Direct trace response error detection

Starting at `bacd4ba`, `Trace.has_error` converts string segments directly
to character lists and back when removing JSON whitespace. The scanner's
handling of keys, null values, empty strings and malformed responses is
preserved. The declaration pin extends the CLI manifest to thirteen
entries, and compatibility preserves all 56 historical schedules and
the restored CLI bundle byte for byte.

The default gate schedule adds `CLI-ERROR-DIRECT`, for 95 legs.
The new check compares 519 compiled predecessor results with independent
goldens and kills five compiled mutants with named wrong answers before
restoring the control. The complete `make test` run passes the native
kernel suite, 24 commands across 18 adapters, and all eight conversion
checks. The trace driver passes 20 live process checks.

The five shifted CLI catch-all line records are refreshed without
changing their approved arms or rationales. The house audit and native
carry check pass. Source hashes are resealed after these changes.

The fresh five-round, six-case paired measurement gives matched median
times of 920.754958 ms for Assay and 578.530375 ms for Bend 2, a ratio
of 1.591541253 in a 7.874-second host window. The active baseline is
byte-identical to the archived measurement. The 1.0 speed bound remains
unchanged and refuses this result. This measurement does not isolate
the conversion change's speed effect. Benchmark controls pass with
37 refusals and six compiled mutations. The full milestone battery
and M2 source lowering remain open.

See `dev/CLI-ERROR-DIRECT.md` and
`dev/validation/2026-10-01-cli-error-direct/` for sources and evidence.

## 2026-10-01: Direct trace decimal normalization

Starting at `7af4b0478d6e1dd23ab98c0b3aa7f9e0d8d25fcd`, `Trace.value`
removes leading decimal zeros from a character list taken directly from
the lowercased string. The earlier path built Series, converted them to
lists and rebuilt strings. Validation, lowercasing, hexadecimal spelling
and decimal-zero normalization retain their behavior. One exact
declaration pin extends the manifest to twelve.

The new comparison passes 872 results against the predecessor, with exact
error output, and against independent acceptance and normalization
goldens. All three compiled mutants give their named wrong answers, and
the restored control passes. Pin deletion, duplication and modification
are refused, and an unrelated lowercase change remains visible. The new
mandatory leg gives the default 94 checks; all 56 predecessor modes and
earlier legs retain their schedules.

The native kernel suite, all 24 commands across 18 adapters and the
seven follow-up checks pass. Native carry and trusted-source budgets pass.
Two earlier comparison attempts stopped while compiling predecessor
fixtures because the literal serializer used unsupported Bend escapes.
Both attempts are archived.

The six-case, five-round measurement records 1.087435467 in a 19.595-second
host window starting at 2026-10-01 10:50 UTC. The active frozen JSON is
byte-identical to the captured record. BEND2-RATIO still fails its 1.0
bound. Ratio refusal and mutation controls pass. The window does not
isolate the decimal-normalization change's speed effect. The full milestone
battery and M2 source lowering remain open.

See `dev/CLI-VALUE-DIRECT.md` and
`dev/validation/2026-10-01-cli-value-direct` for sources and evidence.

## 2026-10-01: Direct CLI hexadecimal prefix removal

Starting at `356ce95673480c8b6290e9549a3a47153c44933f`, `Trace.calldata`,
`Trace.caller` and `Differential.caller` remove hexadecimal prefixes with
`NativeString.drop(2n, ...)`. The earlier paths built Series, dropped
characters and rebuilt strings. Decimal parsing, validation, address
padding, uint160 bounds and offline fixture restrictions retain their
behavior. Three exact declaration pins extend the manifest to eleven.

The new comparison passes 2,184 results across 728 inputs against
independent acceptance and normalization goldens, with exact predecessor
error output. All nine compiled prefix-length mutants give their named
wrong answers, and the restored control passes. Pin deletion, duplication
and modification are refused, and unrelated lowercase changes remain
visible. The new mandatory leg gives the default 93 checks; all 56
predecessor modes and earlier legs retain their schedules.

The native kernel suite and all 24 commands across 18 adapters pass.
Every remaining test-target command passes in the followup capture.
Native carry and trusted-source budgets pass. The first comparison
attempt lacked its compiler path; two harness variants had syntax or
linearity errors. The corrected full run passes, and all attempts are
archived. Native cached artifacts retain the normal builder's input and
output hash checks. New comparison fixtures were freshly compiled.

The six-case, five-round measurement records 1.639908573 in a 9.366-second
host window starting at 2026-10-01 09:18 UTC. The active frozen JSON is
byte-identical to the captured record. BEND2-RATIO still fails its 1.0
bound. Ratio refusal and mutation controls pass. The window does not
isolate the prefix change's speed effect. The full milestone battery
and M2 source lowering remain open.

See `dev/CLI-PREFIX-DIRECT.md` and
`dev/validation/2026-10-01-cli-prefix-direct` for sources and evidence.

## 2026-10-01: Direct executor substring extraction

Starting at `a374e662a727785b7e962f0db97953d687550843`, `Model.segment`
uses the existing native string drop and take helpers. This removes a
Series and list conversion while preserving character order and the
existing magnitude conversion of negative offsets and lengths.

The new check compares both compiled implementations with 1,348 independent
Python code-point goldens, kills three compiled mutants and reruns its
restored control. The eighth exact declaration pin covers `Model.segment`.
The test target and gate schedule include the check. Compatibility retains
all 56 predecessor modes and requires 92 current legs.

The native suites, 24 adapter commands, keyword check, both lexers and all
three subsequent string checks pass across the captured run and scoped
follow-ups. The full test-target attempt timed out on the existing lexer
input mutant. A smaller fixture did not fix it. The final equivalent
mutation takes zero characters before list conversion and passes with all
287 cases and the original timeout. Four earlier lexer builds
were reused. The replay matched their regenerated sources and recorded
their hashes at replay time, not at build time. Source budgets and carry pass.

The frozen five-round, six-case measurement is 1.538120777 in an
18.362-second host window. The original 1.0 limit still fails; its refusal
controls pass. This record does not establish the substring change's
speed effect. Full milestone gates and M2 source lowering remain pending.
Evidence, including the failed attempts and replay receipt, is under
`dev/validation/2026-09-30-segment-direct`.

## 2026-09-30: Direct word prefix removal

Starting at `91a27b7`, `Recognize.parse_word` in `src/emitter.bend` now
removes the hexadecimal prefix with `NativeString.drop`, removing the
stream round trip. The digit rules, length limits and `uint256` overflow
check are unchanged.

WORD-DIRECT compares the restored predecessor and the current
declaration with 1,580 independent Python goldens and three compiled
mutants. `make test` runs the check, and `--lexer-direct` appends it as
the 91st leg. The word parser declaration is the seventh exact
compatibility pin.

The native build, `make test`, the compatibility check and TRUSTED-LINES
pass. The full gate battery was not run. The final paired measurement
records a 13.638-second window and a ratio of 1.312470762 against the
unchanged 1.0 bound, so BEND2-RATIO fails. That record does not isolate
the timing effect of this change. See `dev/WORD-DIRECT.md` and
`dev/validation/2026-09-30-word-direct` for the evidence.

## 2026-09-30: Direct identifier conversion

Starting at `e16c842`, `Recognize.identifier` in `src/emitter.bend` now
sends its input string directly to `NativeString.to_list`, removing the
stream round trip. The ASCII grammar `[A-Za-z_][A-Za-z_0-9]*` is unchanged.

IDENTIFIER-DIRECT compares the restored predecessor and the current
declaration with 1,043 independent grammar goldens and two compiled
mutants. Each test input reaches both adapters one escape per code point.
`make test` runs the check, and `--lexer-direct` appends it as the 90th
leg. The identifier declaration is the sixth exact compatibility pin.

The native build, the identifier, lexer and keyword checks, the
compatibility check and the axiom retry pass. The full gate battery was
stopped after 41 passing checks and was not completed. The fresh paired
measurement records a 33.316-second window and a ratio of 1.775497120
against the unchanged 1.0 bound, so BEND2-RATIO fails. That record does
not isolate the timing effect of this change. See
`dev/IDENTIFIER-DIRECT.md` and `dev/validation/2026-09-30-identifier-direct`
for the evidence.

## 2026-09-30: Contract token string conversion

Starting at `42ef4be`, both `Contract.span` return branches now construct
their token string from the reversed character list directly. The lexer
comparison adds 303 contract cases, five independent goldens and two
compiled mutants, while preserving the existing 287 core cases and gate
schedules. The contract declaration joins the exact compatibility pins.

The native build, kernel and adapter tests, both lexer checks, six
compatibility checks and trusted-line accounting pass. The fresh paired
compiler measurement records a 40.041-second window and a ratio of
0.962311539 against the unchanged 1.0 bound. BEND2-RATIO and its refusal
controls pass. The denominator seal keeps its existing paths and fixtures.

The full gate battery was not run. M2 source lowering and milestone exit
remain pending. See `dev/LEXER-DIRECT.md` and
`dev/validation/2026-09-30-contract-span` for the evidence.

## 2026-09-30: Direct lexer conversions

Starting at `82f1476`, `Lexer.lex` now uses `NativeString.to_list` instead
of constructing and collecting a character stream. `Lexer.go` and
`Lexer.nat_of_digits` send existing character lists directly to
`NativeString.of_list`, removing the same redundant stream round trip.

LEXER-DIRECT passes all 287 inputs, four independent token streams and
three compiling wrong-answer mutants. The comparison includes byte
payloads, positions, diagnostics and the 11 contract corpus files.
Compatibility preserves all 56 predecessor modes and adds one leg to
the new 89-check default. Existing gate modes retain their schedules.
The historical CLI normalization now pins the exact bodies of the three
conversion declarations and the earlier keyword classifier. Negative
checks reject altered, missing or duplicate pins and detect unrelated
reachable source changes.

The native build, kernel and adapter tests, keyword check, six compatibility
checks, TRUSTED-LINES, DENOMINATORS, M0-RATIO and BEND2-RATIO-TEST pass.
The full gate battery was not run. A fresh five-round paired measurement
of six compiler cases is frozen and sealed: window 22.872 seconds,
ratio 1.490829052, above the unchanged 1.0 limit. BEND2-RATIO still fails.
The local lexer's median after/before ratio is 1.014 and does not establish
a speed improvement. M2 source lowering and milestone exit remain pending.

See `dev/LEXER-DIRECT.md` and
`dev/validation/2026-09-30-lexer-direct` for sources and captures.

## 2026-09-29: Direct keyword dispatch

Starting from the event-decode slice at `a29a0c1`, this follow-up
changes `Lexer.ident_kind` in `src/frontend.bend`. A Bend string match
with 30 keyword cases and a catch-all replaces the construction and
linear search of the keyword list. The vocabulary is unchanged. Every
other input returns `Token.Kind.Ident` with the original bytes.

LEXER-KEYWORDS passes with the 30 keywords and 225 other inputs. The
new `dev/lexer-keywords-test.py` builds the actual classifier and prints
(one line, verbatim):

    LEXER-KEYWORDS keywords=30 cases=255 OK

The new default `--keyword-dispatch` adds LEXER-KEYWORDS to the 87
`--m2-event-decode` legs, for 88 legs. The Makefile and `dev/gates.sh`
select it.

On 2026-09-29 the user ruled a pinned delta for the five compatibility
checks (event-decode, event, revert, call and return). The new
`dev/cli_delta.py` checks that the worktree `Lexer.ident_kind`
declaration has the pinned SHA-256 and puts back the BASE declaration.
The reachable CLI bundle must then be byte-identical to each BASE. The
markers do not change. Each report adds the `cli_delta_sha256` field.

A fresh five-round paired timing report of six cases is frozen in
`dev/bend2-baseline.json` and sealed by `dev/BEND2.sha256`. The
7.441-second window yields an Assay/Bend 2 ratio of 1.720825537, above
the unchanged 1.0 limit. The previous record was 1.137273126. The
refreshed `dev/DENOMINATORS.sha256` holds 133 rows. DENOMINATORS,
M0-RATIO and BEND2-RATIO-TEST pass. BEND2-RATIO failed before this
slice and still fails. The full gate battery was not run. Commands,
captures and hashes are retained under
`dev/validation/2026-09-29-keyword-dispatch`.

See `dev/LEXER-KEYWORDS.md` for the change and scope.

## 2026-09-28: M2 typed event log decoding

Starting from the revert-data slice at `aa7517e`, this slice adds
`Abi.Event.decode`. It takes the same schema as `Abi.Event.encode` and
an `Abi.Event.Log`, and returns the decoded parameters in declaration
order. Indexed strings return as tagged 32-byte hashes. The decoder
checks the schema topic limit, the exact topic count, the topic sizes,
the named event signature, the data tuple and then the indexed scalar
words, in that order. It returns no partial values.

EVENT-DECODE passes with 71 cast event vectors, 21 frozen ERC-20 logs,
59 malformed logs, 8 adapter refusals and twelve compiling mutants
killed by named wrong answers. The malformed logs test the check order,
including a limit check before the count check and codec errors after
a correct signature. A restored scratch build passes every vector and
refusal.

The new default `--m2-event-decode` appends EVENT-DECODE for 87 checks.
Compatibility preserves all 54 earlier modes, their commands, deadlines,
markers and failure classes. The staged ABI and test sources remain
byte-identical prefixes, and the compiler CLI bundle is unchanged.

`src/abi.bend` grows to 495 lines, above its earlier 400-line cap. On
2026-09-28 the user re-ratified the source budget: abi 495, assembler
505 and an unchanged total of 3550. TRUSTED-LINES passes under this
budget at 2951/3550. Validation is scoped to this host-codec slice; the
complete 87-leg default battery was not run. Commands, captures and
hashes are retained under `dev/validation/2026-09-28-m2-event-decode`.

A fresh five-round paired timing report is frozen in
`dev/bend2-baseline.json`. The 48.113-second window yields an
Assay/Bend 2 ratio of 1.137273126, above the unchanged 1.0 limit.
BEND2-RATIO remains failing. These separate runs do not establish a
feature-related speed change.

Compiler integration and the remaining M2 work stay pending. See
`dev/M2-EVENT-DECODE.md` for the API and scope.

## 2026-09-27: M2 typed custom-error revert data

Starting from the staged return-data slice at `5e00ee7`, this slice adds
`Abi.Revert.encode` and `Abi.Revert.decode`. Error declarations reuse the
strict calldata codec for their selectors and argument tuples, including
nullary errors, dynamic strings, `Error(string)` and `Panic(uint256)`.
Other declaration variants return `Not_error`; `Call(error)` preserves
the existing typed calldata and tuple errors.

REVERT-CODEC passes with 60 cast oracle cases, 40 frozen ERC-20 empty
reverts, 90 production errors, 292 truncated prefixes, 16 adapter
refusals and twelve compiling mutants killed by named wrong answers.
Every positive checks encoding, decoding and parameter-name independence.
A restored scratch build passes the complete 662-case set. The ERC-20
reference has no typed errors; its empty reverts exercise short-selector
rejection.

The new default `--m2-revertdata` appends REVERT-CODEC for 86 checks.
Compatibility preserves all 53 earlier modes, their commands, deadlines,
markers and failure classes. The staged ABI and test sources remain
byte-identical prefixes, and the compiler CLI bundle is unchanged.

Native tests, tuple/calldata/return/event codec regressions, house rules,
carry, denominator pins, trusted-line bounds and BEND2-RATIO-TEST pass.
The shared dispatch keeps the ABI module within its unchanged 400-line
cap. Validation is scoped to this host-codec slice; the complete 86-leg
default battery was not run. Commands, captures and hashes are retained
under `dev/validation/2026-09-27-m2-revertdata`.

A fresh five-round paired timing report is frozen in
`dev/bend2-baseline.json`. The 13.432-second window yields an
Assay/Bend 2 ratio of 1.657532429, above the unchanged 1.0 limit.
BEND2-RATIO remains failing. These separate runs do not establish a
feature-related speed change.

Compiler integration and the remaining M2 work stay pending. See
`dev/M2-REVERTDATA.md` for the API and scope.

## 2026-09-27: M2 function return-data encoding

Starting at `5e00ee7`, this slice adds `Abi.Return.encode` and
`Abi.Return.decode` for a typed function's output tuple. Empty results
encode to empty bytes. Dynamic offsets start at the tuple, and return
data carries no selector. Type, arity and codec failures return explicit
errors. Function names, inputs, output names and mutability do not alter
the output bytes.

RETURN-CODEC passes with 57 cast oracle cases, all 45 successful ERC-20
reference results, 75 production errors, 288 truncated prefixes,
13 adapter refusals and ten compiling mutants killed by named wrong
answers. Every positive case checks encoding and decoding with changed
function metadata. A restored scratch build passes the full case set.

RETURN-COMPATIBILITY preserves all 52 historical gate modes, their
commands, deadlines, expected markers and failure classes. The new
default `--m2-returndata` appends RETURN-CODEC for 85 checks. The prior
ABI and test sources remain byte-identical prefixes, and the reachable
compiler CLI bundle remains byte-identical.

Native tests, tuple/calldata/event codec regressions, house rules,
carry, denominator pins, trusted-line bounds and BEND2-RATIO-TEST pass.
The source pins and new test harness pins are refreshed. Validation is
scoped to this host-codec slice; the complete 85-leg default battery was
not run. Commands, captures and hashes are retained under
`dev/validation/2026-09-27-m2-returndata`.

A fresh five-round paired timing report is frozen in
`dev/bend2-baseline.json`. The 7.581-second window yields an
Assay/Bend 2 ratio of 1.667820196, above the unchanged 1.0 limit.
BEND2-RATIO therefore remains failing. The compiler bundle is unchanged;
these separate runs do not establish a feature-related speed change.

Compiler integration and the remaining M2 work stay pending. See
`dev/M2-RETURNDATA.md` for the API and scope.

## 2026-09-27: M2 function calldata encoding

Starting at `0cf7d20`, `Abi.Call` builds complete function call payloads
from a typed function schema. `selector` returns the four Keccak
selector bytes, `encode` returns the selector and argument tuple, and
`decode` checks the selector and returns the typed values. Explicit
errors cover `Type_mismatch`, `Arity`, `Short_selector`,
`Wrong_selector` and wrapped codec failures; failed calls return no
partial result.

The calldata gate covers 57 cast oracle payloads, 44 distinct canonical
ERC-20 reference calls, 60 production errors, all 292 truncated prefixes
of a mixed call, 13 adapter refusals and 10 compiling mutants with a
rebuilt scratch control. Every oracle and reference case is encoded,
decoded and encoded again.

The default `--m2-calldata` appends CALL-CODEC for 84 legs.
CALL-COMPATIBILITY checks that all 51 historical modes retain their
schedules, deadlines, markers and failure classes. The original ABI and
test sources remain byte-identical prefixes of the extended files, and
the compiler CLI's reachable Bend bundle is byte-identical. The ABI
module is 347/400 lines and trusted artifacts total 2803/3550, with all
bounds unchanged.

Commands and results are in
`dev/validation/2026-09-27-m2-calldata`. Validation is scoped to the new
calldata gate, compatibility, native tests, the tuple and event codecs,
house rules, the carry and denominator checks and trusted lines. It
does not claim a complete default battery. A fresh paired Bend 2
measurement gives a ratio of 1.720827821, which still fails the
unchanged 1.0 bound, and the mapping corpus freeze is unchanged. The
slice also refreshes the carried `src/abi.bend` and `src/tests.bend`
hashes in `dev/native-carry.json`, pins the three new harness files in
`dev/DENOMINATORS.sha256` and records elapsed times in `RUNS.json`.
Compiler integration and the remaining M2 work stay pending. See
`dev/M2-CALLDATA.md` for the API and remaining scope.

## 2026-09-26: M2 typed event log encoding

Starting at `a1e7440`, `Abi.Event` constructs signature topics, indexed
scalar and string topics, and non-indexed ABI tuple data. Anonymous events
omit topic zero. Explicit errors cover topic limits, arity, type mismatch
and codec failures; failed calls return no partial log.

The event gate covers 71 cast comparisons, 21 distinct frozen ERC-20 logs,
65 production refusals, 13 adapter refusals, 12 Cancun executions and 12
compiling semantic mutants with a rebuilt passing control. The refusals
include non-indexed type mismatches and nine rows that check the error
order when two failures occur. The Cancun programs exercise LOG0 through
LOG4 and receipt-log rollback, using the production encoder's bytes and
independent expected results.

The default now appends EVENT-CODEC for 83 legs. All 50 historical modes
retain their schedules, deadlines, markers and failure classes. Existing
ABI and test definitions and the reachable CLI compiler bundle retain
their base bytes. The ABI module is 308/400 lines and trusted artifacts
total 2764/3550, with all bounds unchanged.

Commands and results are in
`dev/validation/2026-09-26-m2-events`. Validation is scoped to native tests,
the new event gate, neighboring ABI and storage gates and source audits.
It does not claim a complete default battery. A fresh paired Bend 2
measurement gives a ratio of 1.150474099, which still fails the unchanged
1.0 bound, and the mapping corpus freeze is unchanged.
Source event lowering and the remaining M2 compiler and proof work stay
pending. See `dev/M2-EVENTS.md` for the API and remaining scope.

## 2026-09-25: M2 mapping storage locations

This slice starts at `9e1cbe5` and adds checked scalar and nested mapping
locations through `Layout.Mapping.slot` and `Layout.Mapping.path`. Keys
support uint8, uint256, address and bool, with explicit range failures.
Empty paths and unsupported string keys are rejected. The implementation
uses the production ABI word encoder and Keccak-256.

The mapping gate passes 102 cast comparisons, all 10 frozen ERC-20 balance
and allowance locations, 23 refusals, 15 adapter refusals and 12 compiling
semantic mutants.
The restored control passes the same mutation witnesses. Normal tests
pass with 13 adapters and 19 adapter commands. Packing, ABI schema, ABI
codec, proof axioms and benchmark-validation checks also pass.

The new default appends one leg, for 82 checks. All 49 earlier modes keep
their commands, deadlines, markers and failure classifications. Existing
packed-layout definitions, the old test-file prefix and the compiler
CLI's reachable Bend bundle are byte-identical to the base. Layout is
157/250 lines, and the trusted total is 2705/3550 with unchanged limits.

The broad run was stopped after 39 reported legs. Its checksum and missing
offline-dependency failures were repaired and rechecked. This is scoped
validation, not a complete pass of the 82-leg battery. Full logs and the
completed checks are in the [validation record](validation/2026-09-25-m2-mapping/README.md).

Fresh source-pinned measurements give a paired Assay/Bend ratio of
1.495831642, which fails the unchanged 1.0 bound, and a normalized corpus
ratio of 0.660838, which passes. These separate timing runs do not establish
a feature-specific speed change. Compiler integration, the remaining M2
features and the paired speed requirement are still open. See
[M2-MAPPING.md](M2-MAPPING.md) for the API and scope.

## 2026-09-25: M2 packed storage

Base: `f806892`. Added `Layout.Packed` for scalar field placement,
storage metadata and checked packed-word reads and writes. It supports
uint8, uint256, address and bool. Writes preserve neighboring bits;
invalid locations, words, values, duplicate names and dynamic types are
explicit errors. The legacy layout printer is unchanged. Source lowering
for packed declarations remains pending.

The packing gate passes 11 layout fixtures, 1,685 distinct access/readback
cases, 40 refusals, 11 compiling semantic mutants and a restored control.
The inherited test run passes 12 adapters and 18 commands. House and
trusted-source audits pass without changing their rules or limits.
The new default appends one leg, for 81 checks; all 48 older modes retain
their schedules, deadlines and failure classification.

The paired benchmark ratio is 1.727570573 and the normalized corpus ratio
is 1.599478. Fresh source pins retain all 110 previous denominator paths
and add the packing test, both measurements and native carry manifest.
The two changed carry fingerprints retain all 12 inventory entries and
unchanged upstream provenance; the old layout and test definitions are
byte-identical. Both ratios exceed the
unchanged 1.0 bound; the binding speed requirement remains open.

See [M2-PACKING.md](M2-PACKING.md) for the API and
[the validation record](validation/2026-09-25-m2-packing/README.md) for
completed checks and full gate outcomes. M2 is not closed.

## 2026-09-22: ERC-20 reference

Base: `8f61dd5a30b24628317caf5a27544522c221a25e`.

Added a hand-assembled ERC-20 reference before extending source emission.
It has nine methods, two events, balance and nested allowance mappings,
dynamic string returns and a fixed-supply constructor. Frozen ABI, layout,
mapping-key and execution fixtures accompany the commented bytecode.

The runtime is 798 bytes with 431 instructions; the constructor prefix is
107 bytes with 50 instructions. The gate covers every instruction, checks
85 runtime cases under geth run and signed Cancun t8n, and checks four
creations under run. It verifies committed t8n event logs and log operands
from both runtime traces. Eleven bytecode mutants fail their named semantic
witnesses, and every restored control passes.

Validation: all 76 default legs pass in one full run, ending with
`STAGE-M2-REFERENCE OK`. All 45 historical modes preserve their commands,
deadlines, markers and failure classification. The denominator inventory
retains all 137 previous entries, updates only the two gate entry points,
and adds ten pins for the new harness and fixtures. Compiler and kernel
sources and all trusted-code limits are unchanged.

The [validation archive](validation/2026-09-22-m2-reference/README.md)
retains full output, per-leg logs, raw executor and mutation captures,
tool versions and 154 source pins. The existing Bend 2 checks pass; this
slice makes no fresh compilation timing measurement.

Next M2 work: source compiler support targeting the reference, packing,
dynamic ABI input handling and the Lean negative mutants required by M2-ABI.
The current slice establishes a reference and does not close M2.

### Review round 2026-09-22 (M2 reference: the ERC-20 reference gate)

Three review items were applied to the staged tree.

C-1 (medium): README.md still said that dev/gates.sh selects
--m1-close with 75 legs while the staged wrapper execs
--m2-reference; now the paragraph names --m2-reference, the 75
--m1-close legs and the ERC20-REFERENCE leg, for 76 legs.

A-1 (low): reference/erc20/MANIFEST.json declared 13 mutation sites
while the harness applied 11 and nothing tied the two lists; now the
manifest holds the 11 applied sites and dev/erc20-test.py requires
the manifest key set to equal the choices list (ERC20-SITES).

A-2 (low): creates=4 in the ERC20-REFERENCE marker was a literal
return 4; now creation() counts the creations it executed, requires
the count to equal 4 (ERC20-CREATE count) and returns the count.

The marker stays ERC20-REFERENCE cases=85 creates=4 mutants=11
covered=431 scope=reference OK. dev/DENOMINATORS.sha256 rows for
dev/erc20-test.py and reference/erc20/MANIFEST.json await the
record refresh.

### M2 typed ABI metadata, 2026-09-22

Base: `6cb76ea`. Added `Abi.Schema` for the five ERC-20 metadata types,
typed function inputs and outputs, custom errors, indexed events,
constructors and fallbacks. Existing Word entries now use this printer
and retain byte-identical ABI output and canonical signatures.

Validation: full compiler build; nine ERC-20 selectors, two event topics,
seven edge declarations, six legacy rows plus their constructor, and
eight compiling semantic mutants. All 46 earlier gate modes preserve
their schedules and classification. The default appends ABI-SCHEMA as
leg 77. The full run passed 76 legs and failed only AXIOMS because the
fresh checkout lacked its preprovisioned Lean packages. Both packages
were cloned locally at their pinned revisions; the identical AXIOMS
command then passed with exit 0, zero sorries and all 42 theorem reports.
All 77 checks are validated across the full run and this focused rerun.

Refreshed both performance records for the changed ABI source. The
binding Assay/Bend 2 ratio is 0.070826341 against 1.0. Trusted code totals
2287/3550 lines under the existing budgets. The reference, kernel and
measurement methods retain their previous source identities.

Evidence: `dev/validation/2026-09-22-m2-abi-schema`. It includes full
streams, leg logs, focused captures, gate compatibility, source hashes
and the active Bend 2 measurement. Setup failures (a jq invocation,
measurement before building the executable, and an incomplete PATH)
are retained separately. The full-run failure and successful AXIOMS
rerun remain explicit in the archive; no full-run success is claimed.

This slice checks typed metadata. Compiler lowering, ABI encoding,
mapping and event execution, packing and M2 Lean mutants remain pending.

### Review round 2026-09-22 (M2 ABI schema: typed ABI metadata)

Five review items were applied to the staged tree; two await the
re-freeze unit.

B-1 (medium): README.md row 383 still published the predecessor
ratio 0.072614202 while row 4 and every other document say
0.070826341; now row 383 quotes 0.070826341.

C-2 (medium): dev/M1-BEND2.md and dev/M1-CLOSE.md said the default
wrapper runs 76 checks; both now name the ABI-SCHEMA leg and 77
checks. dev/M2-REFERENCE.md attached the ERC20-REFERENCE marker block
to the ABI-SCHEMA sentence; the colon is back on the reference-leg
sentence and the ABI-SCHEMA sentence follows the block as its own
paragraph.

C-4 (medium): dev/M1-BEND2.md claimed dev/DENOMINATORS.sha256 pins the
retained measurement file under dev/validation; it pins the active
report and the corpus files, and the record's FILES.sha256 seals the
retained copy. The paragraph now says so.

B-2 (low): the record README never declared that gate-compatibility.py
pins ROOT to the isolated clone /Users/oobi/Documents/gpt1/assay-m2-abi;
the README now names the clone and states that a rerun needs that path
replaced by the tree under test.

D-4 (low): the record README said GATE-LOGS.tar.gz holds every final
leg log and ABI-CAPTURES.tar.gz holds only schema output, mutant
witnesses and measurements; it now lists the first-run AXIOMS.log, the
passing axioms-rerun.log, and every extra entry of ABI-CAPTURES.tar.gz
(gates-before.py, GATE-COMPATIBILITY.json, archive-readme.md,
build-log.md, a __pycache__ bytecode file).

B-3 (low, fixed in round 2): the ABI-SCHEMA marker at
dev/abi-schema-test.py was a fixed literal, not derived from the checks
that ran. main() now counts the killed mutants and reads the function,
event, edge and legacy counts from the ROOT build's control.json that
the oracles checked; the printed marker is byte-identical (functions=9
events=2 edges=7 legacy=6 mutants=8), so dev/stage-a-gates.py and
dev/M2-ABI-SCHEMA.md are unchanged. dev/DENOMINATORS.sha256 row 41 now
carries the digest of the fixed dev/abi-schema-test.py.

D-1 (medium, fixed by the re-freeze unit): test/dune, the dune stanza
that builds test/abi_schema.exe, now has its dev/DENOMINATORS.sha256 row
(150 rows, sorted, between test/contract_route.ml and
test/emit_cases.ml) and is a SOURCES.json input (159 inputs). The
record refresh re-hashed the DENOMINATORS section and FILES.sha256; no
log or tarball was edited.
### M2 typed ABI values, 2026-09-22

Base: `1c6968f`. Added the sealed `Abi.Codec` API for raw tuples of
Uint8, Uint256, Address, Bool and String values. Encoding returns typed
range and size errors. Decoding enforces canonical offsets, lengths,
padding, boolean values and numeric widths, and consumes the complete
tuple. Raw string bytes round trip unchanged. The ABI module measures
171/400 lines; all artifact and kernel bounds are unchanged.

The codec gate checks 48 cast encodings, 49 round trips, five frozen
ERC-20 return values, 26 explicit refusals, 288 truncation prefixes,
128 perturbed input probes and ten compiling semantic mutants with
named witnesses. The default wrapper appends this gate to the previous
77-leg schedule. A compatibility check preserves all 47 historical
modes and checks five failure classifications.

The complete default run passed 77 legs and failed HOUSE on the initial
test adapter's list lookup and catch-all patterns. The adapter was
rewritten without weakening the house rules, and HOUSE then passed in
its rerun. test/abi_codec.ml and dev/DENOMINATORS.sha256 were rewritten
while the default run was in flight, after its DENOMINATORS leg; the
record holds no artifact that dates the rewrite against the ABI-CODEC
leg, and that leg's log is byte-identical to the pre-rewrite focused
capture, so the default run does not attest the corrected adapter. Its
compile and harness pass rest on the review-round ladders. Final source
pins, budgets, speed and whitespace checks passed. All 78 legs are
validated across the complete run, the HOUSE rerun and the review-round
ladders; the record retains the original failing verdict.

Fresh five-round measurements took 9.643 seconds for the OCaml diagnostic
and 3.319 seconds for the six-program Bend comparison. The binding
Assay/Bend 2 ratio is 0.073514764 against the unchanged 1.0 limit.
The 154 source-pin entries cover the new adapter and gate. Validation
and diagnostic captures, per-leg logs, vectors, measurements and source
hashes are in `dev/validation/2026-09-22-m2-abi-codec`.

Source typing and EVM ABI integration, mappings, events, packing and the
M2 Lean negative mutants remain pending. This codec slice does not close M2.

### Review round 2026-09-22 (M2 typed ABI values: the Abi.Codec host codec)

Six review items were applied to the staged tree in text; the pin
re-freeze (A-1, B-1) and the record refresh (D-2) await their own units.

A-1 (medium): the 128 input probes of dev/abi-codec-test.py drew random
bytes, so seed 0xAB1 accepted none and the re-encode identity ran on
zero inputs. The probes now derive from valid encodings of drawn values,
half of them perturbed once (a flipped byte, a dropped final word, an
appended byte or zero word, or a random offset or length word). Every
accepted probe must encode back to identical bytes and at least 32 must
be accepted (FUZZ-ACCEPTED, printed as FUZZ trials=128 accepted=N). The
marker row is unchanged. dev/M2-ABI-CODEC.md describes the probes.

A-2 (low): dev/M2-ABI-CODEC.md said a restored control runs afterward.
Mutants build in a scratch copy and the control reruns the unmodified
root build; the note now says so.

B-1 (low): dev/bend2-m2-codec-2026-09-22.json and
dev/denominators-m2-codec-2026-09-22.json were not pinned by
dev/DENOMINATORS.sha256; the second fix round re-froze the file from
its own path set (shasum -a 256, never typed rows), adding both rows in
sorted position, giving 154 rows, together with the new digest of
dev/abi-codec-test.py; shasum -a 256 -c prints 154 OK rows. The record
twin REC/DENOMINATORS.sha256 keeps the 152-row run-time list.

C-1 (medium): dev/M1-CLOSE.md row 5 published the predecessor ratio
0.070826341; it now quotes 0.073514764.

C-2 (low): dev/M2-ABI-SCHEMA.md stated in the present tense that the
ratio is 0.070826341; it now dates that value to its slice and points
to the codec re-measurement 0.073514764.

D-1 (medium): this record's README and the paragraph above claimed that
the default run's ABI-CODEC leg exercised the corrected adapter. Both
now state the in-flight rewrite and that the default run does not
attest it; the compile and harness pass rest on the review-round
ladders.

D-2 (low, residual): REC/RESULT.json performance_ratio and count and
the FINAL-CHECKS source-pins=152 marker are typed literals at
archive.py:102 and final-checks.py:13, not derived from the captured
outputs; the derivation lands in the main-loop record refresh.
## 2026-10-03: source event declarations and emission

M2 group 4 now connects event declarations and effectful emission to the shared
ABI schema, checked compiler, model and EVM logs. Indexed scalar and string
topics, anonymous LOG0 through LOG4, typed tuple data, packed and mapping writes,
payable calls, ordered emissions and rollback have independent execution
witnesses. Constructor emission has an explicit refusal.

The reserved event guard proves only `Le 0 0`. A regression rejects the invalid
invariant program that the initial false guard incorrectly accepted. The model
and emitter enforce the same 131072-byte data cap, including its exact boundary.

Validation is retained in
[the source event record](validation/2026-10-03-m2-source-events/README.md):
SOURCE-EVENTS passes 34 cases and 16 refusals; FUNCTION-ABI passes 47 cases;
RETURN-ABI passes 49 cases, eight layouts and 30 refusals. The cumulative
105-leg attempt completed 59 legs with 56 passes and three proof-related
timeouts, then was stopped with SIGTERM during leg 60 under a host load
average near 89. The exact 128-guard timeout also reproduces at the unchanged
HEAD with the same pinned compiler and limit. The complete battery remains
pending for M2 closure.

The default wrappers now select source events. Existing deadlines and trusted
artifact budgets are unchanged. The new compiler source module follows the
function and return ABI module boundary and remains subject to the planned
M2 group 8 audit. No commit or M2 closure is recorded by this staged slice.

A review of the staged slice fixed six findings. F1: `ReturnAbi.string_blocks`
writes a zero word after each copied String, so an earlier event tuple leaves
no padding bytes in later String encodings; two regression cases cover it. F2:
dev/cli_delta.py refreshes the pins of Case.Packed.switch_35,
Case.Packed.switch_38 and Cli.Packed.read_file for the
Mapping.Runtime.Plan.Events arm and EventSource.lower. F3:
dev/event-source-test.py pins a diagnostic for every refusal mutant under
check and emit, isolates the indexed limit in both overflow mutants and checks
the ABI event rows of each variant. F4: the record archives the scoped
outputs, the run manifest and the SIGTERM stop, and rechecks MILESTONE-SPEED
and the 313 checksums on the final staged files. F5: README.md and ten dev
pages name the 105-leg default gate mode. F7: event refusals report the
offending token with the SURFACE_EVENT code, and a bare event declaration
fails at its name. SOURCE-EVENTS now passes 34 cases and 16 refusals. The
record keeps the review reruns under review/.

## M2 group 6: source ERC20, 2026-10-04

On `be3062d`, added `examples/ERC20.asy`: all nine standard entries,
fixed supply, balances, allowances, approvals, transfers, metadata and
typed Transfer/Approval events. The source uses the reference development
account as a fixed genesis holder. It retains the constructor event
refusal and the source decoder's strict trailing-calldata rule.

Added `pure (string 0xHEX)` for String results up to 31 bytes, including
empty and opaque byte strings. The checked Word representation separates
literal tags from validated calldata offsets. String parameters named
`string` retain their existing parenthesized return syntax.

Focused validation passed: ERC20-SOURCE (85 cases, 9 explicit canonical
refusals, 4 creates, 5 literal/parameter cases and 15 malformed-literal
refusals), RETURN-ABI (49 cases, 8 layouts, 30 refusals), SOURCE-EVENTS
(34 cases, 16 refusals), MILESTONE-SPEED (57 schedules and 9 controls),
PIN-CARRY, HOUSE, R0-COUNT, R0-AUDIT, TRUSTED-LINES and diff whitespace.
The final ERC20 command passed under its unchanged 900-second gate bound.

The new `--m2-source-erc20` mode carries all 106 earlier legs and adds the
ERC20 suite. Default gate entry points now select its 107 legs. Numeric
source budgets and prior deadlines/markers are unchanged. The suite uses
three isolated workers to avoid serial source-check overhead in the gate.

Evidence, source hashes, command receipts and prior failed/interrupted
attempts are in `dev/validation/2026-10-04-m2-source-erc20/`. The full M2
acceptance battery was not rerun, and the milestone remains open.

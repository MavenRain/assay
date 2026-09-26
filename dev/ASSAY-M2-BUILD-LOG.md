# Assay M2 build log

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

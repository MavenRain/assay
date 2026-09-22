# Assay M2 build log

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

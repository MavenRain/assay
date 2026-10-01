# Assay M2 build log

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

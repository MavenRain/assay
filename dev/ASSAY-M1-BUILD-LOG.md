# Assay M1 build log

## 2026-09-18: Hexadecimal Word literals in contract source

The twenty-seventh M1 slice starts at
`c8f85f7cb4d318c3aefcd4640b08bff4890fc785`. Contract source accepts a
hexadecimal Word literal wherever it accepts a decimal one, with a
`0x` or `0X` prefix and one to 64 digits in either case. Both
spellings lower to canonical decimal numerals before proof lookup and
core checking, so existing decimal programs keep their artifacts. The
kernel, assembler, runtime backend, source model and axiom set are
unchanged.

One shared binary operand parser replaces the two earlier
implementations, and guard resolution reuses the condition to claim
conversion. The combined emitter measures 1800/1800 lines. Because
both guard paths now read one conversion, the compiler no longer
cross-checks the proved claim against the emitted runtime condition,
so the inferred-guard NAMED-ARGUMENTS mutant is killed by the
independent runtime expectation `MODEL-EXPECTED ig-named-1` alone.

The completed battery passes all 60 functional gates. The new
HEX-LITERALS leg, declared at `dev/stage-a-gates.py:203-204`, prints
`HEX-LITERALS pairs=30 cases=46 signed=25 creates=23 refusals=23
mutants=4 OK` over 30 source pairs, 46 outcomes under the source
model and geth, 25 signed Cancun transitions, 23 creation cases, 23
refused programs and four compiler mutations with restored controls.
AXIOMS and INFERRED-GUARDS were rerun: the first AXIOMS run lacked
the offline proof cache, and the INFERRED-GUARDS marker was updated
after the mutant moved to its runtime witness. DENOMINATORS and
M0-RATIO remain pending under the existing timing pause; the full
62-leg runner exits 1 and retains its FAIL stamp. All 61 prior gate
declarations preserve their exact commands, deadlines and markers.

The [slice contract](M1-HEX-LITERALS.md),
[mutation contract](M1-HEX-LITERAL-MUTATIONS.md) and
[validation archive](validation/2026-09-18-m1-hex-literals/) record
the source forms and checks. Timing remains paused and its frozen
inputs are unchanged.

### Review round 2026-09-18 (M1 hexadecimal Word literals)

A-1 (low): guard resolution reuses the one condition conversion, so
the proved claim and the emitted runtime condition can no longer
disagree at compile time. Now the slice contract and this log both
state that an argument reversal inside that conversion is refused
only by the independent runtime expectation.

A-4 (low): the slice contract left the uint256 range check as the
stated bound of a hexadecimal value, which the 64 digit width rule
already refuses. Now the contract states that the width rule refuses
it and that the range test guards the decimal path only.

D-1 (low): this build log carried no section for the twenty-seventh
slice, while all 26 earlier slice commits carry one. Now the slice
has a section in the shape of its predecessors.

D-2 (low): seven rows of the record README ran past 72 columns, up
to 109. Now every row wraps at 72 columns, with no word, number or
backtick span changed.

## 2026-09-17: Word equality in contract source

The twenty-sixth M1 slice starts at
`92aa8a903910a03d43c7b50b212efd9a8ddefa28`. It adds `eqWord a b`
runtime guards and `EqWord a b` proof claims as expansions into bounds
in both directions. Caller access checks compose with deployer
initialization, custom reverts and rollback. Existing inferred proofs,
helper arguments, proof projections and storage invariants consume the
same checked product. No new axiom or core primitive is introduced.

Equality consumes two runtime bounds. Generated claim leaves count
toward the existing depth limit, including at the last admitted level.
The combined emitter measures 1800/1800 lines; the carried kernel,
inherited parser, runtime backend and model are unchanged.

The completed battery passes all 59 functional gates. DENOMINATORS and
M0-RATIO remain pending under the existing timing pause; the full
61-leg runner exits 1 and retains its FAIL stamp. All 60 prior gate
declarations preserve their exact commands, deadlines and markers.
The equality gate passes eight five-file comparisons, 53 runtime cases,
33 signed Cancun comparisons, eight creation outcomes, six boundary
forms, 17 source refusals and four compiler mutations with restored
controls. The generated claim-depth boundary is checked explicitly.

The [slice contract](M1-EQUALITY.md),
[mutation contract](M1-EQUALITY-MUTATIONS.md) and
[validation archive](validation/2026-09-17-m1-equality/) record the
source forms and checks. Timing remains paused and its frozen inputs
are unchanged.

### Review round 2026-09-18 (M1 Word equality in contract source)

A-2 (medium): the 64-bound refusal branch of the runtime `eqWord` arm
was unreachable, because both width boundary cases used balanced
`eqWord` terms and always left an even bound budget. Now the refused
width case spends 63 `leWord` bounds before its `eqWord`, and every
boundary row pins the exact limit message it expects.

A-1 (low): the runtime `eqWord` arm did no depth accounting, so its
depth refusal came from the expansion stage with another message and
another location. Now the arm tests depth and bounds together and
reports the same limit message as the condition parser.

B-1 (low): five refusal rows pinned only the compiler wide `mismatch`
class, which any unrelated type error satisfies. Now each of the five
pins the exact equality detail text that check, emit and run print.

D-1 (low): row 3 of the record README ran to 100 columns and merged
the base row with the legs sentence. Now the two sentences sit on two
rows and the record manifest carries the new README hash.

## 2026-09-17: context in contract source

The twenty-fifth M1 slice starts at
`dbce0894338775d0eb97bbc0e76ac5605c728552`. It adds `sender <- caller`
and constructor `deployer field` syntax to the contract lowerer. Both
forms select existing optional core effects. Runtime locals retain
fresh snapshots and normal proof scope. Constructor writes retain their
source order, and a deployer write invalidates the field's known literal
value before constructor invariant checking.

An invariant over a dynamically initialized field is refused unless a
later literal store supplies its final value. Unrelated invariants,
caller guards, inferred helper arguments and proof-supplied arithmetic
continue through the existing checker. The kernel, inherited surface,
core recognizer, runtime emitter, model and axiom set are unchanged.
The emitter measures 1792/1800 lines.

The new gate compares all five emitted artifacts with equivalent core
programs for eight combinations of errors, proofs and deployer effects.
It checks 224 runtime cases, 56 signed Cancun comparisons, 64 creation
outcomes, six proof/snapshot composition cases, four constructor order
cases and 17 invalid sources through check, emit and run. Four built
mutations fail their named witnesses, and the restored controls pass.
All 59 earlier gate declarations retain their commands, deadlines and
success markers.

All 58 functional gates pass after five environment rechecks. The
initial PATH omitted `rg` and `leancho`; the affected R0 count, house,
mutation, axiom and source-proof gates pass with the normal tool path
and their unchanged deadlines. The initial 60-leg battery passed 53
legs. DENOMINATORS and M0-RATIO remain pending under the timing pause.
The archive retains both the initial failures and the rechecks.

The [slice notes](M1-CONTEXT-SURFACE.md),
[mutation contract](M1-CONTEXT-SURFACE-MUTATIONS.md) and
[validation archive](validation/2026-09-17-m1-context-surface/) describe
the accepted source forms and retained evidence. Timing stays paused;
the frozen inputs, deadlines and performance claims are unchanged.

### Review round 2026-09-17 (M1 context in contract source)

| id | sev | one line | files |
| --- | --- | --- | --- |
| C-1 | medium | `composition()` published the composition and order counts from the literals `len(records) + 1` and `4`, so five cases were unchecked by the leg tail | dev/context-surface-test.py |
| D-1 | medium | the documented emit command reused `Context-out`, the directory the README assigns to `ContextCore.asy`, so the row exits 64 | dev/M1-CONTEXT-SURFACE.md |
| C-2 | low | the archive README described `SOURCES.json` as the source inputs, while the file hashes 731 code paths and no document | dev/validation/2026-09-17-m1-context-surface/README.md |
| B-1 | low | `refusals(only=...)` returned the full row count, so a one-case witness recorded 17 cases | dev/context-surface-test.py |

Fixed: 4, all by run 1 of this review. Refuted: 1, B-2, because the
driver compares all five emitted files of the example with a generated
reference. Merged and dropped: 0.

C-1 now appends the shadow record and collects the four constructor
order rows, so `composition` returns `len(records), len(orders)` and
`COMPOSITION.json` carries all six records. B-1 counts the exercised
rows and refuses an unknown case name. Both counts stay 6, 4 and 17, so
the gate marker in `dev/stage-a-gates.py` is unchanged. Neither file is
a row of `dev/DENOMINATORS.sha256`, so no freeze row moved.
`SOURCES.json` carries the moved hash of the driver, and
`ARTIFACTS.json` carries the moved hashes of the archive README and of
`SOURCES.json`.

Gate: fix-M1CTXS-1-smoke.log, verdict GREEN-FUNCTIONAL, 60 legs, 58
pass, and every red row is DENOMINATORS or M0-RATIO, the disclosed
state of this slice while the timing gate is paused.
STAGE-M1-LINE: STAGE-M1-CONTEXT-SURFACE FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1
PASS-COUNT: 58
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=52.0 FAIL M0-RATIO
exit=1 elapsed_ms=162.2
DENOM-FAILED-ROWS: bin/assay.ml: FAILED dev/M1-ERRORS.md: FAILED
dev/M1-PROOFS.md: FAILED dev/M1-SURFACE-MUTATIONS.md: FAILED
dev/M1-SURFACE.md: FAILED dev/contract-test.py: FAILED
dev/errors-test.py: FAILED dev/gates.sh: FAILED dev/m1-emit-test.py:
FAILED dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED
emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED
emit/model.mli: FAILED emit/recognize.ml: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13
OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed
control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6
effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK
SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6
mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
witness=increment-success killed control=OK COUNTER-REFERENCE cases=30
creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING:
16 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 16 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42

```
SURFACE-CONTEXT-TAIL: SURFACE-CONTEXT-MUTANT SLOT killed control=OK SURFACE-CONTEXT cases=224 signed=56 creates=64 pairs=8 composition=6 order=4 refusals=17 mutants=4 OK
```

DENOMINATORS stayed red on the kept 119 row manifest; no row was
refrozen. The row refresh belongs to the FINAL tree, rows-only. No
fix of this round refreshed a DENOMINATORS row. The M0-RATIO remeasure
is CARRIED to a calm host; dev/denominators.json and
dev/measurements are never edited in this review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused: pass=58 of 60 legs, fail=[DENOMINATORS,
M0-RATIO], mutants=true, timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true)

The finders and the builder ran opus/medium on the first attempt, with
an opus/medium fallback when the first attempt returned null. The gate
runner ran opus/medium. The verifiers, the judge and the check stage ran
opus/high. The closer ran sonnet/medium, never opus.

## 2026-09-17: core EVM context

The twenty-fourth M1 slice starts at
`b2415c461b357fb3d715aa53e10494f1e401e101`. It integrates the caller and
deployer effects used by the public DAO port. Optional checked families
select the effects; malformed or reordered families remain refusals.
Caller reads occupy fresh memory words. Creation writes use the
immediate deployer, including factories. `run --caller` validates
uint160 context and preserves a zero default. The contract surface
retains its existing invariant and constructor rules.

The emitter measures 1767/1800 lines. The kernel, surface, proof
sources, backend and artifact budgets are unchanged. All five artifacts
from the pushed DAO are byte-identical under the integrated compiler.
The context gate covers eight protocol layouts, signed Cancun
comparisons, creation, nested calls, malformed schemas and six built
compiler mutations.

Two inherited mutation anchors now include the model's caller parameter.
Their faults, witnesses and success criteria are preserved. The initial
battery also encountered timeouts in older proof-inference gates under
high host load. The
[validation archive](validation/2026-09-17-m1-context/) records the
initial results, rechecks and exact source identities. All 57 functional
legs pass after the five rechecks. The initial 59-leg battery passed 52
legs. The three timeout rechecks pass with their original deadlines. All
58 earlier gate declarations remain unchanged, including their commands,
deadlines and success markers. Frozen timing inputs remain unchanged and
timing remains paused.

### Review round 2026-09-17 (M1 core EVM context)

| id | sev | one line | files |
| --- | --- | --- | --- |
| G-1 | medium | row 7 of the canonical driver did not select `--m1-context` | dev/gates.sh |
| ND-1-1 | medium | row 20 of the archive manifest carried a stale hash for `SOURCES.json` after the row 7 fix | dev/validation/2026-09-17-m1-context/ARTIFACTS.json |
| C-2 | low | the protected list named `backend`, which no tracked path matches | dev/validation/2026-09-17-m1-context/FINAL.json |
| C-3 | low | the SOURCE-MODEL rerun carried no command, deadline, exit, pass flag or marker | dev/validation/2026-09-17-m1-context/RECHECKS.json |
| D-1 | low | the stage commit text was absent, while 29 earlier stage flags carry one | dev/STAGE-M1-CONTEXT-COMMIT.txt |
| V-1 | low | eleven prose rows exceeded the 72-column house width | dev/M1-CONTEXT.md, dev/ASSAY-M1-BUILD-LOG.md, dev/validation/2026-09-17-m1-context/README.md |

Fixed: 6, G-1 and ND-1-1 by run 1 of this review, C-2, C-3 and D-1 by
run 2, and V-1 by the close. Refuted: 2, D-2 and D-3. Merged and
dropped: 4, three duplicate reports of G-1 and one report of the entry
that the refuted item also named.

V-1 came from the kit close gate, not from a lens. The eleven rows are
pre-existing slice prose, rewrapped with the words unchanged.

The C-3 values come from the recorded capture of that same rerun, so
no gate was measured again. The new commit text is pinned in
`SOURCES.json`, and `ARTIFACTS.json` records the moved archive hashes.

Gate: fix-M1CTX-1-smoke.log, verdict GREEN-FUNCTIONAL, every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused.
STAGE-M1-LINE: STAGE-M1-CONTEXT FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 14:00:48
PASS-COUNT 57
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=58.9 FAIL M0-RATIO
exit=1 elapsed_ms=163.8
PASS EVM-CONTEXT exit=0 elapsed_ms=33616.1

Rows refreshed by this fix round: FINAL.json (protected now 12 paths,
`backend` dropped, protected_diff unchanged empty), RECHECKS.json
(first entry, SOURCE-MODEL, gains command, deadline null, marker,
exit 0, passed true, outer_deadline kept beside deadline),
dev/STAGE-M1-CONTEXT-COMMIT.txt (new file, house shape), SOURCES.json
(973 entries, one sha256 row inserted in sorted position, and one row
moved for the build log edit), ARTIFACTS.json (rehashed after each of
FINAL.json, RECHECKS.json and SOURCES.json).

DENOMINATORS stays red on the kept 119 row manifest: no row of
dev/DENOMINATORS.sha256 was edited this round, so the disclosed red is
unchanged. The M0-RATIO remeasure is CARRIED to the close step on a
calm host; dev/denominators.json and dev/measurements/ are untouched
by this review.

Full ladder
/Users/oobi/Documents/assay-m1-context-review/gates-M1CTX-1.log,
14:17:56, load 18.25/17.83/18.34 at 14:03 rising to
18.48/19.39/18.18 at 14:17:

```
STAGE-M1-LINE: STAGE-M1-CONTEXT FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1 LADDER-WRAPPER-EXIT 0 14:17:56
PASS-COUNT: 57
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=166.7 FAIL M0-RATIO exit=1 elapsed_ms=172.8
DENOM-FAILED-ROWS: bin/assay.ml: FAILED dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md: FAILED dev/contract-test.py: FAILED dev/errors-test.py: FAILED dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED emit/model.mli: FAILED emit/recognize.ml: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING: 16 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 16 computed checksums did NOT match
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS cases=66 creates=2 refusals=26 mutants=5 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
EVM-CONTEXT-TAIL: CONTEXT-MUTANT SCHEMA killed control=OK EVM-CONTEXT cases=224 signed=56 creates=64 refusals=7 inputs=7 nested=2 independent=6 mutants=6 OK
```

gate: GREEN-FUNCTIONAL (every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused:
pass=57 of 59 legs, fail=[DENOMINATORS,M0-RATIO], mutants=true, marker
tails ok=true, timeout legs only=false, disclosed reds only=true,
wrapper exit ok=true).

The finders and the builder ran opus/medium on the first attempt, with
an opus/medium fallback when the first attempt returned null. The gate
runner ran opus/medium. The verifiers, the judge and the check stage ran
opus/high. The closer ran sonnet/medium, never opus.

## 2026-09-17: inferred proof-producing guard bindings

The twenty-third M1 slice starts at
`088a4056707432d452ecff5b0e38069d53a3a8bc`.
A guard binder can use `(0 checked)` and derive its claim from the
condition. Atomic, compound and named conditions lower through the
existing checked guard path. Explicit annotations remain obligations,
including in unused and reverting continuations. Conditions and error
payloads resolve before the new proof name enters scope.

The focused suite passes 160 source-model/Cancun comparisons, two
creation outcomes, 27 refusals through three commands and 20 pairs
with equal five-file output. Four accepted boundary forms also have
equal output. Four compiler mutations build, fail their named witnesses
and pass after restoration. The earlier inferred-binding `guard-type`
refusal now checks an empty explicit annotation; accepted unannotated
guards are covered by the new atomic execution cases.

All 56 functional legs pass after five environment rechecks. The
initial 58-leg run passed 51 legs. Its PATH omitted the installed `rg`
and `leancho` directories, so R0-COUNT, HOUSE, MUTANTS, AXIOMS and
SOURCE-PROOFS needed reruns. Their original commands, deadlines and
success markers all pass with the corrected PATH. The compiler source
and binary did not change between the battery and the rechecks.
Both proof suites ran after matching 38 cached source files and two
pinned dependency revisions. All 57 prior gate declarations are
unchanged, and the new selector adds one leg.

[The archive](validation/2026-09-17-m1-inferred-guard-bindings/) retains
the initial battery, rechecks, execution captures, erasure hashes,
boundaries, mutation controls and source hashes.
DENOMINATORS and M0-RATIO report the same 14 stale paths as the
committed baseline. The carried kernel, surface, proof sources,
backend and measurement inputs are unchanged. Timing remains paused;
the performance bound and milestone exit remain pending.

### Review round 2026-09-17 (M1 inferred guard bindings)

| id | sev | one line | files |
| --- | --- | --- | --- |
| C-1 | low | three added prose rows over 72 columns held the WIDTH pin at 3 | dev/M1-INFERRED-GUARD-BINDINGS.md, dev/ASSAY-M1-BUILD-LOG.md |
| D-1 | low | GATE-COMPAT base_sha256 hashed the base driver with a stripped newline | dev/validation/2026-09-17-m1-inferred-guard-bindings/GATE-COMPAT.json |
| D-2 | low | the new-leg tail was pinned as a literal on the fresh ladder leg log | verify-final.sh |

Refuted: 0. Merged and dropped: 0, no item was cut for the 7-finding
cap and no two findings named the same defect.

Gate: gates-M1IGB-1.log, verdict GREEN-FUNCTIONAL, every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused.
STAGE-M1-LINE: STAGE-M1-INFERRED-GUARD-BINDINGS FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 04:55:38
PASS-COUNT 56
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=35.4 FAIL M0-RATIO
exit=1 elapsed_ms=104.9
DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED
dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md: FAILED
dev/contract-test.py: FAILED dev/errors-test.py: FAILED
dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED
dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED
emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED
emit/recognize.ml: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13
OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed
control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16
recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK
SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6
mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
witness=increment-success killed control=OK COUNTER-REFERENCE
cases=30 creates=2 mutants=8 value_rejected=5 covered=120
scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING:
14 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 14 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42

```
INFERRED-GUARD-BINDINGS cases=160 creates=2 refusals=27 erasure_pairs=20 boundaries=4 mutants=4 OK
```

DENOMINATORS stayed red on the kept 119-row manifest; no rows-only
refreeze ran in this review, and none of the 119 rows names a path
this round touched. Rows refreshed this round:
dev/M1-INFERRED-GUARD-BINDINGS.md (C-1 rewrap),
dev/ASSAY-M1-BUILD-LOG.md (C-1 rewrap, this block),
dev/validation/2026-09-17-m1-inferred-guard-bindings/GATE-COMPAT.json
(D-1 base_sha256),
dev/validation/2026-09-17-m1-inferred-guard-bindings/ARTIFACTS.json
(D-1 cascade),
dev/validation/2026-09-17-m1-inferred-guard-bindings/SOURCES.json
(D-1 cascade), verify-final.sh (D-2, kit only). The M0-RATIO
remeasure is CARRIED to a calm host; dev/denominators.json and
dev/measurements are untouched by this review.

gate: GREEN-FUNCTIONAL (every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused)

The finders and the builder ran opus/medium on the first attempt, with
an opus/medium fallback when the first attempt returned null. The gate
runner ran opus/medium. The verifiers, the judge and the check stage ran
opus/high. The closer ran sonnet/medium, never opus.

## 2026-09-16: inferred proof binding types

The twenty-second M1 slice starts at
`c74a4ee3558b45b1cca52ef1921581365e11d202`.
Erased entry and proof-local bindings can omit their claim when the
initializer supplies one. Names, helper results, pairs, projections
and annotated expressions retain their checked types and evidence.
Explicit annotations remain obligations, and a bare placeholder still
requires an expected claim. `InferredBindings.asy` demonstrates the
bounded counter with inferred bindings in entries and helper bodies.

The lowering annotates inferred initializers before kernel checking.
Unused declarations and reverting continuations retain those checks.
Constructed proof bundles use the existing claim budget of 32 depth
levels and 4096 nodes before type serialization. The depth arm of
that budget applies to an inferred pair claim only, because a written
claim already obeys the surface depth bound. This bounds repeated
pairing of earlier bindings, which otherwise doubles the inferred type
at each step, and it also bounds a spine that adds one level per step
while staying far below the node budget.

The focused suite passes 229 source-model/Cancun comparisons, two
creation outcomes, 25 refusals through three public commands and 21
inferred/annotated pairs comparing all five emitted files. It accepts
proof nesting through 128 and rejects 129. A 4095-node inferred bundle
and a 32-level inferred claim spine erase identically to a program
without proofs; 4097 nodes, repeated doubling and a 33-level spine are
refused. Six compiler mutations fail their witnesses
and pass after restoration. The compiler builds without errors or
warnings, and the static scan reports no findings.

The existing guard CLAIM mutant required a harness adjustment: the
new inference path left its local resolver unused after mutation,
causing the mutant build to fail before its refusal witness. The
mutant now consumes that binding and retains its invalid claim and
witness. The complete guard recheck passes 83 execution cases, two
creation outcomes, 26 refusals, three erasure variants and all six
mutations with restored controls. No production source or compiler
binary changed after the complete battery began.

Validation passes all 55 functional legs after that guard recheck.
The complete 57-leg run initially passed 54 legs; its failed guard
attempt remains recorded. All 56 prior gate commands, deadlines and
success markers are unchanged. Both proof gates ran after verifying
35 cache source files and two pinned dependency revisions.

The [validation archive](validation/2026-09-16-m1-inferred-bindings/)
retains the original battery, corrected guard recheck, focused captures,
mutation controls, boundaries, source hashes and artifact hashes.
DENOMINATORS and M0-RATIO report the same 14 stale hashes as the
committed baseline. The carried kernel and surface, proof sources and
measurement inputs are unchanged. Timing remains paused, and the M1
performance bound and milestone exit remain pending.

### Review round 2026-09-16 (M1 inferred bindings)

| id | severity | note | files |
| --- | --- | --- | --- |
| A-1 | medium | inferred-claim budget counted nodes only; now bounds depth 32 too | emit/contract.ml, dev/inferred-binding-test.py, dev/stage-a-gates.py |
| C-1 | low | seven prose rows over 72 columns; rewrapped | dev/validation/2026-09-16-m1-inferred-bindings/README.md, README.md, dev/M1-SURFACE.md |
| D-1 | low | BOUNDARIES.json hashed the annotated twin; now hashes the inferred source | dev/inferred-binding-test.py |
| ND-1-1 | medium | round-1 depth bound also constrained written claims, un-killing the PROOF-BUNDLES CLAIM-DEPTH mutant; round 2 bounds an inferred pair claim only | emit/contract.ml |
| ND-1-2 | medium | archive JSONs not regenerated after the round-1 driver change | dev/validation/2026-09-16-m1-inferred-bindings/BOUNDARIES.json, MUTANTS.json, LIVE.json, ERASURE.json, INFERRED-BINDING-CAPTURES.json, legs/INFERRED-BINDINGS.log, ARTIFACTS.json |

Refuted: 0.

Merged and dropped: 0; the five findings name five distinct review
findings. Fix round 2 grouped A-1 with ND-1-1 (one code cause in
emit/contract.ml) and D-1 with ND-1-2 (one archive cause), but no
finding was merged or cut from the report.

Gate result, from
/Users/oobi/Documents/assay-m1-inferred-bindings-review/
gates-M1IB-2.log:

```
STAGE-M1-LINE: STAGE-M1-INFERRED-BINDINGS FAIL
EXIT 1 | LADDER-WRAPPER-EXIT 0 23:47:20
PASS-COUNT: 55
FAIL-COUNT: 2
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=216.0 FAIL M0-RATIO exit=1 elapsed_ms=178.8
```

```
INFERRED-BINDINGS cases=229 creates=2 refusals=25 erasure_pairs=21 boundaries=6 mutants=6 OK
PROOF-HOLES cases=242 creates=2 refusals=25 erasure_pairs=23 boundaries=6 mutants=4 OK
INFERRED-HELPERS cases=254 creates=2 refusals=26 erasure_pairs=24 boundaries=6 mutants=5 OK
INFERRED-ARITHMETIC cases=158 creates=2 refusals=24 erasure_pairs=16 mutants=4 OK
INFERRED-GUARDS cases=112 creates=2 refusals=24 erasure_pairs=14 boundaries=6 mutants=4 OK
NAMED-GUARDS cases=96 creates=2 refusals=27 erasure=10 boundaries=6 mutants=4 OK
COMPOUND-GUARDS cases=88 creates=2 refusals=26 erasure=7 boundaries=7 mutants=4 OK
COMPOUND-INVARIANTS cases=64 creates=2 refusals=24 erasure=8 boundaries=10 mutants=4 OK
PREDICATES cases=72 creates=2 refusals=44 erasure=7 boundaries=12 mutants=4 OK
PROOF-BUNDLES cases=102 creates=2 refusals=41 erasure=8 boundaries=11 mutants=4 OK
PROOF-HELPERS cases=104 creates=2 refusals=50 erasure=7 mutants=4 OK
INVARIANTS cases=52 creates=2 refusals=30 erasure=4 mutants=4 OK
PROOF-TERMS cases=98 creates=2 refusals=25 erasure=5 mutants=4 OK
PROOF-GUARDS cases=83 creates=2 refusals=26 erasure=3 mutants=6 OK
```

The A-1 fix legitimately moved the INFERRED-BINDINGS tail from the
baseline row (refusals=24, boundaries=5, mutants=5) to the row above.
The halted Workflow's own check stage hard-coded the baseline tail and
scored this slice RED for that reason; that is a kit defect of the
Workflow script, not a slice defect, and is recorded in the review
report rather than in the commit message. dev/stage-a-gates.py:184
and legs/INFERRED-BINDINGS.log:11 agree on the new tail as staged.

gate: GREEN-FUNCTIONAL by the verdict rule (every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused; STAGE-M1-INFERRED-BINDINGS FAIL and EXIT 1 come
from that same disclosed pair, not from a functional leg).

The finders and the builders ran opus/medium; the Fable probe was
dead for this run, so the finder, builder and closer tier rulings are
unmet. The verifier and judge ran opus/high and are met. The closer
ran sonnet/medium, never opus.

## 2026-09-16: contextual proof placeholders

The twenty-first M1 slice starts at
`9058d167e7d7423102611ffdd6918c5506b9da59`.
`_` is now a proof expression when an expected claim is available.
It can fill an earlier helper proof argument while later Word and
proof arguments remain explicit. It also works in proof bindings,
helper bodies, arithmetic proofs, annotations and contextual pairs.
`ProofHoles.asy` demonstrates the bounded counter with interleaved
proof and Word parameters.

The lowering reuses the existing evidence lookup and annotates each
inferred term before kernel checking. An unproved symbolic or false
claim still fails, including unused arguments and reverting tails.
Word arguments stay explicit. Placeholders lacking an expected claim
fail with `SURFACE_PROOF`; proof projections can supply that context
with an annotation. Existing lexical scope, resolved Word identities,
resource limits and proof-expression sharing remain in effect.

The new suite passes 242 source-model/Cancun comparisons, two
constructor outcomes, 25 refusals through three commands and 23
placeholder/explicit pairs comparing all five emitted files. It also
checks 16-argument forms, rejection of 17 arguments and an unused
false parameter, plus nesting depths 4, 8, 16 and 128 with bounded
generated core size. Four compiler mutations fail their named
witnesses and pass after restoration.

All 54 functional legs pass in the default 56-leg battery. A syntax
tree comparison confirms all 55 earlier gate commands, deadlines and
success markers are unchanged. Both proof gates ran after the cache
checks matched 35 source files and two pinned dependency revisions.
The carried kernel and surface, proof sources, effect protocol and
backend are unchanged. Trusted-code counts remain within their bounds.

The [validation archive](validation/2026-09-16-m1-proof-holes/)
records each result, execution and refusal captures, mutation controls,
nesting bounds, gate compatibility and source and artifact hashes.
DENOMINATORS and M0-RATIO retain their failures against the preserved
older measurement inputs. Timing remains paused; the M1 performance
bound and milestone exit remain pending.

### Review round 2026-09-16 (M1 proof holes)

| id | severity | note | files |
| --- | --- | --- | --- |
| C-1 | low | stage commit file was absent; written | dev/STAGE-M1-PROOF-HOLES-COMMIT.txt |
| C-3 | low | three prose rows over 72 columns; rewrapped | dev/M1-PROOF-HOLES.md, dev/validation/2026-09-16-m1-proof-holes/README.md |
| B-1 | low | boundaries() twin construction was unguarded; now guarded | dev/proof-hole-test.py |
| ND-1-1 | medium | archive manifest stale after round 1 rewrites; refreshed | dev/validation/2026-09-16-m1-proof-holes/ARTIFACTS.json |

Refuted: 0.

Merged and dropped: 0; the four findings name four distinct
defects, so no merge applies and nothing is cut.

Gate result, from
/Users/oobi/Documents/assay-m1-proof-holes-review/gates-M1PHO-2.log:

```
verdict GREEN-FUNCTIONAL: every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused:
pass=54 of 56 legs, fail=[DENOMINATORS,M0-RATIO], denom
rows=[dev/M1-ERRORS.md,dev/M1-PROOFS.md,dev/M1-SURFACE-MUTATIONS.md,
dev/M1-SURFACE.md,dev/contract-test.py,dev/errors-test.py,
dev/gates.sh,dev/m1-emit-test.py,dev/model-test.py,
dev/stage-a-gates.py,emit/contract.ml,emit/emit.ml,emit/model.ml,
emit/recognize.ml], mutants=true, marker tails ok=true, timeout
legs only=false, disclosed reds only=true, wrapper exit ok=true
STAGE-M1-LINE: STAGE-M1-PROOF-HOLES FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 17:38:28
PASS-COUNT: 54
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=84.4 FAIL M0-RATIO exit=1 elapsed_ms=434.6
DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md: FAILED dev/contract-test.py: FAILED dev/errors-test.py: FAILED dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED emit/recognize.ml: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING: 14 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 14 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

```
PROOF-HOLES cases=242 creates=2 refusals=25 erasure_pairs=23 boundaries=6 mutants=4 OK
```

DENOMINATORS stayed red on the kept 119-row manifest; no rows-only
refreeze ran this round, that remeasure belongs to the close step
on a calm host. Fixes refreshed dev/proof-hole-test.py,
dev/M1-PROOF-HOLES.md,
dev/validation/2026-09-16-m1-proof-holes/README.md, added
dev/STAGE-M1-PROOF-HOLES-COMMIT.txt, and refreshed
dev/validation/2026-09-16-m1-proof-holes/SOURCES.json and
dev/validation/2026-09-16-m1-proof-holes/ARTIFACTS.json. The
M0-RATIO remeasure is CARRIED to a calm host; dev/denominators.json
and dev/measurements/ are never edited in this review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while
the timing gate is paused: pass=54 of 56 legs,
fail=[DENOMINATORS,M0-RATIO], mutants=true, marker tails ok=true,
timeout legs only=false, disclosed reds only=true, wrapper exit
ok=true, stage=STAGE-M1-LINE: STAGE-M1-PROOF-HOLES FAIL, m0=M0-LINE:
M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification, exit=EXIT 1 | LADDER-WRAPPER-EXIT 0 17:38:28)

The finders and the builder ran opus/medium on the first attempt, with
an opus/medium fallback when the first attempt returned null. The gate
runner ran opus/medium. The verifiers, the judge and the check stage ran
opus/high. The closer ran sonnet/medium, never opus.

## 2026-09-16: inferred proof-helper arguments

The twentieth M1 slice starts at
`aa8c433ce7bfc1882897e8ab6c93e29ae898a3b2`.
Proof helper calls can omit trailing proof arguments and reuse checked
evidence for their instantiated claims. Evidence includes transaction
guards, proof bindings, bundle components, helper parameters and
proof-local bindings. Supplied proof arguments contribute to later
arguments of the same call. Word parameters remain explicit.

Every supplied and inferred proof keeps its kernel obligation before
erasure, including unused arguments and reverting continuations.
Proofs reused within a call receive a checked local binding so nested
calls reuse names instead of copying growing proof expressions. The
depth-128 regression generates 179,202 bytes of checked core and emits
the same five files as its simple counterpart.

The new suite passes 254 source-model/Cancun comparisons, two
constructor outcomes, 26 refusals through three commands, 24
inferred/explicit erasure pairs and six accepted boundary forms. Five
compiler mutations are killed with restored passing controls,
including a mutation restoring proof-expression duplication.
`InferredHelpers.asy` uses omitted helper proofs for the counter.

The older helper suite now tests a missing Word argument, since a
missing trailing proof can be inferred. Its argument-order mutation
targets the extended lowering result while retaining its original
witness. All 54 earlier commands, deadlines and markers are unchanged.

All 53 functional legs pass in the default 55-leg battery, which took
824.0 seconds. Both proof gates ran after cache checks matched 35
source files and two pinned dependency revisions. The
[validation archive](validation/2026-09-16-m1-inferred-helpers/)
records each leg, execution and refusal captures, mutation controls,
nesting bounds, gate compatibility and source and artifact hashes.

Timing remains paused. The preserved measurement inputs retain their
existing DENOMINATORS and M0-RATIO failures; the M1 performance bound
and milestone exit remain pending.

## 2026-09-15: inferred arithmetic proofs

The nineteenth M1 slice starts at
`ddeb22c5ce3ea1ceb4a50a7ece3d8ca4a04c1f7e`.
`addLt` and `subLe` accept an omitted proof argument and reuse evidence
for their resolved operands. The existing evidence table supplies
named, anonymous, nested and proof-helper-produced bounds. A missing
match becomes a unit witness whose expected type the kernel checks.
Explicit proof arguments retain their checks, even when valid
alternative evidence exists. Operand rebinding and storage reloads
do not transfer evidence to a new value.

The new suite passes 158 source-model/Cancun execution comparisons,
two constructor outcomes, 24 refusals through three commands and
16 inferred/explicit pairs comparing all five emitted files. Four
compiler mutations are killed with restored passing controls.
`InferredArithmetic.asy` expresses the bounded counter with anonymous
guards and omitted arithmetic proofs.

All 52 functional legs pass in the default 54-leg battery. The run
took 416.1 seconds. Every prior command, deadline and success marker
is unchanged. Both proof gates ran after cache reuse checks matched
35 source files and two pinned dependency revisions. The carried
kernel, surface, proof sources, protocol and backend are unchanged.

DENOMINATORS and M0-RATIO retain their existing failures against
preserved older measurement inputs. Timing remains paused; the M1
performance bound and milestone exit remain pending. The new
[validation archive](validation/2026-09-15-m1-inferred-arithmetic/)
records each leg, execution and refusal captures, mutation controls,
gate compatibility, source hashes and artifact hashes.

### Review round 2026-09-15 (M1 inferred arithmetic)

Kept findings:

| id | severity | title | files |
| --- | --- | --- | --- |
| D-1 | medium | README battery paragraph named the removed | README.md |
|     |        | `--m1-inferred-guards` selector and 53 legs |               |
|     |        | instead of `--m1-inferred-arithmetic` and 54 | |

Refuted: 1 (D-2, dev/M1-INFERRED-GUARDS.md:42, the forward-reference
phrasing matches the repository's own convention in three earlier
slices, so the row states no false fact).
Merged and dropped: 0. No two lens findings named the same file and
defect, and no kept item was cut for the 7-finding cap.

Gate result (log gates-M1IA-1.log):
verdict GREEN-FUNCTIONAL: every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused.
STAGE-M1-LINE: STAGE-M1-INFERRED-ARITHMETIC FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 20:53:52
PASS-COUNT: 52
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=63.9 FAIL M0-RATIO
exit=1 elapsed_ms=198.8
DENOM-FAILED-ROWS: dev/M1-ERRORS.md, dev/M1-PROOFS.md,
dev/M1-SURFACE-MUTATIONS.md, dev/M1-SURFACE.md, dev/contract-test.py,
dev/errors-test.py, dev/gates.sh, dev/m1-emit-test.py,
dev/model-test.py, dev/stage-a-gates.py, emit/contract.ml,
emit/emit.ml, emit/model.ml, emit/recognize.ml, all FAILED.
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13
OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed
control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16
recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK
SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6
mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
witness=increment-success killed control=OK COUNTER-REFERENCE
cases=30 creates=2 mutants=8 value_rejected=5 covered=120
scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING:
14 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 14 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42

DENOMINATORS stayed red on the kept 119-row manifest; it was not
refrozen rows-only, and dev/denominators.json and dev/measurements
were not edited in this review. Rows refreshed by the fix: README.md
and dev/validation/2026-09-15-m1-inferred-arithmetic/SOURCES.json
(refresh-sources.py, entries=949 changed=1 added=0). The M0-RATIO
remeasure is CARRIED to a calm host; it belongs to the close step,
never to a fix round.

gate: GREEN-FUNCTIONAL (every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused:
pass=52 of 54 legs, fail=[DENOMINATORS,M0-RATIO], mutants=true,
marker tails ok=true, timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true)

```
INFERRED-ARITHMETIC cases=158 creates=2 refusals=24 erasure_pairs=16 mutants=4 OK
```

The finders and the builder ran fable/medium on the first attempt, with
an opus/medium fallback when the first attempt returned null. The gate
runner ran opus/medium. The verifiers, the judge and the check stage ran
opus/high. The closer ran sonnet/medium, never opus.

## 2026-09-15: inferred guard evidence

The eighteenth M1 slice starts at
`4649376468d808f908ea6148f8c40ae7e213a7d7`.
Guards accept atomic, compound and named conditions without repeating
their claims in proof annotations. The parser derives the annotation
and lowers to the existing checked proof-guard path. Its internal name
cannot be used by source identifiers. Collected evidence supports
final-state invariant obligations, including components from separate
guards, while preserving the snapshots at which it was established.

The new suite passes 112 source-model/Cancun comparisons, two creation
outcomes, 24 refusals through three commands, 14 inferred/explicit
pairs comparing all five emitted files, six accepted boundary forms
and four compiler mutations with restored passing controls. The
refusals include overwritten and reloaded state, inaccessible internal
evidence, incorrect payloads and expansion and effect-step limits.

All 51 functional legs pass in the default 53-leg battery, including
both proof gates and every previous guard and predicate mutation suite.
The run took 429.3 seconds in total. All 52 prior commands, deadlines
and success markers are unchanged. Proof-cache reuse checks matched
35 source files and two pinned dependency revisions. The carried
kernel, surface, proof sources, protocol and backend are unchanged.

DENOMINATORS and M0-RATIO retain their existing failures against
preserved older inputs. Timing remains paused, and the M1 performance
bound and milestone exit remain pending. The
[validation archive](validation/2026-09-15-m1-inferred-guards/README.md)
records every leg, source and artifact hashes, individual test
captures, mutation witnesses and gate compatibility checks.

### Review round 2026-09-15 (M1 inferred guards)

Lenses: 4. Kept 1, refuted 0, merged and dropped 0.

| id | severity | summary | files |
| --- | --- | --- | --- |
| D-1 | medium | Five added prose rows over 72 columns failed the close gate WIDTH-OVER-72 | README.md, dev/M1-INFERRED-GUARDS.md, dev/M1-INFERRED-GUARD-MUTATIONS.md |

Refuted: 0, no lens finding was refuted at verification.

Merged and dropped: 0, one finding reached the judge, so there was no
duplicate to merge and no item over the cap of 7.

Gate result, log gates-M1IG-1.log:

- Verdict GREEN-FUNCTIONAL: every red row is DENOMINATORS or M0-RATIO,
  the disclosed state of this slice while the timing gate is paused,
  pass=51 of 53 legs, fail=[DENOMINATORS,M0-RATIO], mutants=true,
  marker tails ok=true for INFERRED-GUARDS, NAMED-GUARDS,
  COMPOUND-GUARDS, COMPOUND-INVARIANTS, PREDICATES, PROOF-BUNDLES,
  PROOF-HELPERS, INVARIANTS, PROOF-TERMS, PROOF-GUARDS, timeout legs
  only=false, disclosed reds only=true, wrapper exit ok=true.
- STAGE-M1-LINE: STAGE-M1-INFERRED-GUARDS FAIL
- M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
  ratification
- EXIT 1 | LADDER-WRAPPER-EXIT 0 14:45:01
- PASS-COUNT: 51
- FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=39.0 FAIL M0-RATIO
  exit=1 elapsed_ms=119.1
- DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED
  dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md: FAILED
  dev/contract-test.py: FAILED dev/errors-test.py: FAILED
  dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED dev/model-test.py:
  FAILED dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED
  emit/emit.ml: FAILED emit/model.ml: FAILED emit/recognize.ml: FAILED
- MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS
  killed=13/13 OK
- CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
  cases=66 creates=2 refusals=26 mutants=5 OK
- SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed
  control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16
  recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
- CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
  allocated_bytes=1472 bound=131072 OK
- CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
  CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
- SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK
  SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6
  mutants=8 OK
- DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
  DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
- M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
  counter=30 sources=8 refusals=11 mutants=8 OK
- COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
  witness=increment-success killed control=OK COUNTER-REFERENCE
  cases=30 creates=2 mutants=8 value_rejected=5 covered=120
  scope=reference OK
- DRIVER-TAIL: DRIVER cases=24 OK
- DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING:
  14 computed checksums did NOT match
- M0-RATIO-TAIL: shasum: WARNING: 14 computed checksums did NOT match
- PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
- PROOF-REPORT-LINES: 42

The new leg marker, unchanged by the fix:

```
INFERRED-GUARDS cases=112 creates=2 refusals=24 erasure_pairs=14 boundaries=6 mutants=4 OK
```

DENOMINATORS stayed red on the kept 119 row manifest; it was not
refrozen rows-only. The row refresh belongs to the FINAL tree. Rows a
fix refreshed: README.md, dev/M1-INFERRED-GUARDS.md,
dev/M1-INFERRED-GUARD-MUTATIONS.md,
dev/validation/2026-09-15-m1-inferred-guards/SOURCES.json (refreshed),
dev/validation/2026-09-15-m1-inferred-guards/ARTIFACTS.json
(regenerated). The M0-RATIO remeasure is CARRIED to a calm host;
dev/denominators.json and dev/measurements/ are never edited in this
review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused: pass=51 of 53 legs, fail=[DENOMINATORS,M0-RATIO],
denom rows=[dev/M1-ERRORS.md,dev/M1-PROOFS.md,
dev/M1-SURFACE-MUTATIONS.md,dev/M1-SURFACE.md,dev/contract-test.py,
dev/errors-test.py,dev/gates.sh,dev/m1-emit-test.py,dev/model-test.py,
dev/stage-a-gates.py,emit/contract.ml,emit/emit.ml,emit/model.ml,
emit/recognize.ml], mutants=true, marker tails ok=true (INFERRED-GUARDS
true, NAMED-GUARDS true, COMPOUND-GUARDS true, COMPOUND-INVARIANTS
true, PREDICATES true, PROOF-BUNDLES true, PROOF-HELPERS true,
INVARIANTS true, PROOF-TERMS true, PROOF-GUARDS true), timeout legs
only=false, disclosed reds only=true, wrapper exit ok=true, stage=STAGE-
M1-LINE: STAGE-M1-INFERRED-GUARDS FAIL, m0=M0-LINE: M0-VALIDATION FAIL;
M0-EXIT requires the user commit and ratification, exit=EXIT 1 |
LADDER-WRAPPER-EXIT 0 14:45:01)

The finders and the builder ran fable/medium on the first attempt, with
an opus/medium fallback when the first attempt returned null. The gate
runner ran opus/medium. The verifiers, the judge and the check stage ran
opus/high. The closer ran sonnet/medium, never opus.

## 2026-09-15: named runtime guards

The seventeenth M1 slice starts at
`f8e4206e13fe732dbc13f1f46d93fefcde1cafc2`.
Runtime conditions accept named predicates and expand them through the
same scoped, simultaneous substitution as proof annotations. Expansion
preserves condition order, custom failure payloads, erased evidence
and final-state invariant obligations. Expanded runtime conditions
share a 64-bound budget, with the existing predicate depth and node
limits. Contextual predicate names, including `both`, remain usable.

The new suite passes 96 source-model/Cancun comparisons, two creation
outcomes, 27 refusals through three commands, ten five-file erasure
variants, six accepted boundary forms and four compiler mutations with
restored passing controls. The argument-order mutation uses a direct
definition so nested reversals cannot cancel one another. The existing
proof-guard CLAIM mutation now handles resolved runtime conditions;
its witness and kill criterion are unchanged. The compound suite now
rejects an unknown named runtime predicate in place of the formerly
unsupported named-runtime form. Its count remains 26 refusals.

All 50 functional legs pass in the default 52-leg battery, including
both proof gates and the prior guard and predicate mutation suites.
All 51 previous gate commands, deadlines and success markers are
unchanged. Proof-cache reuse checks 35 source files and two pinned
dependency revisions. The carried kernel, surface, proof sources,
effect protocol and bytecode backend are unchanged.

DENOMINATORS and M0-RATIO retain their existing failures against
preserved older measurement inputs. Timing remains paused; the M1
performance bound and milestone exit remain pending. The
[validation archive](validation/2026-09-15-m1-named-guards/README.md)
contains the battery, individual captures, source hashes and archive
artifact manifest.


### Review round 2026-09-15 (M1 named guards)

A four-lens review of the staged slice kept two low findings. The fix
round corrected both. The stage commit message file
dev/STAGE-M1-NAMED-GUARDS-COMMIT.txt was absent, while every earlier
M1 slice ships one. It is added with the claims of this slice. One
prose row of dev/M1-NAMED-GUARDS.md was 73 columns. That paragraph is
rewrapped with no word changed. No code, suite, count or gate marker
moved, so every printed leg marker stays as measured. No row of
dev/DENOMINATORS.sha256 needed a refresh. The gate result stays 50
functional legs of 52, with DENOMINATORS and M0-RATIO red as staged.

| id | sev | title | files |
| --- | --- | --- | --- |
| D-1 | low | missing commit message file | dev/STAGE-*-COMMIT.txt |
| D-2 | low | prose row over 72 columns | dev/M1-NAMED-GUARDS.md |

Refuted: 0. Merged and dropped: 0; D-1 and D-2 name different files
and different defects, so no duplicate pair existed to merge.

Gate log: gates-M1NG-1.log. Verdict GREEN-FUNCTIONAL: every red row
is DENOMINATORS or M0-RATIO, the disclosed state of this slice while
the timing gate is paused; pass=50 of 52 legs, fail=[DENOMINATORS,
M0-RATIO], denom rows=[dev/M1-ERRORS.md, dev/M1-PROOFS.md,
dev/M1-SURFACE-MUTATIONS.md, dev/M1-SURFACE.md, dev/contract-test.py,
dev/errors-test.py, dev/gates.sh, dev/m1-emit-test.py,
dev/model-test.py, dev/stage-a-gates.py, emit/contract.ml,
emit/emit.ml, emit/model.ml, emit/recognize.ml], mutants=true,
marker tails ok=true, timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true.

STAGE-M1-LINE: STAGE-M1-NAMED-GUARDS FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 09:59:27
PASS-COUNT: 50
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=46.2 FAIL M0-RATIO
exit=1 elapsed_ms=155.3
DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED
dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md: FAILED
dev/contract-test.py: FAILED dev/errors-test.py: FAILED
dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED
dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED
emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED
emit/recognize.ml: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13
OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed
control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16
recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK
SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6
mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
witness=increment-success killed control=OK COUNTER-REFERENCE
cases=30 creates=2 mutants=8 value_rejected=5 covered=120
scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING:
14 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 14 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42

```
NAMED-GUARDS cases=96 creates=2 refusals=27 erasure=10 boundaries=6 mutants=4 OK
```

DENOMINATORS stayed red on the kept 119-row manifest; no rows-only
refreeze ran in this review, and none belongs here. Rows refreshed
by the fix: dev/validation/2026-09-15-m1-named-guards/SOURCES.json
(939 entries after the refresh) and
dev/validation/2026-09-15-m1-named-guards/ARTIFACTS.json (64 rows).
The M0-RATIO remeasure is CARRIED to a calm host; dev/denominators
.json and dev/measurements are never edited in this review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while
the timing gate is paused: pass=50 of 52 legs, fail=[DENOMINATORS,
M0-RATIO], denom rows=[dev/M1-ERRORS.md,dev/M1-PROOFS.md,
dev/M1-SURFACE-MUTATIONS.md,dev/M1-SURFACE.md,dev/contract-test.py,
dev/errors-test.py,dev/gates.sh,dev/m1-emit-test.py,
dev/model-test.py,dev/stage-a-gates.py,emit/contract.ml,
emit/emit.ml,emit/model.ml,emit/recognize.ml], mutants=true, marker
tails ok=true (NAMED-GUARDS true, COMPOUND-GUARDS true,
COMPOUND-INVARIANTS true, PREDICATES true, PROOF-BUNDLES true,
PROOF-HELPERS true, INVARIANTS true, PROOF-TERMS true, PROOF-GUARDS
true), timeout legs only=false, disclosed reds only=true, wrapper
exit ok=true, stage=STAGE-M1-LINE: STAGE-M1-NAMED-GUARDS FAIL,
m0=M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification, exit=EXIT 1 | LADDER-WRAPPER-EXIT 0 09:59:27)

The finders, the builder and the gate runner ran opus/medium. The
verifiers, the judge and the check stage ran opus/high. The closer ran
sonnet/medium. A Fable subagent dies on the [reasoning_extraction]
classifier on this host, so the finder and builder rulings are reported
unmet, and the closer kept the sonnet fallback ruling, never opus.

## 2026-09-14: compound proof guards

Validation and archive checks completed on 2026-09-15.

The sixteenth M1 slice starts at
`09a9b8c3d7f44328a4244da7382c05bbab40a3a9`.
Runtime `both` conditions establish nested proof bundles through checked
atomic guards. Lowering preserves source order and custom failures,
registers the whole bundle and its components for final-state
obligations, and erases the evidence before bytecode emission. Condition
syntax is bounded by depth 32 and 64 atomic checks. `both` remains
contextual, preserving ordinary names and payload parsing.

The new suite passes 88 source-model/Cancun cases, two creation
outcomes, 26 refusals through three commands, seven five-file erasure
variants, seven accepted boundary forms, and four compiler mutations
with restored passing controls. The invariant example checks a named
bundle and rolls back an earlier write on either failed condition.
The prior invariant refusal now describes its mismatched guard shape;
its program and expected rejection are unchanged.

The full default battery has 51 legs. After scoped proof-guard and
predicate rechecks, all 49 functional legs pass, including the carried
42-theorem reports and the source proof checks. The initial proof-guard
run passed its 83 execution cases, 26 refusals and erasure comparisons,
but its CLAIM mutant still constructed the former atomic predicate type.
The mutant now reconstructs a claim from both condition constructors.
Its false-claim witness, all six kill criteria and all restored controls
are unchanged; the full proof-guard suite passes on recheck.
The predicate EXPANSION mutant's short anchor also matched the new
condition budget. Its anchor now selects the expanded-claim budget
specifically, preserving its expanded-node witness and rejection.
Both suites pass sequentially after an earlier concurrent proof-guard
retry hit the unchanged 30-second geth timeout. That retry is retained.
Proof caches were reused after verifying 35 source files and two pinned
dependency revisions. All 50 prior gate commands, deadlines and success
markers are unchanged. The carried kernel, surface, proof sources,
effect protocol and bytecode backend are unchanged.

DENOMINATORS and M0-RATIO retain their failures against the preserved
older measurement inputs. Timing remains paused; the M1 performance
bound and milestone exit remain pending. The
[validation archive](validation/2026-09-14-m1-compound-guards/README.md)
contains the full battery, individual captures, source hashes, gate
comparison and an archive artifact manifest.

### Review round 2026-09-15 (M1 compound guards)

A review pass over the staged slice fixed two low documentation
findings in dev/M1-COMPOUND-GUARDS.md. The gate battery row that
names dev/gates.sh was 74 columns; it is rewrapped to 72 columns
with the same words. The validation bullet for the mutation
controls now links dev/M1-COMPOUND-GUARD-MUTATIONS.md, which had
no referrer outside the archive hash list.

No compiler file, gate script, gate marker or count changed, so
every leg row and every printed marker is unchanged. The archive
source hashes are refreshed for the edited document, and the
archive artifact manifest is rebuilt from the refreshed files.
The baseline ladder and the fix ladder both report 49 of 51 legs
passing, with DENOMINATORS and M0-RATIO red as disclosed.

Kept findings from the review:

file: dev/M1-COMPOUND-GUARDS.md

| id | sev | one line |
| --- | --- | --- |
| D-1 | low | prose row over 72 columns, rewrapped |
| D-2 | low | orphan mutation doc, now linked |

Refuted: 1 (A-1, coverage gap confirmed harmless by a probe rebuild
that pinned the shape check to the resolved type, not to a claim
name; dev/compound-guard-test.py:160 stands as written).

Merged and dropped: 0. No two findings named the same defect and
none was cut; D-3 stays a ruled archive convention, not a fix.

Gate result, log gates-M1CG-1.log:
verdict GREEN-FUNCTIONAL: every red row is DENOMINATORS or
M0-RATIO, the disclosed state of this slice while the timing gate
is paused: pass=49 of 51 legs, fail=[DENOMINATORS,M0-RATIO],
marker tails ok=true, timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true.
STAGE-M1-LINE: STAGE-M1-COMPOUND-GUARDS FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 06:31:52
PASS-COUNT: 49
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=62.5 FAIL M0-RATIO
exit=1 elapsed_ms=222.6
DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md:
FAILED dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md:
FAILED dev/contract-test.py: FAILED dev/errors-test.py: FAILED
dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED dev/model-test.py:
FAILED dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED
emit/emit.ml: FAILED emit/model.ml: FAILED emit/recognize.ml:
FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS
killed=13/13 OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK
CUSTOM-ERRORS cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed
control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16
recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK
SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28
refusals=6 mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
witness=increment-success killed control=OK COUNTER-REFERENCE
cases=30 creates=2 mutants=8 value_rejected=5 covered=120
scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING:
14 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 14 computed checksums did NOT
match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42

```
COMPOUND-GUARDS cases=88 creates=2 refusals=26 erasure=7 boundaries=7 mutants=4 OK
```

DENOMINATORS stays red on the kept 119-row manifest; no rows-only
refreeze ran in this round, and no FINAL tree exists yet. Rows
refreshed by the fix: dev/M1-COMPOUND-GUARDS.md (lines 69 and 71).
dev/ASSAY-M1-BUILD-LOG.md gained this block. The archive
SOURCES.json and ARTIFACTS.json were refreshed to match. The
M0-RATIO remeasure is CARRIED to a calm host; dev/denominators.json
and dev/measurements are unedited in this review.

gate: GREEN-FUNCTIONAL (every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused:
pass=49 of 51 legs, fail=[DENOMINATORS,M0-RATIO], mutants=true,
marker tails ok=true, timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true, stage=STAGE-M1-LINE:
STAGE-M1-COMPOUND-GUARDS FAIL, m0=M0-LINE: M0-VALIDATION FAIL;
M0-EXIT requires the user commit and ratification, exit=EXIT 1 |
LADDER-WRAPPER-EXIT 0 06:31:52)

The finders, the builder and the gate runner ran opus/medium. The
verifiers, the judge and the check stage ran opus/high. The closer
ran sonnet/medium. A Fable subagent dies on the [reasoning_extraction]
classifier on this host, so the finder and builder rulings are
reported unmet, and the closer kept the sonnet fallback ruling,
never opus.

## 2026-09-14: compound storage invariants

The fifteenth M1 slice starts at
`012e7312f2c02958ec85f5a6ad09e60f8d34b30e`.
Storage invariants now accept nested products and named predicates that
expand to products. Lowering uses matching bundle evidence or builds a
pair from checked components. The kernel checks the complete obligation
against final tracked values at construction and successful writes.
Both branches participate in field tracking, including unused supplied
predicate arguments. The carried kernel and surface are unchanged.

The new suite covers 64 source-model/Cancun execution cases, two
creation outcomes, 24 refused programs through three commands, eight
five-file erasure variants, ten accepted boundary forms and four
compiler mutations with restored controls. The new example collects
guard proofs through a named helper. The prior predicate witness now
rejects a wrongly ordered bundle instead of rejecting all bundles.

The default battery gains `COMPOUND-INVARIANTS`, bringing it to 50 legs.
Timing remains paused. Frozen denominator and measurement inputs remain
preserved, and no current performance result or milestone exit is
claimed. The [validation archive][compound]
records all 50 legs. The initial run passes 47 and fails DENOMINATORS,
M0-RATIO and AXIOMS. AXIOMS initially lacks its preprovisioned cache.
After verifying all 28 proof files and both dependency revisions, cache
reuse and a scoped recheck pass all 42 theorem reports and controls.
All 48 functional legs pass; the two preserved measurement failures
remain visible. No existing deadline or passing marker was weakened.

[compound]: validation/2026-09-14-m1-compound-invariants/README.md
### Review round 2026-09-14 (M1 compound invariants)

Review pass 1 (2026-09-14) fixed 2 findings, both low. No gate count,
deadline, frozen bound or measurement moved.

C-1: the archive now ships `ARTIFACTS.json`, the SHA-256 manifest of
every other archive file, computed last, and its README names it. The
prior M1 archives since 2026-09-11 carry the same file. No leg reads
it; no gate count moved.

D-1: four prose rows over 72 columns were rewrapped, `README.md:227`,
`dev/M1-COMPOUND-INVARIANTS.md:57` and `dev/M1-INVARIANTS.md:27` and
`:33`. No word or number changed.

### Closer bookkeeping

Kept findings, both fixed:

| id | sev | one line | files |
| --- | --- | --- | --- |
| C-1 | low | archive ships ARTIFACTS.json, named in its README | dev/validation/2026-09-14-m1-compound-invariants/ARTIFACTS.json, dev/validation/2026-09-14-m1-compound-invariants/README.md |
| D-1 | low | four prose rows over 72 columns rewrapped | README.md, dev/M1-COMPOUND-INVARIANTS.md, dev/M1-INVARIANTS.md |

Refuted: 0.
Merged and dropped: 0.

Gate log:
```
/Users/oobi/Documents/assay-m1-compound-invariants-review/gates-M1CI-1.log
```

```
COMPOUND-INVARIANTS cases=64 creates=2 refusals=24 erasure=8 boundaries=10 mutants=4 OK
```

LOAD-AT-RUN 43, GATES-START 21:17:04, GATES-END 21:35:21, 48 PASS,
FAIL only DENOMINATORS and M0-RATIO (timing paused, by design),
PORCELAIN 81, UNSTAGED 0.

## 2026-09-14: named predicates

The fourteenth M1 slice starts at
`21ee13539340b7bebf8e43c140c60898186d585a`.
It adds parameterized predicates that expand to the existing bound and
bundle claims. Helpers, annotations, guards and storage invariants can
use the names. Every definition and supplied Word argument is validated,
including unused ones. Substitution preserves scope and argument order.
Recursive and forward predicate dependencies are refused. Expansion
has a depth limit of 32 and a shared budget of 4096 visited nodes.

Predicates add no core declaration, axiom or runtime object. The kernel
continues to check every proof before erasure. Guards and invariants
require one atomic expanded bound. Existing snapshot matching prevents
old evidence from justifying an overwritten field or a fresh load.
The carried kernel, surface, proof protocol, backend, assembler and
Lean sources are unchanged.

The new gate passes 72 source-model/Cancun cases, two creation outcomes,
44 refusals through check/emit/run, seven five-file erasure comparisons,
12 accepted boundaries and four mutations with passing restored
controls. Guard and constructor mutation anchors follow the changed
function calls without changing their witnesses, counts or outcomes.

Validation ran in `/Users/oobi/Documents/gpt1/assay-m1-predicates`.
All 47 functional checks passed after scoped rechecks. The initial
49-leg battery recorded a geth timeout in M1-EMISSION and a Lean
timeout in SOURCE-PROOFS. Both passed on recheck with their original
commands and deadlines. The initial and recheck results are preserved.
DENOMINATORS and M0-RATIO failed against the preserved
manifest and measurement. Timing remains paused. No full battery pass
or milestone exit is claimed.
The proof cache check matched 35 source files and two pinned
dependencies before reuse, and both proof gates subsequently ran.

Trusted lines are kernel 3997/4000, emitter 1600/1800 and total new code
2018/3550. `validation/2026-09-14-m1-predicates/` retains the complete
battery, feature captures, controls, hashes and source identities.
`M1-PREDICATES.md` specifies scope, expansion and erasure. Symbolic
arithmetic lemmas and the M1 performance bound remain open.

### Review round 2026-09-14 (M1 predicates)

Review pass 1 (2026-09-14) fixed 2 findings, both low. No gate count,
deadline, frozen bound or measurement moved.

A-1: the expansion LIMIT refusal now names the claim site instead of
the sentinel line 1, column 1 for every Bound or Both node. `resolve`
now carries an enclosing token, seeded from the outermost claim's first
Named token and from each expansion's Named token, so the refusal
names the claim site. The sentinel stays for a claim tree with no
Named node. Diagnostic only; no emitted byte changed, no gate count
moved.

D-1: two prose rows over 72 columns were rewrapped,
`dev/M1-PREDICATES.md:91` and the Timing paragraph in
`dev/STAGE-M1-PREDICATES-COMMIT.txt:11`. No word or number changed.

### Closer bookkeeping

Kept findings, both fixed:

| id | sev | one line | files |
| --- | --- | --- | --- |
| A-1 | low | expansion LIMIT refusal named the sentinel line 1, column 1 for every Bound or Both node | emit/contract.ml |
| D-1 | low | two prose rows exceeded the 72-column width | dev/M1-PREDICATES.md, dev/STAGE-M1-PREDICATES-COMMIT.txt |

Refuted: 1 (D-2, the cited sentence is true as written and the
grammar-widening premise is contradicted by the prior round).
Merged and dropped: 1 (D-1-archive-rows, merged into D-1 with the
scope cut; the dev/validation archive rows are dropped, matching the
committed 2026-09-14-m1-proof-bundles archive).

Gate log:
/Users/oobi/Documents/assay-m1-predicates-review/gates-baseline.log

```
PREDICATES cases=72 creates=2 refusals=44 erasure=7 boundaries=12 mutants=4 OK
```

LOAD-AT-RUN 42, GATES-START 15:46:10, GATES-END 16:01:51, 47 PASS,
FAIL only DENOMINATORS and M0-RATIO (timing paused, by design),
PORCELAIN 85, UNSTAGED 0.

## 2026-09-14: checked proof bundles

The thirteenth M1 slice starts at
`0abfe27e4b38138577737773b49c4e93a3370c80`.
It adds `Both` claims, proof pairs and projections. Helpers can accept,
return and compose multiple bounds. Named entry-local bundles supply
their checked component evidence to final storage-invariant obligations.
The existing kernel checks every component, annotation, helper argument
and unused binding before erasure. Guards still establish atomic bounds.

The lowering uses products in Prop, tuples and existing projections. It
records resolved proof types and instantiates helper conclusions with
their supplied Word arguments. Claim syntax has a 32-level nesting
limit; the existing 128-level proof nesting limit also covers pairs and
projections. The carried kernel, surface, proof protocol, arithmetic,
backend, assembler and Lean sources are unchanged. No axiom is added.

The new gate passes 102 source-model/Cancun cases, two creation
outcomes, 41 refusals through check/emit/run, eight variants with
identical five-file outputs and eleven accepted boundary programs. An
additional refused boundary checks the existing proof-depth limit. Four
mutations are killed with passing restored controls. Prior proof-term
and helper mutation anchors follow the new representation without
changing their witnesses. Contextual proof operations preserve existing
Word, proof, field, argument and helper names, with regression cases for
each role.

Validation ran in `/Users/oobi/Documents/gpt1/assay-m1-proof-bundles`.
All 46 functional legs of the 48-leg battery passed. DENOMINATORS and
M0-RATIO failed against the preserved manifest and old measurement.
Timing remains paused. No full battery pass, performance result or
milestone exit is claimed. Proof cache reuse first verified 35 source
files and two pinned dependencies, then both proof gates ran. Existing
gate counts, deadlines and trusted-line allowances are unchanged.

Trusted lines are kernel 3997/4000, emitter 1524/1800 and total new code
1942/3550. `validation/2026-09-14-m1-proof-bundles/` retains the
battery, new captures, mutation controls, output hashes and exact source
identities. `M1-PROOF-BUNDLES.md` specifies the grammar, inference and
erasure rules. Symbolic arithmetic lemmas and the M1 performance bound
remain open.

### Review round 2026-09-14 (M1 proof bundles)

Review pass 1 fixed four low findings. No gate count, deadline, frozen
bound or measurement moved.

A-1: `M1-PROOF-BUNDLES.md` now states that a helper takes precedence
over a built-in operation from its declaration point onward, and that a
helper body sees only the helpers above it. One accepted boundary form
declares a helper named `pair` after a helper body that uses the
built-in reading.

B-1: the accepted boundary form that keeps `pair` as a storage field and
`first` and `second` as custom-error arguments now builds and projects a
bundle in the same entry. The form count stays eleven, so the
`PROOF-BUNDLES` gate line keeps `boundaries=11` and every other count.

D-1: fourteen new prose lines in `README.md`, this log,
`M1-PROOF-BUNDLES.md` and `STAGE-M1-PROOF-BUNDLES-COMMIT.txt` were
rewrapped to 72 columns. No word or number changed.

D-2: `M1-PROOF-HELPERS.md` and `M1-SURFACE.md` gained one cross-link
each to the proof bundle slice. Both paths join the staged set.

`dev/DENOMINATORS.sha256` is not refreshed here. The rows for
`dev/M1-PROOF-BUNDLES.md`, `dev/M1-PROOF-HELPERS.md`,
`dev/M1-SURFACE.md` and `dev/proof-bundle-test.py` need a refresh on the
final tree, with the rows-only recipe. DENOMINATORS and M0-RATIO stay
red while timing is paused.

### Closer bookkeeping

Kept findings, all fixed:

| id | sev | one line | files |
| --- | --- | --- | --- |
| A-1 | low | forward helper named pair, first or second silently reinterpreted as the built-in | dev/M1-PROOF-BUNDLES.md, dev/proof-bundle-test.py |
| B-1 | low | no accepted boundary form mixed a Word-role pair/first/second name with a live bundle | dev/proof-bundle-test.py, dev/M1-PROOF-BUNDLES.md |
| D-1 | low | 14 new prose lines exceeded the 72-column width the prior round fixed | README.md, dev/ASSAY-M1-BUILD-LOG.md, dev/M1-PROOF-BUNDLES.md, dev/STAGE-M1-PROOF-BUNDLES-COMMIT.txt |
| D-2 | low | claim grammar widened this slice, no cross-link paragraph in the carried docs | dev/M1-PROOF-HELPERS.md, dev/M1-SURFACE.md |

Refuted: 0. Merged and dropped: 0 (no merge reason applies, four
findings touch four different files and four different defects).

Gate log:
/Users/oobi/Documents/assay-m1-proof-bundles-review/gates-M1PB-1.log

STAGE-M1-LINE: STAGE-M1-PROOF-BUNDLES FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 10:12:24
PASS-COUNT: 46
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=61.8 FAIL M0-RATIO
exit=1 elapsed_ms=144.7
DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED
dev/M1-SURFACE-MUTATIONS.md: FAILED dev/M1-SURFACE.md: FAILED
dev/contract-test.py: FAILED dev/gates.sh: FAILED dev/m1-emit-test.py:
FAILED dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED
emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED
emit/recognize.ml: FAILED

MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK
SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7
invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true
allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=8/8 controls=8 OK
CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL
counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK
DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR
witness=increment-success killed control=OK COUNTER-REFERENCE cases=30
creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING: 13
computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 13 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42

DENOMINATORS stayed red on the kept 119-row manifest; it was not
refrozen rows-only in this review round. Fixes refreshed these rows:
dev/M1-PROOF-BUNDLES.md, dev/M1-PROOF-HELPERS.md, dev/M1-SURFACE.md,
dev/proof-bundle-test.py. The M0-RATIO remeasure is CARRIED to a calm
host; dev/denominators.json and dev/measurements are never edited in
this review.

```
PROOF-BUNDLES cases=102 creates=2 refusals=41 erasure=8 boundaries=11 mutants=4 OK
```

The closing ladder log is
/Users/oobi/Documents/assay-m1-proof-bundles-review/gates-final.log,
expected GREEN-FUNCTIONAL (46 PASS, FAIL rows DENOMINATORS and
M0-RATIO only under the timing pause). verify-final reports bad=0.

gate: GREEN-FUNCTIONAL (every red row is DENOMINATORS or M0-RATIO, the
disclosed state of this slice while the timing gate is paused: pass=46
of 48 legs, fail=[DENOMINATORS,M0-RATIO], denom rows=[dev/M1-ERRORS.md,
dev/M1-PROOFS.md, dev/M1-SURFACE-MUTATIONS.md, dev/M1-SURFACE.md,
dev/contract-test.py, dev/gates.sh, dev/m1-emit-test.py,
dev/model-test.py, dev/stage-a-gates.py, emit/contract.ml, emit/emit.ml,
emit/model.ml, emit/recognize.ml], mutants=true, marker tails ok=true
(PROOF-BUNDLES true, PROOF-HELPERS true, INVARIANTS true, PROOF-TERMS
true, PROOF-GUARDS true), timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true, stage=STAGE-M1-LINE:
STAGE-M1-PROOF-BUNDLES FAIL, m0=M0-LINE: M0-VALIDATION FAIL; M0-EXIT
requires the user commit and ratification, exit=EXIT 1 |
LADDER-WRAPPER-EXIT 0 10:12:24)

Staffing: finders ran fable/medium with one opus/medium fallback. The
builder and the closer ran opus/medium. A Fable subagent dies on the
[reasoning_extraction] classifier on this host, and a death in fix or
close forces a resume, so the builder and the closer keep the opus pin
and both rulings are reported unmet.

## 2026-09-13: reusable proof helpers

The twelfth slice starts at `9b5c46ece4fd792ca46ee8d4a0abe8cc872fb2ee`.
It adds named proof helpers with dependent Word and proof arguments.
Helpers can call earlier helpers, and entries can use any helper in
arithmetic proofs, erased bindings and final invariant obligations.
Every helper declaration is checked, including unused declarations.

The source requires zero parameters and permits only pure proof bodies
and proof-position calls. The carried kernel checks top-level functions
in runtime mode, so lowering uses ordinary core binders within helper
definitions. Entry proof applications and bindings erase the entire
call. The existing kernel checks generic helper bodies, instantiated
argument claims, annotations and unused evidence before erasure.

There are at most 32 helpers and 16 parameters or arguments per helper.
The existing 128-level proof nesting bound applies to calls. Recursion,
forward helper references, runtime use, role confusion and name
collisions are refused. No kernel, carried surface, backend, arithmetic,
assembler, proof protocol or Lean source changes are required.

The new example emits 387 runtime bytes and 417 creation bytes. The new
gate passes 104 source-model/Cancun cases, both creation outcomes, and
50 refusals through check, emit and run. Six guarded variants and seven
closed variants retain equal five-file outputs. All seven closed
variants execute, and six accepted boundary programs compile. Four
compiler mutations are killed with restored controls. The existing proof
annotation mutation follows its moved function and keeps its witness.

Validation ran in `/Users/oobi/Documents/gpt1/assay-m1-proof-helpers`.
The complete 47-leg battery passed 44 functional legs. SOURCE-PROOFS hit
its existing 180-second mutation build timeout, then passed a scoped
rerun with the same limits. All 45 functional legs are validated across
those runs. DENOMINATORS and M0-RATIO failed against the preserved
manifest and measurement. Both proof runs are retained in the archive.
Timing remains paused. No full battery pass or fresh performance verdict
is claimed. The proof gates ran after cache reuse checked 35 source
files and two pinned dependencies. No existing gate count, deadline or
trusted line allowance was reduced or increased.

Trusted lines are kernel 3997/4000, emitter 1468/1800 and total new code
1886/3550. `validation/2026-09-13-m1-proof-helpers/` retains the
battery, new captures, mutation controls, erasure hashes and source
identities. The working copy occupied 77 MiB before proof cache reuse,
and the two verified proof caches occupied 128 MiB. These bounded copies
and local tests used the documented disk-floor exception with about 29
GiB free.

The M1 performance bound remains open. These bounded helpers do not add
induction, new surface predicates, automatic preservation lemmas,
epoch-indexed invariants, or a new compiler theorem. See
`M1-PROOF-HELPERS.md` for the accepted grammar and core lowering
contract.

### Review round 2026-09-13 (M1 proof helpers)

A review of this slice kept five findings. All five are fixed here.
Round one fixed four. Round two applied the fifth, which changes the
compiler, because that manifest row is already stale.

- `README.md` now names `STAGE-M1-PROOF-HELPERS OK` and 47 legs, and
  records the helper gate counts: 104 cases, 50 refusals, seven closed
  erasure variants and four mutations with controls.
- `M1-SURFACE.md` records `,` as a punctuation token of the surface
  beside the `.` rule, with the classes that refuse it elsewhere. The
  exit code paragraph is whole again, and the helper cross-link is last
  in the chronological slice chain.
- The commit draft `STAGE-M1-PROOF-HELPERS-COMMIT.txt` wraps at 72
  columns, the width of the three prior slice drafts. Every number is
  unchanged.
- The new prose of this section and of `M1-PROOF-HELPERS.md` wraps at
  72 columns. The mutation ledger tables keep their existing width.
- A comma with no argument after it inside a proof helper call was
  refused as SURFACE_NAME, where the neighbouring missing comma is
  refused as SURFACE_SYNTAX. The argument loop of `emit/contract.ml`
  now refuses a leading, a double and a trailing comma directly with
  the message `expected a proof helper argument after ,` or
  `expected a proof helper argument before ,`, and the
  `trailing-comma` case of `proof-helper-test.py` reads
  `SURFACE_SYNTAX`. No new case is added, so the refusal count holds.

No gate count, printed leg marker, trusted-line bound, gate deadline or
frozen measurement input moved.
`PROOF-HELPERS cases=104 creates=2 refusals=50 erasure=7 mutants=4 OK`,
`PROOF-TERMS cases=98 creates=2 refusals=25 erasure=5 mutants=4 OK`,
`INVARIANTS cases=52 creates=2 refusals=30 erasure=4 mutants=4 OK`,
`PROOF-GUARDS cases=83 creates=2 refusals=26 erasure=3 mutants=6 OK` and
`NULLARY-ENTRIES cases=53 creates=2 refusals=4 mutants=3 OK` all hold
after the compiler change, with a build of 0 errors and 0 warnings.
`dev/DENOMINATORS.sha256` is
unchanged, so the timing freeze of the parent commit stays in place;
the `emit/contract.ml` and `dev/M1-SURFACE.md` rows of that manifest
were already stale before this round. DENOMINATORS and M0-RATIO stay
failed against the preserved manifest and measurement, as disclosed
above.

| id | sev | one line | files |
| --- | --- | --- | --- |
| D-1 | medium | stale gate sentence, no helper counts | README.md |
| A-1 | low | comma error reported as identifier error | emit/contract.ml |
| D-2 | low | commit body lines over 72 columns | dev/STAGE-M1-PROOF-HELPERS-COMMIT.txt |
| D-3 | low | new prose lines over 72 columns | dev/ASSAY-M1-BUILD-LOG.md, dev/M1-PROOF-HELPERS.md |
| D-4 | low | cross-link split a paragraph, no diagnostic class named | dev/M1-SURFACE.md |

Three findings were refuted (A-2, C-1, C-2): reasons are recorded in
review-M1PH-report.md and are not repeated here. Zero findings were
merged and zero were dropped; the judge cap of seven was not reached.

Closing gate log is
`/Users/oobi/Documents/assay-m1-proof-helpers-review/gates-M1PH-2.log`.
STAGE-M1-LINE: STAGE-M1-PROOF-HELPERS FAIL. M0-LINE: M0-VALIDATION
FAIL; M0-EXIT requires the user commit and ratification. EXIT 1.
PASS-COUNT: 45. FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=51.9
FAIL M0-RATIO exit=1 elapsed_ms=159.8. DENOM-FAILED-ROWS: dev/M1-ERRORS.md:
FAILED dev/M1-PROOFS.md: FAILED dev/M1-SURFACE-MUTATIONS.md: FAILED
dev/M1-SURFACE.md: FAILED dev/contract-test.py: FAILED dev/gates.sh:
FAILED dev/m1-emit-test.py: FAILED dev/model-test.py: FAILED
dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED emit/emit.ml:
FAILED emit/model.ml: FAILED emit/recognize.ml: FAILED. MUTANTS-TAIL:
MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK.
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS
cases=66 creates=2 refusals=26 mutants=5 OK. SOURCE-PROOFS-TAIL:
SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS
theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13
mutants=6 controls=4 OK. CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3
identity=true allocated_bytes=1472 bound=131072 OK. CONTRACT-SURFACE-TAIL:
SURFACE-MUTANTS killed=8/8 controls=8 OK CONTRACT-SURFACE counter=30
variants=14 refusals=36 mutants=8 OK. SOURCE-MODEL-TAIL: MODEL-MUTANTS
killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11
invalid=28 refusals=6 mutants=8 OK. DIFF-EXECUTOR-TAIL: DIFF-CHECKS
killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24
OK. M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION
counter=30 sources=8 refusals=11 mutants=8 OK. COUNTER-REFERENCE-TAIL:
COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK
COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5
covered=120 scope=reference OK. DRIVER-TAIL: DRIVER cases=24 OK.
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING: 13
computed checksums did NOT match. M0-RATIO-TAIL: shasum: WARNING: 13
computed checksums did NOT match. PROOF-BUILD-TAIL: OK lake: 0 errors,
0 sorries, 0 warnings. PROOF-REPORT-LINES: 42.

DENOMINATORS stays red on the kept 119-row manifest; no rows-only
refreeze happened in this review, and none belongs here. Fix round 1
refreshed SOURCES.json entries=914 changed=5; fix round 2 refreshed
entries=914 changed=3 for dev/ASSAY-M1-BUILD-LOG.md,
dev/proof-helper-test.py and emit/contract.ml. `dev/denominators.json`
and `dev/measurements/` were not touched. The M0-RATIO remeasure is
CARRIED to a calm host.

gate: GREEN-FUNCTIONAL (every red row is DENOMINATORS or M0-RATIO,
the disclosed state of this slice while the timing gate is paused:
pass=45 of 47 legs, fail=[DENOMINATORS,M0-RATIO], denom rows=[dev/M1-ERRORS.md,
dev/M1-PROOFS.md,dev/M1-SURFACE-MUTATIONS.md,dev/M1-SURFACE.md,
dev/contract-test.py,dev/gates.sh,dev/m1-emit-test.py,dev/model-test.py,
dev/stage-a-gates.py,emit/contract.ml,emit/emit.ml,emit/model.ml,
emit/recognize.ml], mutants=true, marker tails ok=true (PROOF-HELPERS
true, INVARIANTS true, PROOF-TERMS true, PROOF-GUARDS true), timeout
legs only=false, disclosed reds only=true, wrapper exit ok=true,
stage=STAGE-M1-LINE: STAGE-M1-PROOF-HELPERS FAIL, m0=M0-LINE:
M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification,
exit=EXIT 1 | LADDER-WRAPPER-EXIT 0 02:05:52).

Finders ran fable/medium with one opus/medium fallback. The builder
and the closer ran opus/medium: a Fable subagent dies on the
[reasoning_extraction] classifier on this host, and a death in fix or
close forces a resume, so both stages keep the opus pin. Both the
builder and the closer tier rulings are reported unmet.

## 2026-09-13: storage invariant declarations

The eleventh slice starts at `b35c17d00c17b8864475d9a65b282d2ae5567b4c`.
It adds `invariant NAME (s : State) : Prop := CLAIM` declarations for
ordering and addition bounds over storage fields and Word literals.
Construction checks every claim against zero storage followed by its
literal stores. Successful entry returns check affected invariants
against the final loaded or stored values. Unchanged fields preserve
their claims, and reverting paths retain the existing rollback behavior.

The compiler uses matching guard or supplied proofs, or a unit proof
for a closed true claim. Each obligation remains in the checked core
until erasure. Constructor obligations live in its type annotation,
which keeps proof closures out of the closed Eff backend. General
preservation lemmas are not inferred. The carried kernel, surface,
proof protocol, runtime arithmetic, assembler and Lean sources are
unchanged. No new axiom or compiler theorem is claimed.

`CounterInvariant.asy` states the counter bound and proves both update
paths. It emits 465 runtime bytes and 496 creation bytes. The new gate
passes 52 source-model/Cancun cases, both constructor outcomes and 30
refusals through check, emit and run. It covers sequential calls,
overflow, underflow, invalid prestates, rollback, stale storage proofs,
multiple claims and accepted nesting/member boundaries. Four variants
produce identical five-file outputs, including the version with the
declaration removed. Four compiler mutations are detected, each with
a restored control.

Validation ran in `/Users/oobi/Documents/gpt1/assay-m1-invariants`.
The complete 46-leg battery passed 43 legs. CONTRACT-SURFACE stopped
at its old STORE mutation anchor. The store key was renamed, and the
Word binding expression now appears at separate load and local binding
sites. Its STORE and SHADOW anchors were updated to the corresponding
sites without changing the witnesses or expected outcomes. The complete
CONTRACT-SURFACE gate then passed: 30 counter cases, 13 variants, 36
refusals and all seven mutations with restored controls. The review
round below adds one variant and one mutation to that gate. The compiler
was unchanged, so the other functional legs retain their passing runs.

All 44 functional legs are validated across the full battery and that
scoped rerun. DENOMINATORS and M0-RATIO remain failed against the
preserved manifest and measurement. Timing is still paused. No complete
battery pass or fresh performance verdict is claimed. All existing
proof gates pass, including 11 Lean theorems, 226 arithmetic cases and
six proof-model mutations. Cache reuse matched 35 source files and two
pinned dependencies before the proof gates ran.

Trusted lines are kernel 3997/4000, emitter 1379/1800 and total new code
1797/3550. No trusted-line bound, gate deadline or prior case count was
changed. `validation/2026-09-13-m1-invariants/` retains the original
battery, the corrected gate, the exact harness correction, new execution
captures, erasure hashes, mutation controls and source identities. The
M1 performance bound remains open; broader proof functions and
epoch-indexed invariants remain outside this bounded M1 slice.

### Review round 2026-09-13 (M1 invariants)

A review of this slice kept six findings. All six are fixed here.

- `invariant` is a reserved word of the surface. A field, entry, error or
  argument of that name is refused with SURFACE_NAME. `M1-INVARIANTS.md`
  records the reservation, and the new `reserved-word` case checks it.
- The lexer returns `.` as a token everywhere, so a stray projection outside
  an invariant claim is refused with SURFACE_SYNTAX, not SURFACE_TOKEN.
  `M1-SURFACE.md` records the token, and the new `stray-dot` case checks it.
- The contract surface gate gains the `shadow-load` variant and the
  SHADOW-LOAD mutation, which anchors the separate load binding site that
  this slice split out of the shared binding helper.
- The invariant chain classifies overflow, underflow and bound reverts, runs
  three more steps, and reads the storage of each executed step instead of a
  derived Python tuple.
- `README.md` documents the `CounterInvariant.asy` emit command.
- `M1-PROOF-TERMS.md`, `M1-ERRORS.md` and `M1-PROOFS.md` scope the sentence
  about unfinished invariant declarations to their own slice.

The gates now print
`INVARIANTS cases=52 creates=2 refusals=30 erasure=4 mutants=4 OK` and
`CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK`.
The review ladder passed the 44 functional legs. DENOMINATORS and M0-RATIO
stay failed against the preserved manifest and measurement, as disclosed
above. `validation/2026-09-13-m1-invariants/INVARIANTS.log`,
`CONTRACT-SURFACE.log` and `invariants/` hold the review ladder run, and
`GATES.log` keeps the first complete battery. `dev/DENOMINATORS.sha256` is
unchanged, so the timing freeze of the parent commit stays in place. No
trusted-line bound, gate deadline or frozen measurement input moved.

## 2026-09-13: supplied surface proof terms and erased bindings

The tenth slice starts at `ccf78afcbe76f11234f82e36fa553fecd6ff2ef7`.
The contract surface accepts closed unit proofs, explicit annotations,
erased proof aliases and bindings inside proof expressions. `addLt` and
`subLe` accept these expressions directly. Every declared claim remains
in the checked core, including unused false claims. Fresh core names
preserve lexical scope and shadowing. The existing proof protocol,
kernel, carried surface, runtime arithmetic and Lean sources are
unchanged.

`examples/ProofTerms.asy` demonstrates closed addition and a guarded
subtraction with proof aliases, typed failure data and rollback. It
emits 246 runtime bytes and 274 creation bytes. The supplied proof gate
passes 98 source-model/Cancun cases and both constructor outcomes. Its
25 refusal cases run through check, emit and run and require failure
before output creation. Cases include false annotations, unused false
bindings, escaped names, Word/proof shadowing, snapshot reloads and
proof nesting above 128. Positive cases include literal aliases,
snapshot reuse and nesting at 128.

Five closed proof shapes produce identical five-file outputs. Three
guard-derived proof shapes for each arithmetic operation also preserve
all five files. Supplied arithmetic evidence removes one conditional
jump compared with the checked Result form. Four compiler mutations are
killed by their named refusal witnesses, with restored controls. The
earlier guard CLAIM mutation is anchored to its Prove branch now that
other branches also resolve claims; all six existing mutations pass.

Validation ran in `/Users/oobi/Documents/gpt1/assay-m1-proof-terms`. The
complete 45-leg battery passes 43 legs. Its only failures are
DENOMINATORS and M0-RATIO, against the preserved manifest and
measurement from the preceding compiler. Timing remains paused, and
neither its window nor its bounds were changed. No complete battery pass
or fresh performance verdict is claimed. All functional gates pass,
including the existing 11 Lean theorems, 226 arithmetic cases and six
proof-model mutations. Cached Lean artifacts were copied only after
matching 35 source files and two pinned dependencies; the full proof
gates still ran.

Trusted lines are kernel 3997/4000, emitter 1322/1800 and total new code
1740/3550. No trusted-line limit, test deadline or earlier case count
changed. Evidence under `validation/2026-09-13-m1-proof-terms/` retains
the complete battery, new execution and refusal captures, erasure
hashes, mutation controls and final source/archive identities. Invariant
declarations and the M1 performance bound remain unfinished. General
proof functions and user-defined surface predicates remain outside the
bounded proof expression grammar documented in `M1-PROOF-TERMS.md`.

### Review round 2026-09-13 (M1 proof terms)

A review pass read the staged slice, kept three findings, and the fix
round fixed all three. The erasure check now prints the counts it
measured, the archive holds one run only, and the new section wraps at
72 columns.

Kept findings:

| id | severity | one line | files |
| --- | --- | --- | --- |
| B-1 | medium | `TERM-ERASURE` and the run summary printed literal variant counts, so a deleted erasure variant kept the leg green | dev/proof-term-test.py |
| C-1 | medium | The archived `proof-terms/` mixed two runs: 14 captures of an earlier script version inflated the file and artifact counts | dev/proof-term-test.py, dev/validation/2026-09-13-m1-proof-terms/README.md, dev/validation/2026-09-13-m1-proof-terms/ARTIFACTS.json, dev/validation/2026-09-13-m1-proof-terms/proof-terms/ |
| D-1 | low | The new build-log section had 10 prose lines above 72 columns | dev/ASSAY-M1-BUILD-LOG.md |

Refuted: 0 findings. Merged and dropped: 0 and 0.

The printed lines keep their staged text on the staged tree, because
`variants`, `five_files`, `removed_checks`, `erasure` and
`guarded_erasure` measure 5, 5, 1, 5 and 6 again. The gate marker in
`dev/stage-a-gates.py` is unchanged. The archive now holds 318 capture
files and `ARTIFACTS.json` holds 372 entries. No pinned denominator row
was refrozen, so `dev/DENOMINATORS.sha256` keeps its 119 rows and the
12 mismatching rows it already had at HEAD ccf78af. This slice rewrites
four of those 12 paths again: `dev/M1-SURFACE.md`, `dev/gates.sh`,
`dev/stage-a-gates.py` and `emit/contract.ml`. `DENOMINATORS` and
`M0-RATIO` stay red while the timing gate is paused.

Gate result. The ladder log of the last round is
`/Users/oobi/Documents/assay-m1-proof-terms-review/gates-M1PT-1.log`
and the verdict is GREEN-FUNCTIONAL, because every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused: pass=43 of 45 legs, fail=[DENOMINATORS,
M0-RATIO], mutants=true, timeout legs only=false, disclosed reds
only=true, wrapper exit ok=true.

    STAGE-M1-LINE: STAGE-M1-PROOF-TERMS FAIL
    M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
    EXIT 1 LADDER-WRAPPER-EXIT 0 12:44:39
    PASS-COUNT: 43
    FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=110.3 FAIL M0-RATIO exit=1 elapsed_ms=371.0
    DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED dev/M1-SURFACE.md: FAILED dev/contract-test.py: FAILED dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED emit/recognize.ml: FAILED

Leg tails of the same log:

    MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
    CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS cases=66 creates=2 refusals=26 mutants=5 OK
    SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
    CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
    CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=7/7 controls=7 OK CONTRACT-SURFACE counter=30 variants=13 refusals=36 mutants=7 OK
    SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
    DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
    M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
    COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
    DRIVER-TAIL: DRIVER cases=24 OK
    DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING: 12 computed checksums did NOT match
    M0-RATIO-TAIL: shasum: WARNING: 12 computed checksums did NOT match
    PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
    PROOF-REPORT-LINES: 42

DENOMINATORS stayed red on the kept 119 row manifest: no pinned path
was refrozen, and no rows-only refreeze was made on this tree. The
rows that a fix refreshed are `dev/ASSAY-M1-BUILD-LOG.md` and
`dev/proof-term-test.py` in `SOURCES.json` (entries=177 changed=2),
and `README.md` and `SOURCES.json` in `ARTIFACTS.json` (entries=372
moved=2 missing=0), which also lost the 14 stale capture rows. The
M0-RATIO remeasure is CARRIED to a calm host; `dev/denominators.json`
and `dev/measurements` are never edited in this review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: every red row is
DENOMINATORS or M0-RATIO, the disclosed state of this slice while the
timing gate is paused: pass=43 of 45 legs, fail=[DENOMINATORS,
M0-RATIO], denom rows=[dev/M1-ERRORS.md,dev/M1-PROOFS.md,
dev/M1-SURFACE.md,dev/contract-test.py,dev/gates.sh,
dev/m1-emit-test.py,dev/model-test.py,dev/stage-a-gates.py,
emit/contract.ml,emit/emit.ml,emit/model.ml,emit/recognize.ml],
mutants=true, timeout legs only=false, disclosed reds only=true,
wrapper exit ok=true, stage=STAGE-M1-LINE: STAGE-M1-PROOF-TERMS FAIL,
m0=M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification, exit=EXIT 1 LADDER-WRAPPER-EXIT 0 12:44:39)

Agent tiers: the four finders, the builder, the gate runner and the
closer ran opus/medium, the three verifiers ran sonnet/high, and the
judge and the check ran opus/high. The Fable tier probe of this review
died on the `[reasoning_extraction]` classifier before the launch, so
no stage ran fable/medium, and the finder, builder and closer tier
rulings are all reported unmet.

## 2026-09-13: proof-producing guards and erased arithmetic bounds

The ninth slice starts at `77b24f7a354f916ebf388759b678476f38129ae9`.
The surface now accepts quantity-zero ordering and overflow guards,
typed error payloads on failure, and `addLt`/`subLe` proof consumers.
The checked core defines Le and AddFits using the carried eliminators
and Nat primitives. Its complete predicate and effect schema is pinned
by recognition, and additional proof assumptions are refused by emit
and run. No kernel, carried surface or Lean source is changed.

`CounterProofs.asy` emits 405 runtime bytes and 436 creation bytes.
The source model and both Cancun execution paths agree on 83 cases,
including uint256 boundaries, empty and custom failures, rollback,
aliases, proof reuse and storage snapshots. Both constructor outcomes
pass, and every one of its 252 instructions executes. Eighteen source
refusals and six checked schema refusals cover claim/condition mismatch,
operand shadowing, erased proof misuse and assumed or altered bounds.

The success continuation has an explicit function type annotation:
the claim must be checked against the condition even when unused.
Three structurally different closed proofs emit identical five-file
outputs. Supplying the proof removes one arithmetic JUMPI. The overflow
guard still computes a temporary sum, and addLt recomputes its result.
Six compiler mutants fail their named witnesses and pass after restoring
the original source. `dev/M1-GUARDS.md` defines the accepted grammar,
core protocol and remaining scope.

Validation ran in `/Users/oobi/Documents/gpt1/assay-m1-guards`.
The complete 44-leg battery initially passed 39 legs. Three mutation
anchors needed updates after adding a second arithmetic path and typed
local bindings. The repaired M1 emission, source-model and surface
gates pass in full, including their original 8, 8 and 7 mutations and
restored controls. No witness, case count or deadline was weakened.
The compiler binary is identical across the battery and those rechecks.

The combined result is 42 passing legs, with DENOMINATORS and M0-RATIO
still failing against the preserved source manifest and timing report.
Timing remains paused, with no fresh measurement or complete-battery
pass claimed. The existing Lean gate passes 11 theorems, 226 arithmetic
cases and six mutations. Its model covers the earlier Result protocol;
this slice adds no Lean theorem about the new constructors or compiler.

Trusted lines are kernel 3997/4000, emitter 1266/1800 and total new
code 1684/3550. All original bounds remain enforced. Evidence under
`validation/2026-09-13-m1-guards/` retains the original battery, scoped
rechecks, proof and EVM reports, cache identities, source hashes and
final documentation checks. Invariant declarations, surface-supplied
proof terms and the M1 performance bound remain unfinished.

### Review round 2026-09-13 (M1 guards)

A review pass read the staged slice, kept three findings, and the fix
round fixed all three. The guard payload walk now carries the rule of
the earlier empty-payload fix, the OVERFLOW mutation requires the full
`MODEL-EXEC` label, and the commit draft wraps at 72 columns.

Kept findings:

| id | severity | one line | files |
| --- | --- | --- | --- |
| A-1 | medium | The guard payload walk accepted `()` beside a value, so `guard Denied (a) ()` reported SURFACE_NAME and `guard Denied () (a)` reported SURFACE_PROOF instead of the wrong argument count refusal | emit/contract.ml, dev/guard-test.py, dev/stage-a-gates.py, dev/M1-GUARDS.md, README.md |
| D-1 | medium | The OVERFLOW mutation required the bare prefix `MODEL-`, which every MODEL-family label satisfies; the swapped continuations raise `MODEL-EXEC` | dev/guard-test.py, dev/M1-GUARD-MUTATIONS.md |
| D-2 | low | The commit draft line 4 measured 73 columns against the 72-column body width of the earlier stage drafts | dev/STAGE-M1-GUARDS-COMMIT.txt |
| ND-1-1 | medium | New defect from the fixes: the archive row that names `SOURCES.json` still carried the old hash after round 1 refreshed that file | dev/validation/2026-09-13-m1-guards/ARTIFACTS.json, dev/validation/2026-09-13-m1-guards/SOURCES.json, dev/ASSAY-M1-BUILD-LOG.md |

Refuted: 0 findings.

Merged and dropped: 0 merged and 1 dropped. C-1 was dropped on its
mechanism: the claim that a missing emitted output file is not detected
is false, because each erasure variant goes through the shared emit
helper, which requires the exact five output names, so a missing output
file turns the leg red. Only a mutation of the gate script itself
reached green, which is not a product regression class, and the residual
`five_files=5` print is at most a style nit. No kept finding lost its
evidence.

Fixes and their proof. A-1 adds `opens_condition` beside `opens_value`
and gives the guard payload walk the refusal that the ending payload
walk already had. Two refusal cases, `error-empty-last` and
`error-empty-first`, now cover `Denied (a) ()` and `Denied () (b)`, so
`GUARD-REFUSALS` prints `surface=20` and `PROOF-GUARDS` prints
`refusals=26`. The marker in `dev/stage-a-gates.py` and the counts in
`README.md` and `M1-GUARDS.md` move with it. D-1 sets the OVERFLOW
marker to `MODEL-EXEC`: on the fix copy the documented mutation builds
with 0 errors and 0 warnings, `dev/guard-test.py witness overflow`
exits 1 with `MODEL-EXEC witness: assay: run: M1_EMIT: proved
arithmetic bound`, and the restored control exits 0. Trusted lines move
to emitter 1266/1800 and total new code 1684/3550.

`emit/contract.ml` and `dev/stage-a-gates.py` are pinned by the old
denominator manifest, so `DENOMINATORS` and `M0-RATIO` stay red, as
this slice already discloses. The rows-only refreeze on the final tree
is the only repair, and no stage of the review ran a timing
measurement. The archived battery under
`validation/2026-09-13-m1-guards/` keeps the original run and its 24
refusals; only its `SOURCES.json` hashes were refreshed. A second fix
round refreshed the one `ARTIFACTS.json` row that names
`SOURCES.json`, because the two archive files move together. The
archive now hashes all 406 retained files exactly, and it still
excludes itself.

Gate result, log
`/Users/oobi/Documents/assay-m1-guards-review/gates-M1G-2.log`, verdict
GREEN-FUNCTIONAL: every red row is DENOMINATORS or M0-RATIO, the
disclosed state of this slice while the timing gate is paused: pass=42
of 44 legs, fail=[DENOMINATORS,M0-RATIO], denom
rows=[dev/M1-ERRORS.md, dev/M1-PROOFS.md, dev/M1-SURFACE.md,
dev/contract-test.py, dev/gates.sh, dev/m1-emit-test.py,
dev/model-test.py, dev/stage-a-gates.py, emit/contract.ml,
emit/emit.ml, emit/model.ml, emit/recognize.ml], mutants=true, timeout
legs only=false, disclosed reds only=true, wrapper exit ok=true,
stage=STAGE-M1-LINE: STAGE-M1-GUARDS FAIL, m0=M0-LINE: M0-VALIDATION
FAIL; M0-EXIT requires the user commit and ratification, exit=EXIT 1 |
LADDER-WRAPPER-EXIT 0 04:10:31. Host load at the run: 4:05 28 users,
load averages: 21.04 20.95 20.20.

```
STAGE-M1-LINE: STAGE-M1-GUARDS FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1 | LADDER-WRAPPER-EXIT 0 04:10:31
PASS-COUNT: 42
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=42.7 FAIL M0-RATIO exit=1 elapsed_ms=106.0
DENOM-FAILED-ROWS: dev/M1-ERRORS.md: FAILED dev/M1-PROOFS.md: FAILED dev/M1-SURFACE.md: FAILED dev/contract-test.py: FAILED dev/gates.sh: FAILED dev/m1-emit-test.py: FAILED dev/model-test.py: FAILED dev/stage-a-gates.py: FAILED emit/contract.ml: FAILED emit/emit.ml: FAILED emit/model.ml: FAILED emit/recognize.ml: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS cases=66 creates=2 refusals=26 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=7/7 controls=7 OK CONTRACT-SURFACE counter=30 variants=13 refusals=36 mutants=7 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lean-toolchain: OK shasum: WARNING: 12 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 12 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

DENOMINATORS stayed red on the kept 119 row manifest: no stage of this
review refroze a row of `dev/DENOMINATORS.sha256`, and the rows-only
refreeze stays a task of the final tree. The rows that the fixes
refreshed are the eight `SOURCES.json` entries of round 1, the single
`SOURCES.json` entry `dev/ASSAY-M1-BUILD-LOG.md` of round 2 and the one
`ARTIFACTS.json` row that names `SOURCES.json`. The close step refreshed
the same pair once more, for its own edits to this build log and to
`dev/STAGE-M1-GUARDS-COMMIT.txt`. The M0-RATIO remeasure
is CARRIED to a calm host: `dev/denominators.json` and
`dev/measurements/` are never edited in this review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: every red row is DENOMINATORS
or M0-RATIO, the disclosed state of this slice while the timing gate is
paused: pass=42 of 44 legs, fail=[DENOMINATORS,M0-RATIO], denom
rows=[dev/M1-ERRORS.md,dev/M1-PROOFS.md,dev/M1-SURFACE.md,dev/contract-test.py,dev/gates.sh,dev/m1-emit-test.py,dev/model-test.py,dev/stage-a-gates.py,emit/contract.ml,emit/emit.ml,emit/model.ml,emit/recognize.ml],
mutants=true, timeout legs only=false, disclosed reds only=true, wrapper
exit ok=true, stage=STAGE-M1-LINE: STAGE-M1-GUARDS FAIL, m0=M0-LINE:
M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification,
exit=EXIT 1 | LADDER-WRAPPER-EXIT 0 04:10:31)

Agent models: the finders ran fable/medium with one opus/medium
fallback, and the builder and the closer ran opus/medium, because a
Fable subagent dies on the [reasoning_extraction] classifier on this
host and a death in fix or close forces a resume. Both tier rulings are
reported unmet.

## 2026-09-12: typed custom reverts and timing diagnostics

This eighth slice starts at `2077c4a98903803cfc92cd14a6f4aaac34b76ab0`.
Named Word errors lower to a checked Error sum and
`reject : Error -> Tx`. The checked schema supplies ABI rows and
in-tree Keccak selectors. Reserved and colliding selectors are
refused before output creation, including unused declarations.
Existing programs retain their prior output files.

`examples/Errors.asy` emits 358 runtime bytes and 388 creation bytes.
All 215 runtime instructions execute. The source model and both Cancun
entry points agree on 66 cases, including rollback, loaded snapshots,
repeated arguments, maximum uint256 values, tables of 1, 2 and 32
errors, and a 32-word payload. Two constructor cases check installation
and call-value refusal. Sixteen surface refusals, eight checked backend
refusals and five mutations pass their expected witnesses.

The kernel, surface, assembler and Lean sources are unchanged. Both
proof gates ran. Typed payload encoding is tested and remains outside
the existing Lean arithmetic proof model. See `dev/M1-ERRORS.md` for
the accepted source/core contracts and remaining M1 scope.

### Validation and timing status

All 42 non-performance legs passed across an interrupted battery and a
separate functional remainder. The timing gate was stopped at the user's
request after three measurement windows exceeded the existing 60-second
limit. No complete 43-leg verdict or fresh timing report is claimed.
The previous frozen report remains preserved and does not validate the
current compiler and measurement script.

The diagnostic comparison used 146 ms of child CPU for the old compiler
and 149 ms for the new compiler over the same 11 programs, with
identical outputs. A separate workload sample found that five rounds of
reference compilation alone would consume about 60.65 seconds at the
observed rate. These are diagnostic samples, not performance gate
results. Host CPU contention was observed; the wall/CPU gap does not
isolate its causes. `dev/TIMING-DEBUG.md` records the evidence and its
limits.

The measurement failure path now preserves completed samples in a
unique rejected report and prints workload totals. Synthetic tests
cover the exact boundary, an over-limit window, retained reports and a
valid control. The threshold and five-round method are unchanged.

```
ERROR-LIVE cases=66 creates=2 covered=215 OK
ERROR-REFUSALS surface=16 schema=8 OK
ERROR-MUTANT SELECTOR killed control=OK
ERROR-MUTANT MEMORY killed control=OK
ERROR-MUTANT LENGTH killed control=OK
ERROR-MUTANT ROLLBACK killed control=OK
ERROR-MUTANT ABI killed control=OK
CUSTOM-ERRORS cases=66 creates=2 refusals=24 mutants=5 OK
TRUSTED-LINES kernel=3997 want=3997 bound=4000
TRUSTED-LINES emitter=1134/1800
TRUSTED-LINES assembler=238/600
TRUSTED-LINES keccak=89/250
TRUSTED-LINES abi=29/400
TRUSTED-LINES layout=8/250
TRUSTED-LINES listing=54/250
TRUSTED-LINES total=1552/3550 ratified=3550
TRUSTED-LINES OK
RATIO-DIAGNOSTICS rejected=2 retained=2 control=1 limit=60 OK
```

`validation/2026-09-12-m1-errors/` retains the interrupted and completed
commands, 42 leg logs, functional runner, proof reports, matching cache
identities, custom-error execution and mutation evidence, diagnostics,
and source/artifact hashes. Final house and denominator checks are
recorded separately because the diagnostics and documentation changed
after the initial checks. Timing validation is still paused. M0 and M1
exit ratification remain the user's decision.

### Review round 2026-09-12 (M1 errors)

A review pass read the staged slice, kept one finding, and the fix round
fixed it: the new build-log block is rewrapped at 72 columns. The words
are the same set, no earlier block moved and no gate marker moved.

Kept findings:

| id | severity | one line | files |
| --- | --- | --- | --- |
| D-4 | low | New build-log block has 7 lines over 72 columns (max 82) while the commit message of the slice wraps at 71 | dev/ASSAY-M1-BUILD-LOG.md, dev/validation/2026-09-12-m1-errors/SOURCES.json |

Refuted: 0 findings. The verifiers refuted no finding of this round.

Merged and dropped: 0 merged and 0 dropped, so no finding lost its
evidence.

Ruled to the close-step refreeze: 5 findings. B-1 medium
`emit/contract.ml`: `error_values` accepts `()` only in first position,
so `revert Denied () (x)` and `revert Two (x) ()` give
SURFACE_DECLARATION or SURFACE_NAME instead of the documented
wrong-argument-count refusal. C-1 low `dev/ratio.py`: `validate` never
reads the rejection marker, so a rejected report passes `validate` once
its window seconds are edited under 60. D-2 low `dev/M1-ERRORS.md`: the
battery sentence reads as a result claim while the archived battery
ended interrupted at exit 143. D-3 low `dev/M1-ERROR-MUTATIONS.md`: the
mutation transcripts are said to be archived with the complete battery,
and no complete battery exists for this slice. D-1 low
`dev/TIMING-DEBUG.md`: the resource snapshot numbers have no archived
source. Each repair edits a file pinned by the 119 row
`dev/DENOMINATORS.sha256`, which no stage of this review may regenerate,
so all five ride the close-step refreeze.

Gate result, log
`/Users/oobi/Documents/assay-m1-errors-review/gates-M1E-1.log`, verdict
GREEN-FUNCTIONAL, because `FAIL M0-RATIO` is the only red row, which this
slice expects until the close-step remeasure: pass=42 of 43 legs,
fail=[M0-RATIO], denom rows=[], mutants=true, timeout legs only=false,
ratio only=true, wrapper exit ok=true.

```
STAGE-M1-LINE: STAGE-M1-ERRORS FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1
PASS-COUNT: 42
FAIL-LINES: FAIL M0-RATIO exit=1 elapsed_ms=364.3
DENOM-FAILED-ROWS:
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
CUSTOM-ERRORS-TAIL: ERROR-MUTANT ABI killed control=OK CUSTOM-ERRORS cases=66 creates=2 refusals=24 mutants=5 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=7/7 controls=7 OK CONTRACT-SURFACE counter=30 variants=13 refusals=36 mutants=7 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lakefile.lean: OK verification/lean-toolchain: OK
M0-RATIO-TAIL: M0-RATIO FAIL RATIO-METHOD
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

DENOMINATORS passed on the new 119 row freeze, `PASS DENOMINATORS exit=0`.
The fix refreshed no row of `dev/DENOMINATORS.sha256`, because
`dev/ASSAY-M1-BUILD-LOG.md` has no row in that freeze file; the fix
refreshed one entry of
`dev/validation/2026-09-12-m1-errors/SOURCES.json`, the
`dev/ASSAY-M1-BUILD-LOG.md` hash, old=cf93f1dd0805 new=b1c7627b9024.
The M0-RATIO remeasure is CARRIED to the refreeze on a calm host:
`dev/denominators.json` and `dev/measurements` are never edited in this
review.

gate: GREEN-FUNCTIONAL (GREEN-FUNCTIONAL: FAIL M0-RATIO is the only red
row, which this slice expects until the close-step remeasure: pass=42 of
43 legs, fail=[M0-RATIO], denom rows=[], mutants=true, timeout legs
only=false, ratio only=true, wrapper exit ok=true,
stage=STAGE-M1-LINE: STAGE-M1-ERRORS FAIL, m0=M0-LINE: M0-VALIDATION
FAIL; M0-EXIT requires the user commit and ratification, exit=EXIT 1 |
LADDER-WRAPPER-EXIT 0 21:54:34)

The finders ran fable/medium with one opus/medium fallback, and the
builder and the closer ran opus/medium. A Fable subagent dies on the
[reasoning_extraction] classifier on this host, and a death in fix or
close forces a resume, so the builder and the closer keep the opus pin
and both rulings are reported unmet.

Close step 2026-09-12: six findings are fixed and staged. The fix round
fixed D-4. The carried close step fixed B-1, C-1, D-1, D-2 and D-3 as
patches. The custom error leg now prints `CUSTOM-ERRORS cases=66
creates=2 refusals=26 mutants=5 OK`, and the surface refusal count is
18. The corpus mutant run now prints `RATIO-DIAGNOSTICS rejected=2
retained=2 repaired=1 control=1 limit=60 OK`. The 119 freeze rows of
`dev/DENOMINATORS.sha256` are refreshed for the patched files. The
M0-RATIO remeasure is NOT FIXED: `dev/denominators.json` still pins the
old `dev/ratio.py` hash, and the remeasure needs a calm host. The
one-minute load stayed at 31.87 or more through four readings, so
`refreeze-m1e.sh` did not run.

## 2026-09-12: nullary entry tables

This slice starts at `cd884ff35cfa8b5da9bee4ff0ff86e5e7f903344` and
accepts contracts whose complete entry table has no Word arguments.
The surface supplies an explicit `Type 0` annotation on each empty
argument record. The schema recognizer accepts that exact checked form
and preserves the existing mixed-entry representation. The carried
kernel erasure then retains the entry tag and drops the empty payload.

`examples/Nullary.asy` supplies `get()`, `increment()` and `reset()`.
Its runtime is 238 bytes and creation is 266 bytes.
The source model and both Cancun executor paths agree on 53 cases,
including every selector in tables with 1, 2 and 32 entries. All
156 runtime instructions in the example execute. Two constructor
cases cover installation, initial storage and call-value refusal.
Two manually written core variants match all five surface output files.
Four checked schema refusals run through emit and run before file
creation. Three compiler mutations are killed, with restored controls.

The old nullary-only surface refusal becomes an accepted boundary
program. The surface suite now has 36 refusals and five accepted bounds;
the new gate provides the complete dispatch and execution evidence.
The accepted core schema and remaining M1 scope are in `M1-NULLARY.md`.

### Validation

The complete 42-leg battery passes in
`/Users/oobi/Documents/gpt1/assay-m1-nullary`. The literal command is
recorded in `validation/2026-09-12-m1-nullary/RUN.json`. Full gate logs,
execution captures, mutation witnesses, source hashes and artifact
hashes are archived beside it.

The carried proof cache was reused after matching 26 source/configuration
files and both dependency revisions. The newer verification package built
fresh because the earlier cache's adapter source differed. Both axiom
gates ran, including all 42 carried and eleven source theorem reports.

```
NULLARY-LIVE cases=18 widths=35 creates=2 covered=156 OK
NULLARY-MUTANT SURFACE-UNIVERSE killed control=OK
NULLARY-MUTANT UNIT-RECOGNIZER killed control=OK
NULLARY-MUTANT UNIT-SCHEMA killed control=OK
NULLARY-ENTRIES cases=53 creates=2 refusals=4 mutants=3 OK
TRUSTED-LINES kernel=3997 want=3997 bound=4000
TRUSTED-LINES emitter=1046/1800
TRUSTED-LINES assembler=238/600
TRUSTED-LINES keccak=89/250
TRUSTED-LINES abi=24/400
TRUSTED-LINES layout=8/250
TRUSTED-LINES listing=54/250
TRUSTED-LINES total=1459/3550 ratified=3550
TRUSTED-LINES OK
STAGE-M1-NULLARY OK
M0-VALIDATION OK
```

The frozen M0 measurement completed in 19.433 seconds
at starting load 28.16. Its dated report is
`measurements/2026-09-12-m1-nullary.json`; the previous report remains
preserved. Compiler timing stays informational at M0 and establishes
no M1 performance result. M1 exit still requires user ratification.

### Review round 2026-09-12 (M1 nullary)

A review pass read the staged slice and kept two findings. This review
fixed 2 findings: A-1, B-1. `dev/nullary-test.py` refuses an unknown
argument with a
usage line on standard error and exit code 64. That code agrees with
`dev/source-proof-test.py` and with `dev/gates.sh`. Exit code 1 stays
the code of a real test failure. No gate leg gives the script an
argument, so no leg marker moves. The refreshed freeze row is row 50 of
`DENOMINATORS.sha256` for `dev/nullary-test.py`.

A-1 low `emit/recognize.ml`: the `collection` recognizer matched an
empty argument record with a guarded variable arm that compared the
body with `Rules.unit_ty Level.one`. This review replaces the arm with
the constructor pattern `Term.Ann (Term.Ran (Shape.SColl 0, Term.Sec
(Shape.SColl 0, [])), Term.Univ level)`, guarded by `not variant &&
level = Level.one`. The two forms accept the same terms, because
`Rules.unit_ty Level.one` is that exact term. The recognizer is a
frozen compiler source, so the fix comes with a compiler refreeze after
`corpus/README.md`: a new five-round timing measurement of
`dev/measurements/2026-09-12-m1-nullary.json` (window 19.433 seconds at
starting load 28.16, executable hash prefix fb0752b5203c), copied to
`dev/denominators.json`, all 114 rows of `dev/DENOMINATORS.sha256`
regenerated, and `zsh -f dev/ratio.sh` reports OK. The mutation anchor
UNIT-RECOGNIZER in `dev/nullary-test.py` now targets the new arm text,
and the gate still kills that mutant.

Kept findings:

| id | severity | one line | files |
| --- | --- | --- | --- |
| B-1 | low | Bad argument exits 1 with NULLARY-USAGE where the sibling M1P script exits 64 | dev/nullary-test.py, dev/DENOMINATORS.sha256, dev/ASSAY-M1-BUILD-LOG.md, dev/validation/2026-09-12-m1-nullary/SOURCES.json |
| A-1 | low | Guarded variable arm on the closed Term.t variant in `collection` | emit/recognize.ml, dev/denominators.json, dev/measurements/2026-09-12-m1-nullary.json, dev/nullary-test.py, dev/DENOMINATORS.sha256 |

Refuted: 0 findings. The verifiers refuted no finding of this round.
Close ladder after the refreeze: 42 legs PASS, STAGE-M1-NULLARY OK,
M0-VALIDATION OK, at starting load 31.

Merged and dropped: 0 merged and 0 dropped. The two survivors touch
different files and different defects, so no merge applied and no
finding lost its evidence.

Gate result, log
`/Users/oobi/Documents/assay-m1-nullary-review/gates-M1-1.log`, verdict
GREEN-FULL (pass=42 of 42 legs, fail=[], denom rows=[], mutants=true,
timeout legs only=false, wrapper exit ok=true):

```
STAGE-M1-LINE: STAGE-M1-NULLARY OK
M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
EXIT 0 | LADDER-WRAPPER-EXIT 0 15:40:40
PASS-COUNT: 42
FAIL-LINES:
DENOM-FAILED-ROWS:
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
NULLARY-ENTRIES-TAIL: NULLARY-MUTANT UNIT-SCHEMA killed control=OK NULLARY-ENTRIES cases=53 creates=2 refusals=4 mutants=3 OK
SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=7/7 controls=7 OK CONTRACT-SURFACE counter=30 variants=13 refusals=36 mutants=7 OK
SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: verification/lakefile.lean: OK verification/lean-toolchain: OK
M0-RATIO-TAIL: M0-PROOF-RATIO ms_per_kloc=640.638 files=3 separate=true M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

DENOMINATORS and M0-RATIO both passed on the new 114 row freeze, and the
only row a fix refreshed is row 50, `dev/nullary-test.py`.

gate: GREEN-FULL (pass=42 of 42 legs, fail=[], denom rows=[],
mutants=true, timeout legs only=false, wrapper exit ok=true,
stage=STAGE-M1-LINE: STAGE-M1-NULLARY OK, m0=M0-LINE: M0-VALIDATION OK;
M0-EXIT requires the user commit and ratification, exit=EXIT 0 |
LADDER-WRAPPER-EXIT 0 15:40:40)

The finders ran fable/medium with one opus/medium fallback, and the
builder and the closer ran opus/medium. The Fable tier probe of session
claude1, 2026-09-12 02:46, wf-mechanical, answered PROBE OK 123, and a
death in fix or close forces a resume, so the builder ruling and the
closer ruling are reported unmet.

## 2026-09-12: source arithmetic proofs

This sixth M1 slice builds on `7954843`. The new dependency-free
`verification/` Lake package exports checked uint256 arithmetic and a
finite transaction interpreter. Arithmetic produces an explicit Result
with erased exactness evidence. The interpreter accumulates an erased
certificate for its observable arithmetic trace; `source_overflow_free`
proves the trace satisfies exact, bounded addition and ordered subtraction.
All new proofs use pure terms. The 28 carried `proofs/` files are unchanged.

The statement concerns the Lean source semantics. Its correspondence with
the checked OCaml source pipeline and EVM output is tested. This slice
does not prove compiler correctness or an EVM refinement theorem. The
scope, import recipe and remaining work are in `dev/M1-PROOFS.md`.

The surface review's A-1 and D-1 findings are fixed with this new freeze.
Constructor result, revert and guard refusals retain the offending token
and all three positions are checked through check, emit and run. Core
routing scans lazily and stops early on a non-contract first identifier.
Three 1 MiB inputs allocate 1472 bytes in the routing test, below its
131072 byte ceiling, and return the original strings by identity.

### Validation

The full battery passed 41 of 41 legs with zero failures, ending in
`STAGE-M1-PROOFS OK` and `M0-VALIDATION OK`. Evidence is archived under
`dev/validation/2026-09-12-m1-proofs/`, with source and artifact hashes.

| Check | Result |
| --- | --- |
| OCaml and new Lean builds | Zero errors or warnings; zero unfinished proofs |
| New theorem reports | Eleven reports; nine without axioms and two using only propext |
| Arithmetic correspondence | 226 Lean/OCaml cases with exact Python integer expectations |
| Emitted arithmetic | 16 boundary cases under both Cancun execution paths |
| Recovery and effects | Six explicit recovery cases and seven snapshot/comparison/storage cases |
| Proof adapter refusals | Thirteen malformed inputs rejected |
| Proof mutations | Six named kills, each with a restored build and execution control |
| Report controls | Four forbidden, missing or duplicate axiom reports rejected |
| Surface | 30 counter rows, 13 variants, 37 refusals through three commands, seven mutations |
| Carry and proof seed | 31 source files byte-identical; 28 proof files and 42 reports pass without a skip |
| Trusted lines | Emitter 1033/1800, total 1446/3550, kernel 3997/4000 |
| Measurement identity | 109 frozen input rows, with every earlier row retained |

The source-proof leg took 85.066 seconds. Every existing predicate,
deadline and numerical bound remains in force. The new source-proof leg
has a 600-second deadline and requires the installed pinned Lean toolchain.
Existing local proof dependencies were copied into the validation checkout;
the inherited proof gate verified their manifest revisions offline.

The fresh five-round measurement completed in 26.770 seconds, within the
unchanged one-minute window, and is archived in
`dev/measurements/2026-09-12-m1-proofs.json`. Initial load was 21.78. The
frozen M0 contract corpus measured 947.003 ms/kloc and the fixed invocation
proxy measured 15.312 ms. These are informational M0 measurements, with
no subtraction or M1 performance claim. Earlier reports remain available.

Proof-producing surface guards, erased source proof binders, invariants,
typed custom reverts, nullary-only entry tables and the M1 performance
bound remain unfinished. M0 and M1 exit ratifications remain the user's
decisions. This slice is staged without a commit.

### Review round 2026-09-12 (M1 proofs)

A multi-agent workflow reviewed the staged slice (121 paths on 7954843) on four lenses (proofs and adapter, gate and harness, prose and freeze, integration), verified each finding, judged and ran one fix round. Six findings were confirmed, none refuted, and all six are low severity. The baseline ladder was 41 PASS, 0 FAIL, EXIT 0.

- B-1 (low, fixed). The CONTRACT-ROUTE test routed two inputs that both stop the router at the first byte, so the keyword walk was never measured. test/contract_route.ml now routes a third 1 MiB input that starts with the eight bytes of `contract` and continues into a longer identifier. The three inputs allocate 1472 bytes, below the unchanged 131072 byte ceiling, and the leg line reads `core=3`.
- A-1 (low, fixed). The adapter branch for a failed stdout write bound a detail string that it never used and exited 74 without a diagnostic. verification/Main.lean now writes the error to stderr through `toBaseIO`, which keeps the exit code and never raises a second failure. Every proof stays a pure term.
- C-2 (low, fixed). dev/M1-PROOFS.md now names the three adapter exit codes: 0 with a JSON result, 2 with an `{"error": ...}` object, and 74 when the adapter cannot write its output.
- B-2 (low, fixed). dev/M1-PROOFS.md now names the accepted assumption set (`propext`, `Quot.sound`, `Classical.choice`) and the current inventory (nine theorems with no axiom, two with `propext` alone). The gate set in dev/source-proof-test.py is unchanged.
- C-3 (low, fixed). The 94-column validation line of dev/M1-SURFACE.md is rewrapped at 80 columns with the wording unchanged.
- C-1 (low, fixed). The first body paragraph of dev/STAGE-M1-PROOFS-COMMIT.txt is rewrapped at 72 columns, the width every earlier stage text keeps.

Four frozen rows were refreshed for the edited paths: dev/M1-PROOFS.md, dev/M1-SURFACE.md, test/contract_route.ml and verification/Main.lean. dev/DENOMINATORS.sha256 keeps 109 rows in the same order, and `shasum -a 256 -c` prints OK for every row. No timing input was re-measured, and dev/denominators.json, dev/measurements/ and corpus/MANIFEST.json are untouched. The fix ladder on a fresh copy of the staged tree printed 41 PASS, 0 FAIL, `STAGE-M1-PROOFS OK`, `M0-VALIDATION OK`, EXIT 0 and no failed DENOMINATORS row; its log is /Users/oobi/Documents/assay-m1-proofs-review/fix-M1-1-smoke.log. The CONTRACT-ROUTE evidence log comes from that run, and ARTIFACTS.json and SOURCES.json are refreshed for it.

Kept findings of the round, as closed:

| id | sev | one line | files |
| --- | --- | --- | --- |
| B-1 | low | CONTRACT-ROUTE allocation bound is exercised only by first-byte mismatches, so skip_space, skip_comment and the keyword walk are never measured | test/contract_route.ml |
| A-1 | low | The stdout-failure branch binds a detail string it never uses and exits 74 with no diagnostic | verification/Main.lean |
| C-2 | low | The sourceModel adapter exit codes 0, 2 and 74 are documented nowhere | dev/M1-PROOFS.md |
| B-2 | low | Docs claim the gate rejects unlisted assumptions but never name the allowed axiom set, which is wider than the observed inventory | dev/M1-PROOFS.md |
| C-3 | low | Slice-edited validation line is 94 columns in a file wrapped at 80 | dev/M1-SURFACE.md |
| C-1 | low | Commit body line 3 is 73 columns, above the 72-column body width every earlier stage text kept | dev/STAGE-M1-PROOFS-COMMIT.txt |
| GATE-1 | high | the M1 proofs ladder is RED | (gate) |

GATE-1 changed no file. The round 1 gate reading said RED, but every row of that ladder was green (41 PASS, 0 FAIL). The round 2 ladder reproduced GREEN-FULL.

Refuted: 0.

Merged and dropped: 1. A-1-doc-half: Merged into C-2. The finder A-1 detail carried both a code defect (dead `_detail` binder, silent 74 branch) and the claim that exit 74 is named in no document; the documentation claim is the same defect as C-2, which states it for all three adapter codes 0, 2 and 74. A-1 is kept as the code half only, C-2 owns the doc fix.

Gate result of the last round, log
/Users/oobi/Documents/assay-m1-proofs-review/gates-M1-2.log, verdict
GREEN-FULL because every one of the 41 legs is PASS, no FAIL row, no failed
frozen row, the mutant legs killed their mutants and the wrapper exited 0:

- STAGE-M1-LINE: STAGE-M1-PROOFS OK
- M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
- EXIT 0 | LADDER-WRAPPER-EXIT 0 13:05:54
- PASS-COUNT: 41
- FAIL-LINES:
- DENOM-FAILED-ROWS:
- MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
- SOURCE-PROOFS-TAIL: SOURCE-PROOF-MUTANT ERROR-BRANCH killed control=OK SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK
- CONTRACT-ROUTE-TAIL: CONTRACT-ROUTE core=3 identity=true allocated_bytes=1472 bound=131072 OK
- CONTRACT-SURFACE-TAIL: SURFACE-MUTANTS killed=7/7 controls=7 OK CONTRACT-SURFACE counter=30 variants=13 refusals=37 mutants=7 OK
- SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
- DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
- M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
- COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
- DRIVER-TAIL: DRIVER cases=24 OK
- DENOMINATORS-TAIL: verification/lakefile.lean: OK verification/lean-toolchain: OK
- M0-RATIO-TAIL: M0-PROOF-RATIO ms_per_kloc=881.963 files=3 separate=true M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK
- PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
- PROOF-REPORT-LINES: 42

DENOMINATORS and M0-RATIO both passed on the new 109 row freeze; the fixes refreshed exactly four rows: dev/M1-PROOFS.md, dev/M1-SURFACE.md, test/contract_route.ml and verification/Main.lean.

gate: GREEN-FULL (pass=41 of 41 legs, fail=[], denom rows=[], mutants=true, timeout legs only=false, wrapper exit ok=true, stage=STAGE-M1-LINE: STAGE-M1-PROOFS OK, m0=M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification, exit=EXIT 0 | LADDER-WRAPPER-EXIT 0 13:05:54)

Agent tiers: the finders ran fable/medium with one opus/medium fallback, and the builder and the closer ran opus/medium. The Fable tier probe of session claude1, 2026-09-12 02:46, wf-mechanical, answered PROBE OK 123, but a death in fix or close forces a resume, so the builder and closer rulings are reported unmet.

## 2026-09-12: checked contract surface

This fifth M1 slice builds on `c7e721e`. It adds contract/storage/entry/do
sugar in `emit/contract.ml`, with a sealed interface and one integration
point before the carried checker. Named storage and entry collections,
word locals, loads, stores, checked addition/subtraction, comparison guards,
returns and literal constructors lower to the existing core protocol.
All emitted code and model execution still pass through checking, erasure
and the existing recognizer. The declared contract name supplies layout
metadata. `dev/M1-SURFACE.md` defines the grammar and its bounded scope.

The new counter fixture emits the same runtime, creation, ABI, layout and
axiom files as the core counter. The initial source comparison passed all
30 frozen rows and 13 additional cases, including local shadowing, argument
order, maximum words, snapshots and rollback. Driver testing exposed the
carried erasure's removal of the entry tag when all argument records are
empty. That case now has an explicit `SURFACE_ENTRY` refusal. Mixed entry
tables, including the counter's `get()`, are supported.

### Validation

The complete battery passed 39 of 39 legs with zero failures, ending in
`STAGE-M1-SURFACE OK` and `M0-VALIDATION OK`. Its archive is
`dev/validation/2026-09-12-m1-surface/`, including raw executions, driver
results, compiler mutations, restored controls, source hashes and artifact
hashes. The full run uses the installed OCaml switch, cast, geth and Lean
tools. Existing local proof dependencies were copied into the validation
checkout, and the proof gate verified their manifest revisions offline.

| Check | Result |
| --- | --- |
| Build and inherited suites | Pass, zero build errors and warnings |
| Carry | All 31 sources byte-identical, no unlisted files |
| Surface counter | Five output files byte-identical to the core counter |
| Counter execution | All 30 frozen rows agree with the model and both EVM paths |
| Additional execution | 13 cases, including field reordering and declared layout name |
| Creation and disassembly | Both creation outcomes pass; all 216 runtime instructions exercised |
| Driver | 35 refusals through check/emit/run, four accepted boundary programs, no-tools model call |
| Surface mutations | Seven named kills and seven restored controls |
| Existing M0 and M1 checks | Every gate passes, including prior mutations and source model |
| Proof seed | 28 carried files, 42 axiom reports, no sorryAx, no skip |
| Trusted lines | Emitter 1012/1800, total 1425/3550, kernel 3997/4000 |
| DENOMINATORS and M0-RATIO | Pass with the new measured executable and 94 frozen inputs |

The full source-model leg took 84.990 seconds and the surface leg took
86.485 seconds. Existing gate predicates, deadlines and numerical bounds
remain in force; the new surface leg has a 600-second deadline.

The fresh measurement ran five interleaved rounds in 28.753 seconds, within
the unchanged one-minute limit. It is archived as
`dev/measurements/2026-09-12-m1-surface.json`. Initial load was 68.31;
the frozen M0 contract corpus measured 1240.772 ms/kloc and the fixed-cost
proxy measured 12.790 ms. These are informational M0 measurements, with
no subtraction and no M1 performance claim. Every earlier report remains
available. The surface module is priced within the existing emitter bound.

Proof-producing guards, erased proof binders, invariant declarations,
typed custom reverts, the source overflow-freedom theorem and the M1
performance bound remain unfinished. Nullary-only entry tables retain
the stated erasure limitation. M0 and M1 exit ratifications remain the
user's decisions. This slice is staged without a commit.

### Review round 2026-09-12 (M1 surface)

A 13-agent workflow reviewed the staged slice (349 paths on c7e721e) on four lenses (lowering, gate and harness, prose and freeze, integration), verified each finding, judged, ran two fix rounds and a check stage. Two findings were confirmed, none refuted. Both are in emit/contract.ml, a frozen timing input (a row of dev/DENOMINATORS.sha256), so the review carries them with ready patches instead of moving a frozen row without a new timing run.

- A-1 (medium, carried, NEEDS-NEW-FREEZE). The CONSTRUCTOR refusals for a `pure v` ending, a `revert` ending and a `guard` step report line 1, column 1 instead of the offending token (`here []` at emit/contract.ml lines 202 and 211). The CONTRACT-SURFACE leg checks only the `line ` prefix and the code, so the position is untested. Ready patch: /Users/oobi/Documents/assay-m1-surface-review/patches/A-1.patch (carries the token through `Revert of token`, anchors the three refusals, and adds the expected position to the covering test cases).
- D-1 (low, carried, NEEDS-NEW-FREEZE). `lower` converts the whole source to a char list before it decides whether the file is a contract, so every core file pays one list cell per byte (about 2 s on a 20 MiB file). Ready patch: /Users/oobi/Documents/assay-m1-surface-review/patches/D-1.patch (routes on a lazy scan of the string; applies after A-1).

No source file changed in this round. Ladders on fresh copies of the staged tree: baseline 38 of 39 legs PASS with one inner 120 s timeout of dev/m1-emit-test.py at host load 60 to 209 (a leg outside the slice); baseline rerun 39 PASS at load 66; two fix-round ladders 39 PASS; each green run printed STAGE-M1-SURFACE OK, M0-VALIDATION OK and 94 DENOMINATORS rows OK. The close ladder after this block runs on a fresh copy; its log is /Users/oobi/Documents/assay-m1-surface-review/gates-final.log. SOURCES.json is refreshed for this log and for the commit text.

## 2026-09-11: source model and public run

This fourth M1 slice builds on `ef22665`. The public `run` command checks,
erases and specializes a source program, then interprets its effects with
immutable storage. It accepts explicit calldata, initial slots, call value
and an alternate export, and prints a single JSON outcome. It starts no
external process and writes no files. Source checking and specialization
are shared with emission; arithmetic, dispatch and storage execution use
no opcode or assembler. The sealed API admits only validated inputs and
prepared programs. `dev/M1-RUN.md` defines this boundary and the bounds.

An abort restores the complete input storage image. Arithmetic errors
follow their source continuations without exposing wrapped words. Loads
retain snapshots across later writes. Constructors are validated but
never applied to an already deployed storage image. M0 retains its value
and calldata behavior; M1 applies its common nonpayable guard and decoder.

### Validation

The complete battery passed all 38 legs, ending in `STAGE-M1-RUN OK`
and `M0-VALIDATION OK`. The archive is
`dev/validation/2026-09-11-m1-run/`, including every leg, raw model and
executor captures, source hashes and an artifact manifest.

| Check | Result |
| --- | --- |
| Build, inherited kernel and surface suites | Pass, zero build errors and warnings |
| Pin and carry | 31 of 31 sources unchanged |
| Counter model | All 30 frozen rows agree with both executors and the reference |
| Additional effects | Ten cases, including recovery, snapshots, clearing and rollback |
| M0 model corpus | All eleven cases agree, all five output hashes remain exact |
| Driver | 28 invalid inputs, six accepted invocations, six source refusals |
| Model mutations | Eight named kills and eight restored controls |
| Keccak, assembler, emission and existing executors | All legs pass, including mutations |
| Proof seed | 28 carried files, 42 axiom reports, no sorryAx, no skip |
| Trusted lines | Emitter 734/1800; six artifact total 1147/3550; kernel 3997/4000 |
| DENOMINATORS and M0-RATIO | Pass after a new measurement and source freeze |

The full battery first launched with an incomplete tool PATH. That attempt
was cancelled and its raw log retained. The passing run used the normal
tool PATH. Compiler code, gate predicates and timeouts did not change
between those invocations.

The final executable was measured in five interleaved rounds over 15.133
seconds, within the unchanged one-minute limit. The UTC-dated report is
`dev/measurements/2026-09-12-m1-run.json`; it was collected at 21:26 PDT on
September 11. All prior reports are retained. The active denominator
manifest covers 87 paths, including the new model, sealed interface and
test runner. The measurement uses the frozen M0 corpus and does not claim
the M1 performance bound. The model remains within the existing emitter
allocation, including its interface. No carried kernel, surface, proof
source, contract fixture or reference byte changed.

The next M1 work is the P1 contract/entry/do surface, the source
overflow-freedom theorem and the M1 performance bound. The source model
does not yet model external calls, balances, nonces, logs or gas. M0 and
M1 exit ratifications remain the user's decisions. No commit is made.

### Review round 2026-09-11 (M1 run)

Scope: the source model and public run slice recorded above, 327 paths,
+11842/-311, staged on head ef22665.  Four lenses raised four findings.
The judge kept all four.  A-1, C-1 and C-2 were fixed in fix round 1.
B-1 was fixed in fix round 3, by hand after the workflow run.

| id | sev | path:line | one line | fix |
| --- | --- | --- | --- | --- |
| A-1 | low | `dev/M1-RUN.md:88` | RUN_MEMORY exit 2 is an unreachable internal invariant documented as a named source refusal | three sentences state that RUN_MEMORY reports an internal invariant, not a source refusal |
| B-1 | low | `dev/model-test.py:228` | one require labels every witness outcome that is not MODEL-EXPECTED as a survived mutant | the require is split, and a witness that cannot run gets its own label |
| C-1 | low | `dev/STAGE-M1-RUN-COMMIT.txt:7` | commit text lines 7 and 9 are 73 columns, over the 72-column limit | the second paragraph is rewrapped, maximum column 72 |
| C-2 | low | `README.md:69` | README run synopsis omits `[--export NAME]` that the binary usage and `dev/M1-RUN.md` document | the synopsis gains `[--export NAME]` |

B-1 fix: `dev/model-test.py` now runs two requires after the mutant
witness.  `require(result.returncode != 0, 'MODEL-MUTANT-SURVIVED ')`
holds when the witness passed against the mutant, which is the exact
condition of a survived mutant.  The second require keeps the exit 1
and `MODEL-EXPECTED NAME` test under the new label
`MODEL-MUTANT-WITNESS`, which reports a witness that did not run to its
expected failure.  The leg stays red in both cases, so the old gate was
not vacuous, only the printed cause was wrong.  `dev/M1-RUN-MUTATIONS.md`
documents both labels.  No printed marker of the happy path moved:
SOURCE-MODEL keeps counter=30 variants=10 corpus=11 invalid=28
refusals=6 mutants=8, so `dev/stage-a-gates.py` is untouched.

The file is pinned at `dev/DENOMINATORS.sha256` row 39.  Fix round 3
refreshed that one row in place, from
`254816593d99219926da206baafebcd5570643eb0e7aba70166b4c189faa1941` to
`c9c8ba99d3138a34fd8d193273a00ada67fad15f4234858eac6e996353f9b693`.
The freeze keeps 87 rows.  `shasum -a 256 -c dev/DENOMINATORS.sha256`
reports 87 OK and 0 FAILED, and the DENOMINATORS and M0-RATIO legs stay
green, because row 39 names a test script and no compiler input.

Refuted: 0 of the four raised findings.

Merged and dropped: 0.  The four findings name four different files and
four different defects, so no merge applies.

The round 1 gate ladder was a process event, not a finding.  That run
was killed mid-run at 23:05 inside M1-EMISSION with 36 of 38 legs green
and no failure, so no leg of the slice went red and no file changed for
it.  The rerun on a fresh copy went GREEN-FULL at 38 of 38 legs.

Gate ladder `/Users/oobi/Documents/assay-m1-run-review/gates-M1-2.log`,
verdict GREEN-FULL: pass=38 of 38 legs, fail=[], denom rows=[],
mutants=true, timeout legs only=false, wrapper exit ok=true.

    STAGE-M1-LINE: STAGE-M1-RUN OK
    M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
    EXIT 0
    PASS-COUNT: 38
    FAIL-LINES:
    DENOM-FAILED-ROWS:
    MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
    SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
    DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
    M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK
    COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
    DRIVER-TAIL: DRIVER cases=24 OK
    DENOMINATORS-TAIL: surface/token.ml: OK test/emit_cases.ml: OK
    M0-RATIO-TAIL: M0-PROOF-RATIO ms_per_kloc=546.221 files=3 separate=true M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK
    PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
    PROOF-REPORT-LINES: 42

The fix round 3 smoke ladder ran on a fresh copy after the B-1 fix and
the row 39 refresh.  Log
`/Users/oobi/Documents/assay-m1-run-review/fix-M1-3-smoke.log`, verdict
GREEN-FULL.

    STAGE-M1-LINE: STAGE-M1-RUN OK
    M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
    EXIT 0
    PASS-COUNT: 38
    FAIL-COUNT: 0
    FAIL-LINES:
    DENOM-FAILED-ROWS:
    SOURCE-MODEL-TAIL: MODEL-MUTANTS killed=8/8 controls=8 OK SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK
    LADDER-WRAPPER-EXIT 0

gate: GREEN-FULL (pass=38 of 38 legs, fail=[], denom rows=[],
mutants=true, timeout legs only=false, wrapper exit ok=true,
stage=STAGE-M1-LINE: STAGE-M1-RUN OK, m0=M0-LINE: M0-VALIDATION OK;
M0-EXIT requires the user commit and ratification, exit=EXIT 0).  A
RED-LOAD status would mean that the failing ladder legs are deadline
legs at a high host load and that the verify-final ladder decides; this
round is not that case.

The finders, the builder and the closer of this round ran opus/medium.
The Fable tier probe of 2026-09-11 21:4x, session claude1, is DEAD on
the `reasoning_extraction` classifier, so this run keeps the opus pin
and the Fable tier rulings are reported unmet.


## 2026-09-11: core counter source emission

Base: `850aa68fa5ac5f71254948d2ece24157c4c17267`, the committed bounded
counter reference. The user requested continued development and staging
of all changes. Work used `/Users/oobi/Documents/gpt1/assay-m1-emission`.

`examples/Counter.asy` now emits a 326-byte runtime and 357-byte creation
program. The source supplies the entry variant, argument names, storage
labels, constructor and effect branches. The same entry rows generate
selectors and ABI JSON. Checked add/sub operations deliver a Word or an
empty error leg to a specialized continuation. Load snapshots survive
later writes. Both runtime and creation reject nonzero value.

The ABI and layout equal the frozen reference JSON. Generated bytes differ
from the hand-assembled runtime because this lowering uses explicit blocks
and memory snapshots. The inherited grammar, kernel and proof seed remain
unchanged. `dev/M1-EMISSION.md` defines the core protocol and its bounds.

### Validation

The full `zsh -f dev/gates.sh` run completed 36 of 37 legs successfully.
AXIOMS built its Lean sources successfully, then its axiom-report command
hit the existing 120-second timeout. A scoped rerun of the unchanged
`python3 -P dev/proofs-test.py` passed under the same deadlines. It retained all
42 reports and all three rejection controls. No timeout or gate was
changed. All 37 checks are therefore covered by the full run and retry;
the original failed full-run stamp remains in the archived `GATES.log`.

| Check | Result |
| --- | --- |
| Build, kernel, surface, driver, carry and house rules | Pass |
| Existing M0, executor and counter-reference gates | Pass |
| Core counter differential gate | 30 cases against the reference on both geth paths |
| Creation | Installed runtime, initial limit, and nonpayable rollback |
| Listing coverage | All 216 generated runtime instructions exercised |
| General source programs | Eight live cases, including two arguments and zero selector |
| Compiler refusals | Eleven checked sources rejected before output creation |
| Export selection | Alternate and missing names checked |
| New compiler mutations | Eight killed, eight restored controls passed |
| Public CLI | Increment from the nonzero-limit fixture passed through `assay diff` |
| Proof retry | 42 axiom reports, no sorryAx, three controls |
| Trusted lines | Emitter 592/1800, all trusted artifacts 1005/3550 |
| DENOMINATORS and M0-RATIO | Pass after the new measurement freeze |

The final compiler measurement completed five rounds in 26.440 seconds,
within the unchanged one-minute bound. The previous Stage F report is
preserved in `dev/measurements/2026-09-11-m0-stage-f.json`. The active
report is `dev/measurements/2026-09-11-m1-emission.json`, also copied to
`dev/denominators.json`. The source manifest now covers 83 paths and
includes the previously omitted executor inputs. The frozen M0 corpus
and reference bytes did not change. The ratio remains informational and
does not establish the M1 performance bound.

`dev/validation/2026-09-11-m1-emission/` retains all leg logs, the proof
retry, source hashes, five-file hashes, mutation captures and raw runtime
evidence. `CHECKS.json` distinguishes the initial result from the retry.
Both executor paths use geth. These tests do not prove the OCaml compiler.

The next M1 work is the P1 contract/entry/do surface, public `run`, the
source overflow-freedom theorem and the M1 performance bound. The M0 exit
stamp still requires the user's ratification. No commit or push was made.

### Review round 2026-09-11 (M1 emission)

Scope: the core counter source emission slice recorded above under
`## 2026-09-11: core counter source emission`, 215 paths, +6776/-346,
staged on head 850aa68.  Four lenses raised 10 findings.  The judge
kept 7 and merged 3 into them.  Four kept findings and one new defect
of the round 1 check were fixed in two fix rounds.  Three stay open
because the only fix edits a source that `dev/DENOMINATORS.sha256`
pins.

| id | sev | one line | files |
| --- | --- | --- | --- |
| A-2 | medium | Routing on the bare presence of `Entry` refuses an M0 source with an unrelated diagnostic, and the rule was undocumented | `dev/M1-EMISSION.md` |
| B-1 | medium | The evidence manifest dropped 60 pinned inputs, among them the counter oracle and the proof tree, and its README overstated the archive | `dev/validation/2026-09-11-m1-emission/SOURCES.json`, `dev/validation/2026-09-11-m1-emission/README.md` |
| C-1 | low | The new section stated an AXIOMS retry duration the archive does not support and labelled the 1005/3550 trusted-line total "all new artifacts" | `dev/ASSAY-M1-BUILD-LOG.md` |
| C-3 | low | The freeze recipe listed 8 of the 9 added paths, and the startup caveat covered only the archived timing report | `corpus/README.md` |
| ND-1-1 | medium | The manifest omitted the prose of this slice that its own README sentence claims it hashes | `dev/validation/2026-09-11-m1-emission/SOURCES.json` |

Round 2 added `CARRIED.md`, `dev/EMISSION.md` and `dev/M1-EMISSION.md`
to the evidence manifest, which goes from 182 to 185 entries.  The
manifest now holds the prose of this slice, so the README sentence is
true.  The refresh tool reports `SOURCES entries=185 changed=0` against
the staged blobs.

Open findings: A-1 (an empty `Storage : prod ()` passes the recognizer
and dies later as `EMIT_MISSING: storage`), A-3 (an M1 schema refusal
prints the `M0_PROTOCOL:` prefix) and B-2 (three refusal rows share one
witness substring in the M1-EMISSION leg).  Each needs `emit/emit.ml`,
`emit/recognize.ml` or `dev/m1-emit-test.py`.  The `corpus/README.md`
recipe demands a new sub-minute timing run before such a hash moves, and
this review takes no measurement.

A patch for the three open findings, not staged, is at
`/Users/oobi/Documents/assay-m1-emission-review/patches/m1e-deferred.patch`
with a README and `m1-emission-verify.log` beside it.  It covers A-1
(an empty `Storage` refuses with `STORAGE_EMPTY`), A-3 (a new
`M1_protocol` constructor prints `M1_PROTOCOL:`) and B-2 (each refusal
row compares its whole diagnostic by equality) in `emit/recognize.ml`,
`dev/m1-emit-test.py`, `dev/stage-a-gates.py`, `dev/M1-EMISSION.md`,
`dev/STAGE-M1-EMISSION-COMMIT.txt` and `README.md`, 232 diff lines.
On a copy of the staged tree the patch builds with 0 errors and the
M1-EMISSION leg prints `M1-EMISSION counter=30 sources=8 refusals=12
mutants=8 OK` with exit 0.  `git apply --check` passes on this index.
After apply, `shasum -a 256 -c dev/DENOMINATORS.sha256` reports the
three rows `dev/m1-emit-test.py`, `dev/stage-a-gates.py` and
`emit/recognize.ml` as FAILED, so the patch waits for the
`corpus/README.md` re-freeze recipe: a timing run, then the row
refresh, then the ladder.

No row of `dev/DENOMINATORS.sha256` moved.  The fixes touched no file
under `lib/`, `surface/`, `corpus/contracts/`, `corpus/proofs/` or
`dev/measurements/`.  The one `corpus/` edit is the unpinned
`corpus/README.md` prose of C-3, and `corpus/MANIFEST.json` is
untouched.  The review made no commit and no network operation.

Refuted: 0 of the 10 raised findings.

Merged and dropped: 3.  B-3 into B-1, one README of the same archive
directory overstates it.  C-2 into C-1, two unsupported claims of the
same build-log section.  D-1 into C-3, two prose gaps of the same
corpus freeze section.

Gate ladders.  The baseline `gates-baseline.log` is GREEN-FULL by leg
counts: `PASS-COUNT: 37`, `FAIL-COUNT: 0`, `STAGE-M1-EMISSION OK`,
`M0-VALIDATION OK; M0-EXIT requires the user commit and
ratification`, `DENOM-FAILED-ROWS: 0`.  Those rows were derived by
hand at 18:14:46 from `copy-baseline/.gatework/gates-run.log` after
the harness stopped the launcher shell, so the wrapper log holds no
`EXIT` row.  The round 1 ladder `gates-M1-1.log` holds seven rows and
stops at `PROVISION-REVS` at 18:49:56 under load 30/31/53: it died
while provisioning and printed no leg row.  The round 2 ladder
`gates-M1-2.log` never ran.  It ends `LOCK-BUSY 20:21:55 no ladder
run` after 65 minutes of `WAIT-LOCK` rows on a stale `ladder.lock`
that the round 2 smoke left at 19:07:21, and the main session removed
that lock at 20:32:53.

The round 1 fix smoke `fix-M1-1-smoke.log`, on copy `fix-copy-1` of
the round 1 index, ran 18:43:52 to 18:48:30 and is GREEN-FULL:

    STAGE-M1-LINE: STAGE-M1-EMISSION OK
    M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
    EXIT 0
    PASS-COUNT: 37
    FAIL-COUNT: 0
    DENOM-FAILED-ROWS: 
    M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK 
    DENOMINATORS-TAIL: surface/token.ml: OK test/emit_cases.ml: OK 
    M0-RATIO-TAIL: M0-PROOF-RATIO ms_per_kloc=804.638 files=3 separate=true M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK 

The round 2 fix smoke `fix-M1-2-smoke.log`, on copy `fix-copy-2` of
the round 2 index (HEAD 850aa68, `PORCELAIN-BEFORE 215`), ran 19:08:11
to 19:10:37 and is GREEN-FULL:

    STAGE-M1-LINE: STAGE-M1-EMISSION OK
    M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
    EXIT 0
    PASS-COUNT: 37
    FAIL-COUNT: 0
    DENOM-FAILED-ROWS: 
    M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK 
    DENOMINATORS-TAIL: surface/token.ml: OK test/emit_cases.ml: OK 
    M0-RATIO-TAIL: M0-PROOF-RATIO ms_per_kloc=804.638 files=3 separate=true M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK 

The verdict of the last workflow round, verbatim:

    gate: RED (pass=0 of 0 legs, fail=[], denom rows=[], mutants=false, timeout legs only=false, wrapper exit ok=true, stage=NONE - no STAGE-M1-LINE row was ever printed, m0=NONE - no M0-LINE row was ever printed, exit=LOCK-BUSY 20:21:55 no ladder run)

The close ladder `gates-final.log` on `copy-final` decides.  The copy
was taken at 20:39:22 at load 64 from the closed index (HEAD 850aa68,
`PORCELAIN-BEFORE 215`) before the closer extended this block, the
commit file and the manifest, and no gate leg reads those three files.
The warm build took 255 s, the 37 legs ran 20:44:19 to 20:51:50, and
the ladder is GREEN-FULL:

    STAGE-M1-LINE: STAGE-M1-EMISSION OK
    M0-LINE: M0-VALIDATION OK; M0-EXIT requires the user commit and ratification
    EXIT 0
    PASS-COUNT: 37
    FAIL-COUNT: 0
    FAIL-LINES: 
    DENOM-FAILED-ROWS: 
    PORCELAIN-AFTER 215
    UNSTAGED 0
    LADDER-WRAPPER-EXIT 0 20:51:51
    PASS AXIOMS exit=0 elapsed_ms=21673.8
    PASS M1-EMISSION exit=0 elapsed_ms=85757.8
    M1-EMISSION-TAIL: M1-MUTANTS killed=8/8 controls=8 OK M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK 
    DENOMINATORS-TAIL: surface/token.ml: OK test/emit_cases.ml: OK 
    M0-RATIO-TAIL: M0-PROOF-RATIO ms_per_kloc=804.638 files=3 separate=true M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK 

No leg timed out.  The `AXIOMS` leg, which timed out once in the
archived builder run, passed in 21.7 s.

`DENOMINATORS` and `M0-RATIO` passed on the 83 row freeze in both fix
smokes and in the baseline gate run the baseline rows come from, and
no fix refreshed a row.

Tiers: the finders, the builder and the closer ran opus/medium.  The
Fable tier probe (req_011Cexaan23ubsEVAxtWsnu4, 2026-09-11 17:2x)
died on the reasoning_extraction classifier, so this run kept the opus
pin and the tier rulings are reported unmet.

## 2026-09-11: bounded counter reference

Base: `1e76d6922038d2549ed4804c738574badc964850`, the committed offline
executor slice. The user requested continued development and staging of
all changes. Work used `/Users/oobi/Documents/gpt1/assay-m1-counter`.

The ratified design requires reference bytes to be committed before the
emitter targets them. This slice therefore supplies the hand-assembled
counter, its ABI and layout fixtures, and execution gates. It makes no
counter emitter or surface change and claims no M1 completion.

The runtime is 177 bytes in 120 commented instruction rows. Creation
adds a 27-byte prefix, initializes limit to 100 and starts with count
zero. Increment checks overflow and the limit before its only store.
Decrement checks underflow. Get has no store. All entries and creation
reject nonzero value. Short calldata and unknown selectors revert;
trailing calldata is ignored for all three entries.

The offline Python adapter now accepts a uint256 call value and refuses
insufficient sender funds before execution. It passes the same value to
both entry points. The public `assay diff` command remains zero-value.
The positive CALLVALUE probe returns seven, so the nonpayable probes
cannot pass through an adapter that silently discards the value.

### Validation

The complete battery passed 34 of 36 legs. Only DENOMINATORS and
M0-RATIO failed, on the same four stale source hashes from the prior
executor slice. No gate was skipped or weakened. The new counter leg is
classified as M1, preserving the separate M0 result.

| Check | Result |
| --- | --- |
| Build, kernel, surface, driver, carry and house rules | Pass |
| Existing Keccak, assembler, reference, emission and mutation gates | Pass |
| Frozen corpus and proof erasure seed | Pass |
| Carried proofs | 42 axiom reports, no sorryAx |
| Existing differential executor | 20 live cases, 28 driver cases, 24 refusals |
| Counter behavior | 30 expected outcomes on both geth paths |
| Counter creation | Returned and installed bytes, initial storage, nonpayable rollback |
| Counter listing | In-tree, cast and geth rows equal, every runtime and prefix PC exercised |
| Counter mutations | Eight semantic failures with passing restored controls |
| Call-value validation | Positive value seven, five input/funding refusals |
| Measurement | Both new attempts rejected by the unchanged one-minute bound |

Counter cases retain a nonzero unrelated slot and include a successful
increment from count 7 with limit 100. They cover overflow, underflow,
equality at the bound, zero and maximum values, truncated heads, trailing
data and funded nonpayable calls. Executor agreement is followed by an
exact expected storage/status/output check. Mutation kills require that
specific expectation failure, not an EVM fault or tool error. Creation
uses `evm run --create` only; runtime cases use both executor paths.

`reference/counter/MANIFEST.json` pins the manually specified fixtures.
`dev/M1-COUNTER-MUTATIONS.md` records the exact edits and witnesses.
`dev/validation/2026-09-11-m1-counter/` retains the battery and raw
counter captures. Both executor paths use geth, and these checks do not
constitute a compiler correctness proof.

Two fresh measurement attempts failed `RATIO-WINDOW`, including a final
attempt after the gate battery had finished. Neither produced a report
eligible for a new freeze. The prior measurement and source hash manifest
remain unchanged. DENOMINATORS and M0-RATIO therefore remain open. The
archived attempt logs contain their exact rejection messages.

The counter source emitter can target this reference after the user
commits it. The source dispatcher, ABI/layout emission, entry sugar,
`run`, complete M1-DIFF gate and M1 performance bound remain. M0-EXIT
still requires the user's ratification. No commit or network operation
was made by this slice.

### Review round 2026-09-11 (M1 counter)

Scope: the bounded counter reference slice recorded above under
`## 2026-09-11: bounded counter reference`, 126 paths, +4565/-19,
staged on head 1e76d69.  Four lenses raised 9 findings, 7 kept and
all 7 fixed in one fix round.

| id | sev | one line | files |
| --- | --- | --- | --- |
| B-1 | medium | COUNTER-LABELS checks only the set of label PCs, so a permuted MANIFEST label map passes the leg | `dev/counter-test.py` |
| A-1 | low | The new `--value` CLI flag is exercised by no gate leg | `dev/diff-test.py`, `dev/stage-a-gates.py`, `README.md`, `dev/ASSAY-M1-BUILD-LOG.md` |
| A-2 | low | `--value QUANTITY` does not state the radix, and a bare decimal is read as decimal | `dev/M1-EXECUTOR.md` |
| C-3 | low | README announces the counter reference as a future slice while the same README documents it as present | `README.md`, `dev/M1-EXECUTOR.md` |
| C-4 | low | The docs name one capture directory, the gate writes two | `reference/counter/README.md`, `dev/M1-COUNTER-MUTATIONS.md` |
| D-1 | low | New freeze instruction names a file class `dev/DENOMINATORS.sha256` has never pinned | `corpus/README.md` |
| D-2 | low | README remaining-work list disagrees with the build log and `dev/M1-EXECUTOR.md` | `README.md` |

Refuted: 0.

Merged and dropped: 2.  C-1 merged into B-1 (same file, same line
`dev/counter-test.py:51`, same defect: label names and label PCs
compared as two sets, never paired, and `MANIFEST.json` covered by no
hash; B-1 keeps the wider probe and folds in the literal-dict repair
hint).  C-2 cut by the 7-finding cap as the weakest low (the cited
`dev/M1-EXECUTOR.md:111` text is verbatim and does contradict
`README.md`, so it is not refuted, but it is past tense inside the
executor slice's own historical record and is the same doc-freshness
class as the kept C-3 and D-2).

Gate ladder: `/Users/oobi/Documents/assay-m1-counter-review/gates-1.log`,
verdict GREEN-DOCUMENTED, reason: pass=34 of 36 legs,
fail=[DENOMINATORS,M0-RATIO],
denom rows=[bin/assay.ml,dev/gates.sh,dev/stage-a-gates.py,dev/stage-a-test.py],
mutants=true, stage=STAGE-M1-LINE: STAGE-M1-COUNTER FAIL,
m0=M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and
ratification, exit=EXIT 1.

```
STAGE-M1-LINE: STAGE-M1-COUNTER FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1
PASS-COUNT: 34
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=275.5 FAIL M0-RATIO exit=1 elapsed_ms=1677.6
DENOM-FAILED-ROWS: bin/assay.ml: FAILED dev/gates.sh: FAILED dev/stage-a-gates.py: FAILED dev/stage-a-test.py: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=28 rejected=24 OK
COUNTER-REFERENCE-TAIL: COUNTER-MUTANT SELECTOR witness=increment-success killed control=OK COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK
DRIVER-TAIL: DRIVER cases=24 OK
DENOMINATORS-TAIL: surface/token.ml: OK shasum: WARNING: 4 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 4 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

The DENOMINATORS and M0-RATIO pair stays red by the documented freeze
recipe of `corpus/README.md`, on the same four stale rows
`bin/assay.ml`, `dev/gates.sh`, `dev/stage-a-gates.py` and
`dev/stage-a-test.py`; this review repeated no measurement and edited
no frozen input.

gate: GREEN-DOCUMENTED (pass=34 of 36 legs, fail=[DENOMINATORS,M0-RATIO], denom rows=[bin/assay.ml,dev/gates.sh,dev/stage-a-gates.py,dev/stage-a-test.py], mutants=true, stage=STAGE-M1-LINE: STAGE-M1-COUNTER FAIL, m0=M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification, exit=EXIT 1)

Tiers: the finders, the builder and the closer ran opus/medium because
the Fable tier probe died on the reasoning_extraction classifier
(probe req_011CexKZWQfZPzn1ksRjRrht, session claude1, 2026-09-11 14:0x,
DEAD), so this run keeps the opus pin and the Fable tier rulings are
reported unmet.

## 2026-09-11: offline executor slice

Base: `10ba107b60654323622e29f20b5f0a04d0a38ba2`, the committed M0 Stage F.
The user requested continued development and staging of all changes.
The work was built in `/Users/oobi/Documents/gpt1/assay-m1-executor`.
No commit or network operation was made.

The public `diff` command now compiles a closed source program and compares
storage, returned bytes and revert status through `evm run` and Cancun
`evm t8n`.  The helper validates the prestate, receipts, traces and storage
before comparing them.  It preserves nonzero initial slots and verifies
rollback on revert.  The shared compiler diagnostic now names `trace` or
`diff` when that command requested compilation.

The executor contract is in `dev/M1-EXECUTOR.md`.  Its named restrictions
include the pinned Cancun environment, two fixture accounts and refusal
of `GASLIMIT`.  A live `GAS` probe found that geth overrides `--gas` when
a prestate is present.  The adapter uses that measured behavior and adds
transaction intrinsic gas to the t8n gas allowance and block limit.
Both entry points use geth, so this is not independent client agreement.

### Validation

The build passed with zero errors and zero warnings.  The complete gate
battery ran all 35 legs.  It passed 33 and failed two measurement legs.
The raw result and each leg are retained under
`dev/validation/2026-09-11-m1-executor/`.

| Check | Result |
| --- | --- |
| Kernel and surface suites | Pass |
| Pin and carry inventory | 31 of 31, no changes |
| House rules and trusted lines | Pass, 693 of 3,550 |
| Keccak, assembler and reference gates | Pass, including mutations |
| Source emission and frozen corpus | Pass, all five emitted files |
| Carried proof package | Pass, 42 axiom reports, no sorryAx |
| Existing trace driver | 20 cases pass |
| Differential executor | 20 live cases, 26 driver cases, 24 rejection witnesses pass |
| DENOMINATORS | Fails on four changed source hashes |
| M0-RATIO | Fails on those same source hashes |

The four changed hashes are `bin/assay.ml`, `dev/gates.sh`,
`dev/stage-a-gates.py` and `dev/stage-a-test.py`.  They belong to the
frozen Stage F measurement.  Two attempts to measure the new build
failed `RATIO-WINDOW` because the measured rounds exceeded one minute.
Both attempts ran under high host load.  The limit was not changed,
and no old measurement was assigned new source hashes.  Both failed
attempt logs are retained with the validation evidence.

The slice is staged for review with those two validation failures still
open.  Before a green full battery, collect a new dated measurement with
`zsh -f dev/ratio.sh --measure NEW.json`, preserve the old report, and
freeze the new report and source hashes by `corpus/README.md`.
The bounded counter, dispatcher, ABI surface and remaining M1 gates
remain future work.  The M0 exit stamp is still the user's ratification.

### Review round 2026-09-11 (M1 executor)

Seven review items were applied to the staged tree.

| Item | Change |
| --- | --- |
| D-1 | `dev/stage-a-gates.py` keeps a separate M1 flag.  A failed `DIFF-EXECUTOR` leg now moves the stage line and the exit code only, and the `M0-VALIDATION` line reports the M0 legs alone. |
| A-1 | `evm/diff.py` refuses `GASLIMIT`, `BASEFEE` and `BLOBBASEFEE` with `DIFF_CONTEXT`.  Two rejection witnesses were added, so the leg reports 24. |
| B-1 | `bin/differential.ml` separates `WSIGNALED` from `WSTOPPED` and names the signal, so a killed helper reports `DIFF_RUNNER: killed by SIGTERM`. |
| B-2 | `dev/diff-test.py` adds the `missing-helper` and `runner-signal` driver cases.  Both mutants of the two arms now fail the leg. |
| A-2 | `dev/diff-test.py` adds the `executor-stderr` driver case, which is the first witness for the unexpected-stderr guard. |
| C-2 | `README.md` states that this tree fails DENOMINATORS and M0-RATIO on four changed driver source hashes. |
| C-1 | This log no longer reports host load figures that the retained attempt logs do not hold. |

The driver count moved from 23 to 26 and the rejection count from 22 to 24.
The marker of `dev/stage-a-gates.py`, `README.md`, `dev/M1-EXECUTOR.md`,
`dev/MUTATION-LOG.md` and the validation README carry the new counts.
`dev/MUTATION-LOG.md` records the four mutations that prove the new cases.
No measurement was repeated, and no frozen input was changed, so
DENOMINATORS and M0-RATIO stay failed on the same four source hashes.

The retained executor evidence was refreshed from a second ladder copy of
the fixed tree.  `DIFF-EXECUTOR.log`, `DIFF-EVIDENCE.json`, `GATES.log` and
`DENOMINATORS.log` under `dev/validation/2026-09-11-m1-executor/` now record
that run: `DIFF-EXECUTOR live=20 driver=26 rejected=24 OK`, 33 PASS legs and
the two documented FAIL legs on the same four source hashes.  No measurement
was repeated and no frozen input was changed.

The review kit ran the M1 ladder on fresh copies of the staged tree
(`run-ladder.sh` in `~/Documents/assay-m1-executor-review`).  The
Workflow found 17 raw items.  The verify stage refuted 0.  The judge
kept 7 under the seven-finding cap and dropped 10.  The round-1 check
added ND-1-1.  Every kept item is fixed and staged.

| Id | Severity | File | Line | Finding | Verdict |
| --- | --- | --- | --- | --- | --- |
| D-1 | medium | `dev/stage-a-gates.py` | 142 | An M1-only `DIFF-EXECUTOR` failure printed `M0-VALIDATION FAIL` while every M0 leg passed. | fixed |
| A-1 | medium | `evm/diff.py` | 186 | `supported()` refused only `GASLIMIT`, so `BASEFEE` (0x48) and `BLOBBASEFEE` (0x4a) gave a false `DIFF_MISMATCH`. | fixed |
| B-1 | medium | `bin/differential.ml` | 10 | `DIFF_RUNNER: signal N` printed the OCaml internal signal number, so a helper killed by SIGTERM read as signal -11. | fixed |
| B-2 | medium | `dev/diff-test.py` | 131 | No driver case pinned the `Missing_helper` or the `WSIGNALED` arm of `bin/differential.ml`, so a two-arm mutant survived `DIFF-EXECUTOR`. | fixed |
| A-2 | medium | `evm/diff.py` | 175 | The unexpected-stderr guard in `invoke()` had no witness.  Deleting it left `DIFF-EXECUTOR` green. | fixed |
| C-2 | medium | `README.md` | 148 | The README did not say that the staged battery fails `DENOMINATORS` and `M0-RATIO`, while its quickstart tells the reader to run `dev/gates.sh`. | fixed |
| C-1 | medium | `dev/ASSAY-M1-BUILD-LOG.md` | 48 | The host-load figures 43.58 and 117.49 had no support in the retained measurement evidence. | fixed |
| ND-1-1 | medium | `dev/validation/2026-09-11-m1-executor/DIFF-EXECUTOR.log` | 34 | The retained executor evidence was stale after the round-1 fixes. | fixed |

Fixed 8 (D-1, A-1, B-1, B-2, A-2, C-2, C-1, ND-1-1).  Refuted 0.
Dropped 10:

- A-3: merged into B-2 (the same missing driver cases).
- B-3, B-4, C-3, C-4, C-5, D-2, D-3, D-4: low, confirmed, cut by the
  seven-finding cap.  B-3: `Trace.regular` tests existence only, so a
  helper with mode 000 falls through to `DIFF_RUNNER: exit 2` with a raw
  CPython line.  B-4: `bin/differential.ml` has no python3 version test,
  and the README states the 3.11 requirement only in the gates
  paragraph.  C-3: the commit text did not name the two open legs (the
  closing commit text now does).  C-4: the validation README omits the
  scratch checkout path and the literal gates command.  C-5:
  `dev/diff-test.py` prints `controls=1` although two controls run.
  D-2: `diff FILE --calldata HEX` deviates from `assay diff FIXTURE` in
  `dev/M0-PLAN.md`, and no document names the deviation.  D-3:
  `evm/diff.py` reads `--prestate` unguarded, so a missing path prints a
  raw OSError text with no `DIFF_` name.  D-4: `dev/M0-BUILD-LOG.md`
  still records `pass=34 fail=0`.
- B-5: `Unix.open_process_args_in` and `In_channel.input_all` in
  `bin/differential.ml` are uncaught.  This is the open Stage E ruling
  A-4 on Unix boundary exceptions, not a new defect.  After the ruling,
  apply it to `bin/trace.ml` and `bin/differential.ml` together.

Gate record.  Each ladder copied the staged tree, warmed the proof
build and ran `zsh -f dev/gates.sh`.  The logs live in the review kit
(`~/Documents/assay-m1-executor-review`).

Round-1 gate ladder (`gates-M1-1.log`, 10:26, load 30, after the seven
round-1 items), verdict GREEN-DOCUMENTED:

```
STAGE-M1-LINE: STAGE-M1-EXECUTOR FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1
PASS-COUNT: 33
FAIL-COUNT: 2
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=46.7 FAIL M0-RATIO exit=1 elapsed_ms=209.1
DENOM-FAILED-ROWS: bin/assay.ml: FAILED dev/gates.sh: FAILED dev/stage-a-gates.py: FAILED dev/stage-a-test.py: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
DRIVER-TAIL: DRIVER cases=24 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=26 rejected=24 OK
DENOMINATORS-TAIL: surface/token.ml: OK shasum: WARNING: 4 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 4 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
LADDER-WRAPPER-EXIT 0 10:26:43
```

Round-2 fix smoke ladder (`fix-M1-2-smoke.log`, 10:36, load 21, after
ND-1-1, the tree with every fix applied), verdict GREEN-DOCUMENTED:

```
STAGE-M1-LINE: STAGE-M1-EXECUTOR FAIL
M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification
EXIT 1
PASS-COUNT: 33
FAIL-COUNT: 2
FAIL-LINES: FAIL DENOMINATORS exit=1 elapsed_ms=31.9 FAIL M0-RATIO exit=1 elapsed_ms=263.0
DENOM-FAILED-ROWS: bin/assay.ml: FAILED dev/gates.sh: FAILED dev/stage-a-gates.py: FAILED dev/stage-a-test.py: FAILED
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
DRIVER-TAIL: DRIVER cases=24 OK
DIFF-EXECUTOR-TAIL: DIFF-CHECKS killed=24/24 controls=1 OK DIFF-EXECUTOR live=20 driver=26 rejected=24 OK
DENOMINATORS-TAIL: surface/token.ml: OK shasum: WARNING: 4 computed checksums did NOT match
M0-RATIO-TAIL: shasum: WARNING: 4 computed checksums did NOT match
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

Round-2 gate ladder (`gates-M1-2.log`, 10:40): INCOMPLETE.  Its copy
log holds 14 PASS legs and stops before `ASM-MUTANTS`.  The ladder
process died together with the gate agent that had launched it 62
seconds earlier.  This is a run artifact, not a slice defect, and the
dispatcher item GATE-2 that it raised is not a finding.

Closing ladder (`gates-final.log`, written by `verify-final.sh` after
this close): the decider.  Its verdict is recorded in
`verify-final.out` in the review kit.

DENOMINATORS and M0-RATIO stay failed on the same four source hashes,
`bin/assay.ml`, `dev/gates.sh`, `dev/stage-a-gates.py` and
`dev/stage-a-test.py`, until a new sub-minute measurement freezes them
by the `corpus/README.md` recipe.  The review repeated no measurement
and changed no frozen input.

gate: GREEN-DOCUMENTED (pass=33 of 35 legs, fail=[DENOMINATORS,M0-RATIO], denom rows=[bin/assay.ml,dev/gates.sh,dev/stage-a-gates.py,dev/stage-a-test.py], mutants=true, stage=STAGE-M1-LINE: STAGE-M1-EXECUTOR FAIL, m0=M0-LINE: M0-VALIDATION FAIL; M0-EXIT requires the user commit and ratification, exit=EXIT 1; the last complete ladder fix-M1-2-smoke.log at 10:36 is GREEN-DOCUMENTED; the closing ladder gates-final.log decides)

Review tiers: every finder, builder and closer stage ran on opus/medium
with the markers [finder-tier-explicit], [builder-tier-explicit] and
[closer-tier-explicit] (verify sonnet/high, judge and check opus/high),
because the Fable probe req_011CewthrC781kAdpffiEDBX died on the
reasoning_extraction classifier.  The Fable tier rulings are unmet.
The Workflow run wf_805e5acb-b9f stopped at the round-2 check when its
gate ladder was killed.  The close ran by hand in the main session
after the closer spawn died on the session limit
(req_011Cex8azKwh4QUXSZEnEZZT).

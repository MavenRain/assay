# Assay M1 build log

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

# Assay M1 build log

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

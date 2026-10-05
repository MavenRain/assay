# M2 coverage and audit reconciliation

M2 group 8 compares the documents, budgets and refusals with the code.
Run `python3 -P dev/m2-reconcile-test.py`. The check is static and needs
no build. `make test` includes it and `dev/refined-word-test.py`.

## What the test checks

- Each deferred construct in the table below has its SPEC.md text, its
  refusal text in `src/` and its test evidence. A missing item fails the
  check. An item marked OPEN is not required.
- Each document that names the default gate mode names `--m2-reconcile`
  and the 110-leg count. No document names `--m2-abi` as the current
  default.
- `dev/gates.sh` and the `Makefile` select `--m2-reconcile`. The schedule
  has 110 legs: the 108 `--m2-abi` legs, then M2-RECONCILE and
  REFINED-WORD.
- The stage-A mutant table, `dev/stage-a-gates.py` and
  `dev/milestone-speed-test.py` agree on the MUTANTS count. The table
  contains R0-AUDIT-MILESTONE.
- `dev/refined-word-data` holds the ten refined Word fixtures.
- Three controls remove a refusal, a test text and a leg count in memory.
  Each control must fail.

The marker is
`M2-RECONCILE deferred=9 tested=5 open=4 docs=17 legs=110 mutants=15 fixtures=10 controls=3 OK`.

## Gate mode

`dev/stage-a-gates.py --m2-reconcile` keeps all `--m2-abi` legs with their
deadlines and markers. It adds M2-RECONCILE with a 60-second deadline floor
and REFINED-WORD with a 600-second deadline floor, for 110 legs.
REFINED-WORD requires
`REFINED-WORD valid=2 kernel_refused=3 emitter_refused=1 OK`.
M2 stays open until the group 9 closure battery passes.

## Deferred-construct refusal matrix

| Construct | Refusal site | Test evidence | Status |
|---|---|---|---|
| `SPar` | `src/kernel.bend`, "SPar is deferred" | none | OPEN |
| `SNu` | `src/kernel.bend`, "SNu is deferred" | none | OPEN |
| `nu` | `src/frontend.bend`, "nu is deferred" | `src/tests.bend`, two parser refusals | OK |
| `Auto` | `src/kernel.bend`, "instances are deferred" | `test/neg/n06-auto.err` | OK |
| Family that is not strictly positive | `src/kernel.bend` | `test/neg/mu-nonpositive.err` | OK |
| Right former at a mu shape | `src/kernel.bend` | `src/tests.bend` | OK |
| `KDelay`, `KForce` | `src/emitter.bend`, "EMIT_... (deferred)" | `src/tests.bend`, `Emit.Error.Later` cases | OK |
| `RThunk` | `src/emitter.bend`, "EMIT_... (deferred)" | none | OPEN |
| Level variables | no named refusal | none | OPEN |

SPEC.md has no row for the right former at a mu shape. The kernel message
is the only record.

## Audit table

| Item | Evidence | Status | Action |
|---|---|---|---|
| Stale kernel text "string types arrive at M1" | `src/kernel.bend`, `Check.string_word` | FIXED | Text is now "string types are deferred". Pins refreshed. |
| Stale emitter text `EMIT_HIGHER_ORDER (M1)` | `src/emitter.bend`, `Emit.error` | FIXED | Text is now `EMIT_HIGHER_ORDER (deferred)`. No trusted line added. |
| No mutant for a bad milestone label | `dev/stage-a-test.py`, R0-AUDIT-MILESTONE | FIXED | MUTANTS moves from 14 to 15. |
| REFINED-WORD was not a gate leg | `dev/stage-a-gates.py`, `--m2-reconcile` | FIXED | Leg added. `make test` runs it. |
| Default gate mode and leg count in documents | `dev/m2-reconcile-test.py`, 17 documents | FIXED | Each document names `--m2-reconcile` and 110. |
| Deferred refusals without a test | matrix above, four OPEN rows | OPEN | Add a test for each row, or record a ruling. Deviation M2-G8-D2. |
| Artifact boundaries | `dev/trusted-lines.py`, mutant TRUSTED-UNPRICED | OPEN | The kernel and six artifacts have a line budget. The compiler sources `frontend`, `function_abi`, `return_abi`, `event_source` and `string_literal` (4792 lines) have none. The source list is explicit and the mutant is killed. A price needs a USER ruling. |
| Trusted-line budget | TRUSTED-LINES, `dev/trusted-lines.py` | OK | Emitter 1798 of 1800, kernel 3767 of 4000, total 3190 of 3550. Part C added no line. |
| R0 counts | R0-COUNT, R0-AUDIT | OK | Both legs pass. Their five mutants are killed. |
| Denominator pins | `dev/DENOMINATORS.sha256` | FIXED | 327 rows verify. Rows were added for this document and for `dev/m2-reconcile-test.py`. |
| Gate deadlines | `dev/stage-a-gates.py`, `--m2-reconcile` | OK | The 108 carried legs keep their deadlines. In one run REFINED-WORD took 187 s, and the 600-second floor is 3.2 times that. M2-RECONCILE took 4 s against 60 s. |
| Source pins | `dev/native-carry.json`, `dev/carry-check.sh` | FIXED | Pins refreshed for `src/emitter.bend` and `src/kernel.bend`. CARRY reports 16 of 16 files, no difference and no unlisted file. |
| ERC20 reference and ABI provenance | `reference/erc20`, `dev/ABI-PROVENANCE.md` | OK | `MANIFEST.json`, `README.md` and `abi.json` have the hashes of the group 7 record. Part C did not change them. |
| Earlier source record | `dev/validation/2026-10-04-m2-abi/SOURCES.sha256` | OK | 47 of 47 rows verify at commit 0e81531. 38 rows verify now. The nine other files are group 8 edits. |
| Corpus coverage | `corpus/MANIFEST.json` | OPEN | Each of the 11 files in `corpus/contracts` and `corpus/proofs` has a row. No row is an M2 source contract, and no row was added. Deviation M2-G8-D3. |
| Baseline comparers | six `dev/*-compatibility.py` files | OK | None contains `MUTANTS killed`, `13/13` or `14/14`. No marker drift is possible there. |
| Refined Word evidence (R1) | `dev/refined-word-test.py`, `dev/refined-word-data` | OK | Two valid fixtures emit bytes identical to the contracts without the witness. The kernel refuses three fixtures and the emitter refuses one. Four legacy helper cases pass. |

## Limits

- The check is static. Part C did not run the 110-leg battery. That run
  belongs to group 9.
- The test does not require an OPEN row of the matrix. The marker counts
  these rows as `open=4`.
- The corpus audit compared files with manifest rows only. It did not
  compare each M2 feature with a corpus row.
- Part C did not run the M2-ABI leg again and did not compare
  `dev/CARRIED.md` or `dev/ABI-PROVENANCE.md` line by line. The CARRY leg
  and the recorded hashes are the evidence.
- Only the group 7 record has a `SOURCES.sha256` file. Older records use
  other pin formats, and part C did not verify them again.
- Each deadline measurement is one run on one machine.
- The refined Word witness covers width 256 only.

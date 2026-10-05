# M2 ABI group validation

Base commit: `8d33808cd79a9abaf8e2315d4f1051a343aef354`.
The working copy was `/Users/oobi/Documents/gpt1/assay-m2-abi-controls`.
The installed Bend pin was reused through `BEND`, and the build driver
checked its source/cache identity. No toolchain installation was required.

`SOURCES.sha256` pins the final compiler sources, verification package,
fixtures, golden provenance and relevant harnesses. From the repository
root, verify it with:

```sh
shasum -a 256 -c dev/validation/2026-10-04-m2-abi/SOURCES.sha256
```

After `make`, the focused acceptance command is:

```sh
python3 -P dev/m2-abi-test.py
```

The final build, core tests, function ABI, source events, house rules and
M2-ABI passed. `trusted-lines.log` records unchanged source budgets.
The earlier mapping-runtime and ERC20 execution runs passed before the
semantically equivalent exhaustive-match expansion. Their phase is named
explicitly in `attempts.json`; final M2-ABI rechecks the mapping classifier.

`summary.json` records 12 ABI declarations, 16 rejected schema changes,
20 mutability cases, eight rejected Lean witnesses, seven storage mutants,
seven axiom controls and 13 erased theorem symbols. `schedule.json`
records inspection of all 107 preceding gate tuples and the added leg.
That inspection does not claim execution of the full 108-leg schedule.

Review refresh (2026-10-04): the review fixes F1 to F6 changed
`dev/m2-abi-test.py`, `verification/test/AbiControls.lean` and
`dev/stage-a-gates.py`, and the other files that "Review fixes" below
lists. A new duplicate-key control increased
`abi_controls` from 15 to 16, and the expected M2-ABI marker changed
with it. `SOURCES.sha256` pins these files after the fixes.
`m2-abi-final.log` and `summary.json` are the output of
`python3 -P dev/m2-abi-test.py` in the serial rerun after the fixes.
`schedule.json` and `schedule-final.log` were computed again from the
fixed `dev/stage-a-gates.py`; only the added marker changed.
`evidence.tar.gz` and `attempts.json` did not change. Their captures come
from the run before the review, so their M2-ABI output shows
`abi_controls=15`.

`evidence.tar.gz` contains all 21 command captures, including corrected
build, harness and house failures, plus the final M2-ABI working evidence:
emitted artifacts, altered schemas, valid and invalid Lean witnesses,
diagnostics and storage proof controls. Expected Lean rejections are
successful negative checks. Each capture retains its full stdout, stderr
and command manifest. `attempts.json` indexes their exit statuses.

`bytecode-comparison.json` compares the newly emitted runtime and creation
files with the artifacts already present in the primary Assay checkout.
Both pairs are byte-identical. The predecessor files are also in the
archive. This comparison did not rebuild the old compiler.

The full cumulative M2 battery, audit reconciliation and the production
kernel refinement obligation remain open. No gate deadline, expected
marker, axiom allowlist or golden was relaxed.

## Review fixes

A review of this group confirmed six findings. All six fixes are staged.

- F1: `dev/DENOMINATORS.sha256` had stale rows and no rows for the new
  group files, so the fix resealed the stale rows and added rows for
  `dev/m2-abi-test.py`, `dev/M2-ABI-GOLDENS.md` and
  `verification/test/AbiControls.lean`.
- F2: The switch of the default gate to `--m2-abi` broke
  MILESTONE-SPEED, so `dev/milestone-speed-test.py` now pins the M2-ABI
  leg and requires `--m2-abi` at the end of the gate line in
  `dev/gates.sh` and in the `Makefile`.
- F3: `README.md` and the M2 documents still named `--m2-source-erc20`
  with 107 legs as the default gate, so they now name `--m2-abi` with
  108 legs.
- F4: The forged-refinement negative witness was vacuous because Lean
  rejected it only for 256 not equal to 255, so
  `verification/test/AbiControls.lean` now proves that
  `refine .uint8 256` is an out-of-range error and the negative witness
  states the opposite.
- F5: The `jq -S` comparison merged duplicate object keys, so
  `dev/m2-abi-test.py` now also parses each ABI strictly, and a
  sixteenth control with a repeated key must fail.
- F6: The CARRY leg failed because `dev/native-carry.json` did not pin
  the changed `src/event_source.bend` and `src/frontend.bend`, so the
  fix updated these two pins.

The fixes changed these repository files: `dev/m2-abi-test.py`,
`dev/stage-a-gates.py`, `verification/test/AbiControls.lean`,
`dev/milestone-speed-test.py`, `dev/native-carry.json`,
`dev/DENOMINATORS.sha256`, `dev/M2-ABI-GOLDENS.md`, `README.md`,
`dev/ASSAY-M2-BUILD-LOG.md`, `dev/MILESTONE-GROUPS.md`,
`dev/LEXER-DIRECT.md`, `dev/M1-BEND2.md`, `dev/M1-CLOSE.md`,
`dev/M2-ABI-CODEC.md`, `dev/M2-ABI-SCHEMA.md`,
`dev/M2-EVENT-DECODE.md`, `dev/M2-MAPPING.md`, `dev/M2-PACKING.md`,
`dev/M2-REFERENCE.md`, `dev/M2-RETURN-ABI.md`,
`dev/M2-REVERTDATA.md`, `dev/M2-SOURCE-ERC20.md`,
`dev/M2-SOURCE-EVENTS.md` and `dev/M2-STORAGE-PROOFS.md`. In this
record, they changed `SOURCES.sha256`, `summary.json`,
`m2-abi-final.log`, `schedule.json` and this `README.md`, and they
added `review-rerun.log`.

After the fixes, a serial rerun on the staged tree ran these 18 steps:
`build`, `m2-abi`, `function-abi`, `event-source`, `erc20-source`,
`return-abi`, `mapping-runtime`, `mapping-source`, `storage-proof`,
`speed`, `house`, `carry`, `r0-audit`, `trusted`, `denominators`,
`bend2`, `record` and `diffcheck`. All 18 steps passed with exit
status 0. `review-rerun.log` keeps the final run block, with the exit
status, time, peak memory and last output line of each step. The
`denominators`, `bend2` and `record` steps are `shasum -a 256 -c`
checks of `dev/DENOMINATORS.sha256`, `dev/BEND2.sha256` and
`SOURCES.sha256`, so their log line shows only the last checked file.
The `diffcheck` step is `git diff --cached --check`, which prints
nothing when it passes. The full 108-leg battery was NOT run.

After the rerun, a script regenerated `SOURCES.sha256`. All 45 rows
that the `record` step checked matched the staged files and did not
change. Two new rows pin `dev/milestone-speed-test.py` (the harness
that pins the M2-ABI leg) and `dev/native-carry.json` (the carry
manifest), because the fixes changed them. `summary.json` equals the
summary of the final rerun; `abi_controls` (15 to 16) is the only
count that changed.

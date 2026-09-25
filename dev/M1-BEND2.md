# M1 Bend 2 compilation comparison

The 2026-09-22 compilation-speed requirement is an Assay/Bend 2 ratio at
most 1.0. The current native Bend comparison is 1.727570573 and does not
pass. See [M2-PACKING.md](M2-PACKING.md) for the current source and record.

The pre-migration codec comparison passed: 40.444959 ms for Assay and
550.161042 ms for Bend 2 per six-file batch, giving a ratio of 0.073514764.
Five measured rounds completed in a 3.319-second window. These are elapsed
compilation times on one machine, including process startup. No time is
subtracted and no line-count normalization is applied.

## Scope and correspondence

`corpus/bend2/MANIFEST.json` pairs six existing Assay seed programs with
Bend sources. It pins both inputs, Assay's five expected output hashes,
the expected result, and all 76 Bend compiler/runtime source files used
by the pinned build. The original `corpus/MANIFEST.json` is unchanged.

| Pair | Checked computation | Result |
| --- | --- | --- |
| Return | Literal return | 37 |
| Arithmetic | Apply multiplication by two to 21 | 42 |
| Pair | Project the second component of (3, 4) | 4 |
| Leaf | Pass a witness to an erased parameter | 42 |
| Apply | Apply proof identity before passing the erased argument | 42 |
| Let | Bind and apply proof identity before passing the erased argument | 42 |

All six programs are closed, pure returns with no storage changes. Their
values fit Bend's `U32` and Assay's 256-bit result word. Bend uses its normal
`import Base`; loading and checking that library are included. Assay uses
the protocol declarations already present in its seed sources. Bend's
`EvmOpcodes` is an inhabited witness type; Assay's corresponding witness
is an axiom. These three cases exercise erased argument shapes, not
equivalence of the two proof systems.

This is a frozen comparison of the shared pure subset. It does not measure
stateful contract dispatch, large modules, native-code optimization, or
execution throughput. The separate M1 functional gates still cover the
counter, storage, guards, ABI, source proofs, and Cancun execution.

## Reproduction

The upstream is [bendlang/bend](https://github.com/bendlang/bend/tree/c65bcb788dbfb298bb434c1d858b47c193841dc0),
tag `v2.0.25`, commit `c65bcb788dbfb298bb434c1d858b47c193841dc0`.
Use Bun 1.3.11, Node.js v23.10.0 exactly (the ratio harness pins it),
Python 3.11 or newer, and a C compiler (`cc`) on PATH.
No global Bend installation is required.

```sh
git clone --depth 1 --branch v2.0.25 https://github.com/bendlang/bend.git ../bend2-v2.0.25
python3 -P dev/bend2-ratio.py --measure NEW.json --bend-root ../bend2-v2.0.25
```

The harness checks the pinned source hashes and versions, builds
`_build/bin/assay`, and builds Bend's standalone CLI with
`bun build --compile --minify bend2/main.ts --outfile bin/bend`. It records
both executable hashes, the build tools, the host and load, source hashes,
all individual samples, and validated output hashes. It checks source and
tool identities again after timing. `BEND_NO_TELEMETRY=1` disables Bend's
daily network check equally for the warm-up and measured invocations.

Each interval starts before launching one compiler process. Assay runs
`emit SOURCE -o DIRECTORY` through closing its five files. Bend runs
`SOURCE -o main.c` through closing the emitted C file. Invoking a native
C compiler is excluded from the Bend timing. There is one full warm-up,
then five rounds alternating which compiler runs first. Inputs remain
warm; every invocation gets fresh output paths, with no incremental
compile cache. The ratio is the median of the five Assay batch totals
divided by the median of the five Bend batch totals.

Outside the timing intervals, all Assay outputs must match the existing
frozen hashes. Each warm-up C output is compiled and executed, and must
return the paired expected value. Every measured C output must match that
validated output's hash. Both compiler processes must exit successfully.
The measured window must include all timed intervals and remain below
60 seconds. Rejected windows are retained under a rejected filename.

## Freeze and gate

`dev/measurements/2026-09-25-m2-packing-bend2.json` retains the current
native measurement; `dev/validation/2026-09-22-m2-abi-codec/bend2-baseline.json`
retains the pre-migration codec measurement. `dev/bend2-baseline.json` is
the active native copy. `dev/BEND2.sha256` seals the
active report, and `dev/DENOMINATORS.sha256` also pins the new gate, the
active report and the corpus files; the record's `FILES.sha256` seals the retained copy. A compiler, method, or
workload change requires a fresh measurement and an explicit freeze of the
new report. Measurement never overwrites an existing report or updates the
active freeze automatically.

`python3 -P dev/bend2-ratio.py` enforces the unrounded ratio <= 1.0.
`--m0` validates the same evidence and reports the ratio informationally.
The BEND2-RATIO leg in `dev/stage-a-gates.py` also requires
`informational=false` on the row before the OK marker, so an informational
run cannot pass the leg.
The 77-leg `--m1-close` battery replaces the two historical OCaml M1 ratio
legs with `BEND2-RATIO` and `BEND2-RATIO-TEST`. It also includes the
NATIVE-MAPS and NATIVE-IO checks. OCaml measurement tools and their
archived results remain available as diagnostics. The native default adds
the [M2 reference gate](M2-REFERENCE.md), [ABI-SCHEMA](M2-ABI-SCHEMA.md),
[ABI-CODEC](M2-ABI-CODEC.md) and [packing](M2-PACKING.md), for 81 checks.

`dev/bend2-ratio-test.py` passes three controls, rejects 37 invalid cases,
and kills six mutations. It covers the inclusive boundary, a ratio above
the bound that rounds to 1.0, stale identities, missing and altered seals,
tool and source pins, round order, sample count, non-finite values, window
limits, output agreement, and duplicate JSON keys. Synthetic test reports
provide decision coverage only; the measured report supplies timing data.

### Review round 2026-09-22 (M1 Bend 2 compilation comparison)

A-1 (medium): the seal-refusal step of `dev/bend2-ratio-test.py`
accepted any `BEND2-RATIO FAIL` prefix, so a harness whose REPORT-SEAL
check was deleted or inverted still passed the step; now each seal case
names its refusal reason (`dev/BEND2.sha256` for the missing seal,
`BEND2-REPORT-SEAL` for the altered seal) and the test requires that
reason in the output.

B-1 (medium): the synthetic report builder gave every round and every
sample the same value, so the median-of-batch-totals aggregator was
unverified and median-to-mean, median-to-first-round and sum-to-max
mutations survived; now the five rounds scale by 0.5, 0.8, 1.0, 1.5 and
3.0 with unequal samples, the median round carries the exact ratio, and
two mutations (median to mean, sum to max) join the list, which grows
from four to six.

B-2 (medium): the refusal list proved only the empty case for ROUNDS and
nothing for the report version, the method rounds or an extra sample
series; now it refuses version 2, method rounds 4, an added `native`
sample series and reports with four and six rounds, so the refusal count
rises from 32 to 37. The expected row in `dev/stage-a-gates.py` and this
document read `controls=3 refused=37 mutants=6 OK`; the record leg log
keeps the pre-fix row as evidence.

C-1 (medium): `dev/M1-CLOSE.md` described M1-RATIO and M1-RATIO-TEST in
the present tense as the legs `dev/gates.sh` selects, and the README
linked the compact assembly record without saying that its M1-RATIO rows
are historical; now the closure paragraphs are in the past tense and
point here, and the README marks that record as a 2026-09-21 one.
`dev/M1-COMPACTION.md` is unchanged; its rows 62-63 are historical.

A-2 (low): the BEND2-RATIO OK marker row was identical in binding and
informational mode, so the expected row of the leg could not tell them
apart; now the leg in `dev/stage-a-gates.py` also requires
`informational=false` on the row before the marker.

B-3 (low): `dev/measurements/2026-09-22-m1-bend2.json` was the only
tracked measurement file without a `dev/DENOMINATORS.sha256` row; now
the row is present and the file has 137 rows.

D-1 (low): the record README narrated a passing `--m0` run and a refused
overwrite that no record file captures; now it says that both were
exercised outside the record and gives the command that reproduces the
informational report.

These edits came after the validation record. `SOURCES.json` in the
record keeps the pre-fix digests of the edited inputs by design, and the
record leg logs and json files are evidence, never edited.

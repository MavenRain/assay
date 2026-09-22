# M1 closure validation, 2026-09-21

Starting commit: `ec27e6f`. M1 remains open on R3: the active compiler
ratio is 1.956099 against the required limit of 1.0. The gate refuses it.

## Results

| Check | Result |
| --- | --- |
| DENOMINATORS | Pass, 122 protected paths |
| M0-RATIO | Pass, informational |
| M1-RATIO | Fail, RATIO-BOUND |
| M1-RATIO-TEST | Pass, 5 controls, 15 refusals, 4 source mutation witnesses |
| F-MUTANTS | Pass, 7 mutations and 5 controls |
| HOUSE | Pass |
| GATE-COMPATIBILITY | Pass, 44 historical modes and 3 failure-classification probes |

`FOCUSED.json` records commands, deadlines, markers, exit codes and elapsed
times. Each named log has its corresponding stderr file. `FOCUSED.log`
and `FOCUSED-CAPTURE.json` retain the outer run. The seven-check run exits
1 because M1-RATIO fails. The active report and its dated copy are identical.

## Measurement evidence

Both measurements use one warm round, five interleaved measured rounds,
the unchanged frozen corpus and a strictly less than 60-second window.
There is no fixed-cost subtraction. The first report is
`../../denominators-m1-2026-09-21.json`; the second and active report is
`../../denominators-m1-2026-09-21-02.json`.

| Attempt | Window seconds | Ratio | Starting load | Outcome |
| --- | ---: | ---: | ---: | --- |
| 01 | 18.560 | 1.163762 | 14.57 | Valid window, misses R3 |
| 02 | 44.217 | 1.956099 | 32.99 | Valid window, misses R3 |

`MEASURE-01` and `MEASURE-02` retain both measurement captures. `RATIO-01`
retains the first refusal. The second measurement follows a correction
to the failure-label prefix in `ratio.py`; the measured compiler sources
and timing method are unchanged. No further timing attempts were made.
The timing captures and focused checks were launched from an external
working directory (the `cwd` rows of `MEASURE-01.json`, `MEASURE-02.json`,
`RATIO-01.json`, `FOCUSED-CAPTURE.json` and `PARTIAL.json`) against this
repository root, which `dev/ratio.py` resolves from its own path; the
dated reports were copied in byte-identical.
`diagnose-startup.py` and its JSON contain a separate startup diagnostic sample,
not a performance result. They compare a no-op process, spec-count, check
and emit, with child CPU accounting. No compiler optimization is claimed.

`denominators-before.json` and `DENOMINATORS-before.sha256` preserve the
previous active state. The replacement manifest retains every existing
old path and explicitly migrates the deleted wrapper entry (replaced by
`dev/dune.sh` in commit `4836427`). It also covers the
new gate and measurement reports. `freeze-m1-snapshot.py` records the
snapshot generation recipe.

## Functional evidence reuse

The default rerun completed 38 passing checks before it was explicitly
cancelled. `PARTIAL.json` records interruption with exit 143; `PARTIAL.log`
and `PARTIAL-GATE-LOGS.tar.gz` retain its output and completed leg logs.
It is not a successful full 75-check run.

The compiler and existing feature tests are unchanged. `REUSED-SOURCES.json`
pins the prior address validation's 275-input manifest and records 272
exact matches. Only `dev/gates.sh`, `dev/ratio.py` and
`dev/stage-a-gates.py` differ. The new gate tests, measurements and metadata
checks cover those changes. The prior [complete functional evidence](../2026-09-21-m1-address/README.md)
is reused, including its successful HEX-LITERALS and HOUSE repair reruns.
No missing new validation is described as a fresh full-suite pass.

## Reproduction

From the repository root:

```sh
python3 -P dev/ratio.py --m1
python3 -P dev/m1-ratio-test.py
python3 -P dev/corpus-test.py mutants
python3 -P dev/validation/2026-09-21-m1-close/gate-compatibility.py \
  dev/validation/2026-09-21-m1-close/gates-before.py dev/stage-a-gates.py
zsh -f dev/gates.sh
```

The ratio command and default battery must fail while the frozen ratio
exceeds 1.0. A fresh timing attempt runs `zsh -f dev/dune.sh build` and
then `python3 -P dev/ratio.py --measure-m1 NEW_JSON`, followed by a new
frozen checksum snapshot. The gate checks the compiler source inventory
and records the executable hash, but it does not check that the timed
executable was built from that inventory.
`FILES.sha256` protects this evidence; `VALIDATED-SOURCES.json` records
the final source identities used for the focused checks and reuse audit.

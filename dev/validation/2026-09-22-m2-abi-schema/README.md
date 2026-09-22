# M2 typed ABI validation

Base: `6cb76ea`. All 77 checks are validated across two runs.
`default-gates.log` records 76 passing legs and one AXIOMS failure for a
missing preprovisioned dependency. That full process exited 1, and its
failure marker is preserved. After locally cloning both Lean packages
at their manifest revisions, `axioms-rerun.log` records the identical
AXIOMS command passing with exit 0, zero sorries and 42 theorem reports.
No tracked source changed between those two runs.

`focused-gate.log` records the typed ABI comparisons and eight compiling
mutation kills. `GATE-COMPATIBILITY.json` records 46 preserved earlier
modes and four failure-classification controls. `gates-before.py` is the
gate driver from the base commit. The compatibility script is retained as
the transcript of the run in the isolated clone
`/Users/oobi/Documents/gpt1/assay-m2-abi` (its `ROOT` on row 7); a rerun
needs that path replaced by the tree under test.

The compiler build and both fresh measurements have complete capture
manifests, stdout and stderr. `bend2-baseline.json` matches the active
measurement. The Assay/Bend 2 ratio is 0.070826341, below the 1.0 bound.

`GATE-LOGS.tar.gz` contains the 77 leg logs of the first full run; its
`AXIOMS.log` is that run's failing log and `axioms-rerun.log` is the passing
rerun. `ABI-CAPTURES.tar.gz` retains the schema output (`control.json`,
`emitted.json`), the eight mutant witness logs, the measurement twins
(`bend2-baseline.json`, `denominators.json`, `BEND2.sha256`,
`DENOMINATORS.sha256`), copies of `gates-before.py` and
`GATE-COMPATIBILITY.json`, an earlier README draft (`archive-readme.md`),
a copy of the build log (`build-log.md`) and a `__pycache__` bytecode file
from the compatibility run; `ERC20-CAPTURES.tar.gz` retains the reference
execution evidence.
`SOURCES.json` pins validated inputs. `FILES.sha256` seals this archive.

The `diagnostic-*` captures retain the earlier jq invocation error,
measurement attempted before the main executable was built, and the
interrupted gate run whose PATH omitted rg and leancho. They are not
passing validation records.

The schema adapter authors ERC-20 declarations directly. Source lowering,
runtime ABI encoding and the remaining M2 proof obligations are pending.

The initial jq diagnostic stdout is compressed to preserve its exact
trailing blank line while keeping Git whitespace checks clean.

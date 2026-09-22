# M1 closure

Status: the current R3 speed gate passes. The requirement, set by the
user on 2026-09-22, is compilation speed at least as fast as Bend 2.
The [frozen paired comparison](M1-BEND2.md) measures a ratio of 0.070826341
against the 1.0 limit. The four retained OCaml measurements below are
historical diagnostics.

This historical slice starts at `ec27e6f`. It implements the former OCaml
performance gate and brings the existing M1 implementation under one battery.
It adds no language feature or trusted compiler line.

The ratified M1 design requires a bounded counter, dispatcher, ABI and
layout output, contract surface syntax, and differential agreement with
the hand-assembled counter. The existing gates cover those requirements:

| Requirement | Gates |
| --- | --- |
| Hand-assembled reference, nonzero-limit success and failure calldata | COUNTER-REFERENCE |
| Emitted counter, dispatcher, ABI and layout | M1-EMISSION |
| Contract, storage, entry and do syntax | CONTRACT-SURFACE |
| Storage, return and revert agreement through geth run and Cancun t8n | DIFF-EXECUTOR, M1-EMISSION, CONTRACT-SURFACE |
| Source execution and overflow-freedom theorem | SOURCE-MODEL, SOURCE-PROOFS |
| R3 compilation speed at least as fast as Bend 2 | BEND2-RATIO, BEND2-RATIO-TEST |

The counter gates exercise 30 calldata/prestate rows, exceeding the
eight-row milestone requirement. The two executors are geth entry points.
The source-model proof does not prove the OCaml compiler correct.

## Performance contract

Assay must compile at least as fast as Bend 2. This replaces all previous
milestone compilation speed requirements. Compare parse through emit,
ending at the five files on disk, on equivalent frozen workloads with
pinned toolchains, the same machine and matched cache conditions. Require
an Assay/Bend 2 compilation-time ratio <= 1.0. Speed is informational at
M0 and binding from M1 onward. A measured Bend 2 comparison is required
to close the speed requirement; no existing OCaml report can do so.

The [Bend 2 comparison](M1-BEND2.md) supplies the paired corpus, pinned
toolchains, complete compilation intervals, output validation, frozen
measurement and refusal tests. The 75-leg `--m1-close` battery uses its
two gates in place of the former OCaml M1 ratio legs. The comparison's
scope is six closed pure programs; stateful M1 behavior retains its
separate functional gates.

## Historical OCaml measurement tooling

The tools below retain the former comparison for diagnostics. Their OCaml
thresholds no longer bind milestone completion. The Bend 2 gate above
validates the current R3 requirement.

`python3 -P dev/ratio.py --m1` validates the frozen report and then enforces
the unrounded comparison between contract and native-OCaml milliseconds
per thousand lines. A ratio of exactly 1.0 passes; any larger ratio fails.
It also requires an M1 report and an exact inventory of current compiler
source hashes, including newly added files. Historical M0 reports cannot
close M1. The original invocation remains informational. The gate checks
the compiler source inventory and records the executable hash, but it
does not check that the timed executable was built from that inventory;
run `zsh -f dev/dune.sh build` immediately before `--measure-m1`.

The historical corpus and measurement method use eight contract programs,
three separately reported proof programs, and the frozen 24-file OCaml
reference. There is one warm round followed by five interleaved measured
rounds, with a strictly less than 60-second wall-clock window. Each assay
compile writes and validates all five output files. `ocamlc` and the fixed
invocation cost remain reported, with no subtraction. The bound applies
to this frozen corpus, not to every possible source program.

The latest window took 9.337 seconds. The dated report is
[`denominators-m1-2026-09-21-04.json`](denominators-m1-2026-09-21-04.json), with
an identical active copy at `denominators.json`. The initial closure archive
is retained under `validation/2026-09-21-m1-close/`. The compaction follow-up
and its preceding checksum list are under `validation/2026-09-21-m1-compaction/`.
Compiler, corpus and measurement identities are checked before and after
measurement. No existing dated measurement is overwritten.

| Attempt | Window seconds | Assay ms/kloc | ocamlopt ms/kloc | Ratio | Starting load |
| --- | ---: | ---: | ---: | ---: | ---: |
| 01 | 18.560 | 489.814 | 420.889 | 1.163762 | 14.57 |
| 02 | 44.217 | 2133.327 | 1090.603 | 1.956099 | 32.99 |
| 03, baseline | 10.958 | 451.684 | 272.959 | 1.654772 | 17.73 |
| 04, active | 9.337 | 363.756 | 247.618 | 1.469021 | 9.83 |

The compiler sources are identical in attempts 01 and 02. The script change
between them corrects the M1 failure label. Attempt 03 measures the committed
baseline, and attempt 04 includes [compact assembly](M1-COMPACTION.md).
Their host loads differ, so these wall-time changes do not isolate the
effect of the optimization. The measurement script and corpus are unchanged.
Startup diagnostics are
retained as diagnostic evidence, not as a substitute for R3 validation.

## Bend 2 validation

The [2026-09-22 archive](validation/2026-09-22-m1-bend2/README.md) records
all 75 checks. Seventy passed in the default run; five failed because its
PATH omitted `rg` and `leancho`. All five passed with the complete tool
PATH. Both Bend 2 legs passed in the full run. The archive retains the
initial failures, successful rechecks, source hashes and full output.

## Historical closure validation

The 2026-09-21 closure run selected `--m1-close`, then the 73-leg address
battery plus M1-RATIO and M1-RATIO-TEST. The compatibility check compared
commands, deadlines and markers for the 44 historical modes and probed the
failure class of the three `--m1-close` legs only. The historical M0/M1
classes were unchanged because the scheduler change only added rows under
`--m1-close`. The two ratio legs were classified as M1 failures. The M0
ratification message remained. Since 2026-09-22 `--m1-close` runs the
same battery with BEND2-RATIO and BEND2-RATIO-TEST in their place (see
[M1-BEND2.md](M1-BEND2.md)). The default wrapper now appends the
[M2 reference gate](M2-REFERENCE.md) and [ABI-SCHEMA](M2-ABI-SCHEMA.md), for 77 checks.

That ratio test used synthetic reports to exercise the public command; these
were decision tests and provided no timing evidence. It checked the
inclusive boundary, rejection despite six-decimal rounding, informational M0
behavior, report identities, source changes and additions, invalid windows,
rejected reports, summaries, command timings and frozen checksums. Four
source mutations removed dispatch enforcement, the bound, source identity
checking and the M1-report requirement. Each admitted a report that the
restored gate refused. A final restored boundary control passed.

The initial closure archive records 38 fresh passes from an interrupted default
run, focused closure checks, and gate compatibility. The prior full
functional evidence is reused after comparing its 275 pinned inputs:
272 match exactly, and only `dev/gates.sh`, `dev/ratio.py` and
`dev/stage-a-gates.py` changed. The archive records this comparison.
A green `STAGE-M1-CLOSE` validates these implementation requirements;
it does not create a commit or a user ratification record.

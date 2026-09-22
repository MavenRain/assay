# M1 closure

Status: M1 remains open. The final measured ratio is 1.956099 against
the R3 limit of 1.0. Both retained measurement attempts miss the bound.
The remaining milestone work is a passing measurement under the same
frozen corpus, one-minute window and five-round protocol.

This slice starts at `ec27e6f`. It completes the performance gate required
by R3 and brings the existing M1 implementation under one default battery.
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
| R3 compiler wall-time ratio at most 1.0 | M1-RATIO |

The counter gates exercise 30 calldata/prestate rows, exceeding the
eight-row milestone requirement. The two executors are geth entry points.
The source-model proof does not prove the OCaml compiler correct.

## Performance contract

`python3 -P dev/ratio.py --m1` validates the frozen report and then enforces
the unrounded comparison between contract and native-OCaml milliseconds
per thousand lines. A ratio of exactly 1.0 passes; any larger ratio fails.
It also requires an M1 report and an exact inventory of current compiler
source hashes, including newly added files. Historical M0 reports cannot
close M1. The original invocation remains informational. The gate checks
the compiler source inventory and records the executable hash, but it
does not check that the timed executable was built from that inventory;
run `zsh -f dev/dune.sh build` immediately before `--measure-m1`.

The corpus and measurement method are unchanged: eight contract programs,
three separately reported proof programs, and the frozen 24-file OCaml
reference. There is one warm round followed by five interleaved measured
rounds, with a strictly less than 60-second wall-clock window. Each assay
compile writes and validates all five output files. `ocamlc` and the fixed
invocation cost remain reported, with no subtraction. The bound applies
to this frozen corpus, not to every possible source program.

The final window took 44.217 seconds. The dated report is
[`denominators-m1-2026-09-21-02.json`](denominators-m1-2026-09-21-02.json), with
an identical active copy at `denominators.json`. The previous report and
checksum list are retained under `validation/2026-09-21-m1-close/`.
Compiler, corpus and measurement identities are checked before and after
measurement. No existing dated measurement is overwritten.

| Attempt | Window seconds | Assay ms/kloc | ocamlopt ms/kloc | Ratio | Starting load |
| --- | ---: | ---: | ---: | ---: | ---: |
| 01 | 18.560 | 489.814 | 420.889 | 1.163762 | 14.57 |
| 02, active | 44.217 | 2133.327 | 1090.603 | 1.956099 | 32.99 |

The compiler sources are identical in both attempts. The script change
between them corrects the M1 failure label. Startup diagnostics are
retained as diagnostic evidence, not as a substitute for R3 validation.

## Validation

`zsh -f dev/gates.sh` selects `--m1-close`, the 73-leg address battery plus
M1-RATIO and M1-RATIO-TEST. The compatibility check compares commands,
deadlines and markers for the 44 historical modes and probes the failure
class of the three `--m1-close` legs only. The historical M0/M1 classes
are unchanged because the scheduler change only adds rows under
`--m1-close`. The new legs are classified as M1 failures. The existing
M0 ratification message remains.

The ratio test uses synthetic reports to exercise the public command;
these are decision tests and provide no timing evidence. It checks the
inclusive boundary, rejection despite six-decimal rounding, informational
M0 behavior, report identities, source changes and additions, invalid
windows, rejected reports, summaries, command timings and frozen checksums.
Four source mutations remove dispatch enforcement, the bound, source
identity checking and the M1-report requirement. Each admits a report that
the restored gate refuses. A final restored boundary control passes.

The validation archive records 38 fresh passes from an interrupted default
run, focused closure checks, and gate compatibility. The prior full
functional evidence is reused after comparing its 275 pinned inputs:
272 match exactly, and only `dev/gates.sh`, `dev/ratio.py` and
`dev/stage-a-gates.py` changed. The archive records this comparison.
A green `STAGE-M1-CLOSE` validates these implementation requirements;
it does not create a commit or a user ratification record.

# M2 function ABI source integration validation

M2 group 2 adds typed source parameters and opaque dynamic string calldata.
See [source function calldata](../../M2-FUNCTION-ABI.md) and
[FunctionCalldata.asy](../../../examples/FunctionCalldata.asy).
M2 remains open. The complete 103-leg battery was not run.

The final native build uses the pinned Bend 2.0.32 compiler at
`573002f01ec6c52416d44489543f69a9625facf8` through `BEND`.
[RESULTS.json](RESULTS.json) records the compiler hash, the hash of the built
program `_build/bend/assay.js`, the build input hash, the hash of the `assay`
launcher, final source hashes, command captures and each check's revision
scope. Full stdout, stderr and capture manifests are archived alongside this
file.

| Check | Result |
| --- | --- |
| Native build | Assay built; unchanged tests and backends reused |
| Function ABI | 47 calldata cases, one typed mapping program, three size-cap checks, two collision refusals and 12 source refusals |
| Native tests | 18 adapters and 24 commands |
| Mapping runtime | 40 live cases, 27 refusals, constructor and layout checks |
| Packed source | 66 cases and all six compiled mutants |
| Public calldata CLI | 53 encodings, 55 decodings, 196 refusals and two pin mutants |
| Schedule | 57 historical schedules and nine controls; the new schedule equals all 102 carried legs plus mandatory FUNCTION-ABI |
| House, carry, R0 and trusted lines | Passed; carry has 13/13 files, no drift or unlisted files; the trusted-line audit admits src/function_abi.bend without a budget |
| Denominators | All 305 rows match |

Function encodings come from `cast`. The model, geth run and Cancun t8n agree
on ordinary valid and invalid calls. Cap cases use the model and geth run,
including the largest canonical string accepted below the 131072-byte limit.
Source type refusals cover `check`, `emit` and `run`. Two independently pinned
function names with selector `45534f82` are refused by emission and the model.

The table reports the `review-*` captures. All of them ran on the final staged
tree after the review fixes. The final build output `_build/bend/assay.js` has
SHA-256 `68032dc4e1865bf6125120563843de7359ec1f61bc4dc9164d28b20c396b16db`.
RESULTS.json keeps the original captures. Revision `pre-review` marks a
capture of the tree before the review fixes. Revision `earlier-in-change`
marks the original native, mapping, packed and public CLI captures, which ran
on an earlier build in this change sequence.

The retained failed collision-test attempt omitted emit's required output path;
the corrected test passed. The first CALLDATA-CLI run failed its compatibility
pins. Four pins in dev/cli_delta.py (Cli.run, Case.Packed.switch_35,
Case.Packed.switch_38, Cli.Packed.read_file) were updated for the function ABI
plan and the new Cli.run input order. The record keeps that run as
`attempt-calldata-compatibility`. Other resolved checks caught the model's hex-to-byte
adapter and the emitter's inclusive Uint8 bound before final validation.

Review covered canonical offsets, tail order, padding, exact tuple size,
scalar bounds, scratch memory placement, selector uniqueness and preservation
of legacy source plans. No carried gate, marker, deadline, required mutant or
trusted artifact limit was removed or relaxed. The trusted-line audit now
admits src/function_abi.bend without a budget. No artifact budget counts this
emitter instruction code. The catch-all manifest changes only existing line
coordinates, with every arm digest and rationale preserved.

## Review

A second review found seven defects. Each row names the fix and its evidence.

| Finding | Change | Evidence |
| --- | --- | --- |
| F1 | dev/DENOMINATORS.sha256 has current rows for all changed files and new rows for the four new slice files. | [review-denominators](review-denominators.stdout.log) |
| F2 | RESULTS.json names the program, input and launcher hashes. The four regressions ran again on the final build. The failed CALLDATA-CLI attempt is archived. | [native](review-native-tests.stdout.log), [mapping](review-mapping-runtime.stdout.log), [packed](review-packed-source.stdout.log), [CLI](review-calldata-cli.stdout.log), [attempt](attempt-calldata-compatibility.stderr.log) |
| F3 | A String parameter scope ends at each top-level declaration. Three sources reuse the name in a later error, predicate or invariant. | [review-function-abi](review-function-abi.stdout.log) |
| F4 | Typed sources keep the source line and column. Two pairs compare typed and Word diagnostics. | [review-function-abi](review-function-abi.stdout.log) |
| F5 | The suite adds one valid trailing-byte case and three string padding refusals. The pinned summary is `cases=47`. | [review-function-abi](review-function-abi.stdout.log), [review-schedule](review-schedule.stdout.log) |
| F6 | The feature page and this record state that src/function_abi.bend has no trusted-line budget. | [review-trusted-lines](review-trusted-lines.stdout.log) |
| F7 | The stage-a-gates.py usage text and 19 dev pages name `--m2-function-abi` with 103 legs as the default. `--m2-mapping-runtime` keeps 102 legs. | [review-schedule](review-schedule.stdout.log) |

The review fixes changed src/function_abi.bend and src/frontend.bend, so the
build ran again. The carry manifest and the catch-all line coordinates match
the final sources ([review-carry](review-carry.stdout.log),
[review-house](review-house.stdout.log),
[review-r0-audit](review-r0-audit.stdout.log)).

Word result ABI and source events remain work for the following M2 groups.

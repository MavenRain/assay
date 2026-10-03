# M2 return and error ABI source integration validation

M2 group 3 adds typed source results and custom error schemas. String payloads
refer to the current entry's String parameters. The checked core continues to
use Word operands. See [the feature guide](../../M2-RETURN-ABI.md) and
[ReturnData.asy](../../../examples/ReturnData.asy).
M2 remains open. The complete 104-leg cumulative battery was not run.

[RESULTS.json](RESULTS.json) records the base revision, final source and
program hashes, pinned compiler revision and command captures. The captures
directory preserves full manifests, stdout and stderr, including earlier
failures. Only captures selected in `final_checks` describe the final source.
Other attempts retain their observed status, including incomplete captures.
The schedule record is a simulation, with no claim that its 104 commands ran.
Five error streams use JSON text wrappers to preserve trailing whitespace
and blank lines exactly while keeping the staged diff clean. Decode the
`text` field as UTF-8; `raw_sha256` verifies the original bytes.

| Check | Result |
| --- | --- |
| Pinned Bend build | Assay built; unchanged tests and backends reused |
| Return ABI | 49 ordinary and cap cases, eight layout and isolated-error cases, 30 source refusals |
| Native tests | 18 adapters and 24 commands |
| Function ABI | 47 calldata cases, mapping, cap, collision and refusal checks |
| Mapping runtime | 40 live cases, 27 refusals, constructor and layout checks |
| Packed source | 66 cases and six compiled mutants |
| Public calldata CLI | 53 encodings, 55 decodings, 196 refusals, two pin mutants |
| Public returndata CLI | 54 encodings, 55 decodings, 176 refusals, two pin mutants |
| Schedule simulation | All 103 carried commands, deadlines and markers unchanged; new mandatory leg; missing marker refused |
| House, carry, R0 and trusted lines | Passed; 14/14 inventory files, no drift; artifact budgets unchanged |
| Denominators | 309 hash rows match; 11 changed rows refreshed and four new feature files pinned; five rows refreshed again after review |

Expected payloads come from cast. The model, geth run and Cancun t8n agree on
all execution fixtures. The duplicated-string cap case uses a bounded local
adapter because its calldata exceeds the shared differential harness domain.
The shared harness limits remain unchanged. The fixture proves rejection when
output duplication exceeds 131072 bytes and verifies storage rollback.

Early compile attempts exposed Bend match and reuse constraints. Unannotated
encoder locals also caused excessive inference cost; explicit local types
fixed it. An attempt was killed during high host load, and a cancelled capture
may retain an incomplete status. The final build uses the unchanged pinned
Bend compiler. Earlier feature runs caught reserved fixture names, an
incorrect refusal exit-code expectation and typed-error activation when all
results were Word. The latter is fixed and covered by isolated scalar and
String error programs. Failed audit attempts also include missing root
arguments, moved catch-all lines and source hashes awaiting refresh.

Capture manifests and schedule-audit.py record the absolute paths of the build clone. The stdout and stderr files beside each manifest are the archived copies. Two build attempts ran without the pinned BEND path and failed before compilation. One attempt named a shell script that does not exist and exited 127.

The three changed CLI declaration pins correspond to Outputs plan routing and
the return ABI source reader. Existing catch-all reasons are preserved.
`src/return_abi.bend` is admitted as unpriced compiler source, following
`src/function_abi.bend`. M2 group 8 still owes boundary review. Source storage
and refinement obligations remain for group 5; source events are next.

## Review

The review of the staged slice found seven defects. All seven are fixed and
none is refuted. The table lists each fix and its evidence.

| Finding | Change | Evidence |
| --- | --- | --- |
| F1 | `dev/milestone-speed-test.py` expects the `--m2-return-abi` default schedule and entry points | `../../milestone-speed-test.py` |
| F2 | The cap fixture is 131076 bytes with the selector and a near-cap case at 131012 bytes passes; the marker is `cases=49` | `captures/review-return_abi/command-0001.stdout` |
| F3 | README.md and ten dev pages name the 104-leg default gate mode | `../../DENOMINATORS.sha256` row for `dev/LEXER-DIRECT.md` |
| F4 | Each refusal leg pins the full message of its rule | `captures/review-return_abi/command-0001.stdout` |
| F5 | This README discloses the build clone paths and the nonzero attempts | `FILES.sha256` |
| F6 | The model run of the cap fixture has a 90 s timeout | `captures/review-return_abi/manifest.json` |
| F7 | The feature guide discloses the scratch cursor at base+131104 and its gas cost | `RESULTS.json` source hash of `dev/M2-RETURN-ABI.md` |

`final_checks` now selects `review-return_abi` and `review-schedule_simulation`.
The original attempts `run-m8iVNk` and `run-fkrxDe` remain in the record. The
review simulation ran [schedule-audit-review.py](schedule-audit-review.py), a
copy of `schedule-audit.py` with the root set to this repository, and
`schedule.json` carries the `cases=49` marker. `schedule-audit-review.py` and
the `review-schedule_simulation` manifest record the absolute path of the
review scratch directory. `launcher_sha256` now pins the local
`_build/bin/assay` built from the staged sources; the earlier value matched no
launcher file. No source file changed, so the program and compiler hashes are
unchanged. `dev/milestone-speed-test.py` joins the source hashes.

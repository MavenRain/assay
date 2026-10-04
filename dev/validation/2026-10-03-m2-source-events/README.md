# M2 source events validation, 2026-10-03

Base: `386f240e1dcca6a829be10edbe1356bfec9286e1`.
Compiler: pinned Bend 2.0.32, commit
`573002f01ec6c52416d44489543f69a9625facf8`.

The source event implementation passes its focused execution and refusal
checks and the preceding function and return ABI integration suites.
The cumulative battery remains incomplete.

| Check | Result |
| --- | --- |
| SOURCE-EVENTS | 34 execution cases, 16 refusals after the review fixes; cast, model, geth and Cancun receipts agree. The pre-review scoped check passed 32 cases and 15 refusals. |
| FUNCTION-ABI | 47 cases, one mapping, three caps, two collisions and 12 refusals pass. |
| RETURN-ABI | 49 cases, eight layouts and 30 refusals pass, including rollback and caps. |
| AXIOMS | 42 theorems, 28 carried files and three controls pass; no sorryAx. |
| HOUSE and TRUSTED-LINES | Pass; trusted artifact bounds remain unchanged. |
| MILESTONE-SPEED | 57 schedules and nine controls pass in a scoped check on the final staged files. The cumulative run did not reach this leg. |
| Frozen checksums | All 313 paths match in the DENOMINATORS leg and in a scoped recheck after dev/milestone-speed-test.py and dev/DENOMINATORS.sha256 changed. |
| Cumulative attempt | 59 legs completed: 56 pass and three time out. INFERRED-GUARD-BINDINGS was running when SIGTERM stopped the run about 4.6 minutes later. The remaining 45 legs were not reached. |

The interrupted cumulative run timed out in INFERRED-GUARDS (128 guards,
30-second emit limit), PROOF-HOLES (nested depth 16, the same command limit),
and INFERRED-BINDINGS (600-second leg limit). The host load average reached
about 89. A clean baseline at the base commit, built with the same pinned
compiler and Node launcher, also exceeded the unchanged 30-second limit on
the exact 128-guard program. An additional 128-hole stress input timed out in
both builds. These controls are preserved in `probes/boundary-comparison.json`.
M2 closure still requires the complete battery under suitable host conditions.

Commands used in the isolated checkout:

```sh
BEND=<pinned Bend 2.0.32, commit 573002f, sha256 in RESULT.json> python3 -P dev/build.py all
python3 -P dev/event-source-test.py
python3 -P dev/function-abi-test.py
python3 -P dev/return-abi-test.py
BEND=<pinned Bend 2.0.32, commit 573002f, sha256 in RESULT.json> zsh -f dev/gates.sh
```

The isolated checkout was /Users/oobi/Documents/gpt1/assay-source-events with
the compiler at /Users/oobi/Documents/gpt1/assay-events-bend/bin/bend. The
`scoped/` SOURCE-EVENTS, FUNCTION-ABI and RETURN-ABI copies and
`gates.manifest.json` are byte-identical archives of those outputs.
`scoped/MILESTONE-SPEED.*` and `scoped/DENOMINATORS.*` are rechecks on the
final staged files in this repository.

`cases.json` contains independent encodings, model outcomes, geth LOG witnesses,
receipt outcomes and evidence hashes. `scoped/` holds the successful integration
outputs. `gates.stdout` and `legs/` retain the interrupted run, including its
failures. `RESULT.json` derives the completed and pending legs from the current
schedule. `SOURCE-HASHES.json` pins the changed source and harness files;
`FILES.sha256` pins this archive.

Two readable logs have trailing blank lines trimmed for the index whitespace
check. Their exact original bytes are preserved in `.raw.gz` copies;
`LOG-NORMALIZATIONS.json` records both hashes and the compressed copy paths.

The prior records retain the repaired branch direction, missing carry checksums,
missing offline proof dependencies, event-data model cap and fixture mistakes.
`prior/proof-before.json` records an invalid invariant program accepted before
the lowering fix and its correctly rejected control. Emission now supplies only
the true claim `Le 0 0`; the invalid program is a refusal regression, and a valid
invariant-preserving emission is an execution case. The event-data suite accepts
exactly 131072 bytes and rejects overflow with storage and log rollback.

Constructor emission is explicitly refused. The compiler source boundary is
documented in `dev/M2-SOURCE-EVENTS.md` for the planned M2 audit; M2 remains open.

## Review

A review of the staged slice fixed six findings. A seventh finding, F6, was
refuted and needed no change. The fixes are staged with the slice. The reruns
in `review/` used the rebuilt program; `RESULT.json`
holds its hash as `assay_js_sha256` and the pre-review hash in
`review_build_note`. `review/RERUNS.json` lists each rerun with its exit code,
duration and output hashes. `review/cases.json` is the final SOURCE-EVENTS
witness set with 34 cases and 16 refusals.

| Finding | Change | Evidence |
| --- | --- | --- |
| F1 | `ReturnAbi.string_blocks` writes a zero word after each copied String. An earlier event tuple leaves no padding bytes in later String encodings. The cases `string-padding-return` and `string-padding-logs` cover the leak. | `review/SOURCE-EVENTS.stdout`, `review/RETURN-ABI.stdout`, `review/cases.json` |
| F2 | `dev/cli_delta.py` pins `Case.Packed.switch_35`, `Case.Packed.switch_38` and `Cli.Packed.read_file` at their source event bodies. The CLI compatibility legs compare the current bundle again. | `review/MAPPING-CLI.stdout`, `SOURCE-HASHES.json` row for `dev/cli_delta.py` |
| F3 | `dev/event-source-test.py` pins a diagnostic for all 16 refusal mutants under `check` and `emit`. The two overflow mutants fail only on the indexed limit. Each variant checks its ABI event rows and mutability. The event cap test pins the first overflow at 43617 bytes. | `review/SOURCE-EVENTS.stdout`, `review/cases.json` |
| F4 | This record archives the scoped outputs under `scoped/`, the run manifest as `gates.manifest.json`, the MILESTONE-SPEED and DENOMINATORS rechecks on the final staged files, and names SIGTERM as the stop cause. | `gates.manifest.json`, `scoped/MILESTONE-SPEED.stdout`, `scoped/DENOMINATORS.stdout` |
| F5 | Eleven dev pages and the `dev/stage-a-gates.py` usage text name `--m2-source-events` with 105 legs as the current default gate mode. | `SOURCE-HASHES.json` rows for the dev pages |
| F7 | Event refusals report the offending token. RESERVED points at the reserved name. Wrong argument counts and String argument errors use the `SURFACE_EVENT` code at the emit token. An event without a parameter list fails at its name. The `bare-event` mutant and pinned diagnostics cover these paths. | `review/SOURCE-EVENTS.stdout`, `review/cases.json` |

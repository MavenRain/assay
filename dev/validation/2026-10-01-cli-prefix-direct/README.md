# CLI prefix validation

The source checkout starts at `356ce95673480c8b6290e9549a3a47153c44933f`.
See [CLI-PREFIX-DIRECT](../../CLI-PREFIX-DIRECT.md) for scope and results.

`cli-prefix.*` captures the passing 2,184-case comparison and nine compiled
mutants. `cli-prefix-report.json` records the predecessor, declaration
pins, output hashes and named mutation witnesses. `BUILD-HASHES.json`
records the generated fixture sources, JavaScript, launchers and outputs
at archive time. These fixtures were freshly compiled for this run.

`native.*` captures the native kernel suite and 24 commands across 18
adapters. Existing build artifacts were copied into the validation
checkout; the normal builder verifies input and JavaScript hashes before
reusing its cache. `followups.*` captures every remaining test-target
command, with actual exit codes in `followup-exits.json`. The check runner
and per-check reports are included. Together these captures cover the
current `make test` commands. `compatibility.*` retains the 56-mode,
93-leg schedule and historical CLI bundle check. `carry.*` and `trusted.*`
retain the native inventory and source-budget verdicts.

`setup-missing-compiler.*`, `harness-inline-match.*` and
`harness-linearity.*` are completed failed attempts. They stopped before
comparing runtime results. The completed passing run follows them.

`measure.*` captures the new six-case, five-round compilation measurement.
`paired-measurement.json` is the active frozen baseline. `ratio.*` records
the expected speed-bound failure at 1.6399085733075094, and
`ratio-controls.*` records its passing refusal and mutation controls.
The full milestone battery and M2 source lowering remain open.

`SOURCE-HASHES.json` pins this slice's source and documentation.
`FILES.sha256` seals the complete record. `dev/DENOMINATORS.sha256`
retains every earlier entry and adds this record and the new gate files.

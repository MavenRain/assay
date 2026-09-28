# M2 typed revert-data validation

This record covers the host codec layered on the staged return-data
slice at `5e00ee7`. Compiler lowering and M2 closure remain pending.

The native suite, all five ABI codec gates, compatibility, house, carry,
source-pin, trusted-line and timing-gate regression checks pass.
The complete 86-leg default battery was not run.

## Codec and compatibility checks

- REVERT-CODEC: 60 independent cast vectors, 40 frozen empty reference
  reverts, 90 production errors, 292 truncated prefixes, 16 adapter
  refusals and 12 compiling mutants killed by named wrong answers.
  The restored scratch build passes all 662 generated cases.
- Native tests: 17 adapters and 23 commands, including the panic payload.
- ABI-CODEC, CALL-CODEC, RETURN-CODEC and EVENT-CODEC: regression gates
  with their existing mutation controls.
- REVERT-COMPATIBILITY and RETURN-COMPATIBILITY: prior schedules and
  the new appended check, with unchanged compiler CLI reachability.
- Preservation: all 53 modes from the original worktree match the build
  copy, and its staged ABI and test sources remain byte-identical prefixes.
- House, carry, denominator hashes and trusted-line bounds remain binding.
  The ABI cap remains 400 lines and the total cap remains 3550 lines.

## Timing limitation

BEND2-RATIO fails its existing 1.0 bound. The frozen five-round paired
report has median batch times of 1582.055583 ms for Assay and 954.464332 ms
for Bend 2, giving a ratio of 1.657532429 over a 13.432-second window.
BEND2-RATIO-TEST passes. The compiler CLI bundle is unchanged; the
separate measurement windows do not establish a feature-related speed
change. No performance threshold or check was relaxed.

## Evidence

`RUNS.json` records commands, exit codes, wall times and complete
capture locations. Every run started in the root of a separate build
checkout, so each `cwd` is `.`. The capture manifests keep their original
absolute paths. Each `seconds` value is the time from the creation of the
capture run directory to the write of its manifest. REVERT-CODEC took
27.607 s and RETURN-CODEC took 29.235 s against their 300 s deadlines.
`$MEASURE` is the output path of the paired measurement, and
`paired-measurement.json` is its byte copy.
`SOURCES.json` pins the reviewed source and validation dependencies.
`$PRESERVATION_CHECK` is an external script that this record does not
retain. `SOURCES.json` pins its SHA-256 under `external`. It compared the
build copy with a saved baseline of the original staged tree and wrote
`preservation.json`.
`FILES.sha256` covers this record, all capture files and the generated
case list. `paired-measurement.json` is the frozen timing report.
`compatibility.json` records the historical gate and compiler comparison;
`preservation.json` records the comparison with the original staged tree.

Builds used the Bend 2 checkout pinned in `dev/toolchain.json`, selected
through `BEND`. `$BEND_ROOT` in `RUNS.json` names that checkout, which
is outside this repository. `cast` supplies independent encoding and selector oracles.
The reference reverts contain empty bytes and test strict selector
rejection. Typed error payloads use cast oracles.

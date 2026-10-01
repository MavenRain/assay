# Trace decimal normalization validation

This slice starts at `7af4b0478d6e1dd23ab98c0b3aa7f9e0d8d25fcd`.
`Trace.value` removes its Series round trip while retaining validation,
lowercasing, hexadecimal spelling and decimal-zero normalization.

`native.*` captures the complete passing `make test` run: the native kernel
suite, 24 commands across 18 adapters, and seven follow-up checks.
`value-report.json` records 872 predecessor comparisons, 872 independent
golden checks, three compiled mutants, and the restored control.
Compatibility retains all 56 predecessor schedules, requires the new
94-leg schedule, and restores the historical CLI bundle byte for byte.

`trace-value.*` captures 36 live integration cases, two funding failures,
and 34 refused inputs. `ratio-controls.*` captures three controls,
37 refusals and six benchmark mutations.

`paired-measurement.json` contains the fresh matched five-round, six-case
measurement and is byte-identical to `dev/bend2-baseline.json`.
The median times are 1631.756500 ms for Assay and 1500.554791 ms for Bend 2,
giving a ratio of 1.087435467 in a 19.595-second host window beginning
2026-10-01 10:50 UTC. `measurement.*` captures the measurement command.
`ratio.*` captures the required speed-bound refusal, exit status 1.
The limit remains 1.0. This measurement does not isolate the change's
speed effect. The full milestone battery and M2 source lowering remain open.

The two `harness-*-failure.*` captures retain completed failed attempts.
They stopped while compiling predecessor fixtures because the initial
literal serializer used unsupported Bend escapes. The corrected serializer
uses the established Unicode escape format; the complete native run passes.
`pre-seal-denominators.log` retains the nine expected mismatches before
the changed source hashes were resealed.

Review changes after this record made the comparison stricter: a run
that writes to standard error now fails, and the unrelated-change check
also fails when the pin refuses the changed bundle. The compatibility
report lists all six appended legs, and the build log gains this slice's
entry. A later run of the changed comparison passes all 872 cases and three
mutants with the output digest and mutant receipts in `value-report.json`.
That run is not archived.

`SOURCE-HASHES.sha256` seals the changed source, integration files and
current performance documentation. `FILES.sha256` seals this complete
record using repository-relative paths. `dev/DENOMINATORS.sha256` retains
its prior scope and adds the new gate, notes and validation files.

# Mapping storage validation

Base: `9e1cbe59a4bf9fb9fabf5715bb4c239b83d7e19a`. `SOURCES.json` pins the
implementation and validation inputs. `FILES.sha256` seals this record.
Commands used the pinned local Bend compiler. Measurements disabled its
telemetry, as recorded by the measurement scripts and logs.

Completed checks:

- Mapping: 102 independent `cast index` comparisons, 10 frozen ERC-20
  balance and allowance locations, 23 refusals, 15 adapter refusals and 12
  compiling semantic mutants. All probes are distinct; the restored control
  passes.
- Native `dev/build.py runtest`: kernel fixtures, 13 adapters and 19 adapter
  commands. `runtest.log` contains the complete output.
- Packed storage: 11 layouts, 1,685 distinct accesses and readbacks,
  40 refusals and 11 killed mutants.
- ABI schema: 9 functions, 2 events, 7 edge declarations, 6 legacy rows
  and 8 killed mutants.
- ABI codec: 48 cast comparisons, 49 vectors, 5 frozen reference values,
  26 refusals, 288 truncation prefixes, 128 fuzz trials and 10 killed mutants.
- Axioms: 42 theorems, zero `sorryAx`, 28 carried files and 3 controls.
- Benchmark validation: 3 controls, 37 refused reports and 6 killed mutants.
- Carry and source audits: 12/12 inventory entries, no changed or unlisted
  entries, layout at 157/250 lines and the trusted total at 2705/3550.
- Gate compatibility: all 49 prior modes retain their commands, deadlines,
  markers and failure classifications. The new mode appends one leg, for 82.
- Isolation: existing packed-layout definitions, the existing test-file
  prefix and the compiler CLI's reachable Bend bundle match the base bytes.

The broad run is intentionally partial. `broad-partial.log` and
`broad-results.json` record 39 reported legs, 37 passing and two failing.
The run ended by cancellation with exit 143 after verifying the unchanged
CLI bundle. Only logs for reported legs appear under `broad/`.

`DENOMINATORS` initially used a seal computed before the new paired-report
seal was written. The final seal was regenerated and the exact checksum
command passes in `focused/denominators.log`. The regeneration happened in
the isolated checkout while the broad run was in progress. It happened after
leg 13 (`DENOMINATORS`, FAIL) and before leg 35 (`M0-RATIO`, PASS). Legs 1
to 13 ran with the stale seal. The `M0-RATIO` pass depends on the
regenerated seal, because that leg runs the same checksum command first.
The broad record has no per-leg timestamps or tree hashes, so it does not
show the exact leg at which the seal changed. `AXIOMS` ran before the
isolated checkout had its ignored local Lean dependencies. The pinned
dependencies were copied from the original checkout and the check passes
in `axioms.log`. Neither initial failure is omitted from the broad log.

The later focused commands and their actual exit codes and durations are
in `focused/runs.json`. Every functional command passes. The paired
performance command fails with ratio 1.4958316416377786 against the
unchanged 1.0 bound; the normalized corpus command passes with 0.660838.
Both fresh measurement reports are retained here. Differences between
timing runs do not establish a mapping-specific performance effect.

This record does not claim a complete pass of the 82-leg default battery,
M1 speed closure or M2 compiler integration. Mapping declarations and
source lowering, events, dynamic ABI lowering and M2 Lean mutants remain
pending.

Focused commands from the repository root:

```sh
python3 -P dev/build.py runtest
python3 -P dev/layout-mapping-test.py
python3 -P dev/layout-packed-test.py
python3 -P dev/abi-schema-test.py
python3 -P dev/abi-codec-test.py
python3 -P dev/proofs-test.py
python3 -P dev/bend2-ratio-test.py
shasum -a 256 -c dev/DENOMINATORS.sha256
python3 -P dev/ratio.py --m1
python3 -P dev/bend2-ratio.py
```

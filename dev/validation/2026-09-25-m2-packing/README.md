# Packed storage validation

Base: `f80689217a7557a7b3bd200f2ed865cde9d59e10`. The implementation and
packing test inputs are pinned in `SOURCES.json`; `FILES.sha256` seals this record.
Commands used the repository's pinned Bend compiler with telemetry disabled.

Completed checks:

- Packing: 11 layouts, 1,685 distinct access/readback cases, 40 refusals,
  11 compiling semantic mutants and the restored control.
- `make test`: kernel fixtures and all 12 adapters, 18 adapter commands.
- ABI schema: 9 functions, 2 events, 7 edge declarations, 6 legacy rows
  and 8 killed mutants.
- ABI codec: 48 cast comparisons, 49 vectors, 5 frozen reference values,
  26 refusals, 288 truncation prefixes, 128 fuzz trials and 10 killed mutants.
- Axioms: 42 theorems, zero `sorryAx`, 28 carried files and 3 controls.
- House and trusted-source audits, all 12 carry inventory entries, and
  all 13 audit mutants. Layout is 111/250 lines; the total is 2659/3550.
- Gate compatibility: all 48 earlier modes preserve commands, deadlines,
  markers and failure classification. The new mode adds one leg, for 81.
- Benchmark validation: 3 controls, 37 refused reports and 6 mutants.

`make-gates-partial.log` is an interrupted broad run, with 44 passing legs
and two failures. `PIN-CARRY` detected the intentional source additions;
the two fingerprints were refreshed after checking that the original layout
body and test-file prefix are byte-identical. The 12-file inventory and
upstream provenance are unchanged. `AXIOMS` lacked the ignored offline
dependencies in the isolated checkout. Local clones at the pinned revisions
were provisioned. Both checks subsequently passed, with separate logs here.

The broad run was stopped after confirming that the production CLI's
reachable Bend bundle is byte-identical to the base. The new packing suite,
final inherited tests and ABI suites were completed separately. This record
does not claim a complete pass of the 81-leg default battery. The archived
broad-leg logs contain only legs actually reported by that run; schedule
simulation output is excluded.

Review fixes changed the packing suite and the packing adapter in
`src/tests.bend`. The suite adds the late-spill and uint256-spill layouts,
the LATE-SPILL and TYPE-DEDUPE mutants, and an arity refusal for a names
list without types. It no longer repeats boolean or readback probes, and it
rejects layout JSON with a repeated key. `packing.log`, `packing.stderr`,
`report.json` and `SOURCES.json` come from the fixed suite.
`packing-mutants.tar.gz` and the other logs predate these fixes. The
tarball holds the nine pre-fix mutant logs.

The current paired performance ratio is 1.727570573 and the normalized
corpus ratio is 1.599478. Both binding commands still fail against 1.0.
The reports, source pins, bounds and refusal controls are retained; the
speed requirement remains open. M2 compiler integration also remains open.

Reproduce the focused checks from the repository root:

```sh
python3 -P dev/layout-packed-test.py
make test
python3 -P dev/abi-schema-test.py
python3 -P dev/abi-codec-test.py
python3 -P dev/proofs-test.py
python3 -P dev/validation/2026-09-25-m2-packing/gate-compatibility.py .
python3 -P dev/validation/2026-09-25-m2-packing/cli-closure.py .
```

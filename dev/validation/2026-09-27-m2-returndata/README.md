# M2 return-data validation

This record covers the typed function result slice on `5e00ee7`.
See [the API and scope](../../M2-RETURNDATA.md).

`RUNS.json` records the commands, exit codes, wall times and retained
capture paths. Each capture includes its original manifest, stdout and
stderr. Every run started in the root of a separate build checkout, so
each `cwd` is `.`. The capture manifests keep their original absolute
paths. Each `seconds` value is the time from the creation of the capture
run directory to the write of its manifest. `.tools/bend` is the local
Bend tool directory of this repository. `$MEASURE` is the output path of
the paired measurement, and `paired-measurement.json` is its byte copy.
`SOURCES.json` pins the relevant source files; `FILES.sha256` seals this
record. `paired-measurement.json` is a byte copy of the
`dev/bend2-baseline.json` that this slice froze. The revert-data refresh
superseded that baseline.

RETURN-CODEC passes with 57 oracle cases, 45 reference cases, 75 errors,
288 truncated prefixes, 13 adapter refusals and ten compiling mutants
killed by named wrong answers. The restored scratch control passes.
`return-codec-cases.json` retains every production query and its expected
answer. `compatibility.json` verifies all 52 historical modes, including
commands, deadlines, expected markers and failure classes. The new
default has 85 checks, and the compiler CLI bundle is unchanged.

The native tests, tuple/calldata/event codec regressions, house rules,
carry, denominator pins, trusted-line bounds and BEND2-RATIO-TEST pass.
The initial adapter build and positive probes are retained alongside
the complete return-codec gate. This is scoped validation; the complete
85-leg default battery was not run.

The binding BEND2-RATIO fails its unchanged 1.0 bound with a refreshed
ratio of 1.667820196 measured over 7.581 seconds. The preceding calldata
report also failed that bound. The unchanged compiler CLI bundle means
these measurements do not identify a return-data-related slowdown.

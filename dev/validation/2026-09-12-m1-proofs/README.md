# M1 source-proof validation

The complete battery passed 41 of 41 legs, ending in `STAGE-M1-PROOFS OK`
and `M0-VALIDATION OK`. `GATES.log` preserves the output and each leg has
its own log. The carried proof seed ran with 42 axiom reports and no skip.

`evidence/` contains the new package build, eleven theorem reports, complete
Lean/OCaml requests and outputs, emitted Cancun executions, malformed-input
refusals, and six named mutations with restored controls. `sources/` inside
it preserves the generated source fixtures. `surface-positions/` contains
the three constructor-position refusals through check, emit and run.
Transient build and output paths in captures may no longer exist.

`SOURCES.json` pins compiler inputs, tests, proof sources and accompanying
documentation. `ARTIFACTS.json` pins all other archive files. The timing
report is `dev/measurements/2026-09-12-m1-proofs.json`; it covers the frozen
M0 corpus and makes no M1 performance claim. The theorem and correspondence
boundaries are specified in `dev/M1-PROOFS.md`.

# M1 surface validation

The complete battery passed 39 of 39 legs, ending in `STAGE-M1-SURFACE OK`
and `M0-VALIDATION OK`. The carried proof gate ran, with 42 axiom reports
and no `sorryAx`. `GATES.log` preserves the battery output, and each leg
has its own log. The source scope and limits are in `dev/M1-SURFACE.md`.

`evidence/` retains the surface model and EVM executions, driver results,
three-way disassembly, constructor probes, output hashes, and mutation
builds, kills and restored controls. Core and reference sources remain
covered by the existing gates. The empty PATH model invocation started
no external process. Temporary source and output paths in the captures
describe the test run and may no longer exist.

`SOURCES.json` pins the compiler inputs, test runners and accompanying
documentation. `ARTIFACTS.json` pins every other file in this archive.
The measurement report is `dev/measurements/2026-09-12-m1-surface.json`;
it covers the frozen M0 corpus and makes no M1 performance claim.

# M1 nullary validation

The complete battery passed 42 of 42 legs, ending in `STAGE-M1-NULLARY OK`
and `M0-VALIDATION OK`. `GATES.log` preserves the output and each leg has
its own log. `RUN.json` records the checkout, base commit and exact command.
The carried proof seed ran with 42 axiom reports and no skip. The source
proof gate also passed its eleven theorem reports and correspondence cases.

`evidence/` contains the new entry cases, emitted Cancun executions,
creation captures, ABI and erasure checks, schema refusals, and three
mutations with restored controls. Transient output paths in captures may
no longer exist. `CACHE.json` records the source-matched carried-proof
cache and pinned dependencies. The new verification package built fresh.

`SOURCES.json` pins compiler inputs, tests, proof sources and accompanying
documentation. `ARTIFACTS.json` pins all other archive files. The timing
report is `dev/measurements/2026-09-12-m1-nullary.json`; it covers the
frozen M0 corpus and makes no M1 performance claim. The accepted schema
and correspondence boundaries are specified in `dev/M1-NULLARY.md`.

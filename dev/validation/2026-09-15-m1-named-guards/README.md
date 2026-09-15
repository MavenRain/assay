# Named guard validation

Base: `f8e4206e13fe732dbc13f1f46d93fefcde1cafc2`.

The default 52-leg battery passes all 50 functional legs. DENOMINATORS
and M0-RATIO retain their existing failures against preserved older
measurements. Timing remains paused. This archive makes no performance
or milestone-exit claim.

`GATES.log` and `legs/` retain the battery and each leg's output.
`RUN.json` records every result and the compiler hash. `CACHE.json`
records the source and pinned dependency checks before reusing proof
artifacts. Both proof gates run in this battery.

`GUARD-CAPTURES.json` retains individual execution, refusal and mutation
captures. `LIVE.json` and `ERASURE.json` summarize 96 execution cases,
two creation outcomes and ten erasure variants. The gate also checks
27 refusals through three commands, six accepted boundaries, and four
built mutants with restored passing controls.

`GATE-COMPAT.json` records the unchanged 51 prior commands, deadlines
and success markers. `FINAL.json` lists preserved source, proof and
measurement paths. `SOURCES.json` hashes the active source tree.
`ARTIFACTS.json` hashes every other file in this archive.

The ratio text log ends with one newline for whitespace checks.
`M0-RATIO-RAW.json` preserves its exact original stdout and SHA-256.

# Inferred guard validation

Base: `4649376468d808f908ea6148f8c40ae7e213a7d7`.

The default 53-leg battery passes all 51 functional legs. DENOMINATORS
and M0-RATIO retain their existing failures against preserved older
measurement inputs. Timing remains paused. No fresh performance result
or milestone exit is claimed.

`GATES.log` and `legs/` retain the battery and each leg's output.
`RUN.json` records every result and the compiler hash. `CACHE.json`
records the 35 source and two pinned dependency checks before reusing
proof artifacts. Both proof gates ran in this battery.

`GUARD-CAPTURES.json` retains execution, refusal and mutation captures.
`LIVE.json` records 112 execution comparisons and two creation outcomes.
`ERASURE.json` hashes all five files for 14 inferred/explicit pairs.
The gate also checks 24 refusals through three commands, six accepted
boundaries and four built mutants with restored passing controls.
`MUTANTS.json` records mutation witnesses and compiler source hashes.

`GATE-COMPAT.json` records the unchanged 52 prior commands, deadlines
and success markers. `FINAL.json` lists preserved source, proof and
measurement paths. `SOURCES.json` hashes active source files, excluding
the vendor and validation directories. `ARTIFACTS.json` hashes every
other file in this archive.

The ratio text log ends with one newline for whitespace checks.
`M0-RATIO-RAW.json` preserves its exact original stdout and SHA-256.

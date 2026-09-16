# Inferred arithmetic validation

Base: `ddeb22c5ce3ea1ceb4a50a7ece3d8ca4a04c1f7e`.

The default 54-leg battery passes all 52 functional legs. DENOMINATORS
and M0-RATIO retain their existing failures against preserved older
measurement inputs. Timing remains paused. No fresh performance result
or milestone exit is claimed.

`GATES.log` and `legs/` retain the battery and each leg's output.
`RUN.json` records every result and the compiler hash. `CACHE.json`
records the 35 source and two pinned dependency checks before reusing
proof artifacts. Both proof gates ran in this battery.

`ARITHMETIC-CAPTURES.json` retains execution, refusal and mutation
captures.
`LIVE.json` records 158 execution comparisons and two creation outcomes.
`ERASURE.json` hashes all five files for 16 inferred/explicit pairs.
The gate also checks 24 refusals through three commands and four
built mutants with restored passing controls.
`MUTANTS.json` records mutation witnesses and compiler source hashes.

`GATE-COMPAT.json` records the unchanged 53 prior commands, deadlines
and success markers. `FINAL.json` lists preserved source, proof and
measurement paths. `SOURCES.json` hashes active source files, excluding
the vendor and validation directories. `ARTIFACTS.json` hashes every
other file in this archive.

`LOG-NORMALIZATION.json` records one trailing blank line removed from
the archived M0-RATIO log. Its content is otherwise unchanged. The
original output remains in the full battery capture.

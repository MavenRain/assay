# Inferred helper validation

Base: `aa8c433ce7bfc1882897e8ab6c93e29ae898a3b2`.

The default 55-leg battery passes all 53 functional legs. DENOMINATORS
and M0-RATIO retain their existing failures against preserved older
measurement inputs. Timing remains paused. No fresh performance result
or milestone exit is claimed.

`GATES.log` and `legs/` retain the battery and each leg's output.
The individual ratio log omits its redundant final blank line.
`RUN.json` records every result and the compiler hash. `CACHE.json`
records the 35 source and two pinned dependency checks before reusing
proof artifacts. Both proof gates ran in this battery.

`HELPER-CAPTURES.json` retains execution, refusal and mutation captures.
`LIVE.json` records 254 execution comparisons and two creation outcomes.
`ERASURE.json` hashes all five files for 24 inferred/explicit pairs.
The gate also checks 26 refusals through three commands, two accepted
16-parameter boundary forms, a false unused parameter at that boundary,
four nesting depths through 128, and five built mutants with controls.
`BOUNDARIES.json` records source hashes and generated core sizes for
the nested programs, whose five emitted files match the simple program.
`MUTANTS.json` records mutation witnesses and compiler source hashes.

`GATE-COMPAT.json` records the unchanged 54 prior commands, deadlines
and success markers. `FINAL.json` lists preserved source, proof and
measurement paths. `SOURCES.json` hashes active source files, excluding
the vendor and validation directories. `ARTIFACTS.json` hashes every
other file in this archive.

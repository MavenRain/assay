# Proof placeholder validation

Base: `9058d167e7d7423102611ffdd6918c5506b9da59`.

The default 56-leg battery passes all 54 functional legs. DENOMINATORS
and M0-RATIO retain their existing failures against preserved older
measurement inputs. Timing remains paused. No fresh performance result
or milestone exit is claimed.

`GATES.log` and `legs/` retain the battery and each leg's output. Leg
logs omit redundant final blank lines. `RUN.json` records every result
and the compiler hash. `CACHE.json` records the 35 source and two pinned
dependency checks before reusing proof artifacts. Both proof gates ran.

`PROOF-HOLE-CAPTURES.json` retains execution, refusal and mutation
captures. `LIVE.json` records 242 execution comparisons and two
creation outcomes. `ERASURE.json` hashes all five files for 23
placeholder/explicit pairs. The gate also checks 25 refusals through
three commands, two accepted 16-parameter forms, rejection of 17
arguments and a false unused parameter, four nesting depths through
128, and four built mutants with restored controls. `BOUNDARIES.json`
records nested source hashes and generated core sizes. `MUTANTS.json`
records each witness and
compiler source hash.

`GATE-COMPAT.json` compares the complete syntax trees of all 55 earlier
gate declarations, including commands, deadlines and markers.
`FINAL.json` lists protected source, proof and measurement paths.
`SOURCES.json` hashes active source files and the changed documentation.
`ARTIFACTS.json` hashes every other file in this archive.

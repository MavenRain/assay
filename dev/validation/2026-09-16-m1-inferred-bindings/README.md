# Inferred proof binding validation

Base: `c74a4ee3558b45b1cca52ef1921581365e11d202`.

Validation passes all 55 functional legs after one guard-harness
recheck. The complete 57-leg battery initially passed 54 legs.
PROOF-GUARDS failed because its CLAIM mutant left a helper binding
unused, which prevented the deliberate mutant from building. The
harness now consumes that binding while preserving the same mutation
and witness. Its full recheck passed, including all six mutations and
restored controls. `GUARD-RECHECK.json` records both source hashes and
the completed capture. No production source or compiler binary changed
after the battery began.

DENOMINATORS and M0-RATIO retain their existing failures against
preserved older measurement inputs. Timing remains paused. No fresh
performance result or milestone exit is claimed. `PENDING.json`
verifies both gates report the same 14 stale hashes as the committed
baseline.

`GATES.log` and `legs/` retain the battery and each leg's output. Leg
logs omit redundant final blank lines. `RUN.json` records both initial
and final results and the compiler hash. `rechecks/` retains the
corrected guard gate output. `CACHE.json` records the 35 source and
two pinned dependency checks before reusing proof artifacts. Both
proof gates ran.

`INFERRED-BINDING-CAPTURES.json` retains execution, refusal and
mutation captures. `LIVE.json` records 229 execution comparisons and
two creation outcomes. `ERASURE.json` hashes all five files for 21
inferred/annotated pairs. The gate also checks 25 refusals through
three commands, four nesting depths through 128, rejection of depth
129, a 4095-node inferred bundle and a 32-level inferred claim spine,
both with unchanged erased output. It rejects 4097 nodes, repeated
bundle doubling and a 33-level spine. Six built mutants have restored
controls. `BOUNDARIES.json` records accepted depths, inferred source
hashes and annotated twin hashes. The captures retain both variants'
command results. `MUTANTS.json` records each witness and compiler
hash.

`GATE-COMPAT.json` compares the complete syntax trees of all 56 earlier
gate declarations, including commands, deadlines and markers.
`FINAL.json` lists protected source, proof and measurement paths.
`SOURCES.json` hashes active source files and the changed documentation.
`ARTIFACTS.json` hashes every other file in this archive.

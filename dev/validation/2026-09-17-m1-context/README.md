# Core EVM context validation

Base: `b2415c461b357fb3d715aa53e10494f1e401e101`.

All 57 functional legs pass after the rechecks in `RECHECKS.json`.
`GATES.log`, `GATES.stderr`, `RUN.json` and `legs/` retain the initial
59-leg battery, including failures. Two mutation anchors needed the new
caller parameter, and older proof-inference tests encountered timeouts.
Rechecks preserve the assertions and success markers. SOURCE-MODEL's
standalone rerun retained its per-command deadlines; its outer deadline
was not recorded. Other rechecks use the original gate deadline. Leg
logs omit trailing blank lines; the full battery streams are retained.

DENOMINATORS and M0-RATIO remain pending. `PENDING.json` compares
frozen, base and current hashes. Timing remains paused and the frozen
inputs are unchanged. No performance result or milestone exit is
claimed.

`LIVE.json` records 224 model/EVM comparisons, 56 signed Cancun
comparisons and 64 creation outcomes. `NESTED.json` checks proxy CALLER
and factory deployment. `INDEPENDENT.json` checks six deployer-only
creation/model cases. `MUTANTS.json` records six built mutations and
passing restored controls. The gate also checks seven invalid schemas
and seven input/default cases.

`CAPTURES.json.gz` retains the complete context command captures and
executor traces as a JSON object keyed by filename. `CAPTURES.json`
records its uncompressed identity; `OUTPUTS.json` hashes emitted files.
`DAO-PORT.json` records five byte-identical artifacts from the pushed
DAO.

`GATE-COMPAT.json` preserves all 58 earlier gate declarations.
`MUTATION-COMPAT.json` checks that the two carried mutation changes only
thread the caller parameter. `CACHE.json` records 35 matching proof
package inputs and two pinned dependencies. Both proof suites ran.
`FINAL.json` records protected sources, the compiler identity and the
1767/1800 emitter count. `STATIC-AUDIT.log` records the scoped scan.
`SOURCES.json` hashes source inputs outside validation archives.
`ARTIFACTS.json` hashes every other file in this archive.

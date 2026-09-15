# Compound guard validation

Base: `09a9b8c3d7f44328a4244da7382c05bbab40a3a9`.

This slice started on 2026-09-14 and closed validation on 2026-09-15.

The default 51-leg battery and two scoped legacy rechecks pass all 49
functional legs. DENOMINATORS and M0-RATIO retain their existing failures
against preserved older measurements. Timing remains paused. This
archive makes no performance or milestone-exit claim.

`GATES.log` and `legs/` retain the complete battery and each leg's output.
`RUN.json` records initial statuses, rechecks and the compiler hash.
`INITIAL-GUARD-FAILURE.json` preserves the stale CLAIM mutant's type
error. `RECHECKS.log` and `LEGACY-GUARD-CAPTURES.json` preserve the full
passing proof-guard suite after that mutation's type conversion was
updated. Its six witnesses and kill criteria are unchanged. The
predicate EXPANSION mutation now uses a precise anchor for the same
budget removal and expanded-node witness. `PREDICATE-CAPTURES.json`
retains its passing rerun. `RECHECKS.json` records both suites with their
unchanged commands, deadlines and markers. `LOAD-RETRY.log` retains an
earlier retry that hit the existing 30-second geth timeout while the
battery was active. The successful reruns were sequential. `CACHE.json`
records the verified source and pinned dependency checks before reusing
the Lean artifacts. Both proof gates run in this battery.

`GUARD-CAPTURES.json` preserves the individual execution, refusal and
mutation captures. `LIVE.json` and `ERASURE.json` summarize 88 execution
cases, two creation outcomes and seven byte-exact variants. The gate
also checks 26 refusals through three commands, seven accepted boundary
forms and four built mutants with restored controls.

`GATE-COMPAT.json` verifies that all 50 prior commands, deadlines and
success markers are unchanged. `FINAL.json` lists the preserved source,
proof and measurement paths. `SOURCES.json` hashes the active source
tree. `ARTIFACTS.json` hashes every other file in this archive and is
written last.

`legs/M0-RATIO.log` omits a final blank line for the staged whitespace
check. Its original bytes remain embedded in `GATES.log`.

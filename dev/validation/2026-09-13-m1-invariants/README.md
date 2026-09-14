# Storage invariant validation

The complete 46-leg battery ran in
`/Users/oobi/Documents/gpt1/assay-m1-invariants` from base `b35c17d`.
It passed 43 legs and found stale mutation anchors in CONTRACT-SURFACE,
alongside the two previously disclosed timing-related failures.
`GATES.log` and `CAPTURE.json` retain that complete initial run.
The STORE and SHADOW anchors were updated without changing their
witnesses or expected outcomes. The complete CONTRACT-SURFACE gate then
passed, including all eight mutations and restored controls. The compiler
was unchanged, so the other functional legs retain their passing runs.
`CONTRACT-SURFACE.initial.log` preserves the failure;
`CONTRACT-SURFACE.log`, `CORRECTION-CAPTURE.json` and `CORRECTION.diff`
retain the corrected run and exact harness change.

All 44 functional legs are validated across those two runs.
`DENOMINATORS` and `M0-RATIO` remain failed against the preserved
manifest and old measurement.
Timing remains paused; no complete battery pass or fresh performance
verdict is claimed. Per-leg logs trim trailing whitespace; `GATES.log`
preserves the original output. `RUN.json` records all leg verdicts.

`invariants/` holds this run's 52 source-model/Cancun comparisons,
constructor outcomes, 30 refusals through check/emit/run, erasure hashes,
four compiler mutations and restored controls. Execution captures use
both geth entry points, so they provide no independent-client claim.
`CACHE.json` records 35 matched Lean sources and two pinned dependencies
before copying existing artifacts. The full proof gates still ran.

The review round of 2026-09-13 added one surface variant, one surface
mutation, three invariant cases and two invariant refusals. `INVARIANTS.log`,
`CONTRACT-SURFACE.log` and `invariants/` hold the review ladder run.
`GATES.log` and `CAPTURE.json` keep the first complete battery, and
`RUN.json` keeps its leg verdicts.

`SOURCES.json` binds the prior source closure and every changed or new
source and document, excluding validation archives. `FINAL.json`
records the protected-input check. `ARTIFACTS.json` hashes every
retained artifact except itself. Temporary paths in captures may no
longer exist; the committed test script retains reproducible inputs.

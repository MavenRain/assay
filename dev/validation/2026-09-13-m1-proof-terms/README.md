# Supplied proof term validation

The complete 45-leg battery ran in
`/Users/oobi/Documents/gpt1/assay-m1-proof-terms` from base `ccf78af`.
`GATES.log` retains the full transcript and `CAPTURE.json` its command
and exit status. All 43 functional legs pass. `DENOMINATORS` and
`M0-RATIO` fail against the preserved manifest and old measurement.
Timing remains paused; no complete battery pass or new timing result
is claimed. `RUN.json` records every leg and the compiler identity.
`M0-RATIO.log` trims a trailing blank line for clean staging; the complete
original output remains in `GATES.log`.

`proof-terms/` retains 98 source-model/Cancun comparisons, constructor
outcomes, 25 refusals through check/emit/run, erasure hashes, all four
compiler mutation witnesses and restored controls. It holds 318 files,
one per capture of this run. Fourteen captures of an earlier script
version were removed, and `ARTIFACTS.json` now holds 372 entries. The
test script clears its work directory before each run. Execution captures
contain both geth entry points, so they provide no independent-client
claim. `CACHE.json` records matched Lean sources and pinned dependency
revisions before copying existing artifacts. The full source-proof and
axiom gates still ran, and their outputs remain in the leg logs.

`SOURCES.json` binds the preceding source closure and every changed or
new source and document, excluding validation archives. `ARTIFACTS.json`
hashes every retained artifact except itself. The final source scan is
recorded in `FINAL.json` and `FINAL.log` after writing the build record.
Temporary command paths in captures may no longer exist. The repository
test scripts and source hashes retain the reproducible inputs.

# M1 typed error validation

All 42 non-performance legs passed across two runs. The full battery was
interrupted, and the timing gate remains paused at the user's request.
No complete battery verdict or current timing pass is claimed.

`RUN.json` identifies the checkout, compiler, base revision and results.
`interrupted-battery/` retains the first 27 completed leg verdicts and
the interrupted command status. `functional-remainder/` retains the 15
remaining non-performance verdicts. `FUNCTIONAL-RUN.json` records each
remainder command, result and log hash; `functional-runner.py` retains
its exact deadlines and markers. Each leg also has a separate log.
`final-rechecks/` and `FINAL-RECHECKS.json` record the final house and
source-hash checks after the diagnostic code and documentation changes.

`evidence/` retains 66 source/model/EVM comparisons, ABI and erasure
checks, two creation cases, 24 refusals and five mutations with restored
controls. `evidence/OUTPUTS.json` records gas, size and coverage. Temporary
paths recorded in captures may no longer exist.

Both proof gates ran. `CACHE.json` records the 35 matching source and
configuration files and two pinned dependencies used to reuse Lean
artifacts. The new typed payload encoding is outside the existing source
proof model.

`diagnostics/` retains workload and compiler comparison results, their
scripts, and all three original failed timing captures. These are not
performance gate results. The previous timing report is unchanged and
does not validate the current compiler and measurement script. See
`dev/TIMING-DEBUG.md` for the diagnosis and failure-reporting fix.

`SOURCES.json` pins the code, tests, proof sources, timing inputs and
documentation. `ARTIFACTS.json` pins every other file in this archive.

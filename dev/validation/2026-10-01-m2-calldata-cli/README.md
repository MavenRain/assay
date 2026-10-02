# Public function calldata validation

Base: `4cf4ebc533173fc277ce455accc2c802ea2f951d`.

The original source bundle reused verified compiler output. The original
`calldata-cli` run checked 52 encodings, 55 decodings, 192 refusals and two
changed pin controls. Selector and tuple expectations come from `cast`; one
decoded string case uses hand-built arbitrary bytes. `REPORT.json` binds
the reviewed results to the current source hashes. `compiled-assay.json`
records the original compiler input and output identities.

The static gates pass: carry, R0 counts, R0 audit, house rules, trusted source
limits, denominator hashes and 57 historical schedules with nine runner
controls. The default M2 schedule has 99 legs, including `CALLDATA-CLI`.
The trusted artifact total remains 3184 of 3550 lines.

The initial `make test` passed the core suite and adapter commands, then
failed while compiling a packed-storage mutant. A second attempt timed out
in the unchanged cached kernel batch at its existing 180-second deadline.
The standalone kernel retry passes. Both failed complete captures remain
here alongside the successful records. These attempts do not establish a
passing full `make test` or the complete 99-leg milestone battery.

Follow-up checks pass the kernel suite, all eleven CLI regression checks,
and all 66 packed-source cases with six killed mutants. Together with the
initial successful adapter commands and final calldata checks, these cover
the test target's components. The complete milestone battery was not rerun.

Validation ran in the separate worktree
`/Users/oobi/Documents/gpt1/assay-m2-calldata-cli`. This record keeps
verbatim copies of the external scripts. `check-static.py` ran
`dev/carry-check.py`, `dev/r0-count.sh`, `dev/r0-audit.sh`,
`dev/house.sh`, `dev/trusted-lines.sh`, `dev/milestone-speed-test.py` and
`shasum -a 256 -c dev/DENOMINATORS.sha256`. Its `git diff --check` step
saw no unstaged changes, so it is not a whitespace check of the staged
slice. `check-cli-regressions.py` ran the eleven `dev/*-test.py` files that
it names, with `BEND` set to the repository Bend. `prepare-validation.py`
regenerated `dev/native-carry.json`, `dev/bend-catchalls.json` and
`dev/DENOMINATORS.sha256` from the edited sources.

The initial `make test` ran when the new CLI declarations were in a
separate `src/call_cli.bend`. That layout failed the trusted-line check.
The staged `src/cli.bend` kept the same declaration order, so the assay
bundle had the same input identity (`adb90c7a`) and the build reused that
output. The adapter results in `make-test-initial.stdout.log` come from
that run.

The CLI declarations remain in `src/cli.bend` and keep the existing source
inventory. Compiler failure reporting now includes the exit code and the
end of the full log. No test deadline or success condition was relaxed.

## Review changes

A review added an encoded calldata limit of 131072 bytes to
`src/cli.bend`. Before this change, long string arguments stopped the
process with a Bend memory fault. `dev/calldata-cli-test.py` now checks
both sides of each cap and the exact diagnostic of each truncated tuple.
`review-build.log` records `make all`, and `review-compiled-assay.json`
records the new compiler input and output identities.
`review-calldata-cli.log` shows 53 encodings, 55 decodings, 196 refusals
and two changed pin controls. The event, event-decode, mapping and
milestone schedule checks pass in their `review-*.log` files.
`review-gates.log` records the static gates on the reviewed tree.
`REPORT.json` lists the review changes. The review did not rerun the full
`make test` or the 99-leg milestone battery.

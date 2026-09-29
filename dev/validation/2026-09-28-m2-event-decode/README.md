# M2 event decoding validation

This record covers the host event decoder added to `aa7517e`. The staged
slice does not close M2. Source event lowering remains pending.

## Evidence

`RUNS.json` lists the exact outcome and capture directory for each check.
Each capture retains its complete stdout, stderr and original manifest.
The legacy M1 corpus stdout is gzip-compressed to retain its trailing
blank line without introducing whitespace errors in the staged diff.
The original absolute paths identify the isolated build checkout; they
are provenance, not required paths for replay. `SOURCES.json` pins the
reviewed implementation and validation dependencies.

`RUNS.json` also records each check's command, working directory, exit
code and wall time in seconds. The wall time runs from the creation of
the original run directory to the write of its manifest. The interrupted
ABI-CODEC run has no exit code and no wall time. In `RUNS.json`,
`$ARCHIVE_ROOT` names the isolated build checkout, and `$BEND_ROOT` names
the Bend 2 checkout pinned in `dev/toolchain.json`. Both are outside this
repository.

The review fixes reran four checks in the repository root: TRUSTED-LINES,
EVENT-DECODE, COMPATIBILITY and DENOMINATORS-FINAL. Their captures
replace the earlier ones. Each new manifest keeps the same fields, with
cwd `.` and paths relative to this directory. Their wall time is the
elapsed time of the command itself.

`vectors.json` retains all 151 event-decoding inputs and expected answers:
71 independent cast vectors, 21 frozen ERC-20 logs and 59 malformed logs.
Eight adapter refusals and twelve compiling semantic mutants are checked
by the executable gate. All twelve mutants produced named wrong answers,
and the restored scratch control passed the vectors and refusal checks.
The malformed logs include `limit-before-count` and
`anonymous-limit-before-count`, which test that the schema topic limit
is checked before the topic count. They also include named logs with the
correct signature hash and bad data or an out-of-range indexed word.
These test that codec errors are not reported as `Wrong_signature`.

The native suite passed with 18 adapters and 24 commands. Compatibility
checks preserve all 54 earlier gate modes, with one appended check for
87 total. Existing ABI and test sources remain byte-identical prefixes.
The reachable compiler CLI bundle is byte-identical to the base.

EVENT-CODEC, CALL-CODEC, RETURN-CODEC and REVERT-CODEC pass with their
existing mutation controls. HOUSE, refreshed CARRY and DENOMINATORS,
the scheduled M0 corpus report and BEND2-RATIO-TEST also pass.

Initial carry and checksum checks were run before refreshing the changed
source pins. The archive copy has no Git history, so its successful carry
rerun used the base repository for the read-only ancestry query and the
archive's own files for every hash check. The target repository is checked
again after transfer. The optional legacy M1 corpus report was not
refreshed or rerun; the active compiler-speed gate is BEND2-RATIO.

The fresh five-round paired measurement completed in 48.113 seconds.
Its Assay and Bend 2 median batch times are 5203.637876 ms and
4575.539292 ms, for a ratio of 1.137273126. BEND2-RATIO fails its unchanged
1.0 bound. The separate informational report exposes the measured ratio;
it is not a passing binding gate. The initial report-seal refusal is also
retained, followed by the corrected seal and final gate results. The
compiler CLI bundle is unchanged, so differences from previous timing
windows do not establish a decoder-related performance change.

## Limitations

The ABI file has 495 lines, above the earlier 400-line bound. On
2026-09-28 the user re-ratified the source budget: abi 495, assembler
505 and an unchanged total of 3550. TRUSTED-LINES passes under this
budget with `total=2951/3550`. No implementation was moved outside the
priced modules.

The optional full ABI-CODEC regression was interrupted before the outer
runner's 360-second timeout. Its captured output records fuzz results
and four killed mutants, but not a complete gate pass. Its inner capture
manifest was left in `running` state when the managed parent was canceled;
the archived output is partial evidence only. Earlier ABI definitions are
unchanged, as checked by the byte-prefix compatibility test.

The complete 87-leg default battery was not run. `RUNS.json` is the
authority for which scoped checks completed. No interrupted, failed or
unrun check is counted as passing.

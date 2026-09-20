# Calldata-size validation

Base: `4a5dfda0c410a2c050a767de374fe3d54c75d473`.

`FINAL.json` records 36 passing scoped gates. `SCOPED.json` contains the
fresh run of the preceding slice's 35 selected gates. CALLDATASIZE was
run separately against the same implementation while those gates ran.
Its duration includes the capture wrapper and stays within its new
600-second gate deadline. Commands, deadlines, markers and exit codes
are recorded; full stdout and stderr are retained in `logs/`.

`GATE-COMPATIBILITY.json` compares every old mode with the base revision,
including commands, deadlines and markers. The new mode preserves all
70 preceding legs and appends CALLDATASIZE as leg 71.

`CALLDATASIZE-CAPTURES.tar.gz` contains the complete new test work
directory: core fixtures, emitted artifacts, independent expected
outcomes, model and Cancun responses, signed-call evidence, refusal
diagnostics, and mutant/control build and probe captures. `WITNESSES.json`
records the five mutations and restored controls with source hashes.
`CALLDATASIZE-EXECUTION.json` retains the original capture manifest.

The first line audit reported 1803/1800 before formatting the shared
snapshot code. The passing build and behavioral tests use the final
1800-line emitter. No functional gate needed a failed-run replacement.

`TOOLS.json` records the installed tool versions. `SOURCES.json` hashes
the final non-validation source snapshot. `ARTIFACTS.json` hashes this
archive. The original capture directory paths identify the local run;
the tar archive retains its evidence independently of those paths.

The full 71-leg ladder was not rerun. The preserved denominator and
measurement inputs were not changed. DENOMINATORS and M0-RATIO retain
their known timing pause. No performance or milestone-exit claim is made.

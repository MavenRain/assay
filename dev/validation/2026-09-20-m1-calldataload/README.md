# Calldata-word validation

Base: `15c417c1da18ad163e8c52df69c0206673aa874e`.

Command: `zsh -f dev/gates.sh`, which defaults to `--m1-calldataload`.

The final 72-leg default run passes 70 gates. All M1 feature gates
pass. DENOMINATORS and M0-RATIO fail at the existing frozen checksum
check; the full command exits 1. The clean committed baseline also
fails that checksum check.

`DENOMINATORS` fails against the frozen M0 checksum manifest on the clean
committed baseline. `M0-RATIO` stops at the same checksum command. That
manifest also references the removed `dev/dunecho.sh`. The archive keeps
these failures and the unchanged validation limits.

The new CALLDATALOAD gate passes 2240 independently expected model/geth
comparisons, 35 signed calls, 64 unused-constructor artifact pairs, 31
surface probes, two public commands, 18 refusals and five named mutant
witnesses with passing restored controls. The full run repeats the earlier
feature gates and mutation batteries after the shared parser and context
changes. The trusted emitter is 1799 of 1800 lines; the kernel is 3997.

- `FINAL.json` records all 72 gate outcomes and timings.
- `FULL.log`, `FULL.stderr` and `FULL-EXECUTION.json` retain the completed
  command and its exit status. `logs/` contains each final gate's output.
- `VALIDATED-SOURCES.json` pins 270 source and build files before the final
  run. Archiving verifies those hashes after the run.
- `GATE-COMPATIBILITY.json` compares all 42 earlier gate modes to the base.
- `MUTATION-ANCHORS.json` and `ANCHOR-AUDIT.json` record anchor inspections.
  The anchor audit's remaining `0123456789abcdef` candidate is test calldata,
  not a mutation anchor. The complete surface suite verifies its adapted
  literal witness in the final run.
- `attempts/` retains scoped successes, baseline checks and both interrupted
  full attempts. Interrupted attempts are not successful full validations.
- `SUPERVISOR-RECOVERY.json` records a transient lost-heartbeat observation
  and recovery of the same final run without restarting it.
- `CALLDATALOAD-CAPTURES.tar.gz` contains generated programs, emitted
  artifacts, model/geth captures and mutation witnesses.
- `ARTIFACTS.json` hashes every archived file except itself.

The first full attempt exposed the emitter line-budget overflow. The second
exposed house-check patterns and a stale surface mutation anchor after the
refactor. The local Lean dependency cache was copied into the isolated
checkout so AXIOMS could run without fetching dependencies. All resulting
source and test fixes are included in the final run.

No performance measurement or milestone exit is claimed.

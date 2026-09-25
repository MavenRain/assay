# Native Bend migration validation

`REPORT.json` records checks performed while migrating base commit
`2cd3259f10d085dfedb405395d9adb341ef816ed`. It includes source identities,
attempt outcomes, focused rechecks and captured output. These are iterative
checks, not a claim that the complete stage passed in one run.

The final focused run passed the 330 kernel fixtures and direct assertions,
source-model suite, stack suite and 13 audit mutation controls. CARRY, R0,
HOUSE, native byte IO, allocation routing, and the original size limits pass.
The kernel is 3,767 lines against the unchanged 4,000-line ceiling. ABI codec,
ABI schema, Keccak and reference mutation checks also passed during the
migration. Earlier CLI parity checks matched 311 cases against the old
implementation. That set is only the recorded `additional/cli_parity_311`
capture in `REPORT.json` and has no runnable case list, so the four argv token
cases (`--help`, `--`, `--threads` and `--gpu`, each refused with exit 64) went
into the runnable public-driver suite in `dev/stage-a-test.py`. That check now
passes all 28 cases.

The performance gate remains red. The final matched benchmark measured
1,755.286418 ms for Assay and 1,303.759208 ms for Bend, a ratio of
1.3463271493918378 against the unchanged 1.0 limit. Its measurement window
was 15.828627 seconds. The denominator capture completed within its
60-second limit at 30.147462 seconds. Both committed reports bind the native
source and measurement method. Benchmark decision-boundary tests and their
restored controls pass.

Recorded deadline failures remain unresolved for the largest inferred-guard,
inferred-binding and guard-binding boundaries; the proof-hole mutation witness;
the inferred-helper sharing witness; and the payable, callvalue, calldatasize,
calldataload and address suites. The original limits remain in place. Timeouts
and compilation failures do not count as successful mutation checks. A redundant
calldataload retry was stopped after the other sequential deadline failures;
the original completed 600-second failed attempt remains recorded. The record
predates the 2026-09-24 argv fix of `src/os.js` (digest 1ed3654b to 69ce5ef4),
the argv path is outside the measured compile loop, so the record is not
re-recorded, and the M1 ratio identity rows in `dev/denominators.json` and
`dev/bend2-baseline.json` were re-pinned to the new digest for the same reason,
which also applies to the 2026-09-24 exit-code fix of `dev/build.py` (digest
fd892bc7 to 3b738bbd): the build script is outside the measured compile loop,
and its identity row in the same two files was re-pinned.

The emitter mutation check EMIT-MUTANTS is unresolved for the same reason. Both
recorded attempts with an exit code, the `full_leg_attempts` entry and the entry
in the `additional/reference_and_emission_retries` log, report exit 1 and
`"passed": false`, because a mutant does not compile: the captured battery log
ends with `EMIT-GATE FAIL MUTANT-BUILD STORAGE-ALIAS` and a Bend compilation
failure. The marker `EMIT-MUTANTS killed=7/7 controls=4 OK` also appears in the
captured `additional/emitter_mutants` text, but that capture records no exit
code, command or source identity, so it is not a passing run under the rule
above. The check counts as passed only after a run that records exit 0 with its
command and the source identity it measured.

Run `make gates` after building the pinned toolchain to execute the complete
battery. The retained performance and deadline failures mean it is expected
to report a failing stage until those issues are resolved.

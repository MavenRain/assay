# Call-value validation

Base: `48364273f02cd1c0ee1177facc4ab5ba81671557`.

`FINAL.json` records 35 passing scoped gates, including their original
commands, timeouts, required markers and actual results. The public
Dune build passes; the repository keeps warnings fatal.
`GATE-COMPATIBILITY.json` checks all 40 previous modes and 69 legs without
exceptions. CALLVALUE is appended as leg 70.

`SCOPED-INITIAL.json` retains the first regression run. R0-COUNT and HOUSE
failed because that invocation's PATH omitted `rg`. SOURCE-MODEL,
NULLARY-ENTRIES, CUSTOM-ERRORS and PROOF-GUARDS initially stopped at stale
mutation anchors after the source refactor. `RECHECKS.json` retains every
rerun, including the second SOURCE-MODEL anchor failure before its abort
branch was selected uniquely. Original mutation counts and witnesses
remain required. `attempts/` contains superseded logs; `logs/` contains
the final logs.

The final source keeps the nullary-entry scan outside the per-entry
helper. BUILD, HOUSE, TRUSTED-LINES, CONTRACT-SURFACE, NULLARY-ENTRIES and
CALLVALUE were refreshed after that adjustment. The emitter remains
1800/1800 lines, the kernel 3997/4000, and the six added components
2224/3550, with unchanged bounds.

`CALLVALUE-CAPTURES.tar.gz` contains generated sources and artifacts,
model outcomes, geth traces, independent expected outcomes, signed Cancun
evidence and mutation/control records under `callvalue/`.
`WITNESSES.json` hashes those files. The final gate covers 480 core cases,
18 signed calls, 16 artifact pairs, 12 surface probes, two public command
calls, 13 refusals and four killed mutants with passing controls.
Signed calls additionally check balance transfer and rollback.

`DRIVER-CAPTURES.tar.gz` retains the local finite-command captures,
including earlier test-fixture corrections. `SOURCES.json` pins source
inputs, `TOOLS.json` records the local tool versions, and `ARTIFACTS.json`
hashes the archive files. Reproduce the checks with the activated toolchain
from README.md and `python3 -P dev/validation/2026-09-20-m1-callvalue/scoped-run.py`.
`recheck.py` reruns failed rows, or explicitly named gates, and preserves
their prior logs.

The complete 70-leg ladder was not run. DENOMINATORS and M0-RATIO retain
their existing timing pause. This archive makes no timing, gas ratio,
or milestone-exit claim.

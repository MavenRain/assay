# Differential caller validation

Base: `63fde3b0cb01c83990f26e18b9cbb21c78a2288c`.

The build, 12 scoped regression gates and the documented `who()` example
pass. DIFF-CALLER records 45 source-model and signed geth comparisons,
four funding or nonce refusals, 33 driver refusals and five adapter refusals.
The complete battery was not rerun. DENOMINATORS and M0-RATIO remain
paused under the existing timing diagnosis; no milestone exit is claimed.

`SCOPED.json` lists the commands, timeouts, markers and measured results.
`GATE-COMPATIBILITY.json` records preservation of 38 old modes and 67
legs, with DIFF-CALLER appended as the 68th leg. `scoped-run.py` reproduces
that comparison against the pinned base and reruns the scoped checks.
The build command is `zsh -f dev/dunecho.sh build`; the documented example
is in `dev/M1-DIFF-CALLER.md`. Build before replaying the checks.

The compressed CASES, LIVE and ARGV files retain all 88 invocations,
45 expected outcomes and 90 executor requests. The signing scalars in
ARGV are the public fixture values 1 and 2. Temporary execution paths
inside receipts are historical. Capture files identify the original local
command artifacts, and the corresponding logs are copied into this archive.

`SOURCES.json` pins the changed source, test and documentation files.
`ARTIFACTS.json` hashes the remaining archive files. `FINAL.json` states
the checked scope and outstanding timing work.

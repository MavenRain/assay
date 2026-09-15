# Compound invariant validation, 2026-09-14

Base: `012e7312f2c02958ec85f5a6ad09e60f8d34b30e`.
The isolated checkout is recorded in `RUN.json`. Its validated source
hashes are in `SOURCES.json`, and its compiler hash is in `RUN.json`.

The full command was `zsh -f dev/gates.sh`. All 50 legs ran. The initial
run passed 47 and failed DENOMINATORS, M0-RATIO and AXIOMS. The first two
retain the documented stale measurement failures. AXIOMS reported a
missing preprovisioned dependency in the fresh checkout.

`CACHE.json` records equality of all 28 proof files and both pinned
dependency revisions before reuse of the prior checkout's proof cache.
The scoped command `python3 -P dev/proofs-test.py` then passed: 42
theorem reports, no `sorryAx`, and three report controls. Its captured
output and command metadata are retained separately.

After that recheck, all 48 functional legs pass. The full battery still
fails. Timing remains paused, the existing frozen inputs are unchanged,
and neither current performance nor milestone exit is claimed.

The new gate passes 64 source-model/Cancun execution comparisons, two
creation outcomes, 24 rejected programs through three commands, eight
five-file erasure variants, ten accepted boundaries and four compiler
mutations with passing restored controls. `LIVE.json`, `ERASURE.json`
and `COMPOUND-CAPTURES.json` retain the corresponding evidence.

`GATES.log` and `GATES.stderr` contain the initial run. `legs/` retains
every leg's output. `RECHECKS.log` and `RECHECKS.stderr` contain the proof
recheck. `CAPTURE.json` and `RECHECK-CAPTURE.json` retain capture metadata.
`FINAL.json` lists preserved inputs and the remaining failed gates.
`ARTIFACTS.json` hashes every other archive file.
The readable ratio leg removes an extra final blank line; its exact
captured text and SHA-256 are preserved in `RAW-LEG-LOGS.json`.

No gate deadline, frozen measurement, source limit or existing passing
marker was relaxed. The predicate refusal now tests a wrong component
because valid bundled invariants are part of the accepted grammar.

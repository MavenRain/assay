# M2 calldata validation

This record covers the typed call payload slice on `0cf7d20`.
See [the API and scope](../../M2-CALLDATA.md).

`RUNS.json` records the commands, outcomes, wall times and retained
logs. `SOURCES.json` pins the relevant source files. `FILES.sha256`
seals this record.
The prior event measurement remains in the 2026-09-26 record; the current
`paired-measurement.json` is a byte copy of `dev/bend2-baseline.json`.

The new codec, compatibility, native tests, tuple codec, event codec,
house rules, carry, denominator and trusted-line checks pass. The
compatibility check verifies all 51 historical modes, their deadlines,
expected markers and failure classes. The new default has 84 checks.
This is scoped validation; the complete default battery was not run for
this slice.

The first carry check failed: `dev/native-carry.json` still held the
old hashes of `src/abi.bend` and `src/tests.bend`. `carry.log` keeps
that failure. The review refreshed the two hashes, and `carry-final.log`
records `CARRY files=12/12 diff=0 unlisted=0`. `dev/DENOMINATORS.sha256`
now also pins `dev/call-codec-test.py`, `dev/call-compatibility.py` and
`dev/mutations/call-codec.json`. `denominator-pins-final.log` checks
the regenerated file.

The 15 original rows, which come before `carry` in `RUNS.json`, ran
from the root of the build checkout
`/Users/oobi/Documents/gpt1/assay-m2-event-surface`. Their capture
artifacts are not retained in this record. Their wall times come from
the artifact timestamps, from the creation of the run directory to the
write of its manifest. The `carry` row is the pre-fix carry run in this
checkout. It and the `-final` rows ran from the repository root, have
no capture artifact and were timed directly. The `-final` rows ran on
the final tree. CALL-CODEC
took 37.558 s against its 300 s deadline. The 1-minute load average was
18.2 before that run and 17.1 after it. The direct ABI-CODEC rerun took
213.168 s. The reruns wrote `call-codec-cases.json` and
`compatibility.json` byte for byte again.

BEND2-RATIO-TEST passes. The binding BEND2-RATIO still fails its unchanged
1.0 bound: the refreshed ratio is 1.720827821, measured over 7.642 seconds.
The preceding event report also failed that bound. The compiler CLI bundle
is unchanged; this comparison does not identify a calldata-related slowdown.

Early adapter builds needed binder fixes, and an initial house check
rejected two catch-all matches. Explicit matches now pass the same house
rules. An early trusted-line invocation omitted its required root argument;
the recorded successful invocation supplies it. These attempts are retained
alongside the final results.

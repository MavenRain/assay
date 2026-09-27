# Event codec validation

Base: `a1e7440`. `RUNS.json` records the commands, actual exits and wall
times for this scoped validation. `SOURCES.json` pins the implementation,
test, gate and documentation inputs of the final tree, and
`FILES.sha256` seals this record. The `*-final` logs are runs on that
final tree.

The new event gate compares 71 cases with cast, 21 distinct frozen ERC-20
logs, 65 production refusals and 13 adapter refusals. The production
refusals include type mismatches at indexed and non-indexed positions and
nine rows with two failures that check the error order. Its 12 semantic
mutants compile and fail their named answer witnesses, followed by a
rebuilt passing scratch control. `vectors.json` contains the query and
expected output of each of the 157 codec rows. `refusals.json` contains
the command, exit code, stdout and stderr diagnostic of each of the 13
adapter refusals. `cancun.json` retains the generated runtimes and both
geth execution reports for 12 cases, including LOG0 through LOG4 and
receipt-log rollback on revert. `event-codec-final.log` records the run
that wrote these three files.

Native runtest covers the kernel fixtures and 14 adapters through 20
commands. The neighboring ABI schema, ABI codec, packed-storage and
mapping gates run with their existing mutation checks. The record also
includes house, carry, source-pin and trusted-line audits. The ABI module
is 308/400 lines and the trusted artifact total is 2764/3550. No bound,
historical gate deadline or existing marker is relaxed.

`compatibility.json` records all 50 historical gate modes retaining
their schedules, deadlines, markers and failure classes. The new mode
adds EVENT-CODEC for 83 checks. It also pins the byte-identical compiler
CLI bundle and checks that the old ABI and test definitions are unchanged.
Compatibility checks compare schedules; they do not execute those gates.

The first scoped run failed ABI-CODEC at its DECODE-UINT8 mutation anchor
and CARRY at the two edited source hashes. The old decoder definition
was byte-identical, but a newly appended comment was included in its
mutation declaration record. Removing that comment restored the anchor.
The carry manifest was refreshed for the two changed files. Original
failures remain in their logs and `RUNS.json`. The logs without a
`-final` suffix come from runs before that correction and before the
review fixes. The build, native tests, the event, ABI schema, ABI codec,
packed-storage and mapping gates, compatibility, house, carry,
trusted-line and denominator checks were then rerun on the final tree.
Their `*-final` logs and `RUNS.json` entries record those runs in
execution order. House ran twice, before and after the seals;
`house-final.log` and its `RUNS.json` entry record the second run. The
direct ABI codec rerun took 300.7 s under concurrent load, over the 300 s
gate deadline, so it proves the result and not the deadline; the full
gate run checks the deadline.

This is scoped validation, not a run of all 83 default gates. This slice
does not claim speed closure. The encoder and
test-only log programs do not implement source event lowering, dynamic
ABI lowering or the remaining M2 Lean mutants.

## Paired performance

A fresh paired measurement was necessary. The slice changed three pinned
compiler sources: `Makefile`, `dev/build.py` and `src/abi.bend`. The
paired report records their hashes, so BEND2-RATIO-TEST failed with
BEND2-IDENTITIES on the mapping report. The report identities were not
edited by hand. The measurement ran once from the repository root:

```sh
BEND_NO_TELEMETRY=1 python3 -P dev/bend2-ratio.py \
  --measure /Users/oobi/Documents/gpt1/assay-events-paired.json \
  --bend-root /Users/oobi/Documents/gpt1/assay-bend2-v2.0.25
```

The Bend root is the pinned checkout at tag `v2.0.25`, commit
`c65bcb788dbfb298bb434c1d858b47c193841dc0`. The box is shared. The
1-minute load average stayed at 8 or more for 16 minutes of polling, so
the measurement ran under load. The load averages were 14.68, 15.62 and
13.32 before it and 13.96, 15.37 and 13.29 after it. Five rounds
completed in a 10.756-second window, below the 60-second limit.
`paired-measure.log` has the tool output.

The new report was frozen byte for byte as `dev/bend2-baseline.json` and
copied to `paired-measurement.json`. `dev/BEND2.sha256` was regenerated.
The previous active report stays retained as
`dev/validation/2026-09-25-m2-mapping/paired-measurement.json`, which is
byte-identical to it. No bound, limit, case set, round count or script
changed. After the freeze, `bend2-ratio-test-final.log` records
`BEND2-RATIO-TEST controls=3 refused=37 mutants=6 OK`.
`bend2-ratio-final.log` records the expected failure
`BEND2-BOUND limit=1.0 ratio=1.1504740989295137`. The ratio stays above
the unchanged 1.0 bound. The corpus measurement was not rerun; its gate
passes, so the mapping corpus freeze is unchanged.

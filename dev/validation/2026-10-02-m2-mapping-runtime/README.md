# M2 mapping runtime validation, 2026-10-02

This record discharges M2 group 1 in [the grouped plan](../../MILESTONE-GROUPS.md).
It does not close M2. Validation used base
`c6996645b3ae00db761cafc5cce6d75c46317eab` in an isolated shared clone,
the repository's pinned native Bend 2.0.28 compiler at
`bc178404f4778704fa5584a73fcdf72bcdf9f32c`, and the existing cast and geth tools.
[The manifest](manifest.json) records final source, artifact, toolchain and
evidence hashes. Each command capture has complete stdout, stderr and capture
metadata alongside this file. [Mapping runtime](../../M2-MAPPING-RUNTIME.md)
documents the implementation and remaining scope.

| Check | Command | Result and evidence |
| --- | --- | --- |
| Official build | `env BEND=.tools/bend/bin/bend python3 -P dev/build.py build` | Assay build passed; unchanged test and backend builds cached. [Capture](build-final.capture.json). The actual BEND path pointed to the main checkout's pinned compiler. |
| Native tests | `python3 -P dev/build.py runtest` | Kernel, adapters and roundtrips passed. [Output](native.stdout). |
| Mapping runtime | `python3 -P dev/mapping-runtime-test.py` | 40 live cases, 27 refusals, exact constructor and layout checks passed. [Output](review-mapping-runtime.stdout), [case evidence](cases/summary.json). |
| Packed source | `python3 -P dev/packed-source-test.py` | 66 cases and all six compiled mutants passed. [Output](packed-source.stdout). |
| Mapping source | `python3 -P dev/mapping-source-test.py` | 39 cases, 13 goldens, 26 refusals and two compiled mutants passed. [Output](mapping-source.stdout). |
| Mapping CLI | `python3 -P dev/mapping-cli-test.py` | 244 cases, 102 oracle rows, 10 reference rows, 46 refusals and 43 preservation controls passed after final review. [Output](mapping-cli-final.stdout). |
| Calldata CLI | `python3 -P dev/calldata-cli-test.py` | 53 encodings, 55 decodings, 196 refusals and two pin mutants passed. [Output](calldata-cli.stdout). |
| Return-data CLI | `python3 -P dev/returndata-cli-test.py` | 54 encodings, 55 decodings, 176 refusals and two pin mutants passed. [Output](returndata-cli.stdout). |
| Event CLI | `python3 -P dev/event-cli-test.py` | 56 cases and 36 refusals passed. [Output](event-cli.stdout). |
| Event decode CLI | `python3 -P dev/event-decode-cli-test.py` | 59 cases and 54 refusals passed. [Output](event-decode-cli.stdout). |
| Schedule controls | `python3 -P dev/milestone-speed-test.py` | 57 schedules and nine controls passed. [Output](schedule.stdout). |
| House audit | `python3 -P dev/house.py .` | All house checks passed on final source and registry hashes. [Output](house.stdout). |
| Carry audit | `python3 -P dev/carry-check.py .` | 12 of 12 files, no differences or unlisted files. [Output](carry.stdout). |
| R0 audit | `python3 -P dev/r0-audit.py .` | Passed. [Output](r0.stdout). |
| Trusted lines | `python3 -P dev/trusted-lines.py .` | Fixed module budgets passed. [Output](trusted-lines.stdout). |
| Paired measurement | `python3 -P dev/bend2-ratio.py --measure NEW.json --bend-root .tools/bend` | Five rounds, six cases, 7.676 second window. The report is now `dev/bend2-baseline.json`, sealed by `dev/BEND2.sha256`. [Output](review-bend2-measure.stdout), [seal check](review-bend2-seal.stdout). |
| Paired ratio | `python3 -P dev/bend2-ratio.py` | Red: ratio 1.894 against the 1.0 limit, measured on a loaded host. The previous freeze recorded 1.179. [Output](review-bend2-ratio.stdout). |
| Paired measurement controls | `python3 -P dev/bend2-ratio-test.py` | Three controls, 37 refusals and six mutations passed. [Output](review-bend2-ratio-test.stdout). |
| Denominator seal | `shasum -a 256 -c dev/DENOMINATORS.sha256` | All 301 rows OK, with four new rows. [Output](review-denominators.stdout). |
| Default gate | `python3 -P dev/stage-a-gates.py --m2-mapping-runtime` | Not run. The 102-leg battery remains for closure. |

Each live mapping case uses independently computed cast Keccak locations and
expected outcomes. The model, geth `evm run` and Cancun `evm t8n` must agree.
Raw inputs, outputs, traces and storage are preserved in `cases/`. The suite
also checks ordinary Word identifiers named `Mapping` and `assayMapUser`, the
32 user-member limit, zero-key snapshots, invalid key and value rollback,
boolean canonicality, narrow upper-bit preservation and three nested keys.

The new default schedule requires the exact marker
`MAPPING-RUNTIME live=40 refusals=27 constructor=1 layout=1 OK` and keeps the
101 predecessor legs, deadlines and markers. The full cumulative 102-leg
battery was not run this turn. Individual scoped suites and schedule controls
passed. Closure must run the cumulative battery and M2-ABI on final hashes.

Initial failures are retained. Parallel packed-mutant compilation killed the
model-preserve compiler with exit -9. [The first stderr](packed-source-first.stderr)
and [compiler result](packed-source-killed-mutant.json) record it. Serialization
reduced peak compiler memory; the complete retry passed with unchanged mutants,
assertions and deadlines. CLI preservation initially refused reviewed plan
plumbing, then missing helpers in historical baselines. The exact nine changed
declarations are now pinned, absent reviewed helpers remain detectable if
reachable, and changed, missing or duplicate pins are rejected.
The `mapping-cli-before-pins` and `mapping-cli-before-optional-baseline` captures
record those attempts. Return-data preservation found a comment attached to the
older `Mapping.Source.print` declaration. Removing it restored that declaration
exactly, and the suite passed. Its earlier failure is retained in
`returndata-cli-before-comment-fix.stderr`.

[The review record](review.json) records the final diff inspection and source
packet provenance. Source packets are conservative lookup evidence and do not
perform validation. Review covered mapping key order, separate temporary
memory, scratch placement, packed writes, rollback, user limits, source routing,
historical CLI preservation and gate continuity. Final review strengthened the
duplicate-baseline tests; the mapping CLI retry passed afterward.

The trusted-line audit does not assign an individual budget to `frontend.bend`,
where the new integration lives. Passing its fixed module budgets does not
measure this addition. Audit reconciliation remains M2 group 8. Typed source
function and result ABI, dynamic types, source events, complete ERC20 acceptance,
storage and refinement obligations, required negative Lean mutants and the final
M2-ABI gate remain open.

## Review

A review of the staged slice confirmed six findings and refuted one. This
turn fixed the six findings and ran the affected suites again. Files with
the `review-` prefix hold those captures: stdout, stderr and capture
metadata for each command.

- Member limit: the 32-member limit counts only user fields. The generated
  `assayMap` cell does not count. The
  [mapping runtime suite](review-mapping-runtime.stdout) passed with
  `MAPPING-RUNTIME live=40 refusals=27 constructor=1 layout=1 OK`.
- Deployer on a mapping root: `check` now refuses it. Before the fix,
  `check` accepted it and `emit` failed with `EMIT_INVALID`.
- Test strength: each refusal must exit 1 with its own diagnostic under
  `check`, `emit` and `run`. Layout type metadata must match exactly. The
  example adds a `Mapping Uint256 Address` field, so the suite covers
  `Uint256` keys and `Address` values.
- Scratch memory: the mapping scratch base follows the highest memory word
  of the program, not its instruction count. Peak memory is 352 bytes for
  `balanceOf` and 384 bytes for `approve`, below the 1024-byte check.
- Documentation: `README.md` and the dev pages no longer name the 101-leg
  return-data gate as the default.
- CLI pins: the member-limit fix changed `Contract.add_name`, so its digest
  pin in `dev/cli_delta.py` is new. The
  [mapping source](review-mapping-source.stdout) and
  [mapping CLI](review-mapping-cli.stdout) suites passed after the change.
- Seals: one detached run measured `dev/bend2-baseline.json` again
  ([output](review-bend2-measure.stdout)). The report records load averages
  of 11.95, 13.41 and 16.32 at the start; `uptime` showed 12.56, 13.55 and
  16.39 at launch. The host was not quiet. `dev/BEND2.sha256` has the new
  row ([check](review-bend2-seal.stdout)), and the measurement controls
  passed ([output](review-bend2-ratio-test.stdout)). The ratio is 1.894
  against the 1.0 limit, so the M4 speed leg stays red
  ([output](review-bend2-ratio.stdout)). The previous freeze recorded
  1.179. `dev/DENOMINATORS.sha256` adds rows for the four new files, and
  all 301 rows were generated again ([check](review-denominators.stdout)).
- Regressions: [build](review-build.stdout),
  [native tests](review-native.stdout),
  [packed source](review-packed-source.stdout),
  [calldata CLI](review-calldata-cli.stdout),
  [return-data CLI](review-returndata-cli.stdout),
  [event CLI](review-event-cli.stdout),
  [event decode CLI](review-event-decode-cli.stdout),
  [schedule controls](review-milestone-speed.stdout),
  [house](review-house.stdout), [carry](review-carry.stdout),
  [R0](review-r0.stdout) and [trusted lines](review-trusted-lines.stdout)
  passed again. `cases/` holds the final mapping runtime run.

The refuted report concerned `OPTIONAL_BASE` in `dev/cli_delta.py`. That
code did not change.

The review did not run the cumulative 102-leg battery
(`python3 -P dev/stage-a-gates.py --m2-mapping-runtime`). Closure must run it.

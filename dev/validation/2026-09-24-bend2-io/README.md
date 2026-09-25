# Byte-string IO validation

The base is `f29b428`. `REPORT.json` pins the changed implementation and the
captured outputs. All commands use the pinned Bend compiler with
`BEND_NO_TELEMETRY=1`.

Completed checks:

- `make test`: kernel fixtures and all 11 adapters, 17 adapter commands.
  This includes 618 assembly-compaction cases and source roundtripping.
- Native IO: 12 cases, including all byte values, empty and exact-chunk
  files, multiple chunks, truncation, Unicode paths and pipe backpressure.
- Keccak mutations: all four mutants killed (witnesses K2, K2, B136 and
  S1) and the restored control passed, using default compiler discovery
  after the scratch-copy fix.
- ABI codec: 48 cast comparisons, 49 vectors, five reference cases,
  26 negative cases, 288 prefixes, 128 fuzz trials and 10 killed mutants.

The broad `make gates` attempt was interrupted after it exposed missing
compiler discovery in mutation-test copies. Its log is retained in full.
It passed carry, R0, HOUSE, native maps, native IO, trusted-line limits,
kernel, surface, driver and audit-mutation checks before the interruption.
It also recorded a compaction timeout, although the subsequent `make test`
completed all 618 compaction cases. The full battery was not rerun to
completion. The focused Keccak and ABI mutation runs validate the repaired
scratch-copy path; the interrupted run does not constitute a full pass.

The current matched ratio is 1.445234 and the normalized corpus ratio is
1.198462, both above the unchanged 1.0 limit. The live reports and seals
contain fresh measurements. `before-ratio.json` retains the same-session
baseline; machine contention varied, so no percentage speedup is claimed.
The performance gates remain red. Earlier large-boundary failures are not
closed by this slice.

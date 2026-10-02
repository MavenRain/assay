# M2 event decoding CLI validation

Base: `7bca8dcfbfdbf76457dc7ea3ff7665351556c783`.

`make-test.stdout.log` and `make-test.stderr.log` contain the complete
successful `make test` run. Its capture manifest records exit code zero.
The final standalone decoder check also passed: 59 cases and 49
refusals. Cast produced the logs for 58 cases. The opaque case uses a
hand-built indexed string hash. `REPORT.json` contains the vectors,
expected typed values, refusal count, historical CLI compatibility result
and source hashes.
The full target also passed the existing encoder and mapping CLI suites,
including their pin controls, and the packed source execution and mutants.

`build.*` records the final compiler build. `compiled-assay.json` records
the compiler input and output identity. `audits.*` records passing house,
carry and trusted-line checks. The house inventory adds three named parser
refusals and updates moved line references; every existing arm remains
unchanged. The byte parser uses exhaustive list and option matches.
Usage and dispatch are the only updated CLI compatibility pins.

`SOURCE-HASHES.sha256` freezes changed inputs and direct dependencies.
`FILES.sha256` pins every other file in this directory. Full milestone
gates and M4 speed checks were not run. Event declarations and log emission
from source remain pending.

## Review fixes

A review of the staged slice found six defects, and this record contains
the fixes. The default `--m2-source-packing` schedule now runs
EVENT-DECODE-CLI, for 98 checks. The decoder refuses a topic or data
value above 131072 bytes with exit 64. Before this fix, such a value
could overflow the native stack. Five new refusal rows cover the
`--data` flag check, a misplaced `--anonymous` flag and the size limit.
After the fixes, the decoder check passed 59 cases and 54 refusals.
The `review-*.log` files record the rerun checks, and the
`review_changes` list in `REPORT.json` names each fix.
`compiled-assay.json` and the `build.*`, `audits.*`, `make-test.*` and
`event-decode-cli.*` files are from the slice before the review.

# M1 error mutations

`dev/errors-test.py mutants` builds each edit on a temporary source copy.
Each mutated compiler must build with zero errors and warnings, fail its
named semantic witness, then pass that witness after restoration.

| Mutation | Edit | Required failure |
| --- | --- | --- |
| SELECTOR | Shift the selector by 216 bits instead of 224 | `COUNTER-EXPECTED snapshot-1`, wrong revert bytes |
| MEMORY | Place the encoding buffer at zero | `COUNTER-EXPECTED snapshot-1`, repeated snapshot argument is overwritten |
| LENGTH | Omit the selector's four bytes from the REVERT length | `COUNTER-EXPECTED snapshot-1`, truncated output |
| ROLLBACK | Return modified model storage after a typed reject | `MODEL-EXPECTED witness`, prior write escapes rollback |
| ABI | Filter out every error row | `ERROR-WITNESS abi`, declarations missing from ABI |

SELECTOR, MEMORY and LENGTH use `snapshot(2,3)`, expecting the encoded
arguments `(3,2,3)`. ROLLBACK uses a balance error after writing 9 over 7.
The witness compares model output, storage and both Cancun execution
paths against independently specified expected values. Transcripts are
captured under `.gatework/errors`. The archived copies are the
`mutant-NAME.json`, `mutant-NAME-build.json`, `control-NAME.json` and
`control-NAME-build.json` captures in
`dev/validation/2026-09-12-m1-errors/evidence/`, with the leg output in
`dev/validation/2026-09-12-m1-errors/CUSTOM-ERRORS.log`.

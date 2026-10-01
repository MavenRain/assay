# Word prefix validation

The continuation starts at `91a27b76f4f5ad182aacbc47d6ddd29301a44ef6`.
Implementation and validation ran in `/Users/oobi/Documents/gpt1/assay-next`.
The changes are integrated and staged in `/Users/oobi/Documents/assay`.

`build.stdout.log` and its manifest record the passing native build.
`test.stdout.log` and its manifest retain the complete passing `make test`
run: the kernel suite, 24 commands across 18 adapters, keyword goldens,
287 core lexer cases, 303 contract lexer cases, 1,043 identifier goldens,
and 1,580 word parser goldens. The word check kills all three compiled
prefix-removal mutants and reruns its restored control.

`word-report.json` records the named mutant results and declaration hash.
`compatibility.json` records the unchanged 56 predecessor schedules, all
91 current legs and the normalized CLI bundle. Each of the seven pinned
declarations must retain its exact digest. Missing, duplicate and modified
word parser declarations are refused, while an unrelated reachable helper
change remains visible. `trusted-lines.stdout.log` records the passing
source budget without changing its limits.

`paired-measurement.json` is the first five-round compiler measurement,
taken while `make test` was still running. It is retained for provenance.
`paired-measurement-final.json` was taken after that process completed and
is byte-identical to the active `dev/bend2-baseline.json`. It reports
1.312470762 against the unchanged 1.0 speed bound, in a 13.638-second
host window. The records do not isolate the effect of this source change.
The speed gate therefore remains failing. The final gate log records that
failure, and the ratio refusal controls are checked separately.

`FILES.sha256` seals the archived evidence. Native carry and denominator
seals follow changed source and metadata without removing existing paths.
The complete milestone gate battery was not run. This record does not
close M1 performance or M2.

The review after this record changed four things. It resealed the
`Recognize.parse_word` anchors in `dev/mutations/hex-literals.json` and
`dev/mutations/contract.json` to the new declaration digest. It merged the
two WORD-DIRECT output lines into one gate marker that pins 1,580 cases,
1,580 goldens and three mutants. It updated the current leg count, pin list
and frozen ratio in the other documents, and it added a build log entry.
The logs in this directory predate those changes and show the earlier
two-line output.

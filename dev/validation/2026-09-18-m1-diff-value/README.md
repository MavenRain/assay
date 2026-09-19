# Differential call-value validation

Base: `97be2654adf0f791ea2418d1f1c4bf7e0b79fd27`.

The build and all nine selected validation legs pass. DIFF-VALUE
records 32 source-model/EVM cases, 32 signed Cancun transitions and
31 refusals. DIFF-EXECUTOR retains its existing 20 live, 28 driver
and 24 damaged-capture refusal cases. SCOPED.json records the seven
carry, audit, house-rule, trusted-line, CLI and trace regressions.
Their logs preserve the existing success markers.

GATE-COMPATIBILITY.json records the base, the count of 64 unchanged
prior gate declarations, the new DIFF-VALUE leg tuple and the sha256
of the post-change dev/stage-a-gates.py. SOURCES.json hashes the
final changed source files and the unchanged model, example and
executor inputs used by these tests. FINAL.json records the scope and
final results. ARTIFACTS.json hashes the other archive files.

diff-value-witnesses.json.gz retains the focused commands, complete
stdout and stderr, expected outcomes, model outcomes, EVM reports,
actual executor arguments and signed transaction requests. The signing
key is geth's existing public fixture key 1. All execution is offline.
Both EVM paths use geth. Balances, nonces and logs are outside the
differential comparison.

BUILD and DIFF-EXECUTOR include their captured command manifests.
DIFF-VALUE-FIRST records an initial test-harness failure caused by
passing the fixture address to the model without its hexadecimal
prefix. The corrected focused gate passes in DIFF-VALUE.log.

The scratch checkout is
`/Users/oobi/Documents/gpt1/assay-m1-diff-value`.
The build unsets OPAM_SWITCH_PREFIX, CAML_LD_LIBRARY_PATH, OCAMLPATH
and OCAMLFIND_CONF and uses `zsh -f dev/dunecho.sh build`. A local
dune-workspace keeps Dune rooted in that scratch checkout; it is not
part of the staged change. Commands ran through kanon-wait and
kanon-exec with bounded replies.

The complete ladder was not rerun. The inherited DENOMINATORS and
M0-RATIO timing pause is unchanged. This archive claims no performance
result, full-ladder pass or milestone completion.

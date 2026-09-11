# Stage E validation, 2026-09-10

Base: `8d4bd9de0249340a6c8316f57ec6cf65b999cc23` (Stage D).
The scratch checkout is `/Users/oobi/Documents/gpt1/assay-stage-e`.
The command was `env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH
-u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh`.
All 29 legs pass.  The Lean gate ran; it did not skip.

`GATES.log` records the full result.  The named leg logs and the mutant
and restored-control logs retain the witnesses.  `ORACLES.json` contains
complete argv, exit status, stdout and stderr for the geth and cast calls.
Every geth execution names `evm/fixtures/cancun.json`.  Deliberately invalid
fork probes retain their expected diagnostic in those receipts.

`Ref20/` holds a fresh emission of the validated source.  The runtime is
the exact 20-byte committed reference.  Creation is 30 bytes and runtime
execution uses 22,232 gas under the explicit fixture.  Stage F owns corpus
measurements; these numbers are not a throughput or M0-exit claim.

`SOURCES.json` pins the carried validation inputs, backend sources,
driver, tests, fixtures and all 28 proof-seed files used by this run.
It excludes this evidence directory and prose build/mutation logs.
`proof-build.log` reports zero errors, sorries and warnings.
`proof-report.log` holds all 42 dependency reports.  The proof seed's
fidelity limits remain in `proofs/FIDELITY.md`.

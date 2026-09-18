# Hexadecimal Word literal validation

Base: `c8f85f7cb4d318c3aefcd4640b08bff4890fc785`. All 60 functional legs
pass in the 62-leg battery after the AXIOMS and INFERRED-GUARDS rechecks
recorded in `RECHECKS.json`. The first run lacked the offline Lean
dependency cache. Its original AXIOMS failure is retained in
`AXIOMS.log`, and the successful rerun retains the unchanged command,
deadline, test source hash and complete output.
The inferred-guard argument-reversal mutant failed at the independent
runtime expectation after condition conversion was shared. Its old
compile-refusal marker was updated to that exact runtime failure. The
original gate failure and mutant output are retained; all four mutants
and their restored controls pass on the rerun. The complete rerun
witness archive is `INFERRED-GUARDS-witnesses.json.gz`.
`DENOMINATORS` and `M0-RATIO` fail against the preserved timing inputs
under the existing pause. The aggregate battery exits 1 and its FAIL
stamp is retained verbatim in `GATES.log`. No performance or milestone
exit claim is made.
`M0-RATIO.log.gz` preserves its full raw log, including the final blank
line, without introducing a whitespace error in the staged text diff.

`HEX-LITERALS.log` records 30 artifact pairs, 46 runtime cases, 25
signed Cancun comparisons, 23 creation outcomes, 23 refusals and four
detected compiler mutations with passing restored controls.
`PAIRS.json`, `LIVE.json`, `CREATES.json`, `REFUSALS.json` and
`MUTANTS.json` retain the cases and source hashes.
`hex-literals-witnesses.json.gz` maps every focused test artifact path
to its full text, including sources, all five emitted artifacts, process
arguments, exit codes, stdout, stderr and signed transition evidence.
The two execution paths both use geth.

All 61 prior gate declarations retain identical ASTs, commands,
deadlines and markers in `GATE-COMPATIBILITY.json`. `FINAL.json` records
the exact compiler identity and protected paths. `SOURCES.json` hashes
988 tracked and untracked nonignored regular files outside
`dev/validation/` and `vendor/`, including documentation. The manifest
does not hash its own archive. `ARTIFACTS.json` hashes all other archive
files, including this README. `CAPTURE.json` retains capture metadata.

Run `zsh -f dev/gates.sh` with the offline proof dependencies and tools
from `dev/TOOLCHAIN.md`. This run reused the locally provisioned proof
cache from the preceding Word equality workspace. The unchanged
axiom gate verifies its dependency revisions before using the cache.

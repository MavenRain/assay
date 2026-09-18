# Word equality validation

Base: `92aa8a903910a03d43c7b50b212efd9a8ddefa28`.
All 59 functional legs pass in the 61-leg battery.
`DENOMINATORS` and `M0-RATIO` fail against the preserved timing inputs
under the existing pause. The aggregate battery exits 1 and its FAIL
stamp is retained verbatim in `GATES.log`. No performance or milestone
exit claim is made.
`M0-RATIO.log.gz` preserves its full raw log, including the final blank
line, without introducing a whitespace error in the staged text diff.

`WORD-EQUALITY.log` records eight artifact pairs, 53 runtime cases,
33 signed Cancun comparisons, eight creation outcomes, six boundary
forms, 17 refusals and four detected compiler mutations with passing
restored controls. `PAIRS.json`, `LIVE.json`, `CREATES.json`,
`BOUNDARIES.json` and `MUTANTS.json` retain the cases and source hashes.
`equality-witnesses.json.gz` maps every focused test artifact path to
its full text, including sources, all five emitted artifacts, process
arguments, exit codes, stdout, stderr and signed transition evidence.
The two execution paths both use geth.

All 60 prior gate declarations retain identical ASTs, commands,
deadlines and markers in `GATE-COMPATIBILITY.json`. `FINAL.json` records
the exact compiler identity and protected paths. `SOURCES.json` hashes
983 tracked and untracked nonignored regular files outside
`dev/validation/` and `vendor/`, including documentation. The manifest
does not hash its own archive. `ARTIFACTS.json` hashes all other archive
files, including this README. `CAPTURE.json` retains capture metadata.

Run `zsh -f dev/gates.sh` with the offline proof dependencies and tools
from `dev/TOOLCHAIN.md`. This run reused the locally provisioned proof
cache from the preceding context surface workspace. The unchanged
axiom gate verifies its dependency revisions before using the cache.

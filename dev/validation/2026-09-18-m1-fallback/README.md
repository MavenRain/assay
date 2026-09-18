# Fallback validation

Base: `3e997f1bb4c69a35ee065018ac1238856cbe3b8c`.
The complete 64-leg battery records 61 passes and three failures in
GATES.log and exits 1. AXIOMS initially lacked the preprovisioned
kan-tactics dependency. CACHE.json records 35 matched proof inputs and
two verified dependency revisions restored from the local cache.
AXIOMS-RECHECK.log and its capture record the passing scoped recheck,
including all 42 theorems, 28 carried files and three controls.
All 62 functional legs are therefore verified. DENOMINATORS and
M0-RATIO remain failed under the existing timing pause. The initial
failure and aggregate FAIL stamp are preserved. No performance or
milestone exit claim is made. M0-RATIO.log.gz preserves its full output.

FALLBACK.log records 99 model and EVM cases, 99 signed Cancun
transitions, ten creation checks, 23 refusals, two boundary checks and
six mutations with passing restored controls. LIVE.json, CORE-LIVE.json,
REFUSALS.json, CORE-REFUSALS.json, BOUNDARIES.json and MUTANTS.json retain
the cases. fallback-witnesses.json.gz maps every focused artifact path
to its full text, including sources, emitted files, command arguments,
stdout, stderr and signed transition evidence. Both EVM paths use geth.

ARTIFACT-COMPATIBILITY.json records all 185 identical artifacts from
37 legacy sources, comparing the current compiler against a separately
built snapshot of the base commit. BASELINE-BUILD.log and
artifact-compatibility.py retain that check. The snapshot adds a local
dune-workspace solely to prevent Dune selecting the enclosing checkout.

GATE-COMPATIBILITY.json pins the unchanged ASTs, commands, deadlines
and success markers of all 63 prior gate declarations. FINAL.json
records both the initial battery results and the resolved axiom gate.
SOURCES.json hashes 998 nonignored source and documentation
files outside dev/validation and vendor. ARTIFACTS.json hashes all other
archive files, including this README.

Scratch checkout: `/Users/oobi/Documents/gpt1/assay-m1-fallback`.
The captured battery command is `env -u OPAM_SWITCH_PREFIX -u
CAML_LD_LIBRARY_PATH -u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh`.
The scoped recheck is `python3 -P dev/proofs-test.py`. Both ran through
kanon-wait and kanon-exec with bounded replies.

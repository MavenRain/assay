# Proof guard validation

Validated from `/Users/oobi/Documents/gpt1/assay-m1-guards` on base
`77b24f7a354f916ebf388759b678476f38129ae9`.

`GATES.log` is the complete original `zsh -f dev/gates.sh` transcript.
The initial 44-leg run has three mutation-anchor failures in addition
to the expected denominator and timing failures. `rechecks/` contains
complete runs of the three repaired gates. The compiler is identical
between the battery and those rechecks. No mutation count or witness
was dropped, and all restored controls are required.

`RUN.json` records both the initial verdict and the combined result:
42 passing legs, with `DENOMINATORS` and `M0-RATIO` still failing.
Their old source manifest and timing report remain preserved because
timing is paused. There is no complete-battery pass or fresh timing
verdict. `CAPTURE.json` retains the original command and exit status.

`guards/` contains the source-model and both Cancun captures, positive
and negative checks, erasure comparisons, emitted output hashes,
mutation witnesses and restored controls. The complete guard gate
passes 83 cases, two creation outcomes, 24 refusals, three proof
variants and six mutants. All 252 counter instructions execute.
`source-proofs/` retains the existing Lean model's axiom, executable
and mutation evidence. That model covers the earlier Result protocol.
`CACHE.json` records matched proof sources and dependency revisions.

`SOURCES.json` hashes the prior validation source closure plus every
changed or added source and document in this slice. `ARTIFACTS.json`
hashes the retained evidence, excluding itself. Final documentation
and identity checks are recorded under `final-checks/`.

`ARCHIVE-FORMAT.json` preserves the exact raw output of the two ratio
logs, including their blank lines at EOF. The readable text copies
omit those terminal blank lines so the staged whitespace check passes.
The capture metadata describes the raw streams; the format record
hashes both forms.

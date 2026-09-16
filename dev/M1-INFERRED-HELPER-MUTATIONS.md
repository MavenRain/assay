# Inferred helper argument mutations

`dev/inferred-helper-test.py mutants` makes a temporary source copy,
builds each mutation, runs its named witness, restores the original
compiler, rebuilds and requires the same witness to pass.

| Mutation | Change | Witness | Required failure |
| --- | --- | --- | --- |
| EVIDENCE | Drop evidence when filling omitted helper arguments | anonymous-add | M1-TOOL anonymous-add |
| LOCAL | Drop newly bound proof-local evidence | proof-local-add | M1-TOOL proof-local-add |
| PARAMETER | Drop generic helper parameter evidence | helper-body-add | M1-TOOL helper-body-add |
| SUPPLIED | Replace supplied proof checking with evidence inference | explicit-invalid | ERROR-REFUSAL ih-explicit-invalid |
| SHARING | Copy proof arguments instead of binding their checked values | boundaries | IH-NESTED proof expression growth |

Build failures do not count as kills. Each mutated witness must exit 1
with its required marker; the restored control must exit 0. Captures
record source hashes, command outcomes and the named witnesses.

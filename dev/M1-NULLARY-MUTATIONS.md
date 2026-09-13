# M1 nullary mutation witnesses

`dev/nullary-test.py mutants` builds each mutant in a temporary copy,
requires its named witness to exit 1, restores the source, rebuilds,
and requires the same witness to pass. A build failure is not a kill.

| Mutation | Edit | Required witness |
| --- | --- | --- |
| SURFACE-UNIVERSE | Generate bare `prod ()` for an all-nullary table | `NULLARY-WITNESS surface` |
| UNIT-RECOGNIZER | Accept the explicit empty product at `Prop` instead of `Type 0` | `NULLARY-WITNESS core` |
| UNIT-SCHEMA | Reconstruct annotated argument records without their annotation | `NULLARY-WITNESS core` |

These witnesses catch loss of accepted emission. Restored controls also
run the selected `get()` branch against its storage expectation. The
live suite independently checks selector behavior through the source
model and both EVM execution paths. Four negative schema cases cover
unannotated tables, explicit `Prop`, aliases and annotated nonempty
records. Captures retain each build and witness result.

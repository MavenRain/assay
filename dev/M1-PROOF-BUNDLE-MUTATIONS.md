# Proof bundle mutation witnesses

`dev/proof-bundle-test.py mutants` builds each mutation in a temporary
copy and runs its named witness. Each restored compiler must build
without warnings and pass the same witness. A build failure alone does
not count as a killed mutation.

| Mutation | Changed behavior | Witness |
| --- | --- | --- |
| SECOND-CHECK | Replace the supplied second component with unit before checking | `argument-discarded` supplies a false annotation in an unused helper argument; the mutant incorrectly accepts it |
| PROJECTION | Exchange product projection indices | `projection-valid` compiles a bundle with distinct ordering and addition claims; the mutant selects a component of the wrong type |
| CLAIM-DEPTH | Raise the new claim limit from 32 to 128 | `claim-depth` supplies 33 nested products; the mutant accepts the out-of-bound program |
| INVARIANT-COMPONENTS | Register only the bundle as final-state evidence | `invariant-components` needs both bounds after Word aliases; the mutant cannot establish the final atomic claims |

The gate checks the exact mutation anchor, successful mutant build,
named failure diagnostic, expected witness exit, restored build and
restored witness. All four mutations must be killed.

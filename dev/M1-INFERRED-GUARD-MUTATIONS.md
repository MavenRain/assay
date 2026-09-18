# Inferred guard mutations

`dev/inferred-guard-test.py mutants` builds each altered compiler in a
temporary copy, runs the named witness, then restores and rebuilds the
source and requires the same witness to pass. Build failures cannot
satisfy a kill. All builds must report zero errors and warnings.

| Mutation | Changed behavior | Witness | Required failure marker |
| --- | --- | --- | --- |
| CLAIM | Reverse an inferred atomic ordering claim. | `separate-evidence` | `M1-TOOL separate-evidence` |
| NAMED-ARGUMENTS | Reverse predicate arguments in the shared claim and runtime conversion. | `named` | `MODEL-EXPECTED ig-named-1` |
| EVIDENCE | Discard evidence collected by proof guards. | `invariant` | `M1-TOOL invariant` |
| STALE-STATE | Skip final-state invariant obligations. | `stale-invariant` | `ERROR-REFUSAL ig-stale-invariant` |

Each altered compiler must build successfully. The mutant witness must
exit 1 with its specified marker, and the restored control must exit 0.
The live witnesses use symbolic entry inputs. The atomic claim and
missing evidence mutations are checked by the kernel. Since the
hexadecimal literal slice shares condition-to-claim conversion, reversing
named predicate arguments changes both the inferred claim and its runtime
condition. The independent expected outcome for `ig-named-1` kills this
mutation even though the reversed guard and claim agree with each other.
The stale-state witness overwrites a field after
the guard and must be refused by all three public commands. Letting any
command accept it kills that mutant.

The gate records build and witness captures plus source hashes in
`.gatework/inferred-guards`. `MUTANTS.json` identifies the four
witnesses and their controls; frozen evidence accompanies the build log.

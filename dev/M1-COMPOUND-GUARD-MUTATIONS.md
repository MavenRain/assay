# M1 compound guard mutations

The suite mutates a temporary compiler copy and builds every mutant.
Each named witness must fail for the altered compiler and pass after
restoring the original source. The runtime suite compares storage,
return data and revert data with the source model and Cancun execution.

| Mutation | Change | Witness |
| --- | --- | --- |
| PAIR-ORDER | Reverse the checked components in the proof pair. | `custom` must emit and execute the ordering/addition guard. |
| ERROR-PAYLOAD | Replace the checked custom failure with an empty revert. | `custom` must preserve the declared selector and both Word arguments. |
| COMPONENT-EVIDENCE | Omit the guard bundle from invariant evidence. | `invariant` must check and emit the dynamic final-state obligation. |
| CHECK-ORDER | Execute the right component before the left component. | `erasure` must match the equivalent separate guards in all five files. |

The first and third mutants are rejected while emitting their valid
witnesses. The second violates expected revert data. The fourth changes
the emitted runtime and listing while leaving the logical conjunction
equivalent. Build failures do not count as killed mutants.

The existing proof-guard suite also retains its six mutations. Its
CLAIM mutation reconstructs the runtime claim from `Check` and `Conjoin`
before discarding the source annotation. This preserves the original
false-claim witness against the new condition type. The remaining five
mutations and all six kill criteria are unchanged.

The predicate suite's EXPANSION mutation targets the expanded-claim
budget specifically. Guard conditions now have a separate bound budget,
so the original short text anchor occurred twice. Its expanded-node
witness and required rejection are unchanged.

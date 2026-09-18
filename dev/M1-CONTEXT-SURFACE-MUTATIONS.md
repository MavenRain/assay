# Surface context mutations

Each mutation is compiled in a disposable copy. Compilation must succeed
without warnings. The named witness must exit 1 with its diagnostic,
and the restored source must rebuild and pass the same witness.

| Mutation | Changed behavior | Witness |
| --- | --- | --- |
| CALLER | Replace a caller binding with the literal zero | Five-file comparison with the core caller program |
| DEPLOYER | Initialize a deployer field with zero | Five-file comparison with the core deployer program |
| STATE | Keep the previous literal value after a deployer write | Reject a constructor whose owner invariant used stale zero |
| SLOT | Always initialize slot zero | Execute a constructor that initializes the second field |

The caller and deployer mutations fail `SURFACE-CONTEXT-PAIR`.
The state mutation fails `SURFACE-CONTEXT-REFUSAL stale-invariant`.
The slot mutation fails `SURFACE-CONTEXT-ORDER deployer-only`.
`MUTANTS.json` in the validation archive retains the source hashes,
exit codes and diagnostic markers. Full command captures include the
builds and restored controls.

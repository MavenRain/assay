# M1 surface mutation ledger

`dev/contract-test.py mutants` builds each mutation in a temporary copy,
requires the named witness to fail with the expected diagnostic, restores
the original module, rebuilds and requires that same witness to pass.
Build failures never count as kills. Every mutation changes only
`emit/contract.ml`; the witness source and expected outcomes stay fixed.

| Mutation | Change | Witness | Required failure |
| --- | --- | --- | --- |
| SLOT | Reverse the two storage field indices | `get-nonzero` | `MODEL-EXPECTED get-nonzero` |
| ARGUMENT | Reverse the two argument indices | `two-args` | `MODEL-EXPECTED two-args` |
| SUBTRACTION | Lower subtraction as addition | `decrement-success` | `MODEL-EXPECTED decrement-success` |
| GUARD | Swap the operands of `le` | `increment-success` | `MODEL-EXPECTED increment-success` |
| STORE | Replace the stored value with zero | `increment-success` | `MODEL-EXPECTED increment-success` |
| SHADOW | Resolve an earlier binding before the new binding | `shadow` | `MODEL-EXPECTED shadow` |
| SHADOW-LOAD | Resolve an earlier binding before an `sload` binding | `shadow-load` | `MODEL-EXPECTED shadow-load` |
| LITERAL | Admit a 257-bit literal | `word-range` | `SURFACE-REFUSAL word-range` |

The first seven fail by disagreeing with a fixed source-model outcome.
LITERAL fails because `check` accepts an out-of-range surface literal;
the control requires the source refusal through `check`, `emit` and `run`.
Each raw build, kill and restored-control capture is retained in the
validation archive. The final marker is
`SURFACE-MUTANTS killed=8/8 controls=8 OK`.

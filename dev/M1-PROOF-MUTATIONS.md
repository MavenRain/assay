# M1 source-proof mutation ledger

Each mutation runs in a temporary copy. Runtime mutations must build before
their named witness can kill them. Every restored copy must build without
errors, sorries or warnings and pass the addition control with operands 2
and 1, including its complete arithmetic trace.

| Mutation | Change | Required witness |
| --- | --- | --- |
| EXACT-ADD | Claim the returned sum is one larger | Lean rejects the exactness theorem in Arithmetic.lean |
| UPPER-BOUND | Accept a sum equal to the modulus | Lean rejects the invalid Fin bound in Arithmetic.lean |
| SUB-ORDER | Reverse the subtraction precondition | Lean rejects the success/error evidence in Arithmetic.lean |
| TRACE | Drop the event from a completed arithmetic node | The 2 + 1 result has an empty trace |
| DISPATCH | Swap add and sub in the JSON adapter | The requested 2 + 1 returns 1 |
| ERROR-BRANCH | Follow success after a rejected operation | Maximum word plus one reads the missing success snapshot 3 |

The report controls inject `sorryAx`, inject an unlisted axiom, omit one
theorem report and duplicate one report. All four must be rejected.
Existing OCaml model and EVM-emitter mutations remain in the full battery.

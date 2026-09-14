# M1 proof helper mutations

`dev/proof-helper-test.py mutants` builds each changed compiler on a
temporary copy, runs its named witness, restores the compiler, and
requires the same witness to pass. A build failure does not kill a
mutation. The test retains commands, exit statuses and output captures.

| Mutation | Change | Killing observation |
| --- | --- | --- |
| DECLARATION | Drop generated helper definitions | `unused-false` accepts a false unused declaration, violating the required refusal |
| SHADOW | Ignore a local binding shadowing a helper | `word-shadow` accepts a helper call after a Word shadows its name |
| MEMBERS | Skip helper name registration and its member bound | `helpers` accepts 33 helper declarations |
| ARGUMENTS | Reverse the assembled core arguments | `apply-order` refuses a valid ordered subtraction program |

The original compiler must reject the three invalid witnesses and
compile and execute the subtraction witness with result 5 and updated
storage. Every restored control must pass. The gate requires four kills
and four restored controls.

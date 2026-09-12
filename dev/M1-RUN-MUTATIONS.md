# Source model mutation witnesses

Each mutation edits `emit/model.ml` in a temporary copy, rebuilds, and runs
one named `dev/model-test.py witness NAME` case. Exit 1 must contain the
exact `MODEL-EXPECTED NAME` witness. A build failure does not count as a
kill. Restoring the source, rebuilding and rerunning must exit zero.
`MODEL-MUTANT-SURVIVED NAME` means that the witness passed against the
mutant. `MODEL-MUTANT-WITNESS NAME` means that the witness did not run to
its expected failure.

| Mutation | Edit | Witness |
| --- | --- | --- |
| VALUE | Disable nonzero call-value refusal | value-get |
| OVERFLOW | Permit a 257-bit addition result | add-recovery |
| UNDERFLOW | Permit a negative subtraction result | sub-recovery |
| BOUND | Make the upper-bound comparison strict | increment-at-limit |
| SNAPSHOT | Replace loaded values with zero | snapshot |
| ROLLBACK | Revert with the written storage image | write-abort |
| HEAD | Decode two arguments after only checking the selector length | short-two |
| M0-WRITE | Store zero instead of the effect's value | m0-write |

The recovery witnesses matter: the counter's later limit check can mask a
broken overflow guard, and its pre-subtraction comparison can mask a broken
underflow guard. The dedicated programs distinguish arithmetic errors from
successful results without those later guards.

Build logs, mutant results and restored controls are retained under
`.gatework/model/`, alongside the live model and executor captures.

# M1 named guard mutations

`dev/named-guard-test.py mutants` builds each modified compiler in a
temporary copy, runs its witness, restores the original source, builds
again and requires the control to pass. A build failure is not a kill.

| Mutation | Change | Required failing witness |
| --- | --- | --- |
| ARGUMENT-ORDER | Reverse predicate call arguments | `M1-TOOL named` |
| SHADOW | Accept a locally shadowed predicate name | `ERROR-REFUSAL ng-word-shadow` |
| EXPANDED-BOUNDS | Remove the expanded atomic-check limit | `ERROR-REFUSAL ng-expanded-bounds` |
| SHARED-BUDGET | Reset the limit for every right branch | `ERROR-REFUSAL ng-aggregate-bounds` |

The argument-order witness uses a direct predicate definition. This
prevents two nested reversals from canceling each other. Its annotation
is inline, so reversing the runtime arguments cannot also rewrite the
annotation. The kernel must reject the resulting ordering mismatch.

The scope witness uses an inline annotation and a runtime predicate
shadowed by a local Word. The limit witnesses expand to 65 bounds and
two 40-bound branches respectively. Refusal checks cover all three
source commands and require no output directory to be created.

The earlier proof-guard CLAIM mutation now infers its false replacement
annotation from resolved runtime conditions. Its original false-claim
witness and required failure marker are preserved. The compound-guard
suite now rejects an unknown named runtime predicate in place of its
former rejection of every named runtime condition.

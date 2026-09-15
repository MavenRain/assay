# M1 predicate mutation witnesses

`dev/predicate-test.py mutants` copies the source to a temporary tree,
changes one compiler anchor, builds it and runs a named witness.
It restores the original compiler and requires the same witness to pass.
Build errors do not count as kills.

| Mutation | Named witness | Required observation |
| --- | --- | --- |
| UNUSED-DECLARATION | unused-declaration | An unused definition with an unknown predicate must be rejected. |
| UNUSED-ARGUMENT | unused-argument | An unbound argument must be rejected even if the predicate ignores it. |
| ARGUMENT-ORDER | argument-order | Applying `Below` to zero and one must check; reversing the arguments falsifies the claim. |
| EXPANSION | expanded-nodes | A duplicating definition above the shared expansion budget must be rejected. |

Refusal witnesses run through check, emit and run. They require a typed
refusal and no emitted files. The accepted argument-order witness emits
through the ordinary compiler. Captures retain the build, killing
observation and restored control for each mutation.

# M1 inferred proof binding mutations

Each mutation builds in a temporary copy and runs a focused witness.
A build failure does not count as a kill. The mutated compiler must
fail the witness with its expected diagnostic; the restored compiler
must pass it.

| Mutation | Change | Killing witness |
| --- | --- | --- |
| ENTRY-EVIDENCE | Omit the inferred binding's evidence in the continuation | binding-evidence |
| LOCAL-EVIDENCE | Omit the proof-local binding's evidence in its body | local-evidence |
| ANNOTATION | Infer a type even when a binding annotation was supplied | wrong-annotation |
| UNUSED | Drop an unused inferred binding before the kernel checks it | unused-false |
| BUNDLE-LIMIT | Widen the inferred claim budget to 8192 nodes | bundle-expansion |
| DEPTH-LIMIT | Widen the inferred pair claim depth bound to 1024 | spine-depth |

The first two witnesses require emission and Cancun execution and fail
at `M1-TOOL` when evidence is lost. The third requires rejection of a
false annotation despite a valid initializer. The fourth requires
rejection of an unused initializer with a false claim. The latter
mutants accept invalid sources and fail at `ERROR-REFUSAL`. The fifth
witness requires rejection of a 4097-node inferred bundle and also
fails at `ERROR-REFUSAL` when the limit is widened. The sixth witness
requires rejection of a 33-level inferred claim spine, which holds 67
nodes and therefore passes the node budget alone.

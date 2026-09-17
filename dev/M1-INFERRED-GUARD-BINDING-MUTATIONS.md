# M1 inferred guard binding mutations

Each mutation builds in a temporary copy and runs a focused witness.
A build failure does not count as a kill. The mutated compiler must
fail the witness with its expected diagnostic; the restored compiler
must pass it.

| Mutation | Change | Killing witness |
| --- | --- | --- |
| ANNOTATION | Infer a claim despite a supplied annotation | annotation |
| BINDING | Replace the source proof name with an internal name | named |
| ATOMIC-CLAIM | Reverse the inferred ordering claim | atomic |
| NAMED-ARGUMENTS | Reverse arguments in the inferred predicate claim | named |

The first witness requires rejection of an annotation whose operands
differ from the condition. Its mutant accepts that source and fails at
`ERROR-REFUSAL igb-annotation`. The remaining witnesses require checked
emission and execution. They fail at `M1-TOOL named` or `M1-TOOL atomic`
when the inferred claim or the name available to projections is wrong.

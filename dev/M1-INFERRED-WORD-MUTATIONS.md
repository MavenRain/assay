# Inferred Word binding mutation witnesses

`dev/inferred-word-test.py mutants` builds each mutation in a temporary
copy, checks its named failing witness, restores the source, rebuilds
and requires the same witness group to pass. Build failure does not
count as killing a mutation.

| Mutation | Defect | Required failing witness |
| --- | --- | --- |
| IMPLICIT | Require the old annotation for every Word binding | `WORD-EMIT decimal` |
| ANNOTATION | Ignore a supplied annotation's type | `WORD-REFUSAL wrong-annotation check` |
| ERASED | Replace an erased proof used as a Word with zero | `WORD-REFUSAL erased-value check` |
| SHADOW | Append a new binding behind its older namesake | `WORD-MODEL local-shadow-6` |

IMPLICIT exercises the new parser branch. ANNOTATION protects the
explicit spelling's type requirement. ERASED and SHADOW exercise the
shared lowering used by the new spelling. The shadow witness uses an
independent numeric expectation under the source model. The ordinary
suite also compares all runtime cases with geth and signed Cancun
transitions.

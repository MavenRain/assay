# Equality mutation contract

`dev/equality-test.py` builds each changed compiler in an isolated copy.
The named witness must exit 1 with its marker. The source is restored,
rebuilt and the same witness must exit 0. Build failures do not count
as detected mutations. Source hashes and process output are retained.

| Mutation | Compiler change | Witness | Required failure marker |
| --- | --- | --- | --- |
| RUNTIME | Duplicate the forward runtime bound in place of the reverse bound | `live` | `EQUALITY-MODEL words-0-1` |
| CLAIM | Duplicate the forward proof claim in place of the reverse claim | `pairs` | `EQUALITY-EMIT pair-typed` |
| PAYLOAD | Stop recognizing equality as the condition after a custom error payload | `pairs` | `EQUALITY-EMIT pair-typed` |
| DEPTH | Admit an equality pair whose generated leaves exceed claim depth 32 | `boundaries` | `EQUALITY-BOUNDARY claim-depth-32` |

The runtime witness compares the source model with a Python equality
expectation for zero and one. The claim witness requires a valid typed
equality guard and both proof projections to compile. The payload
witness supplies two error arguments before the equality condition.
The depth witness requires refusal at the expanded claim boundary.

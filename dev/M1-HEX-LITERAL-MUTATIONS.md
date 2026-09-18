# Hexadecimal literal mutations

`dev/hex-literals-test.py mutants` builds each altered compiler in a
temporary copy, runs the named witness, restores the source and reruns
that witness. Build failures do not count as kills. Per-attempt build
and execution transcripts are retained in the validation archive.

| Mutation | Change | Required failing witness |
| --- | --- | --- |
| RADIX | Read hexadecimal digits in base ten | `pairs`: `HEX-PAIR value-00 runtime.hex` compares `0x10` with decimal 16 |
| EMPTY | Remove the requirement for digits after the prefix | `refusals`: `HEX-REFUSAL empty-lower check` rejects `word 0x` |
| RANGE | Admit decimal 2^256 at the surface boundary | `refusals`: `HEX-REFUSAL decimal-overflow check` requires the surface Word diagnostic |
| NORMALIZE | Preserve noncanonical decimal spelling | `pairs`: `HEX-EMIT proof-inference` requires evidence established with `0X0A` to serve arithmetic using `00010` |

`MUTANTS.json` records source hashes, exits and witness markers for all
eight mutant/control attempts. The full gate also checks digits in both
cases, zero, leading zeros, large exact values, the highest bit, uint160
constants and the maximum uint256 value against independent outcomes.

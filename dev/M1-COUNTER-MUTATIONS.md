# Counter reference mutation witnesses

`dev/counter-test.py` mutates a copy of the frozen runtime bytes in memory.
The reference files stay unchanged. Each mutant executes on both geth
paths and must reach executor agreement, then fail the exact
`COUNTER-EXPECTED CASE` check. An EVM fault or an adapter error does not
count as a kill. The restored original runs on the same case after each
kill and must pass.

| Mutation | Byte edit | Witness |
| --- | --- | --- |
| CALLVALUE | Replace CALLVALUE with PUSH0 | `value-increment` succeeds instead of reverting |
| OVERFLOW | Replace the sum-below-count LT with GT | `increment-overflow` accepts a wrapped sum |
| BOUND | Replace the sum-above-limit GT with LT | `increment-over-limit` accepts 101 with limit 100 |
| UNDERFLOW | Replace the argument-above-count GT with LT | `decrement-underflow` accepts a wrapped difference |
| SUBTRACTION | Replace SUB with ADD | `decrement-success` returns and stores 17 instead of 7 |
| STORE | Replace SSTORE with POP | `increment-success` returns 12 while leaving count 7 |
| SHORT-HEAD | Change the increment head bound from 36 to 4 | `increment-short-31` accepts the zero-padded argument |
| SELECTOR | Flip the increment selector's last bit | `increment-success` reverts as unknown |

The mutation outputs and the restored controls are retained separately
under `.gatework/counter/`, and the reused reference parser writes its
listing captures to `.gatework/reference/counter/`. The standalone gate
also checks a successful
CALLVALUE return of seven and five rejected values: negative, 2^256,
boolean, malformed text and an amount above the sender's balance.

These are reference and adapter witnesses. Source emitter mutations for
the counter belong to the next slice, after the reference is committed.

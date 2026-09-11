# Bounded counter reference

This is the hand-assembled M1 reference, prepared before the source
emitter targets it. It implements the counter behavior in the ratified
design, with one full-word slot each for `count` and `limit`.
`runtime.evm` contains 177 bytes in 120 commented instruction rows.
`init-prefix.evm` contains 27 bytes and initializes `limit` to 100.
`init.hex` appends the runtime to that prefix. A fresh deployment starts
with count zero. Both the constructor and every runtime entry reject
nonzero call value.

| Entry | Selector | Behavior |
| --- | --- | --- |
| `increment(uint256)` | `7cf5dab0` | Reject overflow or a sum above limit, otherwise store and return the sum |
| `decrement(uint256)` | `3a9ebefd` | Reject an argument above count, otherwise store and return the difference |
| `get()` | `6d4ce63c` | Return count without writing storage |

Every successful return is exactly 32 bytes. All failures revert with
empty data. Calldata shorter than four bytes, unknown selectors and
argument heads shorter than 36 bytes revert. Trailing bytes are ignored
for every entry. `decrement` assumes the prestate satisfies the counter
invariant, just as the specified program does. It does not repair an
arbitrary prestate whose count already exceeds its limit.

The `abi.json` and `layout.json` files are reference fixtures. They are
not source compiler output. The runtime uses memory words at offsets
0, 32 and 64 for local values and has no calls, loops or logs. Slots other
than zero are preserved during runtime execution, including the limit.
Creation sets slot one only.

`MANIFEST.json` pins the instruction tables, hex, ABI, layout and 30
explicit before/after cases. No gate regenerates those expectations.
The labels are byte offsets in the frozen runtime. Selectors are checked
against both in-tree Keccak and `cast sig`. All instruction annotations
must match the in-tree listing, `cast disassemble` and `evm disasm`.

Run `python3 -P dev/counter-test.py` after the normal build. The gate
executes every case under `evm run` and `evm t8n --state.fork Cancun`,
then checks exact expected storage, status and return bytes. The matrix
covers all 120 runtime instructions, boundary equality, zero and maximum
words, arithmetic failures, calldata handling and nonpayable guards.
An unrelated nonzero slot is included in every case. Two `evm run
--create` probes check installed bytes, initial storage and rollback for
a nonpayable constructor. Creation has only this one executor path in
this slice.

Eight bytecode mutants must fail their named expected outcomes on both
executor paths, and each original witness must then pass. A separate
CALLVALUE probe returns seven on both paths, so the nonpayable cases
cannot pass through an adapter that silently drops the value. Invalid
values and insufficient sender funds fail before either executor starts.
Raw transcripts are retained by the gate in `.gatework/counter/`, and the
reused reference parser writes its listing captures to
`.gatework/reference/counter/`.

Both executor paths use geth 1.14.12. This reference is not a proof of
the future compiler, an independent EVM implementation, or the complete
M1-DIFF gate. After this reference is committed, the next slice can add
counter source emission and compare its bytes and behavior against these
frozen fixtures. Entry sugar, real ABI/layout emission and `run` remain.

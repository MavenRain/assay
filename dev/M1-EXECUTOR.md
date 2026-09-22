# Offline differential execution

This is the first assay M1 slice, on Stage F commit `10ba107`.
R-QE and R-M0-9 select `evm t8n --state.fork Cancun` as the second
executor.  R-M0-8 names the command `diff`.  The M0 ratification stamp
is still the user's.  This slice does not claim M1 completion.

```sh
dune build
_build/default/bin/assay.exe diff examples/Ref20.asy --calldata 0x00ff
_build/default/bin/assay.exe diff examples/Ref20.asy --calldata 0x --prestate fixture.json
zsh -f dev/gates.sh
```

The command checks and emits `main` in memory.  It uses the M0 source
protocol and its named refusals.  It compares all nonzero storage slots,
returned bytes and success or revert status.  A matching revert succeeds.
Other EVM faults fail even if both executors report the same fault.
The JSON report contains the agreed outcome and measured gas figures.
Gas, balance, nonce and logs are outside the equality verdict.

`bin/differential.ml` launches `evm/diff.py` through Python 3.11 or newer
with `-P` and literal arguments.  The helper uses only the Python standard
library.  Both tools must be executable on PATH.  Empty PATH elements are
ignored.  The default fixture and helper paths are relative to the built
executable, so the command may run from another directory.  Each executor
has a 30-second deadline.  The helper caps runtime at 24,576 bytes and
calldata at 32,768 bytes.  It writes only in its temporary directory.

The checked source and compiler remain OCaml.  The Python adapter parses
external JSON and does not enter the emitter, assembler or kernel trusted
line counts.  It is an additional trust boundary for the differential
verdict.  The two entry points both use geth 1.14.12, so agreement does not
establish correctness against an independent EVM implementation.

## Prestate and transaction

The non-alloc fields must equal `evm/fixtures/cancun.json` after canonical
JSON serialization.  `ENV_SHA` pins those fields.  Changes to the fork,
chain, timestamp or other environment fields fail with `DIFF_PRESTATE`.
This restriction avoids silently translating unsupported genesis fields.

The alloc may contain these three addresses, with or without `0x`:

| Role | Address |
| --- | --- |
| Default sender (fixture key 1) | `7e5f4552091a69125d5dfcb7b8c2659029395bdf` |
| Alternate sender (fixture key 2) | `2b5ad5c4795c026514f8317c7a215e218dccd6cf` |
| Receiver | `0000000000000000000000007265636569766572` |

Each account may have balance, nonce, storage and empty code fields.
Missing accounts have zero balance, nonce and storage.  Both executors
receive the same normalized alloc, with the emitted runtime installed at
the receiver.  Nonzero initial storage is preserved.  Address aliases and
slot aliases cannot introduce duplicate entries.  Zero slots are omitted
only after their values have been checked.

The t8n input is one legacy transaction with zero gas price.
The public `assay diff` command accepts optional `--value WORD`, defaulting
to zero. Its [Word validation](M1-DIFF-VALUE.md) matches the source model,
including uppercase hexadecimal. The Python adapter accepts `--value N`,
a decimal count or a `0x`-prefixed hex word, or the keyword argument `value`
in `execute`. Values must fit uint256 and the sender's prestate balance
must cover them. Both executor paths receive the same value; the adapter
never funds the sender itself.
The selected public fixture key signs it offline. `--caller ADDRESS`
selects either sender above, defaulting to key 1; the Python adapter and
the `caller` keyword of `execute` accept the same selection. The
[caller contract](M1-DIFF-CALLER.md) defines the address grammar and refusals.
The selected sender's initial nonce is read from the alloc, and an exhausted
nonce is refused before execution. No key is used for a network request.
The runner disables block rewards and supplies empty withdrawals and a zero
beacon root. It starts no daemon.

## Gas adapter

With a prestate, geth 1.14.12 `evm run` overrides `--gas` with the genesis
gas limit.  This was measured with a program that returns `GAS`.
The execution allowance is therefore 16,777,216 on both paths.

The t8n transaction receives that allowance plus its intrinsic gas:
21,000 plus 4 per zero calldata byte and 16 per nonzero calldata byte.
Its block gas limit also includes that intrinsic amount, so the transaction
fits the block.  The accounts and calldata stay the same, but the block gas
limit differs by this named adjustment.  The runner also pins a zero base
fee and the genesis excess blob gas for t8n only, while `evm run` reads the
values of its own genesis.  `GASLIMIT`, `BASEFEE` and `BLOBBASEFEE` are
therefore refused with `DIFF_CONTEXT`.  The opcode scan skips PUSH operands.
The current M0 emitter does not emit these three opcodes.

The report separates execution gas, transaction gas and intrinsic gas.
The t8n receipt includes refund effects; its gas is not assumed to equal
the sum of the trace gas and intrinsic gas.  Storage clearing is a live
witness for that distinction.

## Gates and remaining work

The executor leg runs nine hand-assembled cases and all eleven frozen
corpus files.  The direct cases cover reference bytes, nonzero storage,
slot preservation, clearing, calldata, nonempty revert data, write rollback,
caller identity and `GAS`.  The driver runs eight calldata rows and checks
paths with spaces, explicit prestates, literal argv and named failures.
The named failures include an absent helper, a runner that a signal kills,
and an executor that writes to stderr and then exits zero.
Damaged captures must fail for each compared field, missing results,
missing or unrelated traces, receipt corruption, EVM faults and malformed
state.  A restored capture must pass.  Evidence retains the raw captures.

The first executor slice accepted closed M0 programs. Its original
validation passed 33 of 35 legs, with DENOMINATORS and M0-RATIO failed on
stale hashes after two timing attempts exceeded the one-minute bound.
The current [M1 core emitter](M1-EMISSION.md) also compiles the counter
dispatcher and arithmetic effects. The same public `diff` command now
executes those source programs with calldata. The [source model](M1-RUN.md)
also interprets their specialized effects through public `run`.
The subsequent surface and source-proof slices provide contract sugar
and the source overflow-freedom theorem. The [M1 closure gate](M1-CLOSE.md)
adds the binding performance check to the complete battery; the bound
remains open.

The [hand-assembled counter reference](../reference/counter/README.md) is the
second M1 slice in this tree, including its nonpayable guard and offline
call-value probes. Its current
validation and measurement history are recorded in `dev/ASSAY-M1-BUILD-LOG.md`.

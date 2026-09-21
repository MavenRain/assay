# Contract-address snapshots

The thirty-eighth M1 slice starts at `0eed12b`. An entry can read the
address of the executing contract:

```text
entry observe () : Eff Sig Word := do
  self <- address ; pure self
```

The result is an unsigned 160-bit address represented as a zero-extended
Word. It identifies the contract, independently of the caller. Each
read gets a fresh runtime binding. Later context reads, storage loads
and writes preserve that binding. It can be stored, compared, used in
checked arithmetic or included in a typed revert payload. Reverts
restore the original storage.

`address` is reserved and takes no arguments. It is an entry effect;
constructors and the closed-revert fallback do not admit it. Reading
the address does not make an entry payable. Read-only entries remain
`view`, and nonpayable entries still reject nonzero value before effects.
See [ContractAddress.asy](../examples/ContractAddress.asy).

The HexWords example's previous `address()` entry is now `literalAddress()`
to avoid the reserved effect name. Its literal result and hex-validation
coverage remain unchanged. Existing source must rename declarations that
use the newly reserved identifier.

## Checked core protocol

The optional constructor follows any `caller`, `callvalue`,
`calldatasize` and `calldataload` constructors and precedes `payable`:

```text
  | address : (Word 256 -> Tx) -> Tx
```

The checker validates the exact family, order and continuation type.
Lowering looks up its checked constructor tag and allocates a fresh
snapshot. The emitter uses `ADDRESS`; the source model reads its
validated contract-address input. An unused declaration preserves all
five emitted artifacts, including creation bytecode.

## Execution inputs

`run FILE --address ADDRESS` sets the source model's contract address.
It defaults to zero and accepts decimal or `0x`-prefixed hexadecimal
values through `2^160 - 1`. The option may occur once. Invalid addresses,
missing values and duplicate options exit 64 before source loading.

`--caller` and `--address` are independent. `Model.inputs` and
`Model.inputs_with_caller` retain their existing behavior with a zero
contract address. `Model.with_address` validates and replaces that field
without changing other inputs.

`trace` and `diff` obtain the contract address from their existing
execution fixture. Their command-line options are unchanged. To compare
their result with `run`, pass the fixture's receiver address to `--address`.

## Validation

The ADDRESS gate covers all 128 combinations of errors, proofs, caller,
call value, calldata size, calldata loads and payability. It checks 1920
independently expected model/geth outcomes and 128 unused-constructor
artifact pairs. The surface probes cover five contract addresses,
including zero, a high-bit address and the largest uint160 address.
The matrix and surface probes include 55 signed Cancun calls altogether.

Seven public-command checks cover `run`, `trace` and `diff`, including
the model default and decimal and hexadecimal boundaries. Twenty-four
refusals cover malformed core protocols, unsupported surface positions
and invalid public inputs. Five [mutation witnesses](M1-ADDRESS-MUTATIONS.md)
require successful mutant builds, the named failing assertion and passing
restored controls.

The default gate runner appends ADDRESS as leg 73. Previous modes retain
their commands, deadlines, markers and classifications. M0 and M1 creation
now share the same bounded offset-resolution routine; storage-body lookup
is also shared. The emitter grows from 1799 to 1800 of 1800 lines and the kernel stays at 3997,
with all trusted-code limits unchanged. This slice claims no new timing
result or milestone exit.

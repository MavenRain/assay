# Calldata-size snapshots

The thirty-sixth M1 slice starts at `4a5dfda`. An entry can bind the
complete calldata byte length as a `Word`:

```text
entry size () : Eff Sig Word := do
  length <- calldatasize ; pure length
```

The length includes the four-byte selector, encoded arguments and any
trailing bytes. Calling `size()` with its selector alone returns four.
Appending one byte returns five. The effect observes the current call's
data, independently of caller identity and call value. Repeated reads
have the same value and keep distinct bindings when combined with other
snapshots, storage reads or arithmetic.

The [CalldataSize example](../examples/CalldataSize.asy) uses the length
in a proof guard, storage writes and typed revert payloads. Failed guards
and reverts restore the original storage. Reading the length does not
make an entry payable. Unmarked entries still reject nonzero value
before argument decoding or effects. Read-only entries remain `view`.
Short or unknown selectors retain the existing dispatcher behavior.

`calldatasize` is reserved and takes no arguments. It is an entry effect;
constructors and the closed-revert fallback do not admit it.

## Checked core protocol

The checked `Tx` family accepts this optional constructor after optional
`caller` and `callvalue` constructors, before the payable marker:

```text
  | calldatasize : (Word 256 -> Tx) -> Tx
```

The family declaration, order, width and continuation type are checked.
Snapshot constructor tags come from the checked family table. Emission
uses `CALLDATASIZE`; the source model counts normalized calldata bytes.
An unused declaration leaves all five emitted artifacts unchanged.
The kernel and trusted-line bounds remain unchanged.

## Execution and validation

`run`, `trace` and `diff` use their existing `--calldata` input. No new
command option is needed. The public input limit remains 32768 bytes;
the opcode itself retains its EVM meaning independently of that limit.

CALLDATASIZE checks all 32 combinations of errors, proofs, caller context,
call value and payability. It covers 1024 independently expected
model/geth comparisons, 28 signed Cancun calls, 32 unused-constructor
artifact pairs, 16 surface probes, two public commands and 13 refusals.
The surface probes include trailing bytes, lengths around word boundaries,
the public input limit and rollback after a storage write.

Five [mutations](M1-CALLDATASIZE-MUTATIONS.md) must compile and fail at
their named witnesses, with passing restored controls. The default gate
runner appends CALLDATASIZE as leg 71; previous modes retain their gates.
This slice does not claim a performance measurement or milestone exit.

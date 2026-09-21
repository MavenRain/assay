# Calldata-word reads

The thirty-seventh M1 slice starts at `15c417c`. An entry can read a
32-byte word at a byte offset in the complete calldata:

```text
entry observe (offset : Word) : Eff Sig Word := do
  value <- calldataload offset ; pure value
```

Offset zero includes the four-byte selector. Offset four starts at the
first ABI argument. Offsets need not be aligned. The result is big endian;
missing bytes at the end of the word are zero. An offset at or beyond the
calldata length returns zero, including the largest uint256 offset.

Offsets can be literals, arguments or earlier Word bindings, including
storage loads, arithmetic results and other calldata reads. Each read
keeps its own snapshot. Later reads, context effects and storage writes
preserve earlier bindings. The [CalldataWord example](../examples/CalldataWord.asy)
also uses loaded words in proof guards and typed revert payloads. Failed
guards and reverts restore the original storage.

Reading calldata does not make an entry payable. Read-only entries remain
`view`; unmarked entries reject nonzero value before effects. ABI argument
length checks and short or unknown selector behavior remain in force.

`calldataload` is reserved and takes exactly one Word offset. It is an
entry effect. Constructors and the closed-revert fallback do not admit it.

## Checked core protocol

The optional constructor follows any `caller`, `callvalue` and
`calldatasize` constructors and precedes the payable marker:

```text
  | calldataload : Word 256 -> (Word 256 -> Tx) -> Tx
```

The checker validates its family, order, operand width and continuation
type. Lowering obtains the constructor tag from the checked family table
and allocates a fresh runtime binding. Emission uses `CALLDATALOAD`.
The source model compares the full-width offset against the input length
before converting an in-range offset to a host integer.

An unused declaration leaves all five emitted artifacts unchanged.
The kernel and trusted-line bounds remain unchanged.

The context representation carries the offset through the existing
snapshot path. The lexer and source router share whitespace handling,
and contract literals and public model inputs share uint256 parsing.
These refactors keep the emitter at 1799 of 1800 lines. Existing context,
call-value, calldata-size, surface-literal and hex mutation anchors follow
the shared code; their named assertions and required outcomes are preserved.

## Execution and validation

`run`, `trace` and `diff` keep the existing `--calldata` option and
32768-byte public input limit. The load itself retains EVM zero-padding
semantics rather than imposing an additional bounds check.

CALLDATALOAD covers all 64 combinations of errors, proofs, caller, call
value, calldata size and payability. Its 2240 independently expected
model/geth comparisons include unaligned and huge offsets, snapshots,
guards and dispatcher refusals. It also checks 35 signed Cancun calls,
64 unused-constructor artifact pairs, 31 surface probes, two public
commands and 18 invalid programs.

Five [mutation witnesses](M1-CALLDATALOAD-MUTATIONS.md) require successful
mutant builds, failure at the named assertion and passing restored
controls. The default gate runner appends CALLDATALOAD as leg 72.
Previous modes retain their gates. This slice claims no performance
measurement or milestone exit.

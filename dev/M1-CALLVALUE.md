# Call-value snapshots

The thirty-fifth M1 slice starts at `4836427`. An entry can bind the
current call's value as a `Word`:

```text
payable entry observe () : Eff Sig Word := do
  amount <- callvalue ; pure amount
```

The value is independent of calldata arguments and caller identity. It
is a uint256 snapshot of the current EVM call, including zero and the
maximum word. Repeated reads have the same value. Snapshots can be stored,
used in arithmetic and proof guards, or included in typed revert data.
The [CallValue example](../examples/CallValue.asy) exercises these paths
with caller context and rollback after a storage write.

Reading `callvalue` does not make an entry payable. Unmarked entries
continue to reject nonzero value before argument decoding or effects;
their successful reads return zero. A read without a storage write is
`view` unless its entry is explicitly payable. Constructors and the
closed-revert fallback do not support this effect. `callvalue` is a
reserved surface word and takes no arguments.

## Checked core protocol

Core sources may add this optional constructor to the checked `Tx`
family, after optional caller context and before the payable marker:

```text
  | callvalue : (Word 256 -> Tx) -> Tx
```

The complete family declaration, order and constructor type are checked.
Tags come from that family table. Caller and call value share a typed
snapshot path, with separate model inputs and EVM opcodes. Declaring
the constructor without using it leaves all five emitted artifacts
unchanged. The kernel and the trusted-line bounds remain unchanged.

## Execution and validation

`run --value`, `trace --value` and `diff --value` supply the observed
value. Trace and differential calls need a prestate funding the selected
caller. The source model tracks storage and return data; signed Cancun
comparisons additionally check balance transfers and rollback.

CALLVALUE covers all 16 combinations of errors, proofs, caller context
and payable entries. It checks 480 independently expected model/geth
cases, 18 signed calls, 16 unused-constructor artifact pairs, 12 surface
cases, two public command calls, 13 refusals and four mutations with
restored controls. Values include zero, one and uint256 max. Calldata,
caller and call value differ in the surface probes.

Activate the toolchain described in README.md, then run:

```sh
dune build
python3 -P dev/callvalue-test.py
python3 -P dev/validation/2026-09-20-m1-callvalue/scoped-run.py
```

The default ladder appends CALLVALUE as leg 70. The scoped runner checks
that all 40 previous gate modes retain their declarations and selects
35 affected gates. [Mutation witnesses](M1-CALLVALUE-MUTATIONS.md) and the
[validation archive](validation/2026-09-20-m1-callvalue/) record the checks.
This slice makes no milestone-exit or performance claim.

# Payable entries

The thirty-fourth M1 slice starts at `f187d41`. A contract accepts call
value only at an entry explicitly marked `payable`:

```text
payable entry deposit (amount : Word) : Eff Sig Word := do
  sstore cell amount ; pure amount
```

The [Payable example](../examples/Payable.asy) combines payable entries,
ordinary storage writes, a view entry, caller snapshots, an erased bound
proof and typed reverts. A payable entry may also return without writing
storage. Its ABI still says `payable`, because it accepts value.
Unmarked entries retain inferred `view` or `nonpayable` metadata.
The annotation changes neither the selector nor the argument encoding.

Mixed contracts check the value guard at each unmarked entry before
decoding arguments or executing effects. Payable entries still reject
short argument heads. Trailing calldata retains its existing behavior.
An explicit fallback and every constructor remain nonpayable. A nonzero
value sent to an unknown or short selector reverts with empty data;
at zero value, the fallback retains its declared revert payload.
Any revert rolls back storage writes and the signed transaction's value
transfer. Contracts with no payable entries retain the original global
value guard and their existing emitted artifacts.

`payable` is a reserved surface word. Duplicate annotations, payable
constructors, payable fallbacks and annotations inside an entry body
are refused. The annotation belongs immediately before `entry`.

## Checked core protocol

Core sources can append this optional constructor to the checked `Tx`
family, after optional custom errors, proof effects and caller context:

```text
  | payable : Tx -> Tx
```

The specialized result of an entry may be `payable tx`. The marker
wraps that entry's complete transaction. Nested markers, markers after
an effect and markers on the fallback are refused. The recognizer checks
the complete family declaration, including constructor order and types.
Constructor tags come from that checked family table. A similarly named
constructor with a different type does not acquire payability semantics.
Declaring the optional constructor without using it changes no output.

## Execution and validation

`run --value` applies each entry's payability to the source model. The
model continues to describe storage and return data; it does not model
account balances. `trace --value` and `diff --value` execute value-bearing
calls with geth and require a prestate funding the selected sender.
The calldata `amount` in the example is independent of the call value.
This slice does not add an effect for reading that value inside source.

The PAYABLE gate checks 216 independently expected core execution cases
across all eight combinations of errors, proofs and caller context.
Each case compares the model with geth. Values include zero, one and the
uint256 maximum. Twenty-four signed Cancun comparisons additionally
check sender and receiver balances for transfer and rollback.
Eight pairs compare all five emitted artifacts with an unused marker
present or absent. Six surface cases, four public command calls using
both signing fixtures, two creation outcomes and 18 refusals cover the
source and command boundaries. Four compiler/model mutations must fail
at named witnesses and pass after restoration.

Activate an opam switch with OCaml 5.2.1, Dune 3.24.2 and Zarith 1.14
(README.md) before running this block.

```sh
dune build
python3 -P dev/payable-test.py
python3 -P dev/validation/2026-09-19-m1-payable/scoped-run.py
python3 -P dev/stage-a-gates.py --m1-payable
```

The new default appends PAYABLE as leg 69 and preserves all 39 previous
gate modes. BUILD now uses public Dune and its exit status; all other
declarations are unchanged. The scoped runner selects 33 gates. A further
eight checks validate the public build path and mutation controls.
The [validation archive](validation/2026-09-19-m1-payable/) records the
actual outcomes, source hashes and execution captures. It also documents
the unchanged timing pause. This slice makes no M1 completion claim.

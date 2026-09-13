# M1 proof-producing guards

The ninth M1 slice adds erased proof binders to the contract surface.
An overflow or ordering guard supplies a proof only to its successful
continuation. `addLt` and `subLe` consume that proof and emit arithmetic
without a second bound check. The ordinary checked Result forms remain
available. No carried kernel or surface file changes.

```
do c <- sload count ;
   (0 p : Lt256 (add c n)) <- guard OverflowRevert (lt256 (add c n)) ;
   let s : Word := addLt c n p ;
   bound <- sload limit ;
   (0 q : Le s bound) <- guard BoundRevert (s) (bound) (leWord s bound) ;
   sstore count s ; pure s
```

[CounterProofs.asy](../examples/CounterProofs.asy) includes this entry,
decrement, get, a literal constructor and three declared errors. Its
runtime is 405 bytes and its creation code is 436 bytes. ABI arguments
remain words; proof names and types add no ABI rows or storage slots.

## Accepted forms

| Form | Meaning |
| --- | --- |
| `(0 p : Le a b) <- guard ERROR (leWord a b) ; REST` | Prove unsigned `a <= b`, otherwise reject |
| `(0 p : Lt256 (add a b)) <- guard ERROR (lt256 (add a b)) ; REST` | Prove the mathematical sum is below `2^256`, otherwise reject |
| `let v : Word := addLt a b p ; REST` | Add using a proof of `Lt256 (add a b)` |
| `let v : Word := subLe a b p ; REST` | Subtract using a proof of `Le b a` |

`ERROR` is optional. Omitting it selects empty revert data. Otherwise
it names a declared error followed by parenthesized Word arguments.
A nullary error accepts either `Denied` or `Denied ()`. `()` is the
empty payload only when it is the whole payload, so a `()` beside a Word
argument is a wrong argument count refusal. The condition
always has its own parentheses. Payload expressions resolve before the
new proof enters scope. Rejections restore the original storage.

The proof binder must have quantity zero. Its claim and the guard's
condition are checked independently and must agree by kernel conversion.
The generated success continuation carries an explicit function type
annotation, so the claim cannot be silently replaced by an expected type.
Proof names may be reused or shadowed, but a proof is never a Word.
Using a proof for different operands or the wrong arithmetic operation
fails checking. A loaded word denotes an immutable snapshot: a later
store preserves that snapshot's proof, while a new load needs a new proof.

The existing 128-step body bound includes proof guards and proved
arithmetic. Identifier, source, token, error-argument, specialization,
memory and bytecode limits remain enforced. Constructors still accept
literal stores and `pure ()` only. Invariant declarations and general
surface proof expressions remain outside this slice.

## Checked core boundary

The optional protocol defines `wordNat`, `Le` and `AddFits` using the
carried Word eliminator, Nat primitives and empty/unit propositions.
`Le a b` is true when `wordNat b < wordNat a` is false. `AddFits a b`
tests the mathematical sum against `2^256`. Surface `Lt256 (add a b)`
lowers to this binary `AddFits` predicate.

Four constructors follow the existing Tx protocol, after `reject` when
custom errors are present:

```
guardLe : (a : Word 256) -> (b : Word 256) ->
  ((0 p : Le a b) -> Tx) -> Tx -> Tx
guardAdd : (a : Word 256) -> (b : Word 256) ->
  ((0 p : AddFits a b) -> Tx) -> Tx -> Tx
addLt : (a : Word 256) -> (b : Word 256) ->
  (0 p : AddFits a b) -> (Word 256 -> Tx) -> Tx
subLe : (a : Word 256) -> (b : Word 256) ->
  (0 p : Le b a) -> (Word 256 -> Tx) -> Tx
```

The recognizer compares these declarations, predicate definitions and
the complete family to a freshly checked canonical schema. Their names
select the proof protocol and are reserved by the contract surface.
Proof-protocol programs with user axioms beyond the inherited `Nat`
and canonical `EvmOpcodes` are refused by emit and run, even when an
assumption is unused. This prevents an assumed bound from authorizing
unchecked arithmetic. The ordinary checker and axioms command still
accept and disclose such postulates.

[GuardCore.asy](../examples/GuardCore.asy) demonstrates a closed proof
of `AddFits 2 3`. Core programs can supply checked proofs directly.
The carried erasure removes proof arguments and leaves zero-argument
success continuations. The specializer enters those continuations only
on the guard's success branch. Both paths are still compiled and checked.
The overflow guard computes a temporary wrapped sum for comparison;
that temporary is not exposed as a source word. `addLt` computes the
result again without another branch. No general runtime closure is emitted.

The existing Lean arithmetic model covers the earlier Result protocol.
This slice adds no Lean theorem about the new constructors or compiler.
Its source claims are checked by the carried kernel; their execution
correspondence is tested against two geth entry points using Cancun.

## Validation

`python3 -P dev/guard-test.py` checks 83 source/EVM cases, two constructor
outcomes and all 252 counter instructions. Cases cover uint256 boundaries,
custom and empty failures, prior writes, snapshot reuse, proof reuse and
definitionally equal aliases. It checks 20 source refusals through check,
emit and run, plus six checked schema/assumption refusals through emit
and run. Three different closed proof terms produce equal five-file
outputs. A supplied proof removes exactly one arithmetic `JUMPI` compared
with the checked Result form.

Six compiler mutations have semantic witnesses and restored controls in
[M1-GUARD-MUTATIONS.md](M1-GUARD-MUTATIONS.md). The full `--m1-guards`
battery has 44 legs. Timing remains paused as recorded in
[TIMING-DEBUG.md](TIMING-DEBUG.md). The old denominator manifest and
measurement remain preserved, so `DENOMINATORS` and `M0-RATIO` are
expected to fail on the new compiler. No fresh performance or complete
battery pass is claimed. Invariant declarations, surface-supplied proof
terms and the M1 performance bound remain unfinished.

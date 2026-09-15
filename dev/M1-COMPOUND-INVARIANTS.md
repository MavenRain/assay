# M1 compound storage invariants

The fifteenth M1 slice accepts `Both` claims in storage invariants,
including nested products and named predicates that expand to products.
Each component remains a kernel-checked obligation at construction and
at a successful return that writes any field mentioned by the invariant.

```
predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
  Both (Le x y) (Lt256 (add x y))
invariant bounded (s : State) : Prop := Bounds(s.low, s.high)
```

[CompoundInvariants.asy](../examples/CompoundInvariants.asy) checks
ordering and addition bounds before updating two storage fields. An
erased helper collects the guard proofs into a named bundle. A failed
guard reverts the transaction, including its earlier storage write.

## Evidence and final state

An invariant resolves against the final tracked storage values. Its
evidence can be a matching whole bundle, a component of another checked
bundle, separate guard proofs, or a mixture with closed true bounds.
When no whole bundle matches, lowering constructs a pair recursively.
The kernel checks that pair against the complete invariant type.

An atomic component without explicit evidence uses the existing unit
proof attempt. This succeeds only if the kernel reduces that atomic
proposition to the unit type. It cannot establish a false closed bound
or an unproved symbolic bound. Constructor obligations use the same
recursive construction, starting from zero storage and literal stores.

All snapshot fields in both branches must have a tracked value before
an affected successful return. This includes every supplied argument of
a named predicate, even when its definition ignores that argument.
Writing a field in the right branch triggers the whole invariant. A
reloaded or overwritten field must satisfy the final claim; evidence
about its earlier value cannot establish a different final state.

Read-only entries and writes to fields outside an invariant retain the
existing behavior. Reverting paths have no final-state obligation.
Declaring an invariant introduces no runtime test or initial-state
assumption. A guard still establishes exactly one atomic bound.

## Bounds and erasure

The existing limits apply: 32 invariants, claim syntax depth 32,
expanded depth 32 and 4096 visited expansion nodes. Both branches share
the expansion budget. Predicate and snapshot scope rules are unchanged.
Products introduce no new axiom, ABI argument, storage slot or runtime
proof value. The carried kernel and surface are unchanged.

Eight equivalent programs compare all five outputs: no invariant,
separate atomic declarations, a compound declaration, whole-bundle
evidence, a named predicate, the example's helper, a nested product with
sub-bundle evidence, and a mixture of closed and symbolic components.
Their `runtime.hex`, `init.hex`, `abi.json`, `layout.json` and
`axioms.txt` must match byte for byte.

## Validation

`python3 -P dev/compound-invariant-test.py` runs 64 comparisons between
the source model and Cancun execution, two creation outcomes, 24
refusals through `check`, `emit` and `run`, ten accepted boundary forms,
and [four compiler mutations](M1-COMPOUND-INVARIANT-MUTATIONS.md) with
restored controls. Refusals include a false component on either side,
missing evidence, stale storage, missing fields and expansion limits.

The earlier predicate suite's `invariant-bundle` witness now checks
an incorrectly ordered component. Valid compound invariants are
accepted; the witness still must fail in all three commands. The shared
creation helper accepts an explicit expected storage map, preserving
the previous fixtures' default while checking this zero-state example.

`dev/gates.sh` selects `--m1-compound-invariants`, adding the new leg to
the previous 49. `STAGE-M1-COMPOUND-INVARIANTS OK` requires all 50 legs
to pass. Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md).
The preserved denominator manifest and measurement do not establish
current compiler performance. This slice does not claim milestone exit.

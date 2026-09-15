# M1 compound proof guards

The sixteenth M1 slice lets a single guard establish a nested proof
bundle. Its lowercase `both` condition checks two conditions in source
order. Every atomic condition uses the existing checked
`guardLe` or `guardAdd` protocol.

```
predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
  Both (Le x y) (Lt256 (add x y))
invariant bounded (s : State) : Prop := Bounds(s.low, s.high)
entry set (a : Word) (b : Word) : Eff Sig Word := do
  (0 bounds : Bounds(a, b)) <- guard Denied (a) (b)
    (both (leWord a b) (lt256 (add a b))) ;
  sstore low a ; sstore high b ; pure a
```

[CompoundGuards.asy](../examples/CompoundGuards.asy) is the complete
example. It includes an earlier storage write to demonstrate rollback
when either condition fails.

## Conditions and evidence

The runtime grammar is `leWord A B`, `lt256 (add A B)`, or
`both (CONDITION) (CONDITION)`. Conditions nest at most 32 levels, with
an atomic condition at depth zero, and contain at most 64 atomic bounds.
Each operand remains a bounded Word expression. The subsequent
[named guard slice](M1-NAMED-GUARDS.md) also accepts predicate calls in
runtime conditions and applies these limits after expansion.

The annotation and condition must have the same product structure.
Lowering builds a proof pair in that order. The kernel checks each
atomic continuation against its annotated claim, including components
whose evidence is never used. Component types that do not match their
annotations, or different nesting shapes, are rejected.

The bound proof supports the existing `first`, `second`, `pair`, and
proof-helper operations. Its whole claim and every nested component
become available to storage invariant obligations. Those obligations
still refer to the final tracked values. Loading or rebinding a Word
does not change an earlier proof's snapshot.

## Failure, scope and erasure

Conditions run from left to right. A failed component immediately takes
the guard's failure branch, so later components do not run. Without a
custom error the branch performs an empty revert. Otherwise every
component uses the same declared error and Word payload. Nullary errors
accept both `Halt` and `Halt ()`. Existing payload arity rules apply.

The proof name enters scope only after the whole condition succeeds.
Condition operands and error payloads resolve in the preceding Word
scope. `both` is contextual inside runtime conditions, so it remains a
valid field, local binding, proof-helper, predicate, or error name.

The bundle and its evidence erase before emission. Grouping two guards
with the same failure into a compound guard preserves all five output
files exactly. Nested grouping preserves the same source order. The
carried core grammar, kernel, effect protocol, and bytecode backend are
unchanged.

## Validation

`python3 -P dev/compound-guard-test.py` checks:

- 88 source-model/Cancun comparisons and two creation outcomes.
- 26 rejected programs through `check`, `emit`, and `run`.
- Seven erasure variants across two groups, comparing all five files.
- Seven accepted boundary forms, including depth 32 and 64 bounds.
- [Four mutations](M1-COMPOUND-GUARD-MUTATIONS.md), each with a control.

`dev/gates.sh` selects `--m1-compound-guards` and requires all 51
legs for `STAGE-M1-COMPOUND-GUARDS OK`. The preserved denominator and
ratio checks still describe an older compiler. Timing remains paused,
and this slice does not establish the M1 performance bound.

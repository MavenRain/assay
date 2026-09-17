# M1 inferred guard bindings

The twenty-third M1 slice lets a proof-producing guard omit its
binding annotation:

```
(0 checked) <- guard Denied (a) (b) (Bounds(a, b)) ;
let (0 ordered : Le a b) := first(checked) ;
let (0 fits : Lt256 (add a b)) := second(checked) ;
```

The condition supplies the claim, and the successful continuation can
name its checked evidence.
[InferredGuardBindings.asy](../examples/InferredGuardBindings.asy)
uses that evidence with a compound storage invariant. Failed checks
revert the earlier store and return the declared custom payload.

## Checking and scope

Atomic `leWord` and `lt256` conditions derive `Le` and `Lt256` claims.
Lowercase `both` conditions derive proof bundles; named predicates
retain their arguments and use the existing predicate expansion.
The binder lowers through the same checked guard as an annotated
`(0 p : CLAIM)` binder. Every runtime check still executes, including
when the bound evidence is unused.

An explicit annotation remains an obligation. A mismatched annotation
is refused even if the continuation ignores the proof or reverts.
The new form adds no axiom, ABI field, storage slot or runtime guard.
Its emitted files equal those of the annotated form.

Conditions and error payloads resolve in the preceding scope. The new
proof name becomes available only in the successful continuation, and
can shadow an earlier Word or proof binding. Proof values cannot be
used as Words. Evidence describes the Word values at the guard;
rebinding a Word or reloading storage does not update that evidence.
Other entries cannot use the binding.

Named evidence supports projections, proof helpers, inferred helper
arguments, contextual proof holes, arithmetic proofs and final-state
invariant checking. Unbound `guard` statements still introduce only
internal evidence names. Helper parameter types remain explicit.
Constructors still accept literal stores only.

The existing limits remain: 128 effect steps, 64 expanded atomic
checks per condition, depth 32 and 4096 predicate expansion nodes.
The same condition parser and expansion budget serve both binder forms.

## Validation

`python3 -P dev/inferred-guard-binding-test.py` checks 160 source-model
and Cancun comparisons, two creation outcomes, 27 refusals through
`check`, `emit` and `run`, and equality of all five output files for
20 inferred/annotated pairs. Four accepted boundary forms also compare
their emitted files. They cover 64 checks, depth 32, a nullary predicate
and 128 effects. Refusals cover exceeded and shared budgets.

Four [compiler mutations](M1-INFERRED-GUARD-BINDING-MUTATIONS.md)
must build, fail a specific witness and pass after restoration.

The default `--m1-inferred-guard-bindings` selector adds one leg to the
previous 57-leg battery. Existing commands, deadlines and markers are
unchanged. The earlier inferred-binding refusal named `guard-type`
now checks an empty explicit annotation, `(0 p :)`; its former input
is accepted and exercised by the new atomic execution cases.

The carried kernel, surface, proof sources and backend are unchanged.
Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md).
The performance bound and milestone exit remain pending. The
[archive](validation/2026-09-17-m1-inferred-guard-bindings/README.md)
retains the evidence.

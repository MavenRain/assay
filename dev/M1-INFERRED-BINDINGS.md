# M1 inferred proof bindings

The twenty-second M1 slice lets an erased proof binding omit its type
when the initializer supplies one:

```
let (0 bounded) := fits(a, b) ;
let total : Word := addLt a b bounded ;
```

The initializer can be an existing proof, a helper call, an annotated
expression, a pair, a projection or another proof-local binding.
The same syntax works inside proof expressions and helper bodies:

```
proof fits (0 x : Word) (0 y : Word) (0 p : Lt256 (add x y))
  : Lt256 (add x y) := (let (0 checked) := p in checked)
```

[InferredBindings.asy](../examples/InferredBindings.asy) uses both
forms in the bounded counter.

## Checking and scope

The initializer determines the binding's claim. The generated core
annotates and checks that initializer before making the proof available
to the continuation. A supplied binding annotation remains an
obligation.
Unused bindings, unused helper bodies and reverting continuations keep
their proof checks before erasure. Inference adds no axiom, runtime
guard or ABI field.

Without an annotation, the initializer has no expected claim. Thus
`let (0 p) := _` is refused even if the surrounding expression has an
expected result type. An explicit annotation supplies
the missing context: `let (0 p) := (_ : Le a b)`. A helper call supplies
expected claims to its own proof arguments, so `fits(a, b, _)` works
with matching evidence. Word values cannot initialize proof bindings.
The unit proof `()` synthesizes the core unit proposition; a specific
closed bound can instead be supplied by an annotation or helper result.

Inferred bundles retain their component claims for `first`, `second`
and subsequent evidence lookup. Named predicates expand as before.
Proof-local bindings are visible only in their bodies. Initializers
resolve the preceding scope, including an older binding of the same
name. Sibling expressions and other entries do not receive local
evidence.
Word aliases, rebinding and storage snapshots follow the existing
[inferred-helper rules](M1-INFERRED-HELPERS.md).

Helper parameters and proof-producing guard binders still require
explicit types. Proof bindings remain unavailable in constructors.
The 128-level proof nesting and 128-step effect limits are unchanged.
Constructed bundles also respect the resolved-claim limits: 32 levels
of depth and 4096 nodes. The node budget bounds every constructed
pair. The depth bound applies to an inferred pair claim only, because
an annotated pair claim already obeys the 32-level surface bound of
its written type. Both checks run before serializing a pair's type,
so repeatedly pairing earlier bindings cannot expand an inferred
claim beyond the bounds a written claim obeys.

## Validation

`python3 -P dev/inferred-binding-test.py` checks 229 source-model/Cancun
comparisons, two creation outcomes, 25 refusals through `check`, `emit`
and `run`, and 21 pairs with identical five-file output. Nesting tests
accept depths 4, 16, 64 and 128, compare annotated and inferred erasure,
and reject depth 129. Bundle tests accept a 4095-node claim and a
32-level claim spine, compare their erasure with a program without
proofs, and reject 4097 nodes, repeated doubling and a 33-level spine.
Six [compiler mutations](M1-INFERRED-BINDING-MUTATIONS.md)
must fail their witnesses and pass after restoration.

The default `--m1-inferred-bindings` selector adds one leg to the
earlier 56-leg battery. Existing commands, deadlines and success
markers remain unchanged. The carried kernel and surface, proof
sources and backend
are unchanged. Timing remains paused under
[TIMING-DEBUG.md](TIMING-DEBUG.md);
the performance bound and milestone exit remain pending.

The existing guard CLAIM mutant consumes an otherwise unused helper
binding so its deliberate invalid claim reaches the original refusal
witness. Its build must still pass before the witness can count as a
mutation kill.

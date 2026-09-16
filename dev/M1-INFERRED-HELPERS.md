# M1 inferred proof-helper arguments

The twentieth M1 slice permits omitting trailing proof arguments in a
helper call. For example:

```
proof fits (0 x : Word) (0 y : Word) (0 p : Lt256 (add x y))
  : Lt256 (add x y) := p

guard OverflowRevert (lt256 (add c n)) ;
let total : Word := addLt c n fits(c, n) ;
```

[InferredHelpers.asy](../examples/InferredHelpers.asy) uses this form
for the bounded counter's increment and decrement operations.

## Argument checking

Supplied arguments retain declaration order and their existing checks.
Only a suffix consisting entirely of proof parameters can be omitted.
Word parameters remain explicit, including those following a proof
parameter. An invalid supplied proof is rejected even when matching
evidence is available. Unknown, shadowed and forward helper calls keep
their existing refusals.

Each omitted parameter's claim is instantiated with the supplied Word
values. Lookup selects the most recently recorded exact match. Evidence
includes earlier transaction guards and proof bindings, including
anonymous guards, named predicates and nested bundle components.
Missing bundle evidence can be assembled from its component claims.
If a leaf has no matching evidence, a unit witness is supplied. The
kernel accepts it only when that proposition reduces to true.

Every inferred argument carries its expected type into kernel checking,
including an unused argument, an unused result, and code ending in a
revert. Inference adds no runtime checks, ABI parameters or axioms.
All five emitted files match the corresponding explicit programs.

## Evidence scope

Helper bodies can use their preceding checked proof parameters. Helpers
remain generic definitions, checked even when unused; they cannot rely
on a caller's future arguments to justify an unproved symbolic claim.
Proof-local bindings contribute evidence only within their bodies.
Explicit proof arguments contribute their checked claims to later
arguments of the same call. Neither form leaks evidence into sibling
expressions, enclosing expressions or another helper call.
Proofs reused by later arguments get a checked local binding. Reuse
refers to that binding instead of copying the expression, so nested
calls do not cause exponential growth in generated proof syntax.

Evidence continues to describe resolved Word values. Shadowing a proof
name retains previously checked evidence. A storage write preserves
evidence for an earlier loaded value, while reloading or rebinding a
Word produces a new operand. Lookup does not search Word aliases,
commute arithmetic, prove transitive bounds, invoke other helpers or
use later statements or other entries. An explicit proof can still
use kernel conversion to justify an alias.

The existing 16-parameter, 16-argument, 32-helper and proof/predicate
expansion limits apply. Constructors still accept literal stores only.

## Validation

`python3 -P dev/inferred-helper-test.py` checks:

- 254 source-model/Cancun comparisons and two constructor outcomes.
- 26 rejected programs through `check`, `emit` and `run`.
- 24 inferred/explicit pairs comparing all five emitted files.
- Inferred and explicit calls with 16 proof parameters, plus rejection
  when an unused omitted parameter has a false claim.
- Nested calls at depths 4, 8, 16 and 128, checking generated core size
  and five-file equality with the unnested program.
- Five [compiler mutations](M1-INFERRED-HELPER-MUTATIONS.md), each
  followed by a restored passing control.

The previous helper suite's missing-argument case now omits a Word
argument. Omitting just the final proof is covered as accepted behavior
here. Its refusal count and all earlier gate commands, deadlines and
success markers are preserved. The existing argument-order mutation
targets the extended lowering result and keeps its original witness.
The default `--m1-inferred-helpers`
selector adds one leg to the previous 54-leg battery.

The carried kernel and surface, proof sources, effect protocol and
backend are unchanged. Timing remains paused under
[TIMING-DEBUG.md](TIMING-DEBUG.md). The preserved denominator manifest
and old measurements do not validate this compiler; the M1 performance
bound and milestone exit remain pending.

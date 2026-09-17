# M1 contextual proof placeholders

The twenty-first M1 slice accepts `_` in a proof expression when its
expected claim is known. It uses the same checked evidence lookup as
omitted trailing helper proofs. A placeholder can occupy an earlier
proof argument while later Word or proof arguments remain explicit:

```
proof relay (0 x : Word) (0 y : Word) (0 p : Lt256 (add x y))
  (0 z : Word) (0 q : Lt256 (add x y)) : Lt256 (add x y) := _

(0 bounded : Lt256 (add a b)) <- guard (lt256 (add a b)) ;
let total : Word := addLt a b relay(a, b, _, word 7, bounded) ;
```

[ProofHoles.asy](../examples/ProofHoles.asy) uses placeholders in the
bounded counter's helpers and their calls.

## Expected claims and checking

A claim is available from a helper's proof parameter or result, an
erased proof binding, an explicit proof annotation, or an `addLt` or
`subLe` operand. A pair checked against a `Both` claim passes each
component's expected claim to its proof expression. For example,
`let (0 p : Both (Le a b) (Lt256 (add a b))) := pair(_, _)` checks
both components. `_` can also assemble a complete bundle from separate
evidence, including named predicates.

Every placeholder is annotated with its expected type in generated
core. The ordinary kernel checks that annotation before erasure,
including unused arguments, unused bindings, unused helpers and
reverting continuations. If no recorded evidence matches a leaf,
lookup supplies a unit witness. It is accepted only when the claimed
proposition reduces to true. A placeholder does not admit an axiom,
add a runtime check or change the ABI.

`first(_)` and `second(pair(_, _))` have no expected bundle for the
inner expression, so they are refused as `SURFACE_PROOF`. An explicit
annotation supplies the missing context, as in
`first((_ : Both (Le a b) (Lt256 (add a b))))`.
Word arguments must still be supplied explicitly. `_` remains reserved
as an identifier and cannot stand for a Word, a binder or a field.

## Evidence scope

Lookup uses resolved operands and the most recently recorded exact
claim. It includes earlier guards, proof bindings, helper parameters,
bundle components and proof-local bindings within their bodies.
Earlier supplied arguments in the same call can contribute evidence
to a later placeholder. A later argument cannot justify an earlier
placeholder, and evidence from a sibling expression or another entry
is unavailable. A supplied explicit proof keeps its own checks even
when another argument is a placeholder.

Word aliases are not searched. Rebinding or reloading a Word gives it
a new operand identity. Writing storage does not invalidate a proof
about an earlier loaded snapshot. Shadowing a proof name preserves
its already checked evidence. These are the existing
[inferred-helper rules](M1-INFERRED-HELPERS.md).

The 16-argument, 16-parameter and 128-level proof nesting limits still
apply. Proof expressions reused by later arguments retain their
checked local bindings, so nested calls do not duplicate growing
proof syntax. A call may mix explicit placeholders with an omitted
trailing proof suffix.

## Validation

`python3 -P dev/proof-hole-test.py` checks 242 source-model/Cancun
comparisons, two constructor outcomes, 25 refusals through `check`,
`emit` and `run`, and 23 pairs with identical five-file output.
Boundary tests accept 16 placeholders and nesting depths 4, 8, 16
and 128, compare their erased output, and reject 17 arguments and
an unused false parameter. Four
[compiler mutations](M1-PROOF-HOLE-MUTATIONS.md) must fail their
witnesses and pass after restoration.

The default `--m1-proof-holes` selector adds one leg to the previous
55-leg battery. Earlier gate commands, deadlines and success markers
are preserved. The carried kernel and surface, proof sources, effect
protocol and backend are unchanged. Timing remains paused under
[TIMING-DEBUG.md](TIMING-DEBUG.md); the M1 performance bound and
milestone exit remain pending.

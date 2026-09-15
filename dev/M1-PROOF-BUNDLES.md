# M1 proof bundles

The thirteenth M1 slice lets a proof helper return several checked
bounds. `Both (A) (B)` is the product of two claims. `pair(P, Q)` proves
its components, and `first(P)` and `second(P)` select them. The existing
kernel checks the whole bundle before erasure, including any component
that is never selected.

```
proof bounds (0 x : Word) (0 y : Word)
  (0 ordered : Le y x) (0 fits : Lt256 (add x y)) :
  Both (Le y x) (Lt256 (add x y)) := pair(ordered, fits)
```

[ProofBundles.asy](../examples/ProofBundles.asy) passes this bundle
through a second helper, then uses its components for `subLe` and
`addLt`. Its two guards still perform the necessary runtime checks.
The bundle and its projections introduce no runtime checks or values.

## Grammar and checking

Claims in helper parameters, helper conclusions, proof annotations and
erased proof bindings now accept `Both (CLAIM) (CLAIM)`. The existing
`Le A B` and `Lt256 (add A B)` claims remain the leaves. Both component
claims use the surrounding Word scope. Claim syntax nests at most 32
levels; an atomic claim is at depth zero.

Proof expressions accept `pair(PROOF, PROOF)`, `first(PROOF)` and
`second(PROOF)`. Pairs have exactly two components. Projections take
exactly one argument. Existing proof-expression nesting remains bounded
at 128, with each pair and projection consuming one level. `Both` is
reserved. The operation names `pair`, `first` and `second` are
contextual inside proof calls, so existing fields, arguments and helpers
can keep these names. A helper takes precedence over a built-in
operation from its declaration point onward. A helper body sees only the
helpers above it, so an earlier body keeps the built-in reading of a
name that a later helper declares. An entry body sees all helpers. A
local binding shadows a call of that name, as it does for other proof
helpers. Bare names retain their ordinary Word or proof role. Core
`.asy` and `.kan` files retain their existing grammar.

A pair checked against a `Both` claim checks each component against its
corresponding claim. Projections infer the operand's checked claim from
names, helper applications, annotations, local bindings and nested
pairs or projections. `()` has the unit proposition when inferred;
an explicit annotation gives a closed proof its intended bound.
For example, `first((pair((), ()) : Both (Le (word 0) (word 1))
(Le (word 1) (word 0))))` is rejected because its second claim is false.

Annotations remain obligations under projections. Unused helper
arguments, declarations and proof-local bindings remain checked.
An atomic proof cannot be projected, and a pair cannot establish an
atomic claim. Source names retain their Word or proof role. A bundle
cannot be returned, stored, passed as a Word helper argument or placed
in a revert payload. Shadowing and storage snapshots keep their existing
rules.

Runtime guards still establish one atomic bound. The later
[compound invariant slice](M1-COMPOUND-INVARIANTS.md) extends invariant
declarations to products. Every named entry-local proof bundle adds
its checked component bounds to the evidence available at successful
returns, recursively through nested bundles. The existing final-state
check still requires the bound's resolved Word values to match the
final storage values. A new load or an unrelated store cannot reuse
evidence for an earlier snapshot. Entry-local shadowing does not remove
evidence already checked in the enclosing core scope.

## Core representation

`Both` lowers to a two-component `prod` in `Prop`, pairs to `tuple`,
and projections to the corresponding zero-based product projection.
The lowering retains the resolved claim alongside each proof name and
instantiates a helper's conclusion with its supplied Word arguments.
Every generated proof expression has an explicit checked annotation.
All of these forms already exist in the carried kernel and surface.

Helper parameters retain ordinary core quantities because top-level
definitions check in runtime mode. The source requires quantity zero and
restricts calls to proof positions. Entry-local proof bindings and the
complete proof arguments erase before specialization. Equivalent inline
and bundled proofs produce identical `runtime.hex`, `init.hex`,
`abi.json`, `layout.json` and `axioms.txt`. Helpers add no ABI entries
or arguments, and the example discloses only `EvmOpcodes`.

This slice changes no kernel, carried surface, proof protocol,
arithmetic, assembler or Lean source. It adds no axiom or compiler
theorem. Symbolic arithmetic lemmas, induction and epoch-indexed
invariants remain separate work.
The later [named predicate slice](M1-PREDICATES.md) supplies reusable
names for atomic claims and bundles.

## Validation

`python3 -P dev/proof-bundle-test.py` checks 102 source-model/Cancun
cases, two creation outcomes, 41 refusals through check/emit/run, eight
variants with identical five-file outputs, and eleven accepted boundary
programs. An additional refused boundary checks the existing 128-level
proof limit. Execution covers maximum words, overflowing addition,
underflow, typed revert payloads, rollback and two storage invariants.
The invariant witness uses Word aliases so that the bundle's components
must supply the final evidence. Compatibility cases cover contextual
operation names used as helper names, proof locals, storage fields and
custom-error arguments. One accepted boundary keeps those names in Word
roles while the same entry builds and projects a bundle. Another
accepted boundary declares a helper with an operation name after a
helper body that uses the built-in reading of that name.

[Four compiler mutations](M1-PROOF-BUNDLE-MUTATIONS.md) have named
witnesses and restored controls. Earlier proof-term and helper mutation
anchors follow the changed representation without changing witnesses,
expected outcomes, counts or deadlines. `--m1-proof-bundles` adds this
gate to the prior 47 legs. `STAGE-M1-PROOF-BUNDLES OK` requires all
48 legs to pass.

Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). The
preserved denominator manifest and measurement do not validate this
compiler. No fresh performance verdict or milestone exit is claimed.

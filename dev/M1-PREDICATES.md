# M1 named predicates

The fourteenth M1 slice adds names for parameterized claims. Definitions
expand to the existing `Le`, `Lt256 (add ...)` and `Both` forms before
the kernel checks proof terms. A predicate declares a proposition; it
does not assert that the proposition is true.

```
predicate Below (0 x : Word) (0 y : Word) : Prop := Le x y
predicate Room (0 x : Word) (0 y : Word) : Prop := Lt256 (add x y)
predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
  Both (Below(y, x)) (Room(x, y))
```

[Predicates.asy](../examples/Predicates.asy) uses names in guard
annotations, helper parameters, helper conclusions and local proof
bindings. Its checked bundle supplies subtraction and addition bounds.
The source-model and Cancun executor agree on successful calls,
overflow, underflow, revert data and rollback.

## Grammar and scope

`predicate NAME PARAMETERS : Prop := CLAIM` declares a predicate.
Each parameter is `(0 NAME : Word)`. A call in a claim is
`NAME(ARGUMENTS)`, with comma-separated Word arguments. A Word is an
in-scope Word name or decimal `word N`, optionally parenthesized.
Constants have no parameters and use `NAME()`. Predicate arguments
cannot contain proof terms, predicate calls or runtime computations.

Predicates can refer to earlier predicates. Recursion and forward
references between predicates are refused. Helpers, entries and
invariants can use predicates declared later in the contract. Every
declaration is validated, even when unused. Its body sees only its own
Word parameters and earlier predicate declarations. Entry locals,
storage fields and other declarations' parameters are out of scope.

Every supplied argument is checked for Word scope and role, including
arguments that the definition never uses. Argument substitution is
simultaneous: parameter names cannot capture caller names. A false
unused predicate is valid, but a supplied proof of it must still check.

Names cannot conflict with globals, fields or ABI argument names.
Parameters are unique within a predicate. A local Word or proof may
shadow a predicate name; invoking that name while shadowed is refused.
`predicate` is reserved. Existing contextual proof operations keep their
roles, so a predicate named `pair` is legal in a claim without changing
the proof-expression operation.

There are at most 32 predicates and 16 parameters or call arguments.
The existing claim syntax limit is 32 levels. After substitution, an
expanded claim has at most 32 levels, counting predicate calls and
products, and 4096 visited nodes, counting each occurrence. The node
budget is shared by both branches of a product. Existing source, token,
identifier and proof-expression bounds continue to apply.

## Proofs and invariants

Named claims work in helper signatures, proof annotations, proof-local
bindings and entry-local erased bindings. Predicates returning `Both`
can be proved with pairs and used through checked projections. All
components and annotations remain obligations, including discarded ones.
Helpers instantiate named conclusions with their supplied Word values.

A guard annotation must expand to one atomic bound. The runtime guard
syntax remains `leWord` or `lt256`; it is checked against the expanded
annotation. Storage invariants also accept products after the
[compound invariant slice](M1-COMPOUND-INVARIANTS.md). Every component
remains an obligation. A predicate adds no runtime test.

```
invariant bounded (s : State) : Prop := Below(s.count, s.limit)
```

Invariant arguments use snapshot fields or literals. Every field passed
to the predicate participates in the existing load, store and final
state tracking, even if the definition ignores that argument. The
constructor and successful writes must establish the expanded claim.
Checked inline or named evidence can discharge the same obligation.
An old load or overwritten value cannot justify a different final state.

## Erasure and validation

Predicates expand within contract lowering. They introduce no core
declarations, axioms, ABI arguments, storage slots or runtime values.
Equivalent named and inline claims produce identical `runtime.hex`,
`init.hex`, `abi.json`, `layout.json` and `axioms.txt`. The carried
kernel, surface, proof protocol, backend, assembler and Lean sources
are unchanged. Symbolic arithmetic lemmas, induction and epoch-indexed
invariants remain separate work.

`python3 -P dev/predicate-test.py` exercises execution, rejected source,
erasure, boundaries and
[four compiler mutations](M1-PREDICATE-MUTATIONS.md).
Each mutation has a named witness and passing restored control.
`--m1-predicates` adds this gate to the previous 48 legs.
`STAGE-M1-PREDICATES OK` requires all 49 legs to pass.

Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). The
preserved denominator manifest and measurement do not validate the
current compiler. No fresh performance result or milestone exit is
claimed.

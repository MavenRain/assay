# M1 inferred arithmetic proofs

The nineteenth M1 slice lets `addLt` and `subLe` reuse established
evidence when their last argument is omitted. For example:

```
guard OverflowRevert (lt256 (add c n)) ;
let total : Word := addLt c n ;
```

[InferredArithmetic.asy](../examples/InferredArithmetic.asy) uses this
form for the bounded counter's increment and decrement operations.
Its five emitted files equal those of `CounterProofs.asy` after
matching the contract name.

## Evidence selection

Omission is recognized at the statement's semicolon. `addLt a b`
requires `Lt256 (add a b)`, while `subLe a b` requires `Le b a`.
The compiler looks up that exact claim for the resolved Word values
in the current transaction. Evidence can come from an earlier named
or anonymous guard, an erased proof binding, or a component of a
nested or named proof bundle. The most recently recorded matching
evidence is selected.

If no evidence matches, the compiler supplies a unit witness. The
kernel accepts it only when the required proposition reduces to
true, such as `addLt (word 2) (word 3)`. A missing symbolic bound,
closed overflow or closed underflow fails kernel checking. Every
inferred argument retains its expected type before erasure, including
arithmetic whose result is unused or followed by a revert.

Supplying a proof explicitly retains the existing checking behavior.
An invalid supplied proof is rejected even when other valid evidence
is available. Guards retain their runtime checks and declared error
payloads. Inference adds no runtime arithmetic check, ABI parameter,
axiom or backend operation.

## Scope and limits

Evidence describes the Word values at its point of introduction.
Shadowing a proof name does not remove its checked evidence. Writing
storage does not change a previously loaded Word value. Rebinding a
Word, reloading storage or calculating a new value introduces a new
operand and does not transfer evidence to it.

Lookup is deliberately exact. It does not search through Word aliases,
derive transitive bounds, commute addition, invoke proof helpers or
use evidence from another entry or a later statement. Supply an
explicit proof when kernel conversion can justify an alias that this
lookup does not recognize. The older `guard le a b` statement does
not introduce erased evidence.

The later [inferred helper slice](M1-INFERRED-HELPERS.md) permits
omitted trailing proof arguments in helper calls. Constructors still
accept literal stores only. Existing effect, expression and predicate
expansion limits apply.

## Validation

`python3 -P dev/inferred-arithmetic-test.py` checks:

- 158 source-model/Cancun execution comparisons and two creation
  outcomes, including overflow, underflow, payloads and rollback.
- 24 rejected programs through `check`, `emit` and `run`.
- 16 inferred/explicit pairs with equality of `runtime.hex`,
  `init.hex`, `abi.json`, `layout.json` and `axioms.txt`.
- Four [compiler mutations](M1-INFERRED-ARITHMETIC-MUTATIONS.md)
  with restored passing controls.

The `--m1-inferred-arithmetic` selector adds one leg to
the previous 53-leg battery. Prior commands, deadlines and success
markers remain unchanged. The kernel, carried surface, proof sources,
effect protocol and backend are unchanged.

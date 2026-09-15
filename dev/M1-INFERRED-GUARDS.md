# M1 inferred guard evidence

The eighteenth M1 slice lets a guard obtain its erased evidence type
from its condition. An entry can check a named predicate without
repeating the proposition in a proof binder:

```
guard Denied (a) (b) (Bounds(a, b)) ;
sstore low a ; sstore high b ; pure a
```

[InferredGuards.asy](../examples/InferredGuards.asy) declares the
predicate and a storage invariant that uses its evidence. A failing
check rolls back the earlier store and returns the declared error
payload.

## Syntax and scope

`guard ERROR PAYLOADS (CONDITION) ;` uses the same condition and error
syntax as an explicitly annotated proof guard. Omitting the error uses
the empty revert payload. Nullary errors accept `Halt` and `Halt ()`.
Conditions can be atomic `leWord` or `lt256` checks, lowercase `both`
combinations, or named predicate calls. Contextual names remain usable.

```
guard (leWord a b) ;
guard Halt () (lt256 (add a b)) ;
guard Denied (a) (b) (both (Below(a, b)) (Room(a, b))) ;
```

Each inferred guard lowers to the existing proof-producing guard with
an internal evidence name. The compiler derives `Le`, `Lt256`, `Both`
or a named claim from the supplied condition, then uses the existing
expansion and kernel checking paths. Every condition is still executed.
Inference does not establish a proposition by declaring it.

No source binding is introduced or shadowed. Source identifiers cannot
use the internal `_assay` prefix. Use an explicit `(0 p : CLAIM)` binder
when a later arithmetic operation or proof helper needs to name the
evidence. The older `guard le a b` form retains its existing behavior.

## Invariants and limits

Inferred evidence participates in final-state invariant checking,
including projections of compound predicates and components established
by separate guards. Evidence refers to the Word values at the guard.
Rebinding a Word, reloading a field or overwriting storage does not turn
it into a proof about the new value. Every affected invariant component
must still be established before a successful return.

The existing limits apply: 128 effect steps, 64 expanded atomic checks
per condition, predicate expansion depth 32 and 4096 visited nodes.
Condition syntax, Word arguments and custom payloads retain their limits
and scope checks. Constructors still accept literal stores only.

## Validation

`python3 -P dev/inferred-guard-test.py` checks:

- 112 source-model/Cancun comparisons and two creation outcomes.
- 24 refusals through `check`, `emit` and `run`.
- 14 inferred/explicit pairs with equality of `runtime.hex`, `init.hex`,
  `abi.json`, `layout.json` and `axioms.txt`.
- Six accepted boundary forms and four
  [compiler mutations](M1-INFERRED-GUARD-MUTATIONS.md) with passing
  controls.

`dev/gates.sh` selects `--m1-inferred-guards`, adding one leg to the
previous 52-leg battery. Existing commands, deadlines and markers are
unchanged. The kernel, carried surface, effect protocol, backend and
Lean sources are unchanged. No axiom, ABI parameter or storage slot is
added by inference.

Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). The
preserved denominator and ratio inputs describe an older compiler;
the M1 performance bound and milestone exit remain pending.

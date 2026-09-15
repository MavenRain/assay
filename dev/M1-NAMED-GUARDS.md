# M1 named runtime guards

The seventeenth M1 slice accepts named predicates as runtime guard
conditions. A contract can reuse one predicate in its proof annotation,
runtime check and storage invariant.

```
predicate Bounds (0 x : Word) (0 y : Word) : Prop :=
  Both (Le x y) (Lt256 (add x y))
entry set (a : Word) (b : Word) : Eff Sig Word := do
  (0 bounds : Bounds(a, b)) <- guard Denied (a) (b) (Bounds(a, b)) ;
  sstore low a ; sstore high b ; pure a
```

[NamedGuards.asy](../examples/NamedGuards.asy) includes the complete
declarations, nested predicates and an invariant. Its earlier write
demonstrates rollback when either condition fails.

## Conditions and scope

The runtime condition grammar now also accepts `NAME(ARGUMENTS)`.
Arguments use the existing comma-separated Word syntax. Nullary
predicates use `NAME()`. Calls can occur inside lowercase `both`
conditions, alongside `leWord` and `lt256` checks.

Runtime calls use the same declaration lookup and simultaneous argument
substitution as proof annotations. Definitions see their own parameters
and earlier predicates. Entries can use predicates declared later in
the contract. Unknown names, forward or recursive definitions, wrong
argument counts, and names shadowed by local Words or proofs are
refused. Every supplied argument is checked, including unused ones.

The existing contextual names remain usable. `both(a, b)` and `both()`
are predicate calls when such a predicate is declared. The compound form
`both (CONDITION) (CONDITION)` keeps its existing meaning. Error
payloads retain their parenthesized Word syntax and arity checks.

## Checking and limits

Expansion produces the same ordered atomic checks as an inline
condition. The kernel checks every continuation against the supplied
annotation, including unused evidence. A matching name does not waive
that check. Compound evidence supplies the existing projections,
arithmetic proof arguments and final-state invariant obligations.

Both annotations and runtime conditions retain the shared predicate
expansion limit of 4096 visited nodes and depth 32, counting predicate
calls and products. Runtime conditions additionally allow at most 64
atomic bounds after expansion, shared across the whole condition.
Source syntax retains its existing depth, token and argument limits.

Conditions and custom error payloads see the Word bindings before the
new proof enters scope. Rebinding a Word does not change an earlier
proof's snapshot. Runtime checks execute in source order, stopping at
the first failure with the same declared error and payload. Declaring
a predicate alone adds no runtime check.

## Erasure and validation

Named and inline conditions with the same contract declarations and
failure branch produce identical `runtime.hex`, `init.hex`, `abi.json`,
`layout.json` and `axioms.txt`. Predicate expansion adds no core axiom,
storage field or ABI argument. The carried kernel, effect protocol,
bytecode backend and Lean proof sources are unchanged.

`python3 -P dev/named-guard-test.py` covers:

- 96 source-model/Cancun comparisons and two creation outcomes.
- 27 refusals through `check`, `emit` and `run`.
- Ten erasure variants across three groups, comparing all five files.
- Six accepted boundary forms, including 64 checks and 32 aliases.
- [Four compiler mutations](M1-NAMED-GUARD-MUTATIONS.md) with controls.

`dev/gates.sh` selects `--m1-named-guards`, adding one leg to the
previous 51-leg battery. Its existing commands, deadlines and markers
are preserved. The older denominator and ratio checks remain in place;
timing and the M1 performance bound remain pending.

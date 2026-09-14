# M1 storage invariant declarations

The eleventh M1 slice checks declared storage bounds at construction and
at successful returns that modify their fields. It uses the existing
kernel and proof protocol. Declarations add no runtime checks, proof
objects, storage slots or ABI arguments.

```
contract CounterInvariant where
  storage State := { count : Word ; limit : Word }
  invariant bounded (s : State) : Prop := Le s.count s.limit
```

[CounterInvariant.asy](../examples/CounterInvariant.asy) supplies checked
proofs for both update paths. For example, after loading `bound` from
`limit`, a successful guard establishes the final claim before a store:

```
(0 q : Le value bound) <- guard (leWord value bound) ;
sstore count value ; pure value
```

## Grammar and scope

An invariant has the form `invariant NAME (S : STATE) : Prop := CLAIM`.
`STATE` must name the contract's storage declaration. A claim is either
`Le A B` or `Lt256 (add A B)`. Operands are decimal `word N` literals or
projections `S.FIELD`, optionally parenthesized. The snapshot binder is
local to this declaration and each field must exist in that storage
record. The declaration may appear before or after entries and errors.

There are at most 32 invariants. Names obey the existing identifier
rules, cannot repeat, and cannot conflict with storage, entry, error,
field or ABI argument names. `invariant` is itself a reserved word of
this slice, so a storage field, entry, error or ABI argument with that
name is refused with `SURFACE_NAME`. Operand nesting is bounded at 128,
within the existing byte, token and identifier limits. An invariant's name is
a declaration label, not an entry-local proof or callable predicate.

## Construction and preservation

Construction starts from zero storage and processes the existing literal
stores in order. Every invariant is checked against the resulting
state, including unchanged fields, unused declarations and later
declarations. An omitted constructor leaves every field zero. A last
store that falsifies a claim is rejected even if an earlier store would
have established it. Addition uses the mathematical uint256 bound.

The surface lowering tracks the most recent loaded or stored value of
each field. At a successful return, every invariant mentioning a field
written by that entry becomes an obligation over its final values.
Each needed field must have been loaded or stored along that path.
Missing values produce `SURFACE_INVARIANT`. A subsequent store replaces
the tracked value, so a proof about an earlier value cannot justify the
new one. Intermediate writes may violate a bound if the final state is
proved or the call reverts.

The compiler selects an in-scope guard or supplied proof with exactly
the resolved claim. The kernel checks that proof against the final
claim. Otherwise it tries the unit proof, which succeeds only when the
claim reduces to the unit proposition. A false or unresolved claim
produces a checked type mismatch. Proof aliases work, and shadowing a
source proof name does not remove evidence already established in the
enclosing checked core scope.

Proof selection is deliberately bounded. It does not infer transitivity,
subtraction monotonicity or general preservation lemmas. Word aliases
or a new load may require a new proof matching the final value names.
In particular, the example's decrement path guards its final bound.
The older boolean `guard le` produces no proof for an invariant.

An entry that writes none of a claim's fields preserves that claim
without a new obligation. Reverting paths preserve the preceding state
through the existing rollback behavior. Consequently, invariant
preservation starts from a valid constructor state and applies to a
sequence of successful or reverted calls. It is not a promise that a
read-only entry repairs an arbitrary invalid `run --storage` prestate.
External calls, mappings and epoch-indexed invariants remain outside
this M1 language.

## Checked core and erasure

Claims resolve only to validated field names and Word values. Each final
obligation is an application of an explicitly typed quantity-zero
function, including when its proof is unused. Constructor obligations
occur in its checked type annotation. This keeps proof closures out of
the closed constructor backend. Carried erasure removes both forms.

The inherited kernel, carried surface, proof protocol, assembler and
Lean sources are unchanged. The field tracking and obligation insertion
are counted in the emitter's trusted lines. This slice adds no compiler
correctness theorem or new axiom.

## Validation

`python3 -P dev/invariant-test.py` checks 52 source-model/Cancun cases,
both constructor outcomes and 30 refusals through check, emit and run.
The cases include maximum words, overflow, underflow, invalid prestates,
rollback, a sequential chain with refused bound, overflow and underflow
steps, multiple invariants, shadowing and accepted
nesting/member boundaries. Four variants preserve all five output files,
including the version with its invariant declaration removed.

[Four compiler mutations](M1-INVARIANT-MUTATIONS.md) have named refusal
witnesses and restored controls. `--m1-invariants` includes the previous
45 legs and adds this gate. `STAGE-M1-INVARIANTS OK` requires all 46
legs to pass. The prior timing measurement and denominator manifest
remain preserved under [TIMING-DEBUG.md](TIMING-DEBUG.md). They do not
validate the current compiler. The M1 performance bound remains open.

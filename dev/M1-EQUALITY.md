# Word equality in contract source

The twenty-sixth M1 slice starts at
`92aa8a903910a03d43c7b50b212efd9a8ddefa28`. It adds two surface forms:

| Form | Expansion |
| --- | --- |
| `eqWord a b` | `both (leWord a b) (leWord b a)` |
| `EqWord a b` | `Both (Le a b) (Le b a)` |

Both operands are existing Word expressions. The runtime guard succeeds
exactly when the unsigned words agree. It checks the first comparison,
then the reverse comparison. Failure uses the normal empty revert or
the supplied custom error, including its checked payload. Writes before
a failed guard roll back with the transaction.

The proof form is a product of bounds. It supplies both arithmetic
obligations through `first` and `second`, including inferred arithmetic
and helper arguments. It does not provide a new equality eliminator or
rewrite local variables. Normal snapshot and shadowing rules still apply.

```text
(0 same : EqWord a b) <- guard (eqWord a b) ;
let zero : Word := subLe a b second(same) ; pure zero
```

An omitted binding annotation infers the same pair. Named predicates,
proof helpers, supplied proof terms and storage invariants accept
`EqWord` anywhere they accept a claim. Equality counts as two runtime
bounds and one product node with two leaves in a claim. The existing
64-bound and depth-32 guard limits apply after expansion; explicit
claim nesting includes the generated pair and its leaves.

`EqWord` and `eqWord` are reserved contract source names. Programs using
neither new name keep their existing protocols and artifacts. The
kernel, inherited parser, core recognizer, emitter, source model and
axiom set are unchanged. The contract lowerer adds eight lines, bringing
the combined emitter budget to 1800/1800.

[OwnerSurface.asy](../examples/OwnerSurface.asy) initializes an owner
from the deployer and checks the caller before changing ownership:

```sh
_build/default/bin/assay.exe emit examples/OwnerSurface.asy -o OwnerSurface-out
python3 -P dev/equality-test.py
python3 -P dev/stage-a-gates.py --m1-equality
```

The focused gate compares all five artifacts with explicitly expanded
programs for eight source forms. Independent expectations cover 53
runtime outcomes, including unequal values in both directions, uint256
boundaries, caller authorization and storage rollback. The source model
and geth run each case. Thirty-three cases additionally use signed
Cancun transitions. Both execution paths use geth, so these are not two
independent client implementations. Eight creation cases check deployer
ownership, exact installed runtime bytes and nonpayable construction.

Six boundary forms cover accepted and refused guard width, guard depth
and claim depth. Seventeen invalid programs are refused by `check`,
`emit` and `run`; refused emission must leave no output directory.
[Four compiler mutations](M1-EQUALITY-MUTATIONS.md) must fail their
named witnesses and pass again after restoration. Earlier gate commands,
deadlines and success markers are preserved.

Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). Frozen
measurement inputs are unchanged. This slice makes no new performance
or milestone-exit claim. Evidence is retained in the
[validation archive](validation/2026-09-17-m1-equality/).

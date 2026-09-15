# M1 reusable proof helpers

The twelfth M1 slice adds reusable, pure proof declarations. Every
helper is checked by the existing kernel, including unused declarations.
Calls can supply arithmetic proofs, erased local bindings and final
storage invariant evidence. Helpers add no runtime checks or new axioms.

```
proof ordered (0 x : Word) (0 y : Word) (0 p : Le x y) : Le x y := p

entry subtract (a : Word) (b : Word) : Eff Sig Word := do
  (0 p : Le b a) <- guard (leWord b a) ;
  let v : Word := subLe a b ordered(b, a, p) ; pure v
```

[ProofHelpers.asy](../examples/ProofHelpers.asy) also shows an addition
helper, a closed proof constant, helper composition, proof-local
shadowing and typed reverts with storage rollback.

## Grammar and scope

`proof NAME PARAMETERS : CLAIM := PROOF` declares a helper. A parameter
is `(0 NAME : Word)` or `(0 NAME : CLAIM)`. Claims retain the existing
`Le A B` and `Lt256 (add A B)` forms. Parameters may be interleaved, and
their types see only preceding parameters. The conclusion and body see
all parameters. Word and proof names retain distinct roles.

The later [proof bundle slice](M1-PROOF-BUNDLES.md) adds
`Both (CLAIM) (CLAIM)` to parameters, conclusions and annotations.
The [compound guard slice](M1-COMPOUND-GUARDS.md) supplies these bundles
from nested runtime checks.
The [named predicate slice](M1-PREDICATES.md) also permits parameterized
claim names in signatures and annotations.

`NAME(ARGUMENTS)` calls a helper inside a proof expression. Arguments
are comma-separated and supplied in declaration order. A Word argument
is a local Word or `word N`, with optional parentheses. A proof argument
uses the existing proof-expression grammar, including nested calls.
Constants have no parameters and are called with `NAME()`.

Helpers can call earlier helpers. Recursion and forward references
between helpers are refused. Entries can call any declared helper,
including a later declaration. Helpers cannot access entry locals,
storage fields or other helpers' parameters. Parameter names are unique
within each helper. Helper names cannot conflict with other globals,
storage fields, or entry and error argument names. A local Word or proof
can shadow a helper, but calling the shadowed name is refused.

The limits are 32 helpers, 16 parameters or call arguments, and 128
nested proof expressions. Existing byte, token and identifier bounds
also apply. `proof` is a reserved identifier. A comma is valid only
between helper call arguments; trailing commas are refused.

## Checking and erasure

Lowering resolves names to fresh core identifiers. Each helper becomes
an ordinary pure core definition with an explicit dependent function
type. The carried kernel checks top-level definitions in runtime mode,
so helper parameters and proof-local binders inside those definitions
use ordinary core quantities. The surface requires zero quantities and
permits applications only in proof positions, where the whole call is
erased. Entry-local proof bindings retain their quantity-zero core form.

This distinction introduces no runtime escape: a helper cannot appear
as a Word, return value, store value or error payload. The body grammar
has no effects or runtime result. The existing checker validates every
definition and call before erasure, including false unused declarations,
false unused proof-local bindings, and unused call arguments. A proof
parameter's claim is instantiated with the supplied Word arguments.

Helpers are checked once as generic functions. They cannot establish a
symbolic claim merely because particular callers use true literals.
Aliases and applications preserve the existing storage snapshot rules.
Reloading a field requires evidence about its new snapshot.

The kernel, carried surface, proof protocol, specializer, arithmetic,
assembler and Lean sources are unchanged. All five output files match
the corresponding inline proof programs. The ABI has no helper entries
or helper parameters, and emitted axiom disclosure remains `EvmOpcodes`.
This slice adds no compiler theorem, induction, user-defined predicates,
automatic preservation lemmas or epoch-indexed invariants.

## Validation

`python3 -P dev/proof-helper-test.py` checks 104 source-model/Cancun
cases, two creation outcomes and 50 refusals through check, emit and
run. Six guarded variants and seven closed variants produce identical
five-file outputs; all seven closed variants also execute. Six accepted
boundary programs include 32 helpers, 16 parameters and arguments, and
128 nested calls. The tests also cover helper-backed storage invariants,
snapshot reuse, declaration order and interleaved parameters.

[Four compiler mutations](M1-PROOF-HELPER-MUTATIONS.md) have named
witnesses and restored controls. The existing proof annotation mutation
now targets its moved lowering function and retains its original
witness. `--m1-proof-helpers` adds this gate to the prior 46 legs. A
complete `STAGE-M1-PROOF-HELPERS OK` requires all 47 legs to pass.

Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). The
preserved denominator manifest and measurement do not validate this
compiler. No fresh performance verdict or milestone exit is claimed.

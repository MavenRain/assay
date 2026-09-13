# M1 supplied proof terms

The tenth M1 slice adds checked proof expressions to the contract surface.
An entry can establish a closed bound, name an existing proof, or pass a
proof expression directly to `addLt` or `subLe`. The carried kernel checks
every claim before erasure, including claims whose proofs are unused.

```
let (0 p : Lt256 (add (word 2) (word 3))) := () ;
let v : Word := addLt (word 2) (word 3)
  (let (0 q : Lt256 (add (word 2) (word 3))) := p in q) ;
pure v
```

[ProofTerms.asy](../examples/ProofTerms.asy) also shows an alias of a
guard-derived ordering proof, a typed failure payload and storage rollback.

## Grammar

The existing predicates are `Le A B` and `Lt256 (add A B)`. Their operands
are surface Word expressions, including literals and local Word names.

| Form | Meaning |
| --- | --- |
| `let (0 P : CLAIM) := PROOF ; REST` | Bind a checked erased proof for the remaining entry body |
| `()` | The unit proof, accepted only when the expected predicate reduces to the unit proposition |
| `P` | An in-scope erased proof |
| `(PROOF)` | Group a proof expression |
| `(PROOF : CLAIM)` | Check an explicit claim as well as the surrounding expected claim |
| `let (0 P : CLAIM) := VALUE in BODY` | Bind a proof inside a proof expression |

The last form can be parenthesized when used as an arithmetic argument.
Every proof binder has quantity zero. A proof-local binding is in scope
only in its body. Its claim and value resolve in the preceding scope,
so `let (0 p : CLAIM) := p in p` can shadow a preceding proof named `p`.
It cannot define a recursive proof. Forward references, cross-entry
references and escaped proof-local names are refused.

An explicit annotation is an obligation even if the surrounding predicate
is true. A false binding remains an error when unused. For example,
`let (0 p : Le (word 1) (word 0)) := () ; pure (word 0)` is rejected.
Likewise, `()` cannot prove a bound on arbitrary entry arguments. Such a
bound needs the existing proof-producing guard or an in-scope proof of
the same claim. Closed claims use the mathematical uint256 bound, so a
sum equal to `2^256` is rejected.

Proofs and Words share lexical names but retain distinct roles. A Word
shadowing a proof cannot be supplied to arithmetic as evidence. A proof
cannot be returned, stored or used in an error payload as a Word. A
storage load still denotes an immutable snapshot: a later store preserves
its proof, while a new load requires new evidence.

Proof expression nesting is bounded at 128. Proof bindings count toward
the existing 128-step entry limit. The existing source-byte, token,
identifier, member and Word-expression limits still apply. Constructors
continue to accept literal stores and `pure ()` only.

## Checked core and erasure

The parser builds a bounded syntax tree and resolves every source name
to a fresh core name. It copies no unchecked proof syntax into the core.
`()` lowers to `tuple ()`. Annotations remain explicit core annotations.
Bindings lower to applications of quantity-zero functions with explicit
function types. The function annotation fixes the claimed input type even
when the continuation does not use its proof.

The existing `Le`, `AddFits`, `guardLe`, `guardAdd`, `addLt` and `subLe`
protocol is unchanged. No kernel, carried surface, runtime arithmetic,
assembler or Lean source changes. The proof protocol's existing refusal
of additional user axioms still applies. The existing Lean model covers
the earlier Result protocol; this slice adds no compiler theorem.

Carried erasure removes proof arguments before specialization. Equivalent
proof shapes leave all five output files equal, and a supplied arithmetic
proof removes one conditional jump compared with the checked Result form.
Proofs add no ABI arguments, storage slots or runtime proof objects.

## Validation and remaining work

`python3 -P dev/proof-term-test.py` checks 98 source-model/Cancun cases,
two constructor outcomes and 25 refusals through check, emit and run.
It covers maximum words, overflow, subtraction underflow, explicit
annotations, unused false claims, aliases, shadowing, snapshot reuse and
the accepted and rejected proof-nesting boundary. Three guard-derived
proof shapes for each arithmetic operation produce equal five-file
outputs. Five closed proof shapes also produce equal five-file outputs.

[Four compiler mutations](M1-PROOF-TERM-MUTATIONS.md) have named rejection
witnesses and restored controls. `--m1-proof-terms` adds this gate to the
existing 44 legs. `STAGE-M1-PROOF-TERMS OK` requires all 45 legs to pass.
Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). The old
denominator manifest and measurement remain preserved, so `DENOMINATORS`
and `M0-RATIO` are expected to fail on this compiler. No complete battery
pass or fresh performance verdict is claimed.

Invariant declarations and the M1 performance bound remain unfinished.
General proof functions, induction and user-defined surface predicates
are outside this bounded expression grammar. Core source remains
available for the existing checked proof language.

# M1 contract surface

The fifth M1 slice adds `contract`, `storage`, `entry` and sequential `do`
syntax over the existing checked core protocol. `emit/contract.ml` lowers
the source to the carried grammar before the ordinary checker and erasure.
No kernel former, axiom or carried surface file is added or changed.
The new module and its interface are counted inside the existing 1800-line
emitter allocation. No trusted-line bound is increased.

`examples/CounterSurface.asy` emits the same five files, byte for byte, as
`examples/Counter.asy`: runtime, creation, ABI, layout and axiom disclosure.
The declared contract name supplies layout metadata even when the file has
a different name. Core files retain the filename rule.

```
contract Counter where
  storage State := { count : Word ; limit : Word }
  entry increment (n : Word) : Eff Sig Word :=
    do c <- sload count ;
       s <- add c n ;
       bound <- sload limit ;
       guard le s bound ;
       sstore count s ; pure s
  entry get () : Eff Sig Word := do c <- sload count ; pure c
  constructor := do sstore limit (word 100) ; pure ()
```

The complete fixture also has `decrement`. It can be passed to `check`,
`check --print`, `check --erased`, `axioms`, `emit`, `trace`, `diff` and
`run`. `check --print` exposes the checked core declarations. Surface
contracts export `main`; alternate exports remain a core-source feature.

## Grammar and effects

One file holds one contract. Its first significant word is `contract`.
Leading whitespace and `--` line comments are accepted, on both `.asy`
and `.kan` files. Every other file goes unchanged to the inherited parser.
The contract starts with `contract NAME where`, followed by one
`storage NAME := { FIELD : Word ; ... }` declaration. The final field
semicolon is optional. The storage name becomes an alias of `Storage`.

Each entry has `entry NAME (ARG : Word) ... : Eff Sig Word := do BODY`.
Use `()` for an entry without arguments. Storage fields and arguments are
uint256 words. The generated named products and entry sum supply the
existing ABI/layout recognizer, dispatcher and calldata decoder. Field,
entry and argument order is preserved. Mutability remains inferred from
the checked effects. Entries use the existing nonpayable guard, ignore
trailing calldata and revert on short heads or unknown selectors.

| Body form | Checked core behavior |
| --- | --- |
| `x <- sload field ; REST` | Snapshot the field, bind the word and continue |
| `x <- caller ; REST` | Snapshot the immediate caller and bind its Word value |
| `x <- add a b ; REST` | Eliminate `ResultWord`, continuing with success or reverting on overflow |
| `x <- sub a b ; REST` | Eliminate `ResultWord`, continuing with success or reverting on underflow |
| `sstore field value ; REST` | Store a word and continue |
| `guard le a b ; REST` | Continue when `a <= b`, otherwise revert |
| `let x : Word := value ; REST` | Bind a word in the remainder of this body |
| `let x := value ; REST` | Infer the Word type and use the same checked binding |
| `pure value` | End the entry by returning one word |
| `revert` | End the entry by reverting with empty data |

A value is an argument, an earlier local binding or `word DECIMAL`, with
optional parentheses. Arithmetic never exposes a wrapped result. Its error
leg explicitly aborts in the generated core, so writes roll back through
the existing model and EVM rules. The core syntax remains available for
programs that recover from an arithmetic error.

Locals can shadow arguments or earlier locals. Generated binders are fresh
and never copied from user names. Storage operands always resolve against
the declared fields, independently of locals. An unbound word or field is
a named refusal. Argument aliases can be shared across entries or with a
storage field because they all denote `Word 256`. Entry and storage-type
names must not collide with those aliases or each other.

An optional `constructor := do BODY` contains literal `sstore` statements
and `deployer field` initialization, and ends in `pure ()`. Writes retain
their source order. No constructor means no initial writes. Constructor
loads, caller bindings, locals, arithmetic, guards and non-unit returns
are refused. Runtime `pure ()` is also refused. The
[context slice](M1-CONTEXT-SURFACE.md) describes caller bindings and the
invariant restrictions on deployer initialization.

## Bounds and remaining work

Names are ASCII identifiers of at most 64 characters. Language and protocol
names, `_`, and the `_assay` prefix are reserved. Storage has 1 to 32 fields;
the table has 1 to 32 entries, each with 0 to 32 arguments. Every entry may
be nullary. The [nullary slice](M1-NULLARY.md) gives empty argument records
an explicit `Type 0` annotation when the complete table has no arguments.
This preserves selector tags through the carried erasure. Mixed tables,
including the counter's `get()`, retain their original checked form.

Each body has at most 128 effect or let steps. Value parentheses nest at
most 128 levels. Contract files contain at most 65536 bytes and 8192
non-comment tokens. Decimal literals must be below `2^256`, with at
most 78 digits. Existing core specialization, depth, memory and bytecode
bounds still apply after lowering. The [hex literal slice](M1-HEX-LITERALS.md)
also accepts hexadecimal Word literals. The
[inferred Word slice](M1-INFERRED-WORDS.md) makes runtime binding
annotations optional while retaining all existing checks.
`.` is a punctuation token of the
surface and is valid only inside an invariant claim. A `.` in any other
position is refused as `SURFACE_SYNTAX`, not as `SURFACE_TOKEN`. `,` is
a punctuation token of the surface and is valid only inside a proof
helper call argument list. A `,` outside such a list is refused as
`SURFACE_SYNTAX`, or as `SURFACE_DECLARATION` after a declaration body,
and never as `SURFACE_TOKEN`.

Surface refusals print `SURFACE_*` diagnostics and exit 1, before output
creation. Existing backend refusals exit 2 and driver misuse exits 64.
The [proof guard slice](M1-GUARDS.md) adds the P1 bound guards and erased
proof binders. The [supplied proof slice](M1-PROOF-TERMS.md) adds checked
closed bounds, erased proof aliases and proof-local bindings. The
[invariant slice](M1-INVARIANTS.md) adds storage bound declarations and
checked obligations for construction and affected successful writes. The
[proof helper slice](M1-PROOF-HELPERS.md) reserves `proof` for pure
helper declarations and adds comma-separated calls in proof expressions.
The [proof bundle slice](M1-PROOF-BUNDLES.md) reserves `Both` and adds
contextual `pair`, `first` and `second` inside proof calls.
The [equality slice](M1-EQUALITY.md) reserves `EqWord` and `eqWord`.
They expand to a proof bundle and runtime bounds in both directions.
The [proof-placeholder slice](M1-PROOF-HOLES.md) accepts `_` as a proof
expression with an expected claim. It remains reserved as an identifier.
The [inferred-binding slice](M1-INFERRED-BINDINGS.md) accepts
`let (0 p) := PROOF` in entries and proof-local expressions, deriving
the binding's type from its checked initializer.
The M1 performance bound also remains open. The original surface uses the
checked Result/error path of the design. The following
[source-proof slice](M1-PROOFS.md) proves overflow freedom for a Lean model
of that path and tests its correspondence with the OCaml implementation.

## Validation

`python3 -P dev/contract-test.py` compares all five counter output files
with the core source and executes all 30 frozen counter rows against the
source model, emitted runtime and committed reference. Both geth execution
paths run. The test also checks both creation outcomes, all 216 emitted
runtime instructions, 14 additional cases, three-way disassembly,
36 refusals through three public commands, five accepted boundary programs
and a model invocation with no tools on PATH.

Eight compiler mutations must fail their named semantic or refusal witness
and pass after restoration. See [the mutation ledger](M1-SURFACE-MUTATIONS.md).
The `--m1-surface` mode has 39 legs and ends in `STAGE-M1-SURFACE OK`.
Its initial evidence is archived under
`dev/validation/2026-09-12-m1-surface/`. These gates test the OCaml
implementation; they do not prove it, and the two executors are entry
points of geth rather than independent client implementations.

The source-proof slice fixes constructor result, revert and guard positions
and pins all three through check, emit and run. Core routing scans the
contract keyword lazily, including an early exit for a large first identifier.
The nullary slice promotes the former nullary-only refusal to an accepted
boundary program and adds its own dispatch and execution gate.

The [typed error slice](M1-ERRORS.md) adds `error` declarations and named
`revert` payloads. Its checked error sum supplies both the ABI and encoding.

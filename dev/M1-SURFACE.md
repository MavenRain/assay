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
| `x <- add a b ; REST` | Eliminate `ResultWord`, continuing with success or reverting on overflow |
| `x <- sub a b ; REST` | Eliminate `ResultWord`, continuing with success or reverting on underflow |
| `sstore field value ; REST` | Store a word and continue |
| `guard le a b ; REST` | Continue when `a <= b`, otherwise revert |
| `let x : Word := value ; REST` | Bind a word in the remainder of this body |
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
and ends in `pure ()`. Stores retain their source order. No constructor
means no initial writes. Constructor loads, locals, arithmetic, guards and
non-unit returns are refused. Runtime `pure ()` is also refused.

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
non-comment tokens. Literals must be decimal values below `2^256`, with at
most 78 digits. Existing core specialization, depth, memory and bytecode
bounds still apply after lowering.

Surface refusals print `SURFACE_*` diagnostics and exit 1, before output
creation. Existing backend refusals exit 2 and driver misuse exits 64.
The P1 proof-producing guard forms, erased proof binders, invariant
declarations and typed custom reverts
remain unfinished. These keywords are refused; no proof annotation is
discarded. The M1 performance bound also remains open. This slice uses the
checked Result/error path of the design. The following
[source-proof slice](M1-PROOFS.md) proves overflow freedom for a Lean model
of that path and tests its correspondence with the OCaml implementation.

## Validation

`python3 -P dev/contract-test.py` compares all five counter output files
with the core source and executes all 30 frozen counter rows against the
source model, emitted runtime and committed reference. Both geth execution
paths run. The test also checks both creation outcomes, all 216 emitted
runtime instructions, 13 additional cases, three-way disassembly,
36 refusals through three public commands, five accepted boundary programs
and a model invocation with no tools on PATH.

Seven compiler mutations must fail their named semantic or refusal witness
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

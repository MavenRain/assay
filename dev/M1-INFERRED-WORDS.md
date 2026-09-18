# Inferred runtime Word bindings

The twenty-eighth M1 slice starts at
`cf3b6cf0474ce66f684bd99c0b5ac87eb3982145`. A runtime binding can omit
its `: Word` annotation:

```text
let floor := word 0x0A ;
guard (leWord floor amount) ;
let result := subLe amount floor ; pure result
```

The initializer accepts the same forms as an explicitly typed Word
binding: a literal, a local Word, `addLt` or `subLe`. Arithmetic still
requires checked evidence, supplied explicitly or inferred from the
current scope. Parenthesized values, proof holes, helpers and bundle
projections retain their existing rules.

Both spellings construct the same binding and lower to the same checked
core. There is no general type inference: a supplied annotation must
still be `Word`, and effects such as `caller` and `sload` still use
`<-`. Erased bindings retain their separate `let (0 proof)` syntax.
Entry and helper parameters still require their declared types.

Initializers see the preceding scope. A binding can shadow an argument
or earlier local, including reading the old value in its initializer.
Word aliases preserve loaded snapshots and checked proof dependencies.
An erased proof cannot initialize a runtime Word, even when the binding
is unused. Arithmetic evidence is checked before erasure, including
when the continuation reverts. Locals do not escape their entry.

Constructor bindings remain refused. The existing 128-step body limit
counts inferred and explicit bindings alike. No kernel, axiom, backend,
source model or trusted-line bound changes. The emitter remains at
1800/1800 lines.

[InferredWords.asy](../examples/InferredWords.asy) combines a hex literal,
an inferred Word alias, a typed custom revert and inferred subtraction
evidence. The focused gate compares all five emitted artifacts for 21
inferred/typed source pairs and checks independent expected results for
40 source-model executions, 40 geth runs and 40 signed Cancun
transitions. Both EVM execution paths use geth. Nineteen refused source
forms run through `check`, `emit` and `run`, with no output directory
created by a refused emission. Two cases pin the effect-step boundary.
Four compiler mutations must fail their named witnesses and pass again
after restoration.

```sh
python3 -P dev/inferred-word-test.py
python3 -P dev/stage-a-gates.py --m1-inferred-words
```

Earlier gate commands, deadlines and success markers are preserved.
DENOMINATORS and M0-RATIO retain the existing timing pause and their
failure status in the complete runner. No frozen timing input is
refreshed by this slice.

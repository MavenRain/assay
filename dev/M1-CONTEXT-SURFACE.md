# Contract surface context

The twenty-fifth M1 slice starts at
`dbce0894338775d0eb97bbc0e76ac5605c728552`. It exposes the existing
[core context effects](M1-CONTEXT.md) through contract source:

```text
entry who () : Eff Sig Word := do
  sender <- caller ; pure sender
constructor := do deployer owner ; pure ()
```

`sender <- caller` binds the immediate EVM caller as a Word. Each read
has its own snapshot and follows the normal local binding and shadowing
rules. The value can be returned, stored, passed to proof helpers or
used in guards and checked arithmetic. Caller-only entries are `view`;
entries that write storage are `nonpayable`. The model uses the existing
`run --caller` option, with a zero default and an unsigned uint160 bound.

`deployer field` initializes a declared field with the immediate creation
caller. It is valid only in constructors. Literal stores and deployer
writes execute in source order, including repeated writes and later
overwrites. Constructors still end in `pure ()`; transaction caller
reads, local bindings and other dynamic constructor expressions remain
unsupported. `caller` and `deployer` are reserved source names.

A deployer write invalidates the compiler's known literal value for
that field. An invariant that mentions the field is refused unless a
later literal store supplies its final value. The diagnostic names the
field whose value is unknown. Unrelated storage invariants continue to
be checked, including contracts that initialize an owner from the
deployer and maintain a separate bounded counter. Runtime caller values
must satisfy the existing proof obligations after successful writes.

The surface selects the optional core constructors only when used.
Existing programs using neither new reserved name retain their protocols
and artifacts.
The kernel, inherited surface parser, core recognizer, emitter, model
and axiom set are unchanged. No new axiom or runtime intrinsic is added.

[ContextSurface.asy](../examples/ContextSurface.asy) demonstrates caller
snapshots, deployer initialization, storage updates and rollback on a
custom error:

```sh
_build/default/bin/assay.exe emit examples/ContextSurface.asy -o ContextSurface-out
_build/default/bin/assay.exe run examples/ContextSurface.asy --calldata 0xd6d21dfd --caller 0x42
python3 -P dev/context-surface-test.py
python3 -P dev/stage-a-gates.py --m1-context-surface
```

The focused gate compares all five emitted files against equivalent
core programs for eight protocol combinations. It checks 224 runtime
cases against independent expectations, the source model and geth,
including 56 signed Cancun transition comparisons. It also checks 64
creation outcomes, six caller/proof composition cases, four constructor
ordering cases and 17 invalid sources through `check`, `emit` and `run`.
Both execution entry points use geth. They are separate execution paths,
not independent client implementations.

Four built compiler mutations must fail their named witnesses, and
restored controls must pass. The mutations replace caller values,
replace deployer writes, retain stale constructor state and select the
wrong storage slot. Earlier gate commands, deadlines and success
markers are preserved. The emitter measures 1792/1800 lines.

Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md). Frozen
measurement inputs are unchanged; this slice makes no new performance
or milestone-exit claim. The
[validation archive](validation/2026-09-17-m1-context-surface/) records
58 passing functional gates after five environment rechecks, the two
pending timing gates and exact source identities.

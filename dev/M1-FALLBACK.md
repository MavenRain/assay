# Explicit reverting fallbacks

The twenty-ninth M1 slice starts at
`3e997f1bb4c69a35ee065018ac1238856cbe3b8c`. A contract can declare one
fallback alongside its entries, errors and constructor:

```text
error MalformedCalldata ()
fallback : Eff Sig Never := revert MalformedCalldata
```

The new spellings `fallback` and `Never` are reserved identifiers.

The fallback runs when calldata is shorter than four bytes or its
selector matches no entry. A declared error can carry parenthesized
Word literals, including hexadecimal literals, in declaration order.
`fallback : Eff Sig Never := revert` keeps the empty revert behavior.
The fallback must end immediately in a revert. It has no arguments,
local scope, storage reads, writes, caller binding or successful return.
The `Never` spelling describes this surface restriction; lowering uses
the existing checked `Tx` protocol and adds no kernel type or axiom.

Known selectors still use their entry's argument decoder. A truncated
known call reverts with empty data. Trailing calldata remains accepted.
The nonpayable check runs before fallback selection, so any nonzero
call value reverts with empty data. A revert inside an entry retains
that entry's original payload and rolls back its writes.

The ABI includes a nonpayable fallback row only for a declared fallback.
An explicit empty fallback has the same runtime and creation bytes as
an omitted fallback. Existing contracts that omit the fallback and avoid
the newly reserved names retain their five artifacts byte for byte.
Constructor initialization and the
nonpayable creation guard retain their existing behavior.

Core source can provide a closed `def fallback : Tx := ...` declaration.
Preparation accepts only an empty abort or a custom error with constant
Word operands after checked specialization. Returning, loading, writing,
reading the caller, branching and arithmetic nodes are refused by both
`emit` and `run`. An absent declaration retains the empty abort.

The [example](../examples/Fallback.asy) includes a nullary fallback
error, a successful storage write and an entry-specific error after a
write. The focused gate checks independent expected outcomes against
the source model, `evm run` and signed Cancun transitions. Both EVM
execution paths use geth, so this is not independent implementation
agreement. It also checks ABI rows, creation, 32-word payloads, surface
and core refusals, and six compiler mutations with restored controls.

```sh
python3 -P dev/fallback-test.py
python3 -P dev/stage-a-gates.py --m1-fallback
```

The emitter stays at 1800/1800 physical lines. The implementation removes
24 blank separators between existing declarations; the kernel, carried
surface, proof packages and trusted bounds are unchanged. Earlier gate
commands, deadlines and success markers are retained. DENOMINATORS and
M0-RATIO remain failed under the existing timing pause; this slice does
not refresh their frozen inputs.

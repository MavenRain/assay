# Core EVM context

The twenty-fourth M1 slice adds the context effects used by the public
[self-referential DAO port][dao-port]. It starts at
`b2415c461b357fb3d715aa53e10494f1e401e101`.
The checked core grammar already expresses both effects:

```text
mu Eff : Type 0 :=
  | ret : Word 256 -> Eff
  | put : Word 256 -> Word 256 -> Eff -> Eff
  | read : Word 256 -> Eff
  | deployer : Word 256 -> Eff -> Eff

-- Append after abort, optional reject, and optional proof effects.
  | caller : (Word 256 -> Tx) -> Tx
```

Both additions are optional. The recognizer compares the complete
checked families against the selected protocol. A constructor name
alone confers no EVM meaning. Constructor lookup uses the family table;
constructors are not ordinary global definitions. Reordered or altered
families remain refusals even when their terms pass the core checker.
M0 retains its original Eff protocol.

`caller` captures EVM `CALLER` in a fresh memory word before running
its continuation. It reports the immediate caller, including when a
proxy makes the call. Existing storage loads, arithmetic results and
later caller reads have separate snapshots. A caller-only entry is
`view`; a continuation that writes storage remains `nonpayable`.
Guards and proof-supplied arithmetic use their existing checked paths.

`deployer slot next` writes creation `CALLER` into a declared storage
slot, then executes `next`. Through CREATE, this is the factory address.
Effects execute in source order, so a later literal store can overwrite
the address. Constructors still end with `ret (word 256 0)`, and the
nonpayable creation guard precedes all stores. The emitted init code
returns the same runtime bytes that `runtime.hex` contains.

The effects are available in core `.asy` programs. The contract surface
keeps its existing constructor and invariant rules. This slice adds no
dynamic constructor expressions to that surface. It also adds no
external-call source effect or MPC integration.

## Example and model

[ContextCore.asy](../examples/ContextCore.asy) initializes an owner slot
from the deployer. `who()` returns the caller, `remember()` stores it,
and `bounded(uint256)` uses a checked guard and a custom error. Its
`who()` body also exercises snapshots across storage and caller reads.

```sh
_build/default/bin/assay.exe emit examples/ContextCore.asy -o Context-out
_build/default/bin/assay.exe run examples/ContextCore.asy --calldata 0xd6d21dfd --caller 0x42
python3 -P dev/stage-a-gates.py --m1-context
```

The model command returns the ABI word 66 with empty storage. Caller
addresses use unsigned decimal or `0x` hexadecimal, bounded by uint160.
Invalid addresses, duplicate flags and missing values exit 64. Omitting
the flag preserves the previous zero caller. Model inputs describe an
already deployed contract; preparing a constructor validates it without
applying its stores to the supplied storage image.

The model uses `Model.inputs_with_caller` for explicit context. Existing
clients can continue using `Model.inputs`. No new axiom is introduced;
the emitted dependency remains `EvmOpcodes`.

## Validation contract

The focused gate covers eight optional protocol layouts, four caller
values (zero, one, uint160 maximum and the signed fixture address),
successful calls, reverts, rollback, malformed calldata and nonzero
value. It compares 224 executions against independent expected results
and the source model. Of those, 56 also compare the signed Cancun
transition executor. Both EVM paths use geth, not independent client
implementations.

There are 64 creation outcomes, two nested caller checks and six
deployer-only creation/model cases covering later overwrites and
repeated writes. Seven well-typed invalid sources are refused by both
emission and model preparation. Seven input/default checks cover the
CLI. Six built mutations exercise CALLER versus ORIGIN in runtime and
init code, snapshot allocation, model context, the address bound and
exact schema recognition. Each mutation must fail its named witness and
each restored control must pass.

The integrated compiler also reproduces all five artifacts from the
pushed DAO byte for byte. The validation archive records their hashes.
Two inherited model mutation anchors include the new caller parameter;
their mutations and witnesses otherwise retain their original meaning.

`--m1-context` adds one leg after the 58 existing declarations. Earlier
commands, deadlines and success markers are preserved. The carried
kernel, surface and proof sources, artifact budgets and measurement
inputs are unchanged. Timing remains paused under
[TIMING-DEBUG.md](TIMING-DEBUG.md); this slice makes no new performance
or milestone-exit claim.

All 57 functional legs pass after five rechecks. The two frozen timing
gates remain pending. The
[validation archive](validation/2026-09-17-m1-context/) retains the
initial failures, successful rechecks and source identities.

[dao-port]: https://github.com/MavenRain/assay-self-referential-dao

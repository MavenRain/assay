# M2 mapping storage locations

This slice starts at `9e1cbe5` and adds `Layout.Mapping` in native Bend 2.
It derives storage locations for scalar keys and nested mappings. It does
not yet add mapping declarations or mapping operations to the source compiler.

## API

`Layout.Mapping.Key` contains an `Abi.Schema.Value_type` and a `Big` value.
Supported key types are `uint8`, `uint256`, `address` and `bool`. Their values
must fit 8, 256, 160 and 1 unsigned bits respectively. String keys remain
unsupported in this slice.

`slot(base, key)` returns the unsigned 256-bit storage location:

```text
keccak256(pad32(key.value) || pad32(base))
```

Both words use big-endian encoding. The key comes first; the mapping's
base slot comes second. The base must be an unsigned 256-bit integer.
This follows the scalar-key rule in the
[Solidity storage specification](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html#mappings-and-dynamic-arrays).

`path(base, keys)` applies `slot` from the outermost key to the innermost
key, using each complete digest as the next base. For the frozen ERC-20
reference, a balance is `path(1, [owner])`; an allowance is
`path(2, [owner, spender])`, with address-typed keys. Empty paths are rejected.

Both operations return `Layout.Mapping.Result(Big)`. Errors distinguish
invalid base slots, unsupported key types, out-of-range key values and
empty paths. Invalid values are rejected before encoding. Nested paths
propagate the first failed step without returning a partial location.
The implementation reuses the production ABI word encoder and Keccak-256.


## Command line

The public CLI exposes the production location API:

```text
assay mapping-slot BASE TYPE KEY [TYPE KEY]...
assay mapping-slot 1 address 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf
assay mapping-slot 2 address 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf address 0x2b5ad5c4795c026514f8317c7a215e218dccd6cf
```

Keys are supplied from outermost to innermost. Supported type names are
`uint8`, `uint256`, `address` and `bool`. The base and keys accept unsigned
decimal or `0x` hexadecimal integers; booleans also accept `true` and `false`.
A spelling contains at most 78 decimal digits or 64 hexadecimal digits,
including leading zeroes.
Each key must fit its declared type. The command prints the final slot as
one unsigned decimal integer, suitable for `assay run --storage SLOT=WORD`.
Malformed arguments and out-of-range values exit 64, write a diagnostic to
stderr and leave stdout empty. Source mapping declarations remain pending.

Run `python3 -P dev/mapping-cli-test.py` after `make all`. It covers 244 CLI
cases using 102 cast oracles and all 10 frozen ERC-20 locations, 46 input
refusals, and two controls for the exact command compatibility pins. Each
case is a distinct argument list, and the test fails on a duplicate. The
oracle cases run in decimal and hexadecimal, and cases with a bool key also
run with `true` and `false`. The frozen locations use 40-digit hexadecimal
addresses. Two cases use the widest accepted spellings, and refusals cover
one more digit. Each refusal must give its own diagnostic text.
The default M2 gate schedule now includes this check and retains every
previous check. It had 96 legs at this slice; the default now runs 100.
Compiler speed stays in M4.

## Validation

Run `python3 -P dev/layout-mapping-test.py`. The adapter batches calls to
the production API. Each adapter refusal runs as a separate process. The
gate checks:

- 102 scalar and nested cases against `cast index`, including zero, maximum
  values, high-bit values, large base slots and seeded paths of depths 1 to 4.
- All 10 frozen ERC-20 balance and allowance slots, also checked against cast.
- 23 refusals covering signed and overflowing keys, invalid base slots,
  unsupported string keys, empty paths and invalid inner keys.
- 15 adapter refusals that exit 64 with `ADAPTER-ARITY`, `ADAPTER-USAGE` or
  `ADAPTER-NUMBER` on stderr and print nothing. They cover wrong key counts,
  unknown commands, missing fields and empty or sign-only numbers.
- 12 compiling semantic mutants with named witnesses and a restored control.

The marker reports the adapter refusals as `refusal=` after `negative=`.

The gate rejects duplicate probes. Mutation witnesses cover reversed hash
inputs, missing key or slot padding, widened type bounds, missing range
checks, accepted empty paths, reversed key order, ignored inner keys and a
`slot` adapter that accepts two keys. Only a wrong answer counts as a
mutant kill. Compiler failures, adapter failures and a wrong adapter output
shape fail the gate.

The explicit mode `--m2-mapping` appends `LAYOUT-MAPPING` to the
previous 79 checks, for 80. All 49 previous modes preserve their schedules,
deadlines, markers and failure classifications. The
[validation record](validation/2026-09-25-m2-mapping/README.md) records the
actual full-suite outcome and performance results.

The default now selects `--m2-mapping-source`, adding
[EVENT-CODEC](M2-EVENTS.md), [CALL-CODEC](M2-CALLDATA.md),
[RETURN-CODEC](M2-RETURNDATA.md), [REVERT-CODEC](M2-REVERTDATA.md),
[EVENT-DECODE](M2-EVENT-DECODE.md), [LEXER-KEYWORDS](LEXER-KEYWORDS.md),
[LEXER-DIRECT](LEXER-DIRECT.md), [IDENTIFIER-DIRECT](IDENTIFIER-DIRECT.md),
[WORD-DIRECT](WORD-DIRECT.md), [SEGMENT-DIRECT](SEGMENT-DIRECT.md),
[CLI-PREFIX-DIRECT](CLI-PREFIX-DIRECT.md),
[CLI-VALUE-DIRECT](CLI-VALUE-DIRECT.md),
[CLI-ERROR-DIRECT](CLI-ERROR-DIRECT.md),
[MAPPING-CLI](#command-line),
[EVENT-CLI](M2-EVENTS.md#command-line),
[EVENT-DECODE-CLI](M2-EVENT-DECODE.md#command-line),
[CALLDATA-CLI](M2-CALLDATA-CLI.md), MILESTONE-SPEED,
[PACKED-SOURCE](M2-SOURCE-PACKING.md) and
[MAPPING-SOURCE](M2-MAPPING-SOURCE.md), for 100 checks.
Counts exclude BEND2-RATIO and BEND2-RATIO-TEST, which moved to
[`--m4-speed`](M4-SPEED.md) on 2026-10-01.

Source lowering, mapping declarations and metadata, event execution,
dynamic ABI lowering and the M2 Lean negative mutants remain pending.
This slice does not close M2.

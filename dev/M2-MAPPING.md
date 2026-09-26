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

The default mode is `--m2-mapping`, appending `LAYOUT-MAPPING` to the
previous 81 checks. All 49 previous modes preserve their schedules,
deadlines, markers and failure classifications. The
[validation record](validation/2026-09-25-m2-mapping/README.md) records the
actual full-suite outcome and performance results.

Source lowering, mapping declarations and metadata, event execution,
dynamic ABI lowering and the M2 Lean negative mutants remain pending.
This slice does not close M2.

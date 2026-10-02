# M2 mapping source declarations

`assay mapping-layout FILE` reads a contract's storage declaration and prints
its typed physical layout as JSON. Scalar fields accept `Word`, `Uint256`,
`Uint8`, `Address` and `Bool`. Mapping declarations use prefix types:

```asy
storage State := {
  balances : Mapping Address Uint256 ;
  allowances : Mapping Address (Mapping Address Uint256) ;
  total : Uint256
}
```

Keys accept all five scalar spellings; `Word` normalizes to `uint256`.
Mapping values can be scalar or nested mappings. Each mapping reserves one
complete base slot. A mapping after a partially filled scalar slot starts
in the next slot, and the following scalar starts after the mapping's base.
Scalar neighbors retain the existing packed layout rules. Parentheses may
group types. Along any nesting path, each `Mapping`, each opening
parenthesis and the final value type uses one of 64 levels. Key types do
not use a level.

The output records the contract name and storage fields in declaration order.
Each field includes its name, decimal slot string, byte offset, reserved byte
width, and scalar or recursive mapping type. For
[MappingStorage.asy](../examples/MappingStorage.asy), `enabled` and `owner`
occupy slot 0, `balances` reserves slot 1, `allowances` reserves slot 2,
`total` occupies slot 3, and `count` begins slot 4. Base slots can be passed
to the existing `mapping-slot` command to derive concrete storage locations.

Malformed types and declarations, duplicate field names and excess nesting
fail with status 1 and empty stdout. Sources above 65536 bytes fail with
status 1. After the storage block, the next token must be the end of input
or a declaration keyword: `entry`, `payable`, `error`, `invariant`,
`predicate`, `proof`, `constructor` or `fallback`. A second storage block
or any other text fails with status 1. Invalid command arguments and
unreadable paths fail with status 64. The command inspects storage
declarations. It does not parse the later declarations, and it does not
elaborate entry bodies. `check`, `emit` and `run` continue to refuse
mapping contracts until checked mapping operations and runtime lowering
are implemented. This slice does not discharge M2 mapping source
integration or the ERC-20 acceptance gate.

`python3 -P dev/mapping-source-test.py` checks 13 explicit layout goldens,
26 source refusals and four usage or file refusals. Goldens and refusals
cover both sides of the depth and source size limits. Two compiled mutations
must fail the erc20 golden: reserving one byte for a mapping, and replacing
declared key types with boolean keys. The goldens before erc20 must pass on
each mutant build. The installed binary is checked again after the
mutations. Historical CLI compatibility compares the complete reachable
bundle after restoring the pinned CLI adapters.

`make test` includes this check. `--m2-mapping-source` appends
`MAPPING-SOURCE` to the 99 carried checks, for 100. `make gates` now selects
`--m2-returndata-cli`, which appends the
[return-data CLI check](M2-RETURNDATA-CLI.md), for 101 checks.
The old `--m2-source-packing` schedule remains available unchanged. All
trusted source budgets and the M4 speed gate remain fixed.

# M2 mapping runtime access

Source contracts now support mapping reads and writes through `check`, `emit` and `run`. Scalar and nested mapping keys use the declared schema, and runtime failures revert the transaction. [MappingAccess.asy](../examples/MappingAccess.asy) exercises balances, allowances, three nested keys, narrow values, booleans and packed scalar neighbors.

```text
storage State := {
  balances : Mapping Address Uint256 ;
  allowances : Mapping Address (Mapping Address Uint256)
}
entry allowance (account : Word) (spender : Word) : Eff Sig Word := do
  value <- sload allowances account spender ; pure value
entry approve (account : Word) (spender : Word) (amount : Word) : Eff Sig Word := do
  sstore allowances account spender amount ; pure amount
```

Each mapping level consumes one Word literal or bound local key. Literals retain the existing `(word n)` syntax. Keys and values have runtime guards for their declared uint8, address or boolean bounds. Uint256 accepts the full Word range. Nested locations use repeated `keccak256(pad32(key) . pad32(base))`, in source key order. Narrow writes preserve the unused upper bits, and reads mask them. Boolean reads reject a noncanonical low byte.

## Lowering and storage

The source adapter inserts virtual fields for mapping keys and accesses. Key cells become EVM memory writes, and access cells become computed storage slots. Scratch memory starts at the end of the highest constant memory word that the lowered program reads or writes, outside custom-error revert data. Each access reuses one window: 64 bytes of hash input and one word for each key. The scratch size therefore does not grow with the number of entries or instructions. If the program uses a memory offset that is not a constant, the base falls back to a bound above the whole program. Neither temporary fields nor their values appear in physical storage or `layout.json`.

The model uses separate memory keys for mapping temporaries and retains zero-valued snapshots. Physical writes use the existing packed-field semantics. Reverts restore the transaction's initial storage, including writes that preceded an invalid key, invalid value or arithmetic failure.

Mapping roots reserve complete slots. Scalar neighbors use the packed planner. The emitted layout includes the original labels, physical slots and offsets, plus recursive mapping type metadata. Constructors use the same slot computation and bounds as entries.

User member limits remain at 32. Only compiler-generated names carrying an internal source marker are excluded from the surface member count. The mapping preparation path bounds the lowered Storage schema by its checked cell count. The ordinary M1 preparation path retains its original bounds. The `assayMap` prefix is reserved in mapping source contracts.

## Validation

`python3 -P dev/mapping-runtime-test.py` compares 40 live cases against independently computed cast Keccak locations and expected outcomes. Each case runs under geth `evm run`, Cancun `evm t8n`, and the Assay model. Cases cover overwrite, deletion, maximum values, key bounds, nested order, self-transfer, rollback after partial writes, narrow-field and address-value preservation, Uint256 keys, distinct nested key order, boolean upper bits and canonical booleans. The check also requires 27 source refusals (nine invalid sources, including `deployer` on a mapping root, each refused by check, emit and run with an exact diagnostic), exact constructor storage and returned runtime, and complete physical layout metadata. Controls accept a mapping beside 31 user fields and an entry parameter that reuses a mapping root name. The `balanceOf` and `approve` calls must use at most 1024 bytes of memory.

At this slice the default gate schedule, `--m2-mapping-runtime`, added the mandatory MAPPING-RUNTIME leg to the 101 carried legs, for 102. The default is now `--m2-function-abi`, which adds [FUNCTION-ABI](M2-FUNCTION-ABI.md), for 103 legs. Historical schedules, deadlines and success markers remain intact. The schedule test checks the extension and both default entry points. See [the validation record](validation/2026-10-02-m2-mapping-runtime/README.md) for completed runs and source hashes.

The existing trusted-line audit passes with its fixed module budgets. Mapping source adaptation, model handling and lowering live in `frontend.bend`, alongside the existing packed-source integration. That module has no individual line budget in the current audit; passing that audit does not measure the size of the new integration logic. The M2 audit reconciliation group must review this boundary explicitly.

## Remaining M2 work

Entry parameters and results in this fixture still use the existing Word ABI. Typed function ABI source integration, dynamic types, source events, the complete ERC20 acceptance contract, proof obligations and the final M2-ABI gate remain open. This change discharges the mapping runtime group, subject to the recorded scoped checks. It does not close M2. The remaining groups are listed in [milestone groups](MILESTONE-GROUPS.md).

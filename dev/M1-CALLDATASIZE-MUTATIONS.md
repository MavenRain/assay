# Calldata-size mutation witnesses

Each mutant must compile, fail at the named witness and pass the same
probe after restoring the original source. The validation archive keeps
the source hashes and captured results.

| Mutant | Change | Required witness |
| --- | --- | --- |
| SURFACE | Bind zero instead of reading the calldata length | `PAYABLE-MODEL cds-observe` |
| EMITTER | Emit `CALLVALUE` for the length snapshot | `PAYABLE-EVM cds-observe` |
| MODEL | Count hex digits instead of bytes | `PAYABLE-MODEL cds-observe` |
| SCHEMA | Admit a 160-bit snapshot continuation | `CALLDATASIZE-REFUSAL wrong-width` |
| SNAPSHOT | Reuse the length binding's memory index | `PAYABLE-MODEL cds-mixed` |

The caller and call-value mutation tests retain their existing witnesses.
Their source anchors and exhaustive context matches follow the shared
snapshot table. No mutation count or expected witness is removed.

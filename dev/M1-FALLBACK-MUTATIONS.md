# Fallback mutations

Every mutation is built in a temporary copy, must fail its named
witness, and must pass the same witness after source restoration.

| Mutation | Change | Required witness |
| --- | --- | --- |
| SHORT | Route short calldata to the empty reject block | `FALLBACK-EVM nullary-empty` |
| UNKNOWN | Route unmatched selectors to the empty reject block | `FALLBACK-EVM nullary-unknown` |
| VALUE | Route nonzero call value to the custom fallback | `FALLBACK-EVM nullary-value-unknown` |
| MODEL | Give unmatched selectors an empty source-model revert | `FALLBACK-MODEL nullary-unknown` |
| CLOSED | Accept non-reverting core fallback transactions | `FALLBACK-REFUSAL core-return emit` |
| ABI | Omit the declared fallback from the ABI | `FALLBACK-ABI nullary` |

The routing witnesses compare against independently specified output
bytes and storage, including a storage slot outside the declared schema.
The core refusal witness checks `check`, `emit` and `run`, and requires
that refused emission create no output directory.

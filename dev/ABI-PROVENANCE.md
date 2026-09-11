# M0 ABI and layout goldens

`reference/abi.json` is the manually authored empty entry list for the
hand-assembled `reference/ref20.evm` contract.  The contract has no entry
dispatcher.  This is the M0 golden required by M0-PLAN section 1 and R-Q5a.
It is not solc output.  A real entry variant and its printer belong to M1.

`reference/layout.json` is manually authored from the single slot in the
same reference and the `Storage` declaration in `examples/Ref20.asy`.
It uses the `storage` and `types` field names specified by R-V0 and the
M0 plan.  The declared type has `encoding=inplace`, `label=uint256` and
`numberOfBytes=32`.  Field zero has offset 0 and slot string `0`.
The backend uses field ordinals as `astId`, not Solidity source IDs.
No Solidity layout compatibility for proxies is claimed.

`ABI-GOLD` uses live `jq -S -c` canonical equality for both emitted JSON
files.  A synthetic nonempty ABI row tests key reordering and entry
renaming because the M0 ABI has no keys to reorder.  The control does not
claim an emitted M0 function.  A separate layout fixture tests JSON
escaping and declaration order.  `axioms.txt` must equal the source
disclosure printed by `assay axioms`.

# ERC-20 reference

This is the first M2 slice, built on `8f61dd5`. It provides frozen,
hand-assembled bytecode and golden metadata before the source compiler
targets ERC-20. The runtime is 798 bytes in 431 commented instructions.
The 107-byte constructor creates 1000 units for the deployer and emits
`Transfer(0, deployer, 1000)`. Every entry and the constructor reject value.

| Entry | Result |
| --- | --- |
| `name()` | ABI string `Assay Test` |
| `symbol()` | ABI string `ASY` |
| `decimals()` | uint8 `18` |
| `totalSupply()` | uint256 supply |
| `balanceOf(address)` | uint256 balance |
| `allowance(address,address)` | uint256 allowance |
| `transfer(address,uint256)` | bool `true` and one `Transfer` event |
| `approve(address,uint256)` | bool `true` and one `Approval` event |
| `transferFrom(address,address,uint256)` | bool `true` and one `Transfer` event |

The interface and event declarations follow [ERC-20](https://eips.ethereum.org/EIPS/eip-20).
This reference has fixed supply and no mint, burn or administration entry.
Failed transfers revert with empty data. Zero amounts emit normal events;
self-transfers preserve balances but still require sufficient funds.
Approvals replace the allowance, including replacing it with zero.
`transferFrom` always spends allowance, even when the caller is the owner
or the allowance is the maximum word. It emits no extra Approval event.
Zero transfer sources and recipients are rejected. Approvals and reads
accept the zero address. These choices are fixture policy where ERC-20
does not prescribe a particular behavior.

The runtime rejects short selectors, unknown selectors, truncated heads
and address arguments with nonzero high 96 bits. It ignores trailing
calldata. Return values, dynamic strings and indexed event topics use the
[Solidity ABI encoding](https://docs.soliditylang.org/en/latest/abi-spec.html).
The ABI JSON was authored from that interface; it is not solc output.
`name` and `symbol` return an offset word, a byte length and a padded data
word. Events have a signature topic, two indexed address words and one
unindexed value word.

`layout.json` uses the storage layout field names, with whole-word supply
at slot 0, balances rooted at slot 1 and nested allowances rooted at slot 2.
Mapping keys follow the [documented storage encoding](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html#mappings-and-dynamic-arrays):

```text
balance(owner) = keccak256(pad32(owner) ++ pad32(1))
allowance(owner, spender) =
  keccak256(pad32(spender) ++ keccak256(pad32(owner) ++ pad32(2)))
```

`slots.json` freezes ten keys, including zero and the largest address.
The layout describes this reference only and promises no proxy layout
compatibility. Packing and dynamic input decoding are later M2 work.

Run `python3 -P dev/erc20-test.py` after `zsh -f dev/build.sh build`.
The gate checks the manifest hashes without regenerating fixtures, compares
each instruction with the in-tree listing and two external disassemblers,
and checks selectors, event topics and mapping preimages with both the
in-tree Keccak and `cast`. Each of the 85 explicit cases runs through
geth `evm run` and signed `evm t8n` under Cancun. It checks exact status,
return bytes, all storage and logs. An unrelated nonzero slot is preserved.
The cases cover every runtime instruction, two callers, canonical address
boundaries, allowance ordering, self-transfers, zero and maximum amounts,
overflow, rollback after allowance spending, malformed inputs and value
guards. Four creation probes cover two deployers and value rejection.

`evm run` does not expose receipt logs. Its topics and data are reconstructed
from the reference's traced MSTORE and LOG operands. The t8n receipt supplies
the actual committed logs, including their contract address, order and
transaction identity. The t8n trace is checked as well. Creation uses only
`evm run`, so its mint event has trace evidence rather than receipt evidence.
Both entry points use geth 1.14.12 and are not independent EVM implementations.

Eleven bytecode mutants must fail their specific semantic witness; an EVM
fault or unrelated harness error does not count as a kill. Each witness
then passes with restored bytes. Captures live under `.gatework/erc20/`.
This slice adds no compiler feature, Lean theorem or M2 completion claim.

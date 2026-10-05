# M2 source ERC20

M2 group 6 composes the source mapping, function ABI, result ABI and event
features in [`examples/ERC20.asy`](../examples/ERC20.asy). Its nine standard
entries implement fixed supply, balances, allowances, transfers, approvals,
name, symbol and decimals. The supply is 1000 units, the name is `Assay Test`,
the symbol is `ASY`, and decimals is 18.

## State and transaction rules

Supply occupies slot 0. Balances use an Address mapping rooted at slot 1.
Allowances use a nested Address mapping rooted at slot 2, with owner first
and spender second. The constructor initializes the whole supply to the
reference development account `0x7e5f4552091a69125d5dfcb7b8c2659029395bdf`.
The recipient is fixed in the source, independently of the deployment caller.
This is an executable test fixture, not a configurable token deployment.

Transfers require nonzero source and destination addresses and sufficient
funds. Debit precedes reading the destination, so a self-transfer restores
the original balance while still checking the amount. Zero transfers emit
Transfer normally. Checked addition rejects an overflowing destination.
Any failure restores earlier writes and removes logs.

Approvals replace the old allowance, including replacement with zero.
They accept a zero spender. `transferFrom` spends allowance for every call,
including an owner calling on itself and an allowance equal to the maximum
Word. It emits one Transfer and no Approval. Transfer and Approval have two
indexed addresses and one unindexed Uint256 amount. All entries and the
constructor reject value.

Three differences from the hand-assembled reference are intentional. Source
typed ABI decoding rejects trailing bytes, while the reference ignores them.
Source `transfer` rejects a zero caller, as stated above. The reference
checks only the `transfer` recipient, so a zero-value transfer from caller
0x0 succeeds there and emits Transfer. A signed transaction cannot use that
caller, so only an unsigned call such as `eth_call` reaches this case. The
reference README states the nonzero source policy, but the reference
bytecode does not apply it to the `transfer` caller. The source constructor uses the existing literal-store representation, with
a fixed genesis holder and no initial Transfer log. The reference instead
initializes the deployer and emits that log. Constructor event emission
remains an explicit source refusal.

## Constant string results

An entry returning String can now end in `pure (string 0xHEX)`. The literal
contains zero to 31 bytes, with an even count of hexadecimal digits. An
empty literal is `0x`. Longer literals, nonhexadecimal bytes, decimal
literals and extra arguments are refused by check, emit and run. The bytes
are opaque, matching the existing String codec; this syntax does not add
UTF-8 validation. Dynamic String parameters keep their existing limits.
A parameter named `string` remains valid, including `pure (string)`.

`src/string_literal.bend` packs the literal into a checked Word. Its most
significant byte is 128 plus the byte length, followed by right-padded
data. Canonically validated calldata offsets are below 131072, so their
most significant byte is zero and cannot overlap a literal tag. The emitter
and model select the matching representation and produce the same ABI
offset, length, data and zero padding. The literal path checks the length
and output cap. Existing result and event paths retain calldata decoding.

## Validation

`python3 -P dev/erc20-source-test.py` pins the SHA-256 of the 85 frozen
reference cases. Seventy-six retain their original outcomes. Nine explicitly
named trailing-calldata cases require empty-data reverts and full rollback
under the source decoder. Every case compares the model, geth run, Cancun
t8n, receipt logs and independently reconstructed LOG operands. The expected
storage includes an unrelated sentinel, so accidental neighbor writes fail.

Four creation cases use two callers and both zero and nonzero value. They
check the returned runtime, installed code, exact fixed genesis state,
absence of constructor logs, and failed creation rollback. Five additional
cases cover empty, zero-byte, UTF-8 and 31-byte literals and a dynamic String
parameter named `string`. Fifteen refusals exercise five malformed literals
through all three source commands. One more probe, outside the frozen
corpus, sends a zero-value `transfer` from the zero caller. Signed t8n
transactions cannot use that sender, so the probe uses the model and geth
run only. The model and the emitted runtime must revert with empty data and
no logs. The reference runtime must succeed with one Transfer log.

The suite is included in `make test` and the cumulative
`dev/stage-a-gates.py --m2-source-erc20` mode, for 107 legs. `dev/gates.sh`
now selects `--m2-abi`, which adds [M2-ABI](M2-ABI-GOLDENS.md), for 108
legs.
Existing gate deadlines and success markers are preserved. Focused evidence
is archived under `dev/validation/2026-10-04-m2-source-erc20/`.
The full M2 acceptance battery and the open kernel refinement requirement
remain work for the later milestone groups.

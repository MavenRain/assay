# Differential call values

The thirtieth M1 slice starts at
`97be2654adf0f791ea2418d1f1c4bf7e0b79fd27` and exposes transaction value
through the existing public differential command:

```sh
_build/default/bin/assay.exe diff examples/Fallback.asy --calldata 0x \
  --prestate funded.json --value 1
```

`funded.json` must use the pinned Cancun fixture fields and provide at
least one wei to the fixture sender,
`0x7e5f4552091a69125d5dfcb7b8c2659029395bdf`, in its alloc. The default
fixture has no sender balance, so a nonzero value requires a funded
prestate. This command is offline and makes no network requests.
With [caller selection](M1-DIFF-CALLER.md), the prestate must fund the
selected fixture address. Funding the other fixture does not cover the call.

`--value` defaults to zero. It accepts unsigned decimal or hexadecimal
with a `0x` or `0X` prefix, up to uint256. Hexadecimal digits accept
either letter case. The spelling can contain at most 78 decimal digits
or 64 hexadecimal digits, including leading zeroes. Spaces, separators,
empty digits and values above uint256 are rejected before source
compilation or executor launch, with `DIFF_VALUE` and exit 64. A word
that starts with `-`, such as a signed spelling, is a dash-led option
value, so the option parser refuses it with the usage row and exit 64.
The driver reuses the source model's Word validation and normalizes
hexadecimal case for the Python adapter.

The source path comes first. `--calldata` remains required;
`--prestate` and `--value` are optional. These options may follow the
source in any order and each may appear once. Missing option values,
duplicates, unknown options, dash-led option values, a dash-led source
and positional extras exit 64.

Both `evm run` and the signed Cancun transition receive the same value.
The adapter checks the sender balance before either executor starts.
Insufficient balance produces `DIFF_VALUE` and exit 2, even for a call
that would revert. A matched revert still prints `DIFF OK` and exits
zero. Report fields and the storage, output and status comparison are
unchanged; balances, nonces and logs remain outside that comparison.

M1 contracts reject a nonzero value before entry decoding or fallback
selection. Their revert data is empty and storage stays unchanged.
At zero value, the explicit fallback still supplies its custom error.
M0 closed effect programs retain their existing behavior. Constructors
are not executed by this runtime command.

The focused gate checks 32 calls against the source model and both
geth execution paths, including the uint256 maximum and every option
ordering. It records the actual `evm run` arguments and all 32 signed
transaction requests, so dropped or altered values fail the gate.
Another 31 cases exercise malformed inputs, option refusals and
insufficient funding. Both execution paths use geth.

```sh
python3 -P dev/diff-value-test.py
python3 -P dev/stage-a-gates.py --m1-diff-value
```

The default gate ladder adds DIFF-VALUE after FALLBACK. All 64 prior
gate declarations retain their commands, deadlines and success markers.
This slice changes no kernel, surface language, emitter, ABI, proof
package, trusted bound or frozen timing input. Validation is scoped
to the changed driver and its existing regression gates. The complete
ladder was not rerun; DENOMINATORS and M0-RATIO retain the timing pause.

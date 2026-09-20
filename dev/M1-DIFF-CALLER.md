# Differential callers

The thirty-third M1 slice starts at `63fde3b` and exposes caller selection
through the public offline differential command:

```sh
_build/default/bin/assay.exe diff examples/ContextSurface.asy \
  --calldata 0xd6d21dfd --caller 0x2b5ad5c4795c026514f8317c7a215e218dccd6cf
```

This calls `who()` with the second fixture identity. Both `evm run` and
the signed Cancun transition return its address as a Word.

Unlike `trace`, the differential command must sign a transaction. It
supports exactly two publicly known test signing keys:

| Signing scalar | Caller address |
| --- | --- |
| 1, the default | `0x7e5f4552091a69125d5dfcb7b8c2659029395bdf` |
| 2 | `0x2b5ad5c4795c026514f8317c7a215e218dccd6cf` |

The command has no user-supplied signing key option. These fixtures are
public test data used only for local execution. Neither executor sends
a network transaction. Omitting `--caller` preserves the original identity.

The public driver uses the source model's unsigned uint160 address grammar:
decimal or hexadecimal with a `0x` or `0X` prefix, either hexadecimal case,
at most 78 decimal or 64 hexadecimal digits including leading zeroes.
It canonicalizes the address to 20 bytes and checks fixture membership.
Malformed, out-of-range and unsupported addresses produce `DIFF_CALLER`
and exit 64 before compilation or tool lookup. Zero and the receiver
address are unsupported because neither has a fixture signing key.

The source path comes first and `--calldata` remains required. `--caller`,
`--calldata`, `--prestate` and `--value` may follow it in any order, once
each. Missing or duplicate options, unknown flags, positional extras and
dash-led option values produce the usage row and exit 64.

The pinned Cancun prestate may contain either fixture account and the
receiver. Other accounts, duplicate address aliases and nonempty code
remain refused. The selected sender and receiver are created with zero
balance, nonce and storage if absent. Existing storage in both fixture
accounts is preserved. The signed transaction uses the selected sender's
nonce and requires its balance to cover `--value`. The adapter does not
transfer funding between fixture accounts. Insufficient balance produces
`DIFF_VALUE`; an exhausted selected nonce produces `DIFF_PRESTATE`. Both
fail with exit 2 before either executor runs. A nonce of `2^64 - 2` is
accepted; `2^64 - 1` is exhausted for the selected sender.

The Python adapter accepts `--caller` independently, and its `execute`
and `prepare` functions accept the keyword argument `caller`. They retain
the first fixture as the default and independently refuse unsupported
identities with `DIFF_CALLER`. Direct adapter errors exit 2.

The focused gate checks 45 independently expected source-model and signed
geth comparisons, including both ownership paths, denial rollback, repeated
caller reads, all 24 option orderings, numeric spellings, nonpayable calls,
default prestates, account storage preservation and nonce boundaries. It
records executor arguments and verifies the selected signing key, nonce
and value. Four funding or nonce refusals, 33 early driver refusals and
five direct adapter refusals exercise the input boundary.

```sh
python3 -P dev/diff-caller-test.py
python3 -P dev/stage-a-gates.py --m1-diff-caller
```

The default ladder appends DIFF-CALLER after TRACE-CALLER. All prior mode
selections retain their commands, timeouts, markers and stage membership.
The [validation archive](validation/2026-09-19-m1-diff-caller/) records
the scoped checks and execution witnesses. The full ladder was not rerun.
DENOMINATORS and M0-RATIO retain the existing timing pause; this slice
makes no performance or milestone-exit claim.

# Trace callers

The thirty-second M1 slice starts at `629bf02` and exposes caller
selection through the public offline trace command:

```sh
_build/default/bin/assay.exe trace examples/ContextSurface.asy \
  --calldata 0xd6d21dfd --caller 0x1234
```

This calls `who()` and returns the selected caller as a Word. The
command compiles the source and prints geth's instruction records,
execution summary and state dump. Runtime tracing does not execute
the constructor, so ownership slots come from the selected prestate.

`--caller` defaults to `0x000000000000000000000000000073656e646572`,
preserving previous traces. Its address grammar matches `run --caller`:
unsigned decimal or hexadecimal with a `0x` or `0X` prefix, bounded by
uint160. Hexadecimal digits accept either letter case. Spellings allow
at most 78 decimal digits or 64 hexadecimal digits, including leading
zeroes, and the numeric value must still fit uint160. Decimal `0010`
means ten and `0009` means nine. The driver reuses the source model's
validation, then converts the address to exactly 40 lowercase hex digits
with a `0x` prefix before passing it to geth's `--sender` option.

Malformed addresses, oversized spellings and out-of-range numbers fail
before compilation or executor lookup with `TRACE_CALLER` and exit 64.
The source path comes first; `--calldata` remains required. `--caller`,
`--value`, `--prestate` and `--calldata` may follow it in any order, once
each. Missing values, duplicate or unknown options, dash-led values or
paths, and extra positional arguments produce usage and exit 64. A
negative caller therefore fails option parsing before address validation.

The receiver remains `0x0000000000000000000000007265636569766572`.
The genesis file is passed directly to geth. A nonzero call value
requires enough balance in the selected caller's account, even if a
different account is funded or the contract would revert. Insufficient
funds produce geth's `insufficient balance for transfer` record before
contract instructions run, followed by `TRACE_EXECUTION` and exit 2.
M1 contracts remain nonpayable. An EVM revert or fault prints the
captured trace and exits 2. Trace uses geth's offline runtime execution;
it does not sign a transaction. The differential command separately
supports [two public signing fixtures](M1-DIFF-CALLER.md).

The focused gate passes 45 independently expected source-model and
geth comparisons. These cover the default caller, numeric spellings,
zero and maximum addresses, two caller snapshots, ownership checks,
storage rollback, a caller equal to the receiver, nonpayable execution,
the default prestate and all 24 option orderings. The gate checks the
actual `CALLER` operands and literal executor arguments. Two funding
faults verify caller-specific balance checks, and 31 refusals use a
missing source and empty tool path to pin early validation. Temporary
paths contain spaces and shell punctuation.

```sh
python3 -P dev/trace-caller-test.py
python3 -P dev/stage-a-gates.py --m1-trace-caller
```

The default ladder adds TRACE-CALLER after TRACE-VALUE. All 37 previous
mode selections and their 66 gate declarations retain their commands,
deadlines, markers and stage membership. The kernel, surface, emitter,
source model, proof packages, trusted bounds and frozen timing inputs
are unchanged. Validation is scoped to the driver and its regressions.
DENOMINATORS and M0-RATIO retain the existing timing pause, with no
milestone-exit claim. The [validation archive](validation/2026-09-19-m1-trace-caller/)
records the checks, source identities and execution witnesses.

# Trace call values

The thirty-first M1 slice starts at `913c8c8` and exposes transaction
value through the public offline trace command:

```sh
_build/default/bin/assay.exe trace examples/Fallback.asy --calldata 0x \
  --prestate funded.json --value 1
```

The command compiles the source and prints geth's instruction records,
execution summary and state dump. `--value` defaults to zero. Its Word
grammar matches `run` and `diff`: unsigned decimal or hexadecimal with a
`0x` or `0X` prefix, up to uint256. Hexadecimal digits accept either
letter case. Spellings allow at most 78 decimal digits or 64 hexadecimal
digits, including leading zeroes. Empty digits, spaces, separators and
values above uint256 are refused before compilation or executor launch
with `TRACE_VALUE` and exit 64.

Decimal leading zeroes are removed before invoking geth as pure
canonicalization of the logged argument; geth's numeric parser already
reads a leading-zero decimal string as plain decimal. Thus `0010` means
ten and `0009` means nine. Hexadecimal spellings are lowercased.
Validation reuses the source model's bounded Word parser and keeps its
spelling and range diagnostics.

The source path comes first. `--calldata` remains required; `--prestate`
and `--value` are optional. These options may follow the source in any
order and each may appear once. Missing values, duplicate or unknown
options, dash-led values or source paths, and extra positional arguments
produce usage and exit 64. A signed value such as `-1` therefore fails
option parsing before Word validation.

Trace retains its existing sender,
`0x000000000000000000000000000073656e646572`, and receiver,
`0x0000000000000000000000007265636569766572`. Its genesis file is passed
directly to geth. The funded fixtures in the gate use the trace sender;
the signed differential command uses a different sender. This command
does not run a signed transition or compare two executors.

The default fixture has no sender balance. A nonzero value requires a
prestate that funds the trace sender with at least that amount. Geth
checks the balance before running contract instructions, even when the
contract would revert. Insufficient funds leave storage unchanged and
produce geth's `insufficient balance for transfer` record, followed by
`TRACE_EXECUTION` and exit 2. Genesis storage keys and values must use
geth's hexadecimal byte encoding, such as 64 hex digits per Word.

M1 contracts reject nonzero value before entry decoding or fallback
selection, with empty revert data and unchanged storage. Zero-value
fallbacks retain their custom error payloads. M0 closed effect programs
retain their existing execution behavior. As before, an EVM revert or
fault prints the captured trace, reports `TRACE_EXECUTION`, and exits 2.
Missing executors or fixtures and executor process failures also exit 2.
Constructors are not executed by this runtime command.

The focused gate checks 36 calls against independent expected outcomes
and the source model, including storage writes, nonpayable storage preservation,
fallback selection, uint256 maximum, accepted spelling bounds, decimal
leading zeroes, and all six option orderings. It records the literal
executor arguments and checks the actual `CALLVALUE` operand for
entry-guarded contracts. Another 34 cases reject malformed values and
options before source loading or tool lookup. Two funding faults check the
unfunded default fixture and an insufficient custom sender balance.
Temporary paths contain spaces and
shell punctuation to exercise literal argument handling.

```sh
python3 -P dev/trace-value-test.py
python3 -P dev/stage-a-gates.py --m1-trace-value
```

The default ladder adds TRACE-VALUE after DIFF-VALUE. The 65 previous
gate declarations keep their commands, deadlines and success markers.
The kernel, surface, emitter, source model, ABI, proof package, trusted
bounds and frozen timing inputs are unchanged. Validation is scoped to
the trace driver and its regression gates. DENOMINATORS and M0-RATIO
remain under the timing pause, with no new milestone-exit claim.
The [validation archive](validation/2026-09-18-m1-trace-value/) records
the scoped checks, source identities and execution witnesses.

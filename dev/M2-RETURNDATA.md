# M2 typed function return data

This slice starts at `5e00ee7` and adds `Abi.Return` in native Bend 2.
It applies the strict tuple codec to a function's declared output types.

## API

- `Abi.Return.encode(fn, values)` returns `Abi.Return.Result(String)`.
- `Abi.Return.decode(fn, bytes)` returns
  `Abi.Return.Result(ListOf(Abi.Codec.Value))`.

The declaration is an `Abi.Schema.Function_`. Supported output types are
`uint8`, `uint256`, `address`, `bool` and `string`, in declaration order.
The function name, input parameters, output names and mutability do not
affect the payload. Use the matching function declaration and bytes from
a successful call. This codec does not determine the call's status.

Return data is a tuple with no selector. Dynamic offsets start at byte
zero of that tuple. Zero outputs encode as an empty byte string, and
decoding zero outputs accepts only empty data. This follows the
[Solidity ABI encoding rules](https://docs.soliditylang.org/en/latest/abi-spec.html#argument-encoding).
For example, a `bool` result of `true` occupies one 32-byte word whose
value is one.

Strings use the existing codec's byte-string convention. Zero and high
bytes are preserved. Callers supply encoded bytes, including UTF-8 bytes
for Unicode text.

Encoding checks schema/value pairs in declaration order. The first type
mismatch or missing/extra value reached returns `Type_mismatch` or
`Arity`. Once this traversal succeeds, the tuple codec checks scalar
bounds and encodes the values. Tuple codec errors from either operation
are wrapped in `Abi.Return.Error.Codec`; failures return no partial result.

Decoding requires canonical bytes: exact scalar ranges, bool words zero
or one, minimal consecutive dynamic offsets, zero padding and no trailing
data. It inherits the tuple codec's stricter policy for suffixes and
nonminimal offsets than Solidity runtime decoding.

This is a host codec. Source compiler integration, typed source arguments
and results, dynamic EVM ABI lowering, packed source declarations,
mappings, events and M2 Lean mutants remain pending. M2 is not closed.

## Validation

Run `python3 -P dev/return-codec-test.py`. It checks:

- 57 oracle payloads from `cast abi-encode`, including scalar boundaries,
  string word boundaries, mixed tuples and 32 seeded cases. Binary string
  cases use the equivalent `bytes` encoding in the oracle.
- All 45 successful results from the frozen ERC-20 reference, covering
  all nine functions and cross-checked with `cast`.
- Encoding and decoding with changed function names, input parameters,
  output names and mutability for every oracle and reference case.
- 75 production errors, all 288 truncated prefixes of a mixed result,
  and 13 adapter refusals. Refusals exit 64 with no stdout.
- Ten compiling mutants killed by named wrong-answer witnesses, then a
  rebuilt scratch control. Compilation, tool and malformed-output
  failures do not count as kills.

`python3 -P dev/return-compatibility.py` preserves all 52 historical gate
modes, including commands, deadlines, expected markers and failure
classes. The existing ABI and test sources remain byte-identical
prefixes, and the compiler CLI's reachable Bend bundle is byte-identical.
Since the keyword-dispatch follow-up, the check accepts one pinned
`Lexer.ident_kind` delta and puts back the BASE declaration before the
compare; see [LEXER-KEYWORDS](LEXER-KEYWORDS.md).
The `--m2-returndata` mode appends RETURN-CODEC, for 85 checks. The current
default adds [REVERT-CODEC](M2-REVERTDATA.md),
[EVENT-DECODE](M2-EVENT-DECODE.md), [LEXER-KEYWORDS](LEXER-KEYWORDS.md),
[LEXER-DIRECT](LEXER-DIRECT.md), [IDENTIFIER-DIRECT](IDENTIFIER-DIRECT.md),
[WORD-DIRECT](WORD-DIRECT.md), [SEGMENT-DIRECT](SEGMENT-DIRECT.md),
[CLI-PREFIX-DIRECT](CLI-PREFIX-DIRECT.md), and
[CLI-VALUE-DIRECT](CLI-VALUE-DIRECT.md),
[CLI-ERROR-DIRECT](CLI-ERROR-DIRECT.md), for 95 checks.

The [validation record](validation/2026-09-27-m2-returndata/README.md)
retains the scoped results, command captures, case corpus and source
hashes. The complete 85-leg default battery was not run for this slice.

## Performance

Changes to `Makefile`, `dev/build.py` and `src/abi.bend` require refreshed
compiler source pins. The return-data slice froze a fresh five-round
paired measurement, retained as
`dev/validation/2026-09-27-m2-returndata/paired-measurement.json`.
It measured a 7.581-second window and a ratio of 1.667820196, above the
unchanged 1.0 bound. BEND2-RATIO remained failing, and BEND2-RATIO-TEST
passed with the new pins. Later refreshes superseded this report;
see [LEXER-KEYWORDS.md](LEXER-KEYWORDS.md) for the active baseline.
The corpus measurement is unchanged. The CLI bundle comparison shows
no executable compiler change, so the separate timing runs do not
establish a return-data-related performance change.

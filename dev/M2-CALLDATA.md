# M2 typed function calldata

This slice starts at `0cf7d20` and adds `Abi.Call` in native Bend 2.
It combines the typed function schema, Keccak selector and strict tuple
codec into complete function call payloads.

## API

- `Abi.Call.selector(fn)` returns the four selector bytes.
- `Abi.Call.encode(fn, values)` returns `Abi.Call.Result(String)`.
- `Abi.Call.decode(fn, bytes)` returns
  `Abi.Call.Result(ListOf(Abi.Codec.Value))`.

The function is an `Abi.Schema.Function_`. Supported input types are
`uint8`, `uint256`, `address`, `bool` and `string`. Input parameter
names, outputs and mutability do not affect the selector. Declaration
names have the schema layer's existing validation policy.

The selector is the first four bytes of Keccak-256 of the canonical
function signature. The argument tuple begins immediately afterward,
and dynamic offsets are relative to that tuple. This follows the
[Solidity function ABI](https://docs.soliditylang.org/en/latest/abi-spec.html#function-selector).
For example, `transfer(address,uint256)` begins with `a9059cbb`,
followed by two 32-byte words.

Strings and payloads use the existing codec's byte-string convention.
Arbitrary string bytes are preserved, including zero and high bytes.
Callers supply encoded bytes, including UTF-8 bytes for Unicode text.

Encoding checks schema/value pairs in declaration order. The first type
mismatch or missing/extra argument reached returns `Type_mismatch` or
`Arity`. After that traversal succeeds, the tuple codec validates scalar
bounds and encodes all values. Decoding first rejects fewer than four
bytes as `Short_selector`, then a selector mismatch as `Wrong_selector`,
then applies the tuple decoder. Underlying errors are wrapped in
`Abi.Call.Error.Codec`. Errors return no partial result.

Decoding requires canonical argument bytes: exact scalar ranges, bool
words zero or one, minimal consecutive dynamic offsets, zero padding and
no trailing data. This inherits the tuple codec's stricter policy for
suffixes and nonminimal offsets than Solidity runtime decoding.

This is a host codec for one supplied function declaration. Compiler
integration, typed source arguments, dynamic EVM ABI lowering, packed
source declarations, mappings, events and M2 Lean mutants remain pending.
It does not change the existing compiler's dispatch behavior or close M2.

## Validation

Run `python3 -P dev/call-codec-test.py`. It checks:

- 57 oracle payloads from `cast calldata`, or a `cast` selector plus the
  equivalent `bytes` encoding for binary strings. These include scalar
  boundaries, string word boundaries, mixed tuples and 32 seeded cases.
- 44 distinct canonical call payloads from the frozen ERC-20 reference.
  Every oracle and reference case is encoded, decoded and encoded again
  with different parameter names, output types and mutability.
- 60 production errors, all 292 truncated prefixes of a mixed call, and
  13 adapter refusals. Refusals exit 64 with no stdout.
- Ten compiling mutants killed by named wrong-answer witnesses, followed
  by a rebuilt scratch control. Compilation, tool and malformed-output
  failures do not count as kills.

`python3 -P dev/call-compatibility.py` preserves all 51 historical gate
modes, including deadlines, expected markers and failure classes. The
original ABI and test sources remain byte-identical prefixes, and the
compiler CLI's reachable Bend bundle is byte-identical. Since the
keyword-dispatch follow-up, the check accepts one pinned
`Lexer.ident_kind` delta and puts back the BASE declaration before the
compare; see [LEXER-KEYWORDS](LEXER-KEYWORDS.md). The `--m2-calldata`
mode appends CALL-CODEC, for a total of 82 checks. The current default adds
[RETURN-CODEC](M2-RETURNDATA.md), [REVERT-CODEC](M2-REVERTDATA.md),
[EVENT-DECODE](M2-EVENT-DECODE.md), [LEXER-KEYWORDS](LEXER-KEYWORDS.md),
[LEXER-DIRECT](LEXER-DIRECT.md), [IDENTIFIER-DIRECT](IDENTIFIER-DIRECT.md),
[WORD-DIRECT](WORD-DIRECT.md), [SEGMENT-DIRECT](SEGMENT-DIRECT.md),
[CLI-PREFIX-DIRECT](CLI-PREFIX-DIRECT.md),
[CLI-VALUE-DIRECT](CLI-VALUE-DIRECT.md),
[CLI-ERROR-DIRECT](CLI-ERROR-DIRECT.md),
[MAPPING-CLI](M2-MAPPING.md#command-line),
[EVENT-CLI](M2-EVENTS.md#command-line),
[EVENT-DECODE-CLI](M2-EVENT-DECODE.md#command-line),
[CALLDATA-CLI](M2-CALLDATA-CLI.md), MILESTONE-SPEED,
[PACKED-SOURCE](M2-SOURCE-PACKING.md) and
[MAPPING-SOURCE](M2-MAPPING-SOURCE.md), for 100 checks.
Counts exclude BEND2-RATIO and BEND2-RATIO-TEST, which moved to
[`--m4-speed`](M4-SPEED.md) on 2026-10-01.

The [validation record](validation/2026-09-27-m2-calldata/README.md) retains
the scoped results, failed development attempts and source hashes.

## Command line

`calldata-encode NAME [TYPE VALUE]...` and
`calldata-decode NAME HEX [TYPE]...` expose the codec as compact JSON.
[The CLI contract](M2-CALLDATA-CLI.md) describes types, value
representations, size limits and refusals. The `CALLDATA-CLI` check runs
with `make test` and the default gate schedule.

## Performance

Changes to `Makefile`, `dev/build.py` and `src/abi.bend` require new
compiler source pins. The calldata slice froze a fresh five-round paired
measurement, retained as
`dev/validation/2026-09-27-m2-calldata/paired-measurement.json`.
It measured a 7.642-second window and a ratio of 1.720827821, above the
unchanged 1.0 bound. BEND2-RATIO therefore remained failing.
BEND2-RATIO-TEST passed with the new pins. Later refreshes superseded
this report; see [LEXER-KEYWORDS.md](LEXER-KEYWORDS.md) for the active
baseline. The corpus measurement is unchanged. The CLI bundle comparison
shows no executable compiler change, so these separate timing runs do
not establish a calldata-related performance change.

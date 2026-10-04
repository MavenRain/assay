# M2 typed event log decoding

This slice starts at `aa7517e` and adds strict decoding to `Abi.Event`
in native Bend 2. Source event declarations and emission lowering remain
pending. M2 is not closed.

## Command line

`assay event-decode NAME [--anonymous] --topics HEX[,HEX]... --data HEX [TYPE indexed|data]...`
decodes one event log as compact JSON. Supply the name, optional anonymous
flag, comma-separated topics, data and schema fields in that order. Use
an empty topics argument (`--topics ''`) for an anonymous event with no
indexed fields. Supported field types are `uint8`, `uint256`, `address`,
`bool` and `string`. The name follows the encoder's ASCII identifier rule.
Hexadecimal input accepts an optional `0x` or `0X` prefix, either digit
case, and empty byte strings. Whitespace, non-hexadecimal characters and
odd digit counts are rejected. Each topic and the data accept at most
131072 bytes. Larger input exits 64.

```sh
assay event-decode Empty --anonymous --topics '' --data 0x
assay event-decode Flag --anonymous --topics '' --data 0x0000000000000000000000000000000000000000000000000000000000000001 bool data
```

The result has a `values` array in schema order. Each entry has a `type`:
unsigned integers use a decimal string in `value`, addresses use a
lowercase 20-byte `0x` string in `value`, and booleans use a JSON boolean
in `value`. Non-indexed strings use a `bytes` field with lowercase `0x`
hexadecimal bytes. The field keeps arbitrary ABI byte strings. Indexed
strings use a `hash` field with the recorded 32-byte topic. The decoder
accepts hashes with an unknown preimage.

For example, the commands above print `{"values":[]}` and
`{"values":[{"type":"bool","value":true}]}`. Malformed arguments or
logs exit 64, emit an `assay: event-decode:` diagnostic on stderr, and
leave stdout empty. After argument parsing, the decoder applies the API's
strict topic, signature and tuple checks below.

`dev/event-decode-cli-test.py` checks cast-generated logs, scalar
boundaries, anonymous events, opaque string hashes, arbitrary string
bytes, hexadecimal spellings, the input size limit and malformed logs.
`make test` and the M2 source-packing gate schedule include this check.
It compares the carried CLI bundle against `7bca8dc` after restoring the
explicitly pinned usage and dispatch bodies. Existing encoder and mapping
CLI tests retain their own historical comparisons and pin controls.

## API

`Abi.Event.decode(name, inputs, anonymous, log)` takes the same event
schema as `Abi.Event.encode` and an `Abi.Event.Log`. It returns
`Abi.Event.Decode_result(ListOf(Abi.Event.Decoded))`, in declaration order.

`Abi.Event.Decoded.Value` contains an `Abi.Codec.Value` for scalar indexed
parameters and all non-indexed parameters. `Abi.Event.Decoded.Hash`
contains exactly the 32 bytes recorded for an indexed string. Its original
value cannot be recovered from the log. Arbitrary hash bytes are accepted;
the decoder does not claim knowledge of their preimage.

Supported types are `uint8`, `uint256`, `address`, `bool` and `string`.
Non-indexed strings preserve the tuple codec's byte-string convention.
Non-anonymous events require the full canonical signature hash in topic
zero. Anonymous events omit that topic and permit four indexed arguments;
named events permit three. Parameter names do not enter the signature.

## Strict errors

The decoder rejects malformed input without returning partial values.
Checks occur in this order:

1. Schema topic limit (`Too_many_topics`).
2. Exact log topic count (`Topic_count`).
3. Every topic has exactly 32 bytes (`Topic_size`).
4. Named event signature matches (`Wrong_signature`).
5. Non-indexed data passes the strict ABI tuple decoder (`Codec(error)`).
6. Indexed scalar words pass the same codec, in declaration order.

This rejects noncanonical booleans, scalar overflows, bad dynamic offsets,
padding, truncation and trailing data. A log without data parameters must
have empty data. Indexed strings remain explicitly tagged hashes.

Schema matching does not authenticate the log's contract address or prove
that a transaction succeeded. Callers retain responsibility for choosing
the schema and identifying the emitting contract.

## Validation and remaining limits

`python3 -P dev/event-decode-test.py` checks 71 independent cast event
vectors, 21 frozen ERC-20 logs, 59 malformed-log cases and eight adapter
refusals. Twelve compiling semantic mutants must produce named wrong
answers; build failures and malformed adapter output do not count as
kills. The restored scratch build must pass every vector and adapter
refusal. Its marker is:

```
EVENT-DECODE oracle=71 reference=21 negative=59 refusal=8 mutants=12 scope=event-decode OK
```

The malformed cases test the check order. `limit-before-count` and
`anonymous-limit-before-count` exceed the schema topic limit and also
carry the wrong topic count, so they must return `Too_many_topics`.
`named-scalar-trailing` and `named-uint8-range-1` carry the correct
signature hash, so their data and indexed codec errors must not become
`Wrong_signature`. The `limit-count-swap` mutant checks the topic count
before the topic limit, and `limit-before-count` kills it. The
`field-error-as-signature` mutant keeps the check order but reports each
field decode failure as `Wrong_signature`, and `named-scalar-trailing`
kills it.

`python3 -P dev/event-decode-compatibility.py` preserves all 54 previous
gate modes, including their deadlines, markers and failure classes. It
also checks byte-identical existing ABI and test source prefixes and an
unchanged reachable compiler CLI bundle. Since the keyword-dispatch
follow-up, the check accepts one pinned `Lexer.ident_kind` delta and puts
back the BASE declaration before the compare; see
[LEXER-KEYWORDS](LEXER-KEYWORDS.md). `--m2-event-decode` adds
EVENT-DECODE, for 85 checks. The
`--m2-returndata-cli` mode runs 101; see
[M2-RETURNDATA-CLI](M2-RETURNDATA-CLI.md).
`--m2-mapping-runtime` adds [MAPPING-RUNTIME](M2-MAPPING-RUNTIME.md), for 102
legs. `--m2-function-abi` adds [FUNCTION-ABI](M2-FUNCTION-ABI.md), for 103
legs. `--m2-return-abi` adds [RETURN-ABI](M2-RETURN-ABI.md), for 104 legs.
`--m2-source-events` adds
[SOURCE-EVENTS](M2-SOURCE-EVENTS.md), for 105 legs. The current default,
`--m2-storage-proofs`, adds [STORAGE-PROOFS](M2-STORAGE-PROOFS.md), for
106 legs. Counts exclude BEND2-RATIO and BEND2-RATIO-TEST, which moved to
[`--m4-speed`](M4-SPEED.md) on 2026-10-01.

The new implementation brings `src/abi.bend` to 495 lines, above the
earlier 400-line ABI limit. On 2026-09-28 the user re-ratified the source
budget in `dev/trusted-lines.py`: abi rises to 495 and assembler falls
from 600 to 505. The ratified total stays 3550. TRUSTED-LINES passes
under this budget with `abi=495/495`, `assembler=262/505` and
`total=2951/3550`. No implementation moved outside the priced modules.
See the [validation record](validation/2026-09-28-m2-event-decode/README.md)
for the measurements and exact check results of this slice.

## Performance

Changes to `Makefile`, `dev/build.py` and `src/abi.bend` require refreshed
compiler source pins. The event-decode slice froze a fresh five-round
paired measurement, retained as
`dev/validation/2026-09-28-m2-event-decode/paired-measurement.json`.
It measured a 48.113-second window and a ratio of 1.137273126, above the
unchanged 1.0 bound. BEND2-RATIO remained failing, and BEND2-RATIO-TEST
passed with the new pins. The keyword-dispatch refresh superseded this
report; see [LEXER-KEYWORDS.md](LEXER-KEYWORDS.md) for the active
baseline. The corpus measurement is unchanged. The CLI bundle comparison
shows no executable compiler change,
so the separate timing runs do not establish a decoder-related
performance change.

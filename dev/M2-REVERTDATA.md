# M2 typed revert data

This slice extends the staged return-data slice on `5e00ee7` with
`Abi.Revert` in native Bend 2. It encodes and strictly decodes the
`Abi.Schema.Declaration.Error` variant.

## API

- `Abi.Revert.encode(declaration, values)` returns
  `Abi.Revert.Result(String)`.
- `Abi.Revert.decode(declaration, bytes)` returns
  `Abi.Revert.Result(ListOf(Abi.Codec.Value))`.

The supported parameter types are `uint8`, `uint256`, `address`, `bool`
and `string`, in declaration order. Parameter names do not affect the
payload. The error name and parameter types determine its selector.

Custom errors use the same selector and argument encoding as function
calls, so this API reuses `Abi.Call` and the strict tuple codec. The first
four bytes are the selector. Dynamic offsets start immediately after
that selector. A nullary error encodes to exactly four bytes.
See the [Solidity ABI error specification](https://docs.soliditylang.org/en/latest/abi-spec.html#errors).

Standard `Error(string)` and `Panic(uint256)` declarations work through
the same API, with selectors `08c379a0` and `4e487b71`. Strings preserve
the tuple codec's byte-string convention, including zero and high bytes.
Callers supply the UTF-8 bytes for Unicode text.

## Errors and scope

`Not_error` rejects constructor, function, event and fallback declarations.
`Call(error)` preserves the typed `Abi.Call.Error`: `Arity` and
`Type_mismatch` report value/schema disagreement. `Short_selector`
rejects fewer than four bytes, including empty reverts. `Wrong_selector`
rejects a different error signature. Its `Codec(error)` variant preserves
the tuple codec's range, length, offset, padding and trailing-data errors.
No malformed payload is normalized or repaired.

Decoding checks the supplied schema and bytes. It does not determine
whether a call reverted or authenticate the origin of its data.
Compiler lowering for typed error arguments, packed storage, mappings,
events and dynamic ABI types remains pending, as do the M2 Lean mutants.
M2 is not closed.

## Validation

`python3 -P dev/revert-codec-test.py` checks 60 cast oracle vectors,
40 frozen ERC-20 empty reverts, 90 production errors, 292 truncated
prefixes and 16 adapter refusals. Every positive vector checks encoding,
decoding and parameter-name independence. The reference has no
typed error declarations, so its empty revert payloads test selector
rejection. All 12 compiling mutants are killed by named wrong answers,
and the restored scratch build passes the complete case set.

`python3 -P dev/revert-compatibility.py` preserves the 52 committed gate
modes and the staged return-data extension, including commands, deadlines,
markers and failure classes. It also checks byte-identical prior source
prefixes and compiler CLI reachability. Since the keyword-dispatch
follow-up, the check accepts one pinned `Lexer.ident_kind` delta and puts
back the BASE declaration before the compare; see
[LEXER-KEYWORDS](LEXER-KEYWORDS.md). `--m2-revertdata` appends
REVERT-CODEC for 86 checks; `--m2-returndata` retains its 85 checks. The
current default [LEXER-KEYWORDS](LEXER-KEYWORDS.md) runs 88.

The [validation record](validation/2026-09-27-m2-revertdata/README.md)
records commands, complete captures, source hashes and timing results.

## Performance

Changes to `Makefile`, `dev/build.py` and `src/abi.bend` require refreshed
compiler source pins. The revert-data slice froze a fresh five-round
paired measurement, retained as
`dev/validation/2026-09-27-m2-revertdata/paired-measurement.json`.
It measured a 13.432-second window and a ratio of 1.657532429, above the
unchanged 1.0 bound. BEND2-RATIO remained failing, and BEND2-RATIO-TEST
passed with the new pins. Later refreshes superseded this report;
see [LEXER-KEYWORDS.md](LEXER-KEYWORDS.md) for the active baseline.
The corpus measurement is unchanged. The CLI bundle comparison shows no executable compiler change,
so the separate timing runs do not establish a revert-data-related
performance change.

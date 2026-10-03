# M2 public function calldata

`assay calldata-encode NAME [TYPE VALUE]...` prints a compact JSON object
with a lowercase, `0x`-prefixed `calldata` field. The payload contains the
Keccak function selector followed by the canonical ABI argument tuple.

`assay calldata-decode NAME HEX [TYPE]...` checks the selector and strictly
decodes the argument tuple. Both commands accept the types `uint8`,
`uint256`, `address`, `bool` and `string`. The function name must be an
ASCII identifier. The types and values follow declaration order. Omitting
the types selects a function with no arguments.

For example:

```sh
_build/bin/assay calldata-encode transfer address 1 uint256 100
_build/bin/assay calldata-encode message string 'hello' bool true
_build/bin/assay calldata-decode totalSupply 0x18160ddd
```

The last command prints `{"values":[]}`. Decoded values use the same JSON
representation as `event-decode`: integers have decimal string `value`
fields, addresses have lowercase 20-byte hexadecimal `value` fields,
booleans have JSON boolean `value` fields, and strings have hexadecimal
`bytes` fields. The string representation preserves arbitrary ABI bytes,
including NUL and non-UTF-8 data. Encoding strings uses the UTF-8 bytes
of the argument. Arguments must be valid UTF-8. The Node.js host
replaces each invalid sequence with U+FFFD (bytes EF BF BD) before
encoding, and the command does not detect this.

Numeric arguments accept unsigned decimal words and `0x` or `0X`-prefixed
hexadecimal words. A spelling contains at most 78 decimal digits or 64
hexadecimal digits, including leading zeroes. Booleans accept exactly
`true` or `false`. The codec checks the declared integer and address
ranges. Encoded calldata is limited to 131072 bytes, including the
selector.

Hexadecimal calldata accepts an optional `0x` or `0X` prefix and either
digit case. Whitespace, non-hexadecimal characters and odd digit counts
are rejected. Input is limited to 131072 bytes, including the selector.

Malformed arguments, oversized calldata, wrong selectors, truncated
tuples, invalid booleans, noncanonical dynamic offsets, nonzero padding
and trailing bytes exit 64, print a command-specific diagnostic on
stderr, and leave stdout empty.

`dev/calldata-cli-test.py` checks 53 encodings and 54 decodings using
independent `cast` selector and tuple calculations, plus one decoding of
hand-built arbitrary string bytes. One encoding is the largest string
calldata within the cap. It checks 196 refusals. These include inputs
just above each 131072-byte cap and a decoding input of exactly 131072
bytes, which passes the cap and fails on trailing data. It also checks
historical CLI compatibility and two altered dispatch/help pin controls.
`make test` includes `CALLDATA-CLI`. The default `--m2-mapping-runtime`
gate schedule (102 checks) includes it, and so does the earlier
101-leg `--m2-returndata-cli` mode.
The validation record is
`dev/validation/2026-10-01-m2-calldata-cli/`.

The commands use the existing `Abi.Call` codec. Source compiler lowering
for typed function arguments remains pending.

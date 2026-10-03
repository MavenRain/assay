# M2 function return-data commands

The public CLI exposes the existing typed result codec:

```sh
assay returndata-encode [TYPE VALUE]...
assay returndata-decode HEX [TYPE]...
```

Types are `uint8`, `uint256`, `address`, `bool` and `string`. Integer and
address values accept unsigned decimal words and `0x` or `0X`-prefixed
hexadecimal words. A spelling contains at most 78 decimal digits or 64
hexadecimal digits, including leading zeroes. A hexadecimal address needs
the prefix, because the command reads an unprefixed spelling as decimal.
Booleans accept `true` and `false`. Encoding strings uses the UTF-8 bytes of
the argument. Arguments must be valid UTF-8. The Node.js host replaces each
invalid sequence with U+FFFD (bytes EF BF BD) before encoding, and the
command does not detect this. The encoder prints one JSON object with a
`returndata` field containing lowercase, `0x`-prefixed hex.
The empty output tuple encodes to `{"returndata":"0x"}`. Function results
have no selector, so the commands do not require a function name.

The decoder accepts hex with or without a prefix and either hex case. It
prints `{"values":[...]}`. Numeric values are decimal strings, addresses are
40-digit hexadecimal strings and booleans are JSON booleans. String results
use a `bytes` field containing hex, preserving arbitrary bytes without UTF-8
conversion. `assay returndata-decode 0x` prints `{"values":[]}`.

The codec rejects values outside their declared ranges, malformed hex,
truncated words or tails, invalid boolean words, noncanonical offsets,
overlapping or reordered dynamic tails, nonzero padding and trailing data.
Encoding and decoding each allow at most 131072 bytes. Unlike calldata, that
limit has no four-byte selector overhead. Invalid arguments and codec errors
fail with status 64, a command-specific diagnostic and empty standard output.

`python3 -P dev/returndata-cli-test.py` compares 54 encodings and 55 decodings
with independent `cast` tuple encodings and explicit byte goldens. It checks
176 refusals, both sides of the size limit, arbitrary decoded string bytes,
empty returns and the complete historical CLI bundle after restoring the
pinned dispatch and usage declarations. Two pin mutations must be refused.

`make test` includes the check. At this slice the default gate schedule,
`--m2-returndata-cli`, appended `RETURNDATA-CLI` to all 100 mapping-source
checks. `--m2-mapping-runtime` appends
[MAPPING-RUNTIME](M2-MAPPING-RUNTIME.md), for 102 checks. The default is now
`--m2-function-abi`, which appends [FUNCTION-ABI](M2-FUNCTION-ABI.md), for 103
checks. Earlier schedules and the two M4 speed legs retain their commands,
deadlines and required success markers. This CLI slice adds no trusted source
or kernel axiom. Source mapping access and event emission remain pending.

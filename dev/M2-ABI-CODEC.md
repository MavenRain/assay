# M2 typed ABI values

The third M2 slice starts at `1c6968f`. `Assay_abi.Abi.Codec` encodes and
decodes raw ABI tuples of `uint8`, `uint256`, `address`, `bool` and `string`.
The tuple contains no selector. The same encoding serves function arguments,
return values and unindexed event data. Strings use byte lengths and a
32-byte offset, length and padded payload, following the
[Solidity ABI encoding specification](https://docs.soliditylang.org/en/latest/abi-spec.html#formal-specification-of-the-encoding).

`encode` accepts a list of typed values and returns `(string, error) result`.
`decode` accepts the schema's type list and raw bytes, and returns
`(value list, error) result`. Values preserve arbitrary string bytes; this
layer does not validate UTF-8. Uint8 values must fit eight unsigned bits,
addresses 160 bits and Uint256 values 256 bits. Encoding rejects negative
or oversized integers. All codec helpers are hidden by a module signature.

Decoding requires the exact canonical tuple: string tails follow declaration
order with minimal offsets, no gaps or aliases, zero right padding and no
trailing data. Bool words must be zero or one. Narrow integer and address
words must have zero high bits. Lengths and offsets are checked as arbitrary
precision integers before converting lengths to host integers or taking
slices. Invalid input returns a typed error. This strict decoder intentionally
rejects extra calldata suffixes and nonminimal offsets that a Solidity
runtime decoder may accept.

This is a host codec for the schema. Source typing, generated EVM ABI handling,
mapping lowering, event execution, packing, other ABI types and the M2 Lean
negative mutants remain pending. The existing Word source language and its
runtime dispatch policy are unchanged. This slice does not close M2-ABI.

## Validation

`python3 -P dev/abi-codec-test.py` checks 48 encodings against `cast abi-encode`,
plus a raw binary string vector, and decodes all 49 vectors to their original
typed values. Cases cover scalar bounds, zero, empty tuples and strings,
UTF-8 byte lengths, 31/32/33 and 63/64/65 byte payloads, mixed static and dynamic
fields, several string tails and deterministic generated tuples. Five frozen
ERC-20 return values agree in both directions.

There are 26 explicit invalid encodings or values, all 288 truncated prefixes
of a mixed tuple, and 128 perturbed input probes derived from valid encodings.
Every accepted probe must encode back to identical bytes, and at least 32 must
be accepted. Ten compiling semantic mutants exercise encode/decode widths,
boolean values, offsets, padding, suffixes, lengths and byte order. Each must
fail at its named witness; compilation or process failure never counts as a
mutation kill. Mutants build in a scratch copy; a control run on the
unmodified root build follows.

The default `zsh -f dev/gates.sh` selects `--m2-abi-codec`, appending one leg to
the unchanged 77-leg schema schedule. The new leg has a 300-second deadline:

```text
ABI-CODEC cast=48 vectors=49 reference=5 negative=26 prefixes=288 fuzz=128 mutants=10 scope=codec OK
```

The ABI module remains within its existing 400-line limit. Fresh compiler
measurements retain the unchanged workloads, measurement methods and 1.0
performance bound. The Assay/Bend 2 ratio is 0.073514764. The record in
[`validation/2026-09-22-m2-abi-codec`](validation/2026-09-22-m2-abi-codec/README.md)
contains the validation logs, source identities and measurement reports.

### Review round 2026-09-22 (M2 typed ABI values: the Abi.Codec host codec)

A-1 medium dev/abi-codec-test.py:136: the 128-probe re-encode identity now draws typed values.
D-1 medium REC/README.md:6: the record discloses the two-run shape, not a clean corrected run.
C-1 medium dev/M1-CLOSE.md:5: the published ratio moved from 0.070826341 to 0.073514764.
B-1 low dev/DENOMINATORS.sha256:72: the two retained measurement copies are pinned, 152 to 154 rows.
D-2 low REC/archive.py:102: kept as a residual, the record transcripts keep their typed literals.
A-2 low dev/M2-ABI-CODEC.md:45: mutants build in a scratch copy, no ROOT source is restored.
C-2 low dev/M2-ABI-SCHEMA.md:56: row 56 states the current ratio 0.073514764.
Refuted: none.
Residuals: D-2 typed literals in the record scripts; R-1 REC/DENOMINATORS.sha256 stays 152 rows.
Final ladder: PASS 78, FAIL 0, EXIT 0, LOAD-AT-RUN 9 06:41:49 load5=12.
Record refresh: DENOMINATORS.sha256 154 rows, SOURCES.json 163 sources, FILES.sha256 40, changed=0.
Review pass 1 (2026-09-22) fixed 7 finding(s): A-1, D-1, C-1, B-1, D-2, A-2, C-2.

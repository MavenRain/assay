# Direct trace decimal normalization

Starting at `7af4b04`, `Trace.value` converts strings directly to character
lists and back when removing leading decimal zeros. It no longer constructs
intermediate Series values. Validation still runs before normalization:
decimal words have at most 78 digits, hexadecimal words have at most 64,
and both must fit uint256. Decimal zero normalizes to `0`. Hexadecimal values
retain their prefix and digits after lowercasing.

`python3 -P dev/cli-value-direct-test.py` compiles the predecessor and
current implementations and compares 872 results, including exact error
strings. Independent Python goldens check acceptance and normalized values.
Cases cover decimal and hexadecimal zero, leading zeros, embedded zeros,
uint160 and uint256 boundaries, length limits, mixed case, empty inputs,
whitespace, NUL, Latin-1 characters, combining marks and astral characters.
Seeded cases add 128 uint256 values in three representations and 128
arbitrary strings.

Three compiled mutants keep leading zeros, trim ones instead of zeros,
or return an empty string for decimal zero. Each must exit successfully
and produce its named wrong answer. The restored implementation then
repeats all 872 cases.

The `Trace.value` declaration pin extends the manifest to twelve entries.
The gate refuses missing, duplicate and modified bodies, and verifies that
an unrelated lowercase-helper change remains visible in the historical
CLI bundle. Native carry hashes follow the changed CLI source.

`make test` includes the new check. The default `--lexer-direct` gate mode
adds a mandatory `CLI-VALUE-DIRECT` leg, for 94 legs. Its predecessors
retain their schedules and requirements. The compilation-speed limit
remains an Assay/Bend 2 ratio at most 1.0.

Validation records are retained in
`dev/validation/2026-10-01-cli-value-direct`.

`make test` passes the native kernel suite, all 24 commands across 18
adapters, and the seven follow-up checks. Compatibility checks retain
all 56 predecessor schedules and require the current 94-leg schedule.

The fresh five-round, six-case measurement is byte-identical to
`dev/bend2-baseline.json`, sealed by `dev/BEND2.sha256`. Its median matched
batch times are 1631.756500 ms for Assay and 1500.554791 ms for Bend 2,
giving a ratio of 1.087435467. The 1.0 speed bound still fails. The measured
19.595-second host window started at 2026-10-01 10:50 UTC; this comparison
does not isolate the decimal-normalization change's speed effect.
The benchmark controls pass with 37 refusals and six compiled mutations.
The full milestone gate battery and M2 source lowering remain open.

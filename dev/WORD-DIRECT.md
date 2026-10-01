# Direct word prefix removal

Starting at `91a27b7`, `Recognize.parse_word` removes the hexadecimal
prefix with `NativeString.drop(2n, text)`. The former path constructed a
Series, dropped two characters, collected a list and rebuilt a string.
The existing native helper returns the same string suffix directly.

The decimal path, ASCII digit checks, case conversion, 64-character
hexadecimal limit, 78-character decimal limit and `uint256` overflow
check retain their behavior. The trusted kernel is unchanged.

`python3 -P dev/word-direct-test.py` compares both compiled implementations
with 1,580 independent Python goldens. Cases cover zero and leading zeros,
mixed-case hexadecimal, the `uint256` boundary, overflow, excess lengths,
signs, spaces, non-ASCII digits and seeded valid and invalid strings.
Three compiled mutants retain the prefix, drop only one character or drop
three characters. Each must exit successfully and produce its named wrong
answer. The restored implementation runs afterward.

The seventh exact declaration pin covers only `Recognize.parse_word`.
The check rejects missing, duplicate and modified pins. A change to the
reachable `NativeString.lower` helper remains visible in historical bundle
comparisons. Native carry hashes follow the changed emitter source.

`make test` includes the word-parser check. `make gates` includes the
mandatory `WORD-DIRECT` leg through its existing `--lexer-direct` mode.
The compatibility check retains all 56 predecessor modes and requires the
default's 91 legs, including the three appended direct-conversion checks.
The benchmark method and 1.0 speed limit remain in force.

The native build, `make test`, schedule comparison and TRUSTED-LINES pass.
The final five-round, six-case measurement is frozen from
`dev/validation/2026-09-30-word-direct/paired-measurement-final.json`.
It reports an assay/Bend ratio of 1.312470762 in a 13.638-second host
window, exceeding the unchanged 1.0 bound. The earlier
`paired-measurement.json` was measured while `make test` was running and
is retained as a separate observation. The final record was taken after
that local test process completed. These observations do not isolate the
speed effect of prefix removal.

Validation evidence is recorded under
`dev/validation/2026-09-30-word-direct`. BEND2-RATIO remains failing.
The full milestone gate battery and M2 source lowering remain pending.

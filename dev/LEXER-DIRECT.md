# Direct lexer conversions

This follow-up starts at `82f1476`. The lexer converts its input string
directly with `NativeString.to_list`. Identifier and natural-literal
character lists pass directly to `NativeString.of_list`. The former paths
built and immediately collected a `Series`, allocating stream nodes and
tail closures before consuming the same characters.

The change touches only `Lexer.lex`, `Lexer.go` and `Lexer.nat_of_digits`.
Token rules, numeric parsing, byte literals, positions and refusal messages
retain their existing behavior. The kernel, runtime boundary and EVM
backend are unchanged.

`python3 -P dev/lexer-direct-test.py` compares complete token streams with
the three predecessor declarations restored from the pinned commit.
The 287 inputs include 20 boundary cases, 256 seeded strings and all 11
contract corpus sources. Tokens include identifier and natural values,
byte payloads, line and column positions, and the final end token.
Refusals include the complete diagnostic. Four independent expected
streams check empty input, declaration punctuation, newlines and leading
numeric zeros. Three compiling mutants lose numeric digits, identifier
heads or the entire input. Each must finish successfully and produce a
different answer for a named case; the unmodified control runs afterward.

The same command checks compatibility with all 56 predecessor modes and
the new default's 89 legs. `make test` adds it after the keyword test.
`make gates` and `dev/gates.sh` now select `--lexer-direct`; the earlier
`--keyword-dispatch` mode retains its original 88 legs.

`dev/cli_delta.py` now pins four lexer declarations, including the earlier
keyword dispatch optimization. Every pinned declaration must occur once
and match its exact digest before its predecessor body is restored for
historical bundle comparisons. Reports identify the complete pin manifest.
Tests reject modified, missing and duplicate pins, and ensure that a change
to another reachable declaration remains visible. The five older
compatibility checks pass with this normalization.

## Performance and validation

The local lexer comparison alternates execution order over five rounds.
Its median after/before ratio is 1.014, with considerable variation.
It does not establish a speed improvement.

A fresh five-round paired measurement of the six matched compiler cases
is frozen in `dev/bend2-baseline.json` and sealed by `dev/BEND2.sha256`.
Its 22.872-second window gives a ratio of 1.490829052 against the unchanged
1.0 limit. BEND2-RATIO still fails; BEND2-RATIO-TEST passes. The previous
dated measurement was 1.720825537. These separate measurements do not
isolate this change's performance effect.

The native build, standard tests, lexer checks, compatibility checks and
trusted-source budget pass. The validation record is under
[2026-09-30-lexer-direct](validation/2026-09-30-lexer-direct/README.md).
The complete gate battery was not run. M2 source lowering and its milestone
exit remain pending.

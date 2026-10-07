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
The input-erasing mutant takes zero characters before conversion to a list.
The direct `Nil{}` replacement exceeded its 180-second compiler timeout
during the [substring continuation](SEGMENT-DIRECT.md), including a retry
with only four inputs. All mutants use the full 287-input fixture, the
original compiler timeout and the named wrong-answer check.

The same command checks compatibility with all 56 predecessor modes and
the current default's 95 legs, including the later
[IDENTIFIER-DIRECT](IDENTIFIER-DIRECT.md), [WORD-DIRECT](WORD-DIRECT.md),
[SEGMENT-DIRECT](SEGMENT-DIRECT.md),
[CLI-PREFIX-DIRECT](CLI-PREFIX-DIRECT.md),
[CLI-VALUE-DIRECT](CLI-VALUE-DIRECT.md), and
[CLI-ERROR-DIRECT](CLI-ERROR-DIRECT.md)
legs. `make test` adds it after the keyword test.
`make gates` and `dev/gates.sh` now select `--lexer-direct`; the earlier
`--keyword-dispatch` mode retains its original 88 legs.

`dev/cli_delta.py` now pins five lexer declarations, including the earlier
keyword dispatch optimization and the contract span conversion. Every pinned declaration must occur once
and match its exact digest before its predecessor body is restored for
historical bundle comparisons. Reports identify the complete pin manifest.
Tests reject modified, missing and duplicate pins, and ensure that a change
to another reachable declaration remains visible. The five older
compatibility checks pass with this normalization.

## Contract token strings, 2026-09-30

Starting at `42ef4be`, `Contract.span` passes its reversed character list
directly to `NativeString.of_list` in both the end-of-input and separator
branches. The scanner retains its character stream, token values, positions
and refusal rules.

The default lexer test now checks both lexers. `--contract` selects the
contract comparison alone. Its 303 inputs include 15 boundary cases,
256 seeded strings and all 32 surface examples. Five independent goldens
cover identifiers, newlines and comments. The 8,192-token boundary is
checked explicitly. Two compiled mutants empty the token string in each
return branch; they produce named wrong answers in cases 1 and 2, and
the restored control matches the predecessor afterward.

The contract span is the fifth exact declaration pin. Modified, missing
and duplicate declarations are rejected. A change to `Contract.word_char`
remains visible in historical bundle comparisons. Gate commands, markers,
deadlines and failure classes retain their existing schedules.

## Performance and validation

Both local lexer comparisons alternate execution order over five rounds.
The recorded median after/before ratios are 1.114991 for the
core lexer and 0.903353 for the contract lexer.

The initial compiler measurement is archived in
`dev/validation/2026-09-30-lexer-direct/paired-measurement.json`; it reported
a ratio of 1.490829052 in a 22.872-second window.
The contract-span six-case, five-round measurement is retained in
`dev/validation/2026-09-30-contract-span/paired-measurement.json`. It reported
0.962311539 against the unchanged 1.0 limit in a 40.041-second window.
BEND2-RATIO and its refusal controls passed on that record. These
measurements describe their recorded host windows. [IDENTIFIER-DIRECT.md](IDENTIFIER-DIRECT.md)
records the identifier measurement. [WORD-DIRECT.md](WORD-DIRECT.md)
describes the current frozen measurement and its failing performance gate.

The native build, kernel suite, 24 commands across 18 adapters, both lexer
checks, six compatibility checks and TRUSTED-LINES pass. The accounting
seals retain the same denominator paths and fixtures. Evidence is under
`dev/validation/2026-09-30-contract-span`.

The complete gate battery was not run. M2 source lowering and milestone
exit remain pending.

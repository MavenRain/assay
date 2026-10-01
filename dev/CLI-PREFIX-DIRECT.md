# Direct CLI hexadecimal prefix removal

Starting at `356ce95673480c8b6290e9549a3a47153c44933f`, `Trace.calldata`,
`Trace.caller` and `Differential.caller` use `NativeString.drop(2n, ...)`
to remove hexadecimal prefixes after lowercasing. The predecessor rebuilt
strings through Series and lists. Decimal callers, input validation,
uint160 bounds, address padding and offline fixture selection retain
their behavior. The trusted kernel is unchanged.

`python3 -P dev/cli-prefix-direct-test.py` compiles both implementations
and compares all 2,184 results across 728 inputs. Independent Python
goldens check acceptance and normalized output. Exact error strings also
match the predecessor. Cases include mixed-case hexadecimal input,
empty calldata, odd digit counts, decimal callers, leading zeros,
word-length limits, uint160 and uint256 boundaries, both offline fixture
addresses, invalid digits, whitespace, NUL, combining marks and astral
characters. Seeded cases include 128 arbitrary strings and 128 addresses
in decimal, lowercase hexadecimal and uppercase hexadecimal forms.

Nine compiled mutants remove zero, one or three characters in each
changed function. Each must finish successfully and give its named
wrong answer. The restored implementation runs afterward.

Three exact declaration pins extend the manifest to eleven entries.
Missing, duplicate and modified bodies are refused. An unrelated change
to the lowercase helper remains detectable in the historical CLI bundle.
Native carry hashes follow the changed CLI source.

`make test` includes this comparison. The existing `--lexer-direct`
gate mode includes mandatory `CLI-PREFIX-DIRECT` and
`CLI-VALUE-DIRECT` legs, for 94 legs.
Compatibility retains all 56 predecessor modes and all earlier default
legs. Benchmark methodology and the 1.0 compilation speed bound retain
their requirements.

Validation evidence is recorded under
`dev/validation/2026-10-01-cli-prefix-direct`.

The native kernel suite and all 24 commands across 18 adapters pass.
The five remaining test-target commands pass in a separate captured run:
keyword dispatch, direct lexing, identifier recognition, word parsing
and substring extraction. Native carry and trusted-source budgets pass.
The first three comparison attempts stopped at a missing compiler path
or harness syntax and linearity errors. The corrected harness completes
the full comparison and all nine mutants; these attempts are archived.

The five-round, six-case measurement was frozen as
`dev/bend2-baseline.json` for this slice. It records a ratio of 1.639908573 in a
9.366-second host window starting at 2026-10-01 09:18 UTC. The 1.0 speed
bound still fails. The ratio refusal and mutation controls pass. This
measurement describes the host window and does not isolate the prefix
change's effect. BEND2-RATIO, the full milestone gate battery and M2
source lowering remain open.

The recorded comparison above is superseded by
[CLI-VALUE-DIRECT.md](CLI-VALUE-DIRECT.md); its archived record remains intact.

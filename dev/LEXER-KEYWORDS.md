# Direct keyword dispatch

This follow-up to `a29a0c1` replaces `Lexer.ident_kind`'s construction
and linear search of a 30-entry keyword list with a Bend string match.
The pinned compiler lowers that match to character dispatch. The existing
`Lexer.keywords` declaration remains available, but it is no longer
reachable from the compiler CLI.

The vocabulary is unchanged. Matching is case-sensitive and requires
the entire spelling. Every other input returns `Token.Kind.Ident` with
the original byte string, including empty and non-ASCII inputs passed
directly to the classifier. The lexer still applies its existing rules
for identifier characters and token locations.

`python3 -P dev/lexer-keywords-test.py` checks all 30 keywords and 225
other inputs, covering proper prefixes, identifier suffixes, case
variants and UTF-8 bytes. It builds the actual classifier and runs it
with the production launcher and stack configuration. `make test` runs
this check after the standard kernel and adapter tests. The gate mode
`--keyword-dispatch` adds it as the LEXER-KEYWORDS leg to the 87
`--m2-event-decode` legs, for 88 legs. `make gates` and `dev/gates.sh`
used this mode until [LEXER-DIRECT](LEXER-DIRECT.md) selected
`--lexer-direct`.

The five historical compatibility checks (event-decode, event, revert,
call and return) accepted exactly one pinned delta: the
`Lexer.ident_kind` declaration. [LEXER-DIRECT](LEXER-DIRECT.md) widens
the pin to four lexer declarations, and the contract span conversion adds
`Contract.span` as a fifth. [Identifier conversion](IDENTIFIER-DIRECT.md)
adds `Recognize.identifier` as a sixth. [Word parsing](WORD-DIRECT.md) adds
`Recognize.parse_word` as a seventh. [Substring extraction](SEGMENT-DIRECT.md)
adds `Model.segment` as an eighth. [cli_delta.py](cli_delta.py) pins
the SHA-256 of each new declaration text and puts back the BASE declaration
before the compare. The rest of the CLI bundle must still be
byte-identical to each BASE. This follows a user ruling of 2026-09-29.

No kernel rule, EVM emission rule, launcher, benchmark method, performance
bound or trusted-source budget changes. Packed storage, mapping and event
source lowering remain pending.

The [validation record](validation/2026-09-29-keyword-dispatch/README.md)
contains the correctness checks and fresh timing results. On the loaded
host, the local before/after rounds of its `compare.py` show no reliable
speed change. The paired per-round median is 0.945 and the geometric mean
is 0.989. These values are computed from the rounds in `comparison.json`,
as sum(after)/sum(before) per round. The outputs are identical. This local A/B
comparison is separate from the Bend 2 measurement below.

## Performance

A fresh paired Bend 2 measurement of this source was frozen in
`dev/bend2-baseline.json` and sealed by `dev/BEND2.sha256`. The
[LEXER-DIRECT](LEXER-DIRECT.md) measurement replaced it. It is retained
as `dev/validation/2026-09-29-keyword-dispatch/paired-measurement.json`.
It ran five rounds of six cases on 2026-09-29, in a 7.441-second window.
The Assay/Bend 2 ratio was 1.720825537, above the unchanged 1.0 bound.
The previous record, 1.137273126 in a 48.113-second window, is in
[M2-EVENT-DECODE.md](M2-EVENT-DECODE.md). BEND2-RATIO failed before this
slice and after it. BEND2-RATIO-TEST passes with the new pins. The
corpus measurement is unchanged.

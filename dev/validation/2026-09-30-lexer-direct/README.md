# Direct lexer conversion validation

Predecessor: `82f14761406f4d0cd383f284250d708595a4988e`.
Validation ran in `/Users/oobi/Documents/gpt1/assay-lexer-direct` using
the repository's pinned Bend 2 checkout and Node runtime.

`lexer-result.json` contains the 287-case comparison, output digest,
named mutant kills and five local timing rounds. `paired-measurement.json`
is the fresh, source-pinned six-case compiler benchmark, identical to the
published `dev/bend2-baseline.json`. `compatibility.json` records the 56
preserved predecessor modes and the new default's 89 checks.
`final-lexer-result.json` records the final integrated lexer rerun after
the compatibility check was wired into the test command. Its output
digest must match the earlier comparison.

`CHECKS.tar.gz` retains complete command captures and metadata, including
builds, standard tests, lexer checks, all compatibility checks, source
budgets, denominator checks and the benchmark validators. Command outcomes
are recorded in `CHECKS.json`. Failed intermediate harness builds and the
first, superseded measurement remain in the workspace captures.

The final BEND2-RATIO command fails with ratio 1.4908290523055048 above
the unchanged 1.0 limit. The ratio validator's controls and mutation
tests pass. Local lexer timing has median after/before 1.014 and does
not establish a speed improvement. The full 89-leg gate battery was
not run. This record does not close M2 or its performance requirement.

`SOURCES.json` hashes the reviewed source, gate wiring and documentation.
The digest list excludes itself and its validation artifacts.

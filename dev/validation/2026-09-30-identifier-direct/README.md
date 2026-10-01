# Identifier conversion validation

Work started at `e16c842b69448b229633a592787f2a7450938c16` in
`/Users/oobi/Documents/gpt1/assay-identifier`. The resulting changes are
staged in `/Users/oobi/Documents/assay`.

The native build passed. `identifier-report.json` records 1,043 predecessor
comparisons and grammar goldens, plus two killed compiled mutants. The four
build logs cover its control, native implementation, and mutants.

`lexer-direct.log` records 287 core lexer cases and 303 contract lexer
cases, with their independent goldens and five killed mutants. It also
records the compatibility check: 56 prior modes retain their schedules,
the current mode contains 90 exact legs, and the CLI bundle remains
identical after restoring the six pinned declarations. `compatibility.json`
retains that comparison, including both appended mandatory legs.
`lexer-keywords.log` records 30 keywords and 255 passing cases.

The full ladder was stopped with exit 143 after 41 passing checks and one
failed AXIOMS check. `gates-partial.log` is a partial run, with no claim
that the remaining legs passed. That failure was a missing ignored proof
cache in the validation checkout. Copying the main repository's existing
cache resolved it: `axioms-retry.log` records 42 theorems, zero `sorryAx`,
28 carried files, and three passing controls.

`paired-measurement.json` is the fresh five-round, six-case compiler
measurement. It is byte-identical to the active `dev/bend2-baseline.json`.
The 1.775497120 ratio exceeds the unchanged 1.0 speed bound, so the speed
gate fails. Its 33.316-second host window does not isolate the timing
effect of the identifier change. `FILES.sha256` seals this evidence.

Review fix: the test's `literal` helper first wrote one `\u{...}` escape
per UTF-8 byte. The Bend parser reads each escape as one code point, so
non-ASCII rows reached both adapters as several byte-valued characters.
The helper now writes one escape per code point. The rerun after that fix
passed with the same output and mutant hashes as `identifier-report.json`.

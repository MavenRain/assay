# Contract span conversion validation

Predecessor: `42ef4be4f81a92acdf8bdb072c4b6c11af237672`.
Validation ran in `/private/tmp/assay-20260930-continue`, the build
directory that `dev/bend2-baseline.json` records, using the repository's
pinned Bend 2 checkout and Node runtime.

`CONTRACT-RESULT.json` contains the 303-case contract lexer comparison,
its output digest, the two named mutant kills and five local timing
rounds. `RESULT.json` contains the 287-case core lexer comparison from
the same default test run. `paired-measurement.json` is the fresh,
source-pinned six-case compiler benchmark. It is identical to the
published `dev/bend2-baseline.json`.

`CHECKS.json` records the label and exit code of each of the 16 commands.
Every command exited 0. Each command has a `<label>.manifest.json` with
its argv, working directory and exit status, and a `<label>.stdout.log`
with its output.

The BEND2-RATIO command passes with ratio 0.962311539 against the
unchanged 1.0 limit. The earlier record, 1.490829052, did not pass. Each
ratio describes its recorded host window. Local lexer timing has median
after/before 1.114991 for the core lexer and 0.903353 for the contract
lexer. These values do not establish a speed change. The full 89-leg
gate battery was not run. This record does not close M2.

`SOURCES.json` hashes the reviewed source, gate wiring and documentation
at validation time. The digest list excludes itself and its validation
artifacts. Review fixes after validation changed `dev/native-carry.json`
and its row in `dev/DENOMINATORS.sha256`, so the
`dev/DENOMINATORS.sha256` digest in `SOURCES.json` predates those fixes.

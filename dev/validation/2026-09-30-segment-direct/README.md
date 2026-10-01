# Executor substring validation

This continuation starts at `a374e662a727785b7e962f0db97953d687550843`.
Implementation and validation ran in
`/Users/oobi/Documents/gpt1/assay-segment-direct`. The record directory uses
the continuation's start date. The final compiler measurement started at
2026-10-01 07:18 UTC.

`segment.stdout.log` records 1,348 independent substring goldens, three
compiled mutants and a restored control. `segment-report.json` comes from
the later passing follow-up and records the complete predecessor commit.
`followups.stdout.log` records passing identifier, word and substring checks;
the reports and `followup-exits.json` retain their counts and exit statuses.

`test-initial.capture.json` has interrupted status and exit 143. The first
full test-target run was restarted after importing and verifying matching
build-cache inputs and outputs. `test-timeout.capture.json` has exit 2. Its
stdout records the passing kernel suite, all 24 commands across 18 adapters,
and keyword checks before the input-erasing lexer mutant's compilation hit
the original 180-second timeout.

`lexer-retry-timeout` records another timeout with the same fixture.
`lexer-small-timeout` records a failed four-input experiment, which was
reverted. The final mutation erases the input using the existing string
helpers, with all 287 inputs and the same deadline. `lexer.stdout.log`
records the passing core and contract lexer comparisons, compiled mutants,
restored controls and five timing rounds. `lexer-resume.py` is the replay
source. Its prefix receipt records the source, JavaScript output, launcher and
compiler hashes of four earlier builds at replay time. The replay checked
that each regenerated source matched and that no hash changed during the
replay. No hash links the reused output or launchers to the timed-out run. The remaining
builds ran fresh. Both lexer result files are archived.

`compatibility.json` records all 56 unchanged predecessor schedules, 92
current legs and the normalized CLI bundle. There are eight exact declaration
pins. The substring check rejects missing, duplicate and modified pins and
keeps a changed reachable helper visible. `trusted-lines.stdout.log` records
passing source budgets; `carry.stdout.log` records 12/12 files with no hash
or inventory differences.

`paired-measurement.json` was taken after the local regression processes
completed. It is byte-identical to `dev/bend2-baseline.json`. Its five rounds
and six cases yield a ratio of 1.538120777 against the retained 1.0 bound,
in an 18.362-second window. `ratio.stdout.log` records the failing bound;
`ratio-controls.stdout.log` records three controls, 37 refusals and six
mutants passing. This observation does not isolate the source change's
speed effect.

Every captured command has its full stdout, stderr and manifest. Failed
attempts predate the final lexer mutation repair. `SOURCE-HASHES.json` pins
the final source state. `FILES.sha256` seals this archive. Native carry and
denominator seals are refreshed without removing prior paths.

The complete milestone gate battery was not run. This record does not close
M1 performance or M2 source lowering.

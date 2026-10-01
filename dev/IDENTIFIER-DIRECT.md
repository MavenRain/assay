# Direct identifier conversion

This continuation starts at `e16c842`. `Recognize.identifier` now passes
the input string directly to `NativeString.to_list`. Its former path
constructed a Series and immediately collected it into a list. The
first-character and remaining-character predicates retain the ASCII
grammar `[A-Za-z_][A-Za-z_0-9]*`.

`python3 -P dev/identifier-direct-test.py` compares the current declaration
with the predecessor restored from that commit. Both compiled adapters
must match 1,043 independent grammar goldens: empty and boundary names,
all 256 ASCII and Latin-1 character values in initial and continuation positions,
Unicode rejection, 8,192-character names, and 512 seeded inputs. Two
compiled mutants replace the character list with an empty list or drop
its first character. Both must produce different results.

The sixth declaration pin in `dev/cli_delta.py` covers exactly
`Recognize.identifier`. The test rejects a missing, duplicate, or modified
pin and verifies that an unrelated reachable character-predicate change
remains visible. Native carry and denominator hashes track the changed
source and pin manifest.

`make test` runs this check. `make gates` includes the `IDENTIFIER-DIRECT`
leg through its existing `--lexer-direct` mode. The benchmark method and
1.0 performance bound remain in force. This change removes an intermediate
representation; its checks establish behavior, without claiming a measured
speed improvement.

The fresh five-round, six-case comparison is retained at
`dev/validation/2026-09-30-identifier-direct/paired-measurement.json` and
frozen in `dev/bend2-baseline.json`. Its ratio is 1.775497120 in a
33.316-second window starting at 2026-10-01 02:55 UTC. BEND2-RATIO therefore
fails against the unchanged 1.0 bound. The preceding contract-span record
reported 0.962311539 in a different host window. These records do not
isolate the timing effect of this identifier change.

The [validation record](validation/2026-09-30-identifier-direct/README.md)
records the passing identifier, lexer, schedule and axiom checks. The full
ladder was stopped after 41 passing checks and a proof-cache failure that
passed on retry. The remaining full-ladder legs have not been claimed as
passing.

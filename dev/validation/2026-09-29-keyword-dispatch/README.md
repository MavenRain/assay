# Keyword-dispatch validation

Base: `a29a0c1`. The implementation change is limited to `Lexer.ident_kind`.
The carry hash is refreshed, and the catch-all inventory preserves existing
reasons while updating shifted line numbers and documenting the new identifier
fallback. No existing leg deadline, benchmark method or budget changes.

## Gate changes

The new `--keyword-dispatch` gate mode adds the LEXER-KEYWORDS leg to the
87 `--m2-event-decode` legs, for 88 legs. The leg runs
`python3 -P dev/lexer-keywords-test.py` with a 600-second deadline.
`make gates` and `dev/gates.sh` now use `--keyword-dispatch`.

The five historical compatibility checks (event-decode, event, revert, call
and return) now accept exactly one pinned delta: the `Lexer.ident_kind`
declaration. [cli_delta.py](../../cli_delta.py) pins the SHA-256 of the new
declaration text. Each check replaces that declaration with its BASE text, so
`Lexer.keywords` is reachable again as at BASE. The rest of the CLI bundle
must still be byte-identical to each BASE. If the pin does not match, the
CLI-BUNDLE check fails. This follows a user ruling of 2026-09-29.

## Passing checks

- [Standard runner](runtest.log): `SUITE-KERNEL OK`, surface tests, and
  `RUNTEST adapters=18 commands=24 OK`.
- [Keyword regressions](keywords.log): all 30 keywords and 225 other inputs,
  `LEXER-KEYWORDS keywords=30 cases=255 OK`.
- [Source audits](audits.log): HOUSE, TRUSTED-LINES and CARRY pass.
  The artifact total remains 2951/3550 and the kernel remains 3767/4000.
- `git diff --check` passes.

The keyword adapter initially exposed two test-harness problems: JSON-style
Unicode escapes are not Bend escapes, and the default Node stack is too small
for the generated adapter. The final adapter uses Bend byte escapes and the
production launcher. Its complete 255-case run passes. An early kernel-suite
invocation preceded the test build; the complete standard runner above built
the required artifacts and passed.

## Before/after measurement

[compare.py](compare.py) runs the original and changed compilers against the
same six frozen inputs, with one warmup and five alternating measured rounds.
Each invocation writes a fresh directory. All five output files are compared
by SHA-256 after every invocation. All outputs agree.

The [raw comparison](comparison.json) records median batch times of
6804.526875 ms before and 5982.518292 ms after, a ratio of medians of
0.879197. The two medians come from different rounds: the before median is
from round 3 and the after median is from round 4. The paired per-round
after/before ratios are 0.839, 0.791, 1.134, 0.945 and 1.333. Their median
is 0.945 and their geometric mean is 0.989. Two of the five rounds are slower
after the change. For the 30 invocations paired by round and input, the
geometric mean ratio is 0.984, and 17 of 30 are faster after the change.

On this loaded shared host, the timing shows no reliable speed change. The
outputs are identical. This local comparison does not replace the binding
Bend 2 gate and makes no claim about every contract. The record includes
source, executable and method hashes.

To reproduce against a separately built baseline tree:

```sh
python3 -P dev/validation/2026-09-29-keyword-dispatch/compare.py BASELINE_ROOT NEW_JSON
```

## Bend 2 paired measurement and freeze

Three attempts at the existing paired Bend 2 measurement exceeded its
unchanged 60-second window:

| Attempt | Seconds | Result |
| --- | ---: | --- |
| [First](paired-rejected-window.json) | 68.638 | BEND2-WINDOW |
| [Second](paired-retry-rejected-window.json) | 61.533 | BEND2-WINDOW |
| [Final](paired-final-rejected-window.json) | 211.892 | BEND2-WINDOW |

Host load varied substantially; the final attempt also overlapped the final
source audits. None of these rejected measurements enters the freeze.

A fourth attempt ran on a quieter host at 2026-09-29T17:32Z, on the staged
keyword-dispatch tree. It completed five rounds of six cases in a
7.441-second window. The Assay/Bend 2 ratio is 1.720825537. The
[report](paired-measurement.json) and its [capture](paired-measurement.log)
are retained here. The measurement wrapper read 1-minute and 5-minute load
averages of 6.58 and 11.85 before the run, and 6.85 and 11.66 after it.
The report records a start load of 7.10, 11.87 and 16.89 (1, 5 and
15 minutes).

This report is frozen. `dev/bend2-baseline.json` is a byte copy of
`paired-measurement.json`, and `dev/BEND2.sha256` seals it. This directory
has no checksum manifest. The previous record is
[paired-measurement.json](../2026-09-28-m2-event-decode/paired-measurement.json)
from `a29a0c1`: ratio 1.137273126 in a 48.113-second window. That record,
the earlier reports and their checksum manifests remain untouched.

The local A/B comparison above is a separate measurement. Its paired
per-round median is 0.945, and its geometric mean is 0.989.

## Gate results

The [earlier gate diagnostics](performance-gates.log) were captured before
the freeze. They report `BEND2-IDENTITIES` for BEND2-RATIO and
BEND2-RATIO-TEST. DENOMINATORS reports stale hashes for Makefile,
native-carry.json and frontend.bend.

After the freeze:

- The refreshed `dev/DENOMINATORS.sha256` makes the DENOMINATORS leg pass.
  It also makes the M0-RATIO leg pass, because `dev/ratio.py` runs the same
  `shasum -a 256 -c dev/DENOMINATORS.sha256` check first.
- BEND2-RATIO-TEST passes on the new identities:
  `BEND2-RATIO-TEST controls=3 refused=37 mutants=6 OK`.
- BEND2-RATIO fails:
  `BEND2-RATIO FAIL BEND2-BOUND limit=1.0 ratio=1.7208255372759242`.
  This leg failed before this slice (ratio 1.137273126) and still fails.
  There is no REPORT-SEAL or IDENTITIES failure.

The full gate battery was not rerun in this slice.

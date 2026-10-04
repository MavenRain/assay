# M2 storage proof validation, 2026-10-03

Base: `7ec1b8ac4110d4f4dd070b81f02fad9b033d08c9`.
Compiler: pinned Bend 2.0.32, commit
`573002f01ec6c52416d44489543f69a9625facf8`, from `.tools/bend`.

Focused validation for M2 group 5, rerun from the tree after the review
repair. Source and compiler hashes are in `SOURCES.json`. Commands,
complete output and durations are in `REGRESSIONS.json`.

| Suite | Exit | Marker |
| --- | --- | --- |
| storage-proof | 0 | `STORAGE-PROOFS theorems=13 accesses=2395 refinements=533 lexical=17 grammar=2 mutants=7 controls=7 erasure=13 OK` |
| milestone-speed | 0 | `MILESTONE-SPEED schedules=57 controls=9 OK` |
| source-proof | 0 | `SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK` |
| layout-packed | 0 | `LAYOUT-PACKED layouts=11 accesses=1685 negative=40 mutants=11 scope=packing OK` |
| packed-source | 0 | `PACKED-SOURCE cases=66 model=packed executors=run+t8n mutants=6 OK` |
| mapping-runtime | 0 | `MAPPING-RUNTIME live=40 refusals=27 constructor=1 layout=1 OK` |

The storage gate passed thirteen theorems, 2,395 access probes, 533
refinement probes, 17 lexical corpus rows, two grammar refusals of the
closure fixtures, seven mutation controls, seven axiom-report controls
and an erasure control over the thirteen theorems. The two closure
fixtures must fail with the surface token in the compiler error output;
a bare nonzero exit does not pass. The adapter refines natural numbers,
labels text that is not a natural number `invalid-value` on refine and
write, and labels a natural number outside the declared type
`out-of-range:<typ>`.
The text `-1` and the other malformed literals moved out of the access
and refinement corpora into the 17-row lexical corpus. The axiom report
is strict per theorem: twelve theorems must list no axioms, and
`write_total` alone may list a subset of `propext`, `Quot.sound` and
`Classical.choice`, which it needs through the core division lemmas.
The erasure control requires the thirteen theorem names absent from
the generated C and the four executable definitions present. See
`dev/M2-STORAGE-PROOFS.md` for the limits of each claim.

`GATE-INTEGRATION.json` records that all 65 gate modes of the base
commit keep their legs, commands, markers and deadlines, and that the
new `--m2-storage-proofs` mode keeps the previous 105 legs and adds one
storage leg. `SUMMARY.json` is the count file that
`dev/storage-proof-test.py` wrote. `EVIDENCE.tar.gz` holds
`_build/storage-proofs`: the access, refinement and mutant probes and
the Lean build and axiom captures.

## Review repair

A review of the first record found seven defects. This rerun covers the
record half and the code half of the repair:

- The first record came from a driver outside the tree, with absolute
  paths of that session. `validate.py` now lives in this directory. It
  uses repo-relative paths, takes the compiler from `.tools/bend` and
  stops when that checkout is not at the commit in `dev/toolchain.json`.
  `REGRESSIONS.json` records repo-relative commands.
- `check-gate-integration.py` compared the gate inventory with `HEAD`
  and rewrote `GATE-INTEGRATION.json` on every run. It now compares
  with the fixed base commit `7ec1b8a` and rewrites the record only
  with `--write`; without the flag it verifies the record and exits 1
  on a difference.
- `EVIDENCE.tar.gz` holds only `_build/storage-proofs`. The managed
  command captures of the first session are not part of the record.
- The default gate advance now reaches every entry point: `make test`,
  `dev/gates.sh` and `dev/milestone-speed-test.py` select
  `--m2-storage-proofs` (106 legs).
- `dev/DENOMINATORS.sha256` has refreshed rows for the nine changed
  files and new rows for the five new files, so the DENOMINATORS leg
  passes on the staged tree.
- The code half of the remaining findings is applied in this round.
  `write_total` proves that the runtime check accepts every valid
  write, so the library has thirteen theorems. The axiom oracle is
  strict per theorem, with a `CLASSICAL` allowlist for `write_total`
  alone and seven controls. The erasure control requires thirteen
  erased theorems and four present executable definitions. The closure
  fixtures must fail on the surface token (`grammar=2`). The adapter
  refines natural numbers with the label `invalid-value`, and the
  malformed literals sit in a 17-row lexical corpus. The marker counts
  changed to 2,395 accesses and 533 refinements. The documentation
  states the remaining limits and names the open Prop-valued Word
  refinement.

## Reproduce

```sh
git -C .tools/bend rev-parse HEAD
python3 -P dev/validation/2026-10-03-m2-storage-proofs/validate.py run
python3 -P dev/validation/2026-10-03-m2-storage-proofs/check-gate-integration.py
```

The first command must print the commit in `dev/toolchain.json`.
`validate.py run` executes the six suites one at a time, then rewrites
`REGRESSIONS.json`, `SUMMARY.json`, `GATE-INTEGRATION.json`,
`EVIDENCE.tar.gz`, `SOURCES.json` and `FILES.sha256`. It stops on the
first suite that fails or on an evidence file that holds a path outside
the tree. Durations and the temporary mutant directory recorded in the
evidence differ between hosts. `validate.py seal` recomputes only
`SOURCES.json` and `FILES.sha256`, for use after an edit to this page.

## Not run

The full 106-leg battery (`zsh -f dev/gates.sh`) was not run for this
record. M2-ABI closure stays with the later closure group.

## History

`FAILED-ATTEMPT-1.json` and `FAILED-ATTEMPT-2.json` are the two failed
storage-proof runs of the first session: the storage-closure mutant
survived the first harness, and the second harness looked for a C
symbol without the package prefix. They keep the absolute interpreter
path of that session. The compiler-pin refusal of that session is
described in `dev/ASSAY-M2-BUILD-LOG.md`.

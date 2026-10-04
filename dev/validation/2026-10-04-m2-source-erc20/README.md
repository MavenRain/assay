# M2 source ERC20 validation, 2026-10-04

Base: `be3062d62b751fc1c0ff790f8950e147b0e51723`.

The first run of this record passed the final compiler build, the ERC20
suite, the typed return suite, the source event suite and seven source/gate
audits. A review of that record found seven defects, F1 to F7 below. After
the fixes, a serial rerun from the repository root repeated the build, the
three suites and seven audits on the final tree. Two more audits ran when
the record was sealed. `rerun/` keeps the rerun captures, and
`rerun/RERUN.json` is its receipt. `SOURCES.json` pins the code, harnesses,
frozen ERC20 oracle and generated compiler of the final tree, and the two
driver copies in `drivers/`. `COMPILER.json` records the compiler commit and
output receipt of the final build. `SOURCES-prereview.json` and
`COMPILER-prereview.json` keep the pins of the first run.

| Suite (final tree) | Result |
| --- | --- |
| ERC20-SOURCE | 85 cases, 9 explicit canonical refusals, 4 creates, 5 literal/parameter cases, 15 malformed-literal refusals, 1 zero-caller probe |
| RETURN-ABI | 49 cases, 8 layouts, 30 refusals, rollback and output cap |
| SOURCE-EVENTS | 34 cases, 16 refusals, receipt/trace logs and rollback |
| MILESTONE-SPEED | 57 carried schedules, 9 runner controls, new ERC20 schedule and default entry points |
| PIN-CARRY | 16 of 16 files, zero changed or unlisted files |
| DENOMINATORS, BEND2 | 322 and 1 pinned rows match, after one row repair |
| HOUSE, R0-COUNT, R0-AUDIT, TRUSTED-LINES | Passed with unchanged numeric budgets |
| git diff --cached --check | Passed |

`ERC20-RUN.json` records the inner final ERC20 command,
`python3 -P dev/erc20-source-test.py` with the repository root as its working
directory, under a 900-second deadline. It includes the elapsed time, exit
status and output. The ERC20-SOURCE leg of `dev/stage-a-gates.py` uses the
same deadline and output marker. Independent
cases run with three workers. Each case has a separate state, subprocess
temporary directory and evidence path. Model calls have a 90-second bound.
The suite preserves every expected outcome and requires distinct case names.

`ERC20-RUN.json` and `erc20-final.stdout` come from the first run, so their
marker has no `zero_caller=1` field. For the final tree, the `erc20-source`
step of `rerun/RERUN.json` and `rerun/erc20-source.stdout` record the same
inner command, run from the repository root.

Two drivers outside the repository made three rows of `REGRESSIONS.json`.
These rows ran with `/Users/oobi/Documents/gpt1` as the working directory.
`drivers/` keeps exact copies of both driver files, and `FILES.sha256` lists
them. The `driver` field of each of the three rows names its copy, and the
`driver_sha256` field pins the SHA-256 of that copy. `SOURCES.json` pins
both copies under `drivers`. Both files were last changed before the runs
that used them. Both use absolute paths to this repository.
`drivers/run-assay-erc20-final.py` made the `erc20-final` row. It ran the
inner command above with a 900-second subprocess timeout and wrote
`/Users/oobi/Documents/gpt1/assay-erc20-final-run.json`; `ERC20-RUN.json` is
an identical copy of that file. To reproduce the row from the tree, run the
inner command from the repository root.
`drivers/probe-assay-erc20-literals.py` made the
`literal-diagnostic-initial` and `literal-focused` rows. It loads
`dev/erc20-source-test.py`, sets the work directory to
`.gatework/erc20-literal-probe` and calls only `literals()`. Only this probe
prints the `ERC20-LITERALS` marker in `literal-focused.stdout`; no file in
the repository outside `drivers/` prints it. The full ERC20 run checks the
same five literal cases and 15 refusals (`literals=5 refusals=15` in
`erc20-final.stdout`).

`cases.json` contains expected and observed outcomes and evidence hashes.
`erc20-evidence.tar.gz` retains the complete per-case command records,
compressed geth and Cancun traces, emitted artifacts and refusal fixtures.
The two existing model JSON schemas differ: eventless literal fixtures omit
`logs`; only those fixtures normalize the absent field to an empty list.
The ERC20 fixture requires the event model schema, including its log field.

`rerun/erc20-cases.json` is the report of the final-tree ERC20 run. Its 85
case rows and its other fields are equal to those in `cases.json`, and it
adds a `zero_caller` entry for the new probe. The probe is outside the
frozen corpus: it sends a zero-value `transfer` from the zero caller. The
model and the emitted runtime must revert with empty data and no logs, and
the reference runtime must succeed with one Transfer log.
`rerun/erc20-evidence-delta.tar.gz` keeps the 12 files of the final-tree
work directory that are new or changed relative to `erc20-evidence.tar.gz`:
`cases.json`, `check-bad-invalid.json`,
`create-2b5ad5c4795c026514f8317c7a215e218dccd6cf-0.json`,
`create-2b5ad5c4795c026514f8317c7a215e218dccd6cf-1.json`,
`create-7e5f4552091a69125d5dfcb7b8c2659029395bdf-0.json`,
`create-7e5f4552091a69125d5dfcb7b8c2659029395bdf-1.json`,
`emit-bad-invalid.json`, `model-zero-caller.json`, `run-bad-invalid.json`,
`zero-caller-prestate.json`, `zero-caller-reference.json`,
`zero-caller-source.json`. The other 246 files are byte-identical to the
entries of `erc20-evidence.tar.gz`. Both archives use sorted names, mode
0644, owner 0 and time 0. As in `erc20-evidence.tar.gz`, the command records
in the delta archive (6 files) keep the absolute repository paths that the
suite wrote in their argv. The final-tree source event run wrote a report
byte-identical to `source-events-cases.json`.

`REGRESSIONS.json` and the matching stdout/stderr files retain successful,
failed and interrupted runs. One stderr log is losslessly compressed to
retain its exact trailing whitespace. The first ERC20 attempt exposed the
reference's permissive trailing bytes, which became nine explicitly named
source refusals without changing the frozen oracle. A concurrent run hit the
old 30-second model-call bound. A slower serial rerun was cancelled before
switching to three independent workers. Initial literal comparisons were
corrected for the legacy JSON schema and for the lexer's rejection of
nonhexadecimal words. Fix F5 later moved that rejection into the String
literal check, which now reports `SURFACE_ABI: String literal requires
hexadecimal bytes` at the literal token. The `literal-diagnostic-initial`
and `literal-focused` rows come from before F5 and F6. `AUDITS-initial.json`
and `AUDITS-intermediate.json` retain the gate default and source inventory
integration failures. In `AUDITS.json`, the first seven rows are the
successful audits of the first run, the `rerun-` rows are the rerun audits
and the `seal-` rows ran when the record was sealed. The last four rows of
`REGRESSIONS.json` are the rerun build and suites. Rerun rows use `.`, the
repository root, as the working directory and name their record-relative
capture files.

## Review fixes and rerun

A review of the first record found seven defects:

- F1: `dev/DENOMINATORS.sha256` had stale rows for nine changed files and no
  rows for `src/string_literal.bend`, `examples/ERC20.asy`,
  `dev/erc20-source-test.py` and `dev/M2-SOURCE-ERC20.md`. It now has 322
  rows, and `SOURCES.json` pins it, as the storage-proofs record does.
- F2: three rows of `REGRESSIONS.json` came from drivers outside the
  repository. `drivers/` now keeps exact copies. `SOURCES.json` pins them
  under `drivers`. The `driver` and `driver_sha256` fields of the three rows
  name each copy and its SHA-256, and `FILES.sha256` lists both copies.
- F3: source `transfer` refuses a zero caller, but the reference accepts a
  zero-value transfer from the zero address and emits Transfer.
  `dev/M2-SOURCE-ERC20.md` names this third intentional difference. The
  ERC20 suite has a zero-caller probe, and `dev/stage-a-gates.py` and
  `dev/milestone-speed-test.py` expect `zero_caller=1` in its marker.
- F4: `README.md` and 13 gate pages named the 106-leg default. They now name
  `--m2-source-erc20` with 107 legs, and the `M2 modes:` usage line of
  `dev/stage-a-gates.py` lists it.
- F5: a String literal with nonhexadecimal digits was refused only by the
  Word path, with a SURFACE_WORD diagnostic at the `pure` token.
  `src/string_literal.bend` now refuses it with `SURFACE_ABI: String literal
  requires hexadecimal bytes` at the literal token.
  `dev/bend-catchalls.json` and `dev/native-carry.json` carry the new line
  and hash.
- F6: the ERC20 suite checks the full diagnostic of each malformed literal
  and requires one expected message for each String literal guard message in
  `src/string_literal.bend`.
- F7: the usage synopsis of `dev/stage-a-gates.py` lists
  `--m2-source-erc20`.

The rerun ran each step serially from the repository root. `/usr/bin/time
-l` cannot run in the sandbox of this machine: `sysctl kern.clockrate` is
not permitted, so it exits 1 and prints no resource usage. The first attempt
used it, so its step exits are masked, although every step printed its
success marker (`rerun/run1-time-l-sandbox.log`). The second attempt wraps
each step in `rerun/rerun-measure.py`, which reads the same wait4 resource
usage (`ru_maxrss` in bytes) and keeps the exit status of the step.
`rerun/rerun.log` is its log.

The DENOMINATORS step of the second attempt failed on one stale row,
`dev/stage-a-gates.py`: F7 changed that file after F4 had refreshed the row.
The row was refreshed, and a repeat of the DENOMINATORS and BEND2 steps
passed. The repeat overwrote the second-attempt captures of these two steps;
`rerun/RERUN.json` keeps their exit status, time and peak memory. Apart from
that row, no file outside this directory changed after the rerun started.

| Step | Command | Exit | Seconds | Peak RSS (bytes) |
| --- | --- | --- | --- | --- |
| build | `python3 -P dev/build.py build` | 0 | 1.0 | 228098048 |
| return-abi | `python3 -P dev/return-abi-test.py` | 0 | 46.1 | 470286336 |
| event-source | `python3 -P dev/event-source-test.py` | 0 | 59.6 | 291127296 |
| erc20-source | `python3 -P dev/erc20-source-test.py` | 0 | 69.6 | 146767872 |
| speed | `python3 -P dev/milestone-speed-test.py` | 0 | 0.3 | 35307520 |
| house | `python3 -P dev/house.py .` | 0 | 0.9 | 37175296 |
| carry | `python3 -P dev/carry-check.py .` | 0 | 0.1 | 21364736 |
| r0-audit | `python3 -P dev/r0-audit.py .` | 0 | 0.1 | 23986176 |
| trusted | `python3 -P dev/trusted-lines.py .` | 0 | 0.1 | 24461312 |
| denominators | `shasum -a 256 -c dev/DENOMINATORS.sha256` | 1 | 0.1 | 7192576 |
| bend2 | `shasum -a 256 -c dev/BEND2.sha256` | 0 | 0.0 | 7077888 |
| denominators (repeat) | `shasum -a 256 -c dev/DENOMINATORS.sha256` | 0 | 0.1 | 7323648 |
| bend2 (repeat) | `shasum -a 256 -c dev/BEND2.sha256` | 0 | 0.0 | 7094272 |
| r0-count (seal) | `zsh -f dev/r0-count.sh` | 0 | 0.2 | 65208320 |
| diff-check (seal) | `git diff --cached --check` | 0 | 0.1 | 11042816 |

The largest peak resident memory of one step was 470286336 bytes, below the
4 GB limit for one run. Not rerun on the final tree: the cumulative 107-leg
gate (`dev/stage-a-gates.py --m2-source-erc20`, selected by `dev/gates.sh`),
the other `make test` suites and the two drivers in `drivers/`. The
`literal-*` and `erc20-final` rows, `ERC20-RUN.json`, `cases.json` and
`erc20-evidence.tar.gz` remain the evidence of the first run.

This is focused evidence for group 6. The cumulative 107-leg M2 gate was not
run, before or after the review fixes, and M2 remains open. The fixture uses
a fixed genesis holder and the existing constructor event refusal. The
kernel Word refinement requirement remains open as recorded in the milestone
plan.

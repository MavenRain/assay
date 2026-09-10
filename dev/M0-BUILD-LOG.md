# M0 build log

This file is the assay M0 build log.  The kanon build log carried at the pin covers a different line of
work and stays in history;  read it with
`git -C /Users/oobi/Documents/assay show 2c2e6e6:dev/M0-BUILD-LOG.md`.  The rewrite of this path is
finding F-1 below.

## Stage 0 (2026-09-10)

Stage 0 is the import of kanon at 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf into
/Users/oobi/Documents/assay by the clone form of R-M0-2, plus the seven agent spikes (b) to (h) of
M0-PLAN.md section 2.  No commit was made by any agent.  One build ran, the spike (b) build of the
clone.  No software was installed.

### Deliverables

| path | spike | one measurable output |
| --- | --- | --- |
| the clone with its history | b | `git -C /Users/oobi/Documents/assay rev-list --count HEAD` prints 30 |
| dev/PIN | b | 41 bytes, the full sha and one newline |
| dev/import-check.sh | b | `IMPORT 2c2e6e6 ancestor=0 diff=0 git_kb=12140 commits=30` |
| dev/SPIKE-IMPORT.md | b | the three clone commands with their verbatim output |
| dev/TOOLCHAIN.md | a | one row per tool, plus the row `kanon (pin build)` |
| dev/denominator.sh | c | three DENOM lines, median of five timed runs |
| dev/denominators.json | c | the three frozen rows with the corpus block |
| dev/SPIKE-LINES.md | d | `TRUSTED-LINES kernel=3997/4000 encoder=246/600 OK` and six projections |
| dev/SPIKE-KECCAK.md | e | `cast sig 'transfer(address,uint256)'` prints 0xa9059cbb |
| dev/SPIKE-FORK.md | f | five opcode rows and the negative control |
| dev/SPIKE-TRACE.md | g | `TRACE bytes=20 rows=17 cast_rows=17 evm_rows=13 diff_ours_cast=0 diff_ours_evm=0` |
| dev/DENOMINATORS.sha256 | h | 28 lines, every line prints OK |
| dev/M0-BUILD-LOG.md | judge | this section |
| dev/MUTATION-LOG.md | judge | three mutants, three killed |

### Gates

Rerun on 2026-09-10 by the fixer.  Runner /Users/oobi/Documents/assay-m0/spikes/gates-2026-09-10.sh,
output /Users/oobi/Documents/assay-m0/spikes/gates-2026-09-10.log.  The judge reran all twelve gates
after that round;  its own printed lines are the section "The judge rerun (2026-09-10)" at the end of
this section, and they are the evidence of record.

| id | result | evidence, the printed line |
| --- | --- | --- |
| S0-G1 REPO | pass | `main`;  `2c2e6e6831a0b2cf3107fa4aad392606109a2bcf`;  remote -v prints 0 lines;  `30` commits |
| S0-G2 KANON-UNTOUCHED | pass | ancestor exit 0;  head `69f3be5198cda4334de4fd23b4ccc92cac595789` at start and at end;  status captures 0 lines at start and at end, diff exit 0, 0 lines;  worktree list shows no assay path |
| S0-G3 DENOMINATORS | pass | `shasum -a 256 -c dev/DENOMINATORS.sha256` exit 0, 28 lines, 0 lines not OK |
| S0-G4 DENOM-ROWS | pass | `DENOMJSON date=2026-09-10 pin=2c2e6e6831a0b2cf3107fa4aad392606109a2bcf rows=ocamlopt_ms_per_kloc,ocamlc_ms_per_kloc,assay_ms_per_kloc missing=none runs=5,5,5 values=448.4,50.7,40.8`;  `zsh -n dev/denominator.sh` exit 0;  the rerun prints three DENOM lines |
| S0-G5 IMPORT-SPIKE | pass | `IMPORT 2c2e6e6 ancestor=0 diff=0 git_kb=12140 commits=30`, exit 0, git_kb under 30720 |
| S0-G6 LINES-SPIKE | pass | `TRUSTED-LINES kernel=3997/4000 encoder=246/600 OK`;  six projections in dev/SPIKE-LINES.md, each with a basis file and its `wc -l`, each under its bound, total 3550 |
| S0-G7 KECCAK-SPIKE | pass | `0xa9059cbb`;  every recorded vector reruns to its digest, empty input `0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470` |
| S0-G8 FORK-SPIKE | pass | PUSH0, TLOAD, TSTORE and MCOPY answer with no error;  CLZ prints ` error: invalid opcode: opcode 0x1e not defined`;  the control prints ` error: invalid opcode: PUSH0` |
| S0-G9 TRACE-SPIKE | pass | `hex chars: 40 bytes: 20`;  evm rows 13, cast rows 17, both diffs empty in dev/SPIKE-TRACE.md |
| S0-G10 TOOLCHAIN | pass | `evm version 1.14.12-stable`;  `cast 0.3.0 (5a8bd89 2024-12-20T08:45:53.135759000Z)`;  ocamlopt and ocamlc `5.2.1`;  dune `3.24.2`;  node `v23.10.0`;  jq `jq-1.6`;  `ripgrep 15.1.0`;  `sd 1.0.0`;  `fd 10.4.2`;  shasum `6.02`;  `git version 2.50.1 (Apple Git-155)`;  `kanoncho 0.1.0`;  kanon, kanon.exe, solc, vyper, huffc, hevm and halmos print nothing under `command -v` |
| S0-G11 PROSE | pass | the byte built pattern prints 0 for each of the eight prose files of this stage |
| S0-G12 DEV-FILES | pass | every file of brief section 1 exists;  import-check.sh and denominator.sh are executable and pass `zsh -n`;  PIN is 41 bytes, `2c2e6e6831a0b2cf3107fa4aad392606109a2bcf` and one newline;  no dune-project diff;  wasm/ and runtime/ are present and untouched, since their deletion is Stage A;  `carried_md_exists: no`, and SPEC.md is a carried path at the pin with no diff, whose last commit is `b6a5af6 M1 Stage L: surface, gates and recursive metatheory`, so Stage 0 wrote neither |

`git -C /Users/oobi/Documents/assay status --porcelain` never lists _build, so the build output stays
out of the repository.

### Mutants

Three mutants, three killed, recorded with their commands in dev/MUTATION-LOG.md.  S0-M2 needed a
corrected recipe, which is finding F-2 below.

### The frozen numbers

The corpus is 24 OCaml files under the clone, 6215 lines, the sha256 of the concatenation recorded in
dev/denominators.json under `corpus.sha256_of_concatenation`.  Load at the freeze was
` 1:10  27 users, load averages: 53.20 50.80 43.65`.

| row | value, ms per kloc | median_ms | min_ms | max_ms | runs |
| --- | --- | --- | --- | --- | --- |
| ocamlopt_ms_per_kloc | 448.4 | 2786.6 | 2258.2 | 4921.2 | 5 |
| ocamlc_ms_per_kloc | 50.7 | 315.3 | 265.9 | 1015.9 | 5 |
| assay_ms_per_kloc | 40.8 | 253.5 | 165.8 | 288.9 | 5 |

The provisional figure 2135.8 ms per kloc sits beside the ocamlopt row in dev/denominators.json under
`provisional_reference`, measured under load 58 to 64 and marked PROVISIONAL.  This machine reads 448.4
under load 53.  The two numbers are reported together and neither binds.  No ratio prints at Stage 0
and M0-RATIO is gated at no M0 milestone (R-Q1a).

The S0-G4 rerun, under load 72, prints the same three rows with different numbers, which is information
about machine noise and not a finding:

| row | frozen | rerun | rerun over frozen |
| --- | --- | --- | --- |
| ocamlopt_ms_per_kloc | 448.4 | 739.8 | 1.65 |
| ocamlc_ms_per_kloc | 50.7 | 512.1 | 10.10 |
| assay_ms_per_kloc | 40.8 | 43.4 | 1.06 |

Rerun load line: `UPTIME  1:27  27 users, load averages: 72.27 64.71 54.42`.  The file marks itself
NOISY and a re-measurement is a new dated file, never an overwrite.

### Findings and how each was resolved

| id | severity | finding | resolution |
| --- | --- | --- | --- |
| F-1 | blocker | dev/M0-BUILD-LOG.md and dev/MUTATION-LOG.md were carried objects at the pin, unmodified, so the two logs of brief section 3.11 were not written and no Stage 0 mutation was recorded | Both paths were rewritten as the assay logs, with the dated `## Stage 0 (2026-09-10)` section of brief section 7 and one `## Stage 0` mutation section.  The three mutants S0-M1, S0-M2 and S0-M3 were run for the first time on 2026-09-10 by /Users/oobi/Documents/assay-m0/mutants/run-mutants.sh and are recorded with their commands and their kill lines.  The carried kanon logs stay in history and are read with `git show 2c2e6e6:dev/M0-BUILD-LOG.md` and `git show 2c2e6e6:dev/MUTATION-LOG.md` |
| F-2 | high | brief section 5 defines S0-M2 as the deletion of `cancunTime` alone, which does not kill the mutant on geth 1.14.12, because PUSH0 is a Shanghai opcode (EIP-3855);  dev/SPIKE-FORK.md worked around it without flagging the departure | Both recipes are run and recorded in dev/MUTATION-LOG.md, the literal one as a survivor with its evidence, the corrected one, which deletes `cancunTime` and `shanghaiTime`, as the kill.  dev/SPIKE-FORK.md section 3.1 now flags the departure by name.  The brief file itself is the caller's and is not edited by this stage |
| C-1 | high | dev/denominators.json is a carried path at the pin, so writing the Stage 0 deliverable modified carried history and the sentence of brief section 3.12, "every carried path is already committed history and shows no diff", is false for that path | The path is kept, because gates S0-G3, S0-G4 and S0-G12 name dev/denominators.json.  Three carried dev/ paths are modified by this stage, dev/denominators.json, dev/M0-BUILD-LOG.md and dev/MUTATION-LOG.md, and dev/DENOMINATORS.sha256 as well.  Brief section 3.12 is read as qualified: every carried path outside the dev/ deliverable list of brief section 1 shows no diff.  The carried content of each is retrievable at 2c2e6e6, and the pre-edit denominators.json is also kept at /Users/oobi/Documents/assay-m0/spikes/denom/carried-denominators-at-pin.json |
| F-IMPORT-1 | low | the exact command `checkout -b main 2c2e6e6` cannot succeed against a source whose default branch is also `main` | Recorded in dev/SPIKE-IMPORT.md, not worked around.  Stage A repeats `checkout -B main <pin>`, which is idempotent and lands the pin by object |
| F-IMPORT-2 | low | gate S0-G1 asks for a commit count over 100, and the whole kanon history at the pin is 30 commits, so that leg cannot pass on this source | Recorded in dev/SPIKE-IMPORT.md.  The judge measured `commits: 30` in the clone against `source_commits_at_pin: 30` and `source_commits_at_head: 31`, so the clone carries every commit the pin reaches, which is the property the leg intends to prove.  The bound 100 is a figure of the brief that the source contradicts |
| F-IMPORT-3 | low | a `set -u` build script aborts under the login rc files with `_telcoin_shared_target:7: CARGO_TARGET_DIR: parameter not set` | The spike (b) build ran under `zsh -f`.  No repository file is touched by the workaround |
| F-TOOL-1 | low | brief section 2 records elan and lake as ABSENT, and both are present on this machine | Measured, not quoted (R-P):  `command -v elan` prints `/Users/oobi/.elan/bin/elan` and `command -v lake` prints `/Users/oobi/.elan/bin/lake`.  dev/TOOLCHAIN.md records elan at `elan 4.2.3 (b6cec7e10 2026-06-08)` and lake as present with no default toolchain, since `lake --version` prints `error: no default toolchain configured`.  The AXIOMS gate keeps its SKIP line while no toolchain is configured |

### Decisions taken during the build

- S0-D1 The scratch layout is /Users/oobi/Documents/assay-m0/spikes/<spike>/ with one directory per
  spike, plus /Users/oobi/Documents/assay-m0/mutants/ for the judge copies.  Nothing under either path
  enters the repository.  No empty directory is left, so no .gitkeep is written.
- S0-D2 The three denominator rows and their rerun commands are recorded in dev/denominators.json under
  `rows.<row>.command` and `rows.<row>.method`, and the rerun is one call of dev/denominator.sh.
- S0-D3 The OCaml corpus is the 24 files listed in dev/denominators.json `corpus.files`, 6215 lines,
  compiled in `ocamldep -sort` order with every .mli before its .ml, into a fresh scratch directory per
  timed run.
- S0-D4 The scratch Cancun prestate is dev/SPIKE-FORK.md section 1, the fork field is `cancunTime` in
  the `config` block, and the invocation form is `evm run --prestate <file> --code <hex>`.
- S0-D5 The scratch 20-byte contract, its per-instruction listing and the pc column form are
  dev/SPIKE-TRACE.md sections 2 and 6.  The pc columns are compared in decimal, offset for offset.
- The four carried dev/ paths named under C-1 are modified by design, since the gate lines name them.
- Stage A work stays out: no CARRIED.md write, no SPEC.md write, no dune-project edit and no deletion
  of wasm/ or runtime/.

### Close

Everything is staged by the closer with `git -C /Users/oobi/Documents/assay add -A` and nothing is
committed.  The user runs one command, printed in
/Users/oobi/Documents/assay-m0/stage-0-commit-msg.txt.

### The judge rerun (2026-09-10)

The judge reran every gate of brief section 4 and every mutation check of brief section 5.  Runners
/Users/oobi/Documents/assay-m0/judge/gates-a.sh, gates-b.sh, mutants.sh and denom-rerun.sh, with
gates-a.log, gates-b.log, mutants.log and denom-rerun.log beside them.  All twelve gates pass and all
three mutants are killed.  The printed lines that differ from the rows above, or that the rows above
do not carry:

- S0-G1 `branch: main`, `head: 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf`, `remote_v_lines: 0`,
  `commits: 30`, `source_commits_at_pin: 30`, `source_commits_at_head: 31`.  The 100 bound of the leg
  is finding F-IMPORT-2 and the clone count equals the source count at the pin.
- S0-G2 `ancestor_exit: 0`, `kanon_head_now: 69f3be5198cda4334de4fd23b4ccc92cac595789`,
  `status_diff_exit: 0  start_lines: 0  mid_lines: 0`, `worktree_rows: 8` with no assay row.
- S0-G3 `g3_exit: 0`, `g3_lines: 28  not_ok:` empty.
- S0-G4 the judge rerun prints `DENOM ocamlopt_ms_per_kloc value=266.0 median_ms=1653.5 min_ms=1604.4
  max_ms=1795.9 runs=5 lines=6215`, `DENOM ocamlc_ms_per_kloc value=39.3 median_ms=244.1 min_ms=236.3
  max_ms=379.5 runs=5 lines=6215` and `DENOM assay_ms_per_kloc value=20.4 median_ms=126.6
  min_ms=113.2 max_ms=136.4 runs=5 lines=6215`, under
  `load averages: 53.76 59.43 55.92`.  Beside the frozen numbers the ratios are 0.59, 0.78 and 0.50,
  information only, since the file marks itself NOISY and no ratio binds at M0 (R-Q1a).  The sha256
  of dev/denominators.json is `0301e112141b45f3c1c70a3746c116eb0d8cf5775c44e7da85e1e304ef305d0b`
  before and after the rerun, so the rerun wrote no repository file.
- S0-G5 `IMPORT 2c2e6e6 ancestor=0 diff=0 git_kb=12140 commits=30`, `import_exit: 0`, and
  `git_kb_direct: 12140` from a direct `du -sk`, under the bound 30720.
- S0-G6 `TRUSTED-LINES kernel=3997/4000 encoder=246/600 OK`, exit 0, from the export at
  /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6.
- S0-G7 all eight recorded vectors rerun to their recorded digest, among them
  `cast keccak 'abc' -> 0x4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45` and
  `cast keccak 'Transfer(address,address,uint256)' ->
  0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef`.
- S0-G8 the four Cancun opcodes answer with empty output and exit 0, CLZ prints
  ` error: invalid opcode: opcode 0x1e not defined`, and the control with no `cancunTime` and no
  `shanghaiTime` prints ` error: invalid opcode: PUSH0`.  The prestate fork fields print as
  `cancun.json: {"shanghaiTime":0,"cancunTime":0,"pragueTime":null}`.
- S0-G9 `TRACE bytes=20 rows=17 cast_rows=17 evm_rows=13 diff_ours_cast=0 diff_ours_evm=0` and
  `S0-G9 PASS`.  The judge also read the two columns directly:  `evm run --json` prints pc
  0 2 3 4 6 11 12 13 14 15 16 18 19, and `cast disassemble` prints those offsets plus the four guard
  bytes 7 to 10, 17 rows over 40 hex characters, which is 20 bytes.
- S0-G10 every present row reruns to its recorded version, and the absent rows print nothing under
  `command -v`.  Finding F-TOOL-1 covers elan and lake.  `evm --version` is the form that answers;
  `evm version` prints `No help topic for 'version'`.
- S0-G12 `zsh_n_import: 0`, `zsh_n_denominator: 0`, `pin_bytes: 41`, `dune_project_diff_lines: 0`,
  `carried_md_exists: no`, `wasm_dir: present  runtime_dir: present`, and no tracked deletion.

### The fixer round rerun (2026-09-10)

Every gate of brief section 4 was rerun after the fixes above.  All twelve pass.  Output
/Users/oobi/Documents/assay-m0/spikes/gates-2026-09-10-post-fix.log.  The S0-G4 rerun of that round
prints `DENOM ocamlopt_ms_per_kloc value=425.9`, `DENOM ocamlc_ms_per_kloc value=133.7` and
`DENOM assay_ms_per_kloc value=38.5`, three more readings of the same rows on a moving machine, which
is information beside the frozen numbers and not a change to them.  dev/DENOMINATORS.sha256 was not
rewritten, because no file it covers changed in this round: the round touched dev/M0-BUILD-LOG.md,
dev/MUTATION-LOG.md and dev/SPIKE-FORK.md only, and the manifest covers dev/denominator.sh,
dev/denominators.json, dev/import-check.sh, dev/PIN and the 24 corpus files.  `shasum -a 256 -c
dev/DENOMINATORS.sha256` still exits 0 over 28 lines with 0 lines not OK.

## Stage 0 close by hand (2026-09-10)

S0-G11 PASS.  The em-dash and en-dash sweep over the thirteen files prints 0 and 0 for each of
dev/TOOLCHAIN.md, dev/SPIKE-IMPORT.md, dev/SPIKE-LINES.md, dev/SPIKE-KECCAK.md, dev/SPIKE-FORK.md,
dev/SPIKE-TRACE.md, dev/M0-BUILD-LOG.md, dev/MUTATION-LOG.md, dev/import-check.sh,
dev/denominator.sh, dev/PIN, dev/denominators.json and dev/DENOMINATORS.sha256, so no replacement
was made and no hashed file was touched.

S0-G2 end leg PASS.  `cmp` exits 0 on the status pair
(assay-m0/spikes/import/kanon-status-start.txt against kanon-status-end.txt, 0 lines each) and 0 on
the head pair (assay-m0/judge/kanon-head-start.txt against kanon-head-end.txt), with the kanon HEAD
`69f3be5198cda4334de4fd23b4ccc92cac595789` at both ends.  `git -C /Users/oobi/Documents/kanon
worktree list` prints 8 rows (kanon itself plus kan-rust-lang-kanon-pin, kanon-m2-corpus,
mechanism-lang-kanon-pin, memsave-kanon-pin, tick-kanon-pin, trawl-kanon-pin and trice-kanon-pin)
and no row names an assay path.

The judge of run wf_d25195e4-0c3 passed the other 11 gates, and its sub-budget cut fell before
S0-G11 and before the close, so this section was written by the closer.

Stage 0 gates: 12 of 12 green after the close.


## Stage A (2026-09-10)

Base: `858deeb`, the committed Stage 0 import.  Stage A builds the assay
checker driver, removes `wasm/` and `runtime/` and their executable consumers,
and adds the assay carry, pin and six artifact budget checks.  The inherited
kernel and surface inventory is 31 files with zero changed bytes.  The kernel
remains 3997 lines.  No upstream source checkout was changed.

The driver preserves check, checked printing, erasure and axiom disclosure.
It accepts `.asy` input and the inherited `.kan` fixtures.  Valid emit syntax
checks and erases the input, then exits 2 with EVM_BACKEND_UNAVAILABLE and
writes no file.  Invalid arguments exit 64.  EVM emission remains Stage E.

CARRIED.md records the required driver scope correction: the actual imported
driver has three Wasm callers outside dispatch_emit.  Removing the backend
requires removing build and run as well.  The inherited library names remain
unchanged so even the lib and surface dune files match the pin.

Validation: `zsh -f dev/gates.sh` passed all 11 legs.  BUILD reports zero
errors and zero warnings.  The full inherited kernel suite and 20 surface
cases pass.  All 24 driver checks and all 13 gate mutations pass.  The frozen
Stage 0 denominator manifest is unchanged and verifies from the repository
root.  The first battery exposed a wrong manifest working directory in the
new runner; the corrected battery passes.  No denominator was remeasured.

Full per-leg output and the final summary are in
`dev/validation/2026-09-10-stage-a/`.  The validation checkout is
`/Users/oobi/Documents/gpt11/assay-stage-a`.  The capture is
`.kanon-exec/run-lZCFny` in that checkout.  The kernel, surface and backend
source status is unchanged between validation and staging.

The gate battery is Stage A only.  It prints B-F as pending and makes no
M0-TRACE or M0 exit claim.  Historical Wasm tests and runtime gates no longer
belong to the active target.  Both inherited checker executables remain in
the build and battery.  Stage B, keccak and selector vectors, is next.

No commit was made.  The changes are prepared for staging in the assay
repository.  The optional commit message is `dev/STAGE-A-COMMIT.txt`.

### Review round 2026-09-10 (Stage A)

| id | severity | finding | files |
| --- | --- | --- | --- |
| D-1 | high | The plan's emit form `assay emit FILE -o DIR` exits 64, because the driver keeps the inherited wasm arity `--export NAME` | bin/assay.ml, dev/stage-a-test.py, README.md |
| A-1 | high | R0-AUDIT never reads SPEC.md, so its documented bound (every naming carries a refusal citation) is unimplemented | dev/r0-audit.py, dev/stage-a-test.py |
| A-2 | high | HOUSE checks three of the five house rules of plan section 11, and its mutable-state leg never reads the code Stage A writes | dev/house.sh, dev/stage-a-test.py |
| D-2 | medium | The subcommands the plan declares at M0 (trace, diff, run, deploy, test) are absent, and the DRIVER leg pins them as typos | bin/assay.ml, dev/stage-a-test.py, README.md |
| A-4 | medium | CARRY reports a deleted carried file with the same word as a smuggled-in file, and still prints files=31 when 30 remain | dev/carry-check.py, dev/stage-a-test.py |
| B-1 | medium | README and R-M0-1 state an accepted source-extension set that bin/assay.ml never checks | bin/assay.ml, dev/stage-a-test.py, SPEC.md, README.md |
| A-6 | medium | TRUSTED-LINES prints numbers it does not enforce, and never prints the ratified total 3550 | dev/trusted-lines.py |

Refuted: 0.

Merged and dropped: 11.  A-3 merged into A-2 (same file dev/house.sh, same
defect class).  A-5 merged into D-2 (same file bin/assay.ml, same defect).
C-5 merged into A-4 (same file dev/carry-check.py, same defect).  D-4 merged
into B-1 (no extension check against a documented accept list).  D-3 merged
into A-6 (the printed numbers are not the enforced or ratified ones).  Cut at
the 7-finding cap: C-1 (dev/CARRIED.md:6 carry-check.sh claim, documentation
only), C-2 (dev/TOOLCHAIN.md:35 records kanon.exe, file untouched), C-3
(SPEC.md:373-375 ENCODER-SUBSET leg in the present tense), C-4 (REACTOR.md,
dev/runtime-test.mjs and dev/agreement.py still describe the deleted Wasm
backend), A-7 (three gate rows of M0-PLAN.md section 8 quote lines the
shipped scripts do not print), B-2 (dev/gates.sh:3 needs python3 3.11 or
newer for -P, a portability note).

Gate result: `/Users/oobi/Documents/assay-stage-a-review/gates-A-1.log`,
GATES-OK, pass=11 fail=0 porcelain_before=47 porcelain_after=47 unstaged=0.
`STAGE-A OK`, `EXIT 0`, `MUTANTS-TAIL: MUTANTS killed=13/13 OK`,
`DRIVER-TAIL: DRIVER cases=24 OK`.

Tier: the finder, the builder and the closer ran opus/medium because the
Fable tier probe died on the reasoning_extraction classifier
(req_011Ceux88aMuSgW4kmsAUKPX).

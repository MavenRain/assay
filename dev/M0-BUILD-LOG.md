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

## Stage B (2026-09-10)

Base: `f6ddcd618c0c5c51adfc722318d391254c82672c`, the committed Stage A.
Work and validation root: `/Users/oobi/Documents/gpt1/assay-stage-b`.
The existing README deployment roadmap edit is preserved in this slice.

`keccak/keccak.ml` adds the `assay_keccak` library.  The implementation uses
immutable five-lane tuples, 24 rounds, a 136-byte rate and suffix `0x01`.
`keccak256` hashes arbitrary bytes and returns 64 lowercase hex digits.
`selector` hashes a canonical ABI signature and returns its first eight hex
digits.  Neither result has a `0x` prefix.  Canonical signature parsing
belongs to the later ABI layer.  The private state and round helpers stay
behind the module signature, and the KECCAK-VEC leg pins that signature
against `dev/keccak-iface.txt`.

The algorithm follows the [Keccak team specification summary](https://keccak.team/keccak_specs_summary.html).
The eight recorded spike rows and 27 additional vectors pass against frozen
values and live `cast` output.  The additional vectors cover arbitrary
bytes, lane boundaries, lengths 135/136/137 and 271/272/273, a 4096-byte
message, and three error signatures.  Their oracle version, commands and
input construction are in `dev/keccak-vectors.json`.  No cryptographic
dependency was added.  The kernel and surface remain byte-exact at the pin.

Validation command, from the work root:

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

Final result: 13 PASS legs, zero FAIL legs, `STAGE-B OK`, exit 0.
The complete final transcript and per-leg logs are in
`dev/validation/2026-09-10-stage-b/`.  The source hash manifest identifies
the code and gate files used for this result.

| measurement | result |
| --- | --- |
| BUILD | 0 errors, 0 warnings |
| PIN-CARRY | files=31/31 diff=0 unlisted=0 |
| R0-COUNT and R0-AUDIT | OK |
| HOUSE | seven legs OK; mutable-state roots include lib and keccak |
| TRUSTED-LINES | kernel=3997; keccak=89/250; new total=89/3550 |
| SUITE-KERNEL and SUITE-SURFACE | OK; surface=20/20 |
| DRIVER | cases=24 OK |
| MUTANTS | killed=13/13 OK |
| DENOMINATORS | all frozen hashes OK |
| KECCAK-VEC | vectors=35 ok=35 adapter=5 OK |
| KECCAK-MUTANTS | killed=4/4 control=OK |

Harness corrections during validation: mutation copies now live outside
the enclosing Dune workspace and build only the Keccak library and adapter.
A build error never counts as a mutation kill.  Host load reached 80 to 123.
An earlier carry leg exceeded 30 seconds, and the inherited mutation leg
exceeded 120 seconds.  Its deadline is now 300 seconds; all 13 checks and
their required markers remain.  The final run passed carry in 0.9 seconds,
inherited mutants in 3.9 seconds and Keccak mutants in 5.1 seconds, at host
load 39.

Stage C, the assembler and listing, is next.  EVM emission remains pending
Stage E.  No M0 exit or performance ratio is claimed.  No commit was made.
The proposed commit message is `dev/STAGE-B-COMMIT.txt`.

### Review round 2026-09-10 (Stage B)

Seven findings were kept and all seven are fixed in one fix round.

| id | severity | finding | files |
| --- | --- | --- | --- |
| A-1 | medium | The hex adapter test/keccak_vec.ml has no mutation coverage: a widened hex decoder survives every Stage B leg | dev/keccak-test.py, dev/stage-a-gates.py, dev/M0-BUILD-LOG.md, README.md, dev/MUTATION-LOG.md, dev/validation/2026-09-10-stage-b/ |
| B-1 | medium | README M4 roadmap sentence contradicts the shipped diagnostic, which prints PENDING (M1) for deploy and test | README.md |
| A-2 | low | No gate pins the sealed signature of assay_keccak, so an encapsulation regression passes the whole ladder | dev/keccak-iface.txt (new), dev/keccak-test.py, README.md, dev/M0-BUILD-LOG.md, dev/MUTATION-LOG.md, SOURCES.json |
| A-3 | low | An oracle disagreement is reported as an implementation failure: every row prints got equal to want and the cast output is discarded | dev/keccak-test.py, dev/MUTATION-LOG.md, KECCAK-VEC.log |
| B-2 | low | dev/gates.sh forwards "$@" into an argv check that rejects every extra argument, so any argument aborts the ladder with a usage line naming a different script | dev/gates.sh |
| C-3 | low | Source hash manifest omits dev/dunecho.sh, a gate file the KECCAK-MUTANTS result depends on | dev/validation/2026-09-10-stage-b/SOURCES.json |
| D-1 | low | README states M4 deployment deliverables that no ruling and no plan line contains (merges C-1) | README.md |

Refuted: 0 findings.

Merged and dropped: 3 findings.  C-1 was merged into D-1 (same file and
same defect: README.md:37-39 ships unratified M4 deployment scope under the
R-8a citation; D-1 concedes that R-4 grounds the chain-profile clause).
B-3 was cut at the seven-item cap as the weakest low: README.md:65 names
cast with no floor and dev/keccak-test.py:38-43 prints the version without
an assertion, but the gate records the version on the KECCAK-ORACLE line
and the installed cast matches the validated one.  C-2 was cut at the cap
as the weakest remaining low: the pronoun in the timing sentence is
ambiguous, but the next sentence discloses the carry timing, so no
statement is false and no gate is affected.

Gate result, log `assay-stage-b-review/gates-B-1.log`:

| line | value |
| --- | --- |
| STAGE-B | STAGE-B OK |
| EXIT | EXIT 0 |
| MUTANTS tail | MUTANTS killed=13/13 OK |
| DRIVER tail | DRIVER cases=24 OK |
| KECCAK-VEC tail | KECCAK-VEC vectors=35 ok=35 adapter=5 OK |
| KECCAK-MUTANTS tail | KECCAK-MUTANTS killed=4/4 control=OK |

All 13 legs passed, pass=13 fail=0, porcelain 32 before and after, and
unstaged 0.

The finder, the builder and the closer ran opus/medium because the Fable
tier probe died on the reasoning_extraction classifier
(req_011Ceux88aMuSgW4kmsAUKPX).

## Stage C (2026-09-10)

Base: `cfcdbf11eb43cc20d32f24e1d8e0c687cac88e0c`, the committed Stage B.
The implementation and validation ran in
`/Users/oobi/Documents/gpt1/assay-stage-c`.  The checked delta is prepared for
`/Users/oobi/Documents/assay`.  No commit was made.

The new `assay_asm` library contains `asm/asm.ml` and `asm/listing.ml`.
The assembler accepts blocks with declared incoming heights, validates every
instruction and edge, and returns a sealed program.  It checks underflow,
the 1024-word limit, conditional and unconditional edges, loops and physical
fallthrough.  Temporary label pushes count toward the peak.  Control
instructions cannot hide inside block bodies, and dynamic jumps are refused.
Unreachable blocks are checked against their declarations too.

One layout pass records all label offsets.  The encoding pass resolves
forward and backward operands at explicit PUSH widths from 1 to 32 bytes.
Duplicate, missing, unmarked and out-of-width targets return named errors.
The listing decodes bytes independently of the block representation.  It
rejects malformed hex, undefined opcodes and incomplete PUSH operands.
`dev/ASM-PROVENANCE.md` records the pinned geth source and comparison rules.

The first local checks found and corrected two fixture assumptions: the
diamond join is at hex PC 0x11, and geth disassembly uses hex PCs.  The
assembler already emitted the correct diamond label.  The installed cast
prints DIFFICULTY for byte 0x44, so the comparator normalizes that single
alias to PREVRANDAO in the oracle transcripts, at the offsets where the input
byte is 0x44.  All PC and immediate data remain exact.

Validation command, run through `kanon-wait` and `kanon-exec`:

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH \
  -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

All 16 legs pass.  Full evidence and source hashes are in
`dev/validation/2026-09-10-stage-c/`.

| Gate | Result |
| --- | --- |
| BUILD | 0 errors, 0 warnings |
| PIN-CARRY, R0-COUNT, R0-AUDIT, HOUSE | PASS |
| SUITE-KERNEL, SUITE-SURFACE | PASS |
| DRIVER | 24 cases |
| MUTANTS | 13/13 killed |
| DENOMINATORS | unchanged hash, PASS |
| KECCAK-VEC | 35/35, adapter=5 |
| KECCAK-MUTANTS | 4/4 killed, restored control OK |
| STACK-HEIGHT | 64 assembly cases, 30 height-checked blocks, 149 opcode rows, 370 effect probes |
| DISASM-3WAY | ours=272 cast=272 evm=272, 7 fixtures, 38 negative cases |
| ASM-MUTANTS | 6/6 killed, restored stack and disassembly controls OK |
| TRUSTED-LINES | kernel=3997, assembler=238/600, listing=54/250, keccak=89/250 |

The measured new total is 381/3550.  Emitter, ABI and layout rows remain
pending.  `panicscan --strict asm test/asm_cases.ml` reports no findings.
The carried kernel, surface and driver sources are unchanged.

Stage D adds the Cancun prestate, reference contract and execution gates.
Stage C only disassembles EVM bytes.  No M0 exit or ratio is claimed.
The proposed commit message is `dev/STAGE-C-COMMIT.txt`.

### Review round 2026-09-10 (Stage C)

Seven findings were kept and all seven are fixed in one fix round.

| id | severity | finding | files |
| --- | --- | --- | --- |
| C-1 | medium | No leg pins the 64 assembly cases: STACK-HEIGHT stays green at 63 or at 15 | dev/asm-test.py, dev/stage-a-gates.py |
| A-2 | medium | Asm.heights is never checked for a block with nonzero incoming height, so two metadata mutants survive both Stage C legs | test/asm_cases.ml |
| C-2 | medium | MUTATION-LOG records witness strings that the ASM-MUTANTS kill rule does not use | dev/MUTATION-LOG.md |
| A-3 | low | DISASM-3WAY summary prints one counter three times as ours=, cast= and evm= | dev/asm-test.py |
| A-4 | low | The STACK-HEIGHT suite line reports blocks=6, a constant fixture length that does not move with the run | test/asm_cases.ml, dev/asm-test.py, dev/M0-BUILD-LOG.md, dev/validation/2026-09-10-stage-c/README.md |
| B-2 | low | The DIFFICULTY to PREVRANDAO alias is unscoped: it rewrites our own listing too, and any byte, not the 0x44 the documents name | dev/asm-test.py, README.md, dev/ASM-PROVENANCE.md, dev/M0-BUILD-LOG.md |
| D-1 | low | DISASM-3WAY is the only leg whose success marker omits its own gate id | dev/stage-a-gates.py |

Refuted: 0 findings.  No finding was refuted at the verify stage.

Merged and dropped: 5 findings.  A-1 was merged into C-1: same file and
line (dev/asm-test.py:38) and the same defect, the unpinned cases= count.
C-1 is the clearer statement because it names the three documents that
record 64.  A-1's cases=15 probe is folded into the C-1 detail.  C-5 was
merged into B-2: same file and line (dev/asm-test.py:80) and the same
defect, an unscoped DIFFICULTY to PREVRANDAO rewrite.  B-2 states the
stream scope, C-5 states the byte scope and the two document sentences;
the merged item carries both and the fix hint covers both.  B-1 was cut
at the 7 finding cap, ranked last of the lows: the staged diff of
dev/gates.sh is one line, --keccak to --asm; the no argument forwarding
property is pre-existing and was deliberately installed by the Stage B
B-2 fix, so this slice did not introduce the defect.  It is confirmed on
the merits (ARGV ['--asm'] for every invocation) but it loses the
introduced-by-this-slice tie break to the four kept lows.  C-3 was cut at
the cap: the verifier corrected a load bearing part of the claim, because
no gate script reads CARRIED.md, so the sentence "the leg checks the
carried inventory named in CARRIED.md" is unsupported, and dev/PIN is in
fact already hash pinned by dev/DENOMINATORS.sha256, which lists
789550fa...  dev/PIN.  What remains is that the validation README
sentence is looser than the 33 rows and that SPIKE-TRACE.md is listed
although only SPIKE-KECCAK.md is read by a leg, which is documentation
wording below the bar of the kept lows.  C-4 was cut at the cap, lowest
value of the confirmed lows: the measurement holds (STAGE-A max=72,
STAGE-B max=70, STAGE-C max=73 at line 8), but 72 columns is a convention
of the earlier templates, not a rule any gate or house check enforces,
and the defect is cosmetic wrap width in a commit template.  It is ranked
below four gate integrity lows.

Closing gate run on a copy, log
`/Users/oobi/Documents/assay-stage-c-review/gates-C-1.log`: pass=16 fail=0,
porcelain_before=46, porcelain_after=46, unstaged=0.

```
STAGE-C OK
EXIT 0
MUTANTS-TAIL: MUTANTS killed=13/13 OK
DRIVER-TAIL: DRIVER cases=24 OK
KECCAK-VEC-TAIL: KECCAK-VEC vectors=35 ok=35 adapter=5 OK
KECCAK-MUTANTS-TAIL: KECCAK-MUTANTS killed=4/4 control=OK
STACK-HEIGHT-TAIL: STACK-HEIGHT blocks=30 cases=64 opcodes=149 effect_cases=370 OK
DISASM-3WAY-TAIL: DISASM-3WAY ours=272 cast=272 evm=272 fixtures=7 negative=38 OK
ASM-MUTANTS-TAIL: ASM-MUTANTS killed=6/6 control=OK
TRUSTED-TAIL: TRUSTED-LINES total=381/3550 ratified=3550 TRUSTED-LINES OK
```

The finder, the builder and the closer ran opus/medium because the Fable
tier probe died on the reasoning_extraction classifier
(req_011Ceux88aMuSgW4kmsAUKPX).  The Stage C probe on 2026-09-10 13:4x was
live, PROBE OK 39, but Fable subagents die mid-run 5/5 on the same
classifier, so the opus pin stays and the rulings are reported unmet.

After the close, C-4 (a low cut at the finding cap) was fixed by hand:
line 8 of dev/STAGE-C-COMMIT.txt was 73 columns. One word was removed, so
every line of that file is at most 72 columns. The review commit message
mirrors the file.

## Stage D (2026-09-10)

Base: `7ff9921b1b91deff84c4b8a5e416febffa60fa97`, the committed and reviewed
Stage C.  Work and validation root:
`/Users/oobi/Documents/gpt1/assay-stage-d`.  No commit was made.

Stage D adds `reference/ref20.evm`, `reference/ref20-init.evm`,
`evm/fixtures/cancun.json`, `dev/reference-test.py` and `dev/fork-check.sh`.
The runtime is the 20-byte Stage 0 reference.  Each instruction has a comment.
The creation prefix copies and returns those bytes.  The gate reads the
annotated source, checks the Stage C assembler and listing, compares cast,
then runs geth with the explicit prestate and fixed sender, receiver and gas.

M0-TRACE checks 17 static rows and the exact 13-step execution path.  PCs
7 through 10 are the four unexecuted guards.  Each executed opcode number,
mnemonic and stack snapshot must match.  The return data is the 32-byte
value 42, and storage contains only slot zero = 42.  CREATE-EQ checks the
creation trace, returned runtime and installed account code.  The constructor
has no storage effect.  A zero process exit alone never establishes success:
the gates check geth's step and summary error fields too.

FORK-DRIFT probes PUSH0, TLOAD, nonzero TSTORE/TLOAD and MCOPY, plus the
expected CLZ refusal.  The negative controls retain the measured Stage 0
correction: removing only `cancunTime` leaves PUSH0 enabled but rejects TLOAD;
removing both `cancunTime` and `shanghaiTime` rejects PUSH0.  Both recipes
run, and the plain PUSH0 diagnostic is checked as well as the JSON error.

Validation command, through `kanon-wait` and `kanon-exec`:

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH \
  -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

All 21 legs pass.  The complete logs, oracle receipts and selected input
hashes are in `dev/validation/2026-09-10-stage-d/`.

| Gate or measurement | Result |
| --- | --- |
| Inherited Stage A-C gates | 16/16 PASS |
| FORK-DRIFT | PUSH0, TLOAD, TSTORE and MCOPY execute; CLZ is refused |
| M0-TRACE | reference bytes=20, listing=17, cast=17, evm=13, skipped=4 |
| Runtime state | slot zero=42, return word=42 |
| CREATE-EQ | 20 bytes returned and installed exactly |
| REFERENCE-CHECKS | 32 corrupt captures rejected, 2 controls pass |
| REFERENCE-MUTANTS | 8/8 killed, 3 restored controls pass |
| Runtime code size and gas | 20 bytes, 22,232 gas |
| Creation code size and gas | 30 bytes, 4,022 gas |
| TRUSTED-LINES | kernel=3997, assembler=238/600, listing=54/250, keccak=89/250 |

The gas figures are geth execution measurements, without transaction
intrinsic gas.  They are reported and not bound.  The new trusted-code total
stays 381/3550.  No OCaml source, carried kernel, surface or driver changed.
The bounded OCaml build ran, and `dev/validation/2026-09-10-stage-d/BUILD.log`
records 0 errors and 0 warnings.  No tool was installed.

Stage E adds source emission, the five output files, recognizers and the
proof seed.  M0-TRACE is explicitly marked `scope=reference` here.  No final
M0 exit or performance ratio is claimed.  The proposed commit message is
`dev/STAGE-D-COMMIT.txt`.

### Review round 2026-09-10 (Stage D)

Eight findings were kept and all eight are fixed in two fix rounds.

| id | severity | finding | files |
| --- | --- | --- | --- |
| D-1 | medium | CREATE-EQ prints neither declared key of M0-PLAN section 8, and no repository document declares the split | reference/README.md |
| B-1 | medium | An outer leg timeout discards all partial output and leaks the mutant clone under TMPDIR | dev/stage-a-gates.py, dev/reference-test.py |
| B-2 | medium | The README promises a saved receipt for every oracle call, but the mutant-clone calls leave none | reference/README.md |
| ND-1-1 | medium | new defect from the fixes: the round 1 TMPDIR sweep could delete the clone of a concurrent run | dev/reference-test.py, dev/validation/2026-09-10-stage-d/SOURCES.json |
| B-3 | low | The inner subprocess timeouts sum far past the leg deadlines, so they can never fire first | dev/reference-test.py |
| B-4 | low | The MUTATION-SITE guard cannot fire for the two prestate mutants | dev/reference-test.py |
| C-3 | low | The documented reference commands fail with a raw Errno message when the build artifact is absent | dev/reference-test.py, reference/README.md |
| C-1 | low | Stage D build log states a disk guard, a threshold, a skip marker and sibling tree sizes that no repository file defines | dev/M0-BUILD-LOG.md |

Refuted: 0 findings.  No finding was refuted at the verify stage.

Merged and dropped: 3 findings.  B-5 was merged into C-1: same file and
same defect (dev/M0-BUILD-LOG.md:575, the disk guard, the 30 GiB threshold
and the skip marker).  C-1 is the clearest statement because it also names
the 19/21 MiB figures and the contradiction with the archived BUILD.log.
D-2 was merged into C-1: same file and same defect
(dev/M0-BUILD-LOG.md:575-576).  D-2's useful extra, that the M0-PLAN
section 11 free-disk rule lives outside the repository and is not cited
here, is folded into the C-1 fix hint.  C-2 was cut at the 7-finding cap
as the least consequential survivor: dev/validation/2026-09-10-stage-d/
SOURCES.json omits dev/SPIKE-FORK.md, but the folder README discloses that
the inventory is selective and not a complete dependency graph, so nothing
in the tree makes a false statement and no gate depends on the entry.
Re-file it as a one-line evidence addendum if a later stage needs the fork
spike rehashable.

Gate result after the fixes, log
`/Users/oobi/Documents/assay-stage-d-review/gates-D-2.log`: 21 PASS, 0 FAIL,
porcelain 60/60, unstaged 0.

```
STAGE-D OK
EXIT 0
MUTANTS-TAIL: MUTANTS killed=13/13 OK
DRIVER-TAIL: DRIVER cases=24 OK
KECCAK-VEC-TAIL: KECCAK-VEC vectors=35 ok=35 adapter=5 OK
KECCAK-MUTANTS-TAIL: KECCAK-MUTANTS killed=4/4 control=OK
STACK-HEIGHT-TAIL: STACK-HEIGHT blocks=30 cases=64 opcodes=149 effect_cases=370 OK
DISASM-3WAY-TAIL: DISASM-3WAY ours=272 cast=272 evm=272 fixtures=7 negative=38 OK
ASM-MUTANTS-TAIL: ASM-MUTANTS killed=6/6 control=OK
TRUSTED-TAIL: TRUSTED-LINES total=381/3550 ratified=3550 TRUSTED-LINES OK
FORK-DRIFT-TAIL: FORK-DRIFT push0=OK tload=OK tstore=OK mcopy=OK clz=INVALID OK
M0-TRACE-TAIL: REFERENCE-MEASURE runtime_bytes=20 gas=22232 M0-TRACE scope=reference bytes=20 listing=17 cast=17 evm=13 skipped=4 storage=42 return=42 OK
CREATE-EQ-TAIL: CREATE-MEASURE init_bytes=30 gas=4022 CREATE-EQ bytes=20 returned=20 installed=1 OK
REFERENCE-CHECKS-TAIL: REFERENCE-CHECKS cases=29 controls=2 OK
REFERENCE-MUTANTS-TAIL: REFERENCE-MUTANTS killed=8/8 controls=3 OK
```

Tier: the finder, the builder and the closer ran opus/medium because the
Fable tier probe died on the reasoning_extraction classifier
(req_011Ceux88aMuSgW4kmsAUKPX); the Stage C probe on 2026-09-10 13:4x was
live but Fable subagents die mid-run 5/5 on the same classifier, so the
Stage D run on 2026-09-10 20:4x keeps the opus pin without a new probe and
the rulings are reported unmet.

Pass 2, lens A rerun.  The lens A finder (gate logic and mutation
adequacy) died in the workflow run on the safety classifier with no
result, so lens A ran again as a standalone finder on the tree that holds
the pass 1 fixes.  Five findings were kept and all five are fixed in one
fix round.  The verifier downgraded A-1 from medium to low: the frozen
receiver address holds no hex letter, so the trace leg cannot fail on it
today.

| id | severity | finding | files |
| --- | --- | --- | --- |
| A-2 | medium | Four requires could be neutralized with every leg green: REFERENCE-ASSEMBLER, TRACE-ACCOUNT, TRACE-SKIP and CREATE-ACCOUNT | dev/reference-test.py, dev/stage-a-gates.py, dev/MUTATION-LOG.md |
| A-1 | low | verify_trace indexed the geth state dump by the literal receiver address, case-sensitively, while verify_create lowercased its keys | dev/reference-test.py |
| A-3 | low | TRACE-SKIP could never fail: the skipped set is a function of values already pinned | dev/reference-test.py |
| A-4 | low | A renamed or truncated prestate fixture failed with a bare key error or decoder message and no gate code | dev/reference-test.py |
| A-5 | low | The M0-TRACE, CREATE-EQ, REFERENCE-CHECKS, REFERENCE-MUTANTS and FORK-DRIFT marker values were literals | dev/reference-test.py |

Refuted: 0 findings.  No finding was refuted at the verify stage.

The check stage confirmed all five fixes on its own copies and reported
one new item, ND-A-1: the recorded run time in the pass 1 tier paragraph
above reads 20:4x, while the pass 1 ladder copy still read 17:xx.  The
closer made that correction by hand after the copy was taken, because
17:xx was a template value and the Stage D run started at 20:4x.  The
value stays, and this paragraph records the edit.

The A-2 fix adds three corrupt-capture cases (trace-21, create-22 and
assembler-row) and no ninth mutant: every in-tree edit of
reference/ref20.evm fails at REFERENCE-BYTES first, and the fixture
column comes from test/asm_cases.ml, outside the mutants() copy list.
The printed cases= count is now a counter in the rejection path and
moves from 29 to 32.  Every document that repeated 29 is amended, and
dev/validation/2026-09-10-stage-d/REFERENCE-CHECKS.log is re-captured
from the post-fix ladder.  SOURCES.json is refreshed for
dev/reference-test.py and dev/stage-a-gates.py.  No line of M0-PLAN.md
or RATIFICATIONS.md pins the count (RATIFICATIONS.md line 62).

Gate result after the pass 2 fixes, log
`/Users/oobi/Documents/assay-stage-d-review/gates-final.log`: 21 PASS,
0 FAIL, porcelain 60/60, unstaged 0.  Every tail line is identical to
the pass 1 result except the REFERENCE-CHECKS count.

```
STAGE-D OK
EXIT 0
FORK-DRIFT-TAIL: FORK-DRIFT push0=OK tload=OK tstore=OK mcopy=OK clz=INVALID OK
M0-TRACE-TAIL: REFERENCE-MEASURE runtime_bytes=20 gas=22232 M0-TRACE scope=reference bytes=20 listing=17 cast=17 evm=13 skipped=4 storage=42 return=42 OK
CREATE-EQ-TAIL: CREATE-MEASURE init_bytes=30 gas=4022 CREATE-EQ bytes=20 returned=20 installed=1 OK
REFERENCE-CHECKS-TAIL: REFERENCE-CHECKS cases=32 controls=2 OK
REFERENCE-MUTANTS-TAIL: REFERENCE-MUTANTS killed=8/8 controls=3 OK
```

Tier for pass 2: the finder, the builder and the checker kept the
opus/medium pin with the explicit tier markers, and the verifier ran
opus/high.  No new Fable probe was made, so the three tier rulings stay
reported unmet.

## Stage E (2026-09-10)

Base: `8d4bd9de0249340a6c8316f57ec6cf65b999cc23`, the committed Stage D
slice.  Work ran in `/Users/oobi/Documents/gpt1/assay-stage-e`.  The main
assay checkout was clean at the baseline.  No agent or workflow was
delegated.  No kernel or surface source changed.

Stage E adds `emit/emit.ml`, `emit/recognize.ml`, the ABI and layout
printers, the five-file driver path, `examples/Ref20.asy` and the carried
kan-evm proof seed.  `dev/EMISSION.md` records the implemented M0 boundary.
The checked Word/Eff declarations are backend conventions in the inherited
grammar.  The emitter compares their full checked schemas and family
tables before giving their names EVM meaning.

Closed first-order calls, records and cases specialize before assembly.
Higher-order values have M1 refusals; delays, forces and thunk results have
M2 refusals.  Nat remains compile-time data.  Word payloads are checked in
`[0, 2^256)` and unboxed; the storage schema has whole-word slots in order
and rejects closures, including aliases.  The default export is `main`.
The driver compiles before creating a new directory and rejects an existing
path.  Host I/O failures retain the inherited exception boundary and can
leave partial output.  This limitation is explicit in `dev/EMISSION.md`.

The emitted runtime is byte-identical to the committed 20-byte reference.
The emitted creation code is its 10-byte prefix plus the runtime.  Both
execution and creation ran under the explicit Cancun fixture.  The emitted
ABI is empty; the layout records slot zero.  `axioms.txt` equals the source
axiom disclosure.  JSON goldens are hand-authored, with provenance and the
nonempty comparator control documented in `dev/ABI-PROVENANCE.md`.

The proof seed consists of 28 byte-exact files from kan-evm
`af81c541d394bd5d7477cf35e9f4021dc1a95539`.  Its original fidelity statement
remains intact.  Lean 4.33.1 and the pinned dependencies were already
installed.  The isolated seed build passed with zero errors, sorries and
warnings.  All 42 carried axiom-report rows contain only the permitted
standard axioms.  The seed does not prove this emitter correct.

Validation command: `env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH
-u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh`.
All 29 legs passed, with no AXIOMS skip.  The complete evidence is in
`dev/validation/2026-09-10-stage-e/`: 66 logs, 47 oracle receipts, the five
emitted reference files and 83 source hashes.  The unchanged Stage A-D
legs retain their prior expectations.  The driver now pins `M0_PROTOCOL`
as the refusal for a bare Nat program that has no contract schema.

| Measurement or gate | Result |
| --- | --- |
| EMIT-CONSTRUCTORS | 22 direct erased-boundary cases |
| WORD-UNBOX | 3 positive words, 9 cases, no boxed Word |
| STORAGE-NOCLOS | 2 positive fields, 9 cases, closure and alias refusals |
| EMIT-SOURCES | 15 executed source variants, 9 checked-source refusals, 3 driver checks |
| ABI-GOLD | live jq canonical equality, 4 comparator/escaping controls |
| M0-TRACE, emitted | 20 bytes, listing 17, cast 17, executed PCs 13, skipped PCs 4 |
| CREATE-EQ, emitted | runtime 20 bytes, returned 20 bytes, installed contracts 1 |
| Runtime execution | slot zero 42, returned word 42, gas 22232 |
| EMIT-MUTANTS | 7 of 7 killed; 4 restored controls passed |
| AXIOMS | 42 reports, zero sorryAx, 3 negative report controls |
| TRUSTED-LINES | emitter 294/1800, ABI 10/400, layout 8/250 |
| TRUSTED-LINES total | new 693/3550, inherited kernel 3997/4000 unchanged |

The source battery found a Boolean representation mismatch during
development.  The emitter now uses the carried `sum<unit|unit>` with no
payload, checked by true and false equality and ordering executions.
Other source cases cover maximum-width words, two slots, a PUSH2 label
program, creation length adjustment and quantity-zero arguments.

The full battery ended `STAGE-E OK`.  Stage F remains pending, including
the frozen corpus, ratio report, trace/diff commands and ERASED-BYTES seed.
No final M0 exit or performance ratio is claimed.  No commit was made.
The proposed commit text is `dev/STAGE-E-COMMIT.txt`.

### Review round 2026-09-10 (Stage E)

Two fix rounds ran over the 132 staged paths on `8d4bd9d`.

| id | sev | finding | files |
| --- | --- | --- | --- |
| A-1 | high | Declared control counts are literal text, so a leg passes with its controls deleted (fixed) | dev/emit-test.py:98 |
| A-2 | high | WORD-UNBOX and STORAGE-NOCLOS marker fields ktag, kstruct, words, kclos, ktail, fields are constants (fixed) | test/emit_cases.ml:61 |
| B-1 | high | AXIOMS fails the whole ladder on a fresh clone and no repository document gives the offline provisioning recipe (fixed) | dev/proofs-test.py:48 |
| A-3 | medium | The AXIOMS declared skip is taken from the leg output and never checked against the host (fixed) | dev/stage-a-gates.py:88 |
| A-4 | medium | Unix.mkdir escapes as an uncaught Unix_error and exits 2, the code documented for an emission refusal (NOT FIXED, needs a ruling: every total form adds a second catch site against SD-D14, or a seventh dune library against R-M0-4) | bin/assay.ml:72 |
| B-2 | medium | leancho is a hard requirement of the AXIOMS leg but is in no toolchain table or install list, and its absence prints an ambiguous message (fixed) | dev/TOOLCHAIN.md:64 |
| B-3 | medium | TOOLCHAIN.md still asserts the AXIOMS gate prints a SKIP line, which this slice contradicts (merges C-1) (fixed) | dev/TOOLCHAIN.md:55 |
| ND-1-1 | medium | New defect from the round 1 fixes: a second catch site (fixed by revert) | bin/assay.ml:75 |
| ND-1-2 | medium | New defect from the round 1 fixes: carried ABI-GOLD evidence still said controls=3 (fixed) | dev/validation/2026-09-10-stage-e/ABI-GOLD.log:1 |
| GATE-1 | high | The Stage E gates did not pass (fixed) | (gate) |

Refuted: 0.  Every finding handed to the review stage survived the re-read.

Merged and dropped: 7.  C-1 merged into B-3 (same file dev/TOOLCHAIN.md and
the same live claim that the AXIOMS gate prints a SKIP line; B-3 cites both
statement blocks plus the reproduced FAIL and PASS outcomes).  D-3 merged
into C-4 (same file proofs/README.md:35, the carried seed README pointing at
`../docs/validation.md`, which assay does not have), then both cut at the
7-finding cap: the carried file is pinned byte exact by dev/PROOFS-PIN.json,
so the only fix is one sentence of prose in CARRIED.md.  D-1 cut at the cap
as the lowest ranked medium: dev/emit-test.py:61 omits `offsets=` and
`five_files=`, but emit() still checks the five files, so the leg is not
vacuous and the gap is a declaration gap against M0-PLAN.md:175 for the
M0-EXIT review.  A-5 cut: dev/emit-test.py:208 concatenates
`'MUTANT-BUILD ' + name + build.stdout` with no separator, diagnostic
quality only on a path that already fails the leg.  C-2 cut as a low: the
validation README:4 and dev/M0-BUILD-LOG.md:703 name a host local scratch
path, while the base commit and the command in the same README already give
reproduction.  C-3 cut and weakened on re-check: the subject measures 61
characters, but no 60-column subject bound appears in M0-PLAN.md or
RATIFICATIONS.md.  D-2 cut as a low: emit/emit.ml has no revert path and
emit/dune does not link assay_keccak, an unrecorded deferral of a plan row,
not an emitted defect, since M0 has no revert in its effect alphabet.

Gate result after the fixes, log
`/Users/oobi/Documents/assay-stage-e-review/gates-E-2.log`,
29 PASS, 0 FAIL, porcelain 132 before and after, unstaged 0:

```
STAGE-E OK
EXIT 0
MUTANTS-TAIL: MUTANT TRUSTED-BOUND killed exit=1 MUTANTS killed=13/13 OK
DRIVER-TAIL: DRIVER cases=24 OK
KECCAK-MUTANTS-TAIL: KECCAK-MUTANT SELECTOR killed witness=S1 exit=1 KECCAK-MUTANTS killed=4/4 control=OK
ASM-MUTANTS-TAIL: ASM-MUTANT LISTING-PC killed witness=DISASM-3WAY ref20 FAIL ASM-MUTANTS killed=6/6 control=OK
TRUSTED-LINES-TAIL: TRUSTED-LINES total=693/3550 ratified=3550 TRUSTED-LINES OK
M0-TRACE-TAIL: REFERENCE-MEASURE runtime_bytes=20 gas=22232 M0-TRACE scope=reference bytes=20 listing=17 cast=17 evm=13 skipped=4 storage=42 return=42 OK
CREATE-EQ-TAIL: CREATE-MEASURE init_bytes=30 gas=4022 runtime_sha=e289c7e05023ac70a05725ddffd97143efe364fdbb882dedc9c04e3f8032a711 returned_sha=e289c7e05023ac70a05725ddffd97143efe364fdbb882dedc9c04e3f8032a711 CREATE-EQ bytes=20 returned=20 installed=1 OK
REFERENCE-MUTANTS-TAIL: REFERENCE-MUTANT INIT-REVERT killed witness=CREATE-EXEC execution reverted REFERENCE-MUTANTS killed=8/8 controls=3 OK
EMIT-CONSTRUCTORS-TAIL: EMIT-CONSTRUCTORS cases=22 OK
WORD-UNBOX-TAIL: WORD-UNBOX ktag=0 kstruct=0 words=3 cases=9 OK
STORAGE-NOCLOS-TAIL: STORAGE-NOCLOS kclos=0 ktail=0 fields=2 cases=9 OK
ABI-GOLD-TAIL: ABI-GOLD jq_sorted=equal provenance=dev/ABI-PROVENANCE.md controls=4 OK
EMITTED-TRACE-TAIL: CREATE-EQ scope=emitted bytes=20 returned=20 installed=1 OK EMIT-MEASURE runtime_bytes=20 init_bytes=30 gas=22232
EMIT-SOURCES-TAIL: EMIT-REFUSE runtime-nat OK EMIT-SOURCES success=15 refusal=9 driver=3 OK
EMIT-MUTANTS-TAIL: EMIT-MUTANT LAYOUT-SLOT killed by LAYOUT-GOLD mismatch EMIT-MUTANTS killed=7/7 controls=4 OK
AXIOMS-TAIL: AXIOMS sorryAx=0 theorems=42 carried_files=28 controls=3 OK AXIOMS-HOST elan present, skip refused
PROOF-BUILD-TAIL: OK lake: 0 errors, 0 sorries, 0 warnings
PROOF-REPORT-LINES: 42
```

The finder, the builder and the closer of this review ran opus/medium
because the Fable tier probe died on the reasoning_extraction classifier
(req_011Ceux88aMuSgW4kmsAUKPX); the Stage C probe on 2026-09-10 13:4x was
live but Fable subagents die mid-run 5/5 on the same classifier, so the
Stage D run on 2026-09-10 17:xx and this Stage E run on 2026-09-10 23:xx
keep the opus pin without a new probe and the rulings are reported unmet.

Closing check after the run: dev/validation/2026-09-10-stage-e/SOURCES.json
still pinned the pre-fix hashes of dev/emit-test.py, dev/proofs-test.py,
dev/stage-a-gates.py and test/emit_cases.ml.  The four entries are refreshed
to the staged blobs.  The other 79 entries are unchanged.

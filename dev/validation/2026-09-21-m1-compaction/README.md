# Compact assembly validation

Base: `eebe37e00ecb7fdce739c49f50a6dd49c45022b1`.
The implementation and measurement contract is in
[`../../M1-COMPACTION.md`](../../M1-COMPACTION.md).

All 34 M0 functional legs are satisfied across the recorded full run and
the focused proof check. `M0-COMPILER.log` records 33 passes; its AXIOMS leg
refused the initially absent local Lean packages. The later `AXIOMS.log`
records 42 theorem reports, 28 carried files and three negative controls
after offline cloning at the two manifest revisions. `m0/` contains the
full run's individual leg logs, including that initial AXIOMS refusal.

`STACK-HEIGHT` includes all 618 compact assembly comparisons. `ASM-MUTANTS`
kills all nine mutants with restored controls. The three new killing logs
are also retained separately, with only their final blank separator omitted.
The remaining focused checks cover M1
emission (30 counter rows, eight sources, 11 refusals, eight mutants) and
the ratio decision tests (five controls, 15 refusals, four mutants).

`FOCUSED.json` preserves the initial `dune runtest` fixture-path failure.
After declaring all four fixture trees and correcting the test action's
working directory, `DUNE-RUNTEST-FIXED.log` ends with `SUITE-KERNEL OK`.
The managed wrapper for the focused batch lost its supervisor heartbeat,
so its exit status remains unknown. The individual command outcomes were
recovered from the completed `FOCUSED.json` and per-command logs. The exit
status of the repeated Dune check was not captured; `FOCUSED.json` keeps the
pre-fix `DUNE-RUNTEST` failure (exit 1, matched false), and the cached
`asm_compact` test did not re-emit `ASM-COMPACT cases=618 OK` in the
repeated run.

`M0-ENV-01.log` retains the first run without `rg` on its restricted PATH.
`M0-ENV-02.log` retains the next run without `leancho` and with the initial
COMPACT-LIMIT witness naming a later failing case. The witness was corrected
to the observed first refusal, `branch-243`. Neither failure was suppressed.

`MEASURE-03.log` and `MEASURE-04.log` identify the two new frozen reports.
Attempt 03 is the committed compiler; attempt 04 is the compact assembler.
The active ratio is 1.4690205258768216 against a limit of 1.0. `M1-RATIO.log`
records the expected `RATIO-BOUND` refusal. M1 remains open. The benchmark
script, input manifest, timing protocol and performance bound are unchanged.

`STARTUP.json`, `startup-probe.py`, `PHASES-BASELINE.log` and `phases.ml` retain
diagnostic evidence. These process and phase probes do not replace R3 or
establish an isolated speedup. The dated frozen reports contain all timed
commands, samples, source hashes, executable hashes and host load values.

`SOURCES.json` pins the 16 reviewed source and measurement inputs.
`DENOMINATORS-before.sha256` preserves the preceding inventory;
`freeze-snapshot.py` records how the new inventory was generated.
Every log, the two frozen reports, `startup-probe.py` and `freeze-snapshot.py`
ran in a working copy of this staged tree at
`/Users/oobi/Documents/gpt1/assay-m1-performance` (HEAD `eebe37e` with the
76 paths staged at record time; the attempt 04 `compiler_sources_sha256`
matches this index), and those two scripts are one-shot records pinned to
that copy with a write-once target, not reproduction steps.
`RESULTS.json` distinguishes the resolved functional failures from the open
performance requirement. No full 75-leg M1 closure pass is claimed.

Reproduction requires the OCaml and Lean toolchains in `dev/TOOLCHAIN.md`,
with `rg`, `leancho`, `cast` and `evm` on PATH. Run the M0 battery with
`python3 -P dev/stage-a-gates.py --m0`. The focused driver is
`python3 -P dev/validation/2026-09-21-m1-compaction/focused-checks.py`.

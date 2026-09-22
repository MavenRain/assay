# M1 Bend 2 validation

Validated on 2026-09-22 from `20634788ca7c0ae416992908d3a614ce41d4107d`
in `/Users/oobi/Documents/gpt1/assay-m1-bend`. The implementation adds the
paired compilation benchmark and replaces the former OCaml M1 speed
gate. Compiler and language source files are unchanged.

The full 75-leg default battery completed with 70 passes and five
environment failures. Its explicit PATH omitted `rg` and `leancho`.
R0-COUNT, HOUSE, MUTANTS, AXIOMS and SOURCE-PROOFS each passed on rerun
with the complete tool PATH. No source change was needed for these
rechecks. `SUMMARY.json` records all 75 checks and their final evidence.
The original runner's exit status remains 1 in `default-gates.json`.
There are no outstanding check failures after the five rechecks.

`default-gates.log` is the complete original runner output;
`first-run/` holds all 75 individual leg logs. Each repaired check has a
`*-recheck.log`, its stderr stream and its capture metadata. The metadata
records the exact command, environment arguments, working directory and
exit status. The full PATH includes the active OCaml switch, Cargo tools,
Elan, Foundry, local tools and Codex's directory containing `rg`.

Both new legs passed in the full battery:

- BEND2-RATIO: ratio 0.072614202, limit 1.0, six cases and five rounds.
- BEND2-RATIO-TEST: three controls, 32 refusals and four killed mutations.

The measurement's complete command and output are retained as
`measurement.json` and `measurement.log`. The frozen raw samples and
tool/source identities are in `../../measurements/2026-09-22-m1-bend2.json`.
The active baseline is an identical copy sealed by `../../BEND2.sha256`.
The public `--m0` mode and the refusal of `--measure dev/bend2-baseline.json`
(`BEND2-RATIO FAIL BEND2-OUTPUT-EXISTS`, hash unchanged) were
exercised outside this record, which holds no capture of them. Run
`python3 -P dev/bend2-ratio.py --m0` to reproduce the informational report.

`SOURCES.json` pins the implementation and benchmark inputs for this
slice. The old OCaml timings remain historical diagnostics. The paired
workload and its limits are described in [M1-BEND2.md](../../M1-BEND2.md).
This record supplies validation evidence, without creating a commit or
changing the explicit user ratification requirement for M0-EXIT.

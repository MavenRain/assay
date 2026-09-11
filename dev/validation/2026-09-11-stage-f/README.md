# Stage F validation, 2026-09-11

Base: `27e1edb1b75055cf3c57587fa929ca2a4b126034` (Stage E).
Scratch checkout: `/Users/oobi/Documents/gpt1/assay-stage-f`.
The command was `env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH
-u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh`.
All 34 legs pass.  Lean ran and did not skip.  Its 42 theorem reports
contain no `sorryAx`.  The complete ladder is `GATES.log`.

`SOURCES.json` pins 136 validation inputs.  The frozen denominator
file pins the sample vectors and full commands.  Its measured window was
17.382 seconds, with load 33.61 at the start
on 12 CPUs.  That load exceeds the CPU count.  This is
a noisy local observation, not a stable throughput claim.  The ratio
1.409387 is informational at M0.  No fixed-cost subtraction is applied.
The eight contract processes total 78.5 ms against eight fixed-cost
proxies of 10.07 ms each, so the measured interval is no larger than the
declared startup proxy.
The original Stage 0 denominator bytes are in `dev/denominators-stage-0.json`.

`ORACLES.json` holds 52 full execution and listing receipts for
the corpus, Stage F mutants and final emitted reference.  Every geth run
names the Cancun fixture.  `MEASURES.json` records code sizes and gas.
`Ref20/` contains a fresh emission checked against all five frozen hashes.

ERASED-BYTES checks application and let proof shapes against a leaf.
Both runtime and init bytes must match.  A changed runtime value must
change both.  This is the M0 seed; the M2 obligation remains open.
F-MUTANTS kills seven changes and accepts five original controls.

The carried kernel, surface and proof seed stay byte-identical.
The trusted backend remains 693 of 3550 lines.  M0-VALIDATION is green.
M0-EXIT still needs the user's Stage F commit and explicit ratification.
No commit or ratification was made by this run.

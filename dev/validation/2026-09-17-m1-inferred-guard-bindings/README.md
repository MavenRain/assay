# Inferred guard binding validation

Base: `088a4056707432d452ecff5b0e38069d53a3a8bc`.

All 56 functional legs pass after five environment rechecks. The
initial 58-leg battery passed 51 legs. The validation PATH omitted
the directories containing `rg` and `leancho`; R0-COUNT, HOUSE,
MUTANTS, AXIOMS and SOURCE-PROOFS pass when rerun with the corrected
PATH. Their commands, deadlines and success markers are unchanged.
No compiler source or binary changed between the battery and rechecks.

DENOMINATORS and M0-RATIO still fail against preserved older timing
inputs. `PENDING.json` compares the committed and current hashes and
confirms that both gates report the same 14 stale paths. Timing stays
paused. No performance result or milestone exit is claimed.

`GATES.log`, `GATES.stderr` and `legs/` retain the initial battery.
Leg logs omit redundant final blank lines.
`RUN.json` records its command and capture, initial and final results,
and compiler hash. `RECHECKS.json` records the corrected PATH and each
recheck, with complete output in `rechecks/`. `CACHE.json` records the
38 matching proof-package source files and two pinned dependencies
checked before reusing build artifacts. Both proof gates ran.

`LIVE.json` records 160 source-model/Cancun comparisons and two creation
outcomes. `ERASURE.json` hashes all five files for 20 inferred/annotated
pairs. `BOUNDARIES.json` records four more equal-output pairs at the
condition and effect limits. The suite refuses 27 invalid sources
through `check`, `emit` and `run`. `MUTANTS.json` records four built
compiler mutations and passing restored controls.
`INFERRED-GUARD-BINDING-CAPTURES.json` retains the individual commands,
exit statuses, stdout and stderr for those tests.

`GATE-COMPAT.json` compares the syntax trees of all 57 previous gate
declarations, including commands, deadlines and markers. `FINAL.json`
hashes protected sources and records the pending performance result.
`STATIC-AUDIT.log` records zero findings from
`panicscan --all --limit 20 emit/contract.ml`.
`SOURCES.json` hashes current sources outside the validation archives.
`ARTIFACTS.json` hashes every other file in this archive.

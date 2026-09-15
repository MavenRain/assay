# Predicate validation, 2026-09-14

All 47 functional checks passed, including scoped rechecks of initial
tool timeouts. RUN.json records the original 49-leg battery and
the rechecks separately. DENOMINATORS and M0-RATIO failed against the
preserved manifest and measurement. Timing remains paused. No full
battery pass, performance result or milestone exit is claimed.

GATES.log and legs/ retain the full battery output. CAPTURE.json records
the captured command. PREDICATE-CAPTURES.json retains the new gate's
execution, refusal, boundary, mutation-build and restored-control
captures. LIVE.json and ERASURE.json record counts and output hashes.
The rechecks/ directory retains each recheck with its original command,
deadline, elapsed time and source identity. RECHECK-RUNNER.py extracts
commands and deadlines from the unchanged gate configuration.
RECHECK-CAPTURE.json and RECHECKS.log retain the enclosing captured run.
RAW-LEG-LOGS.json preserves the exact text of two per-leg logs whose
display copies omit extra blank lines at the end. GATES.log is unchanged.

The feature passes 72 source-model/Cancun cases, two creation outcomes,
44 refusals through check/emit/run, seven five-file erasure comparisons,
12 accepted boundaries and four mutations with passing controls.
The guard-claim and constructor-invariant mutation anchors follow the
new representation with unchanged witnesses and expected outcomes.

CACHE.json and CACHE-REUSE.py record the 35 matching proof source files
and two pinned dependencies checked before reuse. Both proof gates ran.
SOURCES.json hashes the final non-archive repository files. ARTIFACTS.json
hashes every other archive file. FINAL.json records the unchanged
protected inputs, including the frozen measurement and denominator file.

Reproduce with zsh -f dev/dunecho.sh build and
python3 -P dev/predicate-test.py. zsh -f dev/gates.sh runs all 49 legs,
including the preserved failing manifest and measurement checks.

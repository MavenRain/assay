# Proof bundle validation, 2026-09-14

The complete 48-leg battery passed all 46 functional legs. DENOMINATORS
and M0-RATIO failed against the preserved manifest and measurement.
Timing remains paused. No full battery pass or fresh performance verdict
is claimed. RUN.json records every leg and the compiler identity.

GATES.log and the per-leg logs retain the battery output. CAPTURE.json
identifies the captured command and its nonzero exit. BUNDLE-CAPTURES.json
maps each new gate capture filename to its complete text, including
source-model/Cancun execution, refusals, erasure comparisons, mutation
builds, killing observations and restored controls. LIVE.json and
ERASURE.json expose the case counts and five-file output hashes.

GATES.initial.log retains the first battery, which caught a compatibility
issue with existing custom-error argument names. Contextual proof calls
preserve those identifiers and helper names. The complete battery was
then rerun on the corrected compiler. No passing verdict from the first
compiler is substituted into the final run.

CACHE.json records 35 matching Lean sources and two pinned dependencies
checked before artifact reuse. CACHE-REUSE.py retains that procedure.
Both proof gates subsequently ran. All existing counts and deadlines
remain in force.

SOURCES.json hashes final non-archive repository inputs. ARTIFACTS.json
hashes every other archive file. FINAL.json records unchanged protected
inputs. The carried kernel, surface, proof protocol, arithmetic, backend,
assembler and Lean sources have no changes in this slice. Compiler
performance artifacts retain their preceding frozen identities.

Reproduce the feature with zsh -f dev/dunecho.sh build and
python3 -P dev/proof-bundle-test.py. zsh -f dev/gates.sh runs all 48 legs,
including the two preserved failing manifest and measurement checks.

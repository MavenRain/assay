# Proof helper validation, 2026-09-13

The complete 47-leg battery passed 44 functional legs. SOURCE-PROOFS
hit its existing 180-second mutation build timeout, then passed a scoped
rerun with the same limits. All 45 functional legs are validated across
those runs. DENOMINATORS and M0-RATIO failed against the preserved
manifest and measurement. The initial proof log and rerun are both kept.
Timing remains paused; no complete battery pass or fresh performance
verdict is claimed. RUN.json records each leg and the compiler identity.

GATES.log and the per-leg logs retain the battery output. CAPTURE.json
identifies the captured command and its nonzero exit. The proof-helpers
directory retains the new execution cases, refusals, erasure hashes,
mutation builds, killing observations and restored controls.
The source-proofs-rerun directory retains the passing proof retry's
theorem build, case comparisons and mutation captures.

CACHE.json records 35 matching Lean sources and two pinned dependencies
checked before reusing proof artifacts. CACHE-REUSE.py records that
verification and copy procedure. All proof gates subsequently ran.

SOURCES.json hashes the final non-archive repository inputs, including
the new example and test. ARTIFACTS.json hashes every other archive file.
FINAL.json records unchanged protected inputs. The kernel, carried
surface, proof protocol, backend, arithmetic, assembler and Lean sources
have no changes in this slice. The performance artifacts are preserved.

Reproduce the functional checks with zsh -f dev/dunecho.sh build and
python3 -P dev/proof-helper-test.py. zsh -f dev/gates.sh runs all 47 legs,
including the two preserved failing manifest and measurement checks.

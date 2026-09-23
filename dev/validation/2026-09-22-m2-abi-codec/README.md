# M2 ABI codec validation, 2026-09-22

Base: `1c6968f`. The complete default run passed 77 of 78 legs and failed
HOUSE on the initial adapter's list lookup and catch-all patterns.
`house-rerun.log` and `final-checks.log` validate the corrected adapter.
The default run started on the initial adapter; test/abi_codec.ml and
dev/DENOMINATORS.sha256 were rewritten while that run was in flight,
after its DENOMINATORS leg. The record holds no artifact that dates the
rewrite against the ABI-CODEC leg, and ABI-CODEC.log is byte-identical
to focused-before-adapter-fix.log, so the default run does not attest
the corrected adapter; its compile and harness pass rest on the
review-round ladders. All 78 legs are validated across these runs.
`default-gates.log` retains its original failing completion marker.

`RESULT.json` records those verdicts. The two diagnostic captures retain
an initial mutation-witness mismatch and a missing Bun PATH entry, both
corrected. The early build and focused captures are preliminary checks.
The refreshed measurements and the final-checks source pins cover the
final tree; the default run's DENOMINATORS row validated the earlier
pin file.

`leg-logs.tar.gz` contains the full 78 per-leg logs from the default run,
including the original HOUSE failure. `codec-evidence.tar.gz` contains
the final vectors, ten mutation witnesses and schedule-comparison inputs
from `.gatework/abi-codec`. These archives contain no compiled binaries.

`GATE-COMPATIBILITY.json` covers 47 old modes and five failure
classifications. The retained Python scripts are transcripts using the
isolated checkout's paths. Measurements keep the original five rounds,
six paired Bend workloads and unchanged performance bound. The ratio is
0.073514764. The two SHA-256 files retain the active measurement seals.

`SOURCES.json` pins the listed compiler, test, gate and documentation
inputs. `FILES.sha256` seals every file in this validation record except
itself. Carried Lean dependencies were reused from the preprovisioned
local cache. No dependency download was needed.

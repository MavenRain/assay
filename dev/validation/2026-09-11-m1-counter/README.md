# Counter reference validation

The battery passed 34 of 36 legs. DENOMINATORS and M0-RATIO still fail on stale measurement source hashes.

The run used an isolated local clone at base `1e76d69`. `GATES.log`
and the 36 named leg logs retain the battery output. Text logs have
one trailing newline. The `counter/` directory retains raw JSON
captures for all 30 cases, two constructor probes, eight bytecode
mutants and their controls, selectors and disassembly. It also holds
the positive call-value probe. The 120 runtime PCs and every creation
prefix PC were exercised. `DIFF-EVIDENCE.json` retains the existing
executor and driver regression captures. The carried proof package
reported all 42 axiom rows. Dependencies came from the previous local
workspace, with their pinned revisions checked by the proof gate.

Measurement attempt logs record this slice's timing runs. A rejected
run is never used to refresh the source hash manifest.

`SOURCES.json` pins the prior executor source/input inventory and
every current change outside this evidence directory. It excludes
the evidence files to avoid self-reference. These are reference and
adapter checks, not completion of counter source emission or M1.

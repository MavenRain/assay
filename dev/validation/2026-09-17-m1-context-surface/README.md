# Contract surface context validation

Base: `dbce0894338775d0eb97bbc0e76ac5605c728552`.

All 58 functional legs pass after five environment rechecks. The initial
battery passed 53 of 60 legs. The two frozen timing gates stay pending.

`GATES.log`, `GATES.stderr`, `RUN.json` and `legs/` retain the initial
60-leg battery, including its failures. The initial PATH omitted `rg`
and `leancho`. `RECHECKS.json` retains the affected gates rerun with the
normal tool path, original commands, original deadlines and original
success markers. `FINAL.json` lists the final functional verdicts.

DENOMINATORS and M0-RATIO remain pending. `PENDING.json` compares the
frozen, base and current hashes. Timing remains paused, the frozen
measurement files are unchanged and no new performance result is
claimed.

`LIVE.json` records 224 model/EVM comparisons, 56 signed Cancun
comparisons, 64 creation outcomes and eight five-file comparisons with
equivalent core sources. `COMPOSITION.json` records caller values used
with inferred helper proofs and storage invariants. Captures also cover
shadowing, four constructor ordering cases and 17 invalid sources.
`MUTANTS.json` records four compiled mutations and passing restored
controls. Both EVM execution entry points use geth.

`CAPTURES.json.gz` contains the complete command captures and executor
traces as a JSON object keyed by their original filenames.
`CAPTURES.json` records its uncompressed identity. `OUTPUTS.json`
hashes the focused source fixtures and emitted files.

`GATE-COMPAT.json` preserves all 59 previous gate declarations.
`CACHE.json` records the source and pinned dependency checks used to
copy unchanged proof build artifacts before running the proof suites.
`FINAL.json` records the compiler identity, protected source paths and
the emitter count of 1792/1800 lines. `SOURCES.json` hashes the compiled
and executed source inputs outside validation archives. It holds 731
entries and it hashes no document: the commit pins the document bytes.
`ARTIFACTS.json` hashes every other file in this archive.

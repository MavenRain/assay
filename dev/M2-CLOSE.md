# M2 closure

Status: M2 remains open. The group 9 closure battery exited 2 with five
failed legs. Their later focused passes do not establish a passing cumulative
battery on the final source hashes. M3 and M4 remain open.

## Command

`make gates` runs `dev/stage-a-gates.py --m2-reconcile`, the default
110-leg battery. Group 9 ran it under a memory guard. The guard limit
for the process tree was 4096 MB.

## Closure battery

| Field | Value |
| --- | --- |
| Legs | 110 |
| Legs that passed in the closure battery | 105 |
| Battery time | 12576.9 seconds |
| Peak memory of the process tree | 2193 MB |
| Launch (UTC) | 2026-10-06T19:38:44Z |
| Staged tree at launch | `553a927a7c06876279fdc36f7679898a6fc2bb1e` |

EVM-CONTEXT, SURFACE-CONTEXT and WORD-EQUALITY stopped at the leg deadline in the closure battery. INFERRED-BINDINGS (`assay emit` at 600 seconds) and INFERRED-GUARD-BINDINGS (`assay run` at 30 seconds) failed in the closure battery when one inner command reached its own time limit. Each passed when run alone in run-6b. The record keeps both attempts.

The record is in
[validation/2026-10-06-m2-close](validation/2026-10-06-m2-close/README.md).
It keeps the closure battery, each earlier attempt and the leg logs.
`LAUNCH-SOURCES.sha256` identifies the blobs in the recorded launch tree.
`SOURCES.sha256` identifies the later staged review tree; it is not evidence
that battery 3 ran on those blobs. A passing cumulative run on the final
sources is still required before closure.

## Run history

1. Battery 1 ran on `092fa7a`. It completed 76 legs before it
   stopped: 63 passed and 13 failed.
2. Run 1b ran the legs that battery 1 did not reach and six suspect legs.
   It stopped before its last three legs.
3. Group 10 repaired the failures. Focused runs tested each repair. The
   record lists each run.
4. Battery 2 ran on the repaired tree. 106 of 110 legs passed.
   HOUSE failed, and group 10 repaired it. PAYABLE, CALLVALUE and ADDRESS stopped at the leg deadline in battery 2. Each passed when run alone in run-6a.
5. Battery 3 is the closure battery. 105 of 110 legs passed in it.

## Group 10 repairs

- Mutations: the anchors in `dev/mutations/` match the current emitted
  text, so each mutant applies and the gate kills it. The ADDRESS SCHEMA
  mutant text is repaired for the HOUSE leg.
- Return ABI: `src/return_abi.bend` has the repair for the FALLBACK mutant.
- Deferred constructs: see ruling D2 below.
- Corpus: see ruling D3 below.
- Bend 2: the pins follow Bend 2 `v2.0.32`, commit `573002f`.
- Pins: `dev/cli_delta.py`, `dev/native-carry.json` and
  `dev/DENOMINATORS.sha256` follow the changed sources. The compatibility
  checks apply the exact rewrites in `dev/carried_text.py` to carried test
  lines.
- Limits: see the inferred-leg rulings below.

## User rulings

On 2026-10-05 the user gave these rulings:

- D2, "Repair in group 10": `src/tests.bend` has refusal tests for `SPar`,
  `SNu`, `RThunk` and level variables. `src/frontend.bend` refuses level
  variables with a named refusal.
- D3, "Add an ERC20 corpus row": the corpus has the row
  `corpus/m2/ERC20.asy`.
- Source price, "Leave unpriced, record it": `frontend`, `function_abi`,
  `return_abi`, `event_source` and `string_literal` have no line budget.
  These sources contain 4792 lines.
- Inferred legs, "Raise the limits": the inferred legs use longer emit
  timeouts.

On 2026-10-06 the user gave these rulings:

- INFERRED-BINDINGS: `dev/toolchain.json` sets the stack limit to
  131072 KiB, and the witness capture has a 600-second timeout.
- ADDRESS: the test uses `examples/ContractAddress.asy` as its fixture.

## Limits

- Compiler speed belongs to [M4](M4-SPEED.md), following the user's
  2026-10-01 instruction. The M2 closure does not measure speed.
- M3 and M4 remain open.
- The constructs in the deferred-construct matrix of
  [M2-RECONCILE.md](M2-RECONCILE.md) stay deferred. Each keeps its named
  refusal.
- Each leg result comes from one run on one machine.
- 4792 source lines have no line budget, as the source price ruling
  records.

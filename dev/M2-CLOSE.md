# M2 closure

Status: M2 is closed. Battery 6, the group 9 closure battery, passed all
110 legs on the committed final sources. M3 and M4 remain open.

## Command

`make gates` runs `dev/stage-a-gates.py --m2-reconcile`, the default
110-leg battery. Group 9 ran it under a memory guard. The guard limit
for the process tree was 4096 MB.

## Closure battery

| Field | Value |
| --- | --- |
| Legs | 110 |
| Legs that passed in the closure battery | 110 |
| Battery time | 7563.5 seconds |
| Peak memory of the process tree | 2266 MB |
| Launch (UTC) | 2026-10-07T10:01:34Z |
| HEAD at launch | `b8d57161a2e1bef3274bd94c913ec23b5f256688` |
| Tree at launch | `2798cf59afb44d5a2f0f57da886aadd853231677` |

Every leg passed in the closure battery. No leg needed a rerun.

The record is in
[validation/2026-10-06-m2-close](validation/2026-10-06-m2-close/README.md).
It keeps the closure battery, each earlier attempt and the leg logs.
`LAUNCH-SOURCES.sha256` identifies the blobs in the launch tree.
`SOURCES.sha256` identifies the staged closure tree. The two differ only
in the closure documents and their pins.

## Run history

1. Battery 1 ran on `092fa7a`. It completed 76 legs before it
   stopped: 63 passed and 13 failed.
2. Run 1b ran the legs that battery 1 did not reach and six suspect legs.
   It stopped before its last three legs.
3. Group 10 repaired the failures. Focused runs tested each repair. The
   record lists each run.
4. Battery 2 ran on the repaired tree. 106 of 110 legs passed.
   HOUSE failed, and group 10 repaired it. PAYABLE, CALLVALUE and ADDRESS stopped at the leg deadline in battery 2. Each passed when run alone in run-6a.
5. Battery 3 ran on the staged tree `553a927a`. 105 of 110 legs passed.
   EVM-CONTEXT, SURFACE-CONTEXT and WORD-EQUALITY stopped at the leg
   deadline. INFERRED-BINDINGS and INFERRED-GUARD-BINDINGS failed when one
   inner command reached its own time limit. Each passed when run alone in
   run-6b. These focused passes do not close M2, so commit `30feb7b`
   recorded M2 as open.
6. Battery 4 ran on the committed tree `61f9d5d2`. 109 of 110 legs
   passed. INFERRED-BINDINGS failed. In its BUNDLE-LIMIT mutant witness,
   one inner `assay check` reached its 30 second time limit. The leg did
   not reach its own deadline.
7. Battery 5 started on the same tree. A user ruling stopped it after 70
   legs passed, to raise that inner limit. Commit `b8d5716` raised the
   limit of the bundle-expansion refusal check to 120 seconds.
8. Battery 6 is the closure battery. It ran on the committed tree
   `2798cf59`. 110 of 110 legs passed in it.

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

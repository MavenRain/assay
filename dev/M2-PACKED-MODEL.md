# M2 packed source model

`assay run` accepts typed packed contracts. The frontend interpreter maps each
logical field to the same planned physical slot and byte offset used by
emission. Its input and JSON output retain physical storage words, including
neighboring fields, unused high bytes and unrelated slots. Word-only and
Uint256-only contracts continue through the existing model.

Reads extract only the requested field. A dirty boolean reverts when read;
unread dirty fields remain valid prestate. A canonical boolean write repairs
its entire byte before a later read. Writes check the declared value range
and preserve all other bytes. A rejected write, late invalid read, arithmetic
failure, guard failure or custom revert restores the original transaction
prestate, including writes made earlier in the same call.

The packed interpreter supports the existing dispatcher, payable entry checks,
fallbacks, checked and proof-supplied arithmetic, caller, value, address and
calldata operations. Return and custom-error encoding use the existing model.
Run executes one runtime call; constructor behavior remains covered by the
source packing EVM tests.

The model lives in `src/frontend.bend`. Emitted artifact implementations do
not depend on it. No kernel axiom or artifact budget changes: the artifact
sources still total 3184/3550 lines, including emitter 1792/1800, assembler
414/505 and layout 238/250.

Run `make all`, then `python3 -P dev/packed-source-test.py`. The suite covers
66 live cases and six compiled semantic mutations. Transaction cases compare
the source model and both Geth execution paths with independent expected
storage words and outputs. The mutation controls target field selection, field
clearing, unrelated slot retention, boolean validation and transaction
rollback. A named case selector is restricted to mutation controls. Three
isolated mutation copies run concurrently, building only the CLI each control
executes. The default gate runs the complete suite and requires its exact case
and mutation counts within the unchanged 600-second deadline.

The [validation record](validation/2026-10-01-m2-packed-model/REPORT.json)
pins the final sources and records checks and retained evidence. M2 remains
open for mapping, event and dynamic ABI source integration and its negative
Lean proof obligations. Compiler speed remains assigned to M4.

# M2 source packing

Source normalization in src/frontend.bend and CLI handling in src/cli.bend
integrate typed storage declarations with the existing contract compiler. Fields accept Uint8, Bool, Address, Uint256, and
the existing Word spelling. The checked core continues to use Word values;
the typed layout accompanies the same source snapshot into EVM emission.

[PackedStorage.asy](../examples/PackedStorage.asy) compiles count, enabled
and owner into slot 0 at byte offsets 0, 1 and 2. Its full-width total starts
at slot 1. Layout output uses the existing Solidity-compatible packed schema.

Loads shift and mask the field's physical bytes. Boolean loads reject values
other than zero and one. Stores check canonical value ranges before changing
storage, clear only the field's bytes, and preserve neighboring fields and
unused high bytes. Boolean writes replace the complete byte, so a valid write
repairs a previously invalid boolean. A field that would cross a slot starts
at the next slot.

The backend lowers storage operations in assembler blocks, including
constructor writes and deployer initialization, then reassembles labels and
settles init-code offsets. Guards use two-byte jump addresses. It adds no
kernel axiom. Storage recipes are charged to src/layout.bend and block
lowering to src/assembler.bend. All original source budgets remain fixed:
layout uses 238/250 lines, assembler 414/505, and artifacts total 3184/3550.

Function arguments and returns retain the existing Word ABI. Check and
emit accept the typed source. The typed layout applies only when at least
one field is Uint8, Bool or Address. The
[packed source model](M2-PACKED-MODEL.md) now runs these contracts against
the same physical layout. Source whose fields are only Word or Uint256
packs nothing. It keeps the existing Word path for check, emit and run,
with the same artifacts as Word-only source.

dev/packed-source-test.py checks 38 live cases against independent packed
word goldens, using Geth run and signed Cancun t8n for runtime transactions.
It covers range boundaries, neighbor preservation, dirty boolean reads and
repair, sequential rollback, constructors, reordered fields, slot spills,
source rejection, and Word model compatibility for Word-only and
Uint256-only source. Three compiled semantic mutants must fail these
assertions. Geth's two execution paths share an implementation; this is
not agreement between independent EVM engines.

The [packed source model](M2-PACKED-MODEL.md) extends this suite to 66 live
cases and six compiled semantic mutants. Its [validation
record](validation/2026-10-01-m2-packed-model/REPORT.json) pins that run.

dev/fixtures/packed-source-word contains exact Word-only artifacts generated
with the pinned Bend compiler from commit 80bc4c67f9ce7489dbcbec2cbe1a7b85dee07593.
BASELINE.json pins that commit, source and artifacts. The source test compares
runtime, init, ABI and layout bytes with those artifacts.

Historical CLI checks pin the three source adapters in addition to the
existing string changes. They read the historical and current source trees
independently, retaining additions and deletions, then compare the complete
reachable historical CLI after restoring exactly pinned adapters. The native
declaration parser and historical ABI/test prefixes remain unchanged.

Run python3 -P dev/packed-source-test.py after make all. The default
make gates selects --m2-source-packing, appending the
[mapping CLI check](M2-MAPPING.md#command-line), the
[event CLI check](M2-EVENTS.md#command-line), the
[event decoding CLI check](M2-EVENT-DECODE.md#command-line), the
[calldata CLI check](M2-CALLDATA-CLI.md), this check and
the [M4 speed ownership check](M4-SPEED.md) to the 93 carried non-speed
checks, for 99 checks.

The [validation record](validation/2026-10-01-m2-source-packing/REPORT.json)
pins source hashes and records the native suite, live cases, mutants,
compatibility checks and fixed budgets. The full 95-leg battery was not rerun.

M2 remains open. Its remaining work includes mapping and event source
integration, dynamic ABI source integration, and the milestone's negative
Lean proof obligations. This slice does not claim a complete ERC-20
source compiler or a new full milestone battery pass.

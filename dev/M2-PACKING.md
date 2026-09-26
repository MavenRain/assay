# M2 packed storage

This slice starts at `f806892` and adds `Layout.Packed` in native Bend 2.
It plans named fields of type `uint8`, `uint256`, `address` and `bool`,
prints their storage metadata, and reads or updates a field in a 256-bit
word. The source compiler still uses Word storage; packed declarations
and their EVM lowering remain pending.

## API and layout

`plan` accepts `Abi.Schema.Parameter` values and returns checked field
descriptors containing a name, type, slot and byte offset. `print` accepts
the same declarations and a contract name, returning the existing JSON
storage shape. Its `astId` is the declaration index, as in the M1 printer.
Only types present in the declarations appear in the `types` object.

Fields occupy 1, 32, 20 and 1 bytes respectively. Allocation starts at
slot zero, from the least significant byte. A field that does not fit
starts at offset zero in the next slot. This follows the scalar packing
rules in the [Solidity storage-layout specification](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html).
For example:

| Field | Type | Slot | Byte offset |
| --- | --- | --- | --- |
| count | uint8 | 0 | 0 |
| enabled | bool | 0 | 1 |
| owner | address | 0 | 2 |
| total | uint256 | 1 | 0 |

`read(field, word)` returns the field's unsigned integer value.
`write(field, word, value)` returns a replacement word while preserving
every bit outside the field, including unused bytes. Booleans must be
zero or one. Reads reject other boolean byte values; writes replace the
whole byte and can repair an invalid previous boolean value.

Every public operation returns `Layout.Packed.Result`. Planning rejects
empty or duplicate names and unsupported dynamic strings. Access checks
the slot's 256-bit range, the offset and width, the input word's range,
and the value's type-specific range. No truncation substitutes for these
checks. The original `Layout.print` implementation is unchanged.

## Validation and remaining work

Run `python3 -P dev/layout-packed-test.py`. Its adapter batches probes
through the production Bend functions. The gate checks 11 fixed layouts,
1,685 distinct access and readback cases, and 40 refusals. Access coverage includes
every legal byte offset, zero and maximal words and values, seeded random
words, whole-byte boolean replacement, and preservation of neighboring bits.
The gate counts each distinct probe once. It rejects layout JSON with a
repeated key. A names list without a type list is an arity error.

Eleven compiling mutants must fail named witnesses: premature spill,
late spill, wrong address width, widened boolean values, wrong read shift,
failure to clear an old field, missing offset, word, slot or duplicate-name
checks, and a missing type-row dedupe. Compiler failures do not count as kills. The restored control
must pass the same witnesses.

The explicit `--m2-packing` gate mode appends `LAYOUT-PACKED` to the
80-leg codec schedule, for 81 legs. The default additionally runs
[LAYOUT-MAPPING](M2-MAPPING.md). All 48 prior modes preserve their schedules, deadlines
and failure classification. The existing trusted-source limits are intact.
The [validation record](validation/2026-09-25-m2-packing/README.md) records
the actual commands and outcomes.

Both performance reports were remeasured with fresh source pins. The paired
Assay/Bend ratio is 1.727570573; the normalized corpus ratio is 1.599478.
Both exceed the unchanged 1.0 requirement. Timing across different runs
does not establish a feature-specific speed change.

Source integration, mappings, event execution, dynamic ABI lowering and
M2 Lean negative mutants remain pending. This slice does not close M2.

# M0 source emission

This document describes the preserved M0 mode. [M1 core emission](M1-EMISSION.md)
adds source entries, runtime operations, checked arithmetic and constructors
when a source declares `Entry`.

Stage E compiles closed first-order `Eff` programs.  The source grammar is
the carried Kanon grammar.  `examples/Ref20.asy` is the complete minimal
example.  The inherited `examples/m0-spine.kan` exercises the checker; it is
not an EVM contract.

Run `assay emit examples/Ref20.asy -o OUT` with a new output directory and
an existing parent.  The default export is `main`.  `--export NAME` chooses
another closed export.  Compilation completes before any file is created.
A compiler refusal exits 2 and writes nothing.  Existing output paths are
refused with exit 64.  Operating-system I/O failures retain the inherited
driver boundary; a failed write can leave a partial new directory.

## The M0 protocol

The `Word`, `Eff`, constructor and `EvmOpcodes` declarations at the start
of `Ref20.asy` define the M0 protocol.  `Recognize` in `src/emitter.bend` checks those
declarations against a checked canonical schema, including the family
tables.  A matching spelling alone cannot attach EVM meaning to a different
type.  This is a backend convention, with zero new kernel formers.

`Word bits` has one constructor with one concrete Nat payload.  The bits
index is erased.  M0 effect operands and storage fields use `Word 256`.
The Word recognizer checks every payload in the range `[0, 2^256)` and
lowers the tag to one word.  The index is not itself a range proof.  A
boxed Word, wrong constructor shape or out-of-range payload is refused.
Prop-valued refinements remain the M2 item in R-QA.

`Storage` is a named `prod` of `Word 256` fields.  `storage : Storage`
contains slot numbers, consecutive from zero.  Its declaration and the
referenced definitions are checked for closures and tail applications
before specialization.  Each field becomes `fieldN` in the layout, with
one 32-byte slot per field.  A different width, Nat field, slot gap or
closure is refused.  Field names and mapping storage arrive with M1/M2.

The effect family has three first-order constructors:

| Source | EVM meaning |
| --- | --- |
| `ret value` | Return the concrete word as 32 bytes |
| `put slot value next` | Store the word, then execute `next` |
| `read slot` | Load the word from storage and return it as 32 bytes |

Every read or write must name a declared slot.  `read` is terminal at M0.
Runtime branching on a loaded word, input dispatch and higher-order
continuations belong to M1.  `EvmOpcodes : Prop` discloses the external
opcode semantics.  No postulated runtime value is executed.  Extra source
axioms are printed by both `assay axioms` and `axioms.txt`.

## Erased constructors and bounds

The specializer has an exhaustive arm for all fourteen carried term
constructors.  The twelve M0 constructors are handled or explicitly
refused according to the emission map.  `KDelay`, `KForce` and `RThunk`
have M2 diagnostics.  `KClos`, indirect application and unsaturated calls
have M1 diagnostics.  Direct calls and tail calls inline a known body.
Closed records, tags, projections and cases reduce before assembly.
Quantity-zero terms consume no runtime slot.  This stage does not emit a
general heap representation for surviving dynamic structures.

Compile-time Nat arithmetic uses Zarith and truncating subtraction.
Comparisons produce the carried `sum<unit|unit>` representation.  Nat
cannot be the runtime result.  Specialization has 100,000 shared steps
and a 4096-bit intermediate integer bound.  Runtime code is limited to
24,576 bytes.  These implementation bounds produce named refusals.

The assembler checks all generated blocks and edges.  A write jumps over
four `INVALID` guard bytes to a marked block.  This explicit layout
reproduces the committed Stage D reference, including the skipped PCs.
Programs that fit use one-byte label operands; larger programs use two.
The creation prefix computes its own length, then copies and returns the
runtime.  Both returned and installed bytes are checked under Cancun.

## Outputs and gates

The five files are `runtime.hex`, `init.hex`, `abi.json`, `layout.json`
and `axioms.txt`.  Hex is lowercase without `0x`, with one final newline.
The M0 ABI is the empty entry list.  The layout uses solc field names;
`astId` is the field ordinal in this backend, not a Solidity source ID.
`contract` is the source basename without its extension.

`EMITTED-TRACE` checks exact reference bytes, the live cast listing, geth
PCs, stack words, storage, return data and creation.  `EMIT-SOURCES`
executes source variants and requires named refusals to write no files.
`WORD-UNBOX`, `STORAGE-NOCLOS` and `EMIT-CONSTRUCTORS` probe the erased
boundary directly.  `EMIT-MUTANTS` changes real backend code, rebuilds it,
requires a named witness to fail and restores passing controls.

The proof seed is carried from kan-evm commit
`af81c541d394bd5d7477cf35e9f4021dc1a95539`.  `dev/PROOFS-PIN.json`
hashes all 28 files.  `AXIOMS` checks that inventory, builds the seed and
checks all 42 declarations in its carried axiom report.  It allows only
`propext`, `Classical.choice` and `Quot.sound`.  It rejects `sorryAx`, a
missing report row and a duplicate report row.  If elan is absent, it
prints the plan's declared SKIP after checking the carry inventory.
Installed Lean dependencies must already match the seed manifest.

Read `proofs/FIDELITY.md` for the seed's exact scope.  These are proofs of
the kan-evm Lean embedding.  They do not prove this emitter correct.
Stage F freezes eleven corpus files and the wall-time report.  Its
ERASED-BYTES seed compiles three different checked proof shapes and
requires identical runtime and creation bytes.  Changing the runtime
payload must change both byte strings.  This is an executable M0 seed,
not a proof of erasure correctness or the full M2 erasure gate.

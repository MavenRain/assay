# assay

Assay is a Kanon language fork for EVM contracts.  It inherits the kernel and
surface at `2c2e6e6`.  M0 Stage A supplies the checker, erasure, axiom disclosure
and carry gates.  Stage B adds Keccak-256 and selector derivation.
Stage C adds the Cancun assembler and bytecode listing.
Stage D adds the hand-assembled reference and Cancun execution gates.
Stage E emits closed first-order EVM effect programs and five output files.
Stage F freezes the corpus, reports compile time and seeds proof erasure
checks over emitted bytes.
The first M1 slice adds offline differential execution through geth's
`evm run` and `evm t8n` entry points.
The second M1 slice adds the [bounded counter reference](reference/counter/README.md)
with a dispatcher, ABI/layout fixtures and 30 execution cases.
The third M1 slice compiles [core counter source](dev/M1-EMISSION.md),
with a source-derived dispatcher, ABI and named storage layout.
The fourth adds the [source model](dev/M1-RUN.md) and public `run` command,
with checked arithmetic, storage snapshots and rollback on revert.
The fifth adds [contract surface syntax](dev/M1-SURFACE.md), lowering
word storage, entries and sequential effects to that checked core.

```sh
zsh -f dev/dunecho.sh build
_build/default/bin/assay.exe check examples/m0-spine.kan
_build/default/bin/assay.exe check --erased examples/m0-spine.kan
_build/default/bin/assay.exe axioms examples/m0-spine.kan
_build/default/bin/assay.exe spec-count
_build/default/bin/assay.exe emit examples/Ref20.asy -o Ref20-out
_build/default/bin/assay.exe trace examples/Ref20.asy --calldata 0x
_build/default/bin/assay.exe diff examples/Ref20.asy --calldata 0x
_build/default/bin/assay.exe emit examples/Counter.asy -o Counter-out
_build/default/bin/assay.exe diff examples/Counter.asy --calldata 0x6d4ce63c
_build/default/bin/assay.exe run examples/Counter.asy --calldata 0x6d4ce63c --storage 0=7 --storage 1=100
_build/default/bin/assay.exe emit examples/CounterSurface.asy -o Surface-out
zsh -f dev/gates.sh
```

New assay sources use `.asy`.  The checker also accepts inherited `.kan`
fixtures and rejects every other suffix with exit 64 (R-M0-1).  The source
core grammar is unchanged. A file beginning with `contract` uses the
[bounded surface grammar](dev/M1-SURFACE.md). `check --print FILE` prints
the checked core declarations.
A valid file exits 0, a rejected file exits 1, and invalid arguments, an
unaccepted suffix or a missing path exit 64.

`emit FILE -o DIR` checks, erases and specializes an M0 effect program or
an [M1 core entry program](dev/M1-EMISSION.md).
It writes `runtime.hex`, `init.hex`, `abi.json`, `layout.json` and `axioms.txt`.
Use a new directory under an existing parent.  A named compiler refusal
exits 2 and writes nothing.  `--export NAME` selects a closed export in place
of `main`. [The M0 emission contract](dev/EMISSION.md) defines its source
protocol, supported constructors, bounds and I/O behavior.

`trace FILE --calldata HEX` compiles the source and prints geth's JSON
steps, summary and state dump.  It uses the explicit Cancun fixture and
literal process arguments.  Hex may have a `0x` prefix.  M0 programs
ignore calldata.  The default fixture is resolved from the executable's
`_build/default/bin` location, so the working directory can differ.
Use `--prestate FILE` after the calldata to select an explicit fixture.
Invalid hex exits 64; missing tools or fixtures, EVM faults and executor
failures exit 2.  Compilation uses the same checks as `emit` and writes
no output files.

`diff FILE --calldata HEX [--prestate FILE]` compiles the source and
compares storage, returned bytes and revert outcomes under `evm run` and
`evm t8n --state.fork Cancun` (R-M0-8, R-M0-9).  It prints a JSON result
and `DIFF OK` on agreement.  Matching reverts are valid results.  A mismatch,
EVM fault, malformed capture or executor failure exits 2.  Invalid arguments
or calldata exit 64.  Temporary executor files are removed on completion.
The [executor contract](dev/M1-EXECUTOR.md) defines the supported prestate,
the gas adjustment and the remaining M1 work.  Both entry points use geth;
this provides no independent client implementation.

`run FILE [--calldata HEX] [--storage SLOT=WORD]... [--value WORD]
[--export NAME]`
interprets specialized source effects and prints JSON containing status,
returned bytes and storage. It needs no external tools and writes no files.
Storage defaults to empty and describes an already deployed contract.
Constructors are checked but not run. `--export NAME` selects an alternate
entry function. A modeled revert exits zero. Invalid input exits 64 and a
named source refusal exits 2. The [source model contract](dev/M1-RUN.md)
defines the numeric formats, bounds and shared specialization boundary.

`deploy` and `test` still exit 3 with named `PENDING` diagnostics. They
print `PENDING (M1)` today and gain behavior at M4 (R-8a).

M4 deployment support targets anvil, Adiri (Telcoin testnet, chain ID
2017) and Ethereum mainnet (chain ID 1), per R-8a (2026-09-10).
R-8a does not authorize broadcasting transactions.  Chain profiles that
switch PUSH0, TLOAD, TSTORE and MCOPY off for an older L2 come from R-4.
RPC configuration, compatibility checks before broadcast and verification
of deployed code against the emitted runtime hash have no ruling yet and
are open questions.

[CARRIED.md](CARRIED.md) defines the preserved source inventory and records
integration changes.  [SPEC.md](SPEC.md) retains the inherited grammar and R0
counts.  Historical Wasm sections are marked as upstream evidence.
[The build log](dev/M0-BUILD-LOG.md) records the current validation.
[The mutation log](dev/MUTATION-LOG.md) records gate rejection checks.

The `assay_keccak` library exposes `Assay_keccak.Keccak.keccak256` and
`selector`.  Both hash the input string as bytes.  They return lowercase
hex without `0x`: 64 digits for a digest and eight for a selector.
Pass a canonical ABI signature to `selector`, such as
`transfer(address,uint256)`.  Signature parsing belongs to the ABI layer.

The `assay_asm` library exposes `Assay_asm.Asm` and `Assay_asm.Listing`.
`Asm.assemble` takes blocks with declared incoming stack heights.  It returns
a sealed program or a named error.  It checks each instruction, branch edge,
loop edge and fallthrough, including unreachable blocks.  The first block
starts at height zero.  No step may exceed 1024 words, including label pushes.
The assembler supports the 149 legacy Cancun opcodes.  Control instructions
are block endings, and dynamic jumps are refused.

Each block has a label.  Set `destination = true` to emit a `JUMPDEST` at its
start.  `Goto` and `Branch` use explicit PUSH widths from 1 to 32 bytes and
require marked targets.  One layout pass collects label offsets, then encoding
resolves forward and backward references.  A target that does not fit is an
error.  `Next` names the next physical block and emits no jump.
`Push ""` emits `PUSH0`; nonempty operands use lowercase, prefix-free hex.

`Asm.hex`, `Asm.labels` and `Asm.heights` expose the checked bytes, label
offsets and per-block input, output and peak heights.  `Listing.decode`
reads hex bytes independently of the block representation.  It rejects
malformed hex, unknown opcodes and truncated PUSH data.  `Listing.render`
prints hex PCs, mnemonics and exact immediate bytes.  These are library
entry points used by source-to-EVM emission.

The [reference contract](reference/README.md) stores 42 in slot zero and returns
it as a 32-byte word.  Its 20-byte runtime and 10-byte creation prefix have one
comment per instruction.  All execution gates pass the explicit prestate in
`evm/fixtures/cancun.json` to geth.  The trace gate compares the listing and
`cast` rows with the executed path, including the four skipped guard bytes.
The creation gate checks both returned and installed runtime bytes.

Stage E checks Word unboxing and closure-free storage before assembly.
The M0 source fixture emits the exact committed reference bytes. Its ABI is
empty, and its layout declares one full-word slot.  The carried proof seed
is hash-pinned and retains its original fidelity statement.
The [frozen corpus](corpus/README.md) has eight contracts and three
structural proof variants.  `zsh -f dev/ratio.sh` verifies and reports the
frozen wall-time measurements.  The ratio is informational at M0.

The gate battery checks the build, complete inherited kernel suite,
surface suite, driver behavior, pin, carry inventory, R0, house rules,
trusted-line budgets, denominator hash and gate mutations.  It also compares
35 digest and selector vectors with frozen values and live `cast` output.
Four Keccak mutants must fail their named vectors and a restored control
must pass.  The vectors cover binary inputs and the 136-byte rate boundary.
Five malformed adapter invocations must exit 64, and the sealed
`assay_keccak` signature must equal `dev/keccak-iface.txt`.
The assembler checks frozen opcode metadata and stack effects at their lower
and upper limits.  Seven disassembly fixtures, including all 149 opcodes and
every PUSH width, must match live `cast disassemble` and `evm disasm` output.
The comparison normalizes the `DIFFICULTY` spelling to `PREVRANDAO` in the two
oracle transcripts only, and only at offsets where the input byte is `0x44`.
Our own listing is never rewritten, and the all-opcodes fixture must apply the
alias at least once.  The comparison preserves every PC and immediate byte.  Six assembler and listing
mutants must fail, and restored controls must pass.
Stage D adds fork probes for PUSH0, TLOAD, TSTORE, MCOPY and the expected CLZ
refusal.  The transient store and memory-copy probes check nonzero values.
It also rejects 32 corrupt execution captures and eight damaged fixtures,
then requires restored controls to pass.  Gas use and code sizes are reported.
Stage E adds source execution, emitted creation, recognizer mutations,
canonical JSON equality and the carried seed's 42 axiom reports.
Stage F adds execution and creation for all eleven corpus files, exact
five-file hashes, proof-shape byte equality, the frozen ratio report and
seven rejection witnesses.  The M0 trace row verifies all five outputs.
The trace driver also has 20 cases for calldata, path handling, tool
selection and failures.
The executor gate adds 20 live cases, 28 driver cases and 24 rejection
witnesses. The counter reference adds 30 cases, two constructor probes,
eight bytecode mutations and five call-value refusals. Every runtime
instruction is exercised. The core emitter adds 30 source/reference
comparisons on both executor paths, eight general source cases, eleven
refusals and eight compiler mutations with restored controls.
The source model adds 30 counter comparisons against both executors and
the reference, ten extra cases, all eleven M0 corpus programs, driver
and source refusals, and eight mutations with restored controls.
The surface counter has exact five-file equality with the core source.
Its gate adds 30 counter rows, 13 additional execution cases, 35 refusals
through three commands, accepted size boundaries and seven compiler mutations.
`STAGE-M1-SURFACE OK` means all 39 legs pass.
The final M0-EXIT stamp still requires explicit user ratification.
The core counter source, dispatcher, ABI/layout emission, differential gate
and source model are implemented, along with bounded contract/entry/do
sugar. Proof-producing guards, invariant declarations, the source
overflow-freedom theorem and the M1 performance bound remain unfinished.
The core source keeps the inherited grammar and specializes continuations;
it emits no general-purpose closures. The reference was committed before
this emitter targeted it. The [M1 build log](dev/ASSAY-M1-BUILD-LOG.md)
records the current battery and measurement evidence.

The gates require Python 3.11 or newer (`-P`), Foundry `cast` and geth `evm`
on PATH.  The oracles are `cast` 0.3.0 and geth 1.14.12.
The proof seed uses Lean 4.33.1 and the dependencies in its pinned manifest.
The OCaml toolchain is the installed `zxcaml-p1` switch.  The dune scripts
select it and derive the repository root from their own paths.  The library
names `kanon_kernel` and `kanon_surface` stay unchanged for a byte-exact carry.
The tot submodule remains data only and is not needed for the Stage F build.

License: MIT OR Apache-2.0.

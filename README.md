# assay

Assay is a Kanon language fork for EVM contracts.  It inherits the kernel and
surface at `2c2e6e6`.  M0 Stage A supplies the checker, erasure, axiom disclosure
and carry gates.  Stage B adds Keccak-256 and selector derivation.
Stage C adds the Cancun assembler and bytecode listing.
EVM emission is pending Stage E.

```sh
zsh -f dev/dunecho.sh build
_build/default/bin/assay.exe check examples/m0-spine.kan
_build/default/bin/assay.exe check --erased examples/m0-spine.kan
_build/default/bin/assay.exe axioms examples/m0-spine.kan
_build/default/bin/assay.exe spec-count
zsh -f dev/gates.sh
```

New assay sources use `.asy`.  The checker also accepts inherited `.kan`
fixtures and rejects every other suffix with exit 64 (R-M0-1).  The source
grammar is unchanged.  `check --print FILE` prints the checked declarations.
A valid file exits 0, a rejected file exits 1, and invalid arguments, an
unaccepted suffix or a missing path exit 64.

`emit FILE -o DIR` checks and erases its input, then exits 2 with
`EVM_BACKEND_UNAVAILABLE`.  It writes no output.  The inherited
`emit FILE -o DIR --export NAME` arity stays accepted as an alias.  The Wasm
backend and its `build` and `run` commands have been removed.

`trace`, `diff`, `run`, `deploy` and `test` are declared at M0 and exit 3
with a named `PENDING` diagnostic, so a declared name is never reported as a
typo.  `trace FILE --calldata HEX` and `diff FIXTURE` arrive in Stage F, and
`diff` runs the second executor `evm t8n --state.fork Cancun` on the same
prestate (R-M0-8, R-M0-9).  `run` arrives in M1.  `deploy` and `test`
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
entry points; source-to-EVM emission still belongs to Stage E.

Stage D adds the Cancun reference fixture.  Stage E adds EVM emission, recognizers, JSON
outputs and the proof seed.  Stage F measures the frozen corpus.

The Stage C gate battery checks the build, complete inherited kernel suite,
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
mutants must fail, and restored controls must pass.  Stage C disassembles bytes;
execution under the explicit Cancun prestate starts in Stage D.
It prints pending backend stages and does not claim the M0 exit gate has passed.

The gates require Python 3.11 or newer (`-P`), Foundry `cast` and geth `evm`
on PATH.  Stage C was checked with `cast` 0.3.0 and geth 1.14.12.
The OCaml toolchain is the installed `zxcaml-p1` switch.  The dune scripts
select it and derive the repository root from their own paths.  The library
names `kanon_kernel` and `kanon_surface` stay unchanged for a byte-exact carry.
The tot submodule remains data only and is not needed for the Stage C build.

License: MIT OR Apache-2.0.

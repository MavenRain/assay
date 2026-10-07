# assay

Assay's compiler, trusted kernel, frontend, EVM backend and test adapters are
implemented in Bend 2. The pinned compiler emits JavaScript for Node.js;
the hand-written JavaScript boundary only provides operating-system effects.
See [the migration notes](dev/BEND2-MIGRATION.md) for the source layout,
audit boundaries and validation evidence. The [byte-string IO follow-up](dev/BEND2-IO.md)
removes temporary byte lists from file transfers and repairs compiler discovery
in mutation-test copies.
The [keyword-dispatch follow-up](dev/LEXER-KEYWORDS.md) removes per-identifier
keyword-list construction and lookup while preserving the core vocabulary.
The [direct-conversion follow-up](dev/LEXER-DIRECT.md) removes redundant
character streams from lexer input, identifier and numeric conversions.
The [identifier follow-up](dev/IDENTIFIER-DIRECT.md) removes the same
stream from emitter identifier recognition.
The [word-parser follow-up](dev/WORD-DIRECT.md) removes stream construction
when stripping a hexadecimal word prefix.
The [substring follow-up](dev/SEGMENT-DIRECT.md) removes stream and list
construction from executor substring extraction.
The [CLI prefix follow-up](dev/CLI-PREFIX-DIRECT.md) removes stream and list
construction from calldata and caller normalization.
The [trace value follow-up](dev/CLI-VALUE-DIRECT.md) removes Series
round trips from decimal value normalization.
The [trace error follow-up](dev/CLI-ERROR-DIRECT.md) removes Series
round trips from whitespace compaction during response error detection.
`assay mapping-slot BASE TYPE KEY [TYPE KEY]...` exposes typed scalar and
nested [mapping storage locations](dev/M2-MAPPING.md#command-line).
It prints an unsigned decimal slot for inspection or `run --storage` inputs;
`assay mapping-layout FILE` inspects typed mapping source declarations,
including nested mappings and packed scalar neighbors. See the
[mapping source notes](dev/M2-MAPPING-SOURCE.md). Source contracts now support
[mapping reads and writes](dev/M2-MAPPING-RUNTIME.md), including nested keys,
constructor initialization and packed scalar neighbors.
Source entries accept [typed function calldata](dev/M2-FUNCTION-ABI.md),
including canonical dynamic strings, byte-length queries and calldata data addresses.
They also support [typed results and custom errors](dev/M2-RETURN-ABI.md),
including canonical string payloads and scalar bounds with storage rollback.
`assay event-encode NAME [--anonymous] [TYPE indexed|data VALUE]...` exposes
the [typed event codec](dev/M2-EVENTS.md#command-line). It prints JSON topics
and data for log inspection, including indexed string hashes and dynamic
data fields. Source entries support [event declarations and log emission](dev/M2-SOURCE-EVENTS.md).
The [source ERC20 fixture](dev/M2-SOURCE-ERC20.md) composes typed metadata,
balances, allowances, transfers and approvals with those events. String results
also accept `pure (string 0xHEX)` literals of up to 31 bytes.
`assay event-decode NAME [--anonymous] --topics HEX[,HEX]... --data HEX [TYPE indexed|data]...`
exposes the [strict event decoder](dev/M2-EVENT-DECODE.md#command-line).
It prints typed JSON values, preserves string bytes as hexadecimal, and
identifies indexed string hashes separately.
`assay returndata-encode [TYPE VALUE]...` and
`assay returndata-decode HEX [TYPE]...` expose the
[typed function result codec](dev/M2-RETURNDATA-CLI.md), including empty
returns and dynamic strings. The [Bend 2.0.28 upgrade](dev/BEND2-UPGRADE.md)
updates the pinned compiler and its JavaScript effect registration boundary.

The [M2 ABI gate](dev/M2-ABI-GOLDENS.md) compares the complete source ERC20 ABI
with its pinned golden and checks negative Lean witnesses and proof erasure.
The [M2 reconciliation](dev/M2-RECONCILE.md) audits budgets, provenance,
coverage and documents against the code. M2 remains open pending a passing
cumulative battery on the final source hashes. The
[M2 closure](dev/M2-CLOSE.md) records the group 9 closure battery
attempt and subsequent focused reruns.
Milestone work proceeds through the [grouped M2, M3 and M4 plan](dev/MILESTONE-GROUPS.md),
with at most ten implementation turns allocated to each milestone. The compiler speed gate now
belongs to [M4](dev/M4-SPEED.md), as requested on 2026-10-01, with the same
Assay/Bend 2 ratio limit of 1.0. The
[M2 source packing slice](dev/M2-SOURCE-PACKING.md) compiles typed storage
declarations into checked EVM reads, writes and constructor initialization.
The [packed source model](dev/M2-PACKED-MODEL.md) runs the same typed
contracts against physical storage words. Its tests compare its results
with Cancun execution.

The [storage and refinement certificates](dev/M2-STORAGE-PROOFS.md)
check scalar bounds and packed-field locations in Lean with thirteen
term-mode theorems. `write_total` proves that the runtime certificate
check accepts every valid write, so readback and preservation of
neighboring bits hold for every write on valid input. A strict
per-theorem axiom oracle, an erasure check, a 17-row lexical corpus and
executable comparisons against the production storage API cover the
recorded corpus. The ratified Prop-valued Word refinement over a Type 0
index is accepted by the M0 protocol as an erased `InRange` witness on
`word`, checked by the kernel with no new former (width 256 only).

The [M1 closure gate](dev/M1-CLOSE.md) combines the bounded counter,
surface, proof and executor checks. The [first M2 slice](dev/M2-REFERENCE.md) adds a frozen,
hand-assembled [ERC-20 reference](reference/erc20/README.md), with mappings,
events and dynamic string returns. The [second M2 slice](dev/M2-ABI-SCHEMA.md)
adds typed ABI metadata and checks the printer against that reference.
The [third M2 slice](dev/M2-ABI-CODEC.md) adds typed ABI tuple encoding and
strict decoding, including dynamic strings.
The [fourth M2 slice](dev/M2-PACKING.md) adds packed storage layouts and
checked word access for `uint8`, `uint256`, `address` and `bool`.
The [fifth M2 slice](dev/M2-MAPPING.md) derives checked storage locations
for scalar keys and nested mappings, including the ERC-20 reference slots.
The [sixth M2 slice](dev/M2-EVENTS.md) encodes typed event topics and data,
including anonymous events and indexed strings.
The [seventh M2 slice](dev/M2-CALLDATA.md) encodes complete typed function
calls and strictly decodes their selectors and argument tuples.
The [public calldata commands](dev/M2-CALLDATA-CLI.md) expose
both operations through the command line.
The [eighth M2 slice](dev/M2-RETURNDATA.md) encodes and strictly decodes
function results using the declared output types, including empty returns.
The [ninth M2 slice](dev/M2-REVERTDATA.md) encodes and strictly decodes
typed custom-error revert data, including standard errors and panics.
The [tenth M2 slice](dev/M2-EVENT-DECODE.md) strictly decodes typed event
logs, preserving indexed strings as hashes. TRUSTED-LINES passes under
the source budget the user re-ratified on 2026-09-28: abi 495, assembler
505 and an unchanged total of 3550.
The [source event group](dev/M2-SOURCE-EVENTS.md) connects declarations and
emission to the checked compiler, typed ABI, model and EVM logs. It supports
indexed strings, anonymous events, packed storage, mappings and rollback.
Constructor emission has an explicit refusal.
`zsh -f dev/gates.sh` runs the default 110-leg gate battery, and
`make gates-m4-speed` runs the two M4 speed legs.

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
The sixth adds [source arithmetic proofs](dev/M1-PROOFS.md), with a reusable
Lean transaction model and executable comparisons against assay and Cancun.
The seventh adds [entry tables without arguments](dev/M1-NULLARY.md),
including checked dispatch for contracts containing only nullary entries.
The eighth adds [typed custom reverts](dev/M1-ERRORS.md), including checked
error declarations, derived ABI rows and Word payloads with storage rollback.
The ninth adds [proof-producing guards](dev/M1-GUARDS.md), erased bound
proofs and proof-supplied arithmetic without a second runtime check.
The tenth adds [supplied proof terms](dev/M1-PROOF-TERMS.md), with checked
closed bounds, erased aliases and proof-local bindings.
The eleventh adds [storage invariants](dev/M1-INVARIANTS.md), checked at
construction and successful writes, with erased proof obligations.
The twelfth adds [reusable proof helpers](dev/M1-PROOF-HELPERS.md), with
dependent Word and proof arguments checked before erasure.
The thirteenth adds [proof bundles](dev/M1-PROOF-BUNDLES.md), with
checked pairs, projections and component evidence for storage
invariants.
The fourteenth adds [named predicates](dev/M1-PREDICATES.md), reusable
claims in proof helpers, guard annotations and storage invariants.
Definitions expand to the existing checked propositions before erasure.
The fifteenth adds
[compound storage invariants](dev/M1-COMPOUND-INVARIANTS.md),
with checked evidence for every component of a nested or named bundle.
The sixteenth adds [compound proof guards](dev/M1-COMPOUND-GUARDS.md),
checking nested conditions in order and producing erased proof bundles.
The seventeenth adds [named runtime guards](dev/M1-NAMED-GUARDS.md),
reusing predicates in runtime conditions with checked expansion limits.
The eighteenth adds [inferred guard
evidence](dev/M1-INFERRED-GUARDS.md), checking conditions without a
repeated proof annotation and retaining their erased evidence for
final-state invariants.
The nineteenth adds [inferred arithmetic
proofs](dev/M1-INFERRED-ARITHMETIC.md), letting `addLt` and `subLe`
reuse checked evidence without an explicit proof argument.
The twentieth adds [inferred helper
arguments](dev/M1-INFERRED-HELPERS.md), letting proof helpers reuse
checked evidence for omitted trailing proof arguments.
The twenty-first adds [contextual proof
placeholders](dev/M1-PROOF-HOLES.md), using `_` for checked inference
inside proof expressions and interleaved helper arguments.
The twenty-second adds [inferred proof
bindings](dev/M1-INFERRED-BINDINGS.md), deriving erased binding types
from checked proof expressions in entries and proof-local scopes.
The twenty-third adds [inferred guard
bindings](dev/M1-INFERRED-GUARD-BINDINGS.md), deriving named evidence
from runtime conditions while retaining checked annotations.
The twenty-fourth adds [core EVM context](dev/M1-CONTEXT.md): caller
snapshots, deployer initialization and an explicit model caller.
The twenty-fifth adds [context in contract source](dev/M1-CONTEXT-SURFACE.md),
with caller bindings, deployer initialization and checked constructor
invariants.
The twenty-sixth adds [Word equality](dev/M1-EQUALITY.md), with caller
access checks and erased equality evidence built from existing bounds.
The twenty-seventh adds [hexadecimal Word literals](dev/M1-HEX-LITERALS.md),
with a common numeric representation for constants, guards and proofs.
The twenty-eighth adds [inferred Word bindings](dev/M1-INFERRED-WORDS.md),
letting runtime `let` bindings omit their Word annotation while retaining
the same checked scope and arithmetic evidence.
The twenty-ninth adds [explicit reverting fallbacks](dev/M1-FALLBACK.md),
with typed error payloads for short calldata and unmatched selectors.
The thirtieth adds [differential call values](dev/M1-DIFF-VALUE.md),
with bounded Word inputs and signed Cancun checks through `diff --value`.
The thirty-first adds [trace call values](dev/M1-TRACE-VALUE.md),
with bounded Word inputs and instruction-level inspection through `trace --value`.
The thirty-second adds [trace callers](dev/M1-TRACE-CALLER.md), with bounded
addresses and caller-dependent execution through `trace --caller`.
The thirty-third adds [differential callers](dev/M1-DIFF-CALLER.md), selecting
either of two public signing fixtures through `diff --caller`.
The thirty-fourth adds [payable entries](dev/M1-PAYABLE.md), with explicit
`payable entry` annotations, matching ABI metadata and per-entry value guards.
The thirty-fifth adds [call-value snapshots](dev/M1-CALLVALUE.md), reading
the current call's value with `amount <- callvalue` in contract source.
The thirty-sixth adds [calldata-size snapshots](dev/M1-CALLDATASIZE.md),
reading the complete calldata byte length with `size <- calldatasize`.
The thirty-seventh adds [calldata-word reads](dev/M1-CALLDATALOAD.md),
loading a zero-padded word at any byte offset with `value <- calldataload offset`.
The thirty-eighth adds [contract-address snapshots](dev/M1-ADDRESS.md),
reading the executing contract's address with `self <- address`.

```sh
python3 -P dev/bootstrap-bend.py
make
_build/bin/assay check examples/m0-spine.kan
_build/bin/assay check --erased examples/m0-spine.kan
_build/bin/assay axioms examples/m0-spine.kan
_build/bin/assay spec-count
_build/bin/assay emit examples/Ref20.asy -o Ref20-out
_build/bin/assay trace examples/Ref20.asy --calldata 0x
_build/bin/assay diff examples/Ref20.asy --calldata 0x
_build/bin/assay emit examples/Counter.asy -o Counter-out
_build/bin/assay diff examples/Counter.asy --calldata 0x6d4ce63c
_build/bin/assay run examples/Counter.asy --calldata 0x6d4ce63c --storage 0=7 --storage 1=100
_build/bin/assay emit examples/CounterSurface.asy -o Surface-out
_build/bin/assay emit examples/Nullary.asy -o Nullary-out
_build/bin/assay emit examples/Errors.asy -o Errors-out
_build/bin/assay emit examples/CounterProofs.asy -o ProofCounter-out
_build/bin/assay emit examples/ProofTerms.asy -o ProofTerms-out
_build/bin/assay emit examples/CompoundInvariants.asy -o Bounds-out
_build/bin/assay emit examples/NamedGuards.asy -o NamedGuards-out
_build/bin/assay emit examples/InferredGuards.asy -o InferredGuards-out
_build/bin/assay emit examples/InferredHelpers.asy -o InferredHelpers-out
_build/bin/assay emit examples/ProofHoles.asy -o ProofHoles-out
_build/bin/assay emit examples/InferredBindings.asy -o InferredBindings-out
_build/bin/assay emit examples/ContextCore.asy -o Context-out
_build/bin/assay emit examples/ContextSurface.asy -o ContextSurface-out
_build/bin/assay emit examples/CounterInvariant.asy -o CounterInvariant-out
_build/bin/assay emit examples/ProofHelpers.asy -o ProofHelpers-out
_build/bin/assay emit examples/ProofBundles.asy -o ProofBundles-out
leancho -C verification
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

`calldata-encode NAME [TYPE VALUE]...` prints JSON with a `calldata` field.
`calldata-decode NAME HEX [TYPE]...` prints JSON with a `values` array.
Both support uint8, uint256, address, bool and string, including functions
with no arguments. [The command contract](dev/M2-CALLDATA-CLI.md) describes
value representations, byte limits and strict decoding refusals.

`trace FILE --calldata HEX [--prestate FILE] [--value WORD] [--caller ADDRESS]`
compiles the source and prints geth's JSON
steps, summary and state dump.  It uses the explicit Cancun fixture and
literal process arguments.  Hex may have a `0x` prefix.  M0 programs
ignore calldata.  The default fixture is resolved from the executable's
`_build/bin` location, so the working directory can differ.
Use `--prestate FILE` to select an explicit fixture and `--value WORD`
to set the call value, which defaults to zero. Options can follow the
source in any order and each may appear once. Unsigned decimal and
hexadecimal values up to uint256 are accepted; malformed values produce
`TRACE_VALUE` before compilation. `--caller ADDRESS` selects an unsigned
160-bit caller, using decimal or prefixed hexadecimal syntax. It defaults
to `0x000000000000000000000000000073656e646572`. Invalid addresses produce
`TRACE_CALLER` before compilation. Nonzero value requires a prestate that
funds the selected caller. Invalid arguments or hex exit 64;
missing tools or fixtures, EVM reverts or faults, and executor
failures exit 2.  Compilation uses the same checks as `emit` and writes
no output files.

`diff FILE --calldata HEX [--prestate FILE] [--value WORD] [--caller ADDRESS]` compiles the source and
compares storage, returned bytes and revert outcomes under `evm run` and
`evm t8n --state.fork Cancun` (R-M0-8, R-M0-9).  It prints a JSON result
and `DIFF OK` on agreement.  Matching reverts are valid results.  A mismatch,
EVM fault, malformed capture or executor failure exits 2.  Invalid arguments
or calldata exit 64.  Temporary executor files are removed on completion.
The [executor contract](dev/M1-EXECUTOR.md) defines the supported prestate,
the gas adjustment and the remaining M1 work.  Both entry points use geth;
this provides no independent client implementation.

`--value` defaults to zero and accepts the same bounded decimal or hexadecimal
Word spelling as `run`. Options can follow the source in any order and may
occur only once. Nonzero calls require an explicit prestate that funds the
selected fixture sender; insufficient balance exits 2 without running either executor.
The [call-value contract](dev/M1-DIFF-VALUE.md) gives the numeric limits and
nonpayable behavior.
`--caller` selects the address of public fixture signing key 1 (the default)
or 2. Both geth entry points receive the selected identity. Other addresses
are refused with `DIFF_CALLER` and exit 64 before compilation. The
[caller contract](dev/M1-DIFF-CALLER.md) lists the addresses and prestate rules.

`run FILE [--calldata HEX] [--storage SLOT=WORD]... [--value WORD]
[--caller ADDRESS] [--address ADDRESS] [--export NAME]`
interprets specialized source effects and prints JSON containing status,
returned bytes and storage. It needs no external tools and writes no files.
Storage defaults to empty and describes an already deployed contract.
Constructors are checked but not run. `--export NAME` selects an alternate
entry function. A modeled revert exits zero. Invalid input exits 64 and a
named source refusal exits 2. The [source model contract](dev/M1-RUN.md)
defines the numeric formats, bounds and shared specialization boundary.
`--caller` supplies an unsigned 160-bit address, defaulting to zero.
The optional core `caller` effect reads that execution context.
`--address` independently supplies the model's unsigned 160-bit contract
address, defaulting to zero. The `address` effect reads that input.

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
The [frozen corpus](corpus/README.md) has eight contracts, three
structural proof variants and one untimed M2 ERC-20 contract.
`zsh -f dev/ratio.sh` verifies and reports the
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
alias at least once.  The comparison preserves every PC and immediate byte.  Nine assembler and listing
mutants must fail, and restored controls must pass.
Stage D adds fork probes for PUSH0, TLOAD, TSTORE, MCOPY and the expected CLZ
refusal.  The transient store and memory-copy probes check nonzero values.
It also rejects 32 corrupt execution captures and eight damaged fixtures,
then requires restored controls to pass.  Gas use and code sizes are reported.
Stage E adds source execution, emitted creation, recognizer mutations,
canonical JSON equality and the carried seed's 42 axiom reports.
Stage F adds execution and creation for all twelve corpus files, exact
five-file hashes, proof-shape byte equality, the frozen ratio report and
seven rejection witnesses.  The M0 trace row verifies all five outputs.
The trace driver also has 20 cases for calldata, path handling, tool
selection and failures. The trace-value gate adds 36 execution comparisons,
two funding faults and 34 input refusals.
The trace-caller gate adds 45 execution comparisons, two funding faults
and 31 input refusals, including caller operands and access-check rollback.
The differential-caller gate adds 45 signed execution comparisons, four
funding or nonce refusals, 33 input refusals and five adapter refusals.
The executor gate adds 21 live cases, 28 driver cases and 24 rejection
witnesses. The counter reference adds 30 cases, two constructor probes,
eight bytecode mutations and five call-value refusals. Every runtime
instruction is exercised. The core emitter adds 30 source/reference
comparisons on both executor paths, eight general source cases, eleven
refusals and eight compiler mutations with restored controls.
The source model adds 30 counter comparisons against both executors and
the reference, ten extra cases, all twelve corpus programs, driver
and source refusals, and eight mutations with restored controls.
The surface counter has exact five-file equality with the core source.
Its gate adds 30 counter rows, 14 additional execution cases, 36 refusals
through three commands, accepted size boundaries and eight compiler mutations.
The nullary gate adds 53 source/EVM comparisons, two constructor cases,
four checked schema refusals and three mutations with restored controls.
The custom error gate adds 66 source/EVM cases, 26 refusals and five
mutations with restored controls. The proof guard gate adds 83 cases,
26 refusals, three erased proof variants and six mutations with controls.
The supplied proof gate adds 98 cases, 25 refusals, five closed proof
variants and four mutations with controls. The invariant gate adds 52
cases, 30 refusals, four erased variants and four mutations with controls.
The proof helper gate adds 104 cases, 50 refusals, seven closed erasure
variants and four mutations with controls.
`STAGE-M1-PROOF-HELPERS OK` requires all 47 legs to pass, including
source proofs.
The payable gate adds 216 core execution comparisons, 24 signed comparisons,
eight artifact pairs, six surface cases, four public command calls, two
creation outcomes, 18 refusals and four mutations with restored controls.
The call-value gate adds 480 core comparisons, 18 signed comparisons,
16 artifact pairs, 12 surface cases, two public command calls, 13 refusals
and four mutations with restored controls.
The calldata-size gate adds 1024 core comparisons, 28 signed comparisons,
32 artifact pairs, 16 surface cases, two public command calls, 13 refusals
and five mutations with restored controls.
The calldata-word gate adds 2240 core comparisons, 35 signed calls,
64 artifact pairs, 31 surface cases, two public command calls, 18 refusals
and five mutations with restored controls.
The address gate adds 1920 core comparisons, 128 artifact pairs,
40 surface cases, 55 signed calls, seven public command checks,
24 refusals and five mutations with restored controls.
`dev/gates.sh` and `make gates` select `--m2-reconcile`: the 75
`--m1-close` legs (proof-bundle, named-predicate, compound-invariant,
named-guard, inferred-guard and inferred-arithmetic suites), then
ERC20-REFERENCE, ABI-SCHEMA, ABI-CODEC, LAYOUT-PACKED, LAYOUT-MAPPING,
EVENT-CODEC, CALL-CODEC, RETURN-CODEC, REVERT-CODEC, EVENT-DECODE,
LEXER-KEYWORDS, LEXER-DIRECT, IDENTIFIER-DIRECT, WORD-DIRECT,
SEGMENT-DIRECT, CLI-PREFIX-DIRECT, CLI-VALUE-DIRECT, CLI-ERROR-DIRECT,
MAPPING-CLI, EVENT-CLI, EVENT-DECODE-CLI, CALLDATA-CLI, MILESTONE-SPEED,
PACKED-SOURCE, MAPPING-SOURCE, RETURNDATA-CLI, MAPPING-RUNTIME, FUNCTION-ABI,
RETURN-ABI, SOURCE-EVENTS, STORAGE-PROOFS, ERC20-SOURCE,
[M2-ABI](dev/M2-ABI-GOLDENS.md),
[M2-RECONCILE](dev/M2-RECONCILE.md) and REFINED-WORD, for 110 legs.
`--m2-abi` retains its 108 legs.
`--m2-source-erc20` retains its 107 legs.
`--m2-storage-proofs` retains its 106 legs.
`--m2-source-events` retains its 105 legs. `--m2-return-abi` retains its
104 legs. `--m2-function-abi` retains its 103 legs.
`--m2-mapping-runtime` retains its 102 legs.
BEND2-RATIO and BEND2-RATIO-TEST moved to `--m4-speed` (`make gates-m4-speed`)
on 2026-10-01. Each earlier mode keeps its other legs: `--m2-returndata-cli`
has 101, `--m2-mapping-source`
has 100, `--m2-source-packing` 99, `--lexer-direct` 93,
`--keyword-dispatch` 86, `--m2-event-decode` 85, `--m2-revertdata` 84,
`--m2-returndata` 83, `--m2-calldata` 82, `--m2-events` 81,
`--m2-mapping` 80, `--m2-packing` 79, `--m2-abi-codec` 78,
`--m2-abi-schema` 77 and `--m2-reference` 76.
The inferred-helper gate adds 254 source/EVM comparisons, two creation
outcomes, 26 refusals, 24 five-file erasure pairs, six accepted boundary
forms and five mutations with restored controls.
The proof-placeholder gate adds 242 source/EVM comparisons, two creation
outcomes, 25 refusals, 23 five-file erasure pairs, six accepted boundary
forms and four mutations with restored controls.
The compound gate checks 64 execution cases, 24 refusals, eight erasure
variants, ten boundary forms and four mutations with restored controls.
The [compound guard gate](dev/M1-COMPOUND-GUARDS.md) adds 88 execution
cases, 26 refusals, seven erasure variants, seven boundary forms and
four mutations with restored controls. A compound guard checks nested
bounds in source order and supplies their erased proof bundle.
The inferred guard gate adds 112 execution comparisons, two creation
outcomes, 24 refusals, 14 pairs of equivalent five-file outputs, six
boundary forms and four mutations with restored controls.
The inferred arithmetic gate adds 158 execution comparisons, two
creation outcomes, 24 refusals, 16 pairs of equivalent five-file
outputs and four mutations with restored controls.
The equality gate adds eight five-file comparisons, 53 execution cases,
33 signed Cancun comparisons, eight creation outcomes, six boundary
forms, 17 refusals and four mutations with restored controls.
The [M1 measurement](dev/denominators-m1-2026-09-21-04.json) completes five
interleaved rounds in 9.337 seconds. Its OCaml ratio of 1.469021 is historical.
The [compact assembly slice](dev/M1-COMPACTION.md) (a 2026-09-21 record; its M1-RATIO rows are historical)
removes the redundant assembly pass and preserves the existing bytecode
selection policy.
The compilation speed requirement is now **at least as fast as Bend 2**,
per the user ruling of 2026-09-22. This replaces all previous milestone
compilation speed requirements. Compare parse-through-output time, ending
at the five files on disk, against Bend 2 on equivalent frozen workloads.
Require an Assay/Bend 2 compilation-time ratio <= 1.0, with pinned toolchains,
the same machine and matched cache conditions. Speed is informational at
M0 and binding from M1 onward. The [Bend 2 gate](dev/M1-BEND2.md) now pins
six paired pure programs, checks their emitted outputs, and measures five
alternating rounds. The default battery
enforces this unrounded comparison with `BEND2-RATIO`; `BEND2-RATIO-TEST`
checks refusals and mutations. New `M1-RATIO` and `M0-RATIO` measurements
use the pinned Bend compiler and checker as denominators. Earlier reports
remain historical diagnostics. `DENOMINATORS` continues to verify
the compiler source inventory. The [earlier timing diagnosis](dev/TIMING-DEBUG.md)
remains recorded.
The final M0-EXIT stamp still requires explicit user ratification.
The core counter source, dispatcher, ABI/layout emission, differential gate
and source model are implemented, along with bounded contract/entry/do
sugar, typed custom reverts, proof-producing guards and bounded supplied
proof terms and bounded storage invariant declarations. The Lean source
model has an overflow-freedom theorem with tested compiler correspondence.
The core source keeps the inherited grammar and specializes continuations;
it emits no general-purpose closures. The reference was committed before
this emitter targeted it. The [M1 build log](dev/ASSAY-M1-BUILD-LOG.md)
records the current battery and measurement evidence.

The gates require Python 3.11 or newer (`-P`), Foundry `cast` and geth `evm`
on PATH.  The oracles are `cast` 0.3.0 and geth 1.14.12.
The proof seed uses Lean 4.33.1 and the dependencies in its pinned manifest.
The build uses Bend 2.0.32 at the commit in `dev/toolchain.json`, Node.js 22
or newer, and Python 3.11 or newer. Bootstrap needs Git and Bun to build the
pinned Bend CLI. An existing checkout can be selected with `BEND=/path/to/bin/bend`.
`dev/build.sh` derives the repository root from its own path. Build receipts
bind the generated program to its source, compiler and effect boundary.

License: MIT OR Apache-2.0.

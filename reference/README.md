# The Stage D reference contract

`ref20.evm` contains the 20 runtime bytes from `dev/SPIKE-TRACE.md`.
It stores 42 in slot zero, jumps over four INVALID guard bytes, reads the
stored value and returns it as a 32-byte memory word.  The file records hex
PCs, bytes, mnemonics, PUSH operands and one comment per instruction.

`ref20-init.evm` contains a 10-byte creation prefix.  The gate appends the
runtime bytes to that prefix.  The prefix copies the 20-byte suffix from
code offset 10 to memory offset zero, then returns it.  Creation installs
that returned code.  The constructor leaves storage empty; the runtime
performs the store when called.

Build, then run the checks:

```sh
zsh -f dev/dunecho.sh build
python3 -P dev/reference-test.py trace
python3 -P dev/reference-test.py create
zsh -f dev/fork-check.sh
python3 -P dev/reference-test.py checks
python3 -P dev/reference-test.py mutants
```

The `trace`, `create`, `checks` and `mutants` modes read the Stage C listing
artifact `_build/default/test/asm_cases.exe`.  Without the build they fail
with `BUILD-MISSING`.  The `fork` mode reads no build artifact.

These are fixture gates.  `assay emit` remains pending Stage E, and the
driver's `trace` and `diff` commands remain pending Stage F.

The runtime gate compares the annotated source with the Stage C bytecode
decoder and the checked assembler fixture.  It compares all 17 listing rows
with `cast disassemble`.  geth executes 13 of those rows.  The gate checks
their exact order, opcode numbers, mnemonics and stack snapshots.  The four
unexecuted rows are PCs 7, 8, 9 and 10.  The result must be the 32-byte value
42, and the receiver dump must contain exactly storage slot zero = 42.

The creation gate uses `evm run --create`.  It checks the prefix trace,
returned bytes, installed code and empty constructor storage.  The runtime
SHA-256 in the report hashes decoded bytes, rather than the hex text file.
Gas is reported as the value from geth's summary.  These local measurements
do not include transaction intrinsic gas or establish a performance bound.

Every execution uses `evm/fixtures/cancun.json`, an explicit gas limit of
16,777,216, and fixed sender and receiver addresses.  It never relies on the
executor's default fork.  The prestate is the Stage 0 fork fixture promoted
to the repository.  geth runs in memory; these commands start no node and
broadcast no transaction.  The complete command, status, stdout and stderr
of each oracle call made in this tree are saved under `.gatework/reference/`.
The `mutants` gate also calls the oracle inside temporary mutation copies.
Those receipts stay in the copy and are removed with it; the transcript of
every mutation and restored control is kept as `.gatework/reference-mutant-*`
and `.gatework/reference-control-*`.

`PUSH0` is the Shanghai instruction defined by
[EIP-3855](https://eips.ethereum.org/EIPS/eip-3855).
The Cancun transient storage operations are defined by
[EIP-1153](https://eips.ethereum.org/EIPS/eip-1153).
Stage 0 measured a correction to the plan's literal negative-control recipe:
removing `cancunTime` alone keeps PUSH0 enabled, but TLOAD fails.  Removing
both `cancunTime` and `shanghaiTime` produces `invalid opcode: PUSH0`.
Both controls are required by Stage D, with plain diagnostics also checked.
See `dev/SPIKE-FORK.md` section 3.1 for the original evidence.

Fork probes cover PUSH0, TLOAD, a nonzero TSTORE/TLOAD round trip, a nonzero
MCOPY and the expected CLZ refusal on geth 1.14.12.  A zero process exit is
insufficient: geth can return exit zero while its JSON summary holds an EVM
error.  Successful probes reject every execution error.  The CLZ probe
requires the named error in both its final step and its summary.

`checks` damages copies of successful live captures to verify that missing,
duplicated and reordered rows, wrong opcodes, stacks, return values, storage,
installed code and error fields fail.  It also rejects malformed JSON object
shapes and duplicate keys.  Unchanged captures must still pass.
`mutants` edits temporary fixture copies, reruns the same gates, checks their
named failures and restores all three positive gates.

M0-TRACE prints `scope=reference` at Stage D.  CREATE-EQ prints the byte
counts and the installed flag; the runtime and returned SHA-256 digests of the
plan's declared creation line are printed on the `CREATE-MEASURE` line that
precedes it, beside the creation gas.  The five compiler output files,
emitter recognizers and proof seed remain Stage E work.  This stage does
not claim the final M0 exit gate or the second-executor comparison.

# Native Bend 2 implementation

The migration base is Assay commit
`2cd3259f10d085dfedb405395d9adb341ef816ed`. The implementation uses Bend 2.0.25
at `c65bcb788dbfb298bb434c1d858b47c193841dc0`. Production algorithms are
implemented in Bend. The compiler emits JavaScript executed by Node.js.

| Source | Responsibility |
| --- | --- |
| `src/kernel.bend` | Terms, values, checking, evaluation, substitution, arbitrary precision integers and persistent ordered maps |
| `src/frontend.bend` | Parsing, surface elaboration, erasure and printing |
| `src/emitter.bend` | Contract lowering, recognition, proof-aware compilation and source model |
| `src/assembler.bend` | Cancun instructions, stack checks, labels and compaction |
| `src/keccak.bend` | Keccak-256 and selectors |
| `src/abi.bend` | Typed ABI schemas and strict tuple encoding and decoding |
| `src/layout.bend`, `src/listing.bend` | Storage metadata and bytecode listings |
| `src/cli.bend` | Commands, subprocess orchestration and artifact emission |
| `src/tests.bend` | Native kernel assertions, surface and backend adapters, and proof exporters |

Run `python3 -P dev/bootstrap-bend.py` and `make` to build. Bootstrap needs
Git and Bun. An existing checkout can be selected with `BEND=/path/to/bin/bend`.
The builder checks its commit against `dev/toolchain.json`. Running Assay
requires Node.js 22 or newer and Python 3.11 or newer. `./assay` launches the
CLI; `make test` runs the inherited kernel, surface and compaction checks.
`make gates` runs the complete audit and backend battery. Individual native
adapters can be built with `dev/build.sh build test/abi_codec`, for example.

The generated launchers run Bend output in a Node worker with the stack
size pinned in `dev/toolchain.json`. This gives valid deep predicate trees
their own stack without depending on the shell's smaller process stack.
Arguments, standard streams and exit status retain the command-line contract.
The launcher uses Node's [worker resource limits](https://nodejs.org/download/release/v22.15.0/docs/api/worker_threads.html).
It enables Node's [module compile cache](https://nodejs.org/download/release/v23.10.0/docs/api/module.html#module-compile-cache)
under `_build/bend/node-cache` to reduce repeated launcher startup work.
`NODE_COMPILE_CACHE` can select another directory, and
`NODE_DISABLE_COMPILE_CACHE=1` disables this optional optimization.

`dev/bend_source.py` joins declarations and derives forward signatures.
Build receipts hash the bundled source, compiler, toolchain pin and effect
boundary. A cached output is reused only when both its input identity and
output digest match. The source modules contain Bend bodies, not embedded
source in another language. Bend's `@unsafe` annotation does not certify
a function body; this migration makes no new formal verification claim.

`src/os.js` supplies files, byte streams, process arguments, paths and literal
subprocess argument vectors. It contains no integer, hash, codec, assembler
or checker implementation. Its single exception boundary converts operating
system failures to explicit results. Source and artifact bytes use a Latin-1
carrier so the frontend retains byte offsets and binary output behavior.

The trusted-kernel limit remains 4,000 lines. All backend module limits and
the aggregate 3,550-line backend budget remain unchanged. CARRY checks the
native hashes and full source inventory in `dev/native-carry.json` while
retaining the original ancestry pin. R0 checks the native rule annotations.
HOUSE enforces the native style rules, named catch-all inventory, effect
boundary and repository prose rule.

Mutation specifications in `dev/mutations` identify exact native declarations
and source digests. The original behavioral witnesses and restored controls
remain in the harnesses. Compilation failures never count as killed mutants.
`dev/native-maps-test.py` additionally checks lookup, sorted traversal,
replacement, removal, mapping, merging and logarithmic tree height against
an independent dictionary reference.
`dev/native-io-test.py` checks all byte values across the 64 KiB read boundary,
Unicode paths and arguments, missing files, directory reads and write errors.
It also verifies complete output when a pipe reader is delayed.

The routing allocation check uses Node's sampling profiler and object identity
sentinels. It retains the 131,072-byte ceiling and checks copy and allocation
negative controls. Sampled allocation bytes are a runtime-specific observation,
not an exact equivalent of the earlier runtime's allocation counter.

The matched Bend compilation performance requirement remains a ratio of at
most 1.0. Performance reports bind current source and method hashes. Earlier
dated reports describe the pre-migration implementation and are historical
evidence. The old one-off phase profiling program is superseded by the native
matched-corpus measurement tools.

The OCaml source, interfaces, Dune and opam build definitions are removed.
The unused upstream compiler submodule and scripts for the Wasm driver that
Assay removed at Stage A are also removed. Lean statements, proof exports,
fixtures and historical result data remain available.

The [migration validation record](validation/bend2-native/README.md) distinguishes
passing correctness and audit checks from unresolved timing failures. The final
matched performance ratio is 1.346327 against the retained 1.0 requirement;
the full gate battery is not green.

## Review 2026-09-24

The review of this slice ran at HEAD 2cd3259. It kept seven findings. All seven are fixed.

F1: the native validation record named the emitter mutation check as passed while both
EMIT-MUTANTS attempts failed. The record now lists EMIT-MUTANTS as unresolved.

F2: the named-catch-all inventory was vacuous. The check now walks src and dev, it uses a
wider arm regex, and it asserts a non-zero row count. The inventory moves to 473 rows.

F3: the carry check printed files=12/12 diff=0 while it compared 2 of 12 files. All 12 files
are now compared. dev/MUTATION-LOG.md records the check.

F4: the Bend runtime accepted four argv forms that the OCaml driver refused with exit 64.
src/os.js now reads the raw argv. The driver case set moves from 24 to 28 cases.

F5: the R0 count script printed OK when the driver exited non-zero. It now reads the status.

F6: make test exited 0 after 3 of 11 adapters. The check now reports adapters=11 commands=17.

F7: the gate leg deadlines were from the OCaml era. The deadlines are re-derived.

Gate evidence: the fast battery passed 5 of 5 legs on the unfixed snapshot and on every fix
and check unit. The full battery gave ALL-EXIT 1 on both sides. The baseline battery gave
69 PASS and 11 FAIL. The postfix battery gave 69 PASS and 11 FAIL. CALLVALUE and CALLDATASIZE
moved to PASS with the new deadlines. In copies that keep .git, PIN-CARRY, MUTANTS and AXIOMS
pass on both sides with CARRY files=12/12 diff=0, MUTANTS killed=13/13 and sorryAx=0.

Residuals: the performance ratio gate, the three inferred boundary suites, the calldataload
and address suites and the mutation witnesses stay red, as this record states. PIN-CARRY,
MUTANTS and AXIOMS are red in the battery only because the gate copy has no .git directory.
The ABI-CODEC leg hit its 300 s deadline under a box load above 100. Sibling legs with
identical code slowed by the same factor and passed. That leg needs one rerun on a quiet box.
The full gate battery is not green.

The subsequent [byte-string IO follow-up](BEND2-IO.md) refreshes the live
benchmark reports and repairs compiler discovery in mutation-test copies.
The measurements and outcomes above remain the migration review snapshot.

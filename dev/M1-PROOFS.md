# M1 source arithmetic proofs

This sixth M1 slice adds `verification/`, an importable Lean 4.33.1 package
with no external dependencies. It keeps the 28 carried `proofs/` files
byte-identical. All new proofs are pure terms. No axiom, kernel rule or
standard tactic is introduced.

## Statement and boundary

`Word` is `Fin (2^256)`. `checked` returns an explicit success or arithmetic
error, with an erased `Prop` certificate. A successful addition is the exact
natural sum and remains below `2^256`. A successful subtraction requires
the right operand to be no larger than the left and returns their exact
natural difference. Rejected addition means the sum reaches or exceeds the
bound; rejected subtraction means the right operand exceeds the left.
Neither operation returns a wrapped value.

The source transaction grammar has return, abort, store, load, comparison,
and arithmetic with explicit success and error continuations. Arithmetic
success binds a snapshot; failure leaves memory unchanged and evaluates
the error continuation. Abort restores the initial storage. A missing
snapshot is an explicit `SourceError`, separate from a modeled revert.

`source_overflow_free` states that every arithmetic event in an execution
returned by `execute` satisfies the exact arithmetic relation above. The
recursive interpreter constructs an erased certificate as it prepends each
event. The public execution and event records contain no proof fields.
The package also exports exactness and rejection lemmas for each operation,
a word-bound lemma and the direct abort equation. `Axioms.lean` reports
all eleven public theorems and the gate rejects unlisted assumptions,
missing or duplicate reports, and `sorryAx`. The listed assumptions are
`propext`, `Quot.sound` and `Classical.choice`. The current reports stay
inside that set: nine theorems depend on no axiom, and two depend on
`propext` alone.

This is a theorem about the Lean source semantics. Translation from checked
OCaml terms into the specialized transaction grammar, OCaml execution,
the EVM emitter and the executors are tested correspondence boundaries.
There is no machine-checked compiler-correctness or EVM-refinement theorem.
ABI decoding, constructor execution, nonpayable dispatch, resource bounds
and external calls are outside the source theorem. The existing execution
gates continue to cover the implemented dispatcher and constructor behavior.

## Executable evidence

`python3 -P dev/source-proof-test.py` builds the package and runs:

- 226 addition/subtraction cases through the Lean executable and public
  `assay run`, with Python integer expectations. The inputs cover the full
  Cartesian product of nine boundaries and 32 deterministic pairs drawn
  from all 256 bits. Every arithmetic trace is checked, including its length.
- 16 boundary cases through emitted code under both geth Cancun entry
  points, comparing storage, return data and revert outcomes.
- Six core-source cases that recover explicitly from arithmetic errors.
- Seven effects cases for storage snapshots, snapshot overflow, all three
  comparison outcomes, clearing a slot and reading an absent slot.
- Thirteen malformed adapter inputs, six named mutations with restored
  controls, and four axiom-report rejection controls.

`verification/Main.lean` is a test adapter outside the library. It accepts
one JSON argument describing a transaction, storage and memory. Numbers
are decimal strings. Words must be below `2^256`; each input has at most
65536 bytes, each table has at most 1024 distinct keys, and transaction
depth is at most 129 nodes. The adapter exits 0 with a JSON result, exits
2 with an `{"error": ...}` object for a refused input or a modeled
`SourceError`, and exits 74 when it cannot write its output. This format
is for the correspondence gate and is not a new assay command or source
syntax.

The proof gate requires the pinned installed Lean toolchain and never
skips. The complete battery has 41 legs and ends in `STAGE-M1-PROOFS OK`.
The two EVM execution paths use geth and are not independent clients.

## Carried surface fixes and remaining work

The two findings from the surface review are fixed here. Constructor result,
revert and guard refusals report their offending token, with all three
positions checked through the public commands. Core routing no longer
allocates a list for the complete source or first identifier. A dedicated
test checks identity-preserving routing of three 1 MiB core inputs under a
131072-byte allocation ceiling. The third input starts with the eight
bytes of `contract` and continues into a longer identifier, so it runs
the complete keyword walk before the router returns the source unchanged.

The changed compiler receives a fresh frozen M0 timing report, using the
existing one-minute method and unchanged bounds. No M1 performance verdict
is inferred from that report. The [guard slice](M1-GUARDS.md) adds
proof-producing surface guards and erased source proof binders. Its new
constructors are outside this Lean model. Invariant declarations remain
unfinished at this slice. The
[nullary slice](M1-NULLARY.md) implements entry tables without arguments.
The [typed error slice](M1-ERRORS.md) tests custom revert encoding and
rollback; its payloads are outside this Lean model. M1 exit remains
the user's ratification.

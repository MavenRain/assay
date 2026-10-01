# M2 typed event log encoding

This slice starts at `a1e7440` and adds `Abi.Event` in native Bend 2.
It constructs topics and data for a log from typed event parameters and
values. Source event declarations and `emit` lowering remain pending.

## API

`Abi.Event.encode(name, inputs, anonymous, values)` takes the existing
`Abi.Schema.Event_parameter` and `Abi.Codec.Value` types. Its result is
`Abi.Event.Result(Abi.Event.Log)`. A log contains an ordered list of
32-byte topics and ABI tuple data, both represented as byte strings.
Supported types are `uint8`, `uint256`, `address`, `bool` and `string`.
Strings follow the codec's byte-string convention; callers supply encoded
bytes, including UTF-8 bytes when representing Unicode text.

For a non-anonymous event, topic zero is the full Keccak-256 digest of its
canonical signature. Indexed scalars are encoded as 32-byte words, while
indexed strings hash their contents without length or padding. Remaining
arguments form one ABI tuple in declaration order. Anonymous events omit
the signature topic. These rules follow the
[Solidity event ABI](https://docs.soliditylang.org/en/latest/abi-spec.html#events).

The encoder rejects more than three indexed parameters for a named event
or four for an anonymous event. Errors distinguish too many topics,
argument-count mismatch, type mismatch and an underlying codec error.
Scalar bounds apply to both indexed and non-indexed values. A failure
returns no partial log. Topic count is checked first; other failures
follow argument traversal and final tuple encoding.

## Validation

Run `python3 -P dev/event-codec-test.py`. The gate checks:

- 71 independent `cast` comparisons, including scalar boundaries, string
  word boundaries, mixed indexed and non-indexed inputs, anonymous events
  and 32 seeded cases. Binary indexed strings include zero and high bytes.
- 21 distinct frozen ERC-20 Transfer and Approval logs.
- 65 production refusals and 13 adapter refusals. Type mismatches are
  refused at indexed and non-indexed positions. Nine rows combine two
  failures and check the error order above. Adapter errors exit 64,
  print their diagnostic on stderr and produce no stdout.
- 12 executions covering LOG0 through LOG4, dynamic data and rollback.
  The test writes production bytes into a small test-only EVM program,
  runs it through geth's two Cancun entry points and checks receipt logs
  against the independent expected bytes. This is not compiler lowering.
- 12 compiling semantic mutants, each killed by a named wrong-answer
  witness. Compiler failures, malformed output and tool failures do not
  count as kills. A rebuilt scratch control passes afterward.

`python3 -P dev/event-compatibility.py` compares all 50 historical gate
modes with the slice base, including deadlines, markers and failure
classes. It also checks that the existing ABI and test source prefixes
and the compiler CLI's reachable Bend bundle retain their original bytes.
Since the keyword-dispatch follow-up, the check accepts one pinned
`Lexer.ident_kind` delta and puts back the BASE declaration before the
compare; see [LEXER-KEYWORDS](LEXER-KEYWORDS.md).
The `--m2-events` mode appends one gate, for 83 checks total. The current
default adds [CALL-CODEC](M2-CALLDATA.md), [RETURN-CODEC](M2-RETURNDATA.md),
[REVERT-CODEC](M2-REVERTDATA.md), [EVENT-DECODE](M2-EVENT-DECODE.md),
[LEXER-KEYWORDS](LEXER-KEYWORDS.md), [LEXER-DIRECT](LEXER-DIRECT.md),
[IDENTIFIER-DIRECT](IDENTIFIER-DIRECT.md), [WORD-DIRECT](WORD-DIRECT.md),
[SEGMENT-DIRECT](SEGMENT-DIRECT.md) and [CLI-PREFIX-DIRECT](CLI-PREFIX-DIRECT.md),
for 93 checks.

The [validation record](validation/2026-09-26-m2-events/README.md) contains
the scoped test results and source hashes. M2 compiler integration,
dynamic ABI lowering and Lean negative mutants remain pending. This
slice does not close M2.

## Performance

This slice changed three pinned compiler sources: `Makefile`,
`dev/build.py` and `src/abi.bend`. The paired Bend 2 report records the
hashes of these sources, so BEND2-RATIO-TEST refused the mapping report.
A fresh paired measurement was then frozen in `dev/bend2-baseline.json`.
Its five rounds completed in a 10.756-second window. The Assay/Bend 2
ratio was 1.150474099. It stayed above the unchanged 1.0 bound, so
BEND2-RATIO still failed. The corpus measurement was not rerun. Its gate
passes, so the mapping corpus freeze is unchanged. Differences between
timing runs do not establish an event-specific performance effect.

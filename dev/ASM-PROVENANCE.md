# Stage C opcode and listing provenance

The opcode baseline is legacy Cancun.  The metadata fixture is transcribed
from go-ethereum v1.14.12.  These sources define the byte values, stack bounds
and Cancun additions:

- [Opcode constants](https://github.com/ethereum/go-ethereum/blob/v1.14.12/core/vm/opcodes.go).
- [Instruction table](https://github.com/ethereum/go-ethereum/blob/v1.14.12/core/vm/jump_table.go).
- [EIP instruction updates](https://github.com/ethereum/go-ethereum/blob/v1.14.12/core/vm/eips.go).

`dev/asm-opcodes.txt` freezes 84 named rows.  The gate expands PUSH0 through
PUSH32, DUP1 through DUP16 and SWAP1 through SWAP16.  The result has 149 unique
byte values.  For DUPn, pops=n and pushes=n+1 describe its minimum depth and
net height change.  For SWAPn, both counts are n+1.  The assembler does not
model the values on the stack.

The stack gate compares all metadata with that fixture.  It then probes each
body opcode at its minimum input height, one below that minimum when positive,
and the 1024-word limit.  Separate cases cover control instructions and block
edges.  Dynamic jumps are refused, so every accepted edge has a checked target.
Unreachable blocks are checked against their declared heights.  Their heights
do not claim that execution can reach them.

`dev/asm-test.py disasm` compares the listing with the installed `cast disassemble`
and `evm disasm`.  It stores each raw transcript under `.gatework/asm-disasm`.
Both tools print hex PCs.  The only mnemonic alias normalized is `DIFFICULTY`
to `PREVRANDAO`.  It applies to the two oracle transcripts at offsets where the
input byte is 0x44, and never to our own listing.  The all-opcodes fixture must
apply it at least once, so an oracle release that drops the older spelling makes
the dead alias visible.  Immediate bytes retain leading zeros and their
full PUSH width.  Unknown bytes and truncated operands are rejected by our
decoder; permissive oracle behavior on those inputs is not adopted.

The `ref20` fixture reconstructs the 20 bytes already frozen in
`dev/SPIKE-TRACE.md`.  It is an assembler test at Stage C.  The reference
contract file, Cancun prestate and execution gates remain Stage D work.
Other fixtures exercise a branch join, backward jump, every PUSH width,
every DUP/SWAP depth, all defined opcodes and empty bytecode.  No Stage C gate
executes EVM code or claims agreement on gas, storage or return values.

The assembler enforces stack shape, encoding and label bounds.  Gas limits,
code-size limits and opcode availability on older chain profiles are outside
this Stage C API.  Stack and memory exhaustion in the OCaml host remain
resource limits, as in the inherited checker.

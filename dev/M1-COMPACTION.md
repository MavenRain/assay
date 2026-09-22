# M1 compact assembly

This slice starts at `eebe37e`. M0 emission now selects its label width
before assembling the program, removing the second full assembly pass.
The emitted runtime, init code, ABI, layout and axiom disclosures retain
their existing meanings. M1 dispatch continues to use fixed-width assembly.

`Asm.assemble_compact` counts the encoded instruction bytes, destination
markers and terminators in the original block list. It shrinks two-byte
label operands only when that complete wide encoding fits in 255 bytes.
Conditional branches contribute two operands. PUSH payloads contribute
their actual encoded width. The bounded size count saturates at 256.
Both small and large valid programs then need one assembly pass.
All stack, opcode, label and control-flow validation remains in `assemble`;
a refused compact attempt uses the original assembly diagnostic.

The original threshold is deliberately preserved. A wide encoding of 256
bytes still uses two-byte labels even when the compact encoding would fit
in 255 bytes. This keeps the frozen corpus outputs unchanged.

The emitter uses 1,798 of its 1,800 lines. The new policy is implemented
inside the assembler's existing 600-line budget. No kernel line changes.

## Regression coverage

`test/asm_compact.ml` compares bytes, label positions, stack metadata and
refusals with the previous wide-first selection policy in 618 cases.
It covers unconditional and conditional jumps across the size boundary,
every PUSH payload width from zero through 32 bytes at wide sizes 255 and
256, mixed operand widths, empty programs and malformed inputs. A literal
bytecode check supplies an independent small-program oracle.

The executable runs both under `dune runtest` and within `STACK-HEIGHT`.
The existing core test stanza now declares its four fixture trees and runs
from the build root, fixing its previous `test/fixtures` lookup failure
under `dune runtest`.
The six existing assembler mutations keep their original witnesses.
Three additional mutations exercise the new selection policy:

| Mutation | Change | Killing case |
| --- | --- | --- |
| COMPACT-LIMIT | Permit a 256-byte wide encoding to compact | branch-243 |
| COMPACT-PUSH | Under-count PUSH payload bytes | payload-256-1 |
| COMPACT-BRANCH | Leave conditional operands wide | branch-0 |

## Measurement

The corpus, benchmark script, five output files, warm round, five measured
rounds and one-minute limit are unchanged. The new reports preserve every
sample and command. Attempt 03 measures the committed compiler; attempt 04
measures a fresh build with this change. The active report and checksum
inventory now identify attempt 04. Earlier reports remain unchanged.

| Attempt | Window seconds | Assay ms/kloc | ocamlopt ms/kloc | Ratio |
| --- | ---: | ---: | ---: | ---: |
| 03, baseline | 10.958 | 451.684 | 272.959 | 1.654772 |
| 04, compact assembly | 9.337 | 363.756 | 247.618 | 1.469021 |

The measurements ran under different host loads. They do not establish
an isolated speedup for this code change. Startup diagnostics place most
of the command's time outside the compilation phases for the small Ref20
fixture. Neither measurement meets R3, and `M1-RATIO` still rejects the
active report with `RATIO-BOUND M1 limit=1.0`. M1 remains open.

Validation records are in
[`validation/2026-09-21-m1-compaction/`](validation/2026-09-21-m1-compaction/).

### Review round 2026-09-21 (M1 compact assembly)

C-1 (medium): README.md row 283 published six assembler and listing
mutants while the ASM-MUTANTS gate demands killed=9/9; now the row says
nine, matching dev/asm-test.py and the record ASM-MUTANTS.log.

D-1 (medium): the record README claimed an observed exit 0 for the
repeated Dune check that no record file carries, and a successful run
for DUNE-RUNTEST-FIXED.log; now it says the log ends with SUITE-KERNEL
OK, that the exit status was not captured, that FOCUSED.json keeps the
pre-fix DUNE-RUNTEST failure (exit 1, matched false), and that the
cached asm_compact test did not re-emit ASM-COMPACT cases=618 OK.

C-2 (low): dev/ASSAY-M1-BUILD-LOG.md had no section for the fortieth
M1 slice although every M1-titled predecessor commit added one; now a
dated section above the thirty-ninth names assemble_compact, the 618
cases, killed=9/9 and the attempt 03 and 04 ratios.

D-2 (low): the record README never disclosed that every run executed
in a separate working copy of the staged tree, whose root the scripts
freeze-snapshot.py and startup-probe.py hardcode; now one sentence
names the copy, its HEAD and index, and marks the two scripts as
one-shot records with a write-once target, not reproduction steps.

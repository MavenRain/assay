# Assay M2 build log

## 2026-09-22: ERC-20 reference

Base: `8f61dd5a30b24628317caf5a27544522c221a25e`.

Added a hand-assembled ERC-20 reference before extending source emission.
It has nine methods, two events, balance and nested allowance mappings,
dynamic string returns and a fixed-supply constructor. Frozen ABI, layout,
mapping-key and execution fixtures accompany the commented bytecode.

The runtime is 798 bytes with 431 instructions; the constructor prefix is
107 bytes with 50 instructions. The gate covers every instruction, checks
85 runtime cases under geth run and signed Cancun t8n, and checks four
creations under run. It verifies committed t8n event logs and log operands
from both runtime traces. Eleven bytecode mutants fail their named semantic
witnesses, and every restored control passes.

Validation: all 76 default legs pass in one full run, ending with
`STAGE-M2-REFERENCE OK`. All 45 historical modes preserve their commands,
deadlines, markers and failure classification. The denominator inventory
retains all 137 previous entries, updates only the two gate entry points,
and adds ten pins for the new harness and fixtures. Compiler and kernel
sources and all trusted-code limits are unchanged.

The [validation archive](validation/2026-09-22-m2-reference/README.md)
retains full output, per-leg logs, raw executor and mutation captures,
tool versions and 154 source pins. The existing Bend 2 checks pass; this
slice makes no fresh compilation timing measurement.

Next M2 work: source compiler support targeting the reference, packing,
dynamic ABI input handling and the Lean negative mutants required by M2-ABI.
The current slice establishes a reference and does not close M2.

### Review round 2026-09-22 (M2 reference: the ERC-20 reference gate)

Three review items were applied to the staged tree.

C-1 (medium): README.md still said that dev/gates.sh selects
--m1-close with 75 legs while the staged wrapper execs
--m2-reference; now the paragraph names --m2-reference, the 75
--m1-close legs and the ERC20-REFERENCE leg, for 76 legs.

A-1 (low): reference/erc20/MANIFEST.json declared 13 mutation sites
while the harness applied 11 and nothing tied the two lists; now the
manifest holds the 11 applied sites and dev/erc20-test.py requires
the manifest key set to equal the choices list (ERC20-SITES).

A-2 (low): creates=4 in the ERC20-REFERENCE marker was a literal
return 4; now creation() counts the creations it executed, requires
the count to equal 4 (ERC20-CREATE count) and returns the count.

The marker stays ERC20-REFERENCE cases=85 creates=4 mutants=11
covered=431 scope=reference OK. dev/DENOMINATORS.sha256 rows for
dev/erc20-test.py and reference/erc20/MANIFEST.json await the
record refresh.

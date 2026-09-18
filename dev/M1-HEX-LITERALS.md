# Hexadecimal Word literals

The twenty-seventh M1 slice starts at
`c8f85f7cb4d318c3aefcd4640b08bff4890fc785`. Contract source accepts
hexadecimal constants anywhere it accepts a Word literal:

```text
word 0x10
word 0XAbCdEf
word 0x1234567890abcdef1234567890abcdef12345678
```

The prefix can be `0x` or `0X`; digits can use either case. A literal
has between one and 64 hexadecimal digits, including any leading zeros.
Decimal literals retain their 78-digit limit and uint256 range check.
A hexadecimal literal carries at most 64 digits, so a hexadecimal
value above 2^256-1 is refused by that width rule, and the uint256
range test at `emit/contract.ml:108` guards the decimal path only.
Signs, separators, numeric suffixes, empty prefixes and values outside
the unsigned 256-bit range are refused. Hexadecimal constants are Word
values, with no address type or checksum interpretation.

Both spellings lower to canonical decimal numerals before proof lookup
and core checking. For example, `word 0X0A`, `word 00010` and `word 10`
refer to the same value and can share inferred evidence:

```text
guard (leWord (word 0X0A) a) ;
let difference : Word := subLe a (word 00010) ; pure difference
```

This applies to runtime guards, proof annotations, helper arguments,
named predicates, storage invariants, custom error payloads and literal
constructor stores. Existing decimal programs retain their emitted
artifacts; proof lookup now also recognizes equivalent decimal spellings
with leading zeros. The inherited core syntax remains unchanged.

Literal parsing uses total sequence and Option operations. The shared
binary operand parser replaces two implementations, and guard resolution
reuses the existing condition-to-claim conversion. The combined emitter
remains at 1800/1800 lines. The kernel, assembler, emitter backend, source
model and axiom set are unchanged.

[HexWords.asy](../examples/HexWords.asy) demonstrates a bounded storage
field, mixed-spelling guard evidence, an address constant and a uint256
mask:

```sh
_build/default/bin/assay.exe emit examples/HexWords.asy -o HexWords-out
python3 -P dev/hex-literals-test.py
python3 -P dev/stage-a-gates.py --m1-hex-literals
```

The focused gate compares all five artifacts for 30 hexadecimal and
decimal source pairs. Independent expectations cover 46 outcomes under
the source model and geth, including arithmetic overflow, equality,
caller checks, custom reverts and rollback. Twenty-five outcomes also
use signed Cancun transitions. These execution paths both use geth.
Twenty-three creation cases check constructor storage, returned runtime
bytes and installed code. Twenty-three invalid programs are checked
through `check`, `emit` and `run`; refused emission leaves no output
directory. Four built [compiler mutations](M1-HEX-LITERAL-MUTATIONS.md)
must fail their named witnesses and pass again after restoration.

Earlier gate commands, deadlines and success markers are preserved.
The inferred-guard argument-reversal mutant now targets the shared
conversion. Its exact required failure changes from a compile refusal to
the independent runtime mismatch `MODEL-EXPECTED ig-named-1`; the mutant
and restored control both still run.
The compile-time claim at `emit/contract.ml:319` and the emitted
runtime condition at `emit/contract.ml:499` now come from the
one conversion at `emit/contract.ml:277`, so an argument reversal
inside it is refused only by the runtime expectation and no longer
by the compiler.
Timing remains paused under [TIMING-DEBUG.md](TIMING-DEBUG.md), with
the recorded timing baselines unchanged. This slice makes no performance
or milestone-exit claim. See the
[validation archive](validation/2026-09-18-m1-hex-literals/).

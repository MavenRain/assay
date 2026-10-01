# Direct executor substring extraction

Starting at `a374e662a727785b7e962f0db97953d687550843`, `Model.segment`
uses `NativeString.take` and `NativeString.drop` directly. The predecessor
constructed a Series from the input string, dropped and took characters,
collected a list and rebuilt a string. Both paths apply the existing
`Big.to_nat` conversion to the offset and length. That conversion uses the
magnitude of negative values. The trusted kernel is unchanged.

`python3 -P dev/segment-direct-test.py` compares both compiled implementations
with 1,348 independent Python code-point goldens. Cases cover empty strings,
zero lengths, boundaries, negative magnitudes, oversized natural bounds,
NUL, newlines, combining characters, non-ASCII digits and astral characters.
Three compiled mutants ignore the offset, ignore the length or use the
length as the offset. Each must exit successfully and produce its named
wrong answer. The restored implementation runs afterward.

The eighth exact declaration pin covers only `Model.segment`. Missing,
duplicate and modified pins are rejected. A change to the reachable
`Big.to_nat` helper remains visible in historical bundle comparisons.
Native carry hashes follow the changed emitter source.

`make test` includes the substring check. `make gates` includes the mandatory
`SEGMENT-DIRECT` leg through its existing `--lexer-direct` mode. Schedule
compatibility retains all 56 predecessor modes and requires the current
93 legs, including all five direct-conversion checks. The benchmark method
and 1.0 speed limit retain their requirements.

Validation evidence is recorded under
`dev/validation/2026-09-30-segment-direct`.

The native kernel suite and all 24 commands across 18 adapters pass in the
captured test run. The lexer and remaining test-target commands pass in
scoped follow-ups. The original full `make test` attempt timed out while
compiling the existing input-erasing lexer mutant. The repaired mutation
uses `NativeString.take(0n, src_932)` before list conversion, retaining the
same wrong-answer condition, all 287 input cases and the 180-second compiler
timeout. The direct `Nil{}` variant still timed out with four inputs.
Four lexer builds already in the work directory were reused. The replay
checked that each regenerated Bend source matched its file and that no
source, output, launcher or compiler hash changed during the replay. These
hashes were recorded at replay time. No hash links the reused JavaScript
or launchers to the timed-out run. The replay receipt and all failed and
completed captures are archived. Source budgets and native
carry pass.

The new five-round, six-case measurement was byte-identical to the then-active
`dev/bend2-baseline.json`. It records a ratio of 1.538120777 in an
18.362-second host window starting at 2026-10-01 07:18 UTC. This exceeds
the unchanged 1.0 bound and does not isolate the substring change's speed
effect. The ratio refusal controls pass. BEND2-RATIO, the full milestone
gate battery and M2 source lowering remain open.
The later [CLI prefix continuation](CLI-PREFIX-DIRECT.md) supersedes the active
compiler measurement with its own frozen record.

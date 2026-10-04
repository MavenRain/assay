# M2 source results and custom errors

Entries can return `Word`, `Uint8`, `Uint256`, `Address`, `Bool` or `String`.
Custom error parameters accept the same types. ABI printing uses the declared
types, and return and revert payloads use their canonical tuple encoding.

```text
error Refused (code : Uint8) (message : String)
entry echo (message : String) : Eff Sig String := do pure message
entry fail (code : Uint8) (message : String) : Eff Sig Word :=
  do revert Refused (code) (message)
entry narrow (value : Word) : Eff Sig Uint8 := do pure value
```

Scalar results and error arguments are bounded at termination. Uint8 admits
0 through 255, Address admits 160 bits, Bool admits 0 or 1, and Uint256 admits
256 bits. A failed bound produces an empty revert and restores the initial
storage. Source checking still uses the carried Word proof core. The storage
and refinement obligations in M2 group 5 remain open.

String results and String error arguments may refer to String parameters
in the current entry. `pure message` and `pure (message)` return such a
parameter. Results also accept [constant byte strings](M2-SOURCE-ERC20.md#constant-string-results)
of up to 31 bytes through `pure (string 0xHEX)`. Other String construction,
concatenation and multiple results retain explicit refusals. Arbitrary bytes
are preserved; UTF-8 is optional.
Each String parameter operand keeps its own calldata offset, including repeated operands
and multiple dynamic error fields. The emitter copies data into fresh memory
and writes tuple offsets, lengths and zero padding.

Typed result entries use canonical input tuple decoding even when an input is
declared Word. Entries with only Word inputs and a Word result keep the carried
decoding behavior. Typed errors use their declared selector. Empty errors keep
their four-byte selector. Typed calldata and each final payload have a 131072-byte
cap; an error payload's selector counts toward its cap. Duplicating a String
can exceed the output cap even when the input is within its cap. The suite
accepts a 131012-byte error payload and rejects a 131076-byte one, so the
selector bytes count.

Known limit. Each typed result and each typed error stores a cursor word at
base+131104, where base is 96 bytes above the highest mapping or error scratch
address (65632 for the example). This expands memory to about 196768 bytes on
every typed call, about 92k gas for memory alone, even for a Uint8 result.
Word-only entries keep the carried path and do not pay this cost. M4 will place
the length, end and cursor words directly after the tuple head.

The model uses the shared return and revert codecs. The emitter checks bounds
and payload size before returning or reverting. Both handlers compose with
packed storage and mapping access. The example is
[ReturnData.asy](../examples/ReturnData.asy).

`python3 -P dev/return-abi-test.py` checks independent cast encodings against
the model, geth run and Cancun t8n. It covers scalar boundaries, empty and
multibyte strings, arbitrary bytes, multiple tails, malformed calldata,
output overflow, rollback, packed neighbors, mappings and source refusals.
The suite has 49 ordinary and cap cases, eight layout and isolated-error cases,
and 30 source refusals. The large duplicated-string cap fixture uses a bounded
feature-specific geth run and t8n adapter; the shared differential domain stays
unchanged.
The cumulative schedule was `python3 -P dev/stage-a-gates.py --m2-return-abi`.
It adds mandatory RETURN-ABI to the 103 carried function ABI legs, for 104.
`--m2-source-events` adds
[SOURCE-EVENTS](M2-SOURCE-EVENTS.md), for 105 legs. `--m2-storage-proofs`
adds [STORAGE-PROOFS](M2-STORAGE-PROOFS.md), for 106 legs. The current
default, `--m2-source-erc20`, adds [ERC20-SOURCE](M2-SOURCE-ERC20.md), for
107 legs.

The trusted artifact budgets remain unchanged. `src/return_abi.bend` is admitted
as compiler source without a line budget, following `src/function_abi.bend`.
It generates encoding instructions and interprets typed model outcomes.
M2 group 8 must review this source boundary. Changing an artifact price requires
the same user ruling documented for the function ABI boundary.

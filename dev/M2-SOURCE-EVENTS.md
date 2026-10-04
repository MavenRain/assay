# M2 source events

Contracts declare events using the existing ABI value types. Each parameter is
parenthesized, and `indexed` follows its type. `anonymous` follows the final
parameter. Emission is an effect step ending with a semicolon.

```text
event Transfer (from : Address indexed) (to : Address indexed) (amount : Uint256)
entry transfer (from : Address) (to : Address) (amount : Uint256) : Eff Sig Word :=
  do emit Transfer (from) (to) (amount) ; pure amount
```

`Word`, `Uint8`, `Uint256`, `Address`, `Bool` and `String` share the typed ABI
schema. Named events have at most three indexed fields; anonymous events have
at most four. Indexed scalars are canonical 32-byte words. Indexed strings
hash their bytes without ABI length or padding. Remaining values form one
canonical ABI tuple. Empty anonymous events use LOG0, and four indexed
anonymous fields use LOG4. Strings must name a String parameter of the current
entry. Constructor emission has an explicit EVENT refusal.

The source pass introduces reserved `assayEvent` declarations and guards to
carry arguments through the checked core. The emitter and model interpret the
generated failure branch as a log followed by its continuation. The generated
guard proves only `Le 0 0`, and both emitter branch destinations lead through
the log. Emission supplies no false evidence for subsequent source proofs.
Internal
errors stay out of the public ABI. Event declarations preserve field names,
types, indexing and anonymity. Logging entries are nonpayable or payable;
read-only entries retain their inferred view mutability.

Both execution handlers check scalar bounds and the 131072-byte tuple limit.
They retain emission order and discard all logs and storage writes on a
subsequent revert, arithmetic failure, invalid event value or invalid result.
Mapping reads and writes, packed neighbors, typed return data and custom errors
compose with logs. Existing calldata validation runs before the handler.

`assay run` includes a `logs` array for contracts with event declarations.
Each log has ordered `topics` and `data`, represented as lowercase hex strings
with a `0x` prefix. `assay abi` and exported `abi.json` include event rows.

`python3 -P dev/event-source-test.py` compares the model with independent cast
encodings, geth runner LOG stack and memory witnesses, and Cancun t8n receipt
logs. It checks named and anonymous topic limits, zero topics, dynamic strings,
indexed scalar bounds, multiple emissions, packed storage, mapping access,
payable calls, output caps and rollback. Source mutants check declarations,
arguments, reserved names and the constructor refusal. Emit argument count and
String argument refusals carry the EVENT code at the emit token. A reserved
name refusal points at the first reserved token. An event without a parameter
list is refused at its name.

The cumulative schedule was `python3 -P dev/stage-a-gates.py --m2-source-events`.
It preserves the 104 return ABI legs and appends mandatory SOURCE-EVENTS, for
105. `--m2-storage-proofs` adds [STORAGE-PROOFS](M2-STORAGE-PROOFS.md), for
106 legs. The current default, `--m2-source-erc20`, adds
[ERC20-SOURCE](M2-SOURCE-ERC20.md), for 107 legs. The separate M4 speed
schedule and existing deadlines remain unchanged.

The trusted artifact budgets remain unchanged. `src/event_source.bend` is
admitted as compiler source without a line budget, following the function and
return ABI source modules. M2 group 8 must review this source boundary under
the existing budget rules. Storage and refinement obligations, complete ERC20
composition and M2 closure remain open.

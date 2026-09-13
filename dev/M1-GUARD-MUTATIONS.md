# Proof guard mutation witnesses

`dev/guard-test.py mutants` copies source to a temporary directory,
changes one compiler rule, builds it and requires a named witness to
fail. The same witness must pass after restoring that file. The copy
excludes caches and retained validation evidence.

| Mutation | Changed rule | Required failure |
| --- | --- | --- |
| CLAIM | Replace the declared claim with the runtime condition | `ERROR-REFUSAL` on a reversed claim |
| SCHEMA | Allow a modified `wordNat` definition | `ERROR-REFUSAL` on the checked false definition |
| SUB | Specialize proved subtraction as addition | `MODEL-EXPECTED` for `9 - 4` |
| OVERFLOW | Swap the overflow guard's continuations | `MODEL-EXEC` on `MAX + 1` |
| MODEL | Store zero as the proved result in the source model | `MODEL-EXPECTED` for `9 - 4` |
| OPCODE | Reverse operands in the emitted proved subtraction | `COUNTER-EXPECTED` for `9 - 4` |

Each mutant must compile without errors or warnings. Failure to build
does not kill a mutant. Both executable witnesses compare independently
specified output and storage with the source model and both Cancun
execution paths. Refusal witnesses also require the correct exit code,
empty stdout and no output directory. Complete transcripts and controls
are retained with the slice's validation evidence.

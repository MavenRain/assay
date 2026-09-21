# Calldata-word mutation witnesses

`dev/calldataload-test.py mutants` builds each mutation in a temporary
copy, checks its named failure, restores the source and repeats the same
command successfully. Compiler errors do not count as killed mutations.

| Mutation | Change | Witness |
| --- | --- | --- |
| SURFACE | Bind the offset instead of reading calldata | `PAYABLE-MODEL cdl-read-0` |
| EMITTER | Read memory with `MLOAD` instead of calldata | `PAYABLE-EVM cdl-read-0` |
| MODEL | Pad a partial word with ones | `PAYABLE-MODEL cdl-read-31` |
| SCHEMA | Accept a 160-bit offset declaration | `CALLDATALOAD-REFUSAL wrong-width` |
| SNAPSHOT | Reuse the calldata result's memory slot | `PAYABLE-MODEL cdl-snapshot` |

The `PAYABLE` assertion prefix comes from the shared outcome harness.
Each expected output and storage state is independent of the source
model and checked against both model execution and Cancun execution.
The records retain source hashes and mutant/control command results.

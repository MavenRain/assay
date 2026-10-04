# Assay milestone groups

The remaining roadmap is grouped into at most ten implementation turns per milestone. A turn owns a complete feature group, its relevant checks, its review, and staged changes. Tool calls and fixes within that turn do not create extra groups. Completion depends on the milestone acceptance gate passing, not on reaching the turn limit.

M1 is closed. M2 is in progress. M3 and M4 remain open. Mapping runtime access is the first M2 group; ABI source integration follows it. These groups preserve the functional roadmap in the design verdict. Compiler speed belongs to M4 under the later milestone decision documented in [M4 speed](M4-SPEED.md).

## M2 ERC20 mappings events ABI and packing

Nine planned turns, with turn ten reserved for repairs and reruns.

| Turn | Group | Evidence required to discharge it |
| --- | --- | --- |
| 1 | Mapping runtime access | Checked scalar and nested keys, reads and writes, packed neighbors, constructor initialization, rollback, layout metadata, and model agreement with geth run and t8n. Implemented in [mapping runtime](M2-MAPPING-RUNTIME.md). |
| 2 | Function ABI source integration | Typed parameters and dynamic string calldata reach the dispatcher, model and emitter. Canonical decoding and refusal boundaries agree with independent encodings. Implemented in [source function calldata](M2-FUNCTION-ABI.md). |
| 3 | Return and error ABI source integration | Typed results, dynamic return data and custom error payloads reach source programs and both execution handlers. Golden encodings and malformed input checks pass. Implemented in [source results and errors](M2-RETURN-ABI.md). |
| 4 | Source events | Event declarations, indexed fields and LOG emission share a schema with ABI printing. Model logs and EVM topics and data agree with independent event goldens. Implemented in [source events](M2-SOURCE-EVENTS.md), with constructor emission explicitly refused. |
| 5 | Storage and refinement obligations | Packed field bounds, Word refinement obligations and the storage representation have explicit checked evidence. Mapping fields never lower to closures. |
| 6 | Complete ERC20 contract | Supply, balances, allowances, approval and transfer behavior compose with metadata and events. Success, failure, self-transfer and allowance boundaries have independent expected outcomes. |
| 7 | ABI goldens and negative mutants | The complete ERC20 ABI equals the provenance-pinned golden under jq normalization. Required negative Lean mutants are rejected, and proof erasure controls remain effective. |
| 8 | Coverage and audit reconciliation | Artifact boundaries, budgets, source provenance, corpus coverage and documentation are reviewed against the completed implementation. Unsupported features retain explicit refusals. |
| 9 | M2 closure | The cumulative M2 battery and M2-ABI acceptance gate pass on the final source hashes. Archive evidence and stage the closure record. |
| 10 | Repair reserve | Resolve findings or failed gates from the preceding groups without dropping requirements. |

## M3 vault external calls and epoch discipline

Seven planned turns, with turns eight through ten reserved for repairs and reruns. Begin after M2 closure.

| Turn | Group | Evidence required to discharge it |
| --- | --- | --- |
| 1 | External call semantics | Define call inputs, results, rollback and the adversarial scripted callee in the world model and checked IR. |
| 2 | Epoch indexed invariants | A call advances the proof epoch. A pre-call invariant used afterward is rejected; refreshed evidence is accepted. |
| 3 | EVM call lowering | CALL and return data handling agree with the model on success, failure and nested execution. |
| 4 | Transient storage mutex | TLOAD and TSTORE implement the mutex with explicit Cancun support and transaction lifecycle checks. |
| 5 | Vault and access control | Deposit, withdrawal and authorization compose with invariants, calls and the mutex. Failure restores balances and storage. |
| 6 | Adversarial reentry corpus | A re-entering callee exercises stale proofs, failed calls and mutex behavior against independent expected outcomes. |
| 7 | M3 closure | M3-REENTRY rejects the stale-invariant withdrawal and accepts the fixed corpus row. Cumulative checks and audits pass on final hashes. |
| 8 to 10 | Repair reserve | Resolve review findings and failed validation without weakening epoch or execution checks. |

## M4 deployment profiles precompiles and speed

Eight planned turns, with turns nine and ten reserved for repairs and reruns. Begin after M3 closure.

| Turn | Group | Evidence required to discharge it |
| --- | --- | --- |
| 1 | Chain profiles | Explicit local anvil, Adiri and Ethereum mainnet profiles contain chain IDs, fork capabilities and configurable RPC endpoints. |
| 2 | Deployment preparation and refusal | Build deployment transactions and reject a mismatched RPC chain ID or unsupported emitted opcode before broadcast. |
| 3 | Local deployment execution | Deploy to anvil, inspect the receipt, and compare the deployed code hash with the emitted runtime hash. |
| 4 | Precompile integration | Checked call interfaces, model behavior and EVM results agree for supported precompiles, including failure cases. |
| 5 | Target deployment evidence | Exercise each selected profile's RPC checks and receipt verification. Keep target evidence separate; obtain any required broadcast authorization only after the transaction is reviewable. |
| 6 | Fork and coverage reconciliation | Opcode drift, unsupported features and target compatibility have explicit gates and current coverage records. |
| 7 | Compiler speed | Frozen equivalent workloads, pinned toolchains and matched cache conditions satisfy the Assay/Bend compilation ratio at or below 1.0. Preserve the existing binding speed gate. |
| 8 | M4 closure | M4-DEPLOY, speed, cumulative regressions and release artifact audits pass on final hashes. Document target evidence and limits. |
| 9 to 10 | Repair reserve | Resolve deployment, compatibility, speed or review failures without removing acceptance criteria. |

## Closure rules

Each group carries existing commands, deadlines and required success markers forward. Record failures as well as successful reruns. Stage reviewed changes at the end of each implementation turn. A scoped group can finish while the full milestone battery remains pending.

A failing required gate or unavailable external deployment evidence leaves the milestone open. Identify such dependencies before the final closure turn and use the reserved turns for concrete repairs. The ten-turn grouping is a work allocation, not evidence that the roadmap is complete.

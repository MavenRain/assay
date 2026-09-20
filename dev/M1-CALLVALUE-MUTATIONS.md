# Call-value mutation witnesses

Each mutant must compile, fail at the named witness, and pass the same
probe after the original source is restored. Captures and source hashes
are retained in the validation archive.

| Mutant | Change | Required witness |
| --- | --- | --- |
| SURFACE | Bind zero instead of reading call value | `PAYABLE-MODEL cv-observe` |
| EMITTER | Emit `CALLER` for the call-value snapshot | `PAYABLE-EVM cv-observe` |
| MODEL | Read caller identity instead of call value | `PAYABLE-MODEL cv-observe` |
| SCHEMA | Accept a Word 160 continuation in the call-value constructor | `CALLVALUE-REFUSAL wrong-width` |

The execution probes reuse the payable harness, hence its `PAYABLE-`
witness prefix. Their expected value is 19, distinct from both caller
identity and calldata. The schema witness uses an unused malformed
constructor so kernel checking succeeds and the family check is tested.

The caller, source-model, custom-error and proof-guard mutations retain
their existing counts and witnesses after their anchors are updated for
the shared context representation and model input record.

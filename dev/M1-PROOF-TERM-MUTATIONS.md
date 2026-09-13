# Supplied proof term mutations

`dev/proof-term-test.py mutants` builds each compiler mutation in a
temporary copy, runs its named refusal witness and then restores the
source and requires the witness to pass. Every mutation must build with
zero errors and warnings. A killed mutation exits 1 with the full
`ERROR-REFUSAL WITNESS` label, because the invalid source was accepted.
Build failures do not count as kills.

| Mutation | Compiler change | Witness |
| --- | --- | --- |
| BINDING | Discard a proof binding before checking its value | `unused-binding`, an unused false ordering claim |
| ANNOTATION | Ignore a proof expression's explicit claim | `annotation`, a false annotation inside a true arithmetic bound |
| SCOPE | Resolve the oldest binding of a proof name | `shadow`, a Word shadows an earlier proof |
| NESTING | Widen proof nesting from 128 to 8192 | `nesting`, 129 proof parentheses |

The previous guard suite retains all six mutations and their witnesses.
Its CLAIM anchor now includes the `Prove` branch, because the new proof
lowering also resolves claims. The guard mutation still replaces the
declared claim with the condition and requires the original mismatch
witness and restored control. No case, deadline or assertion is removed.

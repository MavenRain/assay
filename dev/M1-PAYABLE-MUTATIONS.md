# Payable mutation witnesses

`dev/payable-test.py mutants` builds an isolated copy for each mutation
and its restored control. A mutant must fail at its named witness; the
restored control must build with zero errors and warnings and pass the
same probe. The PAYABLE gate requires all four pairs.

| Mutation | Deliberate defect | Required witness |
| --- | --- | --- |
| ABI | Print a payable entry as nonpayable | `PAYABLE-ABI` |
| GUARD | Bypass the value guard at an unmarked entry in a mixed contract | `PAYABLE-EVM surface-deny-write` |
| FALLBACK | Bypass the value guard on an explicit reverting fallback | `PAYABLE-EVM surface-fallback` |
| MODEL | Let the source model execute an unmarked entry with value | `PAYABLE-MODEL surface-deny-write` |

The shared protocol checker also requires updated anchors in the existing
M1-EMISSION, PROOF-GUARDS and EVM-CONTEXT batteries. Their original witness
markers and mutation counts are preserved. The Tx-family mutations now
remove `Tx` from the families that the M1 checker compares. The proof
definition mutation changes one shared comparison instead of two copies.
The ABI mutation still inverts inferred read-only classification.

The [validation archive](validation/2026-09-19-m1-payable/) retains failed
anchor attempts, successful rechecks and the new mutation/control captures.

# M1 proof placeholder mutations

`python3 -P dev/proof-hole-test.py mutants` applies each mutation to
an isolated source copy and builds it without warnings. Each named
witness must exit 1 with its expected marker. The source is then
restored, rebuilt and required to pass the same witness.

| Mutation | Change | Witness | Required failure marker |
| --- | --- | --- | --- |
| EVIDENCE | Discard the evidence table during placeholder lookup | `helper-add` | `M1-TOOL helper-add` |
| PAIR | Drop both expected component claims when checking a pair | `pair` | `M1-TOOL pair` |
| LOCAL | Omit a proof-local binding from the evidence available in its body | `local-add` | `M1-TOOL local-add` |
| PARAMETER | Discard parameter evidence when checking a generic helper body | `helper-body-add` | `M1-TOOL helper-body-add` |

The captured `MUTANTS.json` records the mutation and restored source
hashes, witness names, markers and exit codes. Build failures do not
count as killed mutations. The separate refusal suite also requires
false, unused and out-of-scope placeholders to fail through all three
public commands before output creation.

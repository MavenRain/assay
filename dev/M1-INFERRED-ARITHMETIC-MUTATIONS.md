# M1 inferred arithmetic mutations

The focused suite compiles each changed compiler in a temporary copy,
runs its witness, restores the original source and repeats the same
witness. A compiler build failure is not a mutation kill. Each mutant
must exit 1 with its expected diagnostic; each restored control must
exit 0.

| Mutation | Change | Killing witness |
| --- | --- | --- |
| EVIDENCE | Ignore collected arithmetic evidence | anonymous-add |
| SUB-ORDER | Reverse subtraction's required bound | bound-sub |
| BUNDLE | Drop the second component's evidence | bundle |
| SUPPLIED | Ignore a supplied proof and infer it | explicit-invalid |

The first three witnesses require successful emission and execution.
Their mutants fail emission at the `M1-TOOL` assertion. The fourth
witness supplies `()` for a symbolic bound despite an earlier guard;
its mutant accepts a program that must be rejected and triggers
`ERROR-REFUSAL ia-explicit-invalid`.

`MUTANTS.json` records each changed source hash, witness and exit code.
The validation archive also retains mutant and control captures.

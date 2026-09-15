# M1 compound invariant mutations

`python3 -P dev/compound-invariant-test.py mutants` builds each mutant
in a temporary copy. Its named witness must fail with the expected
marker. Restoring the original compiler must make the same witness
pass. No mutation changes the carried kernel or raises a gate limit.

| Mutation | Witness | What it detects |
| --- | --- | --- |
| LEFT | constructor-left | Dropping a false left component |
| RIGHT | constructor-right | Dropping a false right component |
| RIGHT-FIELDS | right-write | Ignoring fields in the right branch |
| COMPONENT-EVIDENCE | component-evidence | Omitting proof composition |

LEFT and RIGHT resolve a compound invariant to just its opposite
component. A constructor with one false component then passes when it
must be rejected. RIGHT-FIELDS drops right-branch fields from tracking;
writing those fields can then skip the required final obligation.
COMPONENT-EVIDENCE returns only the left proof when a pair is required,
so a valid update with two separate guard proofs stops compiling.

The harness requires successful builds with zero errors and warnings,
the expected failing witness for each mutant, and passing restored
controls. Build failures and unrelated diagnostics do not count as
detected mutations.

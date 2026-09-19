# Trace call value validation

This record validates the trace call value slice on base `913c8c8` in
`/Users/oobi/Documents/gpt1/assay-trace-value`. It contains eleven passing
build and test commands plus a check of gate mode selection. The complete
ladder was not run. DENOMINATORS and M0-RATIO remain pending under the
existing timing pause; this record makes no performance or milestone
exit claim.

`SCOPED.json` lists each command, its exit status, required success
marker, and whether it reused a completed run from this same slice.
Each command has a corresponding log. The build and TRACE-VALUE
capture manifests preserve the original command and status.
The remaining nine commands ran after the final test was written.

TRACE-VALUE passes 36 execution comparisons, two funding faults and 34
input refusals. `TRACE-VALUE-CASES.json.gz` preserves all 72 command
receipts, including full geth traces. `TRACE-VALUE-LIVE.json.gz` records
the independent expected outcomes, source-model-checked execution
results and executor arguments for the 36 comparison cases. The gate
checks the observed CALLVALUE operand, including decimal `0010` and
`0009`, rather than inferring the amount from a nonpayable revert.

The existing TRACE-DRIVER, DIFF-EXECUTOR, DIFF-VALUE and DRIVER gates
pass. PIN-CARRY, R0-COUNT, R0-AUDIT, HOUSE and TRUSTED-LINES also pass.
The compiler build reports zero errors and zero warnings.

`GATE-COMPATIBILITY.json` records evaluation of the ladder's mode
selection, stopping before commands run or log files are created. All
36 previous modes return the same commands, deadlines, markers, stage
name and M1 membership as the base. The new mode appends TRACE-VALUE to
the 65 prior legs and selects the matching stage and M1 membership.
This check is separate from execution of the eleven recorded commands.

`SOURCES.json` pins the changed source and documentation, the existing
regression inputs, and the compiled executable. The base commit fixes
unchanged repository content. `ARTIFACTS.json` hashes the archive files
other than itself. `FINAL.json` records the scoped verdict and dates.

To rerun the focused build and gate from the repository root:

```sh
zsh -f dev/dunecho.sh build
python3 -P dev/trace-value-test.py
```

The current full ladder is `zsh -f dev/gates.sh`, or equivalently
`python3 -P dev/stage-a-gates.py --m1-trace-value`. Its two timing legs
retain their previous status.

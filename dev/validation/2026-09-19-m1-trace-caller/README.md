# Trace caller validation

This archive validates the trace caller slice on base `629bf02` in
`/Users/oobi/Documents/gpt1/assay-m1-trace-caller`. Twelve build and gate
commands pass, together with a check of gate mode selection. The full
ladder was not run. DENOMINATORS and M0-RATIO remain under the existing
timing pause, with no performance or milestone-exit claim.

`SCOPED.json` records each command, exit status and required success
marker. Each command has a corresponding log. BUILD and TRACE-CALLER
reuse completed runs from this same slice; their capture manifests
preserve the original command and status. The remaining ten gates ran
after the driver, test and ladder changes were complete.

TRACE-CALLER passes 45 execution comparisons, two funding faults and
31 refusals. `TRACE-CALLER-CASES.json.gz` retains all 123 command
receipts, including full geth traces and source model outputs.
`TRACE-CALLER-LIVE.json.gz` preserves independent expected outcomes,
execution results and literal executor arguments. The gate checks
actual CALLER operands, including decimal leading zeroes, the uint160
maximum and the unchanged default sender. Access denial restores
earlier writes. Funding checks fail for an unfunded chosen caller even
when the legacy default sender is funded.

TRACE-VALUE, TRACE-DRIVER, DIFF-EXECUTOR, DIFF-VALUE and DRIVER pass.
PIN-CARRY, R0-COUNT, R0-AUDIT, HOUSE and TRUSTED-LINES also pass. The
compiler build reports zero errors and warnings.

`GATE-COMPATIBILITY.json` records evaluation of mode selection before
any commands execute or logs are created. All 37 previous modes
preserve their commands, deadlines, markers, stage and M1 membership.
The new mode appends TRACE-CALLER to the 66 prior legs and selects
the matching stage and M1 membership. This check is separate from
execution of the twelve recorded commands.

`SOURCES.json` pins changed source and documentation, regression
inputs and the compiled executable. The base commit fixes unchanged
repository content. `ARTIFACTS.json` hashes archive files other than
itself. `FINAL.json` records the scoped verdict and dates.

To rerun the focused build and gate from the repository root:

```sh
zsh -f dev/dunecho.sh build
python3 -P dev/trace-caller-test.py
```

The complete ladder is `zsh -f dev/gates.sh`, equivalently
`python3 -P dev/stage-a-gates.py --m1-trace-caller`.

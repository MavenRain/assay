# M2 coverage and audit reconciliation validation

Base commit: `a5d5cfe8c9f630e678cce83f8194c19aada7982e`.
The working copy was `/Users/oobi/Documents/assay`. All paths were staged
and nothing was committed. The installed Bend pin was reused. No toolchain
installation was required.

`SOURCES.sha256` pins the staged blob of each of the 29 staged
paths outside this directory. From the repository root, verify it with:

```sh
shasum -a 256 -c dev/validation/2026-10-05-m2-reconcile/SOURCES.sha256
```

The focused acceptance commands are:

```sh
python3 -P dev/m2-reconcile-test.py
python3 -P dev/refined-word-test.py
```

The first command is static. The second command needs `make`.

`attempts.json` lists 24 leg runs in two runs. Run 1 ran each leg
on the tree with the code and gate changes. Run 2 ran the two new legs
again with a timer, then ran the pins, the static check, the light legs
and MILESTONE-SPEED after the documents changed. None of the 24
runs failed. The source files did not change after run 1, so run 2 did
not build again and did not run REFINED-WORD a third time.
`run1-status.log` and `run2-status.log` hold one status line for each
run, and the lines of the pin refresh and the whitespace check. Run 1 did
not record elapsed time.

Each capture holds stdout and stderr together, so the stderr counts in
`attempts.json` are zero. `error_lines` counts lines that contain `FAIL`
or `error:`. An attempt has an artifact only when it made the final
capture of its leg. Each capture is a file in this directory.

`summary.json` holds the counts of the two new markers.
`schedule.json` records the inspection of all 108 preceding gate tuples
and the two added legs. That inspection does not claim execution of the
110-leg schedule. The full battery belongs to group 9.

`dev/M2-RECONCILE.md` holds the audit table and its limits. Three rows
are OPEN: four deferred constructs have no refusal test (deviation
M2-G8-D2), no corpus row is an M2 source contract (deviation M2-G8-D3),
and five compiler sources have no line budget. Each needs a USER ruling.
No gate deadline, expected marker, axiom allowlist or golden was relaxed.

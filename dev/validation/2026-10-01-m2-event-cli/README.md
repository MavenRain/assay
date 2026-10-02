# M2 event CLI validation

Base: `10f1f9651ac245698756a122018cd7a54fd64c8a`.

`make-test.stdout.log` and `make-test.stderr.log` contain the complete
successful `make test` run. Its capture manifest records exit code zero.
The standalone event and mapping process checks also passed. `REPORT.json`
contains all 56 event input vectors and their cast-backed expected logs,
the 36 refusal count, the two pin controls and the compared source hashes.
`audits.log` records passing house, carry and trusted-line checks.

`SOURCE-HASHES.sha256` freezes the changed inputs and direct ABI dependencies.
`FILES.sha256` pins every other file in this directory. The full milestone
gate battery and M4 speed checks were not run. Event source lowering remains
pending.

The review fixes changed documentation only. `review-event-cli.log` and
`review-milestone-speed.log` record the reruns after the fixes, and
`review-gates.log` records the cheap gates. `REPORT.json` lists the
changes under `review_changes`.

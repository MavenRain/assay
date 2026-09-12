# M1 core emission evidence

Base: `850aa68fa5ac5f71254948d2ece24157c4c17267`.
Validated checkout: `/Users/oobi/Documents/gpt1/assay-m1-emission`.

`GATES.log` records `zsh -f dev/gates.sh`: 36 PASS legs and one AXIOMS
timeout. The Lean build passed, but the report command exceeded its
120-second deadline. `AXIOMS-RETRY.log` records a successful run of the
unchanged `python3 -P dev/proofs-test.py` with the same deadlines.
`PROOF-REPORT.log` holds the 42 reports from that retry. No compiler source
or gate changed between the full run and retry.

`CHECKS.json` records the combined coverage of all 37 checks. The original
full-run failure stamp remains in `GATES.log`; it is not rewritten as a
green run. The M0 exit stamp remains subject to user ratification.

`M1-EMISSION.log` records 30 counter/reference comparisons on both geth
paths, two creation probes, 216 covered runtime instructions, eight
additional source programs, eleven refusals, two export checks and eight
compiler mutations with restored controls. `evidence/` holds their raw
captures, generated listing inputs and five-file hashes. `cli-diff.json`
within that directory records the public driver's increment smoke check.
That capture was taken by hand outside the gate legs. Its command reads a
prestate file in a temporary directory that this archive does not hold, so
no leg replays it and a reader cannot reproduce it from the archive alone.

`SOURCES.json` hashes the compiler and driver sources, the frozen corpus,
the proof tree, the reference fixtures, the development and gate scripts,
the prose that interprets this evidence and the dated timing reports.
It excludes this evidence directory to avoid a self-referential manifest.
The dated timing reports remain in `dev/measurements/`. They measure the
frozen M0 corpus, not the M1 performance threshold.

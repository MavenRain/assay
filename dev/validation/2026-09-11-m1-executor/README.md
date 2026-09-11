# M1 executor validation

The complete battery passed 33 of 35 legs in the workspace copy on
`10ba107`.  DENOMINATORS and M0-RATIO remain failed.  `GATES.log`
records the run.  The per-leg logs retain
the full outputs, and `mutations/` retains individual compiler mutation
and restored-control transcripts plus the proof build and axiom report.

`DIFF-EVIDENCE.json` retains 20 live executor captures, 26 public driver
receipts and 24 rejection witnesses.  Two replacement timing attempts
exceeded the one-minute bound.  Their rejection logs are retained as
`MEASUREMENT-ATTEMPT-1.log` and `MEASUREMENT-ATTEMPT-2.log`.  The old
measurement and source hash manifest were not changed.

`SOURCES.json` pins 145 current source and input files,
including every changed file outside this evidence directory.  The
evidence files and this README are excluded to avoid self-reference.
The unchanged proof dependencies were copied from the local Stage F
workspace.  No dependency was installed or fetched.

# Timing window diagnosis

The timing measurement is paused at the user's request on 2026-09-12.
Three attempts exceeded the existing 60-second window. No successful
replacement measurement was produced, and the preceding nullary report
remains preserved. It does not validate the current compiler and timing
script. The limit and five-round method are unchanged.

## Diagnostic evidence

The window covers five interleaved rounds of assay compilation, proof
fixtures, OCaml native compilation, OCaml bytecode compilation and fixed
process cost. It is a limit on the complete measurement window, including
the reference compilers. It is not a one-minute limit on assay alone.

A separate diagnostic pass used the same corpus and compiler commands,
with child-process CPU accounting. It did not run the timing gate or
update its frozen report.

| Workload | Wall seconds | Child CPU seconds |
| --- | ---: | ---: |
| Assay, all 11 programs | 0.808 | 0.128 |
| OCaml native reference | 9.084 | 3.053 |
| OCaml bytecode reference | 3.046 | 0.574 |

At those sampled durations, five rounds of the reference compilers alone
would consume 60.65 seconds. Most of their elapsed time was outside CPU
execution. Scheduling, process startup and I/O can contribute to that
gap; this sample does not isolate their individual shares.

An alternating comparison then ran all 11 programs through the previous
and current assay binaries, checking every frozen output hash. The prior
binary's SHA-256 matched the executable identity in the preceding frozen
report. All 22 compilations produced the expected files.

| Compiler | Wall seconds | Child CPU seconds |
| --- | ---: | ---: |
| Previous frozen binary | 0.428 | 0.146 |
| Current binary | 0.466 | 0.149 |

This small diagnostic shows comparable compiler CPU work, with no evidence
of a substantial assay regression in the measured corpus. It is not a
performance gate result or an M1 performance claim.

The resource figures in this paragraph are an operator observation from the
time of the run. No snapshot file is archived for them. The observation was
100% aggregate CPU use, load near 95, and concurrent desktop activity and
Rust builds. The sorted process sample included iTerm at 144%, MTGA at 99%,
WindowServer at 77%, and rust-analyzer at 54%. These process percentages use
one core as 100%. macOS separately reported 40% memory availability. Low
unused pages alone did not establish memory exhaustion. No unrelated
application or build was stopped.

## Reporting fix

Previously, `dev/ratio.py` raised `RATIO-WINDOW` before constructing or
writing the report, losing every completed sample. That prevented an
exact workload attribution for the three failed attempts.

The failure path now saves a uniquely named `*.rejected-*.json` beside
the requested output. It retains all samples, commands, source identities
and the rejection reason. Its diagnostic prints the elapsed window and
total milliseconds per workload. It still fails the same 60-second bound
and does not create the requested successful-report path. Rejected reports
continue to fail ordinary report validation.

The existing corpus mutation leg now checks exact-boundary and over-bound
failures, retention of both reports, and an accepted control. These tests
use synthetic timing data and run no compiler timing window. The full
timing gate remains paused after this fix.

The validation archive's `diagnostics/` directory retains both diagnostic
result sets, the scripts used to collect them, and the original timing
failure outputs. Their command paths may refer to temporary files that
have since been removed.

# Trace response error detection validation

This slice starts at `bacd4ba`. `Trace.has_error` removes its Series
round trips while preserving response scanning and whitespace compaction.

The native test capture records the complete passing `make test` run,
including all eight conversion checks. The error report records 519
predecessor comparisons, 519 independent goldens, five compiled mutants,
and a restored control. Compatibility preserves 56 historical schedules,
requires the new 95-leg schedule, and restores the historical CLI bundle
byte for byte.

The trace driver capture records 20 live process checks. The house and
carry captures check the updated catch-all line inventory and native source
hashes. The first house capture retains the audit failure before refreshing
the five shifted CLI line records. The first error capture retains the
failed golden for a malformed response with a doubled colon, which the
predecessor recognizes as an error.

The paired measurement, ratio controls and binding ratio capture record
the current compiler performance result: Assay 920.754958 ms, Bend 2
578.530375 ms, ratio 1.591541253 in a 7.874-second measurement window.
The binding speed check refuses this result with the unchanged 1.0 limit.
This measurement does not isolate the conversion change's speed effect.
The full milestone battery and M2 source lowering remain open.

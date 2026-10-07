# Trace error string-fold validation

This slice builds on the staged direct-conversion work at `bacd4ba`.
`Trace.has_error` removes its intermediate character lists with a native
string fold followed by reversal, preserving whitespace and scanner behavior.
The trusted kernel is unchanged.

The complete native capture records a passing `make test`: kernel suite,
24 commands across 18 adapters, and all eight conversion checks. The error
report records 519 predecessor comparisons, independent goldens, six compiled
mutants and the restored control. Compatibility preserves 56 historical
schedules, 95 mandatory legs and the restored CLI bundle. House, native carry
and trusted source budgets pass.

The initial native capture stopped at a lexer mutant compiler failure.
The final complete rerun passes. The first fold capture and build log retain
the parenthesis error fixed before that rerun. Compiler diagnostics now
include exit codes.

The frozen five-round, six-case measurement has matched median times of
3177.324957 ms for Assay and 2193.187959 ms for Bend 2, a ratio of 1.448724421
in a 26.843-second window. The active baseline matches this archive exactly.
The binding speed check fails at the unchanged 1.0 limit. Benchmark controls
pass all 37 refusals and six compiled mutants. This measurement does not
isolate the fold's speed effect. The full milestone battery and M2 source
lowering remain open.

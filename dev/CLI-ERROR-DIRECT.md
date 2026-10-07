# Direct trace response error detection

The 2026-10-02 follow-up folds directly over each string segment with
`NativeString.fold` and reverses the retained characters with `String.reverse`.
It removes the intermediate character lists used by the 2026-10-01 version.
Whitespace recognition and the response scanner retain their behavior.

Starting at `bacd4ba`, `Trace.has_error` converts each string segment
directly to a character list and back when compacting JSON whitespace.
The change removes intermediate Series values. The scanner still removes
only space, tab, carriage return and line feed. Its handling of error keys,
null values, empty strings, repeated keys and malformed responses is preserved.

`python3 -P dev/cli-error-direct-test.py` compiles both implementations and
compares 519 results with explicit independent goldens. Cases cover ordinary
JSON responses, null and empty error values, mixed key case, nested and
repeated keys, truncated responses, ASCII and Latin-1 separators, Unicode
values, and seeded combinations of JSON whitespace.

Six compiled mutants retain each of the four whitespace characters,
remove the colon, or reverse the compacted output. Each must compile,
exit successfully, and produce its named wrong result. The restored
control repeats every case.

The declaration pin extends the CLI manifest to thirteen entries. The
check refuses missing, duplicate and modified bodies and verifies that
a scanner change remains visible in the historical CLI bundle.
Compatibility retains all 56 historical schedules and compares the restored
CLI bundle byte for byte. The default schedule adds a mandatory
`CLI-ERROR-DIRECT` leg, for 95 legs, and `make test` includes the new check.

The 2026-10-01 validation evidence is in
`dev/validation/2026-10-01-cli-error-direct/`. Its five-round,
six-case measurement gives matched median times of 920.754958 ms for
Assay and 578.530375 ms for Bend 2, a ratio of 1.591541253. The compiler
speed limit remains 1.0 and still fails. The measurement does not isolate
this change's speed effect. The full milestone battery and M2 source
lowering remain open.

## String-fold validation, 2026-10-02

The complete `make test` run passes, including all 519 predecessor
comparisons, independent goldens, six compiled mutants and the restored
control. Compatibility preserves the 56 historical schedules and the
95 mandatory legs. House and native carry pass.

The current five-round, six-case paired measurement records matched
median times of 3177.324957 ms for Assay and 2193.187959 ms for Bend 2,
a ratio of 1.448724421 in a 26.843-second window. The 1.0 speed limit
still fails. All 37 benchmark refusals and six compiled mutations pass.
This measurement does not isolate the fold's speed effect. The full
milestone battery and M2 source lowering remain open.

Current evidence is in `dev/validation/2026-10-02-cli-error-fold/`.

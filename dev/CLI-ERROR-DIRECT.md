# Direct trace response error detection

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

Five compiled mutants retain each of the four whitespace characters or
remove the colon. Each must compile, exit successfully, and produce its
named wrong result. Each witness is a fixture with a true golden. The
restored control repeats every case.

The declaration pin extends the CLI manifest to thirteen entries. The
check refuses missing, duplicate and modified bodies and verifies that
a scanner change remains visible in the historical CLI bundle.
Compatibility retains all 56 historical schedules and compares the restored
CLI bundle byte for byte. The default schedule adds a mandatory
`CLI-ERROR-DIRECT` leg, for 95 legs, and `make test` includes the new check.

Validation evidence is in
`dev/validation/2026-10-01-cli-error-direct/`. The fresh five-round,
six-case measurement gives matched median times of 920.754958 ms for
Assay and 578.530375 ms for Bend 2, a ratio of 1.591541253. The compiler
speed limit remains 1.0 and still fails. The measurement does not isolate
this change's speed effect. The full milestone battery and M2 source
lowering remain open.

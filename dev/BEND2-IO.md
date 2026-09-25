# Byte-string file IO

This follow-up starts at `f29b428`. File reads and writes now transfer a
Latin-1 byte string through the existing operating-system boundary. The
Bend driver no longer allocates a list element for every byte or converts
the list back to text. Reads retain the 65,536-byte chunk limit. Bend still
handles chunk order, file closure and explicit error results.

The native IO suite adds empty files, 65,535-byte files, exact 65,536-byte
files and 131,072-byte files. Each copy checks exact bytes and replacement
of existing output. The existing cases cover every byte value, a partial
final chunk, Unicode paths and arguments, IO errors and delayed pipe readers.
The gate requires all 12 cases.

Mutation-test copies share the source checkout's pinned local Bend compiler
through a symlink. The builder still verifies the compiler pin and build
receipts; an explicit `BEND` setting retains precedence. This repairs the
missing-compiler failures observed when using the default local installation.

The live benchmark reports were remeasured and sealed for this source. The
matched Assay/Bend ratio is 1.445234, and the normalized corpus ratio is
1.198462. Both exceed the unchanged 1.0 bound. Machine contention varied
between measurements, so these runs do not establish a percentage speedup.
The binding performance requirement remains open.

See [the validation record](validation/2026-09-24-bend2-io/README.md) for
completed checks, the interrupted broad run and remaining limitations.

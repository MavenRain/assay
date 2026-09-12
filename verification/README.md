# Assay source proofs

This dependency-free Lean package defines checked uint256 arithmetic and
finite source transactions. Import `AssayProofs` from a downstream Lake
project with `require «assay-proofs» from "../assay/verification"`.

Build with `leancho -C verification`. `lake env lean Axioms.lean` in this
directory reports the public theorem assumptions. The `sourceModel`
executable is a test adapter, outside the importable library.

The carried `../proofs/` package remains a separate, byte-identical seed.
The source semantics, correspondence tests and limits are documented in
`../dev/M1-PROOFS.md`.

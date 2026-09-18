# Inferred runtime Word validation

Base: `cf3b6cf0474ce66f684bd99c0b5ac87eb3982145`.
All 61 functional legs pass in the 63-leg battery. DENOMINATORS and
M0-RATIO fail against the preserved timing inputs under the existing
pause. The complete battery exits 1 and retains its FAIL stamp in
GATES.log. No performance or milestone exit claim is made.
M0-RATIO.log.gz preserves its complete output, including trailing
blank lines, without adding whitespace errors to the staged text.

INFERRED-WORDS.log records 21 artifact pairs, 40 runtime cases,
40 signed Cancun comparisons, 19 refused source forms, two body-limit
cases and four detected mutations with passing restored controls.
REFUSALS.json entry 4, `empty-annotation`, supplies an empty annotation
(`let result : := word 1`); the compiler refuses it with the marker
`SURFACE_SYNTAX: expected Word`. An omitted annotation is accepted by
this slice, and every recorded pair exercises that form.
PAIRS.json, LIVE.json, REFUSALS.json, BOUNDARIES.json and MUTANTS.json
retain the cases and source hashes. inferred-word-witnesses.json.gz
maps every focused test artifact path to its full text, including
sources, all five emitted artifacts, process arguments, exit codes,
stdout, stderr and signed transition evidence. Both EVM execution
paths use geth.

All 62 prior gate declarations retain identical ASTs, commands,
deadlines and success markers in GATE-COMPATIBILITY.json. FINAL.json
records the compiler identity and protected paths. SOURCES.json hashes
993 nonignored regular source files, including documentation,
outside dev/validation/ and vendor/. ARTIFACTS.json hashes all other
files in this archive, including this README. CAPTURE.json retains the
capture metadata. CACHE.json records the 35 matched proof inputs and
two verified dependency revisions used for offline cache reuse.

Scratch checkout:
`/Users/oobi/Documents/gpt1/assay-m1-inferred-words`

Command:
```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH \
  -u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

The command ran through kanon-wait and kanon-exec with a 4000-byte
reply budget. Tool versions are pinned in dev/TOOLCHAIN.md.

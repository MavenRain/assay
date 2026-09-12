# M1 source model validation

The complete battery passed 38 of 38 legs in
`/Users/oobi/Documents/gpt1/assay-m1-run`, based on assay commit
`ef22665bcb95751ad70f551dad21bff3dfe4979e`. `GATES.log` holds the final
result and every leg has a separate log. The command was:

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

The normal shell PATH supplied the installed tools, including elan, lake,
leancho, rg, cast and evm. The proof dependency cache was copied offline
from the previous M1 emission scratch checkout. The AXIOMS gate verified
both dependency revisions, all 28 carried sources and 42 axiom reports.
It ran the proof build and did not take the skip path.

`ATTEMPT-PATH.log` retains an earlier interrupted invocation. Its explicitly
reduced PATH omitted rg and the Lean tools, causing tool failures. It was
cancelled and replaced with the command above. No compiler or gate source
changed between those invocations, and no gate threshold was relaxed.

`evidence/` contains the complete source model, emitted-bytecode and
reference captures, driver refusals, model mutation builds, failing
witnesses and restored controls. The live comparison covers 30 counter
rows, ten additional effect programs and eleven frozen corpus programs.
The driver checks 28 invalid inputs, six accepted invocations and six
checked source refusals. Eight model mutations are killed and restored.
Both EVM entry points use geth 1.14.12, while the model shares checking
and specialization with the emitter. These are explicit trust limits.

`SOURCES.json` pins the validated source inputs, measurement manifest and
current documentation. It is not a hash of historical validation archives.
`ARTIFACTS.json` pins the captured files and this README. The new dated
measurement is `../../measurements/2026-09-12-m1-run.json`, collected at
21:26 PDT on September 11. Its five rounds took 15.133 seconds. The prior
reports are preserved unchanged. This measures the frozen M0 corpus with
the final compiler and does not establish the M1 performance bound.

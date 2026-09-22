# M2 reference validation, 2026-09-22

Base commit: `8f61dd5a30b24628317caf5a27544522c221a25e`.
All 76 default legs passed in one full run, ending with
`STAGE-M2-REFERENCE OK`.
Validation ran in `/Users/oobi/Documents/gpt1/assay-m2-reference`, an
isolated local clone. The original checkout receives the validated files
only after the full battery finishes.

`SUMMARY.json` records the verdict, tool versions and scope. `SOURCES.json`
pins the validation inputs, including every existing denominator entry and
the new reference fixtures. The compiler sources are unchanged from the base.

The captured build and default battery use:

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH \
  -u OCAMLFIND_CONF zsh -f dev/dune.sh build
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH \
  -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

| Evidence | Content |
| --- | --- |
| `build.json`, `.log`, `.stderr` | Finite build capture |
| `focused-gate.json`, `.log`, `.stderr` | Initial ERC20-REFERENCE run |
| `default-gates.json`, `.log`, `.stderr` | Full 76-leg battery |
| `GATE-LOGS.tar.gz` | All individual leg logs from the full battery |
| `ERC20-CAPTURES.tar.gz` | Listings, hash oracles, executions, creations, mutants and controls |
| `GATE-COMPATIBILITY.json` | All 45 historical plans compared with the base |
| `DENOMINATOR-DELTA.json` | Existing pins retained, two gate pins updated and ten entries added |
| `gate-compatibility.py` | Reproducible comparison of commands, deadlines, markers and classification |
| `FILES.sha256` | Hashes of the archive files, excluding this hash file itself |

The focused marker is `cases=85 creates=4 mutants=11 covered=431`.
The full gate appends that same check after the 75 M1 closure legs.
The Bend 2 legs validate the frozen paired comparison and its refusals;
this slice introduces no new compilation timing measurement.

Runtime cases use geth `run` and signed Cancun `t8n`. These share one
implementation. The receipt supplies committed event logs; the two traces
also check log operands. Constructor probes use only `run` and reconstruct
the mint event from its trace. No compiler correspondence, Lean theorem,
packing support or M2 milestone exit is claimed by this reference slice.

# Stage D validation, 2026-09-10

Base commit: `7ff9921b1b91deff84c4b8a5e416febffa60fa97`.
Work root: `/Users/oobi/Documents/gpt1/assay-stage-d`.

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH \
  -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

`GATES.log` records all 21 passing legs and `STAGE-D OK`.
The command ran through `kanon-wait` and `kanon-exec`.
Named leg logs retain their full output.  Mutation and restored-control
logs are archived with their original filenames.  `ORACLES.json` preserves
the Stage D live oracle commands, statuses and both output streams as JSON
strings.  Mutation copies are temporary; their parent transcripts retain
the required failure witnesses and restored-control results.

`SOURCES.json` contains selected current build, harness and fixture hashes.
It is an input inventory, not a complete dependency graph.  Unchanged source
outside that inventory is identified by the base commit and the carry gate.
Historical validation directories are evidence for their own base commits.

- The reference runtime has 20 bytes and 17 instructions.
- The trace executes 13 instructions and skips the four guard bytes.
- Stack snapshots, storage slot zero and the 32-byte return value match 42.
- The 30-byte creation program returns and installs the exact runtime.
- Runtime gas is 22,232.  Creation gas is 4,022.  These are reported geth
  execution measurements, without transaction intrinsic gas.
- All five fork probes match the expected Cancun answer set.
- Eight fixture mutants fail at their named checks.  Three restored gates pass.
- All 32 corrupt-capture cases fail at their named checks.  Two controls pass.
- All 16 inherited Stage A-C gates pass.
- Trusted lines remain kernel=3997, assembler=238/600, listing=54/250,
  keccak=89/250 and total=381/3550.

The installed oracles are cast 0.3.0 and geth evm 1.14.12-stable.
Every execution explicitly supplies `evm/fixtures/cancun.json`.
M0-TRACE is marked `scope=reference`.  The five compiler outputs, emission,
recognizers and proof seed remain Stage E work.  No final M0 exit or ratio
is claimed.

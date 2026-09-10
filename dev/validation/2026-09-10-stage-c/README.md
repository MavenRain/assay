# Stage C validation, 2026-09-10

Base commit: `cfcdbf11eb43cc20d32f24e1d8e0c687cac88e0c`.
Work copy: `/Users/oobi/Documents/gpt1/assay-stage-c`.

Command:

```sh
env -u OPAM_SWITCH_PREFIX -u CAML_LD_LIBRARY_PATH -u OCAMLPATH \
  -u OCAMLFIND_CONF zsh -f dev/gates.sh
```

The command ran through `kanon-wait` and `kanon-exec`.  `GATES.log` records
all 16 passing legs and `STAGE-C OK`.  The named leg logs retain their full
output.  `DISASM-RAW.log` contains the seven inputs and all three raw
disassembler transcripts.  `asm-mutant-*.log` holds each mutant rejection;
`asm-control-*.log` holds the restored controls.  `SOURCES.json` hashes the
build configuration, assembler, listing, test adapter and gate inputs.

Results:

- Kernel and surface suites pass.  The 24 driver cases pass.
- Stage A kills 13 of 13 mutants.  Stage B kills 4 of 4 with its control green.
- STACK-HEIGHT passes 64 assembly cases, 30 height-checked blocks and 370 stack-effect probes.
- All 149 Cancun opcode rows match the frozen metadata.
- DISASM-3WAY matches 272 rows from each of the three tools across seven fixtures.
  All 38 negative inputs fail as specified.  The DIFFICULTY alias applies twice,
  once per oracle, on the all-opcodes fixture.
- Stage C kills 6 of 6 mutants.  Each mutant builds before its gate runs.
- The restored stack and disassembly controls pass.
- TRUSTED-LINES reports kernel 3997, assembler 238/600, listing 54/250 and keccak 89/250.
- The measured new total is 381/3550.  Emitter, ABI and layout remain pending.
- `panicscan --strict asm test/asm_cases.ml` reports zero findings.

The installed oracles are `cast` 0.3.0 and geth `evm` 1.14.12-stable.
Stage C does no EVM execution.  The Cancun prestate and execution gates are
Stage D work.  This evidence makes no M0 exit or performance claim.

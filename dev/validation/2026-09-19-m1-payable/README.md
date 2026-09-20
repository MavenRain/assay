# Payable validation

Base: `f187d414b193254081bfbbbf3dbc239bdaa3ed4f`.

The final result includes 33 passing scoped gates. `FINAL.json` lists
their exact commands, limits, required markers and outcomes.
`GATE-COMPATIBILITY.json` checks all 39 previous modes and 68 legs, with
PAYABLE appended as leg 69. BUILD now invokes public Dune and checks its
exit status. Every other gate declaration is preserved. The repository's
Dune configuration continues to make every enabled warning fatal.

`SCOPED-INITIAL.json` records the broad regression run. Four failed rows
were superseded by `RECHECKS.json`: the emitter line count and stale
mutation anchors in M1-EMISSION, PROOF-GUARDS and EVM-CONTEXT. The final
count is 1800/1800. Between that run and the rechecks, the emitter changed
only by removing a blank line; the three test batteries received matching
anchors for the shared schema checker and explicit ABI mutability.
Every original mutation count and failure witness remains required.
`attempts/` retains the earlier failures and `logs/` the final gate logs.

`PUBLIC-TOOLS.json` records eight subsequent checks after replacing the
local build tooling: BUILD, PIN-CARRY, HOUSE, KECCAK-MUTANTS, ASM-MUTANTS,
PROOF-GUARDS, EVM-CONTEXT and PAYABLE. All pass. `BUILD.json` records the
public build command and tool versions. A successful Dune build may have
an empty `BUILD.log`. No compiler source changed during this tooling
cleanup. The remaining scoped gates retain their earlier evidence.

`PAYABLE-CAPTURES.tar.gz` contains the freshly regenerated
`.gatework/payable` directory under `payable/`, including generated
sources and artifacts, model outcomes, raw geth traces, signed Cancun
captures, expected outcomes and mutation/control records. `WITNESSES.json`
hashes its files. The PAYABLE marker records 216 core cases, 24 signed
comparisons, eight artifact pairs, six surface probes, six public command
or creation outcomes, 18 refusals and four mutations. Signed comparisons
verify balance transfer on success and rollback on revert.

`SOURCES.json` pins the changed source and documentation paths on the base
commit. `SHA256.json` hashes the archive's records. A hash proves
freshness, not correctness. The logs and checks provide the evidence.

Reproduce the 33 selected checks with `python3 -P scoped-run.py` from any
directory. `recheck-run.py` replays the four repaired gate declarations.
`public-tools-run.py` replays the eight subsequent checks. All require
the public tools documented in the root README to be on PATH.

The full 69-leg ladder was not run. DENOMINATORS and M0-RATIO remain
paused under the existing timing diagnosis. This archive does not claim
a timing result, M0 exit ratification or M1 completion.

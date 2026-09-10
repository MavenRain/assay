# assay

Assay is a Kanon language fork for EVM contracts.  It inherits the kernel and
surface at `2c2e6e6`.  M0 Stage A supplies the checker, erasure, axiom disclosure
and carry gates.  Stage B adds Keccak-256 and selector derivation.
EVM emission is pending Stage E.

```sh
zsh -f dev/dunecho.sh build
_build/default/bin/assay.exe check examples/m0-spine.kan
_build/default/bin/assay.exe check --erased examples/m0-spine.kan
_build/default/bin/assay.exe axioms examples/m0-spine.kan
_build/default/bin/assay.exe spec-count
zsh -f dev/gates.sh
```

New assay sources use `.asy`.  The checker also accepts inherited `.kan`
fixtures and rejects every other suffix with exit 64 (R-M0-1).  The source
grammar is unchanged.  `check --print FILE` prints the checked declarations.
A valid file exits 0, a rejected file exits 1, and invalid arguments, an
unaccepted suffix or a missing path exit 64.

`emit FILE -o DIR` checks and erases its input, then exits 2 with
`EVM_BACKEND_UNAVAILABLE`.  It writes no output.  The inherited
`emit FILE -o DIR --export NAME` arity stays accepted as an alias.  The Wasm
backend and its `build` and `run` commands have been removed.

`trace`, `diff`, `run`, `deploy` and `test` are declared at M0 and exit 3
with a named `PENDING` diagnostic, so a declared name is never reported as a
typo.  `trace FILE --calldata HEX` and `diff FIXTURE` arrive in Stage F, and
`diff` runs the second executor `evm t8n --state.fork Cancun` on the same
prestate (R-M0-8, R-M0-9).  `run` arrives in M1.  `deploy` and `test`
print `PENDING (M1)` today and gain behavior at M4 (R-8a).

M4 deployment support targets anvil, Adiri (Telcoin testnet, chain ID
2017) and Ethereum mainnet (chain ID 1), per R-8a (2026-09-10).
R-8a does not authorize broadcasting transactions.  Chain profiles that
switch PUSH0, TLOAD, TSTORE and MCOPY off for an older L2 come from R-4.
RPC configuration, compatibility checks before broadcast and verification
of deployed code against the emitted runtime hash have no ruling yet and
are open questions.

[CARRIED.md](CARRIED.md) defines the preserved source inventory and records
integration changes.  [SPEC.md](SPEC.md) retains the inherited grammar and R0
counts.  Historical Wasm sections are marked as upstream evidence.
[The build log](dev/M0-BUILD-LOG.md) records the current validation.
[The mutation log](dev/MUTATION-LOG.md) records gate rejection checks.

The `assay_keccak` library exposes `Assay_keccak.Keccak.keccak256` and
`selector`.  Both hash the input string as bytes.  They return lowercase
hex without `0x`: 64 digits for a digest and eight for a selector.
Pass a canonical ABI signature to `selector`, such as
`transfer(address,uint256)`.  Signature parsing belongs to the ABI layer.

Stage C adds the assembler and listing.  Stage D adds
the Cancun reference fixture.  Stage E adds EVM emission, recognizers, JSON
outputs and the proof seed.  Stage F measures the frozen corpus.

The Stage B gate battery checks the build, complete inherited kernel suite,
surface suite, driver behavior, pin, carry inventory, R0, house rules,
trusted-line budgets, denominator hash and gate mutations.  It also compares
35 digest and selector vectors with frozen values and live `cast` output.
Four Keccak mutants must fail their named vectors and a restored control
must pass.  The vectors cover binary inputs and the 136-byte rate boundary.
Five malformed adapter invocations must exit 64, and the sealed
`assay_keccak` signature must equal `dev/keccak-iface.txt`.
It prints pending backend stages and does not claim the M0 exit gate has passed.

The gates require Python 3.11 or newer (`-P`) and Foundry `cast` on PATH.
The OCaml toolchain is the installed `zxcaml-p1` switch.  The dune scripts
select it and derive the repository root from their own paths.  The library
names `kanon_kernel` and `kanon_surface` stay unchanged for a byte-exact carry.
The tot submodule remains data only and is not needed for the Stage B build.

License: MIT OR Apache-2.0.

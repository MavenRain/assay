# Assay carried sources

The upstream is kanon commit `2c2e6e6831a0b2cf3107fa4aad392606109a2bcf`.
`dev/PIN` holds this full object name and one newline.  The local Git history
contains the pin.  The carry gate reads committed objects from this repository.
It needs no upstream checkout, remote, or writable upstream index.

| Upstream commit | Scope | Delta |
| --- | --- | --- |
| `2c2e6e6831a0b2cf3107fa4aad392606109a2bcf` | Every file under `lib/` and `surface/` | Zero bytes; additions and deletions fail CARRY |

No upstream kernel commit has been carried after the pin.  Add one row here
when a later carry is approved.  `dev/CARRIED.md` remains the inherited ledger
for the older tot source.  Root `PIN` still identifies that tot submodule.
It is distinct from assay's `dev/PIN`.

## Stage A integration changes

The following files are integration code, outside the byte-preserved scope.

| Path | Change |
| --- | --- |
| `bin/kanon.ml` to `bin/assay.ml` | Keep check, erasure, axioms and spec-count; remove Wasm build and run; emit checks and erases, then reports EVM_BACKEND_UNAVAILABLE |
| `bin/host.ml`, `test/wasm.ml`, `wasm/`, `runtime/` | Remove the Wasm backend and its executable consumers |
| `dune-project`, `bin/dune`, `test/dune` | Name the project and binary assay; unlink Wasm; retain both checker test executables |
| `README.md`, `SPEC.md`, `.gitignore` | Describe assay Stage A and the inherited specification; ignore local captures |
| `dev/gates.sh`, carry, R0, house and trusted-line checks | Replace the Kanon runtime battery with the Stage A battery and explicit pending stages |

The plan allows only a `dispatch_emit` edit in the driver.  At the actual pin,
`run_emit`, `run_build` and `module_bytes` call `Kanon_wasm`, and `run` needs
the deleted runtime.  Editing the dispatch arm alone cannot unlink Wasm.
Stage A removes those callers and documents this necessary scope correction.
The inherited library names `kanon_kernel` and `kanon_surface` stay in place
so their dune files and source references remain byte-identical.  New backend
libraries receive the assay prefix when their stages add them.

Historical Wasm goldens, metatheory and development notes remain available.
They are inherited evidence, not claims about assay's EVM implementation.

## Stage E proof seed and integration

The 28 files under `proofs/` are byte-exact committed objects from kan-evm
`af81c541d394bd5d7477cf35e9f4021dc1a95539`.  `dev/PROOFS-PIN.json`
records each SHA-256 digest.  `AXIOMS` checks that manifest separately
from the unchanged Kanon kernel carry.  The seed includes its lakefiles,
toolchain, `FIDELITY.md`, tests and axiom report.  Local Lean build products
and dependency caches are ignored.  The upstream checkout remains unchanged.

Stage E replaces the driver's emission refusal with the checked M0 backend
and adds the `assay_emit` and `assay_abi` libraries.  No carried kernel or
surface file changes.  The seed proves statements about its Lean embedding;
it supplies no proof of the new OCaml emitter.

## M1 core emission

The third M1 slice adds source entry specialization, static continuations,
checked arithmetic, named ABI/layout emission and constructor lowering in
the existing `assay_emit` and `assay_abi` libraries. `assay_emit` now links
the existing Keccak library to derive selectors. The kernel, inherited
surface and carried proofs remain byte-identical. The new source fixture
uses their existing collection and recursive-family constructors.

## M1 contract surface

The fifth M1 slice adds `emit/contract.ml` and its sealed interface. It
lowers bounded contract/entry/do syntax into checked core declarations
before the existing driver pipeline. The files are priced within the
emitter allocation. The carried kernel, surface and proofs stay unchanged.
`examples/CounterSurface.asy` emits exactly the core counter's five files.
The scope, named refusals and remaining P1 proof forms are recorded in
`dev/M1-SURFACE.md`.

## M1 source model

The fourth M1 slice factors the existing specialization entry points and
adds an immutable effect interpreter in `emit/model.ml`. The public `run`
command replaces its pending diagnostic. The model is counted within the
existing emitter budget. It shares the checked source protocol with emission
and uses its own arithmetic, dispatch and storage execution. Kernel, surface,
proof seed and frozen contract sources remain byte-identical.

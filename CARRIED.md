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

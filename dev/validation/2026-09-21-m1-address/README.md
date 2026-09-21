# Contract-address validation

Baseline: `0eed12bd951f78c9c813a54188ec662a1de129b2`.
Command: `zsh -f dev/gates.sh` in the isolated address checkout.

The 73-leg run passes 70 gates and exits 1. HEX-LITERALS exposes the
existing HexWords `address()` entry colliding with the new reserved word.
Renaming that sample entry and its selector check to `literalAddress()`
fixes the failure. The complete HEX-LITERALS gate and HOUSE pass on
focused reruns, preserving the hex gate counts and mutation witnesses.
With that repair, 71 of 73 checks pass, including every M1 feature gate.
DENOMINATORS and M0-RATIO still fail at the existing frozen checksum
check, independently reproduced on the clean committed baseline.

The ADDRESS leg checks 1920 core execution cases, 128 unused-constructor
artifact pairs, 40 surface cases and 55 signed Cancun calls altogether.
Seven public-command checks, 24 refusals and five mutations with restored
controls also pass. Trusted lines: kernel 3997 unchanged, emitter 1800 of 1800 (up from 1799);
all existing bounds are unchanged. No performance or milestone-exit
verdict is claimed.

Evidence:

- `FINAL.json` records all 73 gate outcomes and the source identity.
- `FULL.log`, `FULL.stderr` and `FULL.json` retain the complete command result.
- `GATE-LOGS.tar.gz` contains the 73 unmodified per-gate logs under `logs/`.
- `ADDRESS-CAPTURES.tar.gz` contains the generated programs, artifacts,
  independently expected outcomes, model results, geth captures, signed
  transition evidence and mutation/control records under `address/`.
- `BASELINE-DENOMINATORS.*` records the independent clean-baseline failure.
- `HEX-LITERALS-RERUN.*` and `HOUSE-RERUN.*` retain the successful repair
  validation. The only source changes after the full run began are the
  HexWords entry name and the matching selector in its existing gate.
- `ATTEMPTS.tar.gz` retains every earlier finite build and validation
  capture under `attempts/`, including failures while developing the new
  test harness. FILES.sha256 hashes the archive as one file; its members have no separate hash inventory.
- `GATE-COMPATIBILITY.json` proves all 43 prior runner plans are identical
  and the new mode adds exactly one leg. `gate-compatibility.py` is the checker.
  Run it with the repository path as its only argument to repeat the comparison.
- `VALIDATED-SOURCES.json` pins 275 source and build files at validation time.
  The pin covers every tracked file outside dev/validation/ named dune, dune-project, lean-toolchain or lake-manifest.json, or ending in .lean, .py, .ml, .mli, .asy or .sh: 275 = the 270 of the 2026-09-20-m1-calldataload record, dev/address-test.py, examples/ContractAddress.asy and the three lake-manifest.json files that record did not pin.
- `INITIAL-SOURCES.json` preserves their identities when the full run began.
- `FILES.sha256` inventories this archive, excluding the inventory itself.

Extract the compressed logs and captures to inspect their original bytes.
The archive preserves raw output, including terminal newlines, without
normalizing diagnostics. The two geth execution paths are not independent
client implementations. These tests validate the implementation; they are
not a new proof of compiler correctness.

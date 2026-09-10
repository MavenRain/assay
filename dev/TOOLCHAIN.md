# Spike (a): the toolchain

Date: 2026-09-10.  The install step is the user's.  No agent installs software, and no
agent ran any installer for this file.  Every version below was read by a live command on
this machine on 2026-09-10, never copied from an earlier note.

## Table

| Tool | Status | Version | Command that read the version |
| --- | --- | --- | --- |
| git | present | git version 2.50.1 (Apple Git-155) | `git --version` |
| geth `evm` | present | evm version 1.14.12-stable | `evm --version` |
| foundry `cast` | present | cast 0.3.0 (5a8bd89 2024-12-20T08:45:53.135759000Z) | `cast --version` |
| ocamlopt | present | 5.2.1 | `ocamlopt -version` |
| ocamlc | present | 5.2.1 | `ocamlc -version` |
| opam switch | present | zxcaml-p1 | `opam switch show` |
| zarith | present | zarith (version: 1.14) | `ocamlfind list \| rg '^zarith'` |
| dune | present | 3.24.2 | `dune --version` |
| kanoncho | present | kanoncho 0.1.0 | `kanoncho --version` |
| node | present | v23.10.0 | `node --version` |
| jq | present | jq-1.6 | `jq --version` |
| rg | present | ripgrep 15.1.0 | `rg --version` |
| sd | present | sd 1.0.0 | `sd --version` |
| fd | present | fd 10.4.2 | `fd --version` |
| shasum | present | 6.02 | `shasum --version` |
| elan | present | elan 4.2.3 (b6cec7e10 2026-06-08) | `elan --version` |
| lake | present, no toolchain | error: no default toolchain configured.  run `elan default stable` to install and configure the latest Lean 4 stable release. | `lake --version` |
| kanon (on PATH) | absent | (prints nothing) | `command -v kanon` |
| kanon.exe (on PATH) | absent | (prints nothing) | `command -v kanon.exe` |
| solc | absent | (prints nothing) | `command -v solc` |
| vyper | absent | (prints nothing) | `command -v vyper` |
| huffc | absent | (prints nothing) | `command -v huffc` |
| hevm | absent | (prints nothing) | `command -v hevm` |
| halmos | absent | (prints nothing) | `command -v halmos` |
| kanon (pin build) | present | /Users/oobi/Documents/assay/_build/default/bin/kanon.exe : `usage: kanon check [--print\|--erased] FILE \| axioms FILE \| emit FILE -o OUT.wasm --export NAME \| run FILE --export NAME [--host node\|wasmtime\|kernel\|both] \| build FILE... -o OUT.wasm --export NAME... \| spec-count` | `dune build -j 2 --root /Users/oobi/Documents/assay`, then `fd -t x . /Users/oobi/Documents/assay/_build/default/bin`, then the first line of `--help` |

Host: arm64, ncpu 12, macOS 26.4, read by `uname -m`, `getconf _NPROCESSORS_ONLN` and
`sw_vers -productVersion`.  Load at the read: `1:01  27 users, load averages: 34.58 36.96
34.83`, read by `uptime`.

`kanon` on PATH is absent and that is not a blocker, because spike (b) builds the pin
executable inside the clone.  kanoncho is a distiller whose backend follows the moving
kanon checkout, so kanoncho is not the pin and no denominator row uses it.

Correction to the carried facts, measured not quoted (R-P): elan and lake are PRESENT on
this machine, against the earlier note that recorded them as absent.  lake has no default
Lean toolchain configured, so a Lean build still cannot run without the user's install
step, and the AXIOMS gate still prints a SKIP line.

## The Stage 0a install list, for the user

No agent runs any of these.  They are printed here verbatim for the user to run by hand.

- `foundryup`, the foundry upgrade, for anvil as the second executor and `cast run` at M1.
- solc through svm or Homebrew, the second oracle and a third-party ERC-20 ABI golden
  file, M2 and optional.
- elan and lake, the Lean 4 toolchain, for the carried kan-evm proofs AXIOMS gate, M0 and
  only if the Lean seed is carried.
- a geth newer than 1.14.12, for CLZ and the Fusaka rows, M4 and optional.
- nothing else: the opam switch, node, jq, python3, rg and sd are present.

## Two statements the plan requires

- The AXIOMS gate prints a SKIP line while the Lean toolchain cannot run (plan correction
  5).  On this machine elan is installed but no default toolchain is configured, so the
  SKIP line stands until the user runs the install step above.
- No ratio prints at Stage 0.  M0-RATIO is printed and gated at no milestone at M0
  (R-Q1a), and the denominators of spike (c) are frozen numbers only.

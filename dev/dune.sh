#!/bin/zsh
# dev/dune.sh ARGS...
# Uses the active public Dune toolchain from PATH at this repository's root.
# The root follows the script when a mutation test copies the repository.
# The repository's Dune configuration makes every enabled warning fatal.
set -eu
cd -- "${0:A:h}/.."
command -v dune >/dev/null || { print -u2 'dev/dune.sh: no dune on PATH -- activate an opam switch with OCaml 5.2.1, Dune 3.24.2 and Zarith 1.14 first (see README.md)'; exit 127; }
exec dune "$@"

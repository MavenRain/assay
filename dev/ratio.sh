#!/bin/zsh
set -eu
export PATH=/Users/oobi/.opam/zxcaml-p1/bin:$PATH
exec python3 -P ${0:A:h}/ratio.py "$@"

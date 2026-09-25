#!/bin/zsh
set -eu
exec python3 -P ${0:A:h}/house.py "${1:-${0:A:h:h}}"

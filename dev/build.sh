#!/bin/sh
set -eu
exec python3 -P "${0%/*}/build.py" "$@"

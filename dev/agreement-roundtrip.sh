#!/bin/sh
set -eu
ASSAY_ROOT=${1:-"${0%/*}/.."}
exec "$ASSAY_ROOT/_build/test/roundtrip" /dev/stdin

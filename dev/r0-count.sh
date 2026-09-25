#!/bin/zsh
# dev/r0-count.sh
# Diffs the fenced block under the "## R0 counts" heading of SPEC.md
# against the output of `kanon spec-count`.  Prints R0-COUNT OK and exits 0
# when the diff is empty, else prints the diff, R0-COUNT FAIL, and exits 1.
#
# SA-D7: the root comes from this script's own path, so a copy of the
# repository under a scratch directory checks itself.

set -u

chpwd_functions=()
unfunction chpwd 2>/dev/null

ROOT=${0:A:h}/..
SPEC=$ROOT/SPEC.md
DRIVER=$ROOT/_build/bin/assay
# The work directory sits under the repository root, not under the system
# temp directory, so the script needs no writable path outside the tree it
# checks.  .gitignore holds it.
WORK=$ROOT/.gatework/r0
rm -rf $WORK
mkdir -p $WORK

head_ln=$(rg -n '^## R0 counts$' -- $SPEC | head -1 | awk -F: '{print $1}')
if [[ -z $head_ln ]]; then
  print -r -- "R0-COUNT FAIL: SPEC.md has no '## R0 counts' heading"
  rm -rf $WORK
  exit 1
fi

# The block is the text between the first two fence lines after the heading.
open_ln=$(rg -n '^```' -- $SPEC | awk -F: -v h=$head_ln '$1 > h' | head -1 | awk -F: '{print $1}')
close_ln=$(rg -n '^```' -- $SPEC | awk -F: -v h=$head_ln '$1 > h' | head -2 | tail -1 | awk -F: '{print $1}')
if [[ -z $open_ln || -z $close_ln || $close_ln -le $open_ln ]]; then
  print -r -- "R0-COUNT FAIL: SPEC.md has no fenced block under the heading"
  rm -rf $WORK
  exit 1
fi

awk -v a=$((open_ln + 1)) -v b=$((close_ln - 1)) 'NR >= a && NR <= b' $SPEC > $WORK/spec.txt

if [[ ! -x $DRIVER ]]; then
  print -r -- "R0-COUNT FAIL: $DRIVER is not built"
  rm -rf $WORK
  exit 1
fi

# The status of the driver is part of the check: a driver that prints the
# expected block and then exits nonzero (the JS worker propagates the worker
# exit code) must fail the leg, not pass it.  The script keeps `set -u` alone
# because `set -e` would abort on the `unfunction chpwd` of line 13 when no
# chpwd function is defined, so every fallible command carries its own test.
$DRIVER spec-count > $WORK/driver.txt
driver_st=$?
if (( driver_st != 0 )); then
  print -r -- "R0-COUNT FAIL: $DRIVER spec-count exited $driver_st"
  rm -rf $WORK
  exit 1
fi

if diff $WORK/spec.txt $WORK/driver.txt > $WORK/d 2>&1; then
  print -r -- "R0-COUNT OK"
  rm -rf $WORK
  exit 0
fi

cat $WORK/d
print -r -- "R0-COUNT FAIL"
rm -rf $WORK
exit 1

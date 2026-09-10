#!/bin/zsh
# assay dev/import-check.sh.  Stage 0 spike (b).  Date 2026-09-10.
# Checks that the repository is the kanon import at the pin, with its history kept.
# Usage: zsh dev/import-check.sh <root> <pin-file>
# Prints IMPORT 2c2e6e6 ancestor=0 diff=0 git_kb=<n> commits=<n> and exits 0,
# or IMPORT FAIL <reason> and exits 1.
# It is the prototype of the Stage A dev/carry-check.sh.
set -eu

case "$#" in
  2) root="$1"; pin_file="$2" ;;
  *) print -r -- "IMPORT FAIL usage: import-check.sh <root> <pin-file>"; exit 4 ;;
esac

case "$(test -d "$root/.git" && print -r -- yes || print -r -- no)" in
  yes) : ;;
  *) print -r -- "IMPORT FAIL no git directory at $root/.git"; exit 1 ;;
esac

case "$(test -r "$pin_file" && print -r -- yes || print -r -- no)" in
  yes) : ;;
  *) print -r -- "IMPORT FAIL pin file not readable: $pin_file"; exit 1 ;;
esac

pin="$(head -1 "$pin_file")"
head_sha="$(git -C "$root" rev-parse HEAD)"

case "$head_sha" in
  "$pin") : ;;
  *) print -r -- "IMPORT FAIL head $head_sha is not the pin $pin"; exit 1 ;;
esac

set +e
git -C "$root" merge-base --is-ancestor "$pin" HEAD
ancestor="$?"
set -e

case "$ancestor" in
  0) : ;;
  *) print -r -- "IMPORT FAIL pin $pin is not an ancestor of HEAD (exit $ancestor)"; exit 1 ;;
esac

diff_out="$(git -C "$root" diff --stat "$pin" HEAD -- lib surface)"
diff_lines="$(print -r -- "$diff_out" | rg -c . || true)"

case "$diff_lines" in
  ''|0) diff_count=0 ;;
  *) print -r -- "IMPORT FAIL lib or surface differs from the pin: $diff_lines line(s)"; exit 1 ;;
esac

git_kb="$(du -sk "$root/.git" | cut -f1)"

case "$(test "$git_kb" -lt 30720 && print -r -- yes || print -r -- no)" in
  yes) : ;;
  *) print -r -- "IMPORT FAIL .git is $git_kb KB, over the 30720 KB bound"; exit 1 ;;
esac

commits="$(git -C "$root" rev-list --count HEAD)"

case "$(test "$commits" -gt 0 && print -r -- yes || print -r -- no)" in
  yes) : ;;
  *) print -r -- "IMPORT FAIL no history: rev-list --count HEAD prints $commits"; exit 1 ;;
esac

print -r -- "IMPORT ${pin:0:7} ancestor=${ancestor} diff=${diff_count} git_kb=${git_kb} commits=${commits}"
exit 0

# Spike (b): the import of kanon at the pin

Date: 2026-09-10.  Stage 0 of M0.  Ruling R-M0-2 (clone form, history kept) and R-3.

## Tool

```
$ git --version
git version 2.50.1 (Apple Git-155)
```

## The three commands and their output

```
$ git clone --no-checkout /Users/oobi/Documents/kanon /Users/oobi/Documents/assay
Cloning into '/Users/oobi/Documents/assay'...
done.
exit=0
$ git -C /Users/oobi/Documents/assay checkout -b main 2c2e6e6
fatal: a branch named 'main' already exists
exit=128
$ git -C /Users/oobi/Documents/assay remote remove origin
exit=0
```

The second command failed because `git clone` copies the source HEAD branch name, so a
branch `main` already existed in the clone and pointed at the source HEAD
69f3be5198cda4334de4fd23b4ccc92cac595789, which sits one commit ahead of the pin.  The
clone used `--no-checkout`, so no file was written from that branch.  The repair keeps the
same intent as R-M0-2, which is `main` at the pin with the history kept:

```
$ git -C /Users/oobi/Documents/assay branch --list
* main
$ git -C /Users/oobi/Documents/assay checkout -B main 2c2e6e6
Reset branch 'main'
exit=0
```

Finding F-IMPORT-1, recorded and not worked around: the exact command
`checkout -b main 2c2e6e6` cannot succeed against a source whose default branch is also
`main`.  Stage A repeats `checkout -B main <pin>`, which is idempotent and lands the pin by
object.

## The four checks of dev/import-check.sh

```
$ zsh /Users/oobi/Documents/assay/dev/import-check.sh /Users/oobi/Documents/assay /Users/oobi/Documents/assay/dev/PIN
IMPORT 2c2e6e6 ancestor=0 diff=0 git_kb=12124 commits=30
import_check_exit=0
```

- HEAD equals the PIN content: `git -C ... rev-parse HEAD` prints
  2c2e6e6831a0b2cf3107fa4aad392606109a2bcf, and dev/PIN holds the same string.
- `git -C ... merge-base --is-ancestor 2c2e6e6 HEAD` exits 0, printed as `ancestor=0`.
- `git -C ... diff --stat 2c2e6e6 HEAD -- lib surface` prints nothing, printed as `diff=0`.
- `du -sk .git` prints 12124 KB, under the 30720 KB bound;  the source .git measured 21 MB
  by an earlier read, and the clone is smaller because it copies reachable objects only.

## The history is kept

```
$ git -C /Users/oobi/Documents/assay rev-list --count HEAD
30
$ git -C /Users/oobi/Documents/kanon rev-list --count 2c2e6e6
30
$ git -C /Users/oobi/Documents/kanon rev-list --count HEAD
31
$ git -C /Users/oobi/Documents/assay remote -v
$ du -sh /Users/oobi/Documents/assay/.git
 12M	/Users/oobi/Documents/assay/.git
```

`remote -v` prints nothing, so the origin remote is gone.  The clone carries every commit
that the pin reaches, 30 of 30.  Finding F-IMPORT-2: gate S0-G1 asks for a count over 100,
and the whole kanon history at the pin is 30 commits, so that leg cannot pass on this
source.  The evidence above shows the count of the clone equals the count of the source at
the pin, which is the property the leg intends to prove.

## The pin build

```
$ dune build -j 2 --root /Users/oobi/Documents/assay
build_exit=0
$ fd -t x . /Users/oobi/Documents/assay/_build/default/bin
/Users/oobi/Documents/assay/_build/default/bin/kanon.exe
```

The build ran under `zsh -f`, because the login rc files abort a `set -u` script with
`_telcoin_shared_target:7: CARGO_TARGET_DIR: parameter not set`.  That is finding
F-IMPORT-3 and it does not touch the repository.  `_build` never enters the repository:
`git -C /Users/oobi/Documents/assay check-ignore -v _build` prints
`.gitignore:1:_build/	_build`, and `git -C /Users/oobi/Documents/assay status --porcelain`
lists dev/ files only.

## The command list Stage A repeats

```
git clone --no-checkout /Users/oobi/Documents/kanon /Users/oobi/Documents/assay
git -C /Users/oobi/Documents/assay checkout -B main 2c2e6e6
git -C /Users/oobi/Documents/assay remote remove origin
dune build -j 2 --root /Users/oobi/Documents/assay
zsh /Users/oobi/Documents/assay/dev/import-check.sh /Users/oobi/Documents/assay /Users/oobi/Documents/assay/dev/PIN
```

Stage A adds dev/carry-check.sh and CARRIED.md over this same shape.  Stage 0 writes
neither.

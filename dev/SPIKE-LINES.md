# SPIKE-LINES

Spike (d) of Stage 0, the trusted-line head room.  Date 2026-09-10.  Kanon pin
2c2e6e6831a0b2cf3107fa4aad392606109a2bcf.  Brief section 3.4, gate S0-G6.  This spike writes no
OCaml.  Every number below is printed by a command that this file names;  no number is quoted from
the plan without a rerun.

## 1 The export

The commit is exported with git archive.  No worktree is added, no clone is made into the source
checkout, and no file of /Users/oobi/Documents/kanon is written or read from its working tree.

```
mkdir -p /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6
git -C /Users/oobi/Documents/kanon archive 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf \
  | tar -x -C /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6
```

The export holds 18 top-level entries, among them lib, wasm, runtime, surface, bin, dev and PIN.

## 2 The measured line at the pin

The script takes the root from its own path when no argument is given, so the export measures
itself and no argument was passed:

```
zsh /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/dev/trusted-lines.sh
```

printed:

```
TRUSTED-LINES kernel=3997/4000 encoder=246/600 OK
```

and exited 0.

The kernel leg is the sum of 12 files.  `wc -l` over the 12 files of the script's `kernel_files`
list prints `3997 total`:

| file | lines |
| --- | --- |
| lib/shape.ml | 60 |
| lib/term.ml | 133 |
| lib/rules.ml | 1481 |
| lib/check.ml | 538 |
| lib/value.ml | 137 |
| lib/eval.ml | 297 |
| lib/conv.ml | 396 |
| lib/totality.ml | 146 |
| lib/positivity.ml | 118 |
| lib/global.ml | 130 |
| lib/order.ml | 510 |
| lib/bignum.ml | 51 |
| total | 3997 |

Kernel head room is 4000 minus 3997, which is 3 lines.  M0 spends none of the 3.  Any kernel line
an assay stage spends is a gate failure.

The encoder leg is one file, wasm/gc_encode.ml, at 246 of 600.  Encoder head room is 354 lines,
and section 7 below states why that head room does not survive Stage A.

## 3 The lines Stage A deletes

`wc -l` over the OCaml files of the export wasm directory prints:

| file | lines |
| --- | --- |
| wasm/emit.ml | 1123 |
| wasm/gc_encode.ml | 246 |
| wasm/link.ml | 1162 |
| total | 2531 |

The 2531 of the plan is therefore the wasm OCaml total and not the total of the two directories.
The wasm directory holds one more file, `wasm/dune`, at 55 bytes.  The runtime directory holds no
OCaml:  runtime/reactor.kan 53, runtime/reactor.mjs 275 and runtime/run.mjs 28, which is 356 lines.
Stage A, which deletes both directories, therefore removes 2531 OCaml lines and 356 other lines,
2887 lines in all.  The 2531 figure stays the number this spike measures against, because only the
OCaml lines are the emitter that assay replaces.

## 4 The six projections

Each row projects the line count of a new artifact against its ruled bound (R-M0-3, D-M0-3).  The
basis file is a file of the export whose `wc -l` this spike printed, and the reason states which
part of the basis carries over and which part does not.  A projection is a commitment, not a
measurement:  the stage that writes each artifact measures it and the TRUSTED-LINES row replaces
the projection.

| artifact | bound | projection | head room | basis file | basis wc -l | reason |
| --- | --- | --- | --- | --- | --- | --- |
| emitter | 1800 | 1450 | 350 | wasm/emit.ml | 1123 | The basis lowers 12 erased constructors to wasm and carries the wasm GC type work, which EVM does not have.  The EVM emitter drops that type work and adds the Word unboxing recognizer and the storage recognizer (R-QA, R-QB).  1123 minus about 250 lines of GC typing, plus about 580 lines of stack discipline, two recognizers and the memory model, is 1450. |
| assembler | 600 | 480 | 120 | wasm/link.ml | 1162 | The basis assembles 11 wasm sections, resolves indices and writes LEB128 offsets.  Only the label and offset resolution carries over, which is about 380 of the 1162.  The EVM assembler adds the per-block stack height, the F-4 repair, at about 100 lines.  380 plus 100 is 480. |
| keccak | 250 | 210 | 40 | wasm/gc_encode.ml | 246 | The basis is the one byte-level pure-function file of the pin, at 246 lines, and it is the closest measured analogue of a hash core.  keccak-f[1600] is 5 step mappings over 24 rounds with 3 constant tables of 24, 24 and 24 entries.  About 100 lines of tables, about 70 lines of the 5 steps and about 40 lines of sponge, pad and squeeze is 210. |
| ABI printer | 400 | 320 | 80 | lib/global.ml | 130 | The basis is the declaration table the printer enumerates, at 130 lines.  The printer walks the same table and prints the Solidity contract-ABI JSON shape verbatim (R-5).  About 130 lines of the canonical type name mapper, about 120 lines of the entry shapes and about 70 lines of the `jq -S -c` canonical ordering is 320. |
| layout printer | 250 | 200 | 50 | lib/eterm.ml | 117 | The basis is the erased term whose storage fields the printer reads, at 117 lines.  The printer prints the solc `storageLayout` field names astId, contract, label, offset, slot and type, plus the types map.  About 90 lines of the slot walk and about 110 lines of the two JSON shapes is 200. |
| listing printer | 250 | 190 | 60 | lib/pp.ml | 102 | The basis is the whole display printer of the kernel term, at 102 lines, and it is the measured cost of one sum type to one string.  The listing printer prints a pc column, the opcode mnemonic and the immediate bytes.  About 120 lines of the mnemonic table and about 70 lines of the pc walk and the immediate widths is 190. |

Every projection is under its bound, so no row asks for a bound to move.

## 5 The totals

The six bounds are 1800, 600, 250, 400, 250 and 250.  The bound total is 3550, which is the total
that R-M0-3 settles.  The projection total is 1450 plus 480 plus 210 plus 320 plus 200 plus 190,
which is 2850.  Total head room is 3550 minus 2850, which is 700 lines, 19.7 percent of the bound
total.

The other reading of the budget is 3300, over five artifacts, which prices no listing printer.  The
difference 3550 minus 3300 is 250, which is the listing printer row exactly.  D-M0-3 rules the 3550
reading and prints the total.  The projection total 2850 is 450 under the 3300 reading as well, so
the six projections hold under both readings and nothing in this spike depends on which reading
binds.

## 6 Against the 2531 deleted lines

The bound total 3550 is 1019 lines more than the 2531 that Stage A deletes, a ratio of 1.40.  The
projection total 2850 is 319 lines more than 2531, a ratio of 1.13.  So the projected trusted base
of assay is about one eighth larger than the wasm back end it replaces, and the ruled bounds leave
700 lines of head room above that.  Against the 2887 lines of both directories, the projection 2850
is 37 lines smaller, a ratio of 0.99.

The kernel is a separate leg and does not move:  3997 of 4000, with 3 lines of head room, before
one line of assay is written.

## 7 The encoder leg does not survive Stage A

The script names one encoder file, `$root/wasm/gc_encode.ml`.  Stage A deletes wasm, so that path
goes.  A scratch copy of the export with lib and dev only, and no wasm, was measured to show the
result:

```
zsh /Users/oobi/Documents/assay-m0/spikes/lines/probe-nowasm/dev/trusted-lines.sh
```

printed:

```
trusted-lines: a trusted file is missing under /Users/oobi/Documents/assay-m0/spikes/lines/probe-nowasm/dev/..
TRUSTED-LINES FAIL
```

and exited 1.  Stage A must therefore repoint the encoder leg at the six new artifacts, one
TRUSTED-LINES row per artifact (R-QD), in the same change that deletes wasm.  If it does not, the
gate fails for a missing file and not for a spent line, which is a false red.  This spike writes no
change to the script, because the script is a repository file of Stage A work.

## 8 Rerun

```
git -C /Users/oobi/Documents/kanon archive 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf \
  | tar -x -C /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6
zsh /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/dev/trusted-lines.sh
wc -l /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/wasm/emit.ml \
      /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/wasm/gc_encode.ml \
      /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/wasm/link.ml
wc -l /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/lib/global.ml \
      /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/lib/eterm.ml \
      /Users/oobi/Documents/assay-m0/spikes/lines/kanon-2c2e6e6/lib/pp.ml
```

The export directory is scratch under /Users/oobi/Documents/assay-m0/spikes/ and never enters the
repository.

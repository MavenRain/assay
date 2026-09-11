# M0 mutation log

This file is the assay mutation log.  The kanon mutation log carried at the pin covers a different
line of work and stays in history;  read it with
`git -C /Users/oobi/Documents/assay show 2c2e6e6:dev/MUTATION-LOG.md`.  The rewrite of this path is
recorded as finding F-1 in dev/M0-BUILD-LOG.md.

## Stage 0

Date 2026-09-10.  Runner /Users/oobi/Documents/assay-m0/mutants/run-mutants.sh, output
/Users/oobi/Documents/assay-m0/mutants/mutants-2026-09-10.log.  Every mutant runs on a copy under
/Users/oobi/Documents/assay-m0/mutants/, never on a repository file.  Each copy is deleted after its
run and the sha256 of every original is printed before and after the runner.

Originals before and after, byte identical:

```
d8d4d85f4289ed0913708d7c13e809ac5329d772255a1b0716f98581f54e3328  /Users/oobi/Documents/assay/dev/DENOMINATORS.sha256
789550fa6cb8641e4adbdc0b5ae8a1aaabf4bf067f4ab6b3e0436cec97d4d6c1  /Users/oobi/Documents/assay/dev/PIN
e5abe35480f009fca07f79f15d3dc8c32fba412d93ec81fb5f793775f8e42e5f  /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json
```

### S0-M1 hash, KILLED

Copy dev/DENOMINATORS.sha256, alter one hex digit of the first sha in the copy, run the check from the
repository root.

Mutation: line 1 leading digit 0 becomes 1.

```
original line 1: 02041d10e63437f34ef24050e2a408e5e6945d85ad1873e420deffd53a274cf8  dev/denominator.sh
mutated line 1:  12041d10e63437f34ef24050e2a408e5e6945d85ad1873e420deffd53a274cf8  dev/denominator.sh
```

Command:

```
$ zsh -c "cd /Users/oobi/Documents/assay && shasum -a 256 -c /Users/oobi/Documents/assay-m0/mutants/DENOMINATORS.sha256.mut"
dev/denominator.sh: FAILED
shasum: WARNING: 1 computed checksum did NOT match
exit 1
```

KILLED: the check prints FAILED and exits 1.

### S0-M2 prestate, KILLED under the run recipe, and finding F-2

The brief section 5 writes this mutant as "delete `cancunTime` from the copy" and expects the line
` error: invalid opcode: PUSH0`.  Both recipes were run.  The literal recipe SURVIVES on geth 1.14.12,
because PUSH0 is a Shanghai opcode (EIP-3855) and the copy keeps `shanghaiTime`.  The recipe this stage
ran deletes both fork times, which is the intent of the check, a prestate that does not enable the
opcode under test, and it kills the mutant.  The departure is finding F-2 of dev/M0-BUILD-LOG.md and is
also flagged in dev/SPIKE-FORK.md section 3.1.

Literal recipe, `jq 'del(.config.cancunTime)'`, SURVIVOR, recorded as evidence for F-2 and not counted
as a kill:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/mutants/cancun-no-cancuntime.json --code 5f00
exit 0, no output
```

Run recipe, `jq 'del(.config.cancunTime) | del(.config.shanghaiTime)'`, KILLED:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/mutants/cancun-no-cancun-no-shanghai.json --code 5f00

 error: invalid opcode: PUSH0
```

Companion row, the same literal copy with the Cancun opcode TLOAD, which proves the literal deletion
does disable the Cancun set and only the Shanghai opcode PUSH0 escapes it:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/mutants/cancun-no-cancuntime.json --code 5f5c00

 error: invalid opcode: TLOAD
```

KILLED under the run recipe.  The literal recipe of the brief is a survivor and is carried as finding
F-2 for the judge, with the sensitive command recorded above.

### S0-M3 pin, KILLED

Copy dev/PIN, move one character of the sha in the copy, run dev/import-check.sh with the repository
root and the copy.

Mutation: the leading character 2 moves to the end of the sha.

```
original: 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf
mutated:  c2e6e6831a0b2cf3107fa4aad392606109a2bcf2
```

Command:

```
$ zsh /Users/oobi/Documents/assay/dev/import-check.sh /Users/oobi/Documents/assay /Users/oobi/Documents/assay-m0/mutants/PIN.mut
IMPORT FAIL head 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf is not the pin c2e6e6831a0b2cf3107fa4aad392606109a2bcf2
exit 1
```

KILLED: the script prints IMPORT FAIL and exits 1.

### Result

Three mutants run, three killed, no repository file mutated, every copy deleted.  One departure from
the literal brief recipe, S0-M2, is recorded as finding F-2 with its own survivor evidence.

### The judge rerun (2026-09-10)

The judge reran all three mutants itself.  Runner /Users/oobi/Documents/assay-m0/judge/mutants.sh,
output /Users/oobi/Documents/assay-m0/judge/mutants.log.  Every mutant ran on a copy under
/Users/oobi/Documents/assay-m0/mutants/, every copy was deleted, and the sha256 of every original is
identical before and after the run:

```
d8d4d85f4289ed0913708d7c13e809ac5329d772255a1b0716f98581f54e3328  /Users/oobi/Documents/assay/dev/DENOMINATORS.sha256
789550fa6cb8641e4adbdc0b5ae8a1aaabf4bf067f4ab6b3e0436cec97d4d6c1  /Users/oobi/Documents/assay/dev/PIN
e5abe35480f009fca07f79f15d3dc8c32fba412d93ec81fb5f793775f8e42e5f  /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json
```

S0-M1, one hex digit of the denominators.json line changed from `0301e112` to `0301e113` in the copy
/Users/oobi/Documents/assay-m0/mutants/judge-M1-DENOMINATORS.sha256:

```
$ zsh -c "cd /Users/oobi/Documents/assay && shasum -a 256 -c /Users/oobi/Documents/assay-m0/mutants/judge-M1-DENOMINATORS.sha256"
dev/denominators.json: FAILED
shasum: WARNING: 1 computed checksum did NOT match
exit 1
```

KILLED.

S0-M2, two copies of the scratch prestate.  The literal recipe of the brief deletes `cancunTime`
only;  the corrected recipe deletes `cancunTime` and `shanghaiTime`:

```
$ /opt/homebrew/bin/evm run --prestate <literal copy> --code 5f00
(no output, exit 0)                                   SURVIVOR, finding F-2
$ /opt/homebrew/bin/evm run --prestate <literal copy> --code 5f5c00
 error: invalid opcode: TLOAD                          KILLED
$ /opt/homebrew/bin/evm run --prestate <corrected copy> --code 5f00
 error: invalid opcode: PUSH0                          KILLED
```

KILLED.  PUSH0 is EIP-3855, a Shanghai opcode, so the deletion of `cancunTime` alone cannot disable
it.  The property the mutant tests, that the prestate and not a default governs the answer set, is
killed twice:  by the Cancun opcode TLOAD on the literal copy, and by PUSH0 on the corrected copy.
The literal survivor is printed above and is recorded as finding F-2 in dev/M0-BUILD-LOG.md.

S0-M3, the leading character of the sha moved to the end in the copy
/Users/oobi/Documents/assay-m0/mutants/judge-M3-PIN:

```
$ zsh /Users/oobi/Documents/assay/dev/import-check.sh /Users/oobi/Documents/assay /Users/oobi/Documents/assay-m0/mutants/judge-M3-PIN
IMPORT FAIL head 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf is not the pin c2e6e6831a0b2cf3107fa4aad392606109a2bcf2
exit 1
```

KILLED.

Judge result:  three mutants, three killed, no repository file mutated, every copy deleted, and
`git -C /Users/oobi/Documents/assay status --porcelain` unchanged by the run.


## Stage A (2026-09-10)

Command: `python3 -P dev/stage-a-test.py mutants`.  Each mutation runs in a
temporary copy.  It must exit 1 and print its named rejection.  Original
bytes are restored between cases.  The source checkout is never mutated.

| Mutant | Damage | Rejection |
| --- | --- | --- |
| PIN | Replace dev/PIN with forty zeroes | PIN FAIL |
| CARRY | Append a newline to lib/check.ml | CARRY changed lib/check.ml |
| CARRY-NEW | Add lib/unlisted.ml | CARRY extra lib/unlisted.ml |
| CARRY-GONE | Delete the carried lib/pp.ml | CARRY missing lib/pp.ml |
| R0-COUNT | Change the documented former count to 3 | R0-COUNT FAIL |
| R0-AUDIT | Put SColl in an unapproved kernel file | R0-AUDIT FAIL |
| R0-AUDIT-SPEC | Cite an absent refusing module in the SPEC.md shape table | cites the absent refuser gone.ml |
| HOUSE | Add a failwith site to the driver | HOUSE FAIL |
| HOUSE-LOOP | Add a for loop to the driver | HOUSE no-loop-keyword FAIL |
| HOUSE-DIVISION | Add a bare division to the driver | HOUSE no-bare-division FAIL |
| TRUSTED-LINES | Grow the inherited kernel by one line | TRUSTED-LINES FAIL |
| TRUSTED-UNPRICED | Add emit/hidden.ml outside the priced inventory | unpriced=emit/hidden.ml |
| TRUSTED-BOUND | Add a 251-line keccak implementation | TRUSTED-LINES FAIL |

Result: `MUTANTS killed=13/13 OK`.  Complete output is in
`dev/validation/2026-09-10-stage-a/MUTANTS.log`.

## Stage B (2026-09-10)

Runner: `python3 -P dev/keccak-test.py mutants`, after the build.
Each mutant builds the same library and adapter in an isolated temporary
Dune project.  A compile failure does not count as a kill.  The frozen
vector gate must exit 1 and name the expected failing vector.  The source
is then restored, rebuilt, and required to pass the same vector gate.

| mutant | edit | required witness |
| --- | --- | --- |
| PADDING | Change suffix 0x01 to SHA3 suffix 0x06 | K2 empty-input digest fails |
| END-BIT | Remove the final 0x80 padding bit | K2 empty-input digest fails |
| EXACT-RATE | Omit the extra padding block after an exact rate block | B136 digest fails |
| SELECTOR | Select digest bytes 4 to 7 instead of 0 to 3 | S1 transfer selector fails |

Result: `KECCAK-MUTANTS killed=4/4 control=OK`.  All 13 inherited mutants
also pass.  The summary and four complete rejection transcripts are in
`dev/validation/2026-09-10-stage-b/`.  The live oracle gate separately
requires all 35 unmodified vectors to match `cast` and their frozen values,
prints the `cast` output of each row beside the frozen value, requires five
malformed adapter invocations to exit 64, and pins the sealed
`assay_keccak` signature against `dev/keccak-iface.txt`.

## Stage C (2026-09-10)

Command: `python3 -P dev/asm-test.py mutants`, as the ASM-MUTANTS leg of
`dev/gates.sh`.  Each mutant runs in a temporary copy containing the assembler,
listing, adapter and the same gate inputs.  Each mutated program must build
with zero warnings.  A compile failure is not a kill.  Each gate must exit 1
and print the named witness.  The first four mutants run the `stack` mode, the
STACK-HEIGHT leg, whose adapter prints one line per case with the `ASM-CASE`
prefix.  The last two run the `disasm` mode, the DISASM-3WAY leg.  Each witness
below is the literal string the kill rule requires in the mutant output.
The sources are restored between mutants.

| Mutant | Change | Required witness |
| --- | --- | --- |
| STACK-EFFECT | Change ADD from two inputs to one | ASM-CASE add-underflow FAIL |
| EDGE-HEIGHT | Disable the block-edge height comparison | ASM-CASE goto-height FAIL |
| JUMP-PEAK | Exempt label pushes from the 1024-word limit | ASM-CASE branch-overflow FAIL |
| LABEL-PC | Add one to each resolved label offset | ASM-CASE ref20 FAIL |
| LISTING-OP | Print SLOAD for byte 0x55, which is SSTORE | DISASM-3WAY ref20 FAIL |
| LISTING-PC | Ignore PUSH width when advancing the listing PC | DISASM-3WAY ref20 FAIL |

Result: `ASM-MUTANTS killed=6/6 control=OK`.  After restoration, both the
complete stack gate and the live three-way disassembly gate pass.  The six
rejection transcripts and both control transcripts are stored in
`dev/validation/2026-09-10-stage-c/`.  The full battery also kills all 13
Stage A and all four Stage B mutants.  No Stage C gate executes EVM code.

## Stage D (2026-09-10)

Command: `python3 -P dev/reference-test.py mutants`.  Each fixture mutation
runs the same gate in a temporary copy with the checked Stage C adapter.
No mutation rebuild is needed because the compiled code is unchanged.
Each run must exit 1, print its named witness and produce no traceback.
The original fixture is restored between mutations.

| Mutant | Change | Required witness |
| --- | --- | --- |
| CANCUN-OFF | Remove only config.cancunTime | FORK-TLOAD invalid opcode: TLOAD |
| SHANGHAI-OFF | Remove cancunTime and shanghaiTime | FORK-PUSH0 invalid opcode: PUSH0 |
| REFERENCE-BYTE | Change the stored literal from 42 to 43 | REFERENCE-BYTES |
| REFERENCE-PC | Change SSTORE's declared PC | REFERENCE-PC |
| REFERENCE-NAME | Annotate SSTORE as SLOAD | REFERENCE-LISTING |
| INIT-OFFSET | Copy from offset 11 instead of 10 | CREATE-BYTES |
| INIT-LENGTH | Copy and return 19 runtime bytes | CREATE-BYTES |
| INIT-REVERT | Replace the creation RETURN with REVERT | CREATE-EXEC execution reverted |

Result: `REFERENCE-MUTANTS killed=8/8 controls=3 OK`.  The restored fork,
trace and creation gates all pass.  The Cancun-only control also proves
that PUSH0 still executes, and the Shanghai-off control checks the plain
`error: invalid opcode: PUSH0` line.  This preserves the measured correction
in `dev/SPIKE-FORK.md` section 3.1 rather than repeating the plan's literal
PUSH0 expectation for a Cancun-only deletion.

`python3 -P dev/reference-test.py checks` corrupts copies of live successful
captures.  Twenty-two field edits cover PCs, numeric opcodes, names, stacks,
return values, execution errors, storage, balance, gas and installed code.
Two of them are the runtime-account edit, which adds one account to the
runtime dump, and the sender-nonce edit, which clears the sender nonce of
the creation dump.
Five cases remove, duplicate or reorder trace records.  Two cases damage
cast rows, two reject duplicate JSON keys and a non-object JSON value, and
one damages the reference row of the checked-block fixture table.
Each case requires its exact error code.  Both unchanged controls pass.
Result: `REFERENCE-CHECKS cases=32 controls=2 OK`.

The complete battery also retains the 13 Stage A, four Stage B and six
Stage C mutant kills.  Evidence is in
`dev/validation/2026-09-10-stage-d/`.

## Stage E (2026-09-10)

`python3 -P dev/emit-test.py mutants` copies the source to an isolated
directory.  Every mutant must build without errors or warnings, then fail
the named witness.  A build failure does not count as a kill.  Each source
is restored before the next mutation.  All four restored controls pass.

| Mutant | Code change | Required failing witness |
| --- | --- | --- |
| WORD-BOX | Return a Word `Struct` instead of the unboxed word | WORD-UNBOX `word-zero` |
| WORD-RANGE | Permit a 257-bit payload | WORD-UNBOX `word-overflow` |
| STORAGE-CLOSURE | Accept storage closures and tail applications | STORAGE-NOCLOS `storage-closure` |
| STORAGE-ALIAS | Stop following a referenced storage field body | STORAGE-NOCLOS `storage-hidden` |
| GLOBAL-APP | Replace a called function body with zero | EMIT-CONSTRUCTORS `app` |
| ABI-ENTRY | Emit a nonempty ABI | ABI-GOLD mismatch |
| LAYOUT-SLOT | Shift every printed slot by one | LAYOUT-GOLD mismatch |

Result: `EMIT-MUTANTS killed=7/7 controls=4 OK`.  The exact compiler and
witness outputs are the `emit-mutant-*.log` and `emit-control-*.log` files
under `dev/validation/2026-09-10-stage-e/`.

The ABI comparator uses a synthetic nonempty row because the emitted M0
ABI is empty.  Reordering its keys preserves live `jq -S -c` equality;
renaming its entry breaks equality.  A real emitted-ABI mutant above also
breaks the production comparison.  The layout control checks escaped
strings and declaration order.

The proof gate checks its report parser against three damaged captures:
add `sorryAx`, drop the first theorem and duplicate the first theorem.
All are rejected.  No carried proof source is modified by these controls.
The restored complete report has 42 theorem rows and no `sorryAx`.

The complete Stage E battery also retains the 13 Stage A, four Stage B,
six Stage C and eight Stage D mutant kills.

## Stage F (2026-09-11)

The ERASED-BYTES seed replaces the proof argument with an application and
a let.  The checked forms are distinct, the declarations are identical,
and both runtime and init bytes stay equal.  A payload change from 42 to
43 changes both byte strings.  This is a seed for the M2 obligation.

| change | gate | required witness |
| --- | --- | --- |
| emitted PUSH1 payload 42 to 43, then execute | F-MUTANTS (M0-TRACE check) | TRACE-STACK |
| runtime byte changed beside the intact constructor | F-MUTANTS (CREATE-EQ check) | CREATE-BYTES |
| append one newline to a frozen corpus file | F-MUTANTS (CORPUS check) | CORPUS-HASH |
| append one newline to frozen denominators.json | F-MUTANTS (DENOMINATORS check) | sha256; the leg requires the shasum line `dev/denominators.json: FAILED` and records `witness=sha256` |
| report four runs instead of five | M0-RATIO validator | RATIO-SUMMARY |
| report one source line | M0-RATIO validator | RATIO-SUMMARY |
| report a zero median | M0-RATIO validator | RATIO-SUMMARY |

All seven changes fail their named checks.  The five gate rows above run
inside the F-MUTANTS leg, which reads the check functions of the named
gates; the mutants are not run through those gate commands.  Five
unchanged controls pass: trace, creation, corpus hashes, denominator hash
and ratio metadata.  `ORACLES.json` in the Stage F validation directory
holds the execution and listing receipts of the controls and mutants
(`f-control-run`, `f-control-cast`, `f-control-create`, `f-mutant-run`
and `f-mutant-cast`).  `F-MUTANTS.log` keeps one kill line per change
with its witness identifier.  It holds no rejection text.  The
runtime-byte trace witness executes the changed code; it is not rejected
by a pre-execution hash comparison.

The denominator of the printed `F-MUTANTS killed=7/7` line is the roster
of seven declared names, so a deleted mutation fails `F-MUTANT-ROSTER`.
In the `ERASED-BYTES` line, `mutants` counts the checked proof shapes
beyond the leaf, which must give equal bytes, and `caught` counts the
value control, which must give different bytes.  The counted shapes
cannot survive.  The control is the only item that can.

TRACE-DRIVER has no harness mutant, so the 2026-09-11 review round ran
two mutations by hand on a copy and rebuilt the driver for each one.

| change | gate | observed rejection |
| --- | --- | --- |
| drop the `has_error` test in the `WEXITED 0` arm of bin/trace.ml | TRACE-DRIVER | `TRACE-DRIVER FAIL TRACE-DRIVER wrong-fork: 0:` exit 1 |
| accept a readable but non-executable file named evm in the PATH lookup | TRACE-DRIVER | `TRACE-DRIVER FAIL TRACE-DRIVER non-executable-evm: 2: Fatal error: exception Unix.Unix_error(Unix.EACCES, "create_process", ...)` |

The restored copy prints `TRACE-DRIVER cases=20 explicit_prestate=true
literal_argv=true OK` and exits 0.

## 2026-09-11: M1 executor slice

`dev/diff-test.py` rejects 24 damaged captures, mismatched outcomes and
unsupported execution inputs.  Its final restored capture passes.
`dev/validation/2026-09-11-m1-executor/DIFF-EVIDENCE.json` records each
name and exact rejection, plus the live captures used by the checks.

| Names | Required witness |
| --- | --- |
| STATUS, RETURN, STORAGE | `DIFF_MISMATCH` for the changed field |
| NO-RESULT, NO-ALLOC | `DIFF_T8N` missing result or alloc |
| REJECTED | transaction rejected |
| NO-RECEIPT, DUP-RECEIPT | expected one receipt |
| RECEIPT-STATUS | receipt and trace disagree |
| RECEIPT-HASH, NO-TRACE | missing or unrelated transaction trace |
| RECEIPT-INDEX | wrong receipt index |
| BAD-STORAGE | `DIFF_STORAGE` invalid word |
| TRAILING-JSON, NO-STATE | `DIFF_RUN` missing state dump |
| DUP-JSON | duplicate key |
| EVM-FAULT, LIVE-FAULT | `DIFF_EXECUTION` EVM fault |
| EXCESS-GAS | gas exceeds execution allowance |
| DUP-ACCOUNT | `DIFF_PRESTATE` duplicate account |
| DUP-SLOT | duplicate slot |
| GASLIMIT, BASEFEE, BLOBBASEFEE | `DIFF_CONTEXT` unsupported observation |

The same leg has 26 public driver cases.  They include malformed calldata,
invalid source and prestate paths, the wrong fork, missing or non-executable
tools, process exit and signal failures, and malformed executor output.
Every failed command must leave stdout empty.  Eight calldata rows, an
explicit prestate and paths with spaces must succeed.  Literal argv and
the Cancun flag are read from the tool wrapper's captured arguments.

The live `GAS` case caught a context mismatch during development:
`evm run` returned `0xfffffe` while t8n returned `0xf423e` when the runner
requested one million execution gas.  The final adapter uses the genesis
allowance and adds intrinsic gas to the t8n transaction and block limit.
The `GASLIMIT` rejection records the resulting context restriction.
`BASEFEE` and `BLOBBASEFEE` read the same divided context: `evm run`
returned `0x3b9aca00` for a base fee probe while the t8n environment pins
`0x0`, so both opcodes are refused with the same diagnostic.

### Review round 2026-09-11 (M1 executor)

Three round-1 driver cases close three unwitnessed paths.  Each mutation
was applied to a copy, was built with 0 errors and 0 warnings, and the leg
failed.  The restored copy prints `DIFF-EXECUTOR live=20 driver=26
rejected=24 OK` and exits 0.

| Mutation | Leg case | Witness |
| --- | --- | --- |
| delete the unexpected-stderr guard of evm/diff.py | executor-stderr | `DIFF-EXECUTOR FAIL DIFF-DRIVER executor-stderr: 2: assay: diff: DIFF_RUN: missing state dump` |
| rename the `Missing_helper` text of bin/differential.ml | missing-helper | `DIFF-EXECUTOR FAIL DIFF-DRIVER missing-helper: 2: assay: diff: DIFF_HELPER: MUTANT` |
| report `Runner_exit` for the `WSIGNALED` arm of bin/differential.ml | runner-signal | `DIFF-EXECUTOR FAIL DIFF-DRIVER runner-signal: 2: assay: diff: DIFF_RUNNER: exit -11` |

The last witness also shows the reported defect: the mutant prints the
OCaml signal encoding `-11` for a `SIGTERM`.  The fixed reader prints
`DIFF_RUNNER: killed by SIGTERM` and keeps a separate `stopped by` wording
for `WSTOPPED`.

A fourth mutation checks the stage verdict of `dev/stage-a-gates.py`.  A
copy with one passing base leg and a failing `DIFF-EXECUTOR` leg prints
`M0-VALIDATION OK` with `STAGE-M1-EXECUTOR FAIL` and exit 1.  The control
copy with a passing executor leg prints both lines as `OK` with exit 0.

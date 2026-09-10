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

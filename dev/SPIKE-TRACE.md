# Spike (g), the 20-byte trace

Date: 2026-09-10.  Stage 0, brief section 3.7.  Gate S0-G9.  Decision S0-D5.

This spike proves that our own listing, `cast disassemble` and `evm run --json` give
the same program counter for every instruction of one hand-assembled contract.
No repository file for `reference/ref20.evm` is written here.  That file is Stage D
work.  The contract of this spike lives in the scratch directory
`/Users/oobi/Documents/assay-m0/spikes/trace/`, which never enters the repository.

## 1 Tools

```
$ /opt/homebrew/bin/evm --version
evm version 1.14.12-stable
$ /Users/oobi/.foundry/bin/cast --version
cast 0.3.0 (5a8bd89 2024-12-20T08:45:53.135759000Z)
```

Load at the run: ` 1:07  27 users, load averages: 53.62 50.99 42.42`.

## 2 The scratch contract (S0-D5)

The contract stores 42 in storage slot 0, reads the value back, and returns it as
32 bytes.  It uses PUSH0, so an incorrect prestate rejects it;  it uses a JUMP over
four guard bytes, so the pc columns are not a simple one byte per instruction walk.

Code, 20 bytes:

```
602a5f55600b56fefefefe5b5f545f5260205ff3
```

Byte count: 40 hex characters, which is 20 bytes.  The command that prints the count
is `/usr/bin/wc -c < /Users/oobi/Documents/assay-m0/spikes/trace/ref20.hex`, which
prints `40`.  The sha256 of the hex file is
`7b42423fd6def2a72b899571715d12ca4686e4e3532313fa3a2a7d3bedbc0818`.

Our listing, one comment per instruction.  The scratch copy is
`/Users/oobi/Documents/assay-m0/spikes/trace/ref20.listing.txt`.

```
; Column form: pc(dec) pc(hex) bytes mnemonic ; comment.
0   0x00  60 2a  PUSH1 0x2a    ; push the value 42
2   0x02  5f     PUSH0         ; push slot 0, the Cancun opcode this prestate must enable
3   0x03  55     SSTORE        ; storage[0] = 42
4   0x04  60 0b  PUSH1 0x0b    ; push the jump target, pc 11
6   0x06  56     JUMP          ; jump to the JUMPDEST at pc 11
7   0x07  fe     INVALID       ; guard byte, never reached
8   0x08  fe     INVALID       ; guard byte, never reached
9   0x09  fe     INVALID       ; guard byte, never reached
10  0x0a  fe     INVALID       ; guard byte, never reached
11  0x0b  5b     JUMPDEST      ; the only valid jump target
12  0x0c  5f     PUSH0         ; push slot 0
13  0x0d  54     SLOAD         ; read storage[0], which is 42
14  0x0e  5f     PUSH0         ; push memory offset 0
15  0x0f  52     MSTORE        ; memory[0..32] = 42
16  0x10  60 20  PUSH1 0x20    ; push the return length, 32 bytes
18  0x12  5f     PUSH0         ; push the return offset, 0
19  0x13  f3     RETURN        ; return the 32 bytes that hold 42
```

Seventeen instructions over 20 bytes.  The three multi-byte instructions are the two
PUSH1 pairs at pc 0, pc 4 and pc 16.

## 3 The scratch Cancun prestate

`/Users/oobi/Documents/assay-m0/spikes/trace/cancun.json` is a genesis JSON.  The field
that sets the fork is `config.cancunTime`, set to 0, with `config.shanghaiTime` 0 beside
it.  `number` must be `0x0`;  a genesis with `number` over 0 makes `evm run` abort with
`panic: can't commit genesis block with number > 0`, which this spike met once and
repaired in the scratch file before the recorded run.  This shape is the same shape that
spike (f) uses, and it is recorded there as decision S0-D4.

## 4 Transcript 1, `evm run --json --dump`

```
$ /opt/homebrew/bin/evm run --json --dump \
    --prestate /Users/oobi/Documents/assay-m0/spikes/trace/cancun.json \
    --code 602a5f55600b56fefefefe5b5f545f5260205ff3
{"pc":0,"op":96,"gas":"0x1c9c380","gasCost":"0x3","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH1"}
{"pc":2,"op":95,"gas":"0x1c9c37d","gasCost":"0x2","memSize":0,"stack":["0x2a"],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":3,"op":85,"gas":"0x1c9c37b","gasCost":"0x5654","memSize":0,"stack":["0x2a","0x0"],"depth":1,"refund":0,"opName":"SSTORE"}
{"pc":4,"op":96,"gas":"0x1c96d27","gasCost":"0x3","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH1"}
{"pc":6,"op":86,"gas":"0x1c96d24","gasCost":"0x8","memSize":0,"stack":["0xb"],"depth":1,"refund":0,"opName":"JUMP"}
{"pc":11,"op":91,"gas":"0x1c96d1c","gasCost":"0x1","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"JUMPDEST"}
{"pc":12,"op":95,"gas":"0x1c96d1b","gasCost":"0x2","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":13,"op":84,"gas":"0x1c96d19","gasCost":"0x64","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"SLOAD"}
{"pc":14,"op":95,"gas":"0x1c96cb5","gasCost":"0x2","memSize":0,"stack":["0x2a"],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":15,"op":82,"gas":"0x1c96cb3","gasCost":"0x6","memSize":0,"stack":["0x2a","0x0"],"depth":1,"refund":0,"opName":"MSTORE"}
{"pc":16,"op":96,"gas":"0x1c96cad","gasCost":"0x3","memSize":32,"stack":[],"depth":1,"refund":0,"opName":"PUSH1"}
{"pc":18,"op":95,"gas":"0x1c96caa","gasCost":"0x2","memSize":32,"stack":["0x20"],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":19,"op":243,"gas":"0x1c96ca8","gasCost":"0x0","memSize":32,"stack":["0x20","0x0"],"depth":1,"refund":0,"opName":"RETURN"}
{"output":"000000000000000000000000000000000000000000000000000000000000002a","gasUsed":"0x56d8"}
```

The `--dump` block of the same run:

```
{
    "root": "0abe467c85a5dbac429cd5d2becbe405d4d77533412a5bebeee8391de2da5523",
    "accounts": {
        "0x0000000000000000000000007265636569766572": {
            "balance": "0",
            "nonce": 0,
            "root": "0x81d1fa699f807735499cf6f7df860797cf66f6a66b565cfcda3fae3521eb6861",
            "codeHash": "0x755b9e03b3191b071ebb78b7ebae672c2db6c3b52febaf13955e337d95b5f2ef",
            "code": "0x602a5f55600b56fefefefe5b5f545f5260205ff3",
            "storage": {
                "0x0000000000000000000000000000000000000000000000000000000000000000": "2a"
            },
            "address": "0x0000000000000000000000007265636569766572",
            "key": "0x30d7a0694cb29af31b982480e11d7ebb003a3fca4026939149071f014689b142"
        }
    }
}
```

The return value is `0x...2a`, which is 42, and the dumped storage slot 0 holds `2a`.
The two `INFO` lines of the trie dump go to stderr and are not part of the trace.

## 5 Transcript 2, `cast disassemble`

```
$ /Users/oobi/.foundry/bin/cast disassemble 0x602a5f55600b56fefefefe5b5f545f5260205ff3
00000000: PUSH1 0x2a
00000002: PUSH0
00000003: SSTORE
00000004: PUSH1 0x0b
00000006: JUMP
00000007: INVALID
00000008: INVALID
00000009: INVALID
0000000a: INVALID
0000000b: JUMPDEST
0000000c: PUSH0
0000000d: SLOAD
0000000e: PUSH0
0000000f: MSTORE
00000010: PUSH1 0x20
00000012: PUSH0
00000013: RETURN
```

## 6 The three pc columns

The pc column format is the decimal offset of the first byte of the instruction.  `cast`
prints it as eight hexadecimal digits and `evm --json` prints it as a JSON number, so the
table gives the decimal value of each.  `evm --json` traces the executed path only, so the
four guard bytes at pc 7 to pc 10 carry `not executed` in the evm column, which is agreement
about a byte that no run reaches and not a disagreement about an offset.

| ours (dec) | cast (raw) | cast (dec) | evm --json (raw) | evm (dec) | mnemonic | agree |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | 00000000 | 0 | "pc":0 | 0 | PUSH1 0x2a | yes |
| 2 | 00000002 | 2 | "pc":2 | 2 | PUSH0 | yes |
| 3 | 00000003 | 3 | "pc":3 | 3 | SSTORE | yes |
| 4 | 00000004 | 4 | "pc":4 | 4 | PUSH1 0x0b | yes |
| 6 | 00000006 | 6 | "pc":6 | 6 | JUMP | yes |
| 7 | 00000007 | 7 | not executed | not executed | INVALID | yes |
| 8 | 00000008 | 8 | not executed | not executed | INVALID | yes |
| 9 | 00000009 | 9 | not executed | not executed | INVALID | yes |
| 10 | 0000000a | 10 | not executed | not executed | INVALID | yes |
| 11 | 0000000b | 11 | "pc":11 | 11 | JUMPDEST | yes |
| 12 | 0000000c | 12 | "pc":12 | 12 | PUSH0 | yes |
| 13 | 0000000d | 13 | "pc":13 | 13 | SLOAD | yes |
| 14 | 0000000e | 14 | "pc":14 | 14 | PUSH0 | yes |
| 15 | 0000000f | 15 | "pc":15 | 15 | MSTORE | yes |
| 16 | 00000010 | 16 | "pc":16 | 16 | PUSH1 0x20 | yes |
| 18 | 00000012 | 18 | "pc":18 | 18 | PUSH0 | yes |
| 19 | 00000013 | 19 | "pc":19 | 19 | RETURN | yes |

The table is also checked mechanically.
`/bin/zsh /Users/oobi/Documents/assay-m0/spikes/trace/verify-g9.sh` reads the three
columns out of the three files, converts the `cast` column from hexadecimal to decimal,
and diffs them.  It prints:

```
TRACE bytes=20 rows=17 cast_rows=17 evm_rows=13 diff_ours_cast=0 diff_ours_evm=0
S0-G9 PASS
```

`rows=17` is our listing, `cast_rows=17` is the whole contract, and `evm_rows=13` is the
executed path, which is 17 less the four guard bytes.  Both diffs are empty.

Seventeen rows, 17 of 17 agree.  The last instruction starts at offset 19 and is one byte
long, so the contract is 20 bytes, which matches the printed byte count of section 2.
Both other tools also print the mnemonic that our listing gives, on every row.

## 7 Negative control

The same code under a prestate with no `cancunTime`
(`/Users/oobi/Documents/assay-m0/spikes/trace/nocancun.json`) stops at the first PUSH0:

```
{"pc":2,"op":95,"gas":"0x1c9c37d","gasCost":"0x0","memSize":0,"stack":["0x2a"],"depth":1,"refund":0,"opName":"PUSH0","error":"invalid opcode: PUSH0"}
{"output":"","gasUsed":"0x1c9c380","error":"invalid opcode: PUSH0"}
```

The control proves that the Cancun prestate of section 3, and not a default, is what lets
this contract run.  With `--json`, geth 1.14.12 reports the rejection in the `error` field
of the trace and of the summary, and prints nothing on stderr.  The form
` error: invalid opcode: PUSH0` that gate S0-G8 names is the plain, non-JSON form of the
same rejection, and spike (f) records that form.

## 8 What later stages do with this file

M0-TRACE at Stage D and at Stage E compares the same three columns, ours, `cast` and
`evm --json`, over the Stage D `reference/ref20.evm` and over every emitted fixture.  Gate
DISASM-3WAY adds a fourth reader, `evm disasm`, on the same bytes, so the comparison
becomes ours against three outside disassemblers.  A disagreement is a finding that prints
both lines.  It is never repaired by an edit of one column.

## 9 Reruns

```
/bin/zsh /Users/oobi/Documents/assay-m0/spikes/trace/run-trace.sh
```

The script writes only under its own scratch directory.  It starts no daemon, builds
nothing and installs nothing.

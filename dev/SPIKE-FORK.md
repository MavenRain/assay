# SPIKE-FORK: the Cancun prestate and the fork answer set

Spike (f) of assay M0 Stage 0.  Date: 2026-09-10.  kanon pin: 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf.

Executor: geth `evm`, one run, all rows from the same binary and the same prestate file.

```
$ /opt/homebrew/bin/evm --version
evm version 1.14.12-stable
```

## 1 The scratch prestate (S0-D4)

The prestate is scratch and stays out of this repository at Stage 0.  Stage D owns the repository fixture evm/fixtures/cancun.json.  Stage 0 proves the shape only.

Path: /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json.  sha256 e5abe35480f009fca07f79f15d3dc8c32fba412d93ec81fb5f793775f8e42e5f.

Shape: a geth genesis object with `config`, `alloc` and the block header fields.  The fork is set by the timestamp field `cancunTime` inside `config`, with `shanghaiTime` beside it, and by the block-numbered fields up to `londonBlock` plus `terminalTotalDifficulty` and `mergeNetsplitBlock`.  The blob fields `excessBlobGas` and `blobGasUsed` are present because Cancun reads them.

```
{
  "config": {
    "chainId": 1,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    "londonBlock": 0,
    "mergeNetsplitBlock": 0,
    "terminalTotalDifficulty": 0,
    "cancunTime": 0,
    "shanghaiTime": 0
  },
  "alloc": {},
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x0",
  "gasLimit": "0x1000000",
  "nonce": "0x0000000000000000",
  "timestamp": "0x0",
  "number": "0x0",
  "excessBlobGas": "0x0",
  "blobGasUsed": "0x0"
}
```

The invocation form is `evm run --prestate <file> --json --code <hex>`.  The same file is the input of `evm t8n`, which reads the genesis `config` block in this shape.

geth 1.14.12 refuses `cancunTime` without `shanghaiTime`.  The pair is therefore one unit, the Cancun enablement, and a copy that turns Cancun off deletes both keys.  Evidence, from the copy cancun-no-shanghai.json that holds `cancunTime` and no `shanghaiTime`:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun-no-shanghai.json --json --code 5f00
panic: unsupported fork ordering: shanghaiTime not enabled, but cancunTime enabled at timestamp 0
```

## 2 The five opcode rows

Each row runs under the prestate of section 1.  The trace form is `--json`, one line per step.

### PUSH0 (0x5f), EIP-3855, answers

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json --json --code 5f00
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x2","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":1,"op":0,"gas":"0xfffffe","gasCost":"0x0","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"STOP"}
{"output":"","gasUsed":"0x2"}
```

### TLOAD (0x5c), EIP-1153, answers

Code 5f5c00 is PUSH0, TLOAD, STOP.  The key is 0 and the transient slot is empty, so TLOAD returns 0 at gas cost 0x64.

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json --json --code 5f5c00
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x2","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":1,"op":92,"gas":"0xfffffe","gasCost":"0x64","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"TLOAD"}
{"pc":2,"op":0,"gas":"0xffff9a","gasCost":"0x0","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"STOP"}
{"output":"","gasUsed":"0x66"}
```

### TSTORE (0x5d), EIP-1153, answers

Code 5f5f5d00 is PUSH0, PUSH0, TSTORE, STOP.  TSTORE writes value 0 to key 0 at gas cost 0x64 and leaves the stack empty.

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json --json --code 5f5f5d00
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x2","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":1,"op":95,"gas":"0xfffffe","gasCost":"0x2","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":2,"op":93,"gas":"0xfffffc","gasCost":"0x64","memSize":0,"stack":["0x0","0x0"],"depth":1,"refund":0,"opName":"TSTORE"}
{"pc":3,"op":0,"gas":"0xffff98","gasCost":"0x0","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"STOP"}
{"output":"","gasUsed":"0x68"}
```

### MCOPY (0x5e), EIP-5656, answers

Code 5f5f5f5e00 is PUSH0, PUSH0, PUSH0, MCOPY, STOP.  The length is 0, so the copy costs the base 0x3 and the memory does not grow.

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json --json --code 5f5f5f5e00
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x2","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":1,"op":95,"gas":"0xfffffe","gasCost":"0x2","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":2,"op":95,"gas":"0xfffffc","gasCost":"0x2","memSize":0,"stack":["0x0","0x0"],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":3,"op":94,"gas":"0xfffffa","gasCost":"0x3","memSize":0,"stack":["0x0","0x0","0x0"],"depth":1,"refund":0,"opName":"MCOPY"}
{"pc":4,"op":0,"gas":"0xfffff7","gasCost":"0x0","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"STOP"}
{"output":"","gasUsed":"0x9"}
```

### CLZ (0x1e), EIP-7939, absent on this binary

CLZ is a Fusaka opcode.  geth 1.14.12 does not carry it.  The invalid opcode line below is the expected answer of this spike and is not a failure.  A geth newer than 1.14.12 is the Stage 0a install item for the CLZ and Fusaka rows at M4, and no agent installs it.

Code 5f1e00 is PUSH0, CLZ, STOP.

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json --json --code 5f1e00
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x2","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":1,"op":30,"gas":"0xfffffe","gasCost":"0x0","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"opcode 0x1e not defined"}
{"pc":1,"op":30,"gas":"0xfffffe","gasCost":"0x0","memSize":0,"stack":["0x0"],"depth":1,"refund":0,"opName":"opcode 0x1e not defined","error":"invalid opcode: opcode 0x1e not defined"}
{"output":"","gasUsed":"0x1000000","error":"invalid opcode: opcode 0x1e not defined"}
```

The same row without `--json` prints the gate line verbatim.  The line starts with one space.

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/cancun.json --code 5f1e00

 error: invalid opcode: opcode 0x1e not defined
```

## 3 The negative control

The control proves that the answers of section 2 come from the prestate and not from a default.  The copy is /Users/oobi/Documents/assay-m0/spikes/fork/no-cancun-no-shanghai.json, the prestate of section 1 with the Cancun enablement deleted, made by `jq 'del(.config.cancunTime) | del(.config.shanghaiTime)'`.  sha256 b11be9ba8179ee474fffb3a5241a618d3d15636bab54239227566b3f928a9ed6.  The PUSH0 command of section 2 runs against that copy:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/no-cancun-no-shanghai.json --code 5f00

 error: invalid opcode: PUSH0
```

The `--json` form of the same run:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/no-cancun-no-shanghai.json --json --code 5f00
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x0","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0"}
{"pc":0,"op":95,"gas":"0x1000000","gasCost":"0x0","memSize":0,"stack":[],"depth":1,"refund":0,"opName":"PUSH0","error":"invalid opcode: PUSH0"}
{"output":"","gasUsed":"0x1000000","error":"invalid opcode: PUSH0"}
```

That command is the mutant S0-M2.  The judge runs it on its own copy under /Users/oobi/Documents/assay-m0/mutants/ and the mutant is killed by the line ` error: invalid opcode: PUSH0`.

### 3.1 Finding F-2, a departure from the literal recipe of the brief

The brief section 5 writes S0-M2 as "delete `cancunTime` from the copy".  On geth 1.14.12 that recipe
does not kill the mutant, because PUSH0 is a Shanghai opcode (EIP-3855) and the copy keeps
`shanghaiTime`.  The recipe that this stage ran deletes both `cancunTime` and `shanghaiTime`, which is
the intent of the check: a prestate that does not enable the opcode set under test.  The departure is
recorded as finding F-2 in dev/M0-BUILD-LOG.md and both recipes are run and recorded in
dev/MUTATION-LOG.md, the literal one as a survivor with its evidence and the run one as the kill.  The
control rows below are the proof of the departure and are not decoration.

Two more control rows record why the deletion takes both keys on geth 1.14.12.  PUSH0 is a Shanghai opcode (EIP-3855), so a copy that deletes `cancunTime` alone keeps `shanghaiTime` and PUSH0 still answers:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/no-cancun.json --code 5f00

```

The same copy, with the Cancun opcode TLOAD, does print an invalid opcode line, which is the narrow proof that `cancunTime` alone carries the Cancun opcode set:

```
$ /opt/homebrew/bin/evm run --prestate /Users/oobi/Documents/assay-m0/spikes/fork/no-cancun.json --code 5f5c00

 error: invalid opcode: TLOAD
```

## 4 The rule for every gate (R-Q4a)

Every gate of M0-PLAN.md section 8 runs under this explicit prestate, or under `evm t8n --state.fork Cancun` on the same prestate at M1.  No gate rides the `evm run` default, because the default fork of the binary can move with the binary and a moved default is a silent change of the answer set.  Stage D writes the repository fixture evm/fixtures/cancun.json in the shape of section 1, and Stage D also reruns the control of section 3 as its own negative check.

## 5 Answer set at the pin

| opcode | hex | EIP | fork | geth 1.14.12 answer |
| --- | --- | --- | --- | --- |
| PUSH0 | 0x5f | 3855 | Shanghai | executes, gasCost 0x2 |
| TLOAD | 0x5c | 1153 | Cancun | executes, gasCost 0x64 |
| TSTORE | 0x5d | 1153 | Cancun | executes, gasCost 0x64 |
| MCOPY | 0x5e | 5656 | Cancun | executes, gasCost 0x3 at length 0 |
| CLZ | 0x1e | 7939 | Fusaka | ` error: invalid opcode: opcode 0x1e not defined`, expected |

The runner that prints every row of this file in one run is /Users/oobi/Documents/assay-m0/spikes/fork/run-fork.sh, which is scratch and stays out of this repository.

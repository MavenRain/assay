# SPIKE-KECCAK, the keccak oracle

Date: 2026-09-10.  Spike (e) of M0 Stage 0.  kanon pin 2c2e6e6831a0b2cf3107fa4aad392606109a2bcf.

This file is the vector table that the Stage B builder reads.  Stage B writes keccak/keccak.ml, the in-tree keccak-f[1600] and keccak256, and gate KECCAK-VEC compares the in-tree digest against every recorded digest below.

## 1 Oracle

The oracle is `cast` from foundry.  No agent installs it.

```
$ command -v cast
/Users/oobi/.foundry/bin/cast
$ /Users/oobi/.foundry/bin/cast --version
cast 0.3.0 (5a8bd89 2024-12-20T08:45:53.135759000Z)
```

`cast` is PRESENT, so no `SKIP cast absent` row is recorded.

Input rule of the oracle: an argument that does not start with `0x` is hashed as its UTF-8 bytes;  an argument that starts with `0x` is hashed as the decoded hex bytes.  The empty string and `0x` are the same input, which is the empty-input vector of section 3.

## 2 The selector of transfer(address,uint256)

```
$ /Users/oobi/.foundry/bin/cast sig 'transfer(address,uint256)'
0xa9059cbb
```

```
$ /Users/oobi/.foundry/bin/cast keccak 'transfer(address,uint256)'
0xa9059cbb2ab09eb219583f4a59a5d0623ade346d962bcd4e46b11da047c9049b
```

The first four bytes of the digest are `a9 05 9c bb`, which is the selector printed above.  A function selector is the first four bytes of the keccak256 of the canonical signature string, and nothing else.  Stage B builds every selector and every error selector this way, over the name, never from a literal.

## 3 The empty-input vector

```
$ /Users/oobi/.foundry/bin/cast keccak ''
0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470
```

```
$ /Users/oobi/.foundry/bin/cast keccak 0x
0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470
```

The empty input exercises the padding path alone, with no absorbed message byte, so it is the first vector that fails when the padding byte is wrong.

## 4 Two more vectors

```
$ /Users/oobi/.foundry/bin/cast keccak 'abc'
0x4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45
```

```
$ /Users/oobi/.foundry/bin/cast keccak 'Transfer(address,address,uint256)'
0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
```

The `abc` vector is the classic three-byte message, and it is the vector that separates keccak256 from SHA3-256 in section 6.  The `Transfer` vector is the ERC-20 event topic 0, so it exercises the same code path that the ABI printer needs for log topics.

Two selector rows come with the second signature vector, as a second check of the four-byte rule:

```
$ /Users/oobi/.foundry/bin/cast sig 'approve(address,uint256)'
0x095ea7b3
$ /Users/oobi/.foundry/bin/cast keccak 'approve(address,uint256)'
0x095ea7b334ae44009aa867bfb386f5c3b4b443ac6f0ee573fa91c4608fbadfba
```

## 5 The vector table (KECCAK-VEC)

Each row is one input and its keccak256 digest.  `enc` is `utf8` when the input is the literal text between the quotes, and `hex` when the input is the decoded bytes.  Stage B reruns every command in the last column and compares it against `digest`.

| id | input | enc | digest |
| --- | --- | --- | --- |
| K1 | `transfer(address,uint256)` | utf8 | 0xa9059cbb2ab09eb219583f4a59a5d0623ade346d962bcd4e46b11da047c9049b |
| K2 | `` (empty) | utf8 | 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 |
| K3 | `0x` | hex | 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 |
| K4 | `abc` | utf8 | 0x4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45 |
| K5 | `Transfer(address,address,uint256)` | utf8 | 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef |
| K6 | `approve(address,uint256)` | utf8 | 0x095ea7b334ae44009aa867bfb386f5c3b4b443ac6f0ee573fa91c4608fbadfba |

Selector rows, each the first four bytes of the digest of the same row above:

| id | signature | selector | digest row |
| --- | --- | --- | --- |
| S1 | `transfer(address,uint256)` | 0xa9059cbb | K1 |
| S2 | `approve(address,uint256)` | 0x095ea7b3 | K6 |

The rerun command of row Kn is `/Users/oobi/.foundry/bin/cast keccak '<input>'`, and the rerun command of row Sn is `/Users/oobi/.foundry/bin/cast sig '<signature>'`.

## 6 keccak256 is not SHA3-256

keccak256 is the original Keccak submission with a rate of 1088 bits and a capacity of 512 bits, and SHA3-256 is the FIPS 202 standard over the same keccak-f[1600] permutation and the same rate and capacity.  The two differ in one byte: the multi-rate padding of keccak256 appends the byte 0x01 before the zero fill and the final 0x80, and SHA3-256 appends the domain separated byte 0x06.  Every other step, the theta, rho, pi, chi and iota rounds of keccak-f[1600] and the 24-round count, is identical.  A keccak that uses 0x06 passes no vector of section 5, and the difference is visible on the `abc` vector:

```
$ node -e "const c=require('crypto');console.log('0x'+c.createHash('sha3-256').update('abc').digest('hex'))"
0x3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532
$ /Users/oobi/.foundry/bin/cast keccak 'abc'
0x4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45
```

and on the empty input:

```
$ node -e "const c=require('crypto');console.log('0x'+c.createHash('sha3-256').update('').digest('hex'))"
0xa7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a
$ /Users/oobi/.foundry/bin/cast keccak ''
0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470
```

The EVM uses keccak256, so Stage B keccak/keccak.ml writes 0x01 and gate KECCAK-VEC tests it against the recorded vectors of section 5.  The Stage B mutant flips the padding byte from 0x01 to 0x06 and KECCAK-VEC must fail on every row, which is the non-vacuity proof of the gate.  The keccak budget is 250 trusted lines (R-M0-3).

## 7 Rerun

The gate S0-G7 rerun is one command per row of section 5, compared against the digest in the same row.  A rerun that prints a different digest is a failure of this file, not of the oracle.

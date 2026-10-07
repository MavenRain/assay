# M2 closure battery record

This directory records the group 9 closure battery of milestone M2.

The battery command is `make gates`. It ran from the repository root under a
memory guard with a limit of 4096 MB. The battery has 110 legs.

Closure run: `battery-3`. Launch: 2026-10-06T19:38:44Z. HEAD: `092fa7ab51778ff703c6adea74a027e8a37b1a78`. Staged tree: `553a927a7c06876279fdc36f7679898a6fc2bb1e`.
Result: 105 of 110 legs passed in the closure run. 5 legs failed in the closure run and passed in the later run `run-6b`: `INFERRED-BINDINGS`, `INFERRED-GUARD-BINDINGS`, `EVM-CONTEXT`, `SURFACE-CONTEXT`, `WORD-EQUALITY`.
Closed: no. A passing cumulative battery on the final sources is still required.
The focused reruns do not change battery 3's exit status or identify its inputs
as the later staged sources.

## Files

- `battery.log`: the closure run log. One row for each leg, with the output of each failed leg.
- `battery.json`: the memory guard result of the closure run.
- `legs.tar.gz`: the 110 leg logs of the closure run.
- `attempts.json`: one row for each leg row of each run, in run order.
- `summary.json`: the counts of each run and the closure result.
- `history/`: the logs of the other runs, in run order. Failed runs are kept.
- `LAUNCH-SOURCES.sha256`: the SHA-256 of each blob outside this directory in the recorded launch tree `553a927a7c06876279fdc36f7679898a6fc2bb1e`.
- `SOURCES.sha256`: the SHA-256 of each staged blob outside this directory after review corrections. This later inventory is not the launch inventory and does not imply that the cumulative battery passed on these sources.

## Run history

The closure rules record failures as well as successful reruns. Each run is listed.

| Run | Leg rows | PASS | FAIL | LEG-TIMEOUT |
| --- | ---: | ---: | ---: | ---: |
| `battery-1` | 76 | 63 | 13 | 0 |
| `battery-1b` | 37 | 26 | 11 | 1 |
| `run-2a` | 6 | 6 | 0 | 0 |
| `run-2b` | 13 | 13 | 0 | 0 |
| `run-3a` | 6 | 6 | 0 | 0 |
| `run-3b` | 4 | 2 | 2 | 0 |
| `run-3c` | 1 | 1 | 0 | 0 |
| `run-4a` | 4 | 1 | 3 | 0 |
| `run-4b` | 14 | 12 | 2 | 0 |
| `run-4c` | 3 | 2 | 1 | 0 |
| `run-5a-bend2ratio` | 0 | 0 | 0 | 0 |
| `run-5a-bend2test` | 0 | 0 | 0 | 0 |
| `run-5a` | 6 | 3 | 3 | 0 |
| `run-5d` | 3 | 1 | 2 | 1 |
| `run-5e` | 4 | 2 | 2 | 1 |
| `run-5f` | 2 | 1 | 1 | 0 |
| `run-5g` | 1 | 1 | 0 | 0 |
| `run-5h` | 1 | 1 | 0 | 0 |
| `battery-2` | 110 | 106 | 4 | 3 |
| `run-6a` | 3 | 3 | 0 | 0 |
| `run-close-light` | 8 | 8 | 0 | 0 |
| `battery-3` | 110 | 105 | 5 | 3 |
| `run-6b` | 5 | 5 | 0 | 0 |

## Check the sources

Check the later staged review inventory from the repository root:

```sh
shasum -a 256 -c dev/validation/2026-10-06-m2-close/SOURCES.sha256
```

The launch inventory must instead be compared with blobs read from the recorded
launch tree, not with the current working tree. For example,
`git show 553a927a7c06876279fdc36f7679898a6fc2bb1e:dev/m2-reconcile-test.py | shasum -a 256`
matches the `dev/m2-reconcile-test.py` entry in `LAUNCH-SOURCES.sha256`.

# M2 reference gate

The first M2 slice starts at `8f61dd5`. It freezes the
[ERC-20 reference](../reference/erc20/README.md) before extending source
emission to mappings, events and richer ABI types. The reference includes
nine methods, two events, mapping and nested-mapping storage, dynamic string
returns and deployment initialization.

The explicit `python3 -P dev/stage-a-gates.py --m2-reference` runs the
77 M1 closure checks followed by ERC20-REFERENCE, for 78 legs. Existing
explicit modes retain their commands, deadlines, success markers and
failure classification. `--m1-close` remains the 77-leg M1 battery. The
reference leg has a 300-second deadline and requires the exact marker:

```text
ERC20-REFERENCE cases=85 creates=4 mutants=11 covered=431 scope=reference OK
```

The current default extends this schedule with [ABI-SCHEMA](M2-ABI-SCHEMA.md),
[ABI-CODEC](M2-ABI-CODEC.md) and [LAYOUT-PACKED](M2-PACKING.md).

The reference has 798 runtime bytes and a 107-byte constructor prefix.
All 431 runtime instructions and all constructor instructions are covered.
Every runtime case checks status, return data and full storage through both
geth entry points. It also checks t8n receipt logs and reconstructed logs
from both traces. Creation is checked through `evm run` only.

| Mutant | Required witness |
| --- | --- |
| Ignore CALLVALUE | `value-transfer` |
| Wrong balances base slot | `balance-alice` |
| Wrong allowances base slot | `approve-success` |
| Invert allowance bound | `transferFrom-allowance-short` |
| Add instead of spending allowance | `transferFrom-success` |
| Invert balance bound | `transfer-insufficient` |
| Invert recipient overflow check | `transfer-recipient-overflow` |
| Alter Transfer signature topic | `transfer-success` |
| Omit event data | `transfer-success` |
| Wrong dynamic return offset | `read-name` |
| Accept an extra address bit | `balanceOf-dirty-address-0` |

No compiler, kernel or trusted-code limit changes. The existing Bend 2
performance gate and source pins remain binding. M2 still requires compiler
support, packing, dynamic ABI input handling and its Lean negative mutants.
The reference metadata is manually authored golden data. Passing this gate
does not establish the future compiler's M2-ABI equality or proof obligations.

### Review round 2026-09-22 (M2 reference: the ERC-20 reference gate)

C-1 (medium): the gates paragraph of `README.md` (rows 343-345) still
said that `dev/gates.sh` selects `--m1-close` and runs 75 legs, while
this slice makes it select `--m2-reference`; now the paragraph reads
that `dev/gates.sh` selects `--m2-reference`, the 75 `--m1-close` legs
then ERC20-REFERENCE, for 76 legs.

A-1 (low): `reference/erc20/MANIFEST.json` listed 13 mutation sites,
but `dev/erc20-test.py` applied only 11 of them (`symbol-offset` and
`approval-data-size` had no mutant choice), so the manifest and the
marker row `mutants=11` disagreed; now the manifest holds the 11 applied
sites and the harness requires the manifest's site set to equal the
applied choices (`ERC20-SITES`), so a stale manifest fails the leg.

A-2 (low): `creation()` in `dev/erc20-test.py` returned the literal 4,
so `creates=4` in the marker row was not measured; now the function
counts each creation in the value loop, requires the count to be 4
(`ERC20-CREATE count`) and returns it, so a shortened owner list fails
the leg.

Ladder of record: the fixed tree passed 76 of 76 legs with the rows
`ERC20-REFERENCE cases=85 creates=4 mutants=11 covered=431 scope=reference OK`,
`BEND2-RATIO cases=6 rounds=5 source-pins=OK subtraction=none OK` and
`BEND2-RATIO-TEST controls=3 refused=37 mutants=6 OK`; a second full
run of the same tree repeated the result. `dev/DENOMINATORS.sha256` and
the record's `SOURCES.json` and `FILES.sha256` were re-frozen for the
two changed files; the record's leg logs are unchanged.

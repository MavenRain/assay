# M2 typed ABI metadata

The second M2 slice starts at `6cb76ea`. `Assay_abi.Abi.Schema` describes
the metadata types needed by the frozen ERC-20 reference: `uint8`,
`uint256`, `address`, `bool` and `string`. Functions have typed inputs and
zero or more typed outputs. Declarations also cover constructors, custom
errors, indexed or unindexed event fields, anonymous events and fallbacks.
Constructor and fallback mutability admit only payable or nonpayable.

The schema derives canonical signatures from the same parameter types
used by its JSON printer. Parameter names, outputs, mutability and event
indexing do not enter a signature. This follows the
[Solidity ABI specification](https://docs.soliditylang.org/en/latest/abi-spec.html#json).
The existing M1 entry and custom-error API converts Word arguments to
`uint256` and uses this printer, preserving its exact JSON bytes and
declaration order.

This is a metadata representation and serializer. The test adapter
constructs the ERC-20 declarations directly; the source compiler still
accepts the existing Word ABI. The schema does not validate declaration
names, duplicate selectors or event topic limits. Source typing and
runtime validation must enforce those constraints when using it.
Source integration of calldata and return encoding, mapping lowering,
event emission, packing, other ABI types and the M2 Lean negative mutants
remain pending. Matching
this golden file alone does not close M2-ABI.

## Validation

`python3 -P dev/abi-schema-test.py` builds the adapter and compares its
12 declarations with `reference/erc20/abi.json` under `jq -S -c`.
It checks nine selectors and two event topics against the pinned reference
manifest. Seven additional declarations exercise payable constructors,
empty and multiple outputs, typed custom errors, anonymous events,
fallback mutability and JSON escaping. Six legacy function, error and
fallback rows, plus the implicit constructor, check exact M1 bytes, with
separate empty-ABI and signature checks.

Eight compiling semantic mutants must fail at a named witness: widened
uint8, address or boolean types; string changed to bytes; inverted indexed
or anonymous flags; dropped outputs; and return types added to selectors.
Compiler errors never count as mutation kills.

The explicit `--m2-abi-schema` gate mode appends
ABI-SCHEMA to the existing 76-leg M2 reference schedule, for 77 legs.
The default additionally runs [ABI-CODEC](M2-ABI-CODEC.md). Earlier explicit
modes keep their commands, deadlines, markers and failure
classification. The new leg has a 300-second deadline and requires:

```text
ABI-SCHEMA functions=9 events=2 edges=7 legacy=6 mutants=8 scope=metadata OK
```

The ABI printer stays within its existing 400-line trusted-code limit.
The compiler change required fresh performance measurements and source pins.
At this slice the six-program Assay/Bend 2 ratio measured 0.070826341, below
the unchanged 1.0 bound; the codec slice re-measured it to 0.073514764 (see
[M2-ABI-CODEC.md](M2-ABI-CODEC.md)). The frozen reference, kernel, workloads
and measurement methods are unchanged. Evidence is retained in
[`validation/2026-09-22-m2-abi-schema`](validation/2026-09-22-m2-abi-schema/README.md).

### Review round 2026-09-22 (M2 ABI schema: typed ABI metadata)

B-1 medium README.md:383: predecessor ratio 0.072614202 replaced by 0.070826341.
D-1 medium dev/DENOMINATORS.sha256:138: test/dune row added, REC/SOURCES.json lists test/dune.
C-2 medium dev/M1-BEND2.md:94: M1-BEND2 and M1-CLOSE say 77 checks, M2-REFERENCE marker split.
C-4 medium dev/M1-BEND2.md:80: rows 79-81 now say FILES.sha256 seals the retained record copy.
B-3 low dev/abi-schema-test.py:120: marker counts derived from the checks that ran.
B-2 low REC/README.md:14: gate-compatibility.py declared a transcript of the isolated clone run.
D-4 low REC/README.md:20: both tarballs described by their real contents.
Refuted: none.
Final ladder: 77 PASS, 0 FAIL, EXIT 0, LOAD-AT-RUN 9 15:17:35 load5=12, VERDICT GREEN.
Record refresh: DENOMINATORS.sha256 150 rows, SOURCES.json 159 inputs, re-sealed, changed=0.
Review pass 1 (2026-09-22) fixed 7 finding(s): B-1, D-1, C-2, C-4, B-3, B-2, D-4.

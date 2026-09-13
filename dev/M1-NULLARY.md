# M1 nullary entry tables

The seventh M1 slice accepts contracts whose entries all have empty
argument lists. `examples/Nullary.asy` supplies `get()`, `increment()` and
`reset()`, with a constructor that initializes the counter to seven.
Each function has its own selector and an empty ABI input array.

```sh
_build/default/bin/assay.exe emit examples/Nullary.asy -o Nullary-out
_build/default/bin/assay.exe run examples/Nullary.asy --calldata 0x6d4ce63c --storage 0=7
```

The existing semantics apply: `run` starts with the supplied storage,
creation executes the constructor, arithmetic checks its bounds, and
reverts restore storage. Entries require four selector bytes, accept
trailing calldata and reject nonzero call value. Tables contain 1 to 32
entries. The ordinary Word-argument and mixed tables retain their form.

## Checked representation

An empty product needs an explicit universe on its body to keep an
all-nullary entry sum in `Type 0`:

```
def get : Type 0 := (prod () : Type 0)
def reset : Type 0 := (prod () : Type 0)
def Entry : Type 0 := sum (get, reset)
```

The carried erasure retains the sum tag and drops the empty payload.
`check --erased` therefore shows `main` taking `union sum<unit|unit>`
and selecting the appropriate zero-arity branch. The surface lowerer
generates this annotation for every argument record in an all-nullary
table. The existing specialization and dispatcher then handle it.

The schema recognizer accepts exactly the explicitly annotated empty
product at `Type 0`, in addition to its original bare product records.
It reconstructs and compares the checked declaration before assigning
ABI meaning. An annotation around a nonempty product, an alias of the
empty product, or an explicit `Prop` annotation is outside this schema.

Core source may annotate just one empty argument record: that is enough
to keep the complete entry sum at `Type 0`. A table containing only bare
`prod ()` records still checks in the inherited grammar, but `emit` and
`run` refuse it with `M0_PROTOCOL: M1 nullary Entry needs an explicit
(prod () : Type 0) argument record` and exit 2. Surface source supplies
the annotation automatically.

## Validation

`python3 -P dev/nullary-test.py` checks 53 calls against integer
expectations, the source model and both geth Cancun execution paths:
18 example cases plus every selector in tables of sizes 1, 2 and 32.
These cover distinct branch results, uint256 endpoints, overflow,
storage clearing, short selectors, unknown selectors, trailing data
and nonpayable refusals. Every runtime instruction in the example is
executed. Both successful and refused creation are checked.

The surface example and two manually written core variants have exact
equality across all five emitted files. The gate checks ABI inputs,
live selector derivation, erasure, axiom disclosure and three-way
disassembly. Four checked sources must receive their named schema
refusal through both `emit` and `run`, before file creation.

Three compiler mutations must fail their named witness after a clean
build, and each restored control must pass. See the
[mutation record](M1-NULLARY-MUTATIONS.md). The complete battery has 42
legs and ends in `STAGE-M1-NULLARY OK`. Its timing report measures the
frozen M0 corpus under the existing method. It makes no M1 performance
claim. The source theorem and tested correspondence retain the scope
specified in [M1-PROOFS.md](M1-PROOFS.md).

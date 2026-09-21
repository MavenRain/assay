# Source model execution

`assay run` checks, erases and specializes a source program, then interprets
its effects with immutable storage. It invokes no external tools and writes
no files. The model shares recognition and specialization with the compiler.
Its arithmetic, dispatch and storage execution use no bytecode or assembler.
Agreement therefore checks lowering and execution, with shared frontend
code still outside that comparison.

```sh
_build/default/bin/assay.exe run examples/Ref20.asy
_build/default/bin/assay.exe run examples/Counter.asy --calldata 0x6d4ce63c --storage 0=7 --storage 1=100
```

The second command prints:

```json
{"status":"success","output":"0x0000000000000000000000000000000000000000000000000000000000000007","storage":{"0":"0x7","1":"0x64"}}
```

Options may follow the source in any order. `--calldata HEX`, `--value WORD`
and `--export NAME` each occur at most once. Their defaults are empty bytes,
zero and `main`. `--storage SLOT=WORD` may repeat for distinct slots. Words
and slots use unsigned decimal or `0x`-prefixed hexadecimal, up to uint256.
Hexadecimal accepts either letter case. A spelling contains at most 78
decimal digits or 64 hexadecimal digits, including leading zeroes. Signs,
whitespace, separators and other numeric prefixes are refused.
`--caller ADDRESS` also occurs at most once and defaults to zero.
It uses the same numeric spelling rules, with a uint160 value bound.
The [core context protocol](M1-CONTEXT.md) snapshots it for `caller`
continuations. The existing `Model.inputs` API keeps its zero caller;
`Model.inputs_with_caller` accepts the explicit context.

`--address ADDRESS` independently sets the contract address and defaults
to zero. It accepts the same unsigned 160-bit numeric forms as `--caller`
and may occur once. The [address effect](M1-ADDRESS.md) reads this value.
`Model.with_address` validates and updates an existing input, preserving
its caller, calldata, call value and storage.
Duplicate slots are compared by numeric
value, including slots initialized to zero. At most 1024 initial slots and
32768 calldata bytes are accepted. Initial slots outside the declared layout
are preserved, while source effects can access only declared slots.

Storage describes an already deployed contract. Missing slots read zero;
the constructor is checked but never applied to that storage. To model a
fresh bounded counter, supply `--storage 1=100`. Each invocation starts from
the supplied image, with no persisted session. The JSON storage object uses
decimal keys in numeric order and minimal hexadecimal values. Zero entries
are omitted. It describes only this contract's storage, without account,
balance, nonce, gas or log modeling. Call value reaches the M1 entry's
payability check; it does not transfer balances. M0 effects ignore calldata and value.

M1 dispatch rejects short argument heads and nonzero value at unmarked
entries with empty revert data. [Payable entries](M1-PAYABLE.md) accept
nonzero value. Unknown and short selectors use the reverting fallback,
whose custom payload is available only at zero value. Trailing calldata is ignored.
Success returns one ABI word. Arithmetic uses exact integers, follows the
error continuation on overflow or underflow, and exposes no wrapped result.
Loads capture their values before later writes. An explicit abort restores
the entire input storage image. Handling an arithmetic error without abort
preserves earlier writes.

A modeled revert is an ordinary JSON outcome and exits zero. Invalid
arguments or model inputs exit 64, checking or erasure failures exit 1, and
named source refusals exit 2. The RUN_MEMORY message is not a source
refusal: it reports an internal invariant of the prepared program, because
every specialized memory index is bound before it is read, so no source and
no input can cause it. Rejections print no result. Source protocol,
export, constructor, static-slot and symbolic-Word restrictions match the
core emitter. Specialization keeps its existing fuel, depth and temporary
bounds. Assembly size and gas limits do not apply to this source model.
The input file uses the driver's existing filesystem boundary.

## Validation

`python3 -P dev/model-test.py` checks all 30 frozen counter rows against
the model, emitted runtime and hand-assembled reference. Both bytecode
versions run through `evm run` and `evm t8n` under the explicit Cancun
fixture. Ten additional programs exercise recovery, write rollback,
load snapshots, storage clearing, absent slots, short and trailing heads,
two arguments and the zero selector. All eleven frozen M0 corpus programs
also agree with both executors and their committed expectations.

The driver checks malformed input, duplicate options and numeric aliases,
input bounds, unsupported checked programs, alternate exports, paths with
spaces, and execution with an empty PATH. Eight model mutations must fail
their named expected outcomes, and all restored controls must pass.
`M1-RUN-MUTATIONS.md` records the edits and witnesses. Raw captures live in
`.gatework/model/`. `SOURCE-MODEL` is an M1 gate, and its failure does not
change the separate M0 verdict. The model is priced within the unchanged
1800-line emitter allocation. The inherited kernel and surface stay intact.

This implements the current M0 and M1 source model. External calls and an
adversarial callee belong to later effect support. The P1 surface, source
overflow-freedom theorem and M1 performance bound remain open.

# M1 typed custom reverts

The eighth M1 slice adds declared errors with uint256 payloads. Error
declarations lower to a checked collection sum, and a new `reject` effect
carries that sum. The compiler derives the ABI and selectors from the same
checked declarations. Contracts without errors retain their existing core
protocol and output files.

```
contract Errors where
  storage State := { cell : Word }
  error Denied ()
  error InsufficientBalance (available : Word) (required : Word)
  entry fail (amount : Word) : Eff Sig Word :=
    do before <- sload cell ;
       sstore cell amount ;
       revert InsufficientBalance (before) (amount)
```

The complete [example](../examples/Errors.asy) also exercises nullary
errors, arithmetic and repeated arguments. It accepts the existing check,
emit, axioms, run, trace and diff commands. A modeled revert still exits
zero, with `status: "revert"`, encoded output and the original storage.

## Surface contract

An `error NAME (ARG : Word) ...` declaration may appear between other
declarations after storage. Use `()` for no arguments. There may be up to
32 errors, each with at most 32 arguments. Their declaration order and
argument names are preserved in the ABI. Error names must be distinct
from entries, the storage type and all field or argument aliases.
The existing identifier, source-size and token bounds apply.

`revert NAME (value) ...` ends an entry. Every payload value is explicitly
parenthesized and may be an argument, local, loaded snapshot or word
literal. Nullary reverts accept `revert NAME` and `revert NAME ()`.
Unknown errors, wrong argument counts and unbound values are named surface
refusals. Constructors still accept literal stores followed by `pure ()`.

Bare `revert`, arithmetic failures, failed `guard le`, malformed calldata,
unknown selectors and nonzero call value retain empty revert data. Custom
error declarations do not change these default failure paths.

## Core and encoding

With errors present, the checked core declares named argument products,
`Error : Type 0 := sum (...)`, and appends `reject : Error -> Tx` to the
existing transaction family. Error argument aliases must be exactly
`Word 256`. Empty products may use `(prod () : Type 0)`; a table with only
empty products needs at least one such annotation to preserve its tag
through erasure. The surface supplies the annotation for every empty
error product. `Error` and `reject` are backend protocol names.

The recognizer compares the declarations and full Tx family against its
canonical checked schema. Core aliases, erased reject payloads, renamed
constructors and unsupported products receive backend refusals. A core
global named `Error` selects this protocol even if the export never
rejects. All declared errors, including unused ones, are validated.

An error ABI row contains only `type: "error"`, `name` and `inputs`.
Rows follow the existing constructor and function rows. The selector is
the first four Keccak bytes of `NAME(uint256,...)`, followed by each
argument as a 32-byte big-endian word. This follows the
[Solidity ABI error encoding](https://docs.soliditylang.org/en/latest/abi-spec.html#errors).
Error selector collisions and the reserved values `00000000` and
`ffffffff` are refused before output creation. Function and error
selectors occupy separate domains.

Encoding uses a scratch buffer at byte 32768, after the compiler's 1024
snapshot words. A maximum payload occupies 1028 bytes, requiring at most
33 additional memory words. Payload construction cannot overwrite a
snapshot that a later argument reads. REVERT returns exactly the selector
and payload length. The source model evaluates operands with immutable
snapshots and restores the original storage on rejection.

## Validation and scope

`python3 -P dev/errors-test.py` checks 66 source/model/EVM cases, two
creation cases, every instruction in the example, 18 surface refusals and
eight checked backend refusals. Both geth entry points use the explicit
Cancun fixture. The 32-error table executes every selector, and a 32-word
payload exercises repeated maximum-width operands. The published
`InsufficientBalance` selector is also compared with live `cast` output.

The non-reserved collision `AssayError66951(uint256)` and
`AssayError96267(uint256)` is frozen as `3387398a` and rechecked with cast.
It was found by enumerating `AssayErrorN(uint256)` with PyCryptodome's
Keccak-256, stopping at 96267. PyCryptodome is not a gate dependency.
The existing zero-selector fixture checks reserved error rejection.

Five mutations have named failure witnesses and restored controls in
[M1-ERROR-MUTATIONS.md](M1-ERROR-MUTATIONS.md). The full battery has 43
legs. A complete battery is expected to end in `STAGE-M1-ERRORS OK` and
`M0-VALIDATION OK`. The archived run was interrupted at exit 143. It gives
no complete-battery verdict.
The timing gate for this slice is currently paused. The
[diagnosis](TIMING-DEBUG.md) records the comparison with the prior compiler
and the reporting fix. No complete-battery or fresh timing verdict is claimed.

The Lean source proof model still covers the preceding arithmetic and
empty-abort subset described in [M1-PROOFS.md](M1-PROOFS.md). This slice
tests typed payload correspondence; it adds no theorem about the compiler
or the new payload encoding. Both EVM executors are geth entry points.
The [proof guard slice](M1-GUARDS.md) adds typed errors on guard failure.
Invariant declarations and the M1 performance bound remain unfinished.
Milestone exit ratification remains with the user.

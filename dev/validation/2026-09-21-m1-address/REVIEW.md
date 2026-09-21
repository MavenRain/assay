# Implementation review

The address constructor is optional and follows the existing checked
context order. All matches on the context type remain exhaustive.
Surface lowering and core specialization allocate the same fresh binding
used by the prior context effects. The source model reads the validated
contract address, while emitted execution reads the ADDRESS opcode.

The public model API keeps both existing input constructors. The new
immutable update validates the full value before accepting uint160 and
preserves the remaining input fields. CLI parsing applies that validation
before loading the source and rejects duplicate or incomplete options.

The shared creation-offset resolver retains four attempts, identical
prefix assembly and the same byte-length fixed point. Both previous loops
start at fuel four and offset zero; replacing the M0 zero-fuel check with
the existing decrement helper preserves every reachable case. Storage-body
lookup is the same Option mapping over the same immutable environment.
Constructor validation still rejects nonzero returns and storage reads.

The address witnesses compare independent expected words and storage
images against the source model, direct geth execution and signed Cancun
execution. Contract addresses differ from callers. Boundary probes cover
zero, high-bit and maximum uint160 values, and include reverted writes.
Malformed schema witnesses use unused declarations to avoid unrelated
use-site type errors. Every mutation must build and fail the named
assertion, then pass after restoration.

The gate-plan comparison checks commands, deadlines, markers and M1
classification for all 43 prior modes. The new mode appends one leg.
No kernel, proof, dependency or trusted-code-limit file changed. The
HexWords literal-returning entry is renamed from `address` to
`literalAddress` because `address` is now reserved. Its existing hex gate
uses the new selector with the same expected value and required counts.
The final suite result and source hashes are recorded in FINAL.json and
VALIDATED-SOURCES.json. The suite retains the known measurement failures.

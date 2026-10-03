# M2 source function calldata

Source entries accept `Uint8`, `Uint256`, `Address`, `Bool` and `String`
parameters. `Word` keeps the existing uint256 ABI and decoding behavior.
Explicit ABI types use their canonical selector and strict tuple decoding.
Results still use the existing Word return ABI.

```text
entry lengthOf (message : String) : Eff Sig Word := do
  size <- stringlength message ; pure size
entry readFirst (message : String) : Eff Sig Word := do
  start <- stringdata message ; value <- calldataload start ; pure value
```

`stringlength` returns the byte length. `stringdata` returns the absolute
calldata byte address of the string data. Reads with `calldataload` are raw
32-byte reads: callers must respect the string length, especially for empty
strings and reads that extend into the next dynamic tail. String parameters
cannot be used directly as Word operands. The decoder preserves arbitrary
bytes and does not require UTF-8. `assayAbi` names are reserved in typed sources.
A String parameter name is in scope only in its own entry. The next top-level
declaration ends that scope. Diagnostics for typed sources report the same
source line and column as the equivalent Word source. The 65536-byte source
limit applies to the source text that the user supplies.

The model uses the shared ABI codec for strict decoding. The
emitter checks scalar bounds, offsets in declaration order, tail lengths,
zero padding, the exact final size and the 131072-byte calldata cap before
executing a typed entry. src/function_abi.bend generates these check
instructions. The trusted-line audit lists it as an unbudgeted source, like
the frontend, until M2 group 8 reviews the boundary. A change to its price
needs a user ruling. Invalid calldata reverts with empty return data and
preserves storage. Typed selector collisions are refused by emission and the
model. Packed fields and scalar or nested mappings retain their storage plan.

The generated ABI reports the declared input types and the checked entry
mutability. Constructors, errors, fallback and Word results retain their
existing ABI representation. Return types and source events belong to the
following M2 groups.

[FunctionCalldata.asy](../examples/FunctionCalldata.asy) demonstrates scalar
parameters and string access. `dev/function-abi-test.py` compares independent
cast encodings, model outcomes, geth run and Cancun t8n, and checks source
refusals. It also checks nonzero string padding in a one-string call and in
both tails of a two-string call. Three sources reuse a String parameter name
in a later declaration, and two pairs compare typed and Word diagnostic
positions. The default gate adds FUNCTION-ABI to all 102 carried legs.

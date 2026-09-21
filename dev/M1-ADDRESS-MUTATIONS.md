# Contract-address mutation witnesses

`python3 -P dev/address-test.py mutants` uses an isolated source copy.
Each mutant must build, fail its named assertion and pass the same probe
after restoration. Build failures do not count as killed mutants.
Captures and source hashes are retained under `.gatework/address/`.

| Mutation | Change | Required witness |
| --- | --- | --- |
| SURFACE | Lower `address` as `caller` | `ADDRESS-MODEL probe-0-observe` |
| MODEL | Read the caller input for `address` | `ADDRESS-MODEL probe-0-observe` |
| EMITTER | Emit `CALLER` for `address` | `ADDRESS-EVM probe-0-observe` |
| SCHEMA | Accept a Word 160 continuation | `ADDRESS-REFUSAL wrong-width` |
| SNAPSHOT | Reuse the next context binding's memory slot | `ADDRESS-MODEL probe-0-snapshot` |

The observe witness uses distinct contract and caller addresses. The
snapshot witness reads the address before caller, value, calldata,
storage and further address reads, then returns the first snapshot.
The schema witness checks an unused declaration so an unrelated use-site
type error cannot hide acceptance of the malformed protocol.

# M1 invariant mutations

`python3 -P dev/invariant-test.py mutants` builds each change in a
temporary copy, runs its named witness, restores the original source,
rebuilds and requires the same witness to pass. A mutation counts only
when it builds cleanly and defeats the expected check/emit/run refusal.

| Mutation | Changed behavior | Witness |
| --- | --- | --- |
| CONSTRUCTOR | Omit constructor invariant obligations | `constructor`: initialize count above its bound |
| FINAL | Omit obligations at successful returns | `final`: store an invalid final literal pair |
| STORE | Retain the earlier storage value after a store | `stale-store`: use a proof of the old count for an arbitrary new count |
| SECOND | Check only the first invariant | `second`: leave a false second constructor claim unchecked |

All four mutations must be detected, and every restored control must
pass. The gate prints measured case and mutation counts. Its archive
retains build transcripts, refusal outcomes and restored controls.

The existing surface STORE and SHADOW mutations keep their original
witnesses and outcomes. Their anchors now target the renamed store key
and the local Word binding site. The full surface gate passes after
this harness correction, including all seven restored controls.

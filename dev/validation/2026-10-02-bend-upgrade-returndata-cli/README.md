# Bend 2.0.28 and return-data CLI validation

Validation used a clean snapshot of `f8a8b1b`, with its Git history available,
and Bend `bc178404f4778704fa5584a73fcdf72bcdf9f32c`. The final source and
compiled JavaScript hashes, command exits and log names are in [checks.json](checks.json).

| Check | Result |
| --- | --- |
| Build and runtime suite | 18 adapters, 24 commands pass |
| Return-data CLI | 54 encodings, 55 decodings, 176 refusals, two pin mutations pass |
| Carried calldata CLI | 53 encodings, 55 decodings, 196 refusals pass |
| Mapping CLI | 244 cases, 102 oracle comparisons, 46 refusals pass |
| Event decoder CLI | 59 cases, 54 refusals pass |
| Packed source integration | 66 cases, Geth run and t8n, six compiled mutations pass |
| Historical gate schedules | 57 schedules and nine runner controls pass |
| Bootstrap controls | Explicit upgrade required, dirty tracked source refused, clean upgrade verified by `dev/bootstrap-control-test.py` |
| House style and source budgets | Pass, trusted total remains 3184/3550 |
| Carried native sources | Pass, 12 of 12 files, no difference |
| Paired measurement controls | Three controls, 37 refusals and six mutations pass |

The new default schedule appends one return-data CLI leg to the 100 carried
mapping-source legs. The full 101-leg battery was not run in this slice.
The M4 speed leg remains red: the newly frozen five-round, six-case record
measures an Assay/Bend ratio of 1.179120973 against the unchanged 1.0 limit.
Source identities, the report seal and the measurement window validate.
The `bend2-ratio` logs hold that run.
Earlier compiler versions and measurements remain in historical records.

Initial upgrade runs exposed missing JavaScript effect registrations and a
`CID` reference to an effect pruned from the compiled bundle. Both were fixed
before the successful runtime suite. The first return-data refusal run also
used calldata's four-byte selector overhead in its string size golden.
Return data admits a 131008-byte string plus its 64-byte dynamic tuple header;
131009 bytes must be refused after padding. The corrected boundary tests pass.

## Review fixes

A review of this slice on 2026-10-02 fixed seven findings. It repinned the
carried native sources in `dev/native-carry.json`. It documented the UTF-8
argument limit, the numeric spelling limits and the address notation of the
return-data CLI, and it added two over-long spelling refusals, for 176
refusals. It documented that `--upgrade` does not protect ignored files and
makes a shallow checkout. It updated the current Bend version, baseline and
default gate mode in the live pages. It added a bootstrap control test,
`dev/bootstrap-control-test.py`. The frozen speed record pins the Makefile,
so `make test` does not run that test. It added the return-data test, the
bootstrap test and the contract page to `dev/DENOMINATORS.sha256`. Each check
in `checks.json` now gives its command and its logs. The review did not
change `src/` and did not rebuild the compiled bundles. Each `review-*.log`
file holds one rerun and ends with its exit code. `review-gates.log` holds
the final cheap gates.

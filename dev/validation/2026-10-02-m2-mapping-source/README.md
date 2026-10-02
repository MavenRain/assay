# M2 mapping declaration validation

Base commit: af364d5. This record covers declaration parsing and physical
layout inspection through the public mapping-layout command.

The new command passes 13 explicit layout goldens, 26 declaration refusals,
four command or file refusals, and two compiled semantic mutations. Each
mutation must fail the erc20 golden after the earlier goldens pass. The
schedule check preserves the 99 carried legs and adds one MAPPING-SOURCE
leg, for 100. Historical CLI and schedule checks pass.

The existing mapping, event-encoding, event-decoding and calldata command
checks pass. The first event-decoding attempt exceeded its unchanged
30-second deadline on the maximum-size data case. A rerun passes without
changing the test. event-decode-boundary.json records the expected refusal
on the committed compiler in 12.84 seconds and this compiler in 19.38 seconds,
using the normal worker stack setting. This single pair does not isolate
the declaration change's speed effect.

House, carry and trusted-line audits pass. Kernel and artifact budgets remain
fixed. compiled-code-equivalence.json pins the bundle that make all rebuilt
from the final review source. That bundle matches the final source exactly.
The compiled-code.* logs are the check of the earlier bundle before the
review, and they are kept as history.

The full make test run was interrupted after native builds and adapter checks
had progressed. Its complete logs are retained as interrupted-make.*. Neither
a complete make test pass nor a full 100-leg milestone pass is claimed.
M2 runtime mapping operations, event lowering, dynamic ABI integration,
ERC-20 acceptance and proof closure remain open.

## Review

A review on 2026-10-02 made these changes. After the storage block, the
mapping-layout command now accepts only the end of input or a declaration
keyword, so a second storage block or other text fails with status 1. The
command refuses sources above 65536 bytes. The test adds goldens and
refusals at the depth and size limits, a payable entry golden, and refusals
for a second storage block and for trailing text. Each mutant must now fail
the erc20 golden. The usage text, the build log and the current default
text in the dev pages now name --m2-mapping-source. SOURCE-HASHES.sha256
freezes the changed inputs, which now include README.md,
dev/ASSAY-M2-BUILD-LOG.md, dev/DENOMINATORS.sha256 and
dev/M2-MAPPING-SOURCE.md. FILES.sha256 pins every other file in this
directory.

The review reran the checks after the fixes. The review-*.log files hold
that output, and each one ends with its exit code. mapping-source.stdout.log
and mapping-source.stderr.log hold the review rerun of the mapping source
check, and review-mapping-source.log adds its exit code. The other
*.capture.json, *.stdout.log and *.stderr.log files, and
mapping-source.capture.json, are the runs from before the review.

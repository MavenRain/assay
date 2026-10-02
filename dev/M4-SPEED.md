# M4 compiler speed gate

The user moved compiler speed to M4 on 2026-10-01 so milestone implementation
can proceed through M2 and M3 first. The Assay/Bend 2 ratio must still be at
most 1.0. The six-case, five-round paired protocol, exact source pins, pinned
Node version and prohibition on overhead subtraction are unchanged.

Run make gates-m4-speed, or python3 -P dev/stage-a-gates.py --m4-speed.
This schedule runs both BEND2-RATIO and BEND2-RATIO-TEST, with their original
60-second deadlines and required success markers. Informational measurements
cannot pass the ratio leg. Nonzero exits, missing markers and timeouts still
fail the stage.

dev/milestone-speed-test.py compares all 57 historical schedules with
commit 80bc4c6, removing only these two speed legs from the historical
side. It verifies the complete M4 schedule and exercises nine runner controls.
The default M2 schedule retains 93 carried non-speed checks and appends
MAPPING-CLI, EVENT-CLI, EVENT-DECODE-CLI, MILESTONE-SPEED and
PACKED-SOURCE, for 98 checks.

The last pre-transfer comparison was 1.591541253, above the unchanged 1.0
limit. It is historical evidence and its source pins predate source packing.
The gate must reject stale evidence until a new paired record for the final
source is produced. No passing performance result is claimed.

M4 also retains its deployment and chain-profile requirements. This speed
schedule checks only performance and authorizes no deployment or broadcast.
See [the measurement protocol](M1-BEND2.md) and [M2 source packing](M2-SOURCE-PACKING.md).

#!/usr/bin/env python3
"""Retain initial failures, rerun their original commands, and merge outcomes."""
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[3]
WORK = ROOT / '.gatework/callvalue-validation'
resume = (WORK / 'FINAL.json').exists()
initial = json.loads((WORK / ('FINAL.json' if resume else 'SCOPED.json')).read_text())
assert len(initial) == 35 and len({row['name'] for row in initial}) == 35
requested = set(sys.argv[1:])
assert requested <= {row['name'] for row in initial}, 'unknown gate requested'
attempts = WORK / 'attempts'
attempts.mkdir(exist_ok=True)
checks = json.loads((WORK / 'RECHECKS.json').read_text()) if resume else []
for row in initial:
    if row['passed'] and row['name'] not in requested:
        continue
    name = row['name']
    suffix = f'recheck-{len(checks) + 1}' if resume else 'initial'
    prior = attempts / (name + '-' + suffix + '.log')
    assert not prior.exists(), ('initial capture already archived', name)
    shutil.copy2(WORK / (name + '.log'), prior)
    start = time.monotonic()
    proc = subprocess.run(row['command'], cwd=ROOT, text=True,
                          capture_output=True, timeout=row['timeout'])
    (WORK / (name + '.log')).write_text(proc.stdout + proc.stderr)
    passed = proc.returncode == 0 and row['marker'] in proc.stdout + proc.stderr
    checks.append(dict(row, exit=proc.returncode, passed=passed,
                       elapsed_ms=round((time.monotonic() - start) * 1000)))
    (WORK / 'RECHECKS.json').write_text(json.dumps(checks, indent=2) + '\n')
    print(f"{'PASS' if passed else 'FAIL'} {name} exit={proc.returncode}", flush=True)
    if not passed:
        print(proc.stdout + proc.stderr, flush=True)
replacements = {row['name']: row for row in checks}
final = [replacements.get(row['name'], row) for row in initial]
(WORK / 'FINAL.json').write_text(json.dumps(final, indent=2) + '\n')
assert all(row['passed'] for row in final)
print(f'FINAL passed={len(final)} failed=0 rechecked={len(checks)} OK', flush=True)

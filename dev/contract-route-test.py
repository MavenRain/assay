#!/usr/bin/env python3
"""Check the routing bound and independently break identity and allocation."""
from pathlib import Path
import json
import subprocess

ROOT = Path(__file__).resolve().parent.parent
rows = []
for mode, expected in [('', 0), ('copy', 1), ('allocate', 1)]:
    command = [str(ROOT / '_build/test/contract_route')] + ([mode] if mode else [])
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=30)
    marker = 'bound=131072 OK' if not mode else 'CONTRACT-ROUTE FAIL'
    good = result.returncode == expected and marker in result.stdout + result.stderr
    rows.append({'mode': mode or 'baseline', 'status': result.returncode, 'stdout': result.stdout, 'stderr': result.stderr, 'ok': good})
    if not mode or not good:
        print(result.stdout + result.stderr, end='')
report = ROOT / '_build/contract-route.json'
report.write_text(json.dumps(rows, indent=2) + '\n')
good = all(row['ok'] for row in rows)
print('CONTRACT-ROUTE-CONTROLS killed=' + str(sum(row['ok'] for row in rows[1:])) + '/2 ' + ('OK' if good else 'FAIL'))
raise SystemExit(0 if good else 1)

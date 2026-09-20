#!/usr/bin/env python3
"""Recheck public build commands and representative mutation/control batteries."""
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
scope = {'__file__': str(HERE / 'scoped-run.py'), '__name__': 'public_tools'}
source = (HERE / 'scoped-run.py').read_text()
exec(compile(source[:source.index('\nselected = ')], str(HERE / 'scoped-run.py'), 'exec'), scope)
ROOT = scope['ROOT']
WORK = ROOT / '.gatework/payable-public-tools'
WORK.mkdir(parents=True, exist_ok=True)
selected = {'BUILD', 'PIN-CARRY', 'HOUSE', 'KECCAK-MUTANTS', 'ASM-MUTANTS',
            'PROOF-GUARDS', 'EVM-CONTEXT', 'PAYABLE'}
legs = [row for row in scope['current']['legs'] if row[0] in selected]
assert {row[0] for row in legs} == selected


def run(row):
    name, timeout, command, marker = row
    started = time.monotonic()
    proc = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
    (WORK / (name + '.log')).write_text(proc.stdout + proc.stderr)
    result = dict(name=name, command=command, timeout=timeout, exit=proc.returncode,
                  marker=marker, passed=proc.returncode == 0 and marker in proc.stdout + proc.stderr,
                  elapsed_ms=round((time.monotonic() - started) * 1000))
    print(f"{'PASS' if result['passed'] else 'FAIL'} {name} exit={proc.returncode}", flush=True)
    return result


results = [run(legs[0])]
assert results[0]['name'] == 'BUILD' and results[0]['passed']
with ThreadPoolExecutor(max_workers=2) as pool:
    results.extend(pool.map(run, legs[1:]))
(WORK / 'PUBLIC-TOOLS.json').write_text(json.dumps(results, indent=2) + '\n')
assert all(row['passed'] for row in results)
print(f'PUBLIC-TOOLS passed={len(results)} failed=0 OK')

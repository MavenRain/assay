#!/usr/bin/env python3
"""Run the test target's remaining checks and retain every exit status."""
from pathlib import Path
import json
import subprocess
import sys

ROOT = Path('/Users/oobi/Documents/gpt1/assay-segment-direct')
results = {}
for name in ('identifier-direct', 'word-direct', 'segment-direct'):
    print('FOLLOWUP ' + name, flush=True)
    result = subprocess.run([sys.executable, '-P', str(ROOT / 'dev' / (name + '-test.py'))], cwd=ROOT)
    results[name] = result.returncode
    print('FOLLOWUP ' + name + ' exit=' + str(result.returncode), flush=True)
(ROOT / '_build/segment-followups.json').write_text(json.dumps(results, indent=2) + '\n')
raise SystemExit(int(any(results.values())))

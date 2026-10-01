"""Run the remaining test-target commands, retaining each actual exit status."""
from pathlib import Path
import json
import subprocess
import sys

ROOT = Path('/Users/oobi/Documents/gpt1/assay-cli-direct')
checks = ('lexer-keywords', 'lexer-direct', 'identifier-direct', 'word-direct', 'segment-direct')
results = {}
for name in checks:
    print('FOLLOWUP ' + name, flush=True)
    run = subprocess.run([sys.executable, '-P', str(ROOT / 'dev' / (name + '-test.py'))], cwd=ROOT)
    results[name] = run.returncode
    print('FOLLOWUP ' + name + ' exit=' + str(run.returncode), flush=True)
(ROOT / '_build/cli-followups.json').write_text(json.dumps(results, indent=2) + '\n')
raise SystemExit(int(any(results.values())))

"""Run the remaining CLI checks after the full suite's kernel timeout."""
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m2-calldata-cli')
environment = os.environ | {'BEND': '/Users/oobi/Documents/assay/.tools/bend/bin/bend'}
for name in ('mapping-cli', 'event-cli', 'event-decode-cli', 'lexer-keywords',
             'lexer-direct', 'identifier-direct', 'word-direct', 'segment-direct',
             'cli-prefix-direct', 'cli-value-direct', 'cli-error-direct'):
    result = subprocess.run([sys.executable, '-P', 'dev/' + name + '-test.py'],
                            cwd=ROOT, env=environment, capture_output=True, text=True, timeout=600)
    print(result.stdout, end='', flush=True)
    if result.returncode or result.stderr:
        print(result.stderr, end='', file=sys.stderr)
        raise SystemExit(result.returncode or 1)
print('CLI-REGRESSIONS checks=11 OK')

import json
from pathlib import Path
import subprocess
import sys
import time

root = Path('/Users/oobi/Documents/assay')
argv = ['python3', '-P', 'dev/erc20-source-test.py']
start = time.monotonic()
try:
    result = subprocess.run(argv, cwd=root, capture_output=True, text=True, timeout=900)
    report = dict(argv=argv, cwd=str(root), deadline_seconds=900, seconds=time.monotonic()-start,
                  exit=result.returncode, timed_out=False, stdout=result.stdout, stderr=result.stderr)
except subprocess.TimeoutExpired:
    report = dict(argv=argv, cwd=str(root), deadline_seconds=900, seconds=time.monotonic()-start,
                  exit=124, timed_out=True, stdout='', stderr='ERC20-SOURCE exceeded its 900-second gate deadline\n')
Path('/Users/oobi/Documents/gpt1/assay-erc20-final-run.json').write_text(json.dumps(report, indent=2)+'\n')
print(report['stdout'], end='')
print(report['stderr'], end='', file=sys.stderr)
raise SystemExit(report['exit'])

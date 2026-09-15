"""Run the two corrected legacy suites serially with their gate deadlines."""
from pathlib import Path
import ast
import json
import subprocess
import sys

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m1-compound-guards')
WORK = ROOT / '.gatework/legacy-rechecks'
selected = sys.argv[1:] or ['PROOF-GUARDS', 'PREDICATES']
if any(name not in ('PROOF-GUARDS', 'PREDICATES') for name in selected):
    raise SystemExit('unexpected recheck')
rows = {}
for node in ast.walk(ast.parse((ROOT / 'dev/stage-a-gates.py').read_text())):
    if (isinstance(node, ast.Tuple) and len(node.elts) == 4 and
            isinstance(node.elts[0], ast.Constant) and node.elts[0].value in selected):
        row = ast.literal_eval(node)
        rows[row[0]] = row
if set(rows) != set(selected):
    raise SystemExit('missing recheck gate')
WORK.mkdir(parents=True, exist_ok=True)
failed = False
for name in selected:
    _, timeout, command, marker = rows[name]
    try:
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
        code, stdout, stderr = result.returncode, result.stdout, result.stderr
    except subprocess.TimeoutExpired as exc:
        code = 124
        stdout = exc.stdout or b''
        stderr = exc.stderr or b''
        stdout = stdout.decode(errors='replace') if isinstance(stdout, bytes) else stdout
        stderr = stderr.decode(errors='replace') if isinstance(stderr, bytes) else stderr
        stderr += f'gate timeout after {timeout} seconds\n'
    passed = code == 0 and marker in stdout + stderr
    failed = failed or not passed
    record = dict(name=name, command=command, timeout=timeout, marker=marker,
                  exit=code, stdout=stdout, stderr=stderr, passed=passed)
    (WORK / (name + '.json')).write_text(json.dumps(record, indent=2) + '\n')
    print(stdout, end='', flush=True)
    print(stderr, end='', file=sys.stderr, flush=True)
    print(f'RECHECK {name} {"PASS" if passed else "FAIL"} exit={code}', flush=True)
raise SystemExit(int(failed))

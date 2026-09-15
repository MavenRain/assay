"""Retry selected failed legs with the unchanged battery commands and deadlines."""
from pathlib import Path
import ast
import hashlib
import json
import subprocess
import sys
import time

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m1-predicates')
WORK = ROOT / '.gatework/predicate-rechecks'
source = ROOT / 'dev/stage-a-gates.py'
legs = {}
for node in ast.walk(ast.parse(source.read_text())):
    if not isinstance(node, ast.Tuple) or len(node.elts) != 4:
        continue
    try:
        name, timeout, command, marker = ast.literal_eval(node)
    except (ValueError, TypeError):
        continue
    if isinstance(name, str) and isinstance(timeout, int) and isinstance(command, tuple) and isinstance(marker, str):
        if name in legs:
            raise SystemExit('STOP: ambiguous gate ' + name)
        legs[name] = (timeout, command, marker)
names = sys.argv[1:]
if not names or len(set(names)) != len(names) or any(name not in legs or name in ('DENOMINATORS', 'M0-RATIO') for name in names):
    raise SystemExit('usage: recheck-assay-predicates.py FAILED-LEG ...')
if WORK.exists():
    raise SystemExit('STOP: recheck evidence already exists')
WORK.mkdir(parents=True)
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
identity = dict(binary=digest(ROOT / '_build/default/bin/assay.exe'),
                compiler=digest(ROOT / 'emit/contract.ml'), gates=digest(source))
rows = []
for name in names:
    timeout, command, marker = legs[name]
    start = time.monotonic()
    try:
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
        code, output = result.returncode, result.stdout + result.stderr
    except subprocess.TimeoutExpired as error:
        code = 124
        normalize = lambda text: text.decode(errors='replace') if isinstance(text, bytes) else (text or '')
        output = normalize(error.stdout) + normalize(error.stderr) + '\nRECHECK timeout\n'
    elapsed = (time.monotonic() - start) * 1000
    good = code == 0 and marker in output
    (WORK / (name + '.log')).write_text(output)
    rows.append(dict(name=name, command=list(command), deadline_seconds=timeout, marker=marker,
                     exit=code, elapsed_ms=elapsed, passed=good))
    print(f'RECHECK {name} {"PASS" if good else "FAIL"} exit={code} elapsed_ms={elapsed:.1f}', flush=True)
if identity != dict(binary=digest(ROOT / '_build/default/bin/assay.exe'),
                    compiler=digest(ROOT / 'emit/contract.ml'), gates=digest(source)):
    raise SystemExit('STOP: validated inputs changed during rechecks')
(WORK / 'RECHECKS.json').write_text(json.dumps(dict(identity=identity, results=rows), indent=2) + '\n')
sys.exit(0 if all(row['passed'] for row in rows) else 1)

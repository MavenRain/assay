"""Retain final closure checks with their exit codes and required markers."""
import json
from pathlib import Path
import subprocess
import sys
import time

root, evidence, kit = map(Path, sys.argv[1:])
checks = [
    ('DENOMINATORS', 10, ['shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256'], 'dev/denominators.json: OK'),
    ('M0-RATIO', 60, [sys.executable, '-B', '-P', 'dev/ratio.py'], 'M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK'),
    ('M1-RATIO', 60, [sys.executable, '-B', '-P', 'dev/ratio.py', '--m1'], 'M1-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK'),
    ('M1-RATIO-TEST', 60, [sys.executable, '-B', '-P', 'dev/m1-ratio-test.py'], 'M1-RATIO-TEST OK'),
    ('F-MUTANTS', 180, [sys.executable, '-B', '-P', 'dev/corpus-test.py', 'mutants'], 'F-MUTANTS killed=7/7 controls=5 OK'),
    ('HOUSE', 30, ['zsh', '-f', 'dev/house.sh'], 'HOUSE OK'),
    ('GATE-COMPATIBILITY', 60, [sys.executable, '-B', '-P', str(kit / 'gate-compatibility.py'),
                             str(kit / 'gates-before.py'), str(root / 'dev/stage-a-gates.py')],
     'GATE-COMPATIBILITY modes=44 old=73 new=75 classifications=3 OK'),
]
results = []
for name, timeout, command, marker in checks:
    start = time.monotonic()
    try:
        result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=timeout)
        code, output, error = result.returncode, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        code, output, error = 124, '', 'timeout\n'
    passed = code == 0 and marker in output
    (evidence / (name + '.log')).write_text(output)
    (evidence / (name + '.stderr')).write_text(error)
    results.append(dict(name=name, command=command, cwd=str(root), timeout=timeout,
                        exit_code=code, passed=passed, marker=marker,
                        elapsed_ms=(time.monotonic() - start) * 1000))
    print(f'{"PASS" if passed else "FAIL"} {name} exit={code}', flush=True)
    if name in ('M0-RATIO', 'M1-RATIO'):
        print(output, end='', flush=True)
(evidence / 'FOCUSED.json').write_text(json.dumps(results, indent=2) + '\n')
sys.exit(int(any(not row['passed'] for row in results)))

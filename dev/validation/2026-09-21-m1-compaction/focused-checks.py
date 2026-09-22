"""Run the remaining proof check and checks surrounding the compaction slice."""
import json
from pathlib import Path
import subprocess
import sys

archive = Path(__file__).resolve().parent
root = archive.parents[2]
checks = (
    ('AXIOMS', ['python3', '-P', 'dev/proofs-test.py'], 480, 0,
     'AXIOMS sorryAx=0 theorems=42 carried_files=28 controls=3 OK'),
    ('M1-EMISSION', ['python3', '-P', 'dev/m1-emit-test.py'], 600, 0,
     'M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK'),
    ('M1-RATIO-TEST', ['python3', '-P', 'dev/m1-ratio-test.py'], 60, 0,
     'M1-RATIO-TEST controls=5 refused=15 mutants=4'),
    ('M1-RATIO', ['python3', '-P', 'dev/ratio.py', '--m1'], 60, 1,
     'M1-RATIO FAIL RATIO-BOUND M1 limit=1.0'),
    ('DUNE-RUNTEST', ['zsh', '-f', 'dev/dune.sh', 'runtest'], 120, 0, ''),
)
results = []
for name, command, timeout, expected_exit, marker in checks:
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=timeout)
    (archive / (name + '.log')).write_text(result.stdout + result.stderr)
    good = result.returncode == expected_exit and marker in result.stdout + result.stderr
    results.append(dict(name=name, command=command, exit_code=result.returncode,
                        expected_exit=expected_exit, marker=marker, matched=good))
    print(f'{name} exit={result.returncode} expected={expected_exit} matched={good}', flush=True)
(archive / 'FOCUSED.json').write_text(json.dumps(results, indent=2) + '\n')
sys.exit(0 if all(row['matched'] for row in results) else 1)

"""Complete the interrupted functional battery without running the timing gate."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import time

root = Path('/Users/oobi/Documents/gpt1/assay-m1-errors')
gate = root / '.gatework/stage-m1-errors'
legs = [
    ('EMIT-MUTANTS', 1200, ['python3', '-P', 'dev/emit-test.py', 'mutants'], 'EMIT-MUTANTS killed=7/7 controls=4 OK'),
    ('AXIOMS', 480, ['python3', '-P', 'dev/proofs-test.py'], 'AXIOMS sorryAx=0 theorems=42 carried_files=28 controls=3 OK'),
    ('TRACE-DRIVER', 120, ['python3', '-P', 'dev/trace-test.py'], 'TRACE-DRIVER cases=20 explicit_prestate=true literal_argv=true OK'),
    ('CORPUS', 600, ['python3', '-P', 'dev/corpus-test.py', 'corpus'], 'CORPUS cases=11 five_files=5 OK'),
    ('ERASED-BYTES', 120, ['python3', '-P', 'dev/corpus-test.py', 'erased'], 'ERASED-BYTES mutants=2 caught=1 equal=2 scope=M0-seed OK'),
    ('F-MUTANTS', 180, ['python3', '-P', 'dev/corpus-test.py', 'mutants'], 'F-MUTANTS killed=7/7 controls=5 OK'),
    ('DIFF-EXECUTOR', 180, ['python3', '-P', 'dev/diff-test.py'], 'DIFF-EXECUTOR live=20 driver=28 rejected=24 OK'),
    ('COUNTER-REFERENCE', 300, ['python3', '-P', 'dev/counter-test.py'], 'COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK'),
    ('M1-EMISSION', 600, ['python3', '-P', 'dev/m1-emit-test.py'], 'M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK'),
    ('SOURCE-MODEL', 600, ['python3', '-P', 'dev/model-test.py'], 'SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK'),
    ('CONTRACT-SURFACE', 600, ['python3', '-P', 'dev/contract-test.py'], 'CONTRACT-SURFACE counter=30 variants=13 refusals=36 mutants=7 OK'),
    ('CONTRACT-ROUTE', 30, ['_build/default/test/contract_route.exe'], 'bound=131072 OK'),
    ('SOURCE-PROOFS', 600, ['python3', '-P', 'dev/source-proof-test.py'], 'SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK'),
    ('NULLARY-ENTRIES', 600, ['python3', '-P', 'dev/nullary-test.py'], 'NULLARY-ENTRIES cases=53 creates=2 refusals=4 mutants=3 OK'),
    ('CUSTOM-ERRORS', 600, ['python3', '-P', 'dev/errors-test.py'], 'CUSTOM-ERRORS cases=66 creates=2 refusals=24 mutants=5 OK'),
]
records = []
binary = root / '_build/default/bin/assay.exe'
before = hashlib.sha256(binary.read_bytes()).hexdigest()
for name, timeout, command, marker in legs:
    start = time.monotonic()
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=timeout)
    output = result.stdout + result.stderr
    good = result.returncode == 0 and marker in output
    (gate / (name + '.log')).write_text(output)
    records.append(dict(name=name, argv=command, cwd=str(root), exit=result.returncode, passed=good,
                        elapsed_seconds=time.monotonic() - start, sha256=hashlib.sha256(output.encode()).hexdigest()))
    (gate / 'FUNCTIONAL-RUN.json').write_text(json.dumps(dict(binary_sha256=before, timing_gate='paused by user', legs=records), indent=2) + '\n')
    print(f'{"PASS" if good else "FAIL"} {name} exit={result.returncode}', flush=True)
    if not good:
        print(output, flush=True)
        sys.exit(1)
if hashlib.sha256(binary.read_bytes()).hexdigest() != before:
    raise SystemExit('STOP: compiler changed during validation')
print('FUNCTIONAL-REMAINDER 15/15 OK; timing gate remains paused')

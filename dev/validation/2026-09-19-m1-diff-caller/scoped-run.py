#!/usr/bin/env python3
"""Preserve prior gate declarations and run the affected assay checks."""
import ast
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[3]
WORK = ROOT / '.gatework/diff-caller-validation'
WORK.mkdir(parents=True, exist_ok=True)
BASE = '63fde3b0cb01c83990f26e18b9cbb21c78a2288c'
OLD = subprocess.check_output(['git', 'show', BASE + ':dev/stage-a-gates.py'], cwd=ROOT, text=True)
NEW = (ROOT / 'dev/stage-a-gates.py').read_text()


def declarations(source, args):
    tree = ast.parse(source)
    main = next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == 'main')
    stop = next(index for index, node in enumerate(main.body) if isinstance(node, ast.Assign) and
                any(isinstance(target, ast.Name) and target.id == 'work' for target in node.targets))
    main.body = main.body[:stop] + [ast.parse('return dict(legs=legs, stage=stage, m1_names=sorted(m1_names))').body[0]]
    ast.fix_missing_locations(tree)
    scope = {'__file__': str(ROOT / 'dev/stage-a-gates.py'), '__name__': 'gate_compatibility'}
    saved = sys.argv
    try:
        sys.argv = ['stage-a-gates.py', *args]
        exec(compile(tree, 'stage-a-gates.py', 'exec'), scope)
        return scope['main']()
    finally:
        sys.argv = saved


old_tree = ast.parse(OLD)
modes = next(ast.literal_eval(node.comparators[0]) for node in ast.walk(old_tree)
             if isinstance(node, ast.Compare) and len(node.ops) == 1 and isinstance(node.ops[0], ast.NotIn)
             and isinstance(node.comparators[0], ast.Tuple))
for mode in modes:
    assert declarations(OLD, mode) == declarations(NEW, mode), ('changed prior mode', mode)
previous = declarations(OLD, ['--m1-trace-caller'])
current = declarations(NEW, ['--m1-diff-caller'])
assert current['legs'][:-1] == previous['legs']
assert current['legs'][-1][0] == 'DIFF-CALLER'
assert set(current['m1_names']) == set(previous['m1_names']) | {'DIFF-CALLER'}
assert current['stage'] == 'M1-DIFF-CALLER'
record = dict(base=BASE, previous_modes=len(modes), previous_legs=len(previous['legs']),
              current_legs=len(current['legs']), preserved=True, added_leg=current['legs'][-1],
              gates_sha256=hashlib.sha256(NEW.encode()).hexdigest())
(WORK / 'GATE-COMPATIBILITY.json').write_text(json.dumps(record, indent=2) + '\n')
print(f"GATE-COMPATIBILITY modes={len(modes)} previous={len(previous['legs'])} current={len(current['legs'])} OK", flush=True)

selected = {'DIFF-CALLER', 'DIFF-EXECUTOR', 'DIFF-VALUE', 'TRACE-CALLER', 'TRACE-VALUE', 'TRACE-DRIVER',
            'DRIVER', 'PIN-CARRY', 'R0-COUNT', 'R0-AUDIT', 'HOUSE', 'TRUSTED-LINES'}
results = []
assert selected <= {row[0] for row in current['legs']}
for name, timeout, command, marker in current['legs']:
    if name not in selected:
        continue
    started = time.monotonic()
    proc = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=timeout)
    (WORK / (name + '.log')).write_text(proc.stdout + proc.stderr)
    passed = proc.returncode == 0 and marker in proc.stdout + proc.stderr
    results.append(dict(name=name, command=command, timeout=timeout, exit=proc.returncode,
                        marker=marker, passed=passed, elapsed_ms=round((time.monotonic() - started) * 1000)))
    (WORK / 'SCOPED.json').write_text(json.dumps(results, indent=2) + '\n')
    print(f"{'PASS' if passed else 'FAIL'} {name} exit={proc.returncode}", flush=True)
    if not passed:
        print(proc.stdout + proc.stderr, flush=True)
assert all(row['passed'] for row in results)
print(f'SCOPED passed={len(results)} failed=0 OK')

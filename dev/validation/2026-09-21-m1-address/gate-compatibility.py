import ast
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: gate-compatibility.py REPOSITORY')
ROOT = Path(sys.argv[1]).resolve()
TARGET = ROOT / 'dev/stage-a-gates.py'
BASE = subprocess.check_output(['git', '-C', str(ROOT), 'show', '0eed12bd951f78c9c813a54188ec662a1de129b2:dev/stage-a-gates.py'], text=True)
CURRENT = TARGET.read_text()


def plan(source, mode):
    tree = ast.parse(source)
    main = next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == 'main')
    boundary = next(i for i, node in enumerate(main.body)
                    if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == 'work' for t in node.targets))
    main.body = main.body[:boundary] + ast.parse('return stage, sorted(m1_names), legs').body
    tree.body = [node for node in tree.body if isinstance(node, (ast.Import, ast.ImportFrom))] + [main]
    ast.fix_missing_locations(tree)
    namespace = {'__file__': str(TARGET)}
    exec(compile(tree, str(TARGET), 'exec'), namespace)
    sys.argv = [str(TARGET)] + mode
    return namespace['main']()


modes = [[]] + [[mode] for mode in sorted(set(re.findall(r'"(--[a-z0-9-]+)"', BASE)))]
records = []
for mode in modes:
    before, after = plan(BASE, mode), plan(CURRENT, mode)
    if before != after:
        raise SystemExit('Changed previous gate mode: ' + repr(mode))
    records.append({'mode': mode, 'stage': before[0], 'legs': len(before[2]),
                    'sha256': hashlib.sha256(json.dumps(before, sort_keys=True).encode()).hexdigest()})
previous = plan(CURRENT, ['--m1-calldataload'])
current = plan(CURRENT, ['--m1-address'])
if current[0] != 'M1-ADDRESS' or current[2][:-1] != previous[2] or len(current[2]) != 73:
    raise SystemExit('New gate must append exactly one leg to all prior gates')
if current[1] != sorted(previous[1] + ['ADDRESS']):
    raise SystemExit('Incorrect milestone classification')
result = {'baseline': hashlib.sha256(BASE.encode()).hexdigest(),
          'current': hashlib.sha256(CURRENT.encode()).hexdigest(), 'unchanged_modes': records,
          'new_stage': current[0], 'new_legs': len(current[2]), 'appended': current[2][-1], 'ok': True}
output = ROOT / 'dev/validation/2026-09-21-m1-address/GATE-COMPATIBILITY.json'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({'ok': True, 'unchanged_modes': len(records), 'new_legs': len(current[2]), 'output': str(output)}))

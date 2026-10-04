#!/usr/bin/env python3
"""Compare every gate mode with the base commit without executing or changing its legs.

    python3 -P dev/validation/2026-10-03-m2-storage-proofs/check-gate-integration.py [--write]

The baseline is the fixed base commit of the slice, not HEAD. Without
`--write` the computed summary must equal GATE-INTEGRATION.json and the
script exits 1 on any difference. With `--write` it rewrites the record.
"""
from pathlib import Path
import ast
import contextlib
import hashlib
import io
import json
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BASELINE = '7ec1b8ac4110d4f4dd070b81f02fad9b033d08c9'
SOURCE = ROOT / 'dev/stage-a-gates.py'
RECORD = HERE / 'GATE-INTEGRATION.json'
ADDED = ('STORAGE-PROOFS', 600, ('python3', '-P', 'dev/storage-proof-test.py'))


def fail(message):
    print('GATE-INTEGRATION ' + message)
    sys.exit(1)


def require(ok, message):
    if not ok:
        fail(message)


class SelectLegs(ast.NodeTransformer):
    def __init__(self):
        self.changed = 0

    def visit_Assign(self, node):
        if any(isinstance(target, ast.Name) and target.id == 'work' for target in node.targets):
            self.changed += 1
            return ast.copy_location(ast.Return(ast.Tuple(
                [ast.Name('stage', ast.Load()), ast.Name('legs', ast.Load())], ast.Load())), node)
        return node


def reader(text):
    tree = ast.parse(text)
    select = SelectLegs()
    tree = select.visit(tree)
    require(select.changed == 1, 'expected one work assignment in dev/stage-a-gates.py')
    ast.fix_missing_locations(tree)
    namespace = dict(__file__=str(SOURCE), __name__='gate_inventory')
    exec(compile(tree, str(SOURCE), 'exec'), namespace)
    return namespace['main']


def legs(read, flag):
    before = sys.argv
    try:
        sys.argv = [str(SOURCE)] + ([flag] if flag else [])
        with contextlib.redirect_stdout(io.StringIO()):
            return read()
    finally:
        sys.argv = before


def compare():
    old = subprocess.check_output(['git', 'show', BASELINE + ':dev/stage-a-gates.py'],
                                  cwd=ROOT, text=True)
    prior, current = reader(old), reader(SOURCE.read_text())
    flags = sorted(set(re.findall(r'sys.argv\[1:\] == \["([^"]+)"\]', old)))
    changed = [flag or '(default)' for flag in [''] + flags
               if legs(prior, flag) != legs(current, flag)]
    require(not changed, 'modes changed: ' + ' '.join(changed))
    _, original = legs(prior, '--m2-source-events')
    stage, updated = legs(current, '--m2-storage-proofs')
    require(stage == 'M2-STORAGE-PROOFS', 'unexpected stage ' + stage)
    require(updated[:-1] == original, 'the storage mode does not keep the source-events legs')
    require(updated[-1][0:3] == ADDED, 'unexpected added leg ' + repr(updated[-1][0:3]))
    summary = dict(baseline=BASELINE, existing_modes_preserved=len(flags) + 1,
                   previous_legs=len(original), added_leg=updated[-1],
                   source_sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest())
    return json.loads(json.dumps(summary))


def main():
    summary = compare()
    if '--write' in sys.argv[1:]:
        RECORD.write_text(json.dumps(summary, indent=2) + '\n')
    else:
        require(RECORD.is_file(), 'GATE-INTEGRATION.json is missing; run with --write')
        require(json.loads(RECORD.read_text()) == summary,
                'GATE-INTEGRATION.json differs from the computed summary')
    print(json.dumps(summary))


if __name__ == '__main__':
    main()

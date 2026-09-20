#!/usr/bin/env python3
"""Replay unchanged gate declarations for the corrected mutation anchors."""
import ast
from pathlib import Path

SCRIPT = Path(__file__).with_name('scoped-run.py')
NAMES = {'TRUSTED-LINES', 'M1-EMISSION', 'PROOF-GUARDS', 'EVM-CONTEXT'}
tree = ast.parse(SCRIPT.read_text())
changed = set()
for node in tree.body:
    if not isinstance(node, ast.Assign) or len(node.targets) != 1 or not isinstance(node.targets[0], ast.Name):
        continue
    name = node.targets[0].id
    if name == 'selected':
        node.value = ast.parse(repr(NAMES), mode='eval').body
        changed.add(name)
    elif name == 'WORK':
        node.value = ast.parse("ROOT / '.gatework/payable-rechecks'", mode='eval').body
        changed.add(name)
assert changed == {'selected', 'WORK'}
ast.fix_missing_locations(tree)
exec(compile(tree, str(SCRIPT), 'exec'), {'__file__': str(SCRIPT), '__name__': '__main__'})

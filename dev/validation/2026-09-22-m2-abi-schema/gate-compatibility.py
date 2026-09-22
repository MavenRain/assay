import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m2-abi')
ORIGINAL = ROOT / '.gatework/abi-schema/gates-before.py'
ORIGINAL.write_bytes(subprocess.check_output(
    ['git', '-C', str(ROOT), 'show', '6cb76ea:dev/stage-a-gates.py']))
spec = importlib.util.spec_from_file_location('compat', ROOT / 'dev/validation/2026-09-21-m1-close/gate-compatibility.py')
compat = importlib.util.module_from_spec(spec)
spec.loader.exec_module(compat)
before, old_markers, modes = compat.load(ORIGINAL)
after, new_markers, _ = compat.load(ROOT / 'dev/stage-a-gates.py')
modes = [*modes, ['--m1-close'], ['--m2-reference']]
with tempfile.TemporaryDirectory(prefix='assay-abi-plan-') as temporary:
    root = Path(temporary)
    for args in modes:
        if compat.run(before, old_markers, args, root) != compat.run(after, new_markers, args, root):
            raise SystemExit('Changed historical mode: ' + str(args))
    old = compat.run(before, old_markers, ['--m2-reference'], root)
    new = compat.run(after, new_markers, ['--m2-abi-schema'], root)
    if len(old[0]) != 76 or len(new[0]) != 77 or new[0][:-1] != old[0] or new[1] != 0:
        raise SystemExit('Incorrect appended gate')
    if 'STAGE-M2-ABI-SCHEMA OK' not in new[2]:
        raise SystemExit('Incorrect success marker')
    for leg in ('ABI-SCHEMA', 'ERC20-REFERENCE', 'BEND2-RATIO'):
        failed = compat.run(after, new_markers, ['--m2-abi-schema'], root, fail=leg)
        if failed[1] != 1 or 'STAGE-M2-ABI-SCHEMA FAIL' not in failed[2] or not any(
                line.startswith('M0-VALIDATION OK') for line in failed[2]):
            raise SystemExit('Incorrect failure classification: ' + leg)
    failed = compat.run(after, new_markers, ['--m2-abi-schema'], root, fail='DENOMINATORS')
    if failed[1] != 1 or not any(line.startswith('M0-VALIDATION FAIL') for line in failed[2]):
        raise SystemExit('Incorrect carried failure classification')
    result = dict(modes=len(modes), old=76, new=77, classifications=4, status='OK')
    (ROOT / '.gatework/abi-schema/GATE-COMPATIBILITY.json').write_text(json.dumps(result, indent=2) + '\n')
    print('GATE-COMPATIBILITY ' + json.dumps(result, separators=(',', ':')))

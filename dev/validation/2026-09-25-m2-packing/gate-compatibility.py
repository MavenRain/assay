import importlib.util
import json
from pathlib import Path
import subprocess
import shutil
import tempfile
import sys

ROOT = Path(sys.argv[1]).resolve()
WORK = ROOT / '.gatework/layout-packed'
WORK.mkdir(parents=True, exist_ok=True)
before_path = WORK / 'gates-before.py'
before_path.write_bytes(subprocess.check_output(['git', '-C', str(ROOT), 'show', 'f80689217a7557a7b3bd200f2ed865cde9d59e10:dev/stage-a-gates.py']))
spec = importlib.util.spec_from_file_location('compat', ROOT / 'dev/validation/2026-09-21-m1-close/gate-compatibility.py')
compat = importlib.util.module_from_spec(spec)
spec.loader.exec_module(compat)
before, old_markers, modes = compat.load(before_path)
after, new_markers, _ = compat.load(ROOT / 'dev/stage-a-gates.py')
modes = [*modes, ['--m1-close'], ['--m2-reference'], ['--m2-abi-schema'], ['--m2-abi-codec']]
temporary = tempfile.TemporaryDirectory(prefix='assay-packing-plan-')
SANDBOX = Path(temporary.name)
record = Path('dev/validation/bend2-native/REPORT.json')
(SANDBOX / record).parent.mkdir(parents=True)
shutil.copy2(ROOT / record, SANDBOX / record)
for args in modes:
    assert compat.run(before, old_markers, args, SANDBOX) == compat.run(after, new_markers, args, SANDBOX), args
old = compat.run(before, old_markers, ['--m2-abi-codec'], SANDBOX)
new = compat.run(after, new_markers, ['--m2-packing'], SANDBOX)
assert new[0][:-1] == old[0] and new[1] == 0 and new[0][-1][0] == 'LAYOUT-PACKED'
assert 'STAGE-M2-PACKING OK' in new[2]
for leg in ('LAYOUT-PACKED', 'ABI-CODEC', 'BEND2-RATIO'):
    failed = compat.run(after, new_markers, ['--m2-packing'], SANDBOX, fail=leg)
    assert failed[1] == 1 and 'STAGE-M2-PACKING FAIL' in failed[2]
    assert any(line.startswith('M0-VALIDATION OK') for line in failed[2])
failed = compat.run(after, new_markers, ['--m2-packing'], SANDBOX, fail='DENOMINATORS')
assert failed[1] == 1 and any(line.startswith('M0-VALIDATION FAIL') for line in failed[2])
report = dict(modes=len(modes), previous=len(old[0]), current=len(new[0]), classifications=4, status='OK')
(WORK / 'gate-compatibility.json').write_text(json.dumps(report, indent=2) + '\n')
print('GATE-COMPATIBILITY ' + json.dumps(report))
temporary.cleanup()

from pathlib import Path
from unittest.mock import patch
import contextlib
import importlib.util
import inspect
import io
import json
import subprocess
import sys
import tempfile
import types

root = Path('/Users/oobi/Documents/assay')
work = Path("/Users/oobi/Documents/assay-m2-return-abi-review/schedule-simulation")
work.mkdir(exist_ok=True)
old = subprocess.check_output(['git', 'show', 'HEAD:dev/stage-a-gates.py'], cwd=root)
old_path = work / 'old.py'
old_path.write_bytes(old)

def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value

before = module('before', old_path)
after = module('after', root / 'dev/stage-a-gates.py')
record = after.recorded_runs(root)
assert not record[1]

def simulate(value, flag, missing=False):
    rows = []
    value.__file__ = str(work / ('missing' if missing else flag) / 'dev/stage-a-gates.py')
    value.recorded_runs = lambda _: record
    def run(command, **kwargs):
        frame = inspect.currentframe().f_back
        name, marker = frame.f_locals['name'], frame.f_locals['marker']
        rows.append(dict(name=name, command=list(command), deadline=kwargs['timeout'], marker=marker))
        return types.SimpleNamespace(returncode=0, stdout='SIMULATION\n' + ('' if missing and name == 'RETURN-ABI' else marker) + '\n', stderr='')
    output = io.StringIO()
    with patch.object(sys, 'argv', ['stage-a-gates.py', flag]), patch('subprocess.run', run), contextlib.redirect_stdout(output):
        result = value.main()
    return result, rows, output.getvalue()

old_result, old_rows, old_log = simulate(before, '--m2-function-abi')
new_result, new_rows, new_log = simulate(after, '--m2-return-abi')
bad_result, bad_rows, bad_log = simulate(after, '--m2-return-abi', True)
assert old_result == new_result == 0 and bad_result == 1
assert len(old_rows) == 103 and len(new_rows) == 104
assert new_rows[:103] == old_rows
assert new_rows[-1]['name'] == 'RETURN-ABI'
assert 'FAIL RETURN-ABI' in bad_log and 'STAGE-M2-RETURN-ABI FAIL' in bad_log
result = dict(simulation=True, carried=old_rows, added=new_rows[-1], missing_marker_exit=bad_result,
              old_log=old_log, new_log=new_log, missing_log=bad_log)
(work / 'schedule.json').write_text(json.dumps(result, indent=2) + '\n')
print('SCHEDULE-AUDIT simulation=true carried=103 unchanged=103 added=1 missing_marker=refused OK')

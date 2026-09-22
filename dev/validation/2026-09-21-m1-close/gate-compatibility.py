"""Compare gate schedules and failure classification without rerunning workloads."""
import ast
import contextlib
import importlib.util
import io
import inspect
from pathlib import Path
import subprocess
import sys
import tempfile
from unittest.mock import patch


def load(path):
    spec = importlib.util.spec_from_file_location(path.stem, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    tree = ast.parse(path.read_text())
    markers = {}
    modes = []
    for node in ast.walk(tree):
        try:
            value = ast.literal_eval(node)
        except (ValueError, TypeError, SyntaxError):
            continue
        if isinstance(value, tuple) and len(value) == 4 and isinstance(value[0], str) and isinstance(value[2], tuple):
            markers[value[2]] = (value[0], value[3])
        if isinstance(value, tuple) and len(value) > 40 and all(isinstance(v, list) for v in value):
            modes = value
    assert markers and modes
    return module, markers, modes


def run(module, markers, args, root, fail=None):
    calls = []
    def invoke(command, **kwargs):
        selected = inspect.currentframe().f_back.f_locals
        name, marker = selected['name'], selected['marker']
        calls.append((name, tuple(command), kwargs['timeout'], marker))
        return subprocess.CompletedProcess(command, int(name == fail), marker, '')
    output = io.StringIO()
    module.__file__ = str(root / 'dev/gates.py')
    with patch.object(sys, 'argv', ['gates.py', *args]), patch.object(subprocess, 'run', invoke), contextlib.redirect_stdout(output):
        code = module.main()
    verdicts = [line for line in output.getvalue().splitlines() if line.startswith(('STAGE-', 'M0-VALIDATION', 'PENDING'))]
    return calls, code, verdicts


def main():
    before, old_markers, modes = load(Path(sys.argv[1]))
    after, new_markers, _ = load(Path(sys.argv[2]))
    with tempfile.TemporaryDirectory(prefix='assay-gate-compatibility-') as temporary:
        root = Path(temporary)
        for args in modes:
            assert run(before, old_markers, args, root) == run(after, new_markers, args, root), args
        old = run(before, old_markers, ['--m1-address'], root)
        new = run(after, new_markers, ['--m1-close'], root)
        assert len(old[0]) == 73 and len(new[0]) == 75 and new[0][:-2] == old[0]
        assert new[1] == 0 and 'STAGE-M1-CLOSE OK' in new[2]
        for leg in ('M1-RATIO', 'M1-RATIO-TEST'):
            failed = run(after, new_markers, ['--m1-close'], root, fail=leg)
            assert failed[1] == 1 and 'STAGE-M1-CLOSE FAIL' in failed[2]
            assert any(line.startswith('M0-VALIDATION OK') for line in failed[2])
        failed = run(after, new_markers, ['--m1-close'], root, fail='DENOMINATORS')
        assert failed[1] == 1 and any(line.startswith('M0-VALIDATION FAIL') for line in failed[2])
        print(f'GATE-COMPATIBILITY modes={len(modes)} old=73 new=75 classifications=3 OK')


if __name__ == '__main__':
    main()

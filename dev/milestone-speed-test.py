#!/usr/bin/env python3
"""Verify the M4 speed owner and preserve all other milestone schedule legs."""
import contextlib
import importlib.util
import io
from pathlib import Path
import re
import subprocess
import sys
import tempfile
from unittest import mock

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('speed_schedules', ROOT / 'dev/revert-compatibility.py')
H = importlib.util.module_from_spec(spec)
spec.loader.exec_module(H)
SPEED = {'BEND2-RATIO', 'BEND2-RATIO-TEST'}


def require(ok, message):
    if not ok:
        raise AssertionError('MILESTONE-SPEED ' + message)


def main():
    source = (ROOT / 'dev/stage-a-gates.py').read_text()
    old = subprocess.check_output(['git', 'show', '80bc4c6:dev/stage-a-gates.py'],
                                  cwd=ROOT, text=True)
    before, after = H.load(old), H.load(source)
    modes = sorted(set(re.findall(r'\["(--[a-z0-9-]+)"\]', old)))
    modes = [''] + modes
    original_argv = sys.argv
    try:
        for mode in modes:
            previous = H.schedule(before, mode)
            previous['legs'] = [leg for leg in previous['legs'] if leg[0] not in SPEED]
            current = H.schedule(after, mode)
            require(previous == current, 'changed carried schedule: ' + mode)
            require(not SPEED.intersection(leg[0] for leg in current['legs']), 'early speed leg: ' + mode)
        m4 = H.schedule(after, '--m4-speed')
        require(m4 == dict(stage='M4-SPEED', legs=[
            ('BEND2-RATIO', 60, ('python3', '-P', 'dev/bend2-ratio.py'),
             'informational=false\nBEND2-RATIO cases=6 rounds=5 source-pins=OK subtraction=none OK', False),
            ('BEND2-RATIO-TEST', 60, ('python3', '-P', 'dev/bend2-ratio-test.py'),
             'BEND2-RATIO-TEST controls=3 refused=37 mutants=6 OK', False),
        ]), 'M4 commands, deadlines or required markers changed')
        current = H.schedule(after, '--m2-source-packing')
        previous = H.schedule(after, '--lexer-direct')
        require(current['stage'] == 'M2-SOURCE-PACKING' and
                current['legs'][:-6] == previous['legs'] and
                current['legs'][-6:] == [
                    ('MAPPING-CLI', 600, ('python3', '-P', 'dev/mapping-cli-test.py'),
                     'MAPPING-CLI cases=244 oracle=102 reference=10 refusals=46 OK', True),
                    ('EVENT-CLI', 600, ('python3', '-P', 'dev/event-cli-test.py'),
                     'EVENT-CLI cases=56 oracle=cast refusals=36 OK', True),
                    ('EVENT-DECODE-CLI', 600, ('python3', '-P', 'dev/event-decode-cli-test.py'),
                     'EVENT-DECODE-CLI cases=59 oracle=cast refusals=54 OK', True),
                    ('CALLDATA-CLI', 600, ('python3', '-P', 'dev/calldata-cli-test.py'),
                     'CALLDATA-CLI encode=53 decode=55 oracle=cast refusals=196 pin_mutants=2 OK', True),
                    ('MILESTONE-SPEED', 60, ('python3', '-P', 'dev/milestone-speed-test.py'),
                     'MILESTONE-SPEED schedules=57 controls=9 OK', True),
                    ('PACKED-SOURCE', 600, ('python3', '-P', 'dev/packed-source-test.py'),
                     'PACKED-SOURCE cases=66 model=packed executors=run+t8n mutants=6 OK', True)],
                'source packing must append all six mandatory checks')
        mapping = H.schedule(after, '--m2-mapping-runtime')
        carried = H.schedule(after, '--m2-returndata-cli')
        require(mapping == dict(stage='M2-MAPPING-RUNTIME', legs=carried['legs'] + [
            ('MAPPING-RUNTIME', 600, ('python3', '-P', 'dev/mapping-runtime-test.py'),
             'MAPPING-RUNTIME live=40 refusals=27 constructor=1 layout=1 OK', True)]),
                'mapping runtime must preserve all carried legs and add its required check')
        require('--m2-mapping-runtime' in (ROOT / 'dev/gates.sh').read_text() and
                'dev/stage-a-gates.py --m2-mapping-runtime' in (ROOT / 'Makefile').read_text(),
                'default gate entry points must select mapping runtime')
    finally:
        sys.argv = original_argv

    # Execute the real runner with controlled subprocess outcomes. It must not
    # turn missing markers, nonzero exits or timeouts into a successful M4 gate.
    namespace = {'__file__': str(ROOT / 'dev/stage-a-gates.py'), '__name__': 'speed_runner_probe'}
    exec(compile(source, namespace['__file__'], 'exec'), namespace)
    controls = [(None, None)] + [(index, failure) for index in [0, 1]
                                for failure in ['exit', 'skip', 'marker', 'timeout']]
    for index, failure in controls:
        calls = []

        def run(command, **kwargs):
            position = len(calls)
            calls.append((command, kwargs))
            marker = m4['legs'][position][3]
            if position == index:
                if failure == 'timeout':
                    raise subprocess.TimeoutExpired(command, kwargs['timeout'], output=marker)
                return subprocess.CompletedProcess(command, 1 if failure == 'exit' else 0,
                                                   marker if failure == 'exit' else
                                                   ('SKIP speed gate\n' if failure == 'skip' else 'BEND2-RATIO OK\n'), '')
            return subprocess.CompletedProcess(command, 0, marker + '\n', '')

        with tempfile.TemporaryDirectory(prefix='assay-speed-owner-') as directory:
            path = Path(directory) / 'dev/stage-a-gates.py'
            with mock.patch.dict(namespace, {'__file__': str(path), 'recorded_runs': lambda root: ({}, [], path)}), \
                    mock.patch.object(sys, 'argv', ['stage-a-gates.py', '--m4-speed']), \
                    mock.patch.object(namespace['subprocess'], 'run', side_effect=run), \
                    contextlib.redirect_stdout(io.StringIO()) as output:
                result = namespace['main']()
            require(result == (0 if failure is None else 1), 'failure propagation: ' + str((index, failure)))
            require(len(calls) == 2 and all(call[1]['timeout'] == 60 for call in calls), 'both M4 legs must run')
            require('STAGE-M4-SPEED ' + ('OK' if failure is None else 'FAIL') in output.getvalue(),
                    'M4 final marker')
    print(f'MILESTONE-SPEED schedules={len(modes)} controls={len(controls)} OK')


if __name__ == '__main__':
    main()

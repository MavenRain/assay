#!/usr/bin/env python3
"""Check the Bend bootstrap upgrade controls with mocked Git and Bun."""
from pathlib import Path
import contextlib
import importlib.util
import io
import subprocess
import sys
import tempfile
from unittest import mock

ROOT = Path(__file__).resolve().parent.parent
MODES = ('explicit-required', 'dirty-refused', 'clean-upgrade')
REFUSALS = {'explicit-required': 'different revision', 'dirty-refused': 'tracked local changes'}


def require(ok, message):
    if not ok:
        raise ValueError('BOOTSTRAP ' + message)


def load():
    spec = importlib.util.spec_from_file_location('bootstrap_bend', ROOT / 'dev/bootstrap-bend.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def control(mode):
    """Run main() once against a temporary checkout. No real command runs."""
    module = load()
    pin = module.pin
    calls = []
    head = ['0' * 40]

    def run(args, **kwargs):
        calls.append(list(args))
        if 'rev-parse' in args:
            return subprocess.CompletedProcess(args, 0, head[0] + '\n', '')
        if 'status' in args:
            dirty = ' M bend2/main.ts\n' if mode == 'dirty-refused' else ''
            return subprocess.CompletedProcess(args, 0, dirty, '')
        if 'checkout' in args:
            head[0] = pin['commit']
        return subprocess.CompletedProcess(args, 0, '', '')

    argv = ['bootstrap-bend.py', *([] if mode == 'explicit-required' else ['--upgrade'])]
    out = io.StringIO()
    error = ''
    with tempfile.TemporaryDirectory() as directory, \
            mock.patch.object(module, 'checkout', Path(directory)), \
            mock.patch.object(sys, 'argv', argv), \
            mock.patch.object(module.subprocess, 'run', run), \
            mock.patch.object(module.shutil, 'which', return_value='/bun'), \
            contextlib.redirect_stdout(out):
        try:
            module.main()
        except ValueError as caught:
            error = str(caught)
    changed = [call for call in calls
               if call[0] == '/bun' or 'fetch' in call or 'checkout' in call]
    if mode in REFUSALS:
        require(REFUSALS[mode] in error, mode + ' was not refused: ' + repr(error))
        require(not changed and not out.getvalue(), mode + ' changed the checkout')
        return
    require(not error, mode + ' refused: ' + error)
    fetches = [call for call in calls if 'fetch' in call]
    require(len(fetches) == 1 and fetches[0][-2:] == [pin['repository'], pin['commit']],
            mode + ' did not fetch the exact pin')
    require([call[-1] for call in calls if 'checkout' in call] == [pin['commit']],
            mode + ' did not check out the pin')
    require(head[0] == pin['commit'], mode + ' HEAD does not match the pin')
    require(sum(call[0] == '/bun' for call in calls) == 1, mode + ' did not build once')
    require(out.getvalue() == f"BEND TOOLCHAIN {pin['version']} {pin['commit']}\n",
            mode + ' printed ' + repr(out.getvalue()))


def main():
    for mode in MODES:
        control(mode)
    print('BOOTSTRAP controls=3 explicit-required dirty-refused clean-upgrade OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('BOOTSTRAP FAIL: ' + str(error), file=sys.stderr)
        raise SystemExit(1)

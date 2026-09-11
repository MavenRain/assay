#!/usr/bin/env python3
"""Exercise the public trace command with real geth and literal argv."""
from pathlib import Path
import importlib.util
import json
import os
import shlex
import shutil
import subprocess
import sys
import tempfile


def main():
    root = Path(__file__).resolve().parent.parent
    spec = importlib.util.spec_from_file_location('reference', root / 'dev/reference-test.py')
    ref = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(ref)
    binary = str(root / '_build/default/bin/assay.exe')
    source = root / 'examples/Ref20.asy'
    evm = shutil.which('evm')
    ref.require(evm is not None, 'TRACE-TEST-TOOL', 'evm')
    runtime, declared = ref.reference(root)
    cast = ref.listing(ref.run(root, 'trace-driver-cast', 'cast', 'disassemble', '0x' + runtime))
    cases = []
    receipts = []
    with tempfile.TemporaryDirectory(prefix='assay-trace-') as temporary:
        work = Path(temporary)
        (work / 'bin').mkdir()
        wrapper = work / 'bin/evm'
        argv_file = work / 'argv.txt'
        wrapper.write_text('#!/bin/sh\nprintf "%s\\n" "$@" > "$ASSAY_TRACE_ARGV"\nexec ' + shlex.quote(evm) + ' "$@"\n')
        wrapper.chmod(0o755)
        env = dict(os.environ, PATH=str(work / 'bin'), ASSAY_TRACE_ARGV=str(argv_file))

        def invoke(name, args, code, diagnostic='', environment=env):
            result = subprocess.run([binary, *args], cwd=work, env=environment,
                                    capture_output=True, text=True, timeout=20)
            ref.require(result.returncode == code and diagnostic in result.stderr,
                        'TRACE-DRIVER', f'{name}: {result.returncode}: {result.stdout}{result.stderr}')
            if code == 0:
                ref.require(not result.stderr, 'TRACE-DRIVER-STDERR', name)
                ref.verify_trace(runtime, declared, ref.objects(result.stdout), cast)
            receipts.append(dict(name=name, argv=[binary, *args], cwd=str(work), exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))
            cases.append(name)
            return result

        for value in ('', '0x', '0xDEADBEEF'):
            invoke('calldata-' + value, ['trace', str(source), '--calldata', value], 0)
            argv = argv_file.read_text().splitlines()
            expected = value.lower().removeprefix('0x')
            ref.require(argv[argv.index('--input') + 1] == expected and
                        argv[argv.index('--prestate') + 1] == str(root / 'evm/fixtures/cancun.json'),
                        'TRACE-ARGV', 'calldata or explicit prestate changed')
        explicit = work / 'prestate with spaces.json'
        explicit.write_bytes((root / 'evm/fixtures/cancun.json').read_bytes())
        spaced = work / 'source with spaces.asy'
        spaced.write_bytes(source.read_bytes())
        invoke('explicit', ['trace', str(spaced), '--calldata', 'aa', '--prestate', str(explicit)], 0)
        argv = argv_file.read_text().splitlines()
        ref.require(argv[argv.index('--prestate') + 1] == str(explicit), 'TRACE-ARGV', 'explicit fixture changed')
        unaccepted = work / 'source.txt'
        unaccepted.write_bytes(source.read_bytes())
        negative = [
            ('missing-calldata', ['trace', str(source)], 64, 'usage: assay'),
            ('odd-calldata', ['trace', str(source), '--calldata', '0'], 64, 'CALLDATA_HEX'),
            ('invalid-calldata', ['trace', str(source), '--calldata', 'gg'], 64, 'CALLDATA_HEX'),
            ('shell-calldata', ['trace', str(source), '--calldata', '; touch SENTINEL'], 64, 'CALLDATA_HEX'),
            ('extra-argument', ['trace', str(source), '--calldata', '', 'extra'], 64, 'usage: assay'),
            ('missing-source', ['trace', str(work / 'missing.asy'), '--calldata', ''], 64, 'cannot read'),
            ('suffix', ['trace', str(unaccepted), '--calldata', ''], 64, 'expected a .asy or .kan source'),
            ('missing-prestate', ['trace', str(source), '--calldata', '', '--prestate', str(work / 'missing.json')], 2, 'TRACE_PRESTATE'),
            ('protocol', ['trace', str(root / 'examples/m0-spine.kan'), '--calldata', ''], 2, 'M0_PROTOCOL'),
        ]
        for name, args, code, diagnostic in negative:
            invoke(name, args, code, diagnostic)
        ref.require(not (work / 'SENTINEL').exists(), 'TRACE-SHELL', 'calldata ran as shell text')
        # Review round 2026-09-11 (B-1):  a readable but non-executable evm
        # must not win the lookup, and an empty PATH entry must not resolve
        # to the working directory.
        (work / 'blocked').mkdir()
        blocked = work / 'blocked/evm'
        blocked.write_text('#!/bin/sh\nexit 9\n')
        blocked.chmod(0o644)
        invoke('non-executable-evm', ['trace', str(source), '--calldata', ''], 2, 'TRACE_TOOL',
               dict(os.environ, PATH=str(work / 'blocked')))
        invoke('non-executable-skipped', ['trace', str(source), '--calldata', ''], 0, '',
               dict(os.environ, PATH=str(work / 'blocked') + ':' + str(work / 'bin'),
                    ASSAY_TRACE_ARGV=str(argv_file)))
        cwd_tool = work / 'evm'
        cwd_tool.write_text('#!/bin/sh\nexit 9\n')
        cwd_tool.chmod(0o755)
        invoke('empty-path-entry', ['trace', str(source), '--calldata', ''], 2, 'TRACE_TOOL',
               dict(os.environ, PATH=':' + str(work / 'missing-bin')))
        invoke('missing-evm', ['trace', str(source), '--calldata', ''], 2, 'TRACE_TOOL',
               dict(os.environ, PATH=str(work / 'missing-bin')))
        damaged = json.loads(explicit.read_text())
        damaged['config'].pop('cancunTime')
        damaged['config'].pop('shanghaiTime')
        explicit.write_text(json.dumps(damaged))
        invoke('wrong-fork', ['trace', str(source), '--calldata', '', '--prestate', str(explicit)], 2, 'TRACE_EXECUTION')
        wrapper.write_text('#!/bin/sh\nexit 7\n')
        invoke('executor-exit', ['trace', str(source), '--calldata', ''], 2, 'TRACE_EXECUTOR: exit 7')
        wrapper.write_text('#!/bin/sh\nkill -TERM $$\n')
        invoke('executor-signal', ['trace', str(source), '--calldata', ''], 2, 'TRACE_EXECUTOR: signal')
    (root / '.gatework/trace-driver.json').write_text(json.dumps(receipts, indent=2) + '\n')
    print(f'TRACE-DRIVER cases={len(cases)} explicit_prestate=true literal_argv=true OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('TRACE-DRIVER FAIL ' + str(error))
        sys.exit(1)

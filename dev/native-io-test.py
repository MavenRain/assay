#!/usr/bin/env python3
"""Check production byte streams, chunk boundaries, Unicode paths and errors."""
from pathlib import Path
import json
import os
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'dev'))
import build
from bend_source import bundle, declarations, reachable


def main():
    work = ROOT / '_build/native-io'
    work.mkdir(parents=True, exist_ok=True)
    records = [r for path in (ROOT / 'src/kernel.bend', ROOT / 'src/cli.bend', ROOT / 'dev/native-io.bend')
               for r in declarations(path.read_text(), str(path))]
    source = bundle(reachable(records, 'IOTest.main'), 'IOTest.main').replace('import "./os.js"', 'import "../../src/os.js"')
    path = work / 'io.bend'
    path.write_text(source)
    bend, node = build.compiler(), build.runtime()
    result = subprocess.run([str(bend), str(path), '-o', str(work / 'io.js')], capture_output=True,
                            env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=120)
    (work / 'build.log').write_bytes(result.stdout + result.stderr)
    if result.returncode:
        raise ValueError('native IO build failed: ' + str(work / 'build.log'))
    command = [str(node), '--stack-size=65500', str(work / 'io.js')]
    cases = []

    def check(label, args, code, stdout=None):
        result = subprocess.run(command + [str(arg) for arg in args], capture_output=True, timeout=60)
        good = result.returncode == code and (stdout is None or result.stdout == stdout)
        good &= bool(result.stderr) if code else not result.stderr
        cases.append({'case': label, 'passed': good, 'exit': result.returncode})
        if not good:
            raise ValueError(label + ': unexpected byte output or status')

    with tempfile.TemporaryDirectory(prefix='assay-io-') as directory:
        temporary = Path(directory)
        source_path = temporary / 'input-é.bin'
        output_path = temporary / 'output-λ.bin'
        payload = bytes(range(256)) * 257 + b'\x00\xffend'
        source_path.write_bytes(payload)
        check('copy-all-bytes', ['copy', source_path, output_path], 0, b'')
        if output_path.read_bytes() != payload:
            raise ValueError('copy changed bytes across the 65536-byte chunk boundary')
        check('stdout-all-bytes', ['read', source_path], 0, payload)
        slow = subprocess.Popen(command + ['read', str(source_path)], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        time.sleep(0.5)
        output, errors = slow.communicate(timeout=60)
        if slow.returncode or errors or output != payload:
            raise ValueError('slow stdout reader lost bytes or failed under pipe backpressure')
        cases.append({'case': 'slow-stdout', 'passed': True, 'exit': 0})
        for name, size in (('empty', 0), ('before-chunk', 65535),
                           ('exact-chunk', 65536), ('multiple-chunks', 131072)):
            contents = (bytes(range(256)) * ((size + 255) // 256))[:size]
            source_path.write_bytes(contents)
            check('copy-' + name, ['copy', source_path, output_path], 0, b'')
            if output_path.read_bytes() != contents:
                raise ValueError('copy-' + name + ' changed bytes or failed to truncate output')
        check('unicode-argv', ['argv', 'λ/é'], 0, 'λ/é'.encode())
        check('missing-file', ['read', temporary / 'missing'], 17, b'')
        check('read-directory', ['read', temporary], 17, b'')
        check('missing-parent', ['copy', source_path, temporary / 'missing/out'], 17, b'')
        check('invalid-arguments', [], 64, b'')
    (work / 'result.json').write_text(json.dumps(cases, indent=2) + '\n')
    print(f'NATIVE-IO cases={len(cases)} bytes={len(payload)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.TimeoutExpired) as error:
        print('NATIVE-IO FAIL ' + str(error))
        raise SystemExit(1)

#!/usr/bin/env python3
"""Run committed fixtures and the direct native kernel assertions."""
from pathlib import Path
import json
import os
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
receipt = json.loads((ROOT / '_build/bend/tests.json').read_text())
COMMAND = [receipt['node'], '--stack-size=65500', str(ROOT / '_build/bend/tests.js')]


def run(args):
    result = subprocess.run(COMMAND + args, cwd=ROOT, capture_output=True, timeout=180, env=os.environ | {'ASSAY_ROOT': str(ROOT)})
    if result.returncode:
        raise ValueError(result.stderr.decode(errors='replace').strip() or result.stdout.decode(errors='replace').strip() or f'exit {result.returncode}')
    return result.stdout


def check_all(cases):
    with tempfile.TemporaryDirectory(prefix='assay-kernel-fixtures-') as temporary:
        manifest = Path(temporary) / 'cases'
        fields = []
        for kind, path, _wanted in cases:
            mode = 'parse' if kind == 'PARSE' else 'erase' if kind in ('ERASE', 'ERASE-NEG') else 'check'
            fields.extend((mode, str(path)))
        manifest.write_bytes(('\0'.join(fields) + '\0').encode())
        output = run(['batch', str(manifest)])
    results = []
    offset = 0
    for kind, path, wanted in cases:
        separator = output.find(b':', offset)
        size = output[offset:separator] if separator >= 0 else b''
        if not size or not size.isdigit():
            raise ValueError(f'missing fixture output frame for {kind} {path.name}')
        start = separator + 1
        offset = start + int(size)
        if offset > len(output):
            raise ValueError(f'truncated fixture output for {kind} {path.name}')
        got = output[start:offset]
        detail = '' if got == wanted else f'expected {wanted[:160]!r}, observed {got[:160]!r}'
        results.append((kind, path.stem, got == wanted, detail))
    if offset != len(output):
        raise ValueError('unexpected trailing fixture output')
    return results


def main():
    if len(sys.argv) > 2:
        raise ValueError('usage: kernel-suite.py [TEST_ROOT]')
    folder = Path(sys.argv[1]) if len(sys.argv) == 2 else ROOT / 'test'
    folder = folder.resolve()
    groups = {name: sorted((folder / name).glob('*.kan')) for name in ('fixtures', 'neg', 'erase-neg')}
    if not groups['fixtures'] or not groups['neg']:
        raise ValueError('fixture and negative groups must be nonempty')
    cases = [('PARSE', path, b'ROUNDTRIP OK\n') for paths in groups.values() for path in paths]
    for path in groups['fixtures']:
        for kind, extension in [('CHECK', 'checked'), ('ERASE', 'erased')]:
            cases.append((kind, path, b'OK\n' + (folder / 'golden' / (path.stem + '.' + extension)).read_bytes()))
    for group, kind in [('neg', 'NEG'), ('erase-neg', 'ERASE-NEG')]:
        for path in groups[group]:
            cases.append((kind, path, b'ERR\n' + path.with_suffix('.err').read_bytes().strip()))
    results = check_all(cases)
    for kind, name, good, detail in results:
        print(f'{kind} {name} {"OK" if good else "FAIL"}' + (': ' + detail if detail else ''))
    for kind in ('PARSE', 'CHECK', 'ERASE', 'NEG', 'ERASE-NEG'):
        rows = [r for r in results if r[0] == kind]
        print(f'{kind}-OK {sum(r[2] for r in rows)}/{len(rows)}')
    assertions = run(['kernel'])
    sys.stdout.write(assertions.decode())
    migrated = ['mu-erase', 'mu-rec-direct', 'mu-rec-indexed', 'mu-rec-mutual']
    for name in migrated:
        good = name in {p.stem for p in groups['fixtures']}
        results.append(('MIGRATED', name, good, ''))
        print(f'MIGRATED {name} {"OK" if good else "FAIL"}')
    good = all(row[2] for row in results)
    print('SUITE-KERNEL ' + ('OK' if good else 'FAIL'))
    return 0 if good else 1


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'SUITE {error}\nSUITE-KERNEL FAIL')
        raise SystemExit(1)

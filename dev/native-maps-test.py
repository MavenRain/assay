#!/usr/bin/env python3
"""Compare map operations and logarithmic height against a Python dictionary."""
import json
import math
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'dev'))
import build
from bend_source import bundle, declarations, reachable


def main():
    orders = [[3, 2, 1], [1, 2, 3], [3, 1, 2], [1, 3, 2],
              list(range(257)), list(reversed(range(257))),
              [(index * 73) % 257 for index in range(257)]]
    expected = []
    entry = '@unsafe\ndef MapTest.main() -> IO(Unit):\n  do IO<Unit>:\n'
    for keys in orders:
        entry += '    MapTest.run([' + ', '.join(str(k) + 'n' for k in keys) + '])\n'
        value = {key: key * 3 for key in keys}
        snapshots = [dict(value)]
        value[7] = 999
        snapshots.append(dict(value))
        value.pop(8, None)
        snapshots.append(dict(value))
        value = {key: item + 5 for key, item in value.items()}
        snapshots.append(dict(value))
        for key in (3, 7, 12, 1000):
            value[key] = value.get(key, 0) + key * 3
        snapshots.append(dict(value))
        for values in snapshots:
            rows = ''.join(f'{key}:{values[key]},' for key in sorted(values))
            lookups = ''.join(str(values.get(key, 'none')) + ',' for key in keys)
            expected.append((rows + '|' + lookups, 2 * math.ceil(math.log2(len(values) + 1))))
    entry += '    return Unit{}\n'
    records = [r for path in (ROOT / 'src/kernel.bend', ROOT / 'src/cli.bend', ROOT / 'dev/native-maps.bend') for r in declarations(path.read_text(), str(path))]
    records.extend(declarations(entry, '<map-test>'))
    source = bundle(reachable(records, 'MapTest.main'), 'MapTest.main').replace('import "./os.js"', 'import "../../src/os.js"')
    work = ROOT / '_build/native-maps'
    work.mkdir(parents=True, exist_ok=True)
    path = work / 'test.bend'
    path.write_text(source)
    compiler = build.compiler()
    compiled = subprocess.run([str(compiler), str(path), '-o', str(work / 'test.js')], capture_output=True, text=True, timeout=120)
    (work / 'build.log').write_text(compiled.stdout + compiled.stderr)
    if compiled.returncode:
        raise ValueError('native map test compilation failed: ' + str(work / 'build.log'))
    result = subprocess.run([build.runtime(), '--stack-size=65500', str(work / 'test.js')], capture_output=True, text=True, timeout=60)
    lines = result.stdout.splitlines()
    if result.returncode or len(lines) != len(expected):
        raise ValueError(f'map runtime exit={result.returncode} cases={len(lines)}/{len(expected)}: {result.stderr}')
    for index, (line, (content, bound)) in enumerate(zip(lines, expected)):
        height, actual = line.split('|', 1)
        if actual != content or not 0 < int(height) <= bound:
            raise ValueError(f'map case {index}: content or height differs')
    (work / 'result.json').write_text(json.dumps({'cases': len(expected), 'passed': len(expected)}) + '\n')
    print(f'NATIVE-MAPS cases={len(expected)} OK')


if __name__ == '__main__':
    main()

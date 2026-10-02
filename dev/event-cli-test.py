#!/usr/bin/env python3
"""Check public event encoding against cast, with strict CLI refusals."""
from dataclasses import replace
from pathlib import Path
import hashlib
import importlib.util
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'dev'))
from cli_delta import cli_sources, source_records, only, pinned, PINS

spec = importlib.util.spec_from_file_location('event_oracles', ROOT / 'dev/event-codec-test.py')
EVENT = importlib.util.module_from_spec(spec)
spec.loader.exec_module(EVENT)


def call(args):
    return subprocess.run([str(ROOT / '_build/bin/assay'), 'event-encode', *args],
                          cwd=ROOT, capture_output=True, text=True, timeout=30)


def oracle(name, types, flags, values, anonymous):
    def cast_value(typ, value):
        # ABI bytes and string have identical head, length and padding rules.
        # Hex bytes let cast accept arbitrary CLI text without its string parser.
        return '0x' + value if typ == 'string' else EVENT.cast_value(typ, value)

    topics = [] if anonymous else [EVENT.keccak((name + '(' + ','.join(types) + ')').encode())]
    plain_types, plain_values = [], []
    for typ, indexed, value in zip(types, flags, values, strict=True):
        if indexed:
            topics.append(EVENT.keccak(bytes.fromhex(value)) if typ == 'string' else
                          EVENT.run(ROOT, 'cast', 'abi-encode', 'f(' + typ + ')', cast_value(typ, value))[2:])
        else:
            plain_types.append('bytes' if typ == 'string' else typ)
            plain_values.append(cast_value(typ, value))
    data = EVENT.run(ROOT, 'cast', 'abi-encode', 'f(' + ','.join(plain_types) + ')', *plain_values)[2:] if plain_types else ''
    return EVENT.decode('OK ' + ','.join(topics) + '|' + data)


def vectors():
    rows = []

    def add(name, fields=(), anonymous=False):
        args = [name] + (['--anonymous'] if anonymous else [])
        types, flags, values = [], [], []
        for typ, indexed, value in fields:
            args += [typ, 'indexed' if indexed else 'data', str(value)]
            types.append(typ)
            flags.append(indexed)
            values.append(value.encode('utf-8').hex() if typ == 'string' else
                          str(int(value, 16)) if str(value).startswith('0x') else str(value))
        expected = oracle(name, types, flags, values, anonymous)
        rows.append(dict(name=name, args=args, expected=expected))

    add('Empty')
    add('AnonymousEmpty', anonymous=True)
    add('_')
    add('A0_')
    add('Transfer', [('address', True, '0x01'), ('address', True, '0x02'), ('uint256', False, 3)])
    add('Approval', [('address', True, (1 << 160) - 1), ('address', True, 0), ('uint256', False, (1 << 256) - 1)])
    add('TopicOrder', [('uint8', True, n) for n in (1, 2, 3)])
    add('DataOrder', [('uint8', False, n) for n in (1, 2, 3, 4, 5)])
    add('FourTopics', [('uint8', True, n) for n in (1, 2, 3, 4)], True)
    add('Mixed', [('string', False, 'a'), ('uint8', True, 7), ('string', True, 'bc'), ('string', False, 'd')])
    for typ, values in [('uint8', [0, 255, '0xff']),
                        ('uint256', [0, 1 << 255, (1 << 256) - 1, '0xabc']),
                        ('address', [0, (1 << 160) - 1, '0x1234']),
                        ('bool', ['false', 'true'])]:
        for index, value in enumerate(values):
            for indexed in (False, True):
                add(f'Boundary_{typ}_{index}_{int(indexed)}', [(typ, indexed, value)])
    for index, text in enumerate(['', 'abc', '|', '--anonymous', '"\\\n\t', 'é', '🧪']):
        for indexed in (False, True):
            add(f'String_{index}_{int(indexed)}', [('string', indexed, text)])
    for size in (31, 32, 33, 63, 64, 65):
        add(f'StringSize{size}', [('string', False, 'a' * size), ('bool', True, 'true')])
    add('DecimalCap', [('uint256', False, '0' * 77 + '1')])
    add('HexCap', [('uint256', True, '0x' + '0' * 63 + '1')])
    return rows


def refusals():
    rows = [([], 'usage:'), ([''], 'ASCII event identifier'),
            (['1Bad'], 'ASCII event identifier'), (['Bad Name'], 'ASCII event identifier'),
            (['é'], 'ASCII event identifier'), (['--anonymous'], 'ASCII event identifier'),
            (['E', 'uint8'], 'expected TYPE indexed|data VALUE triples'),
            (['E', 'uint8', 'indexed'], 'expected TYPE indexed|data VALUE triples'),
            (['E', 'uint16', 'data', '0'], 'unsupported field type'),
            (['E', 'Uint8', 'data', '0'], 'unsupported field type'),
            (['E', 'uint8', 'true', '0'], 'expected indexed or data'),
            (['E', '--anonymous', '--anonymous'], 'expected TYPE indexed|data VALUE triples')]
    for typ, bits in [('uint8', 8), ('address', 160), ('uint256', 256)]:
        for mode in ('data', 'indexed'):
            rows.append((['E', typ, mode, str(1 << bits)],
                         'word exceeds uint256' if bits == 256 else 'value exceeds ' + typ))
    for value in ('', '-1', '+1', '0x', '0xgg', '1.0', ' 1', '1 ', '0' * 79, '0x' + '0' * 65):
        rows.append((['E', 'uint256', 'data', value], 'expected a decimal or 0x-prefixed uint256'))
    for value in ('0', '1', '2', 'TRUE', 'False', ''):
        rows.append((['E', 'bool', 'data', value], 'expected true or false'))
    for anonymous, count in [(False, 4), (True, 5)]:
        rows.append((['E'] + (['--anonymous'] if anonymous else []) +
                     ['uint8', 'indexed', '1'] * count, 'too many indexed fields'))
    if len({tuple(args) for args, _ in rows}) != len(rows):
        raise ValueError('DUPLICATE-REFUSAL')
    return rows


def compatibility():
    records = source_records(ROOT, '10f1f96')
    before, after = cli_sources(records)
    if before != after:
        raise ValueError('COMPATIBILITY changed a carried CLI declaration')
    for name in ('Cli.usage', 'Cli.dispatch'):
        row = only(records[1], name)
        if row is None or hashlib.sha256(row.source.encode()).hexdigest() != PINS[name]:
            raise ValueError('MISSING-PIN ' + name)
        changed = [replace(item, source=item.source + '\n') if item.key == row.key else item
                   for item in records[1]]
        if pinned(records[0], changed) is not None:
            raise ValueError('PIN-CONTROL ' + name)


def main():
    if len(sys.argv) != 1:
        raise ValueError('usage: event-cli-test.py')
    compatibility()
    rows = vectors()
    for row in rows:
        result = call(row['args'])
        want = json.dumps(row['expected'], separators=(',', ':'), ensure_ascii=True) + '\n'
        if result.returncode or result.stderr or result.stdout != want:
            raise ValueError(f"ANSWER {row['name']}: {result.returncode}: {result.stdout!r} {result.stderr!r} != {want!r}")
    negative = refusals()
    for args, marker in negative:
        result = call(args)
        if (result.returncode != 64 or result.stdout or
                not result.stderr.startswith('assay: event-encode: ') or marker not in result.stderr):
            raise ValueError(f'REFUSAL {args!r}: {result.returncode}: {result.stdout!r} {result.stderr!r}')
    work = ROOT / '.gatework/event-cli'
    work.mkdir(parents=True, exist_ok=True)
    report = dict(version=1, cases=rows, refusals=len(negative), compatibility='OK', pin_controls=2,
                  sources={path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                           for path in ('src/cli.bend', 'src/abi.bend', 'src/keccak.bend',
                                        'dev/event-cli-test.py', 'dev/event-codec-test.py', 'dev/cli_delta.py')})
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'EVENT-CLI cases={len(rows)} oracle=cast refusals={len(negative)} OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, subprocess.TimeoutExpired, OSError) as error:
        print('EVENT-CLI FAIL: ' + str(error), file=sys.stderr)
        sys.exit(1)

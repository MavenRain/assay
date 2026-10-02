#!/usr/bin/env python3
"""Check public event decoding against cast logs and strict refusals."""
from pathlib import Path
import hashlib
import importlib.util
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'dev'))
from cli_delta import cli_sources, source_records

spec = importlib.util.spec_from_file_location('event_cli', ROOT / 'dev/event-cli-test.py')
ENCODE = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ENCODE)


def call(args):
    return subprocess.run([str(ROOT / '_build/bin/assay'), 'event-decode', *args],
                          cwd=ROOT, capture_output=True, text=True, timeout=30)


def args(name, log, fields=(), anonymous=False):
    return ([name] + (['--anonymous'] if anonymous else []) +
            ['--topics', ','.join(log['topics']), '--data', log['data']] +
            [part for typ, indexed in fields for part in (typ, 'indexed' if indexed else 'data')])


def vectors():
    rows = []
    for row in ENCODE.vectors():
        source = row['args']
        anonymous = source[1:2] == ['--anonymous']
        fields, values = [], []
        topic = 0 if anonymous else 1
        for i in range(2 if anonymous else 1, len(source), 3):
            typ, flag, value = source[i:i + 3]
            indexed = flag == 'indexed'
            fields.append((typ, indexed))
            if typ == 'string':
                key = 'hash' if indexed else 'bytes'
                decoded = row['expected']['topics'][topic] if indexed else '0x' + value.encode().hex()
            else:
                key = 'value'
                word = int(value, 16 if value.lower().startswith('0x') else 10) if typ != 'bool' else None
                decoded = value == 'true' if typ == 'bool' else f'0x{word:040x}' if typ == 'address' else str(word)
            values.append(dict(type=typ, **{key: decoded}))
            topic += indexed
        rows.append(dict(name=row['name'], args=args(source[0], row['expected'], fields, anonymous),
                         expected=dict(values=values)))

    # Exercise arbitrary ABI bytes beyond the UTF-8 text accepted by event-encode.
    raw = '00ff80c328000102'
    log = ENCODE.oracle('Raw', ['string', 'string'], [True, False], [raw, raw], False)
    rows.append(dict(name='Raw', args=args('Raw', log, [('string', True), ('string', False)]),
                     expected=dict(values=[dict(type='string', hash=log['topics'][1]),
                                           dict(type='string', bytes='0x' + raw)])))
    # Hashes are opaque, so decoding must accept an arbitrary indexed string topic.
    log = dict(topics=['0x' + 'ff' * 32], data='0x')
    rows.append(dict(name='Opaque', args=args('Opaque', log, [('string', True)], True),
                     expected=dict(values=[dict(type='string', hash=log['topics'][0])])))
    # Accept uppercase prefixes/digits and bare hex without changing the result.
    source = rows[-2]
    altered = source['args'].copy()
    altered[2] = altered[2].upper()
    altered[4] = altered[4][2:].upper()
    rows.append(dict(name='HexCase', args=altered, expected=source['expected']))
    return rows


def refusals():
    empty = ENCODE.oracle('Empty', [], [], [], False)
    base = args('Empty', empty)
    result = [([], 'usage:'), (['Empty'], 'usage:'),
              (['9Invalid', *base[1:]], 'ASCII event identifier'),
              (['Bad-name', *base[1:]], 'ASCII event identifier'),
              (['é', *base[1:]], 'ASCII event identifier'),
              ([*base, 'bytes32', 'data'], 'unsupported field type'),
              ([*base, 'uint8', 'other'], 'expected indexed or data'),
              ([*base, 'uint8'], 'expected TYPE indexed|data pairs'),
              ([*base, '--anonymous'], 'expected TYPE indexed|data pairs'),
              (['Empty', '--data', '0x', '--topics', base[2]], 'usage:'),
              (['Empty', '--topics', base[2]], 'usage:'),
              (['Empty', '--topics', base[2], '--date', '0x'], 'usage:'),
              (['Empty', '--topics', base[2], '--anonymous', '--data', '0x'], 'usage:'),
              ([*base, '--topics', base[2]], 'unsupported field type')]
    for value in ('0x0', '0xgg', '0x01 02', '0x0x00', 'é', '0x\n00'):
        result.append((['Empty', '--topics', value, '--data', '0x'], 'even-length hexadecimal'))
        result.append((['Empty', '--topics', base[2], '--data', value], 'even-length hexadecimal'))
    for topics, marker in [('', 'topic count'), (base[2] + ',' + base[2], 'topic count'),
                           ('0x', 'exactly 32 bytes'), ('0x' + '00' * 31, 'exactly 32 bytes'),
                           ('0x' + '00' * 33, 'exactly 32 bytes'),
                           ('0x' + '00' * 32, 'signature does not match'),
                           (base[2] + ',', 'topic count'), (',' + base[2], 'topic count')]:
        result.append((['Empty', '--topics', topics, '--data', '0x'], marker))
    result.append((args('Empty', dict(topics=[], data='0x00'), anonymous=True), 'trailing data'))
    # Each topic and the data accept at most 131072 bytes, which keeps the
    # byte parser within the native stack.
    result.append((args('Empty', dict(topics=[], data='0x' + '00' * 131072), anonymous=True),
                   'trailing data'))
    result.append((args('Empty', dict(topics=[], data='0x' + '00' * 131073), anonymous=True),
                   'exceeds 131072 bytes'))
    result.append((['Empty', '--topics', '0x' + '00' * 131073, '--data', '0x'], 'exceeds 131072 bytes'))
    for anonymous, count in ((False, 4), (True, 5)):
        result.append((args('Limit', dict(topics=[], data='0x'), [('uint8', True)] * count, anonymous),
                       'too many indexed fields'))
    for typ, value, marker in [('bool', 2, 'invalid boolean'), ('uint8', 256, 'value exceeds uint8'),
                               ('address', 1 << 160, 'value exceeds address')]:
        word = f'0x{value:064x}'
        result.append((args('Scalar', dict(topics=[word], data='0x'), [(typ, True)], True), marker))
        result.append((args('Scalar', dict(topics=[], data=word), [(typ, False)], True), marker))
    for data, marker in [('', 'truncated value'), ('00' * 31, 'truncated value'),
                          ('00' * 64, 'trailing data')]:
        result.append((args('Scalar', dict(topics=[], data='0x' + data), [('uint256', False)], True), marker))
    word = lambda value: f'{value:064x}'
    for data, marker in [(word(64) + word(0), 'invalid offset'), (word(32), 'truncated value'),
                          (word(32) + word(1), 'truncated value'),
                          (word(32) + word(1) + 'ff' + '00' * 30 + '01', 'nonzero padding'),
                          (word(32) + word(0) + word(0), 'trailing data')]:
        result.append((args('Text', dict(topics=[], data='0x' + data), [('string', False)], True), marker))
    return result


def main():
    if len(sys.argv) != 1:
        raise ValueError('usage: event-decode-cli-test.py')
    before, after = cli_sources(source_records(ROOT, '7bca8dc'))
    if before != after:
        raise ValueError('COMPATIBILITY changed a carried CLI declaration')
    rows = vectors()
    for row in rows:
        result = call(row['args'])
        want = json.dumps(row['expected'], separators=(',', ':')) + '\n'
        if result.returncode or result.stderr or result.stdout != want:
            raise ValueError(f"ANSWER {row['name']}: {result.returncode}: {result.stdout!r} {result.stderr!r} != {want!r}")
    negative = refusals()
    for argv, marker in negative:
        result = call(argv)
        if (result.returncode != 64 or result.stdout or
                not result.stderr.startswith('assay: event-decode: ') or marker not in result.stderr):
            raise ValueError(f'REFUSAL {argv!r}: {result.returncode}: {result.stdout!r} {result.stderr!r}')
    work = ROOT / '.gatework/event-decode-cli'
    work.mkdir(parents=True, exist_ok=True)
    report = dict(version=1, cases=rows, refusals=len(negative), compatibility='OK',
                  sources={path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                           for path in ('src/cli.bend', 'src/abi.bend', 'src/keccak.bend',
                                        'dev/event-decode-cli-test.py', 'dev/event-cli-test.py',
                                        'dev/event-codec-test.py', 'dev/cli_delta.py')})
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'EVENT-DECODE-CLI cases={len(rows)} oracle=cast refusals={len(negative)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('EVENT-DECODE-CLI FAIL:', error, file=sys.stderr)
        sys.exit(1)

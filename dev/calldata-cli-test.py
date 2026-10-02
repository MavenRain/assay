#!/usr/bin/env python3
"""Compare public function calldata with cast and reject noncanonical payloads."""
from dataclasses import replace
from pathlib import Path
import hashlib
import json
import random
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'dev'))
from cli_delta import cli_sources, source_records, only, pinned, PINS


def run(*args):
    result = subprocess.run(args, cwd=ROOT, capture_output=True, text=True, timeout=30)
    if result.returncode or result.stderr:
        raise ValueError(f'ORACLE {args[:3]}: {result.stdout!r} {result.stderr!r}')
    return result.stdout.strip()


def call(command, args):
    return subprocess.run([str(ROOT / '_build/bin/assay'), command, *args],
                          cwd=ROOT, capture_output=True, text=True, timeout=30)


def selector(name, types):
    return run('cast', 'sig', name + '(' + ','.join(types) + ')')


def oracle(name, types, values):
    abi_types, abi_values = [], []
    for typ, value in zip(types, values, strict=True):
        abi_types.append('bytes' if typ == 'string' else typ)
        if typ == 'string':
            abi_values.append('0x' + value.encode('utf-8').hex())
        elif typ == 'address':
            abi_values.append(f'0x{number(value):040x}')
        else:
            abi_values.append(value)
    # String and bytes share tuple layout. The selector always uses string.
    encoded = run('cast', 'abi-encode', 'f(' + ','.join(abi_types) + ')', *abi_values)
    return selector(name, types) + encoded[2:]


def number(text):
    return int(text, 16 if text.lower().startswith('0x') else 10)


def decoded(types, values):
    result = []
    for typ, text in zip(types, values, strict=True):
        if typ == 'string':
            value = dict(type=typ, bytes='0x' + text.encode('utf-8').hex())
        elif typ == 'bool':
            value = dict(type=typ, value=text == 'true')
        elif typ == 'address':
            value = dict(type=typ, value=f'0x{number(text):040x}')
        else:
            value = dict(type=typ, value=str(number(text)))
        result.append(value)
    return dict(values=result)


def vectors():
    rows = [('Empty', [], [])]
    for typ, values in [('uint8', ['0', '1', '255', '0xff']),
                        ('uint256', ['0', '0007', '0X01', str(2**256 - 1), '0x' + 'ff' * 32]),
                        ('address', ['0', '1', '0x' + 'ff' * 20]),
                        ('bool', ['true', 'false']),
                        ('string', ['', 'hello', 'quote"slash\\\n', 'caf\u00e9 \U0001d11e',
                                    'x' * 31, 'x' * 32, 'x' * 33, 'x' * 63, 'x' * 64])]:
        rows.extend(('Input', [typ], [value]) for value in values)
    rows.extend([
        ('transfer', ['address', 'uint256'], ['0x' + '12' * 20, '100']),
        ('approve', ['address', 'uint256'], ['0x' + 'ab' * 20, str(2**256 - 1)]),
        ('Mixed', ['uint8', 'string', 'address', 'bool', 'uint256', 'string'],
         ['255', 'first', '1', 'false', '0x1234', 'second']),
        ('Text', ['string', 'string', 'string'], ['', 'x' * 33, 'last']),
    ])
    rng = random.Random(20261001)
    for i in range(24):
        types = [rng.choice(['uint8', 'uint256', 'address', 'bool', 'string'])
                 for _ in range(1 + i % 6)]
        values = []
        for typ in types:
            if typ == 'bool':
                values.append(rng.choice(['true', 'false']))
            elif typ == 'string':
                values.append(''.join(rng.choice('abc\u00e9"\\\n') for _ in range(rng.randrange(66))))
            else:
                bits = {'uint8': 8, 'uint256': 256, 'address': 160}[typ]
                values.append(str(rng.getrandbits(bits)))
        rows.append(('Random' + str(i), types, values))
    return rows


def refusals():
    result = []
    encode = lambda args, marker: result.append(('calldata-encode', args, marker))
    decode = lambda args, marker: result.append(('calldata-decode', args, marker))
    encode([], 'usage:')
    decode([], 'usage:')
    decode(['f'], 'usage:')
    for name in ['', '1name', 'bad-name', '\u00e9', 'name()']:
        encode([name], 'ASCII function identifier')
        decode([name, '0x'], 'ASCII function identifier')
    encode(['f', 'uint8'], 'TYPE VALUE pairs')
    for typ in ['bytes', 'uint16', 'uint', '--anonymous']:
        encode(['f', typ, '1'], 'unsupported input type')
        decode(['f', '0x', typ], 'unsupported input type')
    for text in ['-1', '+1', '1.0', '', '0x', '0xgg', '0x-1']:
        encode(['f', 'uint256', text], 'expected a decimal or 0x-prefixed uint256')
    encode(['f', 'uint256', str(2**256)], 'word exceeds uint256')
    encode(['f', 'uint256', '0x1' + '00' * 32], 'expected a decimal or 0x-prefixed uint256')
    for typ, text in [('uint8', '256'), ('address', str(2**160))]:
        encode(['f', typ, text], 'value exceeds ' + typ)
    for text in ['1', '0', 'True', 'FALSE']:
        encode(['f', 'bool', text], 'expected true or false')
    for text in ['0x0', '0xgg', '0xzz', '0x00 00']:
        decode(['f', text], 'even-length hexadecimal bytes')
    decode(['f', '0x' + '00' * 131073], 'exceeds 131072 bytes')
    decode(['f', '00' * 131073], 'exceeds 131072 bytes')
    # The cap counts the selector. 131072 bytes pass the cap, but valid
    # calldata has 4 + 32k bytes, so this input fails on trailing data.
    decode(['f', selector('f', []) + '00' * 131068], 'trailing data')
    # Encoded calldata has the same cap. A 130977-byte string pads to 131008
    # bytes, so 4 + 64 + 131008 = 131076. 4096 words give 4 + 131072 bytes.
    encode(['f', 'string', 'a' * 130977], 'calldata exceeds 131072 bytes')
    encode(['f', *['bool', 'true'] * 4096], 'calldata exceeds 131072 bytes')
    word = lambda value: f'{value:064x}'
    for typ, value, marker in [('uint8', 256, 'value exceeds uint8'),
                               ('address', 2**160, 'value exceeds address'),
                               ('bool', 2, 'invalid boolean value')]:
        decode(['f', selector('f', [typ]) + word(value), typ], marker)
    scalar = selector('f', ['uint256']) + word(7)
    decode(['g', scalar, 'uint256'], 'function selector does not match')
    decode(['f', '0x00000000' + scalar[10:], 'uint256'], 'function selector does not match')
    decode(['f', scalar + word(0), 'uint256'], 'trailing data')
    decode(['f', selector('f', []) + '00'], 'trailing data')
    head = selector('f', ['string'])
    for payload, marker in [(word(0), 'invalid offset'), (word(64) + word(0), 'invalid offset'),
                             (word(33) + word(0), 'invalid offset'), (word(32), 'truncated value'),
                             (word(32) + word(1), 'truncated value'),
                             (word(32) + word(1) + 'ff' + '00' * 30 + '01', 'nonzero padding'),
                             (word(32) + word(0) + word(0), 'trailing data')]:
        decode(['f', head + payload, 'string'], marker)
    for payload, types in [(scalar, ['uint256']), (oracle('f', ['string'], ['x']), ['string'])]:
        for end in range(2, len(payload), 2):
            decode(['f', payload[:end], *types],
                   'truncated function selector' if end < 10 else 'truncated value')
    return result


def expect(command, args, expected):
    result = call(command, args)
    want = json.dumps(expected, separators=(',', ':')) + '\n'
    if result.returncode or result.stderr or result.stdout != want:
        raise ValueError(f'ANSWER {command} {args[:4]}: {result.returncode}: '
                         f'{result.stdout!r} {result.stderr!r} != {want!r}')


def compatibility():
    records = source_records(ROOT, '4cf4ebc')
    before, after = cli_sources(records)
    if before != after:
        raise ValueError('COMPATIBILITY changed a carried CLI declaration')
    for name in ('Cli.usage', 'Cli.dispatch'):
        row = only(records[1], name)
        if row is None or hashlib.sha256(row.source.encode()).hexdigest() != PINS[name]:
            raise ValueError('PIN mismatch: ' + name)
        changed = [replace(item, source=item.source + '\n') if item.key == row.key else item
                   for item in records[1]]
        if pinned(records[0], changed) is not None:
            raise ValueError('PIN mutant survived: ' + name)


def main():
    if len(sys.argv) != 1:
        raise ValueError('usage: calldata-cli-test.py')
    compatibility()
    rows = []
    for name, types, values in vectors():
        payload = oracle(name, types, values)
        arguments = [name]
        for typ, value in zip(types, values, strict=True):
            arguments.extend([typ, value])
        expect('calldata-encode', arguments, dict(calldata=payload))
        expected = decoded(types, values)
        expect('calldata-decode', [name, payload, *types], expected)
        rows.append(dict(name=name, types=types, values=values, calldata=payload, decoded=expected))
    payload = rows[-1]['calldata']
    for hex_text in [payload[2:], '0X' + payload[2:].upper()]:
        expect('calldata-decode', [rows[-1]['name'], hex_text, *rows[-1]['types']], rows[-1]['decoded'])
    # ABI string is a byte sequence. Decoding must preserve non-UTF-8 and NUL bytes.
    binary = selector('Binary', ['string']) + f'{32:064x}{2:064x}' + 'ff00' + '00' * 30
    expect('calldata-decode', ['Binary', binary, 'string'], dict(values=[dict(type='string', bytes='0xff00')]))
    # A 130976-byte string gives 4 + 64 + 130976 = 131044 bytes, the largest
    # string calldata within the 131072-byte cap.
    near = 'a' * 130976
    expect('calldata-encode', ['f', 'string', near], dict(calldata=oracle('f', ['string'], [near])))
    encodes = len(rows) + 1
    negative = refusals()
    for command, args, marker in negative:
        result = call(command, args)
        if (result.returncode != 64 or result.stdout or
                not result.stderr.startswith('assay: ' + command + ': ') or
                (marker is not None and marker not in result.stderr)):
            raise ValueError(f'REFUSAL {command} {args[:3]}: {result.returncode}: '
                             f'{result.stdout!r} {result.stderr!r}')
    usage = subprocess.run([str(ROOT / '_build/bin/assay')], cwd=ROOT,
                           capture_output=True, text=True, timeout=30)
    if usage.returncode != 64 or usage.stdout or any(command not in usage.stderr
            for command in ('calldata-encode', 'calldata-decode')):
        raise ValueError('USAGE missing calldata commands')
    work = ROOT / '.gatework/calldata-cli'
    work.mkdir(parents=True, exist_ok=True)
    report = dict(version=1, vectors=rows, encode_cases=encodes, decode_cases=len(rows) + 3,
                  refusals=len(negative), compatibility='OK', pin_mutants=2,
                  sources={path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                           for path in ('src/cli.bend', 'src/abi.bend',
                                        'src/keccak.bend', 'dev/calldata-cli-test.py', 'dev/cli_delta.py')})
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'CALLDATA-CLI encode={encodes} decode={len(rows) + 3} oracle=cast '
          f'refusals={len(negative)} pin_mutants=2 OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('CALLDATA-CLI FAIL:', error, file=sys.stderr)
        sys.exit(1)

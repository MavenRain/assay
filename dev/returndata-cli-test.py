#!/usr/bin/env python3
"""Compare public function returns with cast and reject noncanonical ABI tuples."""
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

spec = importlib.util.spec_from_file_location('calldata_oracle', ROOT / 'dev/calldata-cli-test.py')
oracle = importlib.util.module_from_spec(spec)
spec.loader.exec_module(oracle)


def call(command, args):
    return subprocess.run([str(ROOT / '_build/bin/assay'), command, *args],
                          cwd=ROOT, capture_output=True, text=True, timeout=30)


def expect(command, args, expected):
    result = call(command, args)
    want = json.dumps(expected, separators=(',', ':')) + '\n'
    if result.returncode or result.stderr or result.stdout != want:
        raise ValueError(f'ANSWER {command} {brief(args)}: {result.returncode}: '
                         f'{result.stdout[:200]!r} {result.stderr!r} != {want[:200]!r}')


def brief(args):
    return [arg if len(arg) <= 80 else arg[:80] + '...' for arg in args[:3]]


def compatibility():
    records = source_records(ROOT, 'f8a8b1b')
    if cli_sources(records)[0] != cli_sources(records)[1]:
        raise ValueError('COMPATIBILITY changed a carried CLI declaration')
    for name in ('Cli.usage', 'Cli.dispatch'):
        row = only(records[1], name)
        if row is None or hashlib.sha256(row.source.encode()).hexdigest() != PINS[name]:
            raise ValueError('PIN mismatch: ' + name)
        changed = [replace(item, source=item.source + '\n') if item.key == row.key else item
                   for item in records[1]]
        if pinned(records[0], changed) is not None:
            raise ValueError('PIN mutant survived: ' + name)


def refusals():
    rows = []
    encode = lambda args, marker: rows.append(('returndata-encode', args, marker))
    decode = lambda args, marker: rows.append(('returndata-decode', args, marker))
    decode([], 'usage:')
    encode(['uint8'], 'TYPE VALUE pairs')
    for typ in ('bytes', 'uint16', 'uint', '--anonymous'):
        encode([typ, '1'], 'unsupported input type')
        decode(['0x', typ], 'unsupported input type')
    for text in ('-1', '+1', '1.0', '', '0x', '0xgg', '0x-1'):
        encode(['uint256', text], 'expected a decimal or 0x-prefixed uint256')
    encode(['uint256', str(2**256)], 'word exceeds uint256')
    # Over-long spellings are refused even when the value fits.
    for text in ('0' * 78 + '1', '0x' + '0' * 64 + '1'):
        encode(['uint256', text], 'expected a decimal or 0x-prefixed uint256')
    for typ, text in [('uint8', '256'), ('address', str(2**160))]:
        encode([typ, text], 'value exceeds ' + typ)
    for text in ('1', '0', 'True', 'FALSE'):
        encode(['bool', text], 'expected true or false')
    for text in ('0x0', '0xgg', '0xzz', '0x00 00'):
        decode([text], 'even-length hexadecimal bytes')
    for text in ('0x' + '00' * 131073, '00' * 131073):
        decode([text], 'exceeds 131072 bytes')
    encode(['string', 'a' * 131009], 'returndata exceeds 131072 bytes')
    encode(['bool', 'true'] * 4097, 'returndata exceeds 131072 bytes')
    word = lambda value: f'{value:064x}'
    decode(['0x00'], 'trailing data')
    decode(['0x' + word(7) + word(0), 'uint256'], 'trailing data')
    for typ, value, marker in [('uint8', 256, 'value exceeds uint8'),
                               ('address', 2**160, 'value exceeds address'),
                               ('bool', 2, 'invalid boolean value')]:
        decode(['0x' + word(value), typ], marker)
    for payload, marker in [(word(0), 'invalid offset'),
                             (word(64) + word(0), 'invalid offset'),
                             (word(33) + word(0), 'invalid offset'),
                             (word(32), 'truncated value'),
                             (word(32) + word(1), 'truncated value'),
                             (word(32) + word(1) + 'ff' + '00' * 30 + '01', 'nonzero padding'),
                             (word(32) + word(0) + word(0), 'trailing data')]:
        decode(['0x' + payload, 'string'], marker)
    for payload, types in [(word(7), ['uint256']),
                            (word(32) + word(1) + '78' + '00' * 31, ['string'])]:
        for end in range(0, len(payload), 2):
            decode(['0x' + payload[:end], *types], 'truncated value')
    # Two dynamic tails must follow declaration order and must not overlap.
    for payload in (word(64) + word(64) + word(0),
                    word(96) + word(64) + word(0) + word(0)):
        decode(['0x' + payload, 'string', 'string'], 'invalid offset')
    return rows


def main():
    compatibility()
    rows = oracle.vectors()
    for _, types, values in rows:
        encoded = '0x' + oracle.oracle('f', types, values)[10:]
        pairs = [item for pair in zip(types, values, strict=True) for item in pair]
        expect('returndata-encode', pairs, dict(returndata=encoded))
        expect('returndata-decode', [encoded, *types], oracle.decoded(types, values))
    # Strings preserve bytes, including values that are not UTF-8.
    raw = '0x' + f'{32:064x}{2:064x}' + 'ff00' + '00' * 30
    expect('returndata-decode', [raw.upper(), 'string'],
           dict(values=[dict(type='string', bytes='0xff00')]))
    expect('returndata-decode', [''], dict(values=[]))
    # Exact caps differ from calldata because return data has no selector.
    boundary = 'a' * 131008
    encoded = '0x' + f'{32:064x}{len(boundary):064x}' + boundary.encode().hex()
    expect('returndata-encode', ['string', boundary], dict(returndata=encoded))
    expect('returndata-decode', [encoded, 'string'], oracle.decoded(['string'], [boundary]))
    expect('returndata-encode', ['bool', 'true'] * 4096,
           dict(returndata='0x' + f'{1:064x}' * 4096))
    negatives = refusals()
    for command, args, marker in negatives:
        result = call(command, args)
        if result.returncode != 64 or result.stdout or not result.stderr.startswith('assay: ' + command + ': ') or marker not in result.stderr:
            raise ValueError(f'REFUSAL {command} {brief(args)}: {result.returncode}: '
                             f'{result.stdout[:200]!r} {result.stderr!r}; need {marker!r}')
    print(f'RETURNDATA-CLI encode={len(rows) + 2} decode={len(rows) + 3} '
          f'oracle=cast refusals={len(negatives)} pin_mutants=2 OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('RETURNDATA-CLI FAIL: ' + str(error), file=sys.stderr)
        raise SystemExit(1)

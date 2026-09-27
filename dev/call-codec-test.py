#!/usr/bin/env python3
"""Check complete typed call payloads against cast and frozen ERC-20 calldata."""
from pathlib import Path
import json
import random
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/call-codec'
TYPES = ('uint8', 'uint256', 'address', 'bool', 'string')


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError('TOOL ' + ' '.join(map(str, command[:3])) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def build(root):
    run(root, sys.executable, '-P', 'dev/build.py', 'build', 'test/call_codec')


def query(name, types=(), values=(), value_types=None, mode='encode'):
    return '|'.join((mode, name, ','.join(types),
                     ','.join(types if value_types is None else value_types), *map(str, values)))


def decode_query(name, types, data):
    return '|'.join(('decode', name, ','.join(types), data))


def word(value):
    return f'{value:064x}'


def signature(name, types):
    return name + '(' + ','.join(types) + ')'


def selector(name, types):
    return run(ROOT, 'cast', 'sig', signature(name, types))[2:]


def oracle(name, types, values):
    # ABI bytes and string payloads share encoding, including arbitrary byte strings.
    binary = any(typ == 'string' and ('00' in value or not bytes.fromhex(value).isascii())
                 for typ, value in zip(types, values, strict=True))
    args = []
    for typ, value in zip(types, values, strict=True):
        if typ == 'address':
            args.append(f'0x{int(value):040x}')
        elif typ == 'string':
            args.append('0x' + value if binary else bytes.fromhex(value).decode('ascii'))
        else:
            args.append(str(value))
    if binary:
        abi_types = ['bytes' if typ == 'string' else typ for typ in types]
        return selector(name, types) + run(ROOT, 'cast', 'abi-encode', signature('f', abi_types), *args)[2:]
    return run(ROOT, 'cast', 'calldata', signature(name, types), *args)[2:]


def roundtrip(label, name, types, values, data):
    return [
        dict(name=label + '-encode', query=query(name, types, values), expected='OK ' + data),
        dict(name=label + '-decode', query=decode_query(name, types, data),
             expected='OK ' + '|'.join(map(str, values))),
        dict(name=label + '-metadata', query=query(name, types, values, mode='metadata'), expected='OK ' + data),
    ]


def vectors():
    samples = [
        ('empty', 'ping', [], []),
        ('transfer', 'transfer', ['address', 'uint256'], ['1', '2']),
        ('mixed', 'mixed', ['uint8', 'string', 'address', 'bool', 'string'],
         ['255', '6869', str(2**160 - 1), 'true', '00ff80']),
        ('two-strings', 'words', ['string', 'string'], ['61', '6263']),
    ]
    for typ, values in (
        ('uint8', ['0', '1', '255']),
        ('uint256', ['0', '1', str(2**256 - 1)]),
        ('address', ['0', '1', str(2**160 - 1)]),
        ('bool', ['false', 'true']),
        ('string', ['', '00ff80', 'c3a9f09f9880'] + ['78' * n for n in (1, 31, 32, 33, 63, 64, 65)]),
    ):
        for index, value in enumerate(values):
            samples.append((f'{typ}-{index}', 'value', [typ], [value]))
    rng = random.Random(20260927)
    for index in range(32):
        types = [rng.choice(TYPES) for _ in range(rng.randrange(8))]
        values = []
        for typ in types:
            if typ == 'string':
                values.append(bytes(rng.randrange(97, 123) for _ in range(rng.randrange(70))).hex())
            elif typ == 'bool':
                values.append(rng.choice(['false', 'true']))
            else:
                values.append(str(rng.getrandbits({'uint8': 8, 'uint256': 256, 'address': 160}[typ])))
        samples.append((f'seed-{index}', f'function{index}', types, values))
    rows, data = [], {}
    for label, name, types, values in samples:
        payload = oracle(name, types, values)
        data[label] = (name, types, values, payload)
        rows.extend(roundtrip(label, name, types, values, payload))
    return rows, data


def reference():
    abi = json.loads((ROOT / 'reference/erc20/abi.json').read_text())
    functions = {}
    for row in abi:
        if row['type'] == 'function':
            types = [parameter['type'] for parameter in row['inputs']]
            functions[selector(row['name'], types)] = (row['name'], types)
    rows, seen = [], set()
    for case in json.loads((ROOT / 'reference/erc20/cases.json').read_text()):
        data = case['calldata']
        if data in seen or data[:8] not in functions:
            continue
        name, types = functions[data[:8]]
        if len(data) != 8 + 64 * len(types):
            continue
        values = [str(int(data[8 + 64*i:72 + 64*i], 16)) for i in range(len(types))]
        if any(typ == 'address' and int(value) >= 2**160 for typ, value in zip(types, values, strict=True)):
            continue
        seen.add(data)
        rows.extend(roundtrip('reference-' + case['name'], name, types, values, data))
    if len(seen) < 20:
        raise ValueError('REFERENCE missing canonical calldata')
    return rows, len(seen)


def negatives(data):
    rows = []
    def add(label, command, error):
        rows.append(dict(name=label, query=command, expected='ERR ' + error))
    add('arity-missing', query('f', ['uint8'], [], value_types=[]), 'ARITY')
    add('arity-extra', query('f', [], ['1'], value_types=['uint8']), 'ARITY')
    values = {'uint8': '1', 'uint256': '1', 'address': '1', 'bool': 'true', 'string': '61'}
    for typ in TYPES:
        for value_type in TYPES:
            if typ != value_type:
                add('type-' + typ + '-' + value_type,
                    query('f', [typ], [values[value_type]], value_types=[value_type]), 'TYPE')
    for typ, bits in (('uint8', 8), ('uint256', 256), ('address', 160)):
        for label, value in (('negative', '-1'), ('overflow', str(2**bits))):
            add(typ + '-' + label, query('f', [typ], [value]), 'RANGE-' + typ)
    add('type-before-range', query('f', ['uint8', 'bool'], ['256', '1'],
                                  value_types=['uint8', 'uint256']), 'TYPE')
    add('arity-before-range', query('f', ['uint8', 'bool'], ['256'],
                                   value_types=['uint8']), 'ARITY')
    add('type-before-arity', query('f', ['bool', 'uint8'], ['1'],
                                   value_types=['uint256']), 'TYPE')
    for length in range(4):
        add('selector-short-' + str(length), decode_query('f', ['string'], 'ab' * length), 'SHORT-SELECTOR')
    for label in ('empty', 'transfer', 'mixed'):
        name, types, _, payload = data[label]
        wrong = f'{int(payload[:2], 16) ^ 1:02x}' + payload[2:]
        add('selector-wrong-' + label, decode_query(name, types, wrong), 'WRONG-SELECTOR')
        add('trailing-' + label, decode_query(name, types, payload + '00'), 'TRAILING-DATA')
    add('selector-before-truncated', decode_query('f', ['string'], 'ffffffff'), 'WRONG-SELECTOR')
    for typ, bad, error in (('uint8', 256, 'RANGE-uint8'), ('address', 2**160, 'RANGE-address'), ('bool', 2, 'INVALID-BOOL')):
        prefix = selector('f', [typ])
        add('decode-' + typ, decode_query('f', [typ], prefix + word(bad)), error)
        add('truncated-' + typ, decode_query('f', [typ], prefix + word(0)[:-2]), 'TRUNCATED')
    prefix = selector('f', ['string'])
    tail = word(1) + '61' + '00' * 31
    for offset in (0, 1, 31, 33, 36, 64, 2**256 - 1):
        add('offset-' + str(offset), decode_query('f', ['string'], prefix + word(offset) + tail), 'INVALID-OFFSET')
    add('length-truncated', decode_query('f', ['string'], prefix + word(32)), 'TRUNCATED')
    add('string-truncated', decode_query('f', ['string'], prefix + word(32) + tail[:-2]), 'TRUNCATED')
    add('padding', decode_query('f', ['string'], prefix + word(32) + tail[:-2] + '01'), 'NONZERO-PADDING')
    name, types, _, payload = data['two-strings']
    add('alias', decode_query(name, types, payload[:72] + word(64) + payload[136:]), 'INVALID-OFFSET')
    add('reverse', decode_query(name, types, payload[:8] + word(128) + word(64) + payload[136:]), 'INVALID-OFFSET')
    return rows


def check(root, rows):
    for start in range(0, len(rows), 48):
        batch = rows[start:start + 48]
        output = run(root, str(root / '_build/test/call_codec'), *(row['query'] for row in batch)).split('\n')
        if len(output) != len(batch) or any(not value.startswith(('OK ', 'ERR ')) for value in output):
            raise ValueError('OUTPUT malformed result')
        for row, value in zip(batch, output, strict=True):
            if value != row['expected']:
                raise ValueError('ANSWER ' + row['name'] + ': expected ' + row['expected'] + ', got ' + value)


def prefixes(data):
    name, types, _, payload = data['mixed']
    return [dict(name=f'prefix-{length}', query=decode_query(name, types, payload[:2*length]),
                 expected='ERR ' + ('SHORT-SELECTOR' if length < 4 else 'TRUNCATED'))
            for length in range(len(payload) // 2)]


def refusals():
    cases = [
        ('', 'USAGE'), ('encode', 'USAGE'), ('encode|f|', 'USAGE'),
        ('unknown|f||', 'MODE'), ('encode|f|uint16|', 'TYPE'),
        ('encode|f||uint16|1', 'TYPE'), ('encode|f||uint8|', 'NUMBER'),
        ('encode|f||uint8|-', 'NUMBER'), ('encode|f||bool|2', 'BOOL'),
        ('encode|f||uint8', 'ARITY'), ('decode|f||0', 'HEX'),
        ('decode|f||gg', 'HEX'), ('decode|f|||extra', 'USAGE'),
    ]
    for command, error in cases:
        result = subprocess.run([str(ROOT / '_build/test/call_codec'), command], cwd=ROOT,
                                capture_output=True, text=True, timeout=60)
        if result.returncode != 64 or result.stdout or error not in result.stderr:
            raise ValueError('REFUSAL ' + repr(command) + ': ' + repr(result))
    return len(cases)


def mutants(rows):
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-call-') as directory:
        root = Path(directory) / 'copy'
        native_mutations.copy_project(ROOT, root)
        for case in cases:
            target = root / case['path']
            original = target.read_text()
            try:
                target.write_text(native_mutations.replace(original, case['patches']))
                build(root)
                witnesses = [row for row in rows if row['name'] in case['witnesses']]
                if len(witnesses) != len(case['witnesses']):
                    raise ValueError('MUTANT missing witness')
                try:
                    check(root, witnesses)
                except ValueError as error:
                    if not str(error).startswith('ANSWER '):
                        raise
                    print('MUTANT ' + case['name'] + ' killed: ' + str(error).split(':')[0], flush=True)
                else:
                    raise ValueError('MUTANT survived: ' + case['name'])
            finally:
                target.write_text(original)
        build(root)
        check(root, rows)
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    build(ROOT)
    positive, data = vectors()
    frozen, reference_count = reference()
    negative = negatives(data)
    truncated = prefixes(data)
    rows = positive + frozen + negative + truncated
    if len({row['name'] for row in rows}) != len(rows):
        raise ValueError('DUPLICATE case name')
    check(ROOT, rows)
    refused = refusals()
    killed = mutants(rows)
    (WORK / 'cases.json').write_text(json.dumps(rows, indent=2) + '\n')
    print(f'CALL-CODEC oracle={len(data)} reference={reference_count} negative={len(negative)} prefixes={len(truncated)} refusal={refused} mutants={killed} scope=calldata OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, subprocess.SubprocessError) as error:
        print('CALL-CODEC FAIL: ' + str(error), file=sys.stderr)
        sys.exit(1)

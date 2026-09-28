#!/usr/bin/env python3
"""Check typed function results against cast and frozen ERC-20 return data."""
from pathlib import Path
import json
import random
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/return-codec'
TYPES = ('uint8', 'uint256', 'address', 'bool', 'string')


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError('TOOL ' + ' '.join(map(str, command[:3])) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def build(root):
    run(root, sys.executable, '-P', 'dev/build.py', 'build', 'test/return_codec')


def query(name, types=(), values=(), value_types=None, mode='encode'):
    return '|'.join((mode, name, ','.join(types),
                     ','.join(types if value_types is None else value_types), *map(str, values)))


def decode_query(name, types, data, mode='decode'):
    return '|'.join((mode, name, ','.join(types), data))


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
    abi_types = ['bytes' if binary and typ == 'string' else typ for typ in types]
    return run(ROOT, 'cast', 'abi-encode', signature(name, abi_types), *args)[2:]


def roundtrip(label, name, types, values, data):
    return [
        dict(name=label + '-encode', query=query(name, types, values), expected='OK ' + data),
        dict(name=label + '-decode', query=decode_query(name, types, data),
             expected='OK ' + '|'.join(map(str, values))),
        dict(name=label + '-metadata', query=query(name, types, values, mode='metadata'), expected='OK ' + data),
        dict(name=label + '-decode-metadata', query=decode_query(name, types, data, mode='decode-metadata'),
             expected='OK ' + '|'.join(map(str, values))),
    ]


def vectors():
    samples = [
        ('empty', 'ping', [], []),
        ('pair', 'result', ['address', 'uint256'], ['1', '2']),
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
            inputs = [parameter['type'] for parameter in row['inputs']]
            outputs = [parameter['type'] for parameter in row['outputs']]
            functions[selector(row['name'], inputs)] = (row['name'], outputs)
    rows, seen = [], set()
    count = 0
    for case in json.loads((ROOT / 'reference/erc20/cases.json').read_text()):
        if case['status'] != 'success':
            continue
        name, types = functions[case['calldata'][:8]]
        data = case['output'].removeprefix('0x')
        if types == ['string']:
            length = int(data[64:128], 16)
            values = [data[128:128 + 2*length]]
        elif types == ['bool']:
            values = ['true' if int(data, 16) else 'false']
        elif types in (['uint8'], ['uint256']):
            values = [str(int(data, 16))]
        else:
            raise ValueError('REFERENCE unsupported output schema ' + repr(types))
        if oracle(name, types, values) != data:
            raise ValueError('REFERENCE cast disagrees with ' + case['name'])
        seen.add(name)
        count += 1
        rows.extend(roundtrip('reference-' + case['name'], name, types, values, data))
    if seen != {name for name, _ in functions.values()} or count != 45:
        raise ValueError('REFERENCE missing successful function results')
    return rows, count


def negatives(data):
    rows = []
    def add(label, command, error):
        rows.append(dict(name=label, query=command, expected='ERR ' + error))
    add('arity-missing', query('f', ['uint8'], [], value_types=[]), 'ARITY')
    add('arity-extra', query('f', [], ['1'], value_types=['uint8']), 'ARITY')
    add('arity-missing-tail', query('f', ['uint8', 'bool'], ['1'], value_types=['uint8']), 'ARITY')
    add('arity-extra-tail', query('f', ['uint8'], ['1', 'true'], value_types=['uint8', 'bool']), 'ARITY')
    values = {'uint8': '1', 'uint256': '1', 'address': '1', 'bool': 'true', 'string': '61'}
    for typ in TYPES:
        for value_type in TYPES:
            if typ != value_type:
                add('type-' + typ + '-' + value_type,
                    query('f', [typ], [values[value_type]], value_types=[value_type]), 'TYPE')
                add('tail-type-' + typ + '-' + value_type,
                    query('f', ['bool', typ], ['true', values[value_type]], value_types=['bool', value_type]), 'TYPE')
    for typ, bits in (('uint8', 8), ('uint256', 256), ('address', 160)):
        for label, value in (('negative', '-1'), ('overflow', str(2**bits))):
            add(typ + '-' + label, query('f', [typ], [value]), 'RANGE-' + typ)
    add('type-before-range', query('f', ['uint8', 'bool'], ['256', '1'],
                                  value_types=['uint8', 'uint256']), 'TYPE')
    add('arity-before-range', query('f', ['uint8', 'bool'], ['256'],
                                   value_types=['uint8']), 'ARITY')
    add('type-before-arity', query('f', ['bool', 'uint8'], ['1'],
                                   value_types=['uint256']), 'TYPE')
    for label in ('empty', 'pair', 'mixed'):
        name, types, _, payload = data[label]
        add('trailing-' + label, decode_query(name, types, payload + '00'), 'TRAILING-DATA')
    for typ, bad, error in (('uint8', 256, 'RANGE-uint8'), ('address', 2**160, 'RANGE-address'), ('bool', 2, 'INVALID-BOOL')):
        add('decode-' + typ, decode_query('f', [typ], word(bad)), error)
        add('truncated-' + typ, decode_query('f', [typ], word(0)[:-2]), 'TRUNCATED')
    tail = word(1) + '61' + '00' * 31
    for offset in (0, 1, 31, 33, 36, 64, 2**256 - 1):
        add('offset-' + str(offset), decode_query('f', ['string'], word(offset) + tail), 'INVALID-OFFSET')
    add('length-truncated', decode_query('f', ['string'], word(32)), 'TRUNCATED')
    add('string-truncated', decode_query('f', ['string'], word(32) + tail[:-2]), 'TRUNCATED')
    add('padding', decode_query('f', ['string'], word(32) + tail[:-2] + '01'), 'NONZERO-PADDING')
    add('selector-prefix', decode_query('f', ['string'], '12345678' + word(32) + tail), 'INVALID-OFFSET')
    name, types, _, payload = data['two-strings']
    add('alias', decode_query(name, types, payload[:64] + word(64) + payload[128:]), 'INVALID-OFFSET')
    add('reverse', decode_query(name, types, word(128) + word(64) + payload[128:]), 'INVALID-OFFSET')
    return rows


def check(root, rows):
    for start in range(0, len(rows), 48):
        batch = rows[start:start + 48]
        output = run(root, str(root / '_build/test/return_codec'), *(row['query'] for row in batch)).split('\n')
        if len(output) != len(batch) or any(not value.startswith(('OK ', 'ERR ')) for value in output):
            raise ValueError('OUTPUT malformed result')
        for row, value in zip(batch, output, strict=True):
            if value != row['expected']:
                raise ValueError('ANSWER ' + row['name'] + ': expected ' + row['expected'] + ', got ' + value)


def prefixes(data):
    name, types, _, payload = data['mixed']
    return [dict(name=f'prefix-{length}', query=decode_query(name, types, payload[:2*length]),
                 expected='ERR TRUNCATED')
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
        result = subprocess.run([str(ROOT / '_build/test/return_codec'), command], cwd=ROOT,
                                capture_output=True, text=True, timeout=60)
        if result.returncode != 64 or result.stdout or error not in result.stderr:
            raise ValueError('REFUSAL ' + repr(command) + ': ' + repr(result))
    return len(cases)


def mutants(rows):
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-return-') as directory:
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
    print(f'RETURN-CODEC oracle={len(data)} reference={reference_count} negative={len(negative)} prefixes={len(truncated)} refusal={refused} mutants={killed} scope=returndata OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, subprocess.SubprocessError) as error:
        print('RETURN-CODEC FAIL: ' + str(error), file=sys.stderr)
        sys.exit(1)

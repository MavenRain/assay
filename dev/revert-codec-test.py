#!/usr/bin/env python3
"""Check typed revert data against cast, malformed payloads and compiling mutants."""
from pathlib import Path
from functools import cache
import json
import random
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/revert-codec'
TYPES = ('uint8', 'uint256', 'address', 'bool', 'string')


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError('TOOL ' + ' '.join(map(str, command[:3])) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def build(root):
    run(root, sys.executable, '-P', 'dev/build.py', 'build', 'test/revert_codec')


def query(name, types=(), values=(), value_types=None, mode='encode', kind='error'):
    return '|'.join((mode, kind, name, ','.join(types),
                     ','.join(types if value_types is None else value_types), *map(str, values)))


def decode_query(name, types, data, mode='decode', kind='error'):
    return '|'.join((mode, kind, name, ','.join(types), data))


def word(value):
    return f'{value:064x}'


def signature(name, types):
    return name + '(' + ','.join(types) + ')'


@cache
def cached_selector(sig):
    return run(ROOT, 'cast', 'sig', sig)[2:]


def selector(name, types):
    return cached_selector(signature(name, types))


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
    if binary:
        return selector(name, types) + run(ROOT, 'cast', 'abi-encode', signature(name, abi_types), *args)[2:]
    return run(ROOT, 'cast', 'calldata', signature(name, types), *args)[2:]


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
        ('reason', 'Error', ['string'], ['696e73756666696369656e742062616c616e6365']),
        ('panic', 'Panic', ['uint256'], ['17']),
        ('custom', 'InsufficientBalance', ['uint256', 'uint256'], ['0', '100']),
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
    rows = []
    for case in json.loads((ROOT / 'reference/erc20/cases.json').read_text()):
        if case['status'] != 'revert':
            continue
        data = case['output'].removeprefix('0x')
        if data:
            raise ValueError('REFERENCE expected the frozen empty revert: ' + case['name'])
        rows.append(dict(name='reference-' + case['name'], query=decode_query('Error', ['string'], data), expected='ERR SHORT-SELECTOR'))
    if not rows:
        raise ValueError('REFERENCE missing reverted calls')
    return rows, len(rows)


def negatives(data):
    rows = []
    def add(label, command, error):
        rows.append(dict(name=label, query=command, expected='ERR ' + error))
    def raw(types, payload):
        return decode_query('f', types, selector('f', types) + payload)
    for kind in ('constructor', 'function', 'event', 'fallback'):
        add(kind + '-encode', query('f', kind=kind), 'NOT-ERROR')
        add(kind + '-decode', decode_query('f', [], '', kind=kind), 'NOT-ERROR')
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
        wrong = f'{int(payload[:2], 16) ^ 1:02x}' + payload[2:]
        add('wrong-selector-' + label, decode_query(name, types, wrong), 'WRONG-SELECTOR')
        add('wrong-name-' + label, decode_query(name + 'Other', types, payload), 'WRONG-SELECTOR')
    add('wrong-types', decode_query('result', ['uint256', 'address'], data['pair'][3]), 'WRONG-SELECTOR')
    for typ, bad, error in (('uint8', 256, 'RANGE-uint8'), ('address', 2**160, 'RANGE-address'), ('bool', 2, 'INVALID-BOOL')):
        add('decode-' + typ, raw([typ], word(bad)), error)
        add('truncated-' + typ, raw([typ], word(0)[:-2]), 'TRUNCATED')
    tail = word(1) + '61' + '00' * 31
    for offset in (0, 1, 31, 33, 36, 64, 2**256 - 1):
        add('offset-' + str(offset), raw(['string'], word(offset) + tail), 'INVALID-OFFSET')
    add('length-truncated', raw(['string'], word(32)), 'TRUNCATED')
    add('string-truncated', raw(['string'], word(32) + tail[:-2]), 'TRUNCATED')
    add('padding', raw(['string'], word(32) + tail[:-2] + '01'), 'NONZERO-PADDING')
    add('selector-prefix', raw(['string'], '12345678' + word(32) + tail), 'INVALID-OFFSET')
    name, types, _, payload = data['two-strings']
    add('alias', decode_query(name, types, payload[:72] + word(64) + payload[136:]), 'INVALID-OFFSET')
    add('reverse', decode_query(name, types, payload[:8] + word(128) + word(64) + payload[136:]), 'INVALID-OFFSET')
    return rows


def check(root, rows):
    for start in range(0, len(rows), 48):
        batch = rows[start:start + 48]
        output = run(root, str(root / '_build/test/revert_codec'), *(row['query'] for row in batch)).split('\n')
        if len(output) != len(batch) or any(not value.startswith(('OK ', 'ERR ')) for value in output):
            raise ValueError('OUTPUT malformed result')
        for row, value in zip(batch, output, strict=True):
            if value != row['expected']:
                raise ValueError('ANSWER ' + row['name'] + ': expected ' + row['expected'] + ', got ' + value)


def prefixes(data):
    name, types, _, payload = data['mixed']
    return [dict(name=f'prefix-{length}', query=decode_query(name, types, payload[:2*length]),
                 expected='ERR SHORT-SELECTOR' if length < 4 else 'ERR TRUNCATED')
            for length in range(len(payload) // 2)]


def refusals():
    cases = [
        ('', 'USAGE'), ('encode', 'USAGE'), ('encode|f|', 'USAGE'),
        ('unknown|error|f||', 'MODE'), ('encode|error|f|uint16|', 'TYPE'),
        ('encode|error|f||uint16|1', 'TYPE'), ('encode|error|f||uint8|', 'NUMBER'),
        ('encode|error|f||uint8|-', 'NUMBER'), ('encode|error|f||bool|2', 'BOOL'),
        ('encode|error|f||uint8', 'ARITY'), ('decode|error|f||0', 'HEX'),
        ('decode|error|f||gg', 'HEX'), ('decode|error|f|||extra', 'USAGE'),
        ('decode-metadata|error|f|||extra', 'USAGE'), ('metadata|error|f||uint8', 'ARITY'),
        ('encode|unknown|f||', 'KIND'),
    ]
    for command, error in cases:
        result = subprocess.run([str(ROOT / '_build/test/revert_codec'), command], cwd=ROOT,
                                capture_output=True, text=True, timeout=60)
        if result.returncode != 64 or result.stdout or error not in result.stderr:
            raise ValueError('REFUSAL ' + repr(command) + ': ' + repr(result))
    return len(cases)


def mutants(rows):
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-revert-') as directory:
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
    print(f'REVERT-CODEC oracle={len(data)} reference={reference_count} negative={len(negative)} prefixes={len(truncated)} refusal={refused} mutants={killed} scope=revertdata OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, subprocess.SubprocessError) as error:
        print('REVERT-CODEC FAIL: ' + str(error), file=sys.stderr)
        sys.exit(1)

#!/usr/bin/env python3
"""Compare production event encoding with cast, frozen logs and Cancun receipts."""
from pathlib import Path
import importlib.util
import json
import random
import shutil
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/event-codec'
TARGET = 'test/event_codec'
TYPES = ('uint8', 'uint256', 'address', 'bool', 'string')


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError('TOOL ' + ' '.join(map(str, command[:3])) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def build(root):
    run(root, sys.executable, '-P', 'dev/build.py', 'build', TARGET)


def query(name, types=(), flags=(), values=(), anonymous=False, value_types=None):
    return '|'.join((name, str(int(anonymous)), ','.join(types),
                     ','.join(str(int(flag)) for flag in flags),
                     ','.join(types if value_types is None else value_types), *map(str, values)))


def cast_value(typ, value):
    if typ == 'string':
        return bytes.fromhex(value).decode('utf-8')
    if typ == 'address':
        return f'0x{int(value):040x}'
    return str(value)


def keccak(data):
    return run(ROOT, 'cast', 'keccak', '0x' + data.hex())[2:]


def oracle(name, types=(), flags=(), values=(), anonymous=False):
    topics = [] if anonymous else [keccak((name + '(' + ','.join(types) + ')').encode())]
    plain_types, plain_values = [], []
    for typ, flag, value in zip(types, flags, values, strict=True):
        if flag:
            topics.append(keccak(bytes.fromhex(value)) if typ == 'string' else
                          run(ROOT, 'cast', 'abi-encode', 'f(' + typ + ')', cast_value(typ, value))[2:])
        else:
            plain_types.append(typ)
            plain_values.append(cast_value(typ, value))
    data = run(ROOT, 'cast', 'abi-encode', 'f(' + ','.join(plain_types) + ')', *plain_values)[2:] if plain_types else ''
    return 'OK ' + ','.join(topics) + '|' + data


def decode(row):
    if row.startswith('ERR '):
        if not row[4:] or '|' in row:
            raise ValueError('OUTPUT error shape')
        return None
    if not row.startswith('OK ') or row.count('|') != 1:
        raise ValueError('OUTPUT log shape')
    topics, data = row[3:].split('|')
    topics = topics.split(',') if topics else []
    if len(topics) > 4 or any(len(topic) != 64 for topic in topics) or len(data) % 64:
        raise ValueError('OUTPUT topic/data size')
    for item in topics + [data]:
        if bytes.fromhex(item).hex() != item:
            raise ValueError('OUTPUT noncanonical hex')
    return dict(topics=['0x' + topic for topic in topics], data='0x' + data)


def check(root, rows):
    actual = run(root, str(root / '_build/test/event_codec'), *(row['query'] for row in rows)).splitlines()
    if len(actual) != len(rows):
        raise ValueError('OUTPUT row count')
    for row, output in zip(rows, actual, strict=True):
        decode(output)
        if output != row['want']:
            raise ValueError('ANSWER ' + row['name'] + ': ' + output + ' != ' + row['want'])
    return actual


def vectors():
    rows = []

    def add(name, types=(), flags=(), values=(), anonymous=False):
        rows.append(dict(name=name, query=query(name, types, flags, values, anonymous),
                         want=oracle(name, types, flags, values, anonymous)))

    add('Empty')
    add('AnonymousEmpty', anonymous=True)
    add('Transfer', ('address', 'address', 'uint256'), (1, 1, 0), (1, 2, 3))
    add('Approval', ('address', 'address', 'uint256'), (1, 1, 0), (2**160-1, 0, 2**256-1))
    add('TopicOrder', ('uint8',)*3, (1,)*3, (1, 2, 3))
    add('DataOrder', ('uint8',)*3, (0,)*3, (1, 2, 3))
    add('FourTopics', ('uint8',)*4, (1,)*4, (1, 2, 3, 4), True)
    add('IndexedString', ('string',), (1,), ('616263',))
    add('EmptyString', ('string',), (1,), ('',))
    add('BinaryString', ('string',), (1,), ('00ff80',))
    add('MixedStrings', ('string', 'uint8', 'string', 'string'), (0, 1, 1, 0), ('61', 7, '6263', '64'))
    for size in (0, 1, 31, 32, 33, 63, 64, 65):
        add('StringSize' + str(size), ('string', 'bool'), (0, 1), ('61'*size, 'true'))
    for typ, values in (('uint8', (0, 255)), ('uint256', (0, 2**255, 2**256-1)),
                        ('address', (0, 2**159, 2**160-1)), ('bool', ('false', 'true'))):
        for i, value in enumerate(values):
            for flag in (0, 1):
                add('Edge' + typ + str(i) + str(flag), (typ,), (flag,), (value,))
    rng = random.Random(0xE7E17)
    for i in range(32):
        types = [rng.choice(TYPES) for _ in range(rng.randrange(1, 8))]
        anonymous = bool(i % 2)
        indexed = set(rng.sample(range(len(types)), rng.randrange(min(len(types), 4 if anonymous else 3)+1)))
        values = [rng.getrandbits({'uint8': 8, 'uint256': 256, 'address': 160}[typ])
                  if typ in ('uint8', 'uint256', 'address') else rng.choice(('true', 'false'))
                  if typ == 'bool' else ('s' * rng.randrange(70)).encode().hex() for typ in types]
        add('Seeded' + str(i), types, [j in indexed for j in range(len(types))], values, anonymous)
    return rows


def negatives():
    rows = []

    def add(name, command, error):
        rows.append(dict(name=name, query=command, want='ERR ' + error))

    add('Missing', query('Missing', ('uint8',), (1,), (), value_types=()), 'arity')
    add('Extra', query('Extra', (), (), (1,), value_types=('uint8',)), 'arity')
    for anonymous in (False, True):
        count = 5 if anonymous else 4
        add('TooMany' + str(anonymous), query('Many', ('uint8',)*count, (1,)*count, (1,)*count, anonymous), 'too-many-topics')
    for typ, bits in (('uint8', 8), ('uint256', 256), ('address', 160)):
        for flag in (0, 1):
            for value in (-1, 2**bits):
                add('Range' + typ + str(flag) + str(value), query('Range', (typ,), (flag,), (value,)), 'RANGE-' + typ)
    sample = dict(uint8=1, uint256=1, address=1, bool='true', string='61')
    for flag, prefix in ((1, 'Mismatch'), (0, 'NonindexedMismatch')):
        for typ in TYPES:
            for actual in TYPES:
                if actual != typ:
                    add(prefix + typ + actual, query('Mismatch', (typ,), (flag,), (sample[actual],), value_types=(actual,)), 'type-mismatch')
    # Rows with several failures. The topic count is checked first. Other
    # failures follow argument traversal: indexed values are encoded as they
    # are visited, and non-indexed values are encoded in the final tuple.
    add('TooManyRange', query('Many', ('uint8',)*4, (1,)*4, (1, 1, 1, 256)), 'too-many-topics')
    add('TooManyMismatch', query('Many', ('uint8',)*4, (1,)*4, (1, 1, 1, 'true'),
                                 value_types=('uint8',)*3 + ('bool',)), 'too-many-topics')
    add('TooManyArity', query('Many', ('uint8',)*4, (1,)*4, (1, 1, 1), value_types=('uint8',)*3), 'too-many-topics')
    add('RangeBeforeMismatch', query('Order', ('uint8', 'uint8'), (1, 0), (256, 'true'),
                                     value_types=('uint8', 'bool')), 'RANGE-uint8')
    add('MismatchBeforeRange', query('Order', ('uint8', 'uint8'), (1, 1), ('true', 256),
                                     value_types=('bool', 'uint8')), 'type-mismatch')
    add('DataRangeBeforeMismatch', query('Order', ('uint8', 'uint8'), (0, 1), (256, 'true'),
                                         value_types=('uint8', 'bool')), 'type-mismatch')
    add('RangeBeforeArity', query('Order', ('uint8', 'uint8'), (1, 1), (256,), value_types=('uint8',)), 'RANGE-uint8')
    add('DataRangeBeforeArity', query('Order', ('uint8', 'uint8'), (0, 0), (256,), value_types=('uint8',)), 'arity')
    add('MismatchBeforeArity', query('Order', ('uint8',), (0,), ('true', 1), value_types=('bool', 'uint8')), 'type-mismatch')
    return rows


def reference():
    abi = json.loads((ROOT / 'reference/erc20/abi.json').read_text())
    events = {keccak((row['name'] + '(' + ','.join(p['type'] for p in row['inputs']) + ')').encode()): row
              for row in abi if row['type'] == 'event'}
    rows = []
    for case in json.loads((ROOT / 'reference/erc20/cases.json').read_text()):
        for i, log in enumerate(case['logs']):
            event = events[log['topics'][0][2:]]
            values = [int(topic, 16) for topic in log['topics'][1:]] + [int(log['data'], 16)]
            command = query(event['name'], [p['type'] for p in event['inputs']],
                            [p['indexed'] for p in event['inputs']], values)
            want = 'OK ' + ','.join(t[2:] for t in log['topics']) + '|' + log['data'][2:]
            if not any(row['query'] == command for row in rows):
                rows.append(dict(name=case['name'] + '-' + str(i), query=command, want=want))
    if not rows:
        raise ValueError('REFERENCE empty')
    return rows


def refusals():
    rows = [('', 'USAGE'), ('x', 'USAGE'), ('x|0', 'USAGE'), ('x|0|', 'USAGE'), ('x|0||', 'USAGE'),
            ('x|2|||', 'FLAG'), ('x|0|uint8|2|uint8|1', 'FLAG'),
            ('x|0|uint8||uint8|1', 'ARITY'), ('x|0||1|', 'ARITY'),
            ('x|0|uint8|0|uint8', 'ARITY'), ('x|0|||uint8|', 'NUMBER'),
            ('x|0|||uint8|-', 'NUMBER'), ('x|0|||bool|2', 'BOOL')]
    records = []
    for command, error in rows:
        result = subprocess.run([str(ROOT / '_build/test/event_codec'), command], cwd=ROOT,
                                capture_output=True, text=True, timeout=30)
        if (result.returncode, result.stdout, result.stderr.strip()) != (64, '', 'ADAPTER-' + error):
            raise ValueError('REFUSAL ' + repr((command, result.returncode, result.stdout, result.stderr)))
        records.append(dict(command=command, exit_code=result.returncode, stdout=result.stdout,
                            stderr=result.stderr.strip()))
    (WORK / 'refusals.json').write_text(json.dumps(records, indent=2) + '\n')
    return len(records)


def cancun(rows):
    spec = importlib.util.spec_from_file_location('event_diff', ROOT / 'evm/diff.py')
    diff = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(diff)
    evidence_rows = []
    for row in rows:
        log = decode(check(ROOT, [row])[0])
        data = bytes.fromhex(log['data'][2:])
        # Write the production bytes, then push topics in reverse stack order.
        code = ''.join('7f' + data[i:i+32].hex() + '61' + f'{i:04x}' + '52' for i in range(0, len(data), 32))
        code += ''.join('7f' + topic[2:] for topic in reversed(log['topics']))
        code += '61' + f'{len(data):04x}' + '5f' + f'{0xa0+len(log["topics"]):02x}'
        for revert in (False, True):
            runtime = code + ('5f5ffd' if revert else '00')
            state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
            report, evidence = diff.execute(runtime, '', state, shutil.which('evm'))
            transition = json.loads(evidence['transition'])
            receipt = transition['result']['receipts'][0]
            logs = [dict(topics=item['topics'], data=item['data']) for item in receipt.get('logs') or []]
            expected = [] if revert else [decode(row['want'])]
            if report['status'] != ('revert' if revert else 'success') or logs != expected:
                raise ValueError('CANCUN ' + row['name'])
            evidence_rows.append(dict(name=row['name'], revert=revert, runtime=runtime, report=report, evidence=evidence))
    (WORK / 'cancun.json').write_text(json.dumps(evidence_rows, indent=2) + '\n')
    return len(evidence_rows)


def mutants(rows):
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-events-') as directory:
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
                    print('MUTANT ' + case['name'] + ' killed: ' + str(error).split(':')[0])
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
    positive, negative, frozen = vectors(), negatives(), reference()
    rows = positive + negative + frozen
    if len({row['query'] for row in rows}) != len(rows):
        raise ValueError('DUPLICATE query')
    (WORK / 'vectors.json').write_text(json.dumps(rows, indent=2) + '\n')
    check(ROOT, rows)
    refused = refusals()
    executed = cancun([positive[i] for i in (1, 0, 7, 2, 6, 10)])
    killed = mutants(rows)
    print(f'EVENT-CODEC oracle={len(positive)} reference={len(frozen)} negative={len(negative)} refusal={refused} cancun={executed} mutants={killed} scope=event-codec OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.SubprocessError) as error:
        print('EVENT-CODEC FAIL ' + str(error), file=sys.stderr)
        raise SystemExit(1)

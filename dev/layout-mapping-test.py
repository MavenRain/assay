#!/usr/bin/env python3
"""Check typed mapping locations against cast and frozen ERC-20 storage slots."""
from pathlib import Path
import hashlib
import json
import random
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
TARGET = 'test/layout_mapping'
BITS = {'uint8': 8, 'uint256': 256, 'address': 160, 'bool': 1}
WORD = (1 << 256) - 1


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError('TOOL ' + ' '.join(command[:3]) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def build(root):
    return run(root, sys.executable, '-P', 'dev/build.py', 'build', TARGET)


def query(command, types, base, values):
    return '|'.join(map(str, (command, ','.join(types), base, *values)))


def oracle(base, types, values):
    for typ, value in zip(types, values, strict=True):
        key = ('0x%040x' % value if typ == 'address' else
               ('true' if value else 'false') if typ == 'bool' else str(value))
        output = run(ROOT, 'cast', 'index', typ, key, str(base))
        if len(output) != 66 or not output.startswith('0x'):
            raise ValueError('CAST-SLOT ' + output)
        base = int(output, 16)
    return base


def positives():
    rows = []
    for typ, bits in BITS.items():
        for base in (0, 1, 2, 1 << 255, WORD):
            for value in sorted({0, 1, 1 << (bits - 1), (1 << bits) - 1}):
                rows.append((f'scalar.{typ}.{base}.{value}', query('slot', [typ], base, [value]),
                             'OK ' + str(oracle(base, [typ], [value]))))
    rng = random.Random(20260925)
    names = tuple(BITS)
    for index in range(32):
        types = [rng.choice(names) for _ in range(1 + index % 4)]
        values = [rng.getrandbits(BITS[typ]) for typ in types]
        base = rng.getrandbits(256)
        rows.append((f'nested.{index}', query('path', types, base, values),
                     'OK ' + str(oracle(base, types, values))))
    return rows


def reference():
    slots = json.loads((ROOT / 'reference/erc20/slots.json').read_text())
    addresses = {row['name'].removeprefix('balance-'): int(row['preimage'][2:66], 16)
                 for row in slots if row['name'].startswith('balance-')}
    rows = []
    for row in slots:
        name = row['name']
        if name.startswith('balance-'):
            types, base, values = ['address'], 1, [addresses[name.removeprefix('balance-')]]
        elif name.startswith('allowance-'):
            owner, spender = name.removeprefix('allowance-').split('-')
            types, base, values = ['address', 'address'], 2, [addresses[owner], addresses[spender]]
        else:
            raise ValueError('UNKNOWN-REFERENCE ' + name)
        expected = int(row['slot'], 16)
        if oracle(base, types, values) != expected:
            raise AssertionError('REFERENCE-CAST ' + name)
        rows.append(('reference.' + name, query('path', types, base, values), 'OK ' + str(expected)))
    return rows


def negatives():
    rows = []
    for typ, bits in BITS.items():
        for label, value in (('negative', -1), ('overflow', 1 << bits)):
            rows.append((f'negative.{typ}.{label}', query('slot', [typ], 0, [value]),
                         'ERR out-of-range:' + typ))
            rows.append((f'negative.inner.{typ}.{label}',
                         query('path', ['uint256', typ], 2, [1, value]), 'ERR out-of-range:' + typ))
    for label, base in (('negative', -1), ('overflow', 1 << 256)):
        rows.append(('negative.slot.' + label, query('slot', ['uint256'], base, [0]), 'ERR invalid-slot'))
        rows.append(('negative.path-slot.' + label, query('path', ['uint256'], base, [0]), 'ERR invalid-slot'))
    rows.extend([
        ('negative.string', query('slot', ['string'], 0, [0]), 'ERR unsupported-key'),
        ('negative.inner.string', query('path', ['uint256', 'string'], 2, [1, 0]), 'ERR unsupported-key'),
        ('negative.empty', query('path', [], 0, []), 'ERR empty-path'),
    ])
    return rows


def refusals():
    # Malformed adapter queries exit 64 with one ADAPTER token on stderr.
    return [
        ('refusal.slot.no-key', 'slot||0', 'EXIT 64 ADAPTER-ARITY'),
        ('refusal.slot.two-keys', 'slot|uint256,uint256|0|1|2', 'EXIT 64 ADAPTER-ARITY'),
        ('refusal.slot.missing-key', 'slot|uint256|0', 'EXIT 64 ADAPTER-ARITY'),
        ('refusal.path.extra-key', 'path|uint256|0|1|2', 'EXIT 64 ADAPTER-ARITY'),
        ('refusal.path.missing-key', 'path|uint256,uint256|0|1', 'EXIT 64 ADAPTER-ARITY'),
        ('refusal.path.no-type', 'path||0|5', 'EXIT 64 ADAPTER-ARITY'),
        ('refusal.command', 'bogus|uint256|0|1', 'EXIT 64 ADAPTER-USAGE'),
        ('refusal.fields.none', '', 'EXIT 64 ADAPTER-USAGE'),
        ('refusal.fields.command', 'slot', 'EXIT 64 ADAPTER-USAGE'),
        ('refusal.fields.types', 'slot|uint256', 'EXIT 64 ADAPTER-USAGE'),
        ('refusal.base.empty', 'slot|uint256||1', 'EXIT 64 ADAPTER-NUMBER'),
        ('refusal.base.sign', 'slot|uint256|-|1', 'EXIT 64 ADAPTER-NUMBER'),
        ('refusal.key.empty', 'slot|uint256|0|', 'EXIT 64 ADAPTER-NUMBER'),
        ('refusal.key.sign', 'slot|uint256|0|-', 'EXIT 64 ADAPTER-NUMBER'),
        ('refusal.inner-key.sign', 'path|uint256,uint256|0|1|-', 'EXIT 64 ADAPTER-NUMBER'),
    ]


def refusal(expected):
    return expected.startswith('EXIT ')


def refuse(root, query_text):
    # An adapter refusal stops the whole batch, so each refusal row runs alone.
    result = subprocess.run((str(root / '_build' / TARGET), query_text), cwd=root,
                            capture_output=True, text=True, timeout=60)
    lines, reason = result.stdout.splitlines(), result.stderr.strip()
    if not result.returncode and not result.stderr and len(lines) == 1:
        return lines[0]
    if result.returncode != 64 or result.stdout or not reason.startswith('ADAPTER-') or len(reason.split()) != 1:
        raise ValueError('ADAPTER refusal shape ' + query_text + '\n' + result.stdout + result.stderr)
    return f'EXIT {result.returncode} {reason}'


def check(root, rows):
    inband = [row for row in rows if not refusal(row[2])]
    for start in range(0, len(inband), 24):
        batch = inband[start:start + 24]
        actual = run(root, str(root / '_build' / TARGET), *(row[1] for row in batch)).splitlines()
        if len(actual) != len(batch):
            raise ValueError('ADAPTER row count')
        for (label, _, expected), result in zip(batch, actual, strict=True):
            if result != expected:
                raise AssertionError(f'{label}: expected {expected}; got {result}')
    for label, query_text, expected in (row for row in rows if refusal(row[2])):
        result = refuse(root, query_text)
        if result != expected:
            raise AssertionError(f'{label}: expected {expected}; got {result}')


MUTANTS = [
    ('ORDER', 'src/layout.bend', 'String.append(word, Abi.Codec.word(base))', 'String.append(Abi.Codec.word(base), word)', 'scalar.uint256.2.1'),
    ('KEY-PADDING', 'src/layout.bend', 'Done{Abi.Codec.word(value)}', 'Done{Big.to_bytes(value)}', 'scalar.uint256.2.1'),
    ('SLOT-PADDING', 'src/layout.bend', 'String.append(word, Abi.Codec.word(base))', 'String.append(word, Big.to_bytes(base))', 'scalar.uint256.2.1'),
    ('UINT8-RANGE', 'src/layout.bend', 'Layout.Mapping.checked_word(typ, value, 8n)', 'Layout.Mapping.checked_word(typ, value, 256n)', 'negative.uint8.overflow'),
    ('ADDRESS-RANGE', 'src/layout.bend', 'Layout.Mapping.checked_word(typ, value, 160n)', 'Layout.Mapping.checked_word(typ, value, 256n)', 'negative.address.overflow'),
    ('BOOL-RANGE', 'src/layout.bend', 'Layout.Mapping.checked_word(typ, value, 1n)', 'Layout.Mapping.checked_word(typ, value, 8n)', 'negative.bool.overflow'),
    ('SLOT-RANGE', 'src/layout.bend', 'Abi.Codec.within(Big.of_nat(256n), base)', 'True{}', 'negative.slot.overflow'),
    ('KEY-RANGE', 'src/layout.bend', 'Abi.Codec.within(Big.of_nat(bits), value)', 'True{}', 'negative.uint256.negative'),
    ('EMPTY-PATH', 'src/layout.bend', 'Fail{Layout.Mapping.Error.Empty_path{}}', 'Done{base}', 'negative.empty'),
    ('NESTING', 'src/layout.bend', 'Layout.Mapping.Result.bind(Big, Big, Layout.Mapping.slot(base, key), next => Layout.Mapping.walk(next, tail))',
     'Layout.Mapping.Result.bind(Big, Big, Layout.Mapping.walk(base, tail), next => Layout.Mapping.slot(next, key))', 'reference.allowance-alice-bob'),
    ('TAIL', 'src/layout.bend', 'next => Layout.Mapping.walk(next, tail)', 'next => Done{next}', 'negative.inner.uint8.overflow'),
    ('SLOT-ARITY', 'src/tests.bend', 'case Con{_, Con{_, _}}: Fail{"ADAPTER-ARITY"}',
     'case Con{key, Con{_, _}}: Done{Mapping_layout.show(Layout.Mapping.slot(base, key))}', 'refusal.slot.two-keys'),
]


def mutations(cases, work):
    sources = {path: (ROOT / path).read_text() for path in sorted({row[1] for row in MUTANTS})}
    witnesses = {row[0]: row for row in cases}
    killed = []
    with tempfile.TemporaryDirectory(prefix='assay-mapping-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, path, old, new, witness in MUTANTS:
            if sources[path].count(old) != 1:
                raise ValueError('MUTANT-PATTERN ' + name)
            (copy / path).write_text(sources[path].replace(old, new))
            (work / (name + '-build.log')).write_text(build(copy))
            try:
                check(copy, [witnesses[witness]])
            except AssertionError as error:
                (work / (name + '-witness.log')).write_text(str(error) + '\n')
                killed.append(dict(name=name, witness=witness))
            else:
                raise ValueError('SURVIVED ' + name)
            (copy / path).write_text(sources[path])
        (work / 'control-build.log').write_text(build(copy))
        check(copy, [witnesses[row[4]] for row in MUTANTS])
    return killed


def main():
    work = ROOT / '.gatework/layout-mapping'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'build.log').write_text(build(ROOT))
    positive, frozen, negative, refused = positives(), reference(), negatives(), refusals()
    cases = positive + frozen + negative + refused
    if len({row[1] for row in cases}) != len(cases):
        raise ValueError('DUPLICATE-PROBE')
    check(ROOT, cases)
    killed = mutations(cases, work)
    report = dict(oracle=len(positive), reference=len(frozen), negative=len(negative),
                  refusal=len(refused), mutants=killed, restored_control='OK', cases=cases,
                  sources={path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                           for path in ('src/layout.bend', 'src/tests.bend', 'src/abi.bend', 'src/keccak.bend',
                                        'dev/build.py', 'dev/layout-mapping-test.py', 'reference/erc20/slots.json')})
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print('LAYOUT-MAPPING oracle=%d reference=%d negative=%d refusal=%d mutants=%d scope=mapping OK' %
          (len(positive), len(frozen), len(negative), len(refused), len(killed)))


if __name__ == '__main__':
    try:
        main()
    except (AssertionError, ValueError, OSError, subprocess.TimeoutExpired) as error:
        print('LAYOUT-MAPPING FAIL: ' + str(error), file=sys.stderr)
        raise SystemExit(1)

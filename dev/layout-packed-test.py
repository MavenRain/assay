#!/usr/bin/env python3
"""Check packed layout, lane preservation and compiling semantic mutants."""
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
TARGET = 'test/layout_packed'
WIDTHS = {'uint8': 1, 'uint256': 32, 'address': 20, 'bool': 1}
WORD = (1 << 256) - 1


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError('TOOL ' + ' '.join(command[:3]) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def build(root):
    return run(root, sys.executable, '-P', 'dev/build.py', 'build', TARGET)


def query(command, typ, offset, slot, word, *values):
    return '|'.join(map(str, (command, typ, offset, slot, word, *values)))


def layouts():
    # Fixed placements follow Solidity's lower-order alignment and spill rules.
    fixtures = [
        ('empty', [], []),
        ('word', ['uint256'], [(0, 0)]),
        ('mixed', ['uint8', 'bool', 'address', 'uint256', 'uint8'],
         [(0, 0), (0, 1), (0, 2), (1, 0), (2, 0)]),
        ('exact', ['address'] + ['uint8'] * 12 + ['bool'],
         [(0, 0)] + [(0, offset) for offset in range(20, 32)] + [(1, 0)]),
        ('spill', ['address', 'address', 'uint8'], [(0, 0), (1, 0), (1, 20)]),
        ('late-spill', ['uint8'] * 13 + ['address'], [(0, offset) for offset in range(13)] + [(1, 0)]),
        ('uint256-spill', ['uint8', 'uint256'], [(0, 0), (1, 0)]),
        ('address-end', ['uint8'] * 12 + ['address', 'bool'],
         [(0, offset) for offset in range(12)] + [(0, 12), (1, 0)]),
        ('words', ['uint256'] * 3, [(0, 0), (1, 0), (2, 0)]),
        ('bools', ['bool'] * 33, [(0, offset) for offset in range(32)] + [(1, 0)]),
        ('escaping', ['uint8', 'bool'], [(0, 0), (0, 1)]),
    ]
    cases = []
    for label, types, positions in fixtures:
        contract = 'Packed"\\\n雪' if label == 'escaping' else 'Packed'
        names = [f'field{index}' for index in range(len(types))]
        if label == 'escaping':
            names = ['quote"', 'slash\\\n雪']
        expected = {
            'storage': [dict(astId=i, contract=contract, label=name, offset=offset,
                             slot=str(slot), type='t_' + typ)
                        for i, (name, typ, (slot, offset)) in enumerate(zip(names, types, positions))],
            'types': {'t_' + typ: dict(encoding='inplace', label=typ, numberOfBytes=str(WIDTHS[typ]))
                      for typ in types},
        }
        cases.append(('layout.' + label, '|'.join(('layout', contract, ','.join(types) or '-', ','.join(names))), expected))
    return cases


def accesses():
    rng = random.Random(20260925)
    cases, writes = [], []
    for typ, width in WIDTHS.items():
        maximum = 1 if typ == 'bool' else (1 << (width * 8)) - 1
        for offset in range(33 - width):
            shift = offset * 8
            mask = ((1 << (width * 8)) - 1) << shift
            small = (255 >> shift) & (mask >> shift)
            expected = 'ERR out-of-range:bool' if typ == 'bool' and small > 1 else f'OK {small}'
            cases.append((f'access.small.{typ}.{offset}', query('read', typ, offset, 0, 255), expected))
            for n, word in enumerate((0, WORD, int.from_bytes(bytes(range(32)), 'little'), rng.getrandbits(256))):
                for value in (0, 1) if typ == 'bool' else (0, 1, maximum):
                    expected_word = (word & (WORD ^ mask)) | (value << shift)
                    label = f'access.write.{typ}.{offset}.{n}.{value}'
                    cases.append((label, query('write', typ, offset, WORD, word, value), f'OK {expected_word}'))
                    writes.append((label, typ, offset, word, value, mask))
    return cases, writes


def negatives():
    cases = [
        ('negative.dynamic-layout', 'layout|Packed|string|name', 'ERR unsupported-type'),
        ('negative.empty-name', 'layout|Packed|uint8|', 'ERR empty-name'),
        ('negative.duplicate', 'layout|Packed|uint8,bool|same,same', 'ERR duplicate-name:same'),
        ('negative.arity-empty-types', 'layout|Packed|-|owner,total', 'EXIT 64 ADAPTER-ARITY'),
    ]
    for command in ('read', 'write'):
        value = (0,) if command == 'write' else ()
        cases.append((f'negative.dynamic-{command}', query(command, 'string', 0, 0, 0, *value), 'ERR unsupported-type'))
        for typ, offset in [('uint8', -1), ('uint8', 32), ('uint8', 33), ('uint8', (1 << 48) - 1),
                            ('address', 13), ('uint256', 1)]:
            cases.append((f'negative.offset.{command}.{typ}.{offset}', query(command, typ, offset, 0, 0, *value), 'ERR invalid-location'))
        for slot in (-1, 1 << 256):
            cases.append((f'negative.slot.{command}.{slot}', query(command, 'uint8', 0, slot, 0, *value), 'ERR invalid-location'))
        for word in (-1, 1 << 256):
            cases.append((f'negative.word.{command}.{word}', query(command, 'uint8', 0, 0, word, *value), 'ERR invalid-word'))
    for typ, width in WIDTHS.items():
        bound = 2 if typ == 'bool' else 1 << (width * 8)
        for value in (-1, bound):
            cases.append((f'negative.value.{typ}.{value}', query('write', typ, 0, 0, 0, value), f'ERR out-of-range:{typ}'))
    for offset in (0, 7, 31):
        for value in (2, 255):
            cases.append((f'negative.bool-read.{offset}.{value}', query('read', 'bool', offset, 0, value << (8 * offset)), 'ERR out-of-range:bool'))
    return cases


def unique(pairs):
    # Storage JSON must not repeat a key; plain json.loads would keep only the last copy.
    keys = [key for key, _ in pairs]
    repeated = sorted({key for key in keys if keys.count(key) > 1})
    if repeated:
        raise AssertionError('DUPLICATE-KEY ' + ','.join(repeated))
    return dict(pairs)


def refusal(expected):
    return isinstance(expected, str) and expected.startswith('EXIT ')


def refuse(root, query_text):
    # An adapter refusal stops the whole batch, so each refusal row runs alone.
    result = subprocess.run((str(root / '_build' / TARGET), query_text), cwd=root,
                            capture_output=True, text=True, timeout=60)
    if result.stdout:
        raise ValueError('ADAPTER refusal output ' + result.stdout)
    return f'EXIT {result.returncode} {result.stderr.strip()}'


def check(root, cases):
    observed = {}
    inband = [row for row in cases if not refusal(row[2])]
    for start in range(0, len(inband), 64):
        batch = inband[start:start + 64]
        lines = run(root, str(root / '_build' / TARGET), *(row[1] for row in batch)).splitlines()
        if len(lines) != len(batch):
            raise ValueError('ADAPTER row count')
        for (label, _, expected), line in zip(batch, lines):
            try:
                actual = json.loads(line, object_pairs_hook=unique) if isinstance(expected, dict) and line.startswith('{') else line
            except AssertionError as error:
                raise AssertionError(f'{label}: {error}') from error
            if actual != expected:
                raise AssertionError(f'{label}: expected {expected!r}, observed {actual!r}')
            observed[label] = line
    for label, query_text, expected in (row for row in cases if refusal(row[2])):
        actual = refuse(root, query_text)
        if actual != expected:
            raise AssertionError(f'{label}: expected {expected!r}, observed {actual!r}')
        observed[label] = actual
    return observed


MUTANTS = [
    ('EXACT-SPILL', 'Big.is_lt(Big.of_nat(32n), Big.of_nat((offset + width: Nat)))',
     'Big.is_le(Big.of_nat(32n), Big.of_nat((offset + width: Nat)))', 'layout.exact'),
    ('LATE-SPILL', 'Big.is_lt(Big.of_nat(32n), Big.of_nat((offset + width: Nat)))',
     'Big.is_lt(Big.of_nat(33n), Big.of_nat((offset + width: Nat)))', 'layout.late-spill'),
    ('ADDRESS-WIDTH', 'case Abi.Schema.Value_type.Address{}: 20n',
     'case Abi.Schema.Value_type.Address{}: 19n', 'layout.mixed'),
    ('BOOL-RANGE', 'def Layout.Packed.bits(typ: Abi.Schema.Value_type) -> Nat:\n  match typ:\n    case Abi.Schema.Value_type.Bool{}: 1n',
     'def Layout.Packed.bits(typ: Abi.Schema.Value_type) -> Nat:\n  match typ:\n    case Abi.Schema.Value_type.Bool{}: 8n', 'negative.value.bool.2'),
    ('READ-SHIFT', 'Big.shift_right(word, (offset * 8n: Nat))',
     'Big.shift_right(word, offset)', 'access.small.uint8.4'),
    ('WRITE-CLEAR', 'Big.sub(word, Big.shift_left(Layout.Packed.extract(word, Layout.Packed.width(typ), offset), shift))',
     'word', 'access.write.uint8.0.1.0'),
    ('OFFSET-BOUND', 'Big.of_nat((32n - width: Nat))', 'Big.of_nat(32n)', 'negative.offset.read.uint8.32'),
    ('WORD-RANGE', 'Abi.Codec.within(Big.of_nat(256n), word)', 'True{}', 'negative.word.read.-1'),
    ('SLOT-RANGE', 'Abi.Codec.within(Big.of_nat(256n), slot)', 'True{}', 'negative.slot.read.-1'),
    ('DUPLICATE', 'Layout.Packed.seen(name, seen), _ => Fail{Layout.Packed.Error.Duplicate_name{name}}',
     'False{}, _ => Fail{Layout.Packed.Error.Duplicate_name{name}}', 'negative.duplicate'),
    ('TYPE-DEDUPE', 'Layout.Packed.seen(name, seen), _ => Layout.Packed.type_rows(tail, seen)',
     'False{}, _ => Layout.Packed.type_rows(tail, seen)', 'layout.bools'),
]


def mutations(cases, work):
    source = (ROOT / 'src/layout.bend').read_text()
    witnesses = {row[0]: row for row in cases}
    killed = []
    with tempfile.TemporaryDirectory(prefix='assay-packing-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, old, new, witness in MUTANTS:
            if source.count(old) != 1:
                raise ValueError('MUTANT-PATTERN ' + name)
            (copy / 'src/layout.bend').write_text(source.replace(old, new))
            (work / (name + '-build.log')).write_text(build(copy))
            try:
                check(copy, [witnesses[witness]])
            except AssertionError as error:
                (work / (name + '-witness.log')).write_text(str(error) + '\n')
                killed.append(dict(name=name, witness=witness))
            else:
                raise ValueError('SURVIVED ' + name)
        (copy / 'src/layout.bend').write_text(source)
        (work / 'control-build.log').write_text(build(copy))
        check(copy, [witnesses[row[3]] for row in MUTANTS])
    return killed


def main():
    work = ROOT / '.gatework/layout-packed'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'build.log').write_text(build(ROOT))
    layout_cases, negative_cases = layouts(), negatives()
    access_cases, writes = accesses()
    cases = layout_cases + access_cases + negative_cases
    observed = check(ROOT, cases)
    readbacks, probes = [], set()
    for label, typ, offset, previous, value, mask in writes:
        actual = int(observed[label].removeprefix('OK '))
        if (actual & (WORD ^ mask)) != (previous & (WORD ^ mask)):
            raise AssertionError('NEIGHBOR ' + label)
        probe = query('read', typ, offset, WORD, actual)
        if probe not in probes:
            probes.add(probe)
            readbacks.append(('readback.' + label, probe, f'OK {value}'))
    if len({row[1] for row in access_cases + readbacks}) != len(access_cases) + len(readbacks):
        raise ValueError('DUPLICATE-PROBE')
    check(ROOT, readbacks)
    killed = mutations(cases, work)
    report = dict(layouts=len(layout_cases), accesses=len(access_cases) + len(readbacks),
                  negative=len(negative_cases), mutants=killed, restored_control='OK',
                  sources={path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                           for path in ('src/layout.bend', 'src/tests.bend', 'dev/build.py', 'dev/layout-packed-test.py')})
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print('LAYOUT-PACKED layouts=%d accesses=%d negative=%d mutants=%d scope=packing OK' %
          (report['layouts'], report['accesses'], report['negative'], len(killed)))


if __name__ == '__main__':
    try:
        main()
    except (AssertionError, ValueError, OSError, subprocess.TimeoutExpired) as error:
        print('LAYOUT-PACKED FAIL: ' + str(error), file=sys.stderr)
        raise SystemExit(1)

#!/usr/bin/env python3
"""Exercise the public mapping-slot command against cast and frozen slots."""
from pathlib import Path
import hashlib
import importlib.util
import json
import subprocess
import sys
from dataclasses import replace

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'dev'))
from cli_delta import cli_sources, source_records, only, pinned, PINS, LATE_PINS, TYPE_PINS, OPTIONAL_BASE
spec = importlib.util.spec_from_file_location('mapping_oracles', ROOT / 'dev/layout-mapping-test.py')
M = importlib.util.module_from_spec(spec)
spec.loader.exec_module(M)
BINARY = ROOT / '_build/bin/assay'


def call(args):
    return subprocess.run([str(BINARY), 'mapping-slot', *args], cwd=ROOT,
                          text=True, capture_output=True, timeout=30)


def success(label, args, expected):
    result = call(args)
    if (result.returncode != 0 or result.stderr or
            result.stdout != str(expected) + '\n'):
        raise ValueError(f'{label}: {result.returncode}: {result.stdout!r} {result.stderr!r}')


def key_text(typ, value, spelling):
    """One key in one spelling; canonical writes addresses as 0x and 40 digits."""
    return {
        'decimal': value,
        'hex': hex(int(value)),
        'boolean': ('true' if int(value) else 'false') if typ == 'bool' else value,
        'canonical': '0x' + format(int(value), '040x') if typ == 'address' else value,
    }[spelling]


def arguments(query, spelling):
    _command, types, base, *values = query.split('|')
    args = [hex(int(base)) if spelling == 'hex' else base]
    for typ, value in zip(types.split(','), values, strict=True):
        args.extend([typ, key_text(typ, value, spelling)])
    return args


def spellings(label, query):
    """Spellings that give distinct argv lists for one query.

    The reference rows reuse the base and address keys of scalar address
    rows, so they run once in the canonical address spelling. The boolean
    spelling runs only when the query has a bool key."""
    if label.startswith('reference.'):
        return ['canonical']
    boolean = ['boolean'] if 'bool' in query.split('|')[1].split(',') else []
    return ['decimal', 'hex'] + boolean


# The widest accepted spellings: 78 decimal and 64 hexadecimal digits,
# including leading zeroes. One more digit is refused (see refusals).
CAP_LABEL = 'scalar.uint256.0.1'
CAP_ARGS = [['0' * 78, 'uint256', '0' * 77 + '1'],
            ['0x' + '0' * 64, 'uint256', '0x' + '0' * 63 + '1']]


def refusals():
    rows = [
        ([], 'usage:'), (['0'], 'usage:'), (['0', 'uint8'], 'usage:'),
        (['0', 'uint8', '1', 'address'], 'expected TYPE KEY pairs'),
        (['0', 'uint8', '1', '--extra'], 'expected TYPE KEY pairs'),
        (['0', 'string', '1'], 'unsupported key type'),
        (['0', 'uint16', '1'], 'unsupported key type'),
        (['0', 'Uint8', '1'], 'unsupported key type'),
        (['0', '', '1'], 'unsupported key type'),
    ]
    malformed = 'expected a decimal or 0x-prefixed uint256'
    # 79 decimal or 65 hexadecimal digits pass the 78 and 64 digit caps, so
    # the parser refuses them as malformed even when the value fits.
    for bad in ('', '-', '-1', '+', '0x', '0xgg', '1.0', ' 1', '1 ',
                '0' * 78 + '1', '0x' + '0' * 64 + '1', '0x1' + '0' * 64):
        rows.append(([bad, 'uint256', '0'], malformed))
        rows.append((['0', 'uint256', bad], malformed))
    # The key position of 2^256 is the uint256 row of the BITS loop below.
    rows.append(([str(1 << 256), 'uint256', '0'], 'word exceeds uint256'))
    for typ, bits in M.BITS.items():
        rows.append((['0', typ, str(1 << bits)],
                     'word exceeds uint256' if bits == 256 else 'key exceeds ' + typ))
        rows.append((['2', 'address', '1', typ, str(1 << bits)],
                     'word exceeds uint256' if bits == 256 else 'key exceeds ' + typ))
    rows.extend([
        (['0', 'bool', 'TRUE'], 'expected true, false, a decimal or 0x-prefixed integer'),
        (['0', 'address', 'false'], malformed),
        (['0', 'uint8', 'true'], malformed),
        (['0', 'uint256', '1', 'string', 'x'], 'unsupported key type'),
    ])
    if len({tuple(args) for args, _marker in rows}) != len(rows):
        raise ValueError('DUPLICATE-REFUSAL')
    return rows


def compatibility():
    records = source_records(ROOT, '6afcedc')
    before, after = cli_sources(records)
    if before != after:
        raise ValueError('COMPATIBILITY changed a carried CLI declaration')
    controls = 0
    for name in sorted(PINS | LATE_PINS):
        row = only(records[1], name)
        if row is None or hashlib.sha256(row.source.encode()).hexdigest() != (PINS | LATE_PINS)[name]:
            raise ValueError('COMPATIBILITY missing command pin: ' + name)
        poison = [replace(r, source=r.source + '\n# unexpected change\n')
                  if r.key == row.key else r for r in records[1]]
        if pinned(records[0], poison) is not None:
            raise ValueError('COMPATIBILITY accepted a changed command pin: ' + name)
        if pinned(records[0], [r for r in records[1] if r.key != row.key]) is not None:
            raise ValueError('COMPATIBILITY accepted a missing pin: ' + name)
        if pinned(records[0], records[1] + [row]) is not None:
            raise ValueError('COMPATIBILITY accepted a duplicate pin: ' + name)
        controls += 3
    for name, digest in sorted(TYPE_PINS.items()):
        row = only(records[1], name, 'type')
        if row is None or hashlib.sha256(row.source.encode()).hexdigest() != digest:
            raise ValueError('COMPATIBILITY missing type pin: ' + name)
        poison = [replace(r, source=r.source + '\n# unexpected change\n')
                  if r.key == row.key else r for r in records[1]]
        for changed in (poison, [r for r in records[1] if r.key != row.key], records[1] + [row]):
            if pinned(records[0], changed) is not None:
                raise ValueError('COMPATIBILITY accepted an invalid type pin: ' + name)
            controls += 1
        base_row = only(records[0], name, 'type')
        for changed in ([r for r in records[0] if r.key != base_row.key], records[0] + [base_row]):
            if pinned(changed, records[1]) is not None:
                raise ValueError('COMPATIBILITY accepted an invalid baseline type: ' + name)
            controls += 1
    for name in sorted(OPTIONAL_BASE):
        row = only(records[0], name)
        duplicate = records[0] + [row] if row is not None else records[0] + [only(records[1], name)] * 2
        if pinned(duplicate, records[1]) is not None:
            raise ValueError('COMPATIBILITY accepted a duplicate baseline: ' + name)
        controls += 1
    root = only(records[1], 'Entry.Cli')
    poison = [replace(r, source=r.source + '\n# unreviewed reachable change\n')
              if r.key == root.key else r for r in records[1]]
    left, right = cli_sources([records[0], poison])
    if left == right:
        raise ValueError('COMPATIBILITY ignored an unreviewed reachable change')
    missing = [r for r in records[0] if r.name != 'Cli.Packed.Checked']
    left, right = cli_sources([missing, records[1]])
    if left == right:
        raise ValueError('COMPATIBILITY ignored a reachable reviewed addition')
    return controls + 2


def only_case(cases, name):
    found = [case for case in cases if case['name'] == name]
    if len(found) != 1:
        raise ValueError('MISSING-CASE ' + name)
    return found[0]


def main():
    if len(sys.argv) != 1:
        raise ValueError('usage: mapping-cli-test.py')
    pin_controls = compatibility()
    positives = M.positives()
    reference = M.reference()
    cases = []
    for label, query, expected in positives + reference:
        slot = int(expected.removeprefix('OK '))
        for spelling in spellings(label, query):
            args = arguments(query, spelling)
            success(label + '.' + spelling, args, slot)
            cases.append(dict(name=label + '.' + spelling, args=args, slot=str(slot)))
    cap = only_case(cases, CAP_LABEL + '.decimal')
    for index, args in enumerate(CAP_ARGS):
        name = CAP_LABEL + '.cap.' + ('decimal', 'hex')[index]
        success(name, args, cap['slot'])
        cases.append(dict(name=name, args=args, slot=cap['slot']))
    if len({tuple(case['args']) for case in cases}) != len(cases):
        raise ValueError('DUPLICATE-PROBE')
    negative = refusals()
    for args, marker in negative:
        result = call(args)
        if (result.returncode != 64 or result.stdout or
                not result.stderr.startswith('assay: mapping-slot:') or marker not in result.stderr):
            raise ValueError(f'REFUSAL {args!r}: {result.returncode}: {result.stdout!r} {result.stderr!r}')
    usage = subprocess.run([str(BINARY)], cwd=ROOT, text=True, capture_output=True, timeout=30)
    if usage.returncode != 64 or usage.stdout or 'mapping-slot BASE TYPE KEY' not in usage.stderr:
        raise ValueError('USAGE missing mapping-slot command')
    work = ROOT / '.gatework/mapping-cli'
    work.mkdir(parents=True, exist_ok=True)
    report = dict(version=1, positive=len(cases), oracle=len(positives), reference=len(reference),
                  refusal=len(negative), cases=cases,
                  sources={path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                           for path in ('src/cli.bend', 'src/layout.bend', 'src/abi.bend',
                                        'src/keccak.bend', 'dev/mapping-cli-test.py',
                                        'dev/layout-mapping-test.py', 'dev/cli_delta.py',
                                        'reference/erc20/slots.json')}, compatibility='OK', pin_controls=pin_controls)
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'MAPPING-CLI cases={len(cases)} oracle={len(positives)} reference={len(reference)} '
          f'refusals={len(negative)} OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, subprocess.TimeoutExpired, OSError) as error:
        print('MAPPING-CLI FAIL: ' + str(error), file=sys.stderr)
        sys.exit(1)

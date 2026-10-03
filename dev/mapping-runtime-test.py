#!/usr/bin/env python3
"""Check mapping source against independent slots and both Cancun executors."""
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/mapping-runtime'
spec = importlib.util.spec_from_file_location('mapping_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
C.WORK = WORK
MAX = (1 << 256) - 1
EXPECTED_TYPES = {
    't_address': dict(encoding='inplace', label='address', numberOfBytes='20'),
    't_bool': dict(encoding='inplace', label='bool', numberOfBytes='1'),
    't_mapping(t_address,t_mapping(t_address,t_mapping(t_bool,t_uint256)))': dict(encoding='mapping', label='mapping(address => mapping(address => mapping(bool => uint256)))', key='t_address', value='t_mapping(t_address,t_mapping(t_bool,t_uint256))', numberOfBytes='32'),
    't_mapping(t_address,t_mapping(t_address,t_uint256))': dict(encoding='mapping', label='mapping(address => mapping(address => uint256))', key='t_address', value='t_mapping(t_address,t_uint256)', numberOfBytes='32'),
    't_mapping(t_address,t_mapping(t_bool,t_uint256))': dict(encoding='mapping', label='mapping(address => mapping(bool => uint256))', key='t_address', value='t_mapping(t_bool,t_uint256)', numberOfBytes='32'),
    't_mapping(t_address,t_uint256)': dict(encoding='mapping', label='mapping(address => uint256)', key='t_address', value='t_uint256', numberOfBytes='32'),
    't_mapping(t_bool,t_bool)': dict(encoding='mapping', label='mapping(bool => bool)', key='t_bool', value='t_bool', numberOfBytes='32'),
    't_mapping(t_bool,t_uint256)': dict(encoding='mapping', label='mapping(bool => uint256)', key='t_bool', value='t_uint256', numberOfBytes='32'),
    't_mapping(t_uint8,t_uint8)': dict(encoding='mapping', label='mapping(uint8 => uint8)', key='t_uint8', value='t_uint8', numberOfBytes='32'),
    't_uint256': dict(encoding='inplace', label='uint256', numberOfBytes='32'),
    't_uint8': dict(encoding='inplace', label='uint8', numberOfBytes='1'),
    't_mapping(t_uint256,t_address)': dict(encoding='mapping', label='mapping(uint256 => address)', key='t_uint256', value='t_address', numberOfBytes='32'),
}


def require(ok, message):
    if not ok:
        raise AssertionError('MAPPING-RUNTIME ' + message)


def trace_record(line):
    try:
        value = json.loads(line)
    except ValueError:
        return {}
    return value if isinstance(value, dict) else {}


def memory_size(record):
    value = record['memSize']
    return int(value, 0) if isinstance(value, str) else int(value)


def storage(words):
    return {str(slot): hex(value) for slot, value in words.items() if value}


def main():
    require(shutil.which('evm') and shutil.which('cast'), 'evm and cast are required')
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True, exist_ok=True)
    source = (ROOT / 'examples/MappingAccess.asy').read_text()
    path, output, runtime = C.emit('mapping', source)
    C.checked('check', [C.BINARY, 'check', path])
    layout = json.loads((output / 'layout.json').read_text())
    expected_fields = [
        ('enabled', 0, 0, 't_bool'), ('owner', 0, 1, 't_address'),
        ('balances', 1, 0, 't_mapping(t_address,t_uint256)'),
        ('allowances', 2, 0, 't_mapping(t_address,t_mapping(t_address,t_uint256))'),
        ('narrow', 3, 0, 't_mapping(t_uint8,t_uint8)'),
        ('flags', 4, 0, 't_mapping(t_bool,t_bool)'),
        ('triple', 5, 0, 't_mapping(t_address,t_mapping(t_address,t_mapping(t_bool,t_uint256)))'),
        ('wide', 6, 0, 't_mapping(t_uint256,t_address)'),
        ('count', 7, 0, 't_uint8'),
    ]
    expected = [dict(astId=i, contract='MappingAccess', label=name, slot=str(slot),
                     offset=offset, type=typ)
                for i, (name, slot, offset, typ) in enumerate(expected_fields)]
    require(layout['storage'] == expected, 'declared physical layout')
    require(all(not x['label'].startswith('assayMap') for x in layout['storage']),
            'temporary cells must not appear in the physical layout')
    require(layout['types'] == EXPECTED_TYPES,
            'complete type metadata: ' + json.dumps(layout['types'], sort_keys=True))
    slots, selectors = {}, {}

    def slot(base, *keys):
        cache_key = (base, keys)
        if cache_key not in slots:
            result = base
            for depth, key in enumerate(keys):
                preimage = '0x' + f'{key:064x}' + f'{result:064x}'
                digest = C.checked(f'slot-{base}-{len(slots)}-{depth}',
                                   ['cast', 'keccak', preimage]).strip()
                result = int(digest, 16)
            slots[cache_key] = result
        return slots[cache_key]

    def data(name, args):
        signature = name + '(' + ','.join(['uint256'] * len(args)) + ')'
        if signature not in selectors:
            selectors[signature] = C.checked('selector-' + name, ['cast', 'sig', signature]).strip()[2:]
        return selectors[signature] + ''.join(f'{value:064x}' for value in args)

    cases = []

    # Ordinary identifiers do not select mapping lowering or reserve its prefix.
    plain = ('contract Plain where storage State := { count : Word }\n'
             'entry echo (Mapping : Word) (assayMapUser : Word) : Eff Sig Word := do pure Mapping\n')
    plain_path, _, _ = C.emit('plain-identifiers', plain)
    C.checked('plain-identifiers-check', [C.BINARY, 'check', plain_path])
    plain_result = C.checked('plain-identifiers-run',
                             [C.BINARY, 'run', plain_path, '--calldata', data('echo', [7, 9])])
    require(json.loads(plain_result) == dict(status='success', output='0x' + f'{7:064x}', storage={}),
            'ordinary identifiers must retain Word contract behavior')

    def case(name, method, args, before, after, value):
        cases.append((name, method, args, before, after, value))

    b1, b2, bmax = slot(1, 1), slot(1, 2), slot(1, (1 << 160) - 1)
    a12, a21 = slot(2, 1, 2), slot(2, 2, 1)
    n7, n255 = slot(3, 7), slot(3, 255)
    f0, f1 = slot(4, 0), slot(4, 1)
    triple = slot(5, 1, 2, 1)
    packed = 1 | (0x123456789abcdef << 8)
    case('empty-read', 'balanceOf', [1], {}, {}, 0)
    case('read-prestate', 'balanceOf', [1], {b1: 42, b2: 8}, {b1: 42, b2: 8}, 42)
    case('read-largest-address', 'balanceOf', [(1 << 160) - 1], {bmax: MAX}, {bmax: MAX}, MAX)
    case('write-return-preserves-args', 'setBalance', [1, 99], {0: packed, b2: 8}, {0: packed, b1: 99, b2: 8}, 99)
    case('overwrite', 'setBalance', [1, 5], {b1: 42}, {b1: 5}, 5)
    case('delete', 'setBalance', [1, 0], {b1: 42}, {}, 0)
    case('maximum-value', 'setBalance', [1, MAX], {}, {b1: MAX}, MAX)
    case('address-key-overflow-read', 'balanceOf', [1 << 160], {b1: 42}, {b1: 42}, None)
    case('address-key-overflow-write', 'setBalance', [1 << 160, 5], {b1: 42}, {b1: 42}, None)
    case('nested-read', 'allowance', [1, 2], {a12: 9, a21: 7}, {a12: 9, a21: 7}, 9)
    case('nested-write', 'approve', [1, 2, 123], {a21: 7}, {a12: 123, a21: 7}, 123)
    case('nested-key-overflow', 'approve', [1, 1 << 160, 123], {a12: 9}, {a12: 9}, None)
    case('transfer', 'move', [1, 2, 10], {b1: 42, b2: 8}, {b1: 32, b2: 18}, 18)
    case('self-transfer', 'move', [1, 1, 10], {b1: 42}, {b1: 42}, 42)
    case('insufficient-balance', 'move', [1, 2, 43], {b1: 42, b2: 8}, {b1: 42, b2: 8}, None)
    case('overflow-restores-first-write', 'move', [1, 2, 1], {b1: 42, b2: MAX}, {b1: 42, b2: MAX}, None)
    case('second-key-restores-first-write', 'move', [1, 1 << 160, 1], {b1: 42}, {b1: 42}, None)
    case('narrow-value', 'setNarrow', [7, 255], {0: packed}, {0: packed, 7: 7, n7: 255}, 255)
    case('narrow-preserves-upper-bits', 'setNarrow', [7, 9], {n7: 0xab00}, {7: 7, n7: 0xab09}, 9)
    case('narrow-read-masks-upper-bits', 'readNarrow', [7], {n7: 0xab09}, {n7: 0xab09}, 9)
    case('narrow-largest-key', 'setNarrow', [255, 5], {}, {7: 7, n255: 5}, 5)
    case('narrow-value-restores-scalar', 'setNarrow', [7, 256], {7: 3}, {7: 3}, None)
    case('narrow-key-restores-scalar', 'setNarrow', [256, 1], {7: 3}, {7: 3}, None)
    case('bool-false-key', 'setFlag', [0, 1], {}, {f0: 1}, 1)
    case('bool-true-key', 'setFlag', [1, 1], {}, {f1: 1}, 1)
    case('bool-bad-key', 'setFlag', [2, 1], {f0: 1}, {f0: 1}, None)
    case('bool-bad-value', 'setFlag', [1, 2], {f0: 1}, {f0: 1}, None)
    case('bool-noncanonical-prestate', 'readFlag', [1], {f1: 2}, {f1: 2}, None)
    case('triple-write', 'setTriple', [1, 2, 1, 17], {}, {triple: 17}, 17)
    case('triple-read', 'readTriple', [1, 2, 1], {triple: 17}, {triple: 17}, 17)
    case('triple-bad-key', 'setTriple', [1, 2, 2, 17], {triple: 17}, {triple: 17}, None)
    case('scalar-neighbor', 'setEnabled', [0], {0: packed, b1: 42}, {0: packed & ~255, b1: 42}, 0)
    case('scalar-read', 'readOwner', [], {0: packed}, {0: packed}, packed >> 8)
    w1, wbig = slot(6, 1), slot(6, (1 << 255) + 3)
    t321, t123 = slot(5, 3, 2, 1), slot(5, 1, 2, 3)
    wide_high = 0xff << 160
    case('wide-uint256-key', 'setWide', [(1 << 255) + 3, 0x1234], {}, {wbig: 0x1234}, 0x1234)
    case('wide-address-value-overflow', 'setWide', [1, 1 << 160], {w1: 5}, {w1: 5}, None)
    case('wide-read-masks', 'readWide', [1], {w1: wide_high | 0x1234}, {w1: wide_high | 0x1234}, 0x1234)
    case('wide-write-preserves', 'setWide', [1, 0x5678], {w1: wide_high | 0x1234},
         {w1: wide_high | 0x5678}, 0x5678)
    case('triple-distinct-keys', 'readTriple', [3, 2, 1], {t321: 11, t123: 99}, {t321: 11, t123: 99}, 11)
    case('flag-read-upper-bits', 'readFlag', [1], {f1: 0x101}, {f1: 0x101}, 1)
    case('flag-write-preserves', 'setFlag', [1, 1], {f1: 0xab00}, {f1: 0xab01}, 1)
    def execute(name, path, runtime, method, args, before, after, value):
        calldata = data(method, args)
        expected = dict(status='revert' if value is None else 'success',
                        output='0x' if value is None else '0x' + f'{value:064x}', storage=storage(after))
        initial = {hex(key): hex(value) for key, value in before.items()}
        actual, raw = C.D.execute(runtime, calldata, C.prestate(initial), shutil.which('evm'))
        observed = dict(status=actual['status'], output=actual['output'],
                        storage=actual['storage'].get(C.D.RECEIVER, {}))
        require(observed == expected, name + ': EVM ' + json.dumps(dict(expected=expected, actual=observed)))
        argv = [C.BINARY, 'run', path, '--calldata', calldata]
        for key, value in before.items():
            argv += ['--storage', f'{key}={value}']
        result = C.capture('model-' + name, argv)
        require(result.returncode == 0, name + ': model failed: ' + result.stderr)
        require(json.loads(result.stdout) == expected, name + ': model ' + result.stdout)
        C.save('case-' + name, dict(expected=expected, evm=observed, raw=raw))

    for name, method, args, before, after, value in cases:
        execute(name, path, runtime, method, args, before, after, value)

    header = 'contract Invalid where storage State := { balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) }\n'
    balance_entry = 'entry balanceOf (account : Word) : Eff Sig Word := do value <- sload balances account ; pure value'
    many = ['balances : Mapping Address Uint256'] + [f'field{i} : Uint256' for i in range(32)]
    # Each refusal must exit 1 with its own diagnostic under check, emit and run.
    # Mapping lowering rebuilds declarations from generated tokens, so the member
    # limit reports line 0, column 0 instead of the 33rd field's position.
    invalid = {
        'missing-read-key': (header + 'entry bad () : Eff Sig Word := do value <- sload balances ; pure value',
                             'line 2, column 59: SURFACE_NAME: expected an unreserved identifier of at most 64 characters'),
        'missing-write-value': (header + 'entry bad (key : Word) : Eff Sig Word := do sstore balances key ; pure key',
                                'line 2, column 65: SURFACE_NAME: expected an unreserved identifier of at most 64 characters'),
        'unknown-key': (header + 'entry bad () : Eff Sig Word := do value <- sload balances missing ; pure value',
                        'line 2, column 59: SURFACE_SCOPE: unbound word missing'),
        'extra-key': (header + 'entry bad (key : Word) : Eff Sig Word := do value <- sload balances key key ; pure value',
                      'line 2, column 73: SURFACE_SYNTAX: expected ;'),
        'missing-nested-key': (header + 'entry bad (key : Word) : Eff Sig Word := do value <- sload allowances key ; pure value',
                               'line 2, column 75: SURFACE_NAME: expected an unreserved identifier of at most 64 characters'),
        'unknown-field': (header + 'entry bad (key : Word) : Eff Sig Word := do value <- sload missing ; pure value',
                          'SURFACE_SLOT: unknown field missing'),
        'reserved-local': (header + 'entry bad (assayMap0 : Word) : Eff Sig Word := do pure assayMap0',
                           'line 1, column 1: SURFACE_RESERVED: assayMap names are reserved for mapping lowering'),
        'too-many-user-fields': ('contract Invalid where storage State := { ' + ' ; '.join(many) + ' }\n' + balance_entry,
                                 'line 0, column 0: SURFACE_LIMIT: at most 32 members'),
        'deployer-mapping-root': (header + 'entry get (key : Word) : Eff Sig Word := do value <- sload balances key ; pure value\n'
                                  'constructor := do deployer balances ; pure ()',
                                  'MAPPING: mapping root accepts only keyed sload and sstore'),
    }
    for name, (source, message) in invalid.items():
        bad = WORK / (name + '.asy')
        bad.write_text(source + '\n')
        for command in ('check', 'emit', 'run'):
            destination = WORK / ('invalid-' + name + '-' + command)
            argv = [C.BINARY, command, bad]
            if command == 'emit':
                argv += ['-o', destination]
            result = C.capture(name + '-' + command, argv)
            require(result.returncode == 1 and message in result.stderr,
                    name + ': ' + command + ' must exit 1 with ' + repr(message) + ', got '
                    + str(result.returncode) + ' ' + repr(result.stderr))
            require(not destination.exists(), name + ': emitted invalid output')

    # Generated key and access cells do not count toward the 32 user members.
    boundary_fields = ['balances : Mapping Address Uint256'] + [f'field{i} : Uint256' for i in range(31)]
    boundary = ('contract Boundary where storage State := { ' + ' ; '.join(boundary_fields) + ' }\n'
                'entry get (key : Word) : Eff Sig Word := do value <- sload balances key ; pure value\n')
    boundary_path, _, boundary_runtime = C.emit('member-boundary', boundary)
    C.checked('member-boundary-check', [C.BINARY, 'check', boundary_path])
    boundary_slot = slot(0, 1)
    execute('member-boundary', boundary_path, boundary_runtime, 'get', [1],
            {boundary_slot: 5}, {boundary_slot: 5}, 5)

    # An entry parameter may reuse a mapping root name; only storage statements on the root are refused.
    shadow = header + 'entry echo (balances : Word) : Eff Sig Word := do pure balances\n'
    shadow_path, _, shadow_runtime = C.emit('mapping-root-parameter', shadow)
    C.checked('mapping-root-parameter-check', [C.BINARY, 'check', shadow_path])
    execute('mapping-root-parameter', shadow_path, shadow_runtime, 'echo', [7], {}, {}, 7)

    # Mapping scratch follows the program's highest memory word, not its size.
    peaks = {}
    for method, args in (('balanceOf', [1]), ('approve', [1, 2, 3])):
        traced = C.capture('memory-' + method,
                           ['evm', 'run', '--code', runtime, '--input', data(method, args), '--json'])
        require(traced.returncode == 0, 'memory trace ' + method + ': ' + traced.stderr[-400:])
        sizes = [memory_size(record)
                 for record in map(trace_record, (traced.stdout + traced.stderr).splitlines())
                 if 'memSize' in record]
        require(sizes, 'memory trace ' + method + ' has no memSize records')
        peaks[method] = max(sizes)
        require(peaks[method] <= 1024, f'{method} peak memory {peaks[method]} exceeds 1024 bytes')

    init = (output / 'init.hex').read_text().strip()
    result = C.capture('constructor', ['evm', 'run', '--create', '--sender', '0x' + C.D.SENDER,
                                      '--gas', str(C.D.GAS), '--code', init, '--json', '--dump'])
    require(result.returncode == 0, 'constructor executor: ' + result.stderr)
    outcome = C.D.run_outcome(result.stdout)
    created = [value for address, value in outcome['storage'].items() if address != C.D.SENDER]
    require(outcome['status'] == 'success' and outcome['output'] == runtime,
            'constructor must return the emitted runtime exactly')
    require(created == [storage({0: 1 | (int(C.D.SENDER, 16) << 8), b1: 42, a12: 9})],
            'constructor mapping and scalar initialization: ' + json.dumps(outcome['storage']))
    C.save('summary', dict(live_cases=len(cases), refusal_cases=len(invalid) * 3,
                           constructor=True, physical_layout=True, plain_identifier_controls=3,
                           member_boundary_control=True, mapping_root_parameter_control=True,
                           peak_memory_bytes=peaks))
    print(f'MAPPING-RUNTIME live={len(cases)} refusals={len(invalid) * 3} constructor=1 layout=1 OK')


if __name__ == '__main__':
    try:
        main()
    except (AssertionError, OSError, subprocess.SubprocessError, ValueError) as error:
        print(error, file=sys.stderr)
        raise SystemExit(1)

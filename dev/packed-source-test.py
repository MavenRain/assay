#!/usr/bin/env python3
"""Compile typed source and compare its EVM behavior with packed word goldens."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

SCRIPT_ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('packed_context', SCRIPT_ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
MAX = (1 << 256) - 1
OWNER = int('1234567890abcdef1234567890abcdef12345678', 16)


def require(ok, message):
    if not ok:
        raise AssertionError('PACKED-SOURCE ' + message)


def storage(words):
    return {str(slot): hex(value) for slot, value in words.items() if value}


def fixture():
    return (C.ROOT / 'examples/PackedStorage.asy').read_text()


def live():
    shutil.rmtree(C.WORK, ignore_errors=True)
    C.WORK.mkdir(parents=True, exist_ok=True)
    require(shutil.which('evm') is not None, 'evm is required')
    _, output, runtime = C.emit('source', fixture())
    layout = json.loads((output / 'layout.json').read_text())
    expected_layout = {
        'storage': [dict(astId=index, contract='PackedStorage', label=name, slot=str(slot),
                         offset=offset, type='t_' + typ)
                    for index, (name, slot, offset, typ) in enumerate([
                        ('count', 0, 0, 'uint8'), ('enabled', 0, 1, 'bool'),
                        ('owner', 0, 2, 'address'), ('total', 1, 0, 'uint256')])],
        'types': {'t_' + typ: dict(encoding='inplace', label=typ, numberOfBytes=str(width))
                  for typ, width in [('uint8', 1), ('bool', 1), ('address', 20), ('uint256', 32)]},
    }
    require(layout == expected_layout, 'layout golden: ' + json.dumps(layout))
    cases = []
    signatures = {}

    def selector(name, arity):
        if (name, arity) not in signatures:
            signature = name + '(' + ','.join(['uint256'] * arity) + ')'
            signatures[name, arity] = C.checked('sig-' + name, ['cast', 'sig', signature]).strip()[2:]
        return signatures[name, arity]

    def check(name, method, args, before, after, value=None, *, code=runtime):
        data = selector(method, len(args)) + ''.join(f'{arg:064x}' for arg in args)
        slots = {hex(k): hex(v) for k, v in before.items()}
        actual, raw = C.D.execute(code, data, C.prestate(slots), shutil.which('evm'))
        C.save(name + '-executors', raw)
        expected = dict(status='success' if value is not None else 'revert',
                        output='0x' + (f'{value:064x}' if value is not None else ''),
                        storage=storage(after))
        observed = dict(status=actual['status'], output=actual['output'],
                        storage=actual['storage'].get(C.D.RECEIVER, {}))
        require(observed == expected, name + ': ' + json.dumps(dict(expected=expected, actual=observed)))
        cases.append(dict(name=name, expected=expected, actual=actual))

    # Unused high bytes are part of the independent preservation golden.
    packed = (0xA5 << 248) | (OWNER << 16) | (1 << 8) | 173
    initial = {0: packed, 1: MAX - 7}
    for name, value in [('Count', 173), ('Enabled', 1), ('Owner', OWNER), ('Total', MAX - 7)]:
        check('read-' + name, 'read' + name, [], initial, initial, value)
    fields = [('Count', 0, 0, 8, 8), ('Enabled', 0, 8, 8, 1),
              ('Owner', 0, 16, 160, 160), ('Total', 1, 0, 256, 256)]
    for name, slot, offset, width, bits in fields:
        limit = 1 << bits
        for value in sorted({0, 1, limit - 1, min(limit, MAX), MAX}):
            after = dict(initial)
            if value < limit:
                mask = ((1 << width) - 1) << offset
                after[slot] = (after[slot] & (MAX ^ mask)) | (value << offset)
            check(f'write-{name}-{value}', 'set' + name, [value], initial, after,
                  value if value < limit else None)
    for dirty in [2, 255]:
        before = dict(initial)
        before[0] = (packed & (MAX ^ (255 << 8))) | (dirty << 8)
        check('dirty-read-' + str(dirty), 'readEnabled', [], before, before)
        for value in [0, 1]:
            after = dict(before)
            after[0] = (before[0] & (MAX ^ (255 << 8))) | (value << 8)
            check(f'dirty-repair-{dirty}-{value}', 'setEnabled', [value], before, after, value)
    check('rollback', 'setPair', [9, 2], initial, initial)
    after = dict(initial)
    after[0] = (packed & (MAX ^ 65535)) | (1 << 8) | 255
    check('sequential-writes', 'setPair', [255, 1], initial, after, 255)

    # Constructor offsets and deployer storage use the same physical layout.
    init = (output / 'init.hex').read_text().strip()
    actual, raw = C.evm_run('constructor', init, '', C.SENDER, create=True)
    # First CREATE from the fixture's key-1 sender at nonce zero.
    created = 'f2e246bb76df876cef8b38ae84130f4f55de395b'
    actual['storage'] = raw['storage'].get(created, {})
    require(actual == dict(status='success', output='0x' + runtime,
                           storage=storage({0: (C.SENDER << 16) | 263})),
            'constructor: ' + json.dumps(dict(status=actual['status'], storage=actual['storage'],
                                             runtime_matches=actual['output'] == '0x' + runtime)))
    cases.append(dict(name='constructor', actual=actual))
    for bad in [fixture().replace('(word 7)', '(word 256)'),
                fixture().replace('(word 1)', '(word 2)')]:
        _, out, _ = C.emit('bad-constructor-' + str(len(cases)), bad)
        actual, _ = C.evm_run('bad-init-' + str(len(cases)), (out / 'init.hex').read_text().strip(),
                              '', C.SENDER, create=True)
        require(actual == dict(status='revert', output='0x', storage={}), 'constructor rollback')
        cases.append(dict(name='constructor-reject', actual=actual))

    # Move the address first, so each access must use the computed offset.
    ordered = fixture().replace('count : Uint8 ; enabled : Bool ; owner : Address',
                                'owner : Address ; count : Uint8 ; enabled : Bool')
    _, out, reordered = C.emit('reordered', ordered)
    word = (0xA5 << 248) | OWNER | (173 << 160) | (1 << 168)
    for name, value in [('Count', 173), ('Enabled', 1), ('Owner', OWNER)]:
        check('reordered-read-' + name, 'read' + name, [], {0: word}, {0: word}, value, code=reordered)
    mask = 255 << 160
    check('reordered-write', 'setCount', [0], {0: word}, {0: word & (MAX ^ mask)}, 0, code=reordered)

    # A field that would cross a slot starts at the next physical word.
    spill = fixture().replace('count : Uint8 ; enabled : Bool ; owner : Address',
                              'count : Uint8 ; enabled : Bool ; filler : Address ; owner : Address')
    _, out, spilled = C.emit('spill', spill)
    check('spill-read', 'readOwner', [], {0: packed, 1: OWNER, 2: 17},
          {0: packed, 1: OWNER, 2: 17}, OWNER, code=spilled)
    check('spill-write', 'setOwner', [0], {0: packed, 1: OWNER, 2: 17},
          {0: packed, 1: 0, 2: 17}, 0, code=spilled)

    path = C.WORK / 'source.asy'
    checked = C.capture('checked', [C.BINARY, 'check', path])
    require(checked.returncode == 0, 'typed source must typecheck')
    result = C.capture('model-refusal', [C.BINARY, 'run', path])
    require(result.returncode == 64 and 'packed storage model is pending' in result.stderr,
            'model must explicitly refuse packed storage')
    for index, bad in enumerate([fixture().replace('Uint8', 'Uint9'),
                                 fixture().replace('enabled : Bool', 'count : Bool')]):
        path = C.WORK / f'invalid-{index}.asy'
        path.write_text(bad)
        destination = C.WORK / f'invalid-{index}-output'
        shutil.rmtree(destination, ignore_errors=True)
        result = C.capture('invalid-' + str(index), [C.BINARY, 'emit', path, '-o', destination])
        require(result.returncode != 0 and not destination.exists(), 'invalid source must fail before output')
    # The untyped Word path must retain its exact historical artifacts.
    _, out, _ = C.emit('word-control', fixture().replace('Uint8', 'Word').replace('Bool', 'Word')
                        .replace('Address', 'Word').replace('Uint256', 'Word'))
    path = C.WORK / 'word-control.asy'
    baseline = C.ROOT / 'dev/fixtures/packed-source-word'
    for filename in ['runtime.hex', 'init.hex', 'abi.json', 'layout.json']:
        require((out / filename).read_bytes() == (baseline / filename).read_bytes(),
                'Word artifact drift: ' + filename)
    result = C.capture('word-model-control', [C.BINARY, 'run', path, '--calldata',
                                             selector('readCount', 0), '--storage', '0=173'])
    require(result.returncode == 0, 'Word model must keep working')
    # Full-width typed fields pack nothing, so they keep the Word path and model.
    _, out, _ = C.emit('uint256-control', fixture().replace('Uint8', 'Uint256').replace('Bool', 'Uint256')
                       .replace('Address', 'Uint256'))
    for filename in ['runtime.hex', 'init.hex', 'abi.json', 'layout.json']:
        require((out / filename).read_bytes() == (baseline / filename).read_bytes(),
                'Uint256 artifact drift: ' + filename)
    full = C.capture('uint256-model-control', [C.BINARY, 'run', C.WORK / 'uint256-control.asy', '--calldata',
                                               selector('readCount', 0), '--storage', '0=173'])
    require(full.returncode == 0 and full.stdout == result.stdout, 'Uint256-only source must use the Word model')
    report = dict(cases=cases, layout=layout, source_sha256=hashlib.sha256(fixture().encode()).hexdigest())
    C.save('REPORT', report)
    return len(cases)


def mutants():
    layout = (C.ROOT / 'src/layout.bend').read_text()
    clear = next(line for line in layout.splitlines() if '+clear = Big.sub(' in line)
    mask = next(line for line in layout.splitlines() if line.startswith('def Emit.Packed.mask('))
    patches = [
        ('mask', 'layout', (mask, mask.split(' -> Big:', 1)[0] + ' -> Big: Big.zero()')),
        ('preserve', 'layout', (clear, '        +clear = Emit.Packed.mask(32n)')),
        ('boolean', 'assembler', ('serial, Big.of_nat(2n), Nil{})', 'serial, Big.of_nat(3n), Nil{})')),
    ]
    for name, module, (before, after) in patches:
        source = (C.ROOT / ('src/' + module + '.bend')).read_text()
        require(source.count(before) == 1, 'mutation anchor ' + name)
        with tempfile.TemporaryDirectory(prefix='assay-packed-' + name + '-') as directory:
            root = native_mutations.copy_project(C.ROOT, Path(directory) / 'assay')
            (root / ('src/' + module + '.bend')).write_text(source.replace(before, after))
            built = C.capture('mutant-build-' + name, [sys.executable, '-P', root / 'dev/build.py', 'build'],
                              cwd=root, timeout=600)
            require(built.returncode == 0, 'mutant must compile: ' + name)
            result = C.capture('mutant-' + name, [sys.executable, '-P', __file__, '--control', '--root', root],
                               timeout=600)
            require(result.returncode != 0 and 'PACKED-SOURCE' in result.stderr,
                    'mutant must fail a semantic assertion: ' + name)
    return len(patches)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--control', action='store_true')
    parser.add_argument('--root', type=Path, default=SCRIPT_ROOT)
    args = parser.parse_args()
    C.ROOT = args.root.resolve()
    C.BINARY = C.ROOT / '_build/bin/assay'
    C.WORK = C.ROOT / '.gatework/packed-source'
    cases = live()
    count = 0 if args.control else mutants()
    print(f'PACKED-SOURCE cases={cases} executors=run+t8n mutants={count} OK')


if __name__ == '__main__':
    main()

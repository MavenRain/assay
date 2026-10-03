#!/usr/bin/env python3
"""Compare typed source, its packed model and EVM behavior with word goldens."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import importlib.util
import json
from pathlib import Path
import re
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


def live(case_filter=None):
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
    sources = {runtime: C.WORK / 'source.asy'}

    def selector(name, arity):
        if (name, arity) not in signatures:
            signature = name + '(' + ','.join(['uint256'] * arity) + ')'
            signatures[name, arity] = C.checked('sig-' + name, ['cast', 'sig', signature]).strip()[2:]
        return signatures[name, arity]

    def check(name, method, args, before, after, value=None, *, code=runtime,
              calldata=None, sent=0, revert_output='0x'):
        if case_filter is not None and name != case_filter:
            return
        data = calldata if calldata is not None else selector(method, len(args)) + ''.join(f'{arg:064x}' for arg in args)
        slots = {hex(k): hex(v) for k, v in before.items()}
        actual, raw = C.D.execute(code, data, C.prestate(slots), shutil.which('evm'), value=sent)
        C.save(name + '-executors', raw)
        expected = dict(status='success' if value is not None else 'revert',
                        output='0x' + f'{value:064x}' if value is not None else revert_output,
                        storage=storage(after))
        observed = dict(status=actual['status'], output=actual['output'],
                        storage=actual['storage'].get(C.D.RECEIVER, {}))
        require(observed == expected, name + ': ' + json.dumps(dict(expected=expected, actual=observed)))
        argv = [C.BINARY, 'run', sources[code], '--calldata', data,
                '--caller', str(C.SENDER), '--address', str(int(C.D.RECEIVER, 16)), '--value', str(sent)]
        for slot, word in before.items():
            argv += ['--storage', f'{slot}={word}']
        model = C.capture(name + '-model', argv)
        require(model.returncode == 0, name + ': model failed: ' + model.stderr)
        modeled = json.loads(model.stdout)
        require(modeled == expected, name + ': ' + json.dumps(dict(expected=expected, model=modeled)))
        cases.append(dict(name=name, expected=expected, actual=actual, model=modeled))

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
    sources[reordered] = C.WORK / 'reordered.asy'
    word = (0xA5 << 248) | OWNER | (173 << 160) | (1 << 168)
    for name, value in [('Count', 173), ('Enabled', 1), ('Owner', OWNER)]:
        check('reordered-read-' + name, 'read' + name, [], {0: word}, {0: word}, value, code=reordered)
    mask = 255 << 160
    check('reordered-write', 'setCount', [0], {0: word}, {0: word & (MAX ^ mask)}, 0, code=reordered)

    # A field that would cross a slot starts at the next physical word.
    spill = fixture().replace('count : Uint8 ; enabled : Bool ; owner : Address',
                              'count : Uint8 ; enabled : Bool ; filler : Address ; owner : Address')
    _, out, spilled = C.emit('spill', spill)
    sources[spilled] = C.WORK / 'spill.asy'
    check('spill-read', 'readOwner', [], {0: packed, 1: OWNER, 2: 17},
          {0: packed, 1: OWNER, 2: 17}, OWNER, code=spilled)
    check('spill-write', 'setOwner', [0], {0: packed, 1: OWNER, 2: 17},
          {0: packed, 1: 0, 2: 17}, 0, code=spilled)

    # Exercise the source interpreter's remaining transaction branches with physical storage.
    entries = '''
  error Denied (code : Word)
  entry addCount (delta : Word) : Eff Sig Word := do
    old <- sload count ; value <- add old delta ; sstore count value ; pure value
  entry bumpAfterWrite (delta : Word) : Eff Sig Word := do
    sstore count (word 9) ; old <- sload count ; value <- add old delta ; sstore total value ; pure value
  entry subCount (delta : Word) : Eff Sig Word := do
    old <- sload count ; value <- sub old delta ; sstore count value ; pure value
  entry proven (delta : Word) : Eff Sig Word := do
    old <- sload count ; guard (lt256 (add old delta)) ;
    let value := addLt old delta ; sstore count value ; pure value
  entry guarded (cap : Word) : Eff Sig Word := do
    sstore count (word 7) ; guard (leWord (word 7) cap) ; pure (word 7)
  entry denyPacked () : Eff Sig Word := do sstore count (word 9) ; revert Denied (word 9)
  entry dirtyAfterWrite () : Eff Sig Word := do
    sstore count (word 9) ; value <- sload enabled ; pure value
  entry repairThenRead () : Eff Sig Word := do
    sstore enabled (word 1) ; value <- sload enabled ; pure value
  entry skipDirty () : Eff Sig Word := do pure (word 42)
  payable entry amount () : Eff Sig Word := do
    value <- callvalue ; sstore count value ; size <- calldatasize ; pure size
  entry loadArg (offset : Word) : Eff Sig Word := do value <- calldataload offset ; pure value
  entry self () : Eff Sig Word := do value <- address ; sstore total value ; pure value
  entry sender () : Eff Sig Word := do value <- caller ; sstore owner value ; pure value
  fallback : Eff Sig Never := revert Denied (word 23)
'''
    chunks = {}
    for chunk in re.split(r'(?m)(?=^  (?:error|entry|payable entry|fallback) )', entries):
        words = chunk.split()
        if words:
            key = words[2] if words[0] == 'payable' else words[1] if words[0] in ('entry', 'error') else words[0]
            chunks[key] = chunk

    def behavior(name, methods, *, dispatch=False):
        prefix = fixture().split('\n  entry readCount', 1)[0]
        rows = [chunks['Denied']] + [chunks[method] for method in methods]
        if dispatch:
            rows += ['  entry readCount () : Eff Sig Word := do value <- sload count ; pure value\n',
                     chunks['fallback']]
        source = prefix + '\n' + ''.join(rows) + '\n  constructor := do pure ()\n'
        path, _, code = C.emit(name, source)
        sources[code] = path
        return code

    arithmetic_code = behavior('arithmetic', ['addCount', 'bumpAfterWrite', 'subCount', 'proven', 'guarded'])
    low = dict(initial)
    low[0] = (packed & (MAX ^ 255)) | 7
    for name, method, arg, value in [('add', 'addCount', 1, 174), ('sub', 'subCount', 1, 172),
                                      ('proved', 'proven', 1, 174)]:
        after = dict(initial)
        after[0] = (packed & (MAX ^ 255)) | value
        check(name, method, [arg], initial, after, value, code=arithmetic_code)
    for name, method, arg in [('add-word-overflow', 'addCount', MAX),
                              ('add-field-overflow', 'addCount', 83),
                              ('sub-underflow', 'subCount', 174),
                              ('proved-overflow', 'proven', MAX)]:
        check(name, method, [arg], initial, initial, code=arithmetic_code)
    # A checked failure after a packed write must still restore the prestate.
    check('add-after-write-overflow', 'bumpAfterWrite', [MAX], initial, initial, code=arithmetic_code)
    check('guard-success', 'guarded', [7], initial, low, 7, code=arithmetic_code)
    check('guard-rollback', 'guarded', [6], initial, initial, code=arithmetic_code)
    error_code = behavior('errors', ['denyPacked', 'dirtyAfterWrite', 'repairThenRead', 'skipDirty'])
    denied = '0x' + selector('Denied', 1)
    check('custom-revert', 'denyPacked', [], initial, initial, code=error_code,
          revert_output=denied + f'{9:064x}')
    dirty = dict(initial)
    dirty[0] = (packed & (MAX ^ (255 << 8))) | (255 << 8)
    check('late-read-rollback', 'dirtyAfterWrite', [], dirty, dirty, code=error_code)
    check('repair-then-read', 'repairThenRead', [], dirty, initial, 1, code=error_code)
    check('unused-dirty-boolean', 'skipDirty', [], dirty, dirty, 42, code=error_code)
    # A dirty boolean byte does not block access to the other fields of its word.
    check('dirty-neighbor-read-Count', 'readCount', [], dirty, dirty, 173)
    check('dirty-neighbor-read-Owner', 'readOwner', [], dirty, dirty, OWNER)
    after = dict(dirty)
    after[0] = (dirty[0] & (MAX ^ 255)) | 5
    check('dirty-neighbor-write', 'setCount', [5], dirty, after, 5)
    context_code = behavior('contexts', ['amount', 'loadArg', 'self', 'sender'])
    after = dict(initial)
    after[0] = (packed & (MAX ^ 255)) | 3
    check('payable-context', 'amount', [], initial, after, 4, code=context_code, sent=3)
    # Offset 5 reads bytes 5..36, which differs from the operand and the argument.
    check('calldata-context', 'loadArg', [5], initial, initial, 5 << 8, code=context_code)
    check('calldata-selector', 'loadArg', [0], initial, initial,
          int(selector('loadArg', 1), 16) << 224, code=context_code)
    after = dict(initial)
    after[1] = int(C.D.RECEIVER, 16)
    check('address-context', 'self', [], initial, after, after[1], code=context_code)
    after = dict(initial)
    after[0] = (packed & (MAX ^ (((1 << 160) - 1) << 16))) | (C.SENDER << 16)
    check('caller-context', 'sender', [], initial, after, C.SENDER, code=context_code)
    dispatch_code = behavior('dispatch', ['addCount'], dispatch=True)
    for name, data in [('fallback-empty', ''), ('fallback-short', '00'),
                       ('fallback-unknown', 'ffffffff')]:
        check(name, '', [], initial, initial, code=dispatch_code, calldata=data,
              revert_output=denied + f'{23:064x}')
    check('fallback-value-reject', '', [], initial, initial, code=dispatch_code, calldata='', sent=1)
    check('entry-value-reject', 'readCount', [], initial, initial, code=dispatch_code, sent=1)
    check('short-argument-reject', 'addCount', [], initial, initial, code=dispatch_code,
          calldata=selector('addCount', 1))

    path = C.WORK / 'source.asy'
    checked = C.capture('checked', [C.BINARY, 'check', path])
    require(checked.returncode == 0, 'typed source must typecheck')
    result = C.capture('model-empty-calldata', [C.BINARY, 'run', path])
    require(result.returncode == 0 and json.loads(result.stdout) ==
            dict(status='revert', output='0x', storage={}), 'model empty-calldata rollback')
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
    require(case_filter is None or any(case['name'] == case_filter for case in cases),
            'selected case must run: ' + str(case_filter))
    return len(cases)


def mutants():
    layout = (C.ROOT / 'src/layout.bend').read_text()
    clear = next(line for line in layout.splitlines() if '+clear = Big.sub(' in line)
    mask = next(line for line in layout.splitlines() if line.startswith('def Emit.Packed.mask('))
    patches = [
        ('mask', 'layout', 'read-Count', (mask, mask.split(' -> Big:', 1)[0] + ' -> Big: Big.zero()')),
        ('preserve', 'layout', 'write-Count-0', (clear, '        +clear = Emit.Packed.mask(32n)')),
        ('boolean', 'assembler', 'dirty-read-2', ('serial, Big.of_nat(2n), Nil{})', 'serial, Big.of_nat(3n), Nil{})')),
        ('model-slot', 'frontend', 'read-Enabled',
         ('Model.Packed.field(rest, Big.sub(index, Big.one()))',
          'Model.Packed.field(fields, Big.sub(index, Big.one()))')),
        ('model-preserve', 'frontend', 'write-Count-0',
         ('Done{Some{Model.put(storage, slot, word)}}', 'Done{Some{Model.put([], slot, word)}}')),
        ('model-rollback', 'frontend', 'rollback',
         ('Model.Packed.after_write(fields, input, memory, next, written)',
          'Model.Packed.after_write(fields, MkModel_Input{Get.Model.Input.data(input), Get.Model.Input.value(input), Get.Model.Input.caller(input), Get.Model.Input.address(input), storage}, memory, next, written)')),
    ]
    def check_mutant(patch):
        name, module, case, (before, after) = patch
        source = (C.ROOT / ('src/' + module + '.bend')).read_text()
        require(source.count(before) == 1, 'mutation anchor ' + name)
        with tempfile.TemporaryDirectory(prefix='assay-packed-' + name + '-') as directory:
            root = native_mutations.copy_project(C.ROOT, Path(directory) / 'assay')
            (root / ('src/' + module + '.bend')).write_text(source.replace(before, after))
            built = C.capture('mutant-build-' + name, [sys.executable, '-P', root / 'dev/build.py', 'build', '_build/bin/assay'],
                              cwd=root, timeout=600)
            require(built.returncode == 0, 'mutant must compile: ' + name)
            result = C.capture('mutant-' + name, [sys.executable, '-P', __file__, '--control', '--case', case, '--root', root],
                               timeout=600)
            require(result.returncode != 0 and 'PACKED-SOURCE' in result.stderr,
                    'mutant must fail a semantic assertion: ' + name)
    # Each compiler holds a full checked book. Bound peak memory across mutants.
    with ThreadPoolExecutor(max_workers=1) as workers:
        list(workers.map(check_mutant, patches))
    return len(patches)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--control', action='store_true')
    parser.add_argument('--case', help='run one named live case for a compiled mutation control')
    parser.add_argument('--root', type=Path, default=SCRIPT_ROOT)
    args = parser.parse_args()
    if args.case is not None and not args.control:
        parser.error('--case requires --control')
    C.ROOT = args.root.resolve()
    C.BINARY = C.ROOT / '_build/bin/assay'
    C.WORK = C.ROOT / '.gatework/packed-source'
    cases = live(args.case)
    count = 0 if args.control else mutants()
    print(f'PACKED-SOURCE cases={cases} model=packed executors=run+t8n mutants={count} OK')


if __name__ == '__main__':
    main()

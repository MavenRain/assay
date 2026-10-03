#!/usr/bin/env python3
"""Compare typed source calldata with cast, the model and Cancun execution."""
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/function-abi'
spec = importlib.util.spec_from_file_location('function_abi_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)


def require(ok, message):
    if not ok:
        raise AssertionError(message)


def word(value):
    return f'{value:064x}'


def main():
    require(shutil.which('cast') and shutil.which('evm'), 'cast and evm are required')
    WORK.mkdir(parents=True, exist_ok=True)
    C.WORK = WORK
    source = ROOT / 'examples/FunctionCalldata.asy'
    output = WORK / 'compiled'
    if output.is_dir():
        shutil.rmtree(output)
    C.checked('check', [C.BINARY, 'check', source])
    C.checked('emit', [C.BINARY, 'emit', source, '-o', output])
    runtime = (output / 'runtime.hex').read_text().strip()
    abi = json.loads((output / 'abi.json').read_text())
    functions = {row['name']: row for row in abi if row['type'] == 'function'}
    expected_types = {'narrow': ['uint8'], 'addressOf': ['address'], 'boolean': ['bool'],
                      'wide': ['uint256'], 'lengthOf': ['string'], 'firstWord': ['string'],
                      'secondLength': ['string', 'string', 'bool'], 'legacy': ['uint256']}
    require(set(functions) == set(expected_types), 'complete function ABI')
    for name, types in expected_types.items():
        require([row['type'] for row in functions[name]['inputs']] == types, name + ': input ABI')
        require(functions[name]['stateMutability'] == ('nonpayable' if name in ('boolean', 'wide', 'secondLength') else 'view'), name + ': mutability')

    def calldata(signature, *args):
        return C.checked('cast-' + str(len(cases)), ['cast', 'calldata', signature, *map(str, args)]).strip()[2:]

    cases = []

    def add(name, signature, args, value, changed=None):
        data = calldata(signature, *args)
        cases.append((name, data, value, changed or {}))
        return data

    narrow = add('uint8-zero', 'narrow(uint8)', [0], 0)
    add('uint8-max', 'narrow(uint8)', [255], 255)
    address = add('address-max', 'addressOf(address)', ['0x' + 'ff' * 20], (1 << 160) - 1)
    boolean = add('bool-true', 'boolean(bool)', ['true'], 1, {0: 1})
    add('bool-false', 'boolean(bool)', ['false'], 0)
    wide = add('uint256-max', 'wide(uint256)', [(1 << 256) - 1], (1 << 256) - 1, {1: (1 << 256) - 1})
    legacy = add('legacy', 'legacy(uint256)', [42], 42)
    for text in ('', 'a', 'x' * 31, 'x' * 32, 'x' * 33, 'x' * 65, 'hello 🐙'):
        dynamic = add('string-' + str(len(cases)), 'lengthOf(string)', [text], len(text.encode()))
    first_word = add('string-data', 'firstWord(string)', ['hello'], int.from_bytes(b'hello'.ljust(32, b'\0'), 'big'))
    pair = add('two-strings', 'secondLength(string,string,bool)', ['first', 'second' * 6, 'true'], 36, {0: 1})
    add('empty-strings', 'secondLength(string,string,bool)', ['', '', 'false'], 0)
    selector = C.checked('selector', ['cast', 'sig', 'lengthOf(string)']).strip()[2:]
    binary = selector + word(32) + word(3) + '00ff80' + '00' * 29
    cases.append(('arbitrary-bytes', binary, 3, {}))
    # Word keeps the existing lenient decoding: a trailing byte after a Word argument is accepted.
    cases.append(('legacy-trailing-byte', legacy + '00', 42, {}))

    def bad(name, data):
        cases.append((name, data, None, {}))

    bad('uint8-overflow', narrow[:8] + word(256))
    bad('address-overflow', address[:8] + word(1 << 160))
    bad('bool-two', boolean[:8] + word(2))
    bad('uint256-truncated', wide[:-2])
    bad('scalar-trailing-byte', narrow + '00')
    bad('scalar-trailing-word', narrow + word(0))
    bad('typed-old-selector', C.checked('old-selector', ['cast', 'sig', 'narrow(uint256)']).strip()[2:] + word(7))
    for offset in (0, 1, 31, 64, (1 << 256) - 1):
        bad('offset-' + str(offset), selector + word(offset) + word(3) + '616263' + '00' * 29)
    bad('missing-length', selector + word(32))
    bad('truncated-length', binary[:134])
    bad('large-length', selector + word(32) + word(131072))
    bad('overflow-length', selector + word(32) + word((1 << 256) - 1))
    bad('missing-data', binary[:136])
    bad('short-padding', binary[:-2])
    bad('nonzero-padding', binary[:-2] + '01')
    bad('trailing-dynamic-word', binary + word(0))
    bad('two-strings-alias', pair[:72] + word(96) + pair[136:])
    bad('two-strings-gap', pair[:72] + word(192) + pair[136:])
    bad('two-strings-bool', pair[:136] + word(2) + pair[200:])
    # Each dynamic padding check has its own case: firstWord data, then the first and the second secondLength tail.
    bad('first-word-padding', first_word[:-2] + '01')
    bad('first-tail-padding', pair[:326] + '01' + pair[328:])
    bad('second-tail-padding', pair[:-2] + '01')
    bad('selector-only', narrow[:8])
    bad('bool-truncated', boolean[:8] + '01')

    initial = {1: 7}
    for name, data, value, changed in cases:
        storage = dict(initial)
        storage.update(changed)
        expected = dict(status='revert' if value is None else 'success',
                        output='0x' if value is None else '0x' + word(value),
                        storage={str(key): hex(item) for key, item in storage.items() if item})
        modeled = json.loads(C.checked('model-' + name, [C.BINARY, 'run', source, '--calldata', data, '--storage', '1=7']))
        require(modeled == expected, name + ': model ' + json.dumps(modeled))
        actual, evidence = C.D.execute(runtime, data, C.prestate({'0x1': '0x7'}), shutil.which('evm'))
        observed = dict(status=actual['status'], output=actual['output'], storage=actual['storage'].get(C.D.RECEIVER, {}))
        require(observed == expected, name + ': Cancun ' + json.dumps(observed))
        C.save('case-' + name, dict(expected=expected, model=modeled, evm=observed, evidence=evidence))

    mapping = WORK / 'mapping.asy'
    mapping.write_text('contract TypedMapping where storage State := { balances : Mapping Address Uint256 } '
                       'entry putBalance (key : Address) (amount : Uint256) : Eff Sig Word := do '
                       'sstore balances key amount ; value <- sload balances key ; pure value')
    mapped_output = WORK / 'mapped'
    if mapped_output.is_dir():
        shutil.rmtree(mapped_output)
    C.checked('mapping-emit', [C.BINARY, 'emit', mapping, '-o', mapped_output])
    mapped_runtime = (mapped_output / 'runtime.hex').read_text().strip()
    data = C.checked('mapping-cast', ['cast', 'calldata', 'putBalance(address,uint256)', '0x' + '00' * 19 + '01', '99']).strip()[2:]
    modeled = json.loads(C.checked('mapping-model', [C.BINARY, 'run', mapping, '--calldata', data]))
    actual, evidence = C.D.execute(mapped_runtime, data, C.prestate(), shutil.which('evm'))
    require(modeled['status'] == 'success' and modeled['output'] == '0x' + word(99), 'mapping model')
    require(modeled == dict(status=actual['status'], output=actual['output'], storage=actual['storage'].get(C.D.RECEIVER, {})), 'mapping agreement')
    C.save('typed-mapping', dict(model=modeled, evidence=evidence))

    # These inputs exceed the differential harness cap, so use geth run directly.
    large = selector + word(32) + word(130976) + '61' * 130976
    cap_cases = [('largest-string', large, 130976),
                 ('exact-cap-trailing', large + '00' * 28, None)]
    for name, data, value in cap_cases:
        result = C.capture('model-' + name, [C.BINARY, 'run', source, '--calldata', data, '--storage', '1=7'], timeout=120)
        require(result.returncode == 0, name + ': model input ' + result.stderr)
        expected = dict(status='success' if value is not None else 'revert',
                        output='0x' + word(value) if value is not None else '0x', storage={'1': '0x7'})
        require(json.loads(result.stdout) == expected, name + ': model outcome')
        actual, evidence = C.evm_run(name, runtime, data, int(C.D.SENDER, 16), slots={'0x1': '0x7'})
        require(actual == expected, name + ': geth outcome')
        C.save('case-' + name, dict(expected=expected, evm=actual, evidence=evidence))
    oversized = selector + word(32) + word(131008) + '61' * 131008
    result = C.capture('model-over-cap', [C.BINARY, 'run', source, '--calldata', oversized], timeout=120)
    require(result.returncode == 64 and '131072' in result.stderr and not result.stdout, 'model calldata cap refusal')
    actual, evidence = C.evm_run('over-cap', runtime, oversized, int(C.D.SENDER, 16), slots={'0x1': '0x7'})
    require(actual == dict(status='revert', output='0x', storage={'1': '0x7'}), 'EVM calldata cap refusal')
    C.save('case-over-cap', dict(evm=actual, evidence=evidence))

    collision = WORK / 'collision.asy'
    names = ('collision106936', 'collision119526')
    selectors = [C.checked('collision-' + name, ['cast', 'sig', name + '(uint8)']).strip() for name in names]
    require(selectors == ['0x45534f82', '0x45534f82'], 'independent selector collision fixture')
    collision.write_text('contract Collision where storage State := { cell : Word } ' +
                         ' '.join(f'entry {name} (value : Uint8) : Eff Sig Word := do pure value' for name in names))
    for command in ('emit', 'run'):
        arguments = [C.BINARY, command, collision]
        if command == 'emit':
            arguments += ['-o', WORK / 'collision-refused-output']
        result = C.capture('collision-' + command, arguments)
        require(result.returncode == 2 and 'function selector collision' in result.stderr and not result.stdout,
                'collision refusal: ' + command)

    refusals = {
        'string-as-word': ('entry f (text : String) : Eff Sig Word := do pure text', 'String parameters require stringlength or stringdata'),
        'length-of-word': ('entry f (value : Uint8) : Eff Sig Word := do size <- stringlength value ; pure size', 'string operation requires a String parameter'),
        'unknown-type': ('entry f (value : Bytes) : Eff Sig Word := do pure value', 'SURFACE_SYNTAX: expected Word'),
        'reserved': ('entry assayAbiUser (value : Uint8) : Eff Sig Word := do pure value', 'assayAbi names are reserved'),
    }
    for name, (entry, diagnostic) in refusals.items():
        path = WORK / (name + '.asy')
        path.write_text('contract Invalid where storage State := { cell : Word } ' + entry)
        for command in ('check', 'emit', 'run'):
            arguments = [C.BINARY, command, path]
            if command == 'emit':
                arguments += ['-o', WORK / (name + '-refused-output')]
            result = C.capture(name + '-' + command, arguments)
            require(result.returncode == 1 and diagnostic in result.stderr and not result.stdout, name + ': ' + command)

    # Core diagnostics in a typed source keep the source line and column. Bool and Word have the same length,
    # so each typed source and its Word twin must give the same diagnostic.
    positions = {
        'position-statement': ('entry narrow (value : {0}) : Eff Sig Word := do pure value\n'
                               '  entry bad (value : {0}) : Eff Sig Word := do bogus value ; pure value\n',
                               'line 4, column 55: SURFACE_SYNTAX: expected <-'),
        'position-duplicate': ('entry dup (value : {0}) (value : {0}) : Eff Sig Word := do pure value\n',
                               'line 3, column 29: SURFACE_DUPLICATE: duplicate name value'),
    }
    for name, (entries, diagnostic) in positions.items():
        results = []
        for form in ('Bool', 'Word'):
            path = WORK / (name + '-' + form.lower() + '.asy')
            path.write_text('contract Position where\n  storage State := { amount : Uint256 }\n  ' + entries.format(form))
            results.append(C.capture(name + '-' + form.lower() + '-check', [C.BINARY, 'check', path]))
        for result in results:
            require(result.returncode == 1 and result.stderr.startswith(diagnostic) and not result.stdout,
                    name + ': ' + result.stderr)
        require(results[0].stderr == results[1].stderr, name + ': typed and Word diagnostics differ')

    # A String parameter name is in scope only in its own entry. A later declaration can use the same name.
    scopes = {
        'scope-error': ('entry f (code : String) : Eff Sig Word := do size <- stringlength code ; pure size\n'
                        'error Denied (code : Word)'),
        'scope-predicate': ('entry f (x : String) : Eff Sig Word := do size <- stringlength x ; pure size\n'
                            'predicate Below (0 x : Word) (0 y : Word) : Prop := Le x y'),
        'scope-invariant': ('entry f (s : String) : Eff Sig Word := do size <- stringlength s ; pure size\n'
                            'invariant bounded (s : State) : Prop := Le s.low s.high'),
    }
    for name, declarations in scopes.items():
        path = WORK / (name + '.asy')
        path.write_text('contract Scope where storage State := { low : Word ; high : Word }\n' + declarations + '\n')
        scoped_output = WORK / (name + '-output')
        if scoped_output.is_dir():
            shutil.rmtree(scoped_output)
        C.checked(name + '-check', [C.BINARY, 'check', path])
        C.checked(name + '-emit', [C.BINARY, 'emit', path, '-o', scoped_output])

    print(f'FUNCTION-ABI cases={len(cases)} mapping=1 caps=3 collision=2 refusals={len(refusals) * 3} cast=OK model=OK run=OK t8n=OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, AssertionError, subprocess.SubprocessError) as error:
        print('FUNCTION-ABI FAIL: ' + str(error))
        raise SystemExit(1)

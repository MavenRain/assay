#!/usr/bin/env python3
"""Check empty entry arguments, dispatch, creation and exact schema refusals."""
import hashlib
import importlib.util
import json
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/nullary'
BINARY = ROOT / '_build/bin/assay'
spec = importlib.util.spec_from_file_location('nullary_model', ROOT / 'dev/model-test.py')
M = importlib.util.module_from_spec(spec)
spec.loader.exec_module(M)
P, C, D, require = M.P, M.C, M.D, M.require
SOURCE = ROOT / 'examples/Nullary.asy'
SIGNATURES = {'get': '6d4ce63c', 'increment': 'd09de08a', 'reset': 'd826f88f'}


def core():
    return P.core() + '''def count : Type 0 := Word 256
def Storage : Type 0 := prod (count)
def storage : Storage := tuple (word 256 0)
def get : Type 0 := (prod () : Type 0)
def increment : Type 0 := (prod () : Type 0)
def reset : Type 0 := (prod () : Type 0)
def Entry : Type 0 := sum (get, increment, reset)
def constructor : Eff := put storage.0 (word 256 7) (ret (word 256 0))
def main : Entry -> Tx := fun (entry : Entry) => case entry with
| 0 (args : get) => load storage.0 (fun (c : Word 256) => done c)
| 1 (args : increment) => load storage.0 (fun (c : Word 256) =>
    add c (word 256 1) (fun (result : ResultWord) => case result with
    | 0 (next : Word 256) => store storage.0 next (done next)
    | 1 (error : prod ()) => abort))
| 2 (args : reset) => store storage.0 (word 256 0) (done (word 256 0))
'''


def rows():
    result = []
    for name, values in [('get', (0, 7, 2**256 - 1)),
                         ('increment', (0, 7, 2**256 - 2, 2**256 - 1)),
                         ('reset', (7, 2**256 - 1))]:
        for before in values:
            failed = name == 'increment' and before == 2**256 - 1
            after = before if name == 'get' or failed else before + 1 if name == 'increment' else 0
            result.append(P.row(name + '-' + str(before), SIGNATURES[name], after,
                                after=hex(after), before=hex(before), status='revert' if failed else 'success'))
    for size in range(4):
        result.append(P.row('short-' + str(size), SIGNATURES['get'][:2 * size], 0,
                            after='0x7', status='revert'))
    result.append(P.row('unknown', 'ffffffff', 0, after='0x7', status='revert'))
    result.append(P.row('trailing', SIGNATURES['get'] + 'deadbeef', 7, after='0x7'))
    for name, selector in SIGNATURES.items():
        row = P.row('value-' + name, selector, 0, after='0x7', status='revert')
        row['value'] = 1
        result.append(row)
    return result


def files(folder):
    return {path.name: path.read_bytes() for path in folder.iterdir()}


def creation(runtime, init, folder):
    state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
    state['alloc'] = {D.SENDER: dict(balance='0xa')}
    prestate = folder / 'prestate.json'
    prestate.write_text(json.dumps(state))
    for value in (0, 1):
        text = P.checked('create-' + str(value), ['evm', '--verbosity', '0', 'run',
            '--prestate', prestate, '--sender', '0x' + D.SENDER, '--code', init,
            '--value', str(value), '--create', '--json', '--dump'])
        records, outcome = D.objects(text), D.run_outcome(text)
        installed = [account for owner, account in records[-1]['accounts'].items()
                     if D.address(owner) != D.SENDER]
        require(outcome['status'] == ('success' if value == 0 else 'revert'), 'NULLARY-CREATE status')
        if value == 0:
            require(outcome['output'] == runtime and len(installed) == 1 and
                    installed[0]['code'] == '0x' + runtime and
                    D.storage({D.RECEIVER: installed[0]}) == {D.RECEIVER: {'0': '0x7'}}, 'NULLARY-CREATE runtime/storage')
        else:
            require(outcome['output'] == '' and not installed, 'NULLARY-CREATE rollback')


def live():
    for name, selector in SIGNATURES.items():
        require(P.checked('sig-' + name, ['cast', 'sig', name + '()']).strip() == '0x' + selector,
                'NULLARY-SELECTOR ' + name)
    with tempfile.TemporaryDirectory(prefix='assay-nullary-') as temporary:
        folder = Path(temporary)
        runtime, init = P.emit(SOURCE, folder / 'surface', 'surface-emit')
        expected_abi = [dict(type='constructor', inputs=[], stateMutability='nonpayable')] + [dict(type='function', name=name, inputs=[],
                            outputs=[dict(name='', type='uint256')],
                            stateMutability='view' if name == 'get' else 'nonpayable') for name in SIGNATURES]
        require(json.loads((folder / 'surface/abi.json').read_text()) == expected_abi, 'NULLARY-ABI')
        for variant, text in [('typed', core()), ('one-typed', core().replace(
                'def reset : Type 0 := (prod () : Type 0)', 'def reset : Type 0 := prod ()').replace(
                'def increment : Type 0 := (prod () : Type 0)', 'def increment : Type 0 := prod ()'))]:
            directory = folder / variant
            directory.mkdir()
            source = directory / 'Nullary.asy'
            source.write_text(text)
            P.emit(source, directory / 'out', variant + '-emit')
            require(files(directory / 'out') == files(folder / 'surface'), 'NULLARY-FIVE-FILES ' + variant)
        for mode in ([], ['--print'], ['--erased']):
            result = M.capture('check-' + str(mode), [BINARY, 'check', *mode, SOURCE])
            require(result.returncode == 0 and not result.stderr and bool(result.stdout) == bool(mode), 'NULLARY-CHECK')
            if mode == ['--erased']:
                require('fun main (union sum<unit|unit|unit>)' in result.stdout and
                        'KCase sum<unit|unit|unit> (KVar 0)' in result.stdout, 'NULLARY-TAGS')
        require(P.checked('axioms', [BINARY, 'axioms', SOURCE]) == 'EvmOpcodes\n', 'NULLARY-AXIOMS')
        listing = P.listing('runtime', runtime)
        declared = {pc: opcode for pc, opcode, _immediate in listing}
        covered = set()
        for row in rows():
            M.model(row['name'], SOURCE, row)
            _report, evidence = P.execute('evm-' + row['name'], runtime, row)
            steps = D.objects(evidence['run'])[:-2]
            require(all(declared.get(step['pc']) == step['opName'] for step in steps), 'NULLARY-PC')
            covered.update(step['pc'] for step in steps)
        require(covered == set(declared), 'NULLARY-COVERAGE ' + str(sorted(set(declared) - covered)))
        creation(runtime, init, folder)
        (WORK / 'OUTPUTS.json').write_text(json.dumps(dict(runtime_bytes=len(runtime) // 2,
            init_bytes=len(init) // 2, covered=len(covered), files={name: hashlib.sha256(data).hexdigest()
            for name, data in files(folder / 'surface').items()}), indent=2) + '\n')
        widths = 0
        for count in (1, 2, 32):
            source = folder / f'Width{count}.asy'
            source.write_text('contract Width where storage State := { cell : Word }\n' +
                '\n'.join(f'entry f{i} () : Eff Sig Word := do pure (word {i + 1})' for i in range(count)))
            runtime, _init = P.emit(source, folder / f'width-{count}', f'width-{count}')
            abi = json.loads((folder / f'width-{count}/abi.json').read_text())
            require([row['name'] for row in abi if row['type'] == 'function'] == [f'f{i}' for i in range(count)] and
                    all(row['inputs'] == [] for row in abi), 'NULLARY-WIDTH-ABI')
            for index in range(count):
                selector = P.checked(f'sig-{count}-{index}', ['cast', 'sig', f'f{index}()']).strip()[2:]
                row = P.row(f'width-{count}-{index}', selector, index + 1, after='0x7')
                M.model(row['name'], source, row)
                P.execute(row['name'], runtime, row)
                widths += 1
    print(f'NULLARY-LIVE cases={len(rows())} widths={widths} creates=2 covered={len(covered)} OK', flush=True)
    return len(rows()) + widths


def refused(name, text, marker, folder):
    source = folder / (name + '.asy')
    source.write_text(text)
    P.checked('refusal-check-' + name, [BINARY, 'check', source])
    for command in ('emit', 'run'):
        output = folder / (name + '-out')
        args = ['-o', output] if command == 'emit' else []
        result = M.capture('refusal-' + name + '-' + command, [BINARY, command, source, *args])
        require(result.returncode == 2 and marker in result.stderr and not result.stdout and not output.exists(),
                'NULLARY-REFUSAL ' + name)


def refusals():
    cases = [
        ('bare', core().replace('(prod () : Type 0)', 'prod ()'), 'M1 nullary Entry needs an explicit'),
        ('prop', core().replace('def get : Type 0 := (prod () : Type 0)',
                              'def get : Prop := (prod () : Prop)'), 'M0_PROTOCOL: M1 get'),
        ('alias', core().replace('def get : Type 0 := (prod () : Type 0)',
                               'def Alias : Type 0 := (prod () : Type 0)\ndef get : Type 0 := Alias'), 'M0_PROTOCOL: M1 get'),
        ('nonempty', core().replace('def get : Type 0 := (prod () : Type 0)',
                                  'def get : Type 0 := (prod (count) : Type 0)'), 'M0_PROTOCOL: M1 get'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-nullary-refusals-') as temporary:
        for name, text, marker in cases:
            refused(name, text, marker, Path(temporary))
    return len(cases)


def witness(name):
    with tempfile.TemporaryDirectory(prefix='assay-nullary-witness-') as temporary:
        folder = Path(temporary)
        source = SOURCE
        if name == 'core':
            source = folder / 'Nullary.asy'
            source.write_text(core())
        require(name in ('surface', 'core'), 'NULLARY-WITNESS unknown ' + name)
        result = M.capture('witness-' + name, [BINARY, 'emit', source, '-o', folder / 'out'])
        require(result.returncode == 0 and not result.stderr, 'NULLARY-WITNESS ' + name)
        M.model('witness-' + name, source, next(row for row in rows() if row['name'] == 'get-7'))


def mutants():
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-nullary-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, relative, before, after, example in cases:
            path = copy / relative
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'NULLARY-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'NULLARY-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/nullary-test.py', 'witness', example], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and
                        (not mutated or 'NULLARY-WITNESS ' + example in result.stdout), 'NULLARY-MUTANT ' + label)
            print('NULLARY-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        witness(sys.argv[2])
        return
    if sys.argv[1:] in (['live'], ['refusals'], ['mutants']):
        {'live': live, 'refusals': refusals, 'mutants': mutants}[sys.argv[1]]()
        return
    if sys.argv[1:]:
        print('usage: dev/nullary-test.py [witness NAME|live|refusals|mutants]', file=sys.stderr)
        sys.exit(64)
    cases, invalid, killed = live(), refusals(), mutants()
    print(f'NULLARY-ENTRIES cases={cases} creates=2 refusals={invalid} mutants={killed} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('NULLARY-ENTRIES FAIL: ' + str(error))
        sys.exit(1)

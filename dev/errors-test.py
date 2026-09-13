#!/usr/bin/env python3
"""Compare typed revert bytes, schema checks and rollback with both EVM paths."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/errors'
BINARY = ROOT / '_build/default/bin/assay.exe'
spec = importlib.util.spec_from_file_location('errors_model', ROOT / 'dev/model-test.py')
M = importlib.util.module_from_spec(spec)
spec.loader.exec_module(M)
P, C, D, require = M.P, M.C, M.D, M.require
SOURCE = ROOT / 'examples/Errors.asy'
ERRORS = [('Denied', [], 'e3372e2d'),
          ('InsufficientBalance', ['available', 'required'], 'cf479181'),
          ('Snapshot', ['first', 'second', 'again'], '4721c31d')]
SELECTORS = {'deny': 'a3fdfee3', 'fail': '132e4f3c', 'snapshot': '37c3071a', 'get': '6d4ce63c'}
COLLISION = ('AssayError66951', 'AssayError96267')
MAX = 2**256 - 1


def encoded(selector, values=()):
    return '0x' + selector + ''.join(f'{value:064x}' for value in values)


def row(name, function, args=(), *, error='', values=(), before=7, value=0, success=False):
    result = P.row(name, encoded(SELECTORS[function], args), before, after=hex(before),
                   before=hex(before), status='success' if success else 'revert')
    result['value'] = value
    if not success:
        result['output'] = encoded(error, values)
    return result


def rows():
    result = [row('denied', 'deny', error=ERRORS[0][2])]
    result += [row(f'balance-{i}-{j}', 'fail', [amount], error=ERRORS[1][2],
                   values=[before, amount], before=before)
               for i, before in enumerate((0, 7, MAX)) for j, amount in enumerate((0, 9, MAX))]
    for i, (a, b) in enumerate(((0, 0), (2, 3), (MAX, 0), (MAX, 1), (11, 4))):
        overflow = a + b > MAX
        result.append(row(f'snapshot-{i}', 'snapshot', [a, b],
                          error='' if overflow else ERRORS[2][2], values=[] if overflow else [b, a, b]))
    result += [row(f'get-{i}', 'get', before=before, success=True) for i, before in enumerate((0, 7, MAX))]
    for size in range(4):
        item = row('short-' + str(size), 'deny')
        item['calldata'] = '0x' + SELECTORS['deny'][:2 * size]
        result.append(item)
    item = row('unknown', 'deny')
    item['calldata'] = '0xffffffff'
    result.append(item)
    item = row('short-argument', 'fail')
    item['calldata'] += '00' * 31
    result.append(item)
    item = row('trailing', 'fail', [9], error=ERRORS[1][2], values=[7, 9])
    item['calldata'] += 'deadbeef'
    result.append(item)
    result += [row('value-' + name, name, [2, 3] if name == 'snapshot' else [9] if name == 'fail' else [], value=1)
               for name in SELECTORS]
    return result


def core():
    prefix, tx = P.core().split('def ResultWord', 1)
    return prefix + '''def cell : Type 0 := Word 256
def available : Type 0 := Word 256
def required : Type 0 := Word 256
def InsufficientBalance : Type 0 := prod (available, required)
def Error : Type 0 := sum (InsufficientBalance)
def ResultWord''' + tx + '''  | reject : Error -> Tx
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def amount : Type 0 := Word 256
def fail : Type 0 := prod (amount)
def Entry : Type 0 := sum (fail)
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) => case entry with
| 0 (args : fail) => load storage.0 (fun (before : Word 256) =>
  store storage.0 args.0 (reject (inj 0 of 1 (tuple (before, args.0)) : Error)))
'''


def nullary_core():
    return core().replace('prod (available, required)', '(prod () : Type 0)').replace(
        'tuple (before, args.0)', 'tuple ()')


def creation(runtime, init, folder):
    state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
    state['alloc'] = {D.SENDER: dict(balance='0xa')}
    prestate = folder / 'prestate.json'
    prestate.write_text(json.dumps(state))
    for value in (0, 1):
        text = P.checked('create-' + str(value), ['evm', '--verbosity', '0', 'run', '--prestate', prestate,
            '--sender', '0x' + D.SENDER, '--code', init, '--value', str(value), '--create', '--json', '--dump'])
        records, outcome = D.objects(text), D.run_outcome(text)
        installed = [account for owner, account in records[-1]['accounts'].items() if D.address(owner) != D.SENDER]
        require(outcome['status'] == ('success' if value == 0 else 'revert'), 'ERROR-CREATE status')
        if value == 0:
            require(outcome['output'] == runtime and len(installed) == 1 and installed[0]['code'] == '0x' + runtime and
                    D.storage({D.RECEIVER: installed[0]}) == {D.RECEIVER: {'0': '0x7'}}, 'ERROR-CREATE install')
        else:
            require(outcome['output'] == '' and not installed, 'ERROR-CREATE rollback')


def live():
    for name, arguments, selector in ERRORS:
        signature = name + '(' + ','.join(['uint256'] * len(arguments)) + ')'
        require(P.checked('sig-' + name, ['cast', 'sig', signature]).strip() == '0x' + selector, 'ERROR-SELECTOR ' + name)
    with tempfile.TemporaryDirectory(prefix='assay-errors-') as temporary:
        folder = Path(temporary)
        runtime, init = P.emit(SOURCE, folder / 'surface', 'surface-emit')
        abi = json.loads((folder / 'surface/abi.json').read_text())
        expected = [dict(type='error', name=name, inputs=[dict(name=arg, type='uint256') for arg in args])
                    for name, args, _selector in ERRORS]
        require([item for item in abi if item['type'] == 'error'] == expected, 'ERROR-ABI')
        functions = [item for item in abi if item['type'] == 'function']
        require([item['name'] for item in functions] == list(SELECTORS) and
                [item['stateMutability'] for item in functions] == ['view', 'nonpayable', 'view', 'view'], 'ERROR-FUNCTIONS')
        for mode in ([], ['--print'], ['--erased']):
            result = M.capture('check-' + str(mode), [BINARY, 'check', *mode, SOURCE])
            require(result.returncode == 0 and not result.stderr, 'ERROR-CHECK')
        require(P.checked('axioms', [BINARY, 'axioms', SOURCE]) == 'EvmOpcodes\n', 'ERROR-AXIOMS')
        declared = {pc: opcode for pc, opcode, _immediate in P.listing('runtime', runtime)}
        covered, gas = set(), []
        for item in rows():
            M.model(item['name'], SOURCE, item)
            report, evidence = P.execute(item['name'], runtime, item)
            steps = D.objects(evidence['run'])[:-2]
            require(all(declared.get(step['pc']) == step['opName'] for step in steps), 'ERROR-PC')
            covered.update(step['pc'] for step in steps)
            gas.append(dict(name=item['name'], run_gas=report['run_gas'], t8n_execution_gas=report['t8n_execution_gas']))
        require(covered == set(declared), 'ERROR-COVERAGE ' + str(sorted(set(declared) - covered)))
        creation(runtime, init, folder)
        # The published ABI example fixes the selector independently of assay.
        require(P.checked('abi-encode', ['cast', 'calldata', 'InsufficientBalance(uint256,uint256)', '0', str(MAX)]).strip()
                == encoded('cf479181', [0, MAX]), 'ERROR-ABI-GOLD')
        source = folder / 'Core.asy'
        source.write_text(core())
        runtime_core, _init = P.emit(source, folder / 'core', 'core-emit')
        item = row('core', 'fail', [MAX], error='cf479181', values=[7, MAX])
        M.model('core', source, item)
        P.execute('core', runtime_core, item)
        M.model('no-tools', SOURCE, rows()[1], env={**os.environ, 'PATH': '/nonexistent'})
        widths = 0
        for count in (1, 2, 32):
            source = folder / f'Width{count}.asy'
            source.write_text('contract Width where storage State := { cell : Word }\n' +
                '\n'.join(f'error E{i} ()\nentry f{i} () : Eff Sig Word := do revert E{i} ()' for i in range(count)))
            wide, _init = P.emit(source, folder / f'width-{count}', f'width-{count}')
            wide_abi = json.loads((folder / f'width-{count}/abi.json').read_text())
            require([item['name'] for item in wide_abi if item['type'] == 'error'] == [f'E{i}' for i in range(count)], 'ERROR-WIDTH-ABI')
            for index in range(count):
                selector = P.checked(f'sig-f{count}-{index}', ['cast', 'sig', f'f{index}()']).strip()
                error = P.checked(f'sig-e{count}-{index}', ['cast', 'sig', f'E{index}()']).strip()
                item = P.row(f'width-{count}-{index}', selector, 0, after='0x7', status='revert')
                item['output'] = error
                M.model(item['name'], source, item)
                P.execute(item['name'], wide, item)
                widths += 1
        source = folder / 'Arguments.asy'
        names = [f'x{i}' for i in range(32)]
        source.write_text('contract Arguments where storage State := { cell : Word }\nerror Wide ' +
            ' '.join(f'({name} : Word)' for name in names) + '\nentry fail (amount : Word) : Eff Sig Word := do revert Wide ' +
            ' '.join('(amount)' for _name in names))
        wide, _init = P.emit(source, folder / 'arguments', 'arguments-emit')
        selector = P.checked('sig-Wide', ['cast', 'sig', 'Wide(' + ','.join(['uint256'] * 32) + ')']).strip()[2:]
        item = row('arguments-32', 'fail', [MAX], error=selector, values=[MAX] * 32)
        M.model(item['name'], source, item)
        P.execute(item['name'], wide, item)
        (WORK / 'OUTPUTS.json').write_text(json.dumps(dict(runtime_bytes=len(runtime) // 2, init_bytes=len(init) // 2,
            covered=len(covered), gas=gas, files={path.name: hashlib.sha256(path.read_bytes()).hexdigest()
            for path in (folder / 'surface').iterdir()}), indent=2) + '\n')
    count = len(rows()) + widths + 2
    print(f'ERROR-LIVE cases={count} creates=2 covered={len(covered)} OK', flush=True)
    return count


def refusal(name, text, marker, folder, checked=False):
    source = folder / (name + '.asy')
    source.write_text(text)
    if checked:
        P.checked('refusal-check-' + name, [BINARY, 'check', source])
    for command in (('emit', 'run') if checked else ('check', 'emit', 'run')):
        output = folder / (name + '-out')
        args = ['-o', output] if command == 'emit' else []
        result = M.capture('refusal-' + name + '-' + command, [BINARY, command, source, *args])
        require(result.returncode == (2 if checked else 1) and marker in result.stderr and
                not result.stdout and not output.exists(), 'ERROR-REFUSAL ' + name)


def refusals():
    base = 'contract Bad where storage State := { cell : Word }\n'
    entry = 'entry fail (amount : Word) : Eff Sig Word := do '
    good = base + 'error Denied ()\n' + entry + 'revert Denied ()'
    cases = [
        ('unknown', base + entry + 'revert Missing ()', 'SURFACE_ERROR'),
        ('arity', good.replace('Denied ()\n', 'Denied (n : Word)\n'), 'SURFACE_ERROR'),
        ('extra', good.replace('revert Denied ()', 'revert Denied (amount)'), 'SURFACE_ERROR'),
        ('scope', good.replace('error Denied ()', 'error Denied (n : Word)').replace('revert Denied ()', 'revert Denied (missing)'), 'SURFACE_SCOPE'),
        ('type', good.replace('error Denied ()', 'error Denied (n : Nat)'), 'SURFACE_SYNTAX'),
        ('duplicate', good.replace('error Denied ()', 'error Denied ()\nerror Denied ()'), 'SURFACE_DUPLICATE'),
        ('argument-duplicate', good.replace('error Denied ()', 'error Denied (n : Word) (n : Word)'), 'SURFACE_DUPLICATE'),
        ('global', good.replace('Denied', 'State'), 'SURFACE_DUPLICATE'),
        ('entry-name', good.replace('Denied', 'fail'), 'SURFACE_DUPLICATE'),
        ('alias-name', good.replace('Denied', 'amount'), 'SURFACE_DUPLICATE'),
        ('reserved', good.replace('Denied', 'Error'), 'SURFACE_NAME'),
        ('literal', good.replace('error Denied ()', 'error Denied (n : Word)').replace('revert Denied ()', f'revert Denied (word {MAX + 1})'), 'SURFACE_WORD'),
        ('constructor', good + '\nconstructor := do revert Denied ()', 'SURFACE_CONSTRUCTOR'),
        ('errors-33', base + '\n'.join(f'error E{i} ()' for i in range(33)) + '\n' + entry + 'pure amount', 'SURFACE_LIMIT'),
        ('arguments-33', base + 'error Wide ' + ' '.join(f'(x{i} : Word)' for i in range(33)) + '\n' + entry + 'pure amount', 'SURFACE_LIMIT'),
        ('values-33', good.replace('revert Denied ()', 'revert Denied ' + '(amount) ' * 33), 'SURFACE_LIMIT'),
        # Review round 2026-09-12 (B-1):  a unit payload beside values is a count refusal.
        ('unit-before-value', good.replace('revert Denied ()', 'revert Denied () (amount)'), 'SURFACE_ERROR'),
        ('unit-after-value', good.replace('error Denied ()', 'error Denied (n : Word)').replace('revert Denied ()', 'revert Denied (amount) ()'), 'SURFACE_ERROR'),
    ]
    schemas = [
        ('word-alias', core().replace('def available : Type 0 := Word 256',
            'def Hidden : Type 0 := Word 256\ndef available : Type 0 := Hidden'), 'M0_PROTOCOL: M1 available'),
        ('variant-alias', core().replace('def Error : Type 0 := sum (InsufficientBalance)',
            'def Other : Type 0 := sum (InsufficientBalance)\ndef Error : Type 0 := Other'), 'M0_PROTOCOL: M1 Error'),
        ('constructor-schema', core().replace('| reject : Error -> Tx', '| reject : (0 e : Error) -> Tx'), 'M0_PROTOCOL: M1 Tx'),
        ('renamed-constructor', core().replace('reject', 'refuse'), 'M0_PROTOCOL: M1 Tx'),
        ('nullary-erased', nullary_core().replace('(prod () : Type 0)', 'prod ()'), 'M1 nullary Error needs an explicit'),
        ('nullary-prop', nullary_core().replace('def InsufficientBalance : Type 0 := (prod () : Type 0)',
            'def InsufficientBalance : Prop := (prod () : Prop)').replace(
            'def Error : Type 0 := sum (InsufficientBalance)',
            'def Denied : Type 0 := (prod () : Type 0)\ndef Error : Type 0 := sum (InsufficientBalance, Denied)').replace(
            'inj 0 of 1', 'inj 0 of 2'), 'M0_PROTOCOL: M1 InsufficientBalance'),
        ('collision', base + '\n'.join(f'error {name} (n : Word)' for name in COLLISION) + '\n' + entry + 'pure amount', 'ABI_SELECTOR_COLLISION: 3387398a'),
        ('reserved-zero', base + 'error blockHashAskewLimitary (n : Word)\n' + entry + 'pure amount', 'reserved error selector'),
    ]
    for name in COLLISION:
        require(P.checked('collision-' + name, ['cast', 'sig', name + '(uint256)']).strip() == '0x3387398a', 'ERROR-COLLISION oracle')
    require(P.checked('reserved-zero', ['cast', 'sig', 'blockHashAskewLimitary(uint256)']).strip() == '0x00000000', 'ERROR-RESERVED oracle')
    with tempfile.TemporaryDirectory(prefix='assay-errors-refusals-') as temporary:
        control = Path(temporary) / 'control.asy'
        control.write_text(nullary_core())
        P.emit(control, Path(temporary) / 'control', 'nullary-control')
        for name, text, marker in cases:
            refusal(name, text, marker, Path(temporary))
        for name, text, marker in schemas:
            refusal(name, text, marker, Path(temporary), checked=True)
    print(f'ERROR-REFUSALS surface={len(cases)} schema={len(schemas)} OK', flush=True)
    return len(cases) + len(schemas)


def witness(name):
    with tempfile.TemporaryDirectory(prefix='assay-errors-witness-') as temporary:
        folder = Path(temporary)
        runtime, _init = P.emit(SOURCE, folder / 'out', 'witness-emit')
        if name == 'abi':
            abi = json.loads((folder / 'out/abi.json').read_text())
            require([item['name'] for item in abi if item['type'] == 'error'] == [row[0] for row in ERRORS], 'ERROR-WITNESS abi')
        elif name in ('bytes', 'rollback'):
            item = next(item for item in rows() if item['name'] == ('snapshot-1' if name == 'bytes' else 'balance-1-1'))
            M.model('witness', SOURCE, item)
            P.execute('witness', runtime, item)
        else:
            require(False, 'ERROR-WITNESS unknown ' + name)


def mutants():
    cases = [
        ('SELECTOR', 'emit/emit.ml', 'A.Push selector; number 224;', 'A.Push selector; number 216;', 'bytes'),
        ('MEMORY', 'emit/emit.ml', 'let base = 32 * 1024 in', 'let base = 0 in', 'bytes'),
        ('LENGTH', 'emit/emit.ml', 'number (4 + 32 * List.length values); number base', 'number (32 * List.length values); number base', 'bytes'),
        ('ROLLBACK', 'emit/model.ml', 'output = "0x" ^ selector ^ words; storage = initial', 'output = "0x" ^ selector ^ words; storage', 'rollback'),
        ('ABI', 'abi/abi.ml', 'List.map error errors', 'List.map error (List.filter (fun _row -> false) errors)', 'abi'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-errors-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        for name, relative, before, after, example in cases:
            path = copy / relative
            original = path.read_text()
            require(original.count(before) == 1, 'ERROR-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'ERROR-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/errors-test.py', 'witness', example], cwd=copy)
                marker = {'bytes': 'COUNTER-EXPECTED', 'rollback': 'MODEL-EXPECTED', 'abi': 'ERROR-WITNESS abi'}[example]
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout), 'ERROR-MUTANT ' + label)
            print('ERROR-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        witness(sys.argv[2])
    elif sys.argv[1:] in (['live'], ['refusals'], ['mutants']):
        {'live': live, 'refusals': refusals, 'mutants': mutants}[sys.argv[1]]()
    elif not sys.argv[1:]:
        count, invalid, killed = live(), refusals(), mutants()
        print(f'CUSTOM-ERRORS cases={count} creates=2 refusals={invalid} mutants={killed} OK')
    else:
        print('usage: dev/errors-test.py [live|refusals|mutants|witness NAME]', file=sys.stderr)
        sys.exit(64)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('CUSTOM-ERRORS FAIL: ' + str(error))
        sys.exit(1)

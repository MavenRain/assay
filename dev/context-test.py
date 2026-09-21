#!/usr/bin/env python3
"""Check core EVM context, constructor order and exact optional schemas."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/context'
BINARY = ROOT / '_build/default/bin/assay.exe'
spec = importlib.util.spec_from_file_location('context_diff', ROOT / 'evm/diff.py')
D = importlib.util.module_from_spec(spec)
spec.loader.exec_module(D)
require = D.require
SENDER = int(D.SENDER, 16)


def save(name, value):
    (WORK / (name + '.json')).write_text(json.dumps(value, indent=2) + '\n')


def capture(name, argv, *, cwd=ROOT, timeout=30):
    result = subprocess.run(list(map(str, argv)), cwd=cwd, text=True,
                            capture_output=True, timeout=timeout)
    save(name, dict(argv=list(map(str, argv)), exit=result.returncode,
                    stdout=result.stdout, stderr=result.stderr))
    return result


def checked(name, argv):
    result = capture(name, argv)
    require(result.returncode == 0, 'CONTEXT-TOOL ' + name + ': ' + result.stderr)
    return result.stdout


def fixture(errors=False, proofs=False, deployer=True):
    guard = (ROOT / 'examples/GuardCore.asy').read_text()
    base = guard[guard.index('mu Word'):guard.index('def wordNat')]
    if deployer:
        base = base.replace('axiom EvmOpcodes',
                            '  | deployer : Word 256 -> Eff -> Eff\naxiom EvmOpcodes')
    proof_types = guard[guard.index('def wordNat'):guard.index('def ResultWord')] if proofs else ''
    error_types = 'def Denied : Type 0 := (prod () : Type 0)\ndef Error : Type 0 := sum (Denied)\n' if errors else ''
    tx = guard[guard.index('def ResultWord'):guard.index('  | guardLe')]
    if errors:
        tx += '  | reject : Error -> Tx\n'
    if proofs:
        tx += guard[guard.index('  | guardLe'):guard.index('def cell')]
    tx += '  | caller : (Word 256 -> Tx) -> Tx\n'
    failure = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
    test = (f'guardLe sender args.0 (fun (0 p : Le sender args.0) => done sender) ({failure})'
            if proofs else f'le sender args.0 (done sender) ({failure})')
    constructor = 'put storage.1 (word 256 9) (ret (word 256 0))'
    if deployer:
        constructor = f'deployer storage.0 ({constructor})'
    return base + proof_types + error_types + tx + f'''
def owner : Type 0 := Word 256
def last : Type 0 := Word 256
def Storage : Type 0 := prod (owner, last)
def storage : Storage := tuple (word 256 0, word 256 1)
def who : Type 0 := (prod () : Type 0)
def remember : Type 0 := (prod () : Type 0)
def bound : Type 0 := Word 256
def bounded : Type 0 := prod (bound)
def Entry : Type 0 := sum (who, remember, bounded)
def constructor : Eff := put storage.0 (word 256 7) ({constructor})
def main : Entry -> Tx := fun (entry : Entry) => case entry with
  | 0 (args : who) => load storage.0 (fun (old : Word 256) =>
      caller (fun (sender : Word 256) => load storage.1 (fun (later : Word 256) =>
        caller (fun (again : Word 256) => done sender))))
  | 1 (args : remember) => caller (fun (sender : Word 256) =>
      store storage.1 sender (done sender))
  | 2 (args : bounded) => caller (fun (sender : Word 256) =>
      store storage.1 sender ({test}))
'''


def emit(name, source):
    path = WORK / (name + '.asy')
    path.write_text(source)
    output = WORK / name
    checked('emit-' + name, [BINARY, 'emit', path, '-o', output])
    return path, output, (output / 'runtime.hex').read_text().strip()


def selectors():
    return {name: checked('selector-' + name, ['cast', 'sig', signature]).strip()[2:]
            for name, signature in [('who', 'who()'), ('remember', 'remember()'),
                                    ('bounded', 'bounded(uint256)'), ('denied', 'Denied()')]}


def prestate(slots=None):
    state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
    words = {f'0x{int(key, 16):064x}': f'0x{int(value, 16):064x}'
             for key, value in (slots or {}).items()}
    state['alloc'] = {D.SENDER: dict(balance=hex(10**24)),
                      D.RECEIVER: dict(balance='0x0', storage=words)}
    return state


def evm_run(name, code, data, caller, *, slots=None, value=0, create=False, state=None):
    genesis = WORK / (name + '-prestate.json')
    state = prestate(slots) if state is None else state
    state['alloc'].setdefault(f'{caller:040x}', dict(balance=hex(10**24)))
    genesis.write_text(json.dumps(state))
    argv = ['evm', '--verbosity', '0', 'run', '--prestate', genesis, '--gas', str(D.GAS),
            '--sender', f'0x{caller:040x}', '--receiver', '0x' + D.RECEIVER,
            '--code', code, '--input', data, '--value', str(value), '--json', '--dump']
    text = checked('evm-' + name, argv + (['--create'] if create else []))
    result = D.run_outcome(text)
    return dict(status=result['status'], output='0x' + result['output'],
                storage=result['storage'].get(D.RECEIVER, {})), result


def live(only=False):
    sig = selectors()
    cases, signed, creates = [], 0, []
    layouts = [(False, False, True)] if only else [
        (e, p, d) for e in (False, True) for p in (False, True) for d in (False, True)]
    for errors, proofs, deployer in layouts:
        name = f'context-{int(errors)}-{int(proofs)}-{int(deployer)}'
        source = fixture(errors, proofs, deployer)
        if errors and proofs and deployer:
            example = (ROOT / 'examples/ContextCore.asy').read_text()
            require(example == source, 'CONTEXT-EXAMPLE drift')
            source = example
        path, output, runtime = emit(name, source)
        abi = json.loads((output / 'abi.json').read_text())
        methods = {row['name']: row['stateMutability'] for row in abi if row['type'] == 'function'}
        require(methods == dict(who='view', remember='nonpayable', bounded='nonpayable'), 'CONTEXT-ABI')
        callers = [SENDER] if only else [0, 1, 2**160 - 1, SENDER]
        for caller in callers:
            fail_output = '0x' + sig['denied'] if errors else '0x'
            word = f'0x{caller:064x}'
            before = {'0': '0x7', '1': '0x9'}
            written = {'0': '0x7', **({'1': hex(caller)} if caller else {})}
            rows = [('who', sig['who'], 0, 'success', word, before),
                    ('remember', sig['remember'], 0, 'success', word, written),
                    ('equal', sig['bounded'] + f'{caller:064x}', 0, 'success', word, written),
                    ('zero-bound', sig['bounded'] + '00' * 32, 0,
                     'revert' if caller else 'success', fail_output if caller else word,
                     before if caller else written),
                    ('value', sig['who'], 1, 'revert', '0x', before),
                    ('short', sig['bounded'] + '00' * 31, 0, 'revert', '0x', before),
                    ('unknown', 'ffffffff', 0, 'revert', '0x', before)]
            for label, data, value, status, result, after in rows:
                key = name + '-' + str(caller) + '-' + label
                want = dict(status=status, output=result, storage=after)
                argv = [BINARY, 'run', path, '--calldata', data, '--caller', hex(caller),
                        '--value', value, '--storage', '0=7', '--storage', '1=9']
                model = json.loads(checked('model-' + key, argv))
                actual, _ = evm_run(key, runtime, data, caller, slots={'0x0': '0x7', '0x1': '0x9'}, value=value)
                require(model == want, 'CONTEXT-MODEL ' + label)
                require(actual == want, 'CONTEXT-EVM ' + label)
                if caller == SENDER:
                    report, evidence = D.execute(runtime, data, prestate({'0x0': '0x7', '0x1': '0x9'}),
                                                 shutil.which('evm'), value=value)
                    save('signed-' + key, dict(report=report, evidence=evidence))
                    actual = dict(status=report['status'], output=report['output'],
                                  storage=report['storage'].get(D.RECEIVER, {}))
                    require(actual == want, 'CONTEXT-SIGNED ' + label)
                    signed += 1
                cases.append(dict(name=key, expected=want))
        if not only:
            init = (output / 'init.hex').read_text().strip()
            for caller in [0, 1, SENDER, 2**160 - 1]:
                for value in [0, 1]:
                    key = name + '-create-' + str(caller) + '-' + str(value)
                    _, raw = evm_run(key, init, '', caller, create=True, value=value)
                    want = {**({'0': hex(caller)} if caller else {}), '1': '0x9'} if deployer else {'0': '0x7', '1': '0x9'}
                    require(raw['status'] == ('revert' if value else 'success'), 'CONTEXT-CREATE status')
                    require(raw['output'] == ('' if value else runtime), 'CONTEXT-CREATE runtime')
                    require(list(raw['storage'].values()) == ([] if value else [want]), 'CONTEXT-CREATE storage')
                    creates.append(dict(name=key, result=raw))
    save('LIVE', dict(cases=cases, signed=signed, creates=creates))
    print(f'CONTEXT-LIVE cases={len(cases)} signed={signed} creates={len(creates)} OK', flush=True)
    return len(cases), signed, len(creates)


def refusals(only=None):
    base = fixture()
    marker = 'def main : Entry -> Tx'
    simple = base[:base.index(marker)] + 'def main : Entry -> Tx := fun (entry : Entry) => abort\n'
    rows = {
        'caller-shape': simple.replace('| caller : (Word 256 -> Tx) -> Tx', '| caller : Word 256 -> Tx'),
        'caller-order': simple.replace('  | caller : (Word 256 -> Tx) -> Tx\n', '').replace(
            '  | abort : Tx', '  | caller : (Word 256 -> Tx) -> Tx\n  | abort : Tx'),
        'deployer-shape': simple.replace('| deployer : Word 256 -> Eff -> Eff', '| deployer : Word 256 -> Eff').replace(
            'deployer storage.0 (put storage.1 (word 256 9) (ret (word 256 0)))', 'deployer storage.0'),
        'deployer-slot': simple.replace('deployer storage.0', 'deployer (word 256 2)'),
        'constructor-return': simple.replace('ret (word 256 0)', 'ret (word 256 1)'),
        'constructor-read': simple.replace('ret (word 256 0)', 'read storage.0'),
        'm0-context': simple[:simple.index('def ResultWord')] +
            'def Storage : Type 0 := prod (Word 256)\n'
            'def storage : Storage := tuple (word 256 0)\n'
            'def main : Eff := ret (word 256 0)\n',
    }
    selected = {key: value for key, value in rows.items() if only is None or only == key}
    require(bool(selected), 'CONTEXT-WITNESS unknown refusal')
    for name, text in selected.items():
        path = WORK / (name + '.asy')
        path.write_text(text)
        checked('check-' + name, [BINARY, 'check', path])
        for command in ['emit', 'run']:
            output = WORK / ('refused-' + name)
            args = ['-o', output] if command == 'emit' else []
            result = capture(command + '-' + name, [BINARY, command, path, *args])
            require(result.returncode == 2 and not output.exists(), 'CONTEXT-REFUSAL ' + name)
    print(f'CONTEXT-REFUSALS cases={len(selected)} OK', flush=True)
    return len(selected)


def inputs():
    path, _, _ = emit('inputs', fixture())
    for i, args in enumerate([['--caller', '-1'], ['--caller', str(2**160)], ['--caller', 'xyz'],
                              ['--caller', '0x'], ['--caller'], ['--caller', '1', '--caller', '2']]):
        result = capture('input-' + str(i), [BINARY, 'run', path, *args])
        require(result.returncode == 64 and result.stdout == '', 'CONTEXT-INPUT ' + str(i))
    data = selectors()['who']
    implicit = checked('input-default', [BINARY, 'run', path, '--calldata', data])
    explicit = checked('input-zero', [BINARY, 'run', path, '--calldata', data, '--caller', '0'])
    require(implicit == explicit and json.loads(implicit)['output'] == '0x' + '00' * 32, 'CONTEXT-DEFAULT')
    print('CONTEXT-INPUT cases=7 OK', flush=True)
    return 7


def nested():
    path, output, runtime = emit('nested', fixture())
    sig = selectors()['who']
    target = '0000000000000000000000000000000000001234'
    # Forward calldata by CALL so the contract sees the proxy, not tx.origin.
    proxy = '365f5f3760205f365f5f73' + target + '5af15060205ff3'
    state = prestate()
    state['alloc'][target] = dict(balance='0x0', code='0x' + runtime)
    actual, _ = evm_run('proxy', proxy, sig, SENDER, state=state)
    expected = f'0x{int(D.RECEIVER, 16):064x}'
    require(actual['status'] == 'success' and actual['output'] == expected, 'CONTEXT-PROXY')
    modeled = json.loads(checked('model-proxy', [BINARY, 'run', path, '--calldata', sig,
                                                '--caller', '0x' + D.RECEIVER]))
    require(modeled['output'] == expected, 'CONTEXT-PROXY model')
    # Deploy through CREATE. Init code sees the factory as its creation caller.
    init = (output / 'init.hex').read_text().strip()
    prefix = f'61{len(init)//2:04x}61000f5f3961{len(init)//2:04x}5f5ff000'
    require(len(bytes.fromhex(prefix)) == 15, 'CONTEXT-FACTORY prefix')
    _, raw = evm_run('factory', prefix + init, '', SENDER)
    require(raw['status'] == 'success' and list(raw['storage'].values()) ==
            [{'0': hex(int(D.RECEIVER, 16)), '1': '0x9'}], 'CONTEXT-FACTORY')
    save('NESTED', dict(proxy=actual, factory=raw))
    print('CONTEXT-NESTED cases=2 OK', flush=True)
    return 2


def independent():
    base = fixture().replace('  | caller : (Word 256 -> Tx) -> Tx\n', '')
    base = base[:base.index('def constructor')]
    constructors = [
        ('dynamic', 'deployer storage.0 (put storage.1 (word 256 9) (ret (word 256 0)))'),
        ('overwritten', 'deployer storage.0 (put storage.0 (word 256 17) (ret (word 256 0)))'),
        ('repeated', 'deployer storage.0 (deployer storage.1 (ret (word 256 0)))'),
    ]
    rows = []
    for name, body in constructors:
        path, output, runtime = emit('independent-' + name, base + 'def constructor : Eff := ' + body + '\n'
            'def main : Entry -> Tx := fun (entry : Entry) => load storage.0 (fun (owner : Word 256) => done owner)\n')
        for caller in [0, SENDER]:
            _, raw = evm_run(name + str(caller), (output / 'init.hex').read_text().strip(), '', caller, create=True)
            values = {'0': caller, '1': 9} if name == 'dynamic' else (
                {'0': 17} if name == 'overwritten' else {'0': caller, '1': caller})
            want = {key: hex(value) for key, value in values.items() if value}
            require(raw['status'] == 'success' and raw['output'] == runtime and
                    list(raw['storage'].values()) == ([want] if want else []), 'CONTEXT-INDEPENDENT ' + name)
            args = [BINARY, 'run', path, '--calldata', selectors()['who'], '--caller', hex(caller)]
            for key, value in values.items():
                args += ['--storage', key + '=' + str(value)]
            model = json.loads(checked('independent-model-' + name + str(caller), args))
            require(model == dict(status='success', output=f'0x{values["0"]:064x}', storage=want),
                    'CONTEXT-INDEPENDENT model ' + name)
            rows.append(dict(name=name, caller=caller, result=raw))
    save('INDEPENDENT', rows)
    print(f'CONTEXT-INDEPENDENT cases={len(rows)} OK', flush=True)
    return len(rows)


def mutants():
    cases = [
        ('CALLER', 'emit/emit.ml', 'String.uppercase_ascii (R.context_name source)',
         '(if source = R.Caller then "ORIGIN" else String.uppercase_ascii (R.context_name source))',
         'nested', 'CONTEXT-PROXY'),
        ('DEPLOYER', 'emit/emit.ml', 'Ok ([A.Op "CALLER"; push slot; A.Op "SSTORE"] @ next)',
         'Ok ([A.Op "ORIGIN"; push slot; A.Op "SSTORE"] @ next)', 'nested', 'CONTEXT-FACTORY'),
        ('SNAPSHOT', 'emit/emit.ml', 'continuation fuel (fresh + 1) fn (R.Runtime_word fresh) in\n'
         '       Ok (Context (source, fresh, next), fuel, next_fresh)',
         'continuation fuel fresh fn (R.Runtime_word fresh) in\n'
         '       Ok (Context (source, fresh, next), fuel, next_fresh)',
         'live', 'CONTEXT-MODEL who'),
        ('MODEL', 'emit/model.ml', 'Recognize.Caller -> Ok input.caller', 'Recognize.Caller -> Ok Z.zero',
         'live', 'CONTEXT-MODEL who'),
        ('ADDRESS', 'emit/model.ml', 'Z.numbits caller > 160', 'Z.numbits caller > 256',
         'inputs', 'CONTEXT-INPUT 1'),
        ('SCHEMA', 'emit/recognize.ml',
         '~prefix:"M1 " ["Tx"] globals source',
         '~prefix:"M1 " [] globals source', 'refusals', 'CONTEXT-REFUSAL caller-shape'),
    ]
    results = []
    with tempfile.TemporaryDirectory(prefix='assay-context-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        for name, relative, before, after, case, marker in cases:
            path = copy / relative
            original = path.read_text()
            require(original.count(before) == 1, 'CONTEXT-MUTANT anchor ' + name)
            for mutated in [True, False]:
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'CONTEXT-MUTANT build ' + label)
                result = capture(label, ['python3', '-P', 'dev/context-test.py', 'witness', case], cwd=copy, timeout=90)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'CONTEXT-MUTANT witness ' + label)
                results.append(dict(name=label, marker=marker, exit=result.returncode,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('CONTEXT-MUTANT ' + name + ' killed control=OK', flush=True)
    save('MUTANTS', results)
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=live, refusals=refusals, inputs=inputs, nested=nested,
                    independent=independent, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True, exist_ok=True)
    if args[:1] == ['witness']:
        require(args[1] in commands, 'CONTEXT-WITNESS unknown name')
        live(only=True) if args[1] == 'live' else commands[args[1]]()
    elif args:
        commands[args[0]]()
    else:
        cases, signed, creates = live()
        invalid, options, calls, standalone, killed = refusals(), inputs(), nested(), independent(), mutants()
        print(f'EVM-CONTEXT cases={cases} signed={signed} creates={creates} refusals={invalid} '
              f'inputs={options} nested={calls} independent={standalone} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('EVM-CONTEXT FAIL ' + str(error), flush=True)
        sys.exit(1)

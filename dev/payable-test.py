#!/usr/bin/env python3
"""Check entry payability against independent outcomes and signed Cancun calls."""
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/payable'
SPEC = importlib.util.spec_from_file_location('payable_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C)
C.WORK = WORK
require = C.require
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')
SLOTS = {'0': '0x7', '7': '0x17'}
MAX = 2**256 - 1


def selector(signature):
    return C.checked('selector-' + signature.split('(')[0], ['cast', 'sig', signature]).strip()[2:]


def word(value):
    return f'{value:064x}'


def expected(result=None, *, output=None, stored=None):
    slots = dict(SLOTS)
    if stored is not None:
        if stored:
            slots['0'] = hex(stored)
        else:
            slots.pop('0')
    return dict(status='revert' if result is None else 'success',
                output=('0x' if result is None else '0x' + word(result)) if output is None else output,
                storage=slots)


def outcome(name, path, runtime, data, value, want, *, signed=False, caller=C.SENDER):
    argv = [C.BINARY, 'run', path, '--calldata', data, '--value', value, '--caller', hex(caller)]
    for slot, stored in SLOTS.items():
        argv += ['--storage', f'{int(slot, 16)}={int(stored, 16)}']
    model = json.loads(C.checked('model-' + name, argv))
    require(model == want, 'PAYABLE-MODEL ' + name)
    state = C.prestate(SLOTS)
    state['alloc'][f'{caller:040x}'] = dict(balance=hex(MAX))
    evm, _ = C.evm_run(name, runtime, data, caller, slots=SLOTS, value=value, state=state)
    require(evm == want, 'PAYABLE-EVM ' + name)
    if signed:
        report, evidence = C.D.execute(runtime, data, state, shutil.which('evm'), value=value, caller=hex(caller))
        C.save('signed-' + name, dict(report=report, evidence=evidence))
        actual = dict(status=report['status'], output=report['output'],
                      storage=report['storage'].get(C.D.RECEIVER, {}))
        require(actual == want, 'PAYABLE-SIGNED ' + name)
        alloc = json.loads(evidence['transition'])['alloc']
        transferred = value if want['status'] == 'success' else 0
        require(int(alloc['0x' + C.D.RECEIVER]['balance'], 16) == transferred and
                int(alloc[f'0x{caller:040x}']['balance'], 16) == MAX - transferred,
                'PAYABLE-TRANSFER ' + name)
    C.save('expected-' + name, want)


def core(errors, proofs, caller, *, annotation=True):
    prefix = C.fixture(errors=errors, proofs=proofs, deployer=False).split('\ndef owner', 1)[0]
    if not caller:
        prefix = prefix.replace('  | caller : (Word 256 -> Tx) -> Tx\n', '')
    prefix += '  | payable : Tx -> Tx\n'
    failure = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
    result = 'caller (fun (sender : Word 256) => done sender)' if caller else 'done args.0'
    checked = (f'guardLe args.0 (word 256 10) (fun (0 p : Le args.0 (word 256 10)) => {result}) ({failure})'
               if proofs else f'le args.0 (word 256 10) ({result}) ({failure})')
    accept = f'store storage.0 args.0 ({checked})'
    accept = f'payable ({accept})' if annotation else accept
    peek = 'payable (done (word 256 17))' if annotation else 'done (word 256 17)'
    return prefix + f'''
def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def amount : Type 0 := Word 256
def deposit : Type 0 := prod (amount)
def set : Type 0 := prod (amount)
def ping : Type 0 := (prod () : Type 0)
def Entry : Type 0 := sum (deposit, set, ping)
def constructor : Eff := ret (word 256 0)
def fallback : Tx := {failure}
def main : Entry -> Tx := fun (entry : Entry) => case entry with
  | 0 (args : deposit) => {accept}
  | 1 (args : set) => store storage.0 args.0 (done args.0)
  | 2 (args : ping) => {peek}
'''


def abi(output, want):
    rows = json.loads((output / 'abi.json').read_text())
    actual = {row['name']: row['stateMutability'] for row in rows if row['type'] == 'function'}
    require(actual == want, 'PAYABLE-ABI')
    require(all(row['stateMutability'] == 'nonpayable' for row in rows
                if row['type'] in ('constructor', 'fallback')), 'PAYABLE-ABI creation/fallback')


def live():
    deposit, set_, ping, denied = map(selector, ('deposit(uint256)', 'set(uint256)', 'ping()', 'Denied()'))
    cases = signed = pairs = 0
    for errors, proofs, caller in itertools.product((False, True), repeat=3):
        name = f'core-{int(errors)}{int(proofs)}{int(caller)}'
        path, output, runtime = C.emit(name, core(errors, proofs, caller))
        abi(output, dict(deposit='payable', set='nonpayable', ping='payable'))
        for value in (0, 1, MAX):
            failure = '0x' + denied if errors else '0x'
            success = C.SENDER if caller else 9
            rows = [('deposit', deposit + word(9), expected(success, stored=9)),
                    ('zero', deposit + word(0), expected(C.SENDER if caller else 0, stored=0)),
                    ('rollback', deposit + word(11), expected(output=failure)),
                    ('plain', set_ + word(9), expected() if value else expected(9, stored=9)),
                    ('ping', ping, expected(17)),
                    ('truncated', deposit + '00', expected()),
                    ('trailing', deposit + word(9) + 'ffff', expected(success, stored=9)),
                    ('unknown', 'ffffffff', expected(output='0x' if value else failure)),
                    ('empty', '', expected(output='0x' if value else failure))]
            for label, data, want in rows:
                sign = value == 1 and label in ('deposit', 'rollback', 'plain')
                outcome(f'{name}-{value}-{label}', path, runtime, data, value, want, signed=sign)
                cases += 1
                signed += sign
        unused = core(errors, proofs, caller, annotation=False)
        pair_path, extended, _ = C.emit(name + '-unused', unused)
        pair_path.write_text(unused.replace('  | payable : Tx -> Tx\n', ''))
        legacy = WORK / (name + '-legacy')
        C.checked('emit-' + name + '-legacy', [C.BINARY, 'emit', pair_path, '-o', legacy])
        require(all((extended / file).read_bytes() == (legacy / file).read_bytes() for file in FILES),
                'PAYABLE-LEGACY ' + name)
        pairs += 1
    return cases, signed, pairs


def probe():
    path, output, runtime = C.emit('surface', (ROOT / 'examples/Payable.asy').read_text())
    abi(output, dict(deposit='payable', ping='payable', set='nonpayable', get='view'))
    deposit, set_, get, unknown, large = map(selector, ('deposit(uint256)', 'set(uint256)', 'get()',
                                                   'UnknownCall()', 'TooLarge(uint256)'))
    rows = [('accept', deposit + word(9), 1, expected(C.SENDER, stored=9)),
            ('deny-write', set_ + word(9), 1, expected()),
            ('deny-view', get, 1, expected()),
            ('fallback', 'ffffffff', 1, expected()),
            ('fallback-zero', '', 0, expected(output='0x' + unknown)),
            ('rollback', deposit + word(11), 1, expected(output='0x' + large + word(11)))]
    for name, data, value, want in rows:
        outcome('surface-' + name, path, runtime, data, value, want)
    return len(rows)


def public():
    path = ROOT / 'examples/Payable.asy'
    deposit = selector('deposit(uint256)')
    cases = 0
    for caller in (C.SENDER, int('2b5ad5c4795c026514f8317c7a215e218dccd6cf', 16)):
        state = C.prestate()
        state['alloc'][f'{caller:040x}'] = dict(balance=hex(MAX))
        prestate = WORK / f'public-{caller}-prestate.json'
        prestate.write_text(json.dumps(state))
        for command in ('diff', 'trace'):
            name = f'public-{command}-{caller}'
            text = C.checked(name, [C.BINARY, command, path, '--calldata', deposit + word(9),
                                    '--caller', hex(caller), '--value', '1', '--prestate', prestate])
            if command == 'diff':
                lines = text.splitlines()
                require(len(lines) == 2 and lines[1] == 'DIFF OK', 'PAYABLE-PUBLIC report ' + name)
                report = json.loads(lines[0])
                require(report['status'] == 'success' and
                        report['output'] == '0x' + word(caller) and
                        report['storage'][C.D.RECEIVER] == {'0': '0x9'}, 'PAYABLE-PUBLIC ' + name)
            else:
                report = C.D.run_outcome(text)
                require(report['status'] == 'success' and report['output'] == word(caller) and
                        report['storage'][C.D.RECEIVER] == {'0': '0x9'}, 'PAYABLE-PUBLIC ' + name)
            cases += 1
    _, output, _ = C.emit('creation', path.read_text())
    init = (output / 'init.hex').read_text().strip()
    for value in (0, 1):
        result, raw = C.evm_run('creation-' + str(value), init, '', C.SENDER, value=value, create=True)
        require(result['status'] == ('success' if value == 0 else 'revert'), 'PAYABLE-CREATION')
        created = 'f2e246bb76df876cef8b38ae84130f4f55de395b'
        require(raw['storage'] == ({created: {'0': '0x7'}} if value == 0 else {}), 'PAYABLE-CREATION storage')
        if value == 0:
            require(result['output'] == '0x' + (output / 'runtime.hex').read_text().strip(), 'PAYABLE-CREATION runtime')
        cases += 1
    return cases


def refusals():
    source = (ROOT / 'examples/Payable.asy').read_text()
    base = core(False, False, False)
    rows = [('constructor', source.replace('constructor :=', 'payable constructor :='), 'SURFACE_'),
            ('fallback', source.replace('fallback :', 'payable fallback :'), 'SURFACE_'),
            ('duplicate', source.replace('payable entry deposit', 'payable payable entry deposit'), 'SURFACE_'),
            ('body', source.replace('pure (word 17)', 'payable pure (word 17)'), 'SURFACE_'),
            ('reserved', source.replace('entry set', 'entry payable'), 'SURFACE_NAME'),
            ('shape', base.replace('payable : Tx -> Tx', 'payable : Word 256 -> Tx -> Tx')
                          .replace('payable (', 'payable (word 256 0) ('), 'PROTOCOL'),
            ('nested', base.replace('payable (done (word 256 17))', 'payable (payable (done (word 256 17)))'), 'complete entry'),
            ('after-store', base.replace('store storage.0 args.0 (done args.0)',
                                        'store storage.0 args.0 (payable (done args.0))'), 'complete entry'),
            ('fallback-core', base.replace('def fallback : Tx := abort', 'def fallback : Tx := payable abort'), 'complete entry')]
    count = 0
    for name, text, marker in rows:
        path = WORK / ('refusal-' + name + '.asy')
        path.write_text(text)
        for command, args in (('emit', ['-o', WORK / ('refusal-' + name)]), ('run', [])):
            result = C.capture('refusal-' + command + '-' + name, [C.BINARY, command, path, *args])
            require(result.returncode != 0 and marker.lower() in (result.stdout + result.stderr).lower(),
                    'PAYABLE-REFUSAL ' + command + '-' + name + ': ' + result.stderr)
            count += 1
    return count


def mutants():
    rows = [('ABI', 'abi/abi.ml', '| Payable -> "payable"', '| Payable -> "nonpayable"', 'PAYABLE-ABI'),
            ('GUARD', 'emit/emit.ml', 'if mixed && not (Assay_abi.Abi.accepts_value entry.abi_entry)',
             'if mixed && false && not (Assay_abi.Abi.accepts_value entry.abi_entry)', 'PAYABLE-EVM surface-deny-write'),
            ('FALLBACK', 'emit/emit.ml', 'if mixed && default <> "reject"',
             'if mixed && false && default <> "reject"', 'PAYABLE-EVM surface-fallback'),
            ('MODEL', 'emit/model.ml', 'if has_value && not (Assay_abi.Abi.accepts_value entry.E.abi_entry)',
             'if has_value && false && not (Assay_abi.Abi.accepts_value entry.E.abi_entry)', 'PAYABLE-MODEL surface-deny-write')]
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-payable-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        for name, file, before, after, marker in rows:
            path = copy / file
            original = path.read_text()
            require(original.count(before) == 1, 'PAYABLE-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'PAYABLE-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/payable-test.py', 'probe'], cwd=copy, timeout=60)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'PAYABLE-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('PAYABLE-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(rows)


def main():
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True, exist_ok=True)
    commands = dict(live=live, probe=probe, public=public, refusals=refusals, mutants=mutants)
    if sys.argv[1:]:
        require(len(sys.argv) == 2 and sys.argv[1] in commands, 'PAYABLE arguments')
        print(f'PAYABLE {sys.argv[1]} {commands[sys.argv[1]]()} OK', flush=True)
    else:
        cases, signed, pairs = live()
        probes, public_cases, invalid, killed = probe(), public(), refusals(), mutants()
        print(f'PAYABLE cases={cases} signed={signed} pairs={pairs} probes={probes} '
              f'public={public_cases} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('PAYABLE FAIL ' + str(error), flush=True)
        sys.exit(1)

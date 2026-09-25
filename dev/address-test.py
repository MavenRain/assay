#!/usr/bin/env python3
"""Check contract identity independently of caller and other EVM context."""
import hashlib
import importlib.util
import itertools
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
WORK = ROOT / '.gatework/address'
SPEC = importlib.util.spec_from_file_location('address_calldata', ROOT / 'dev/calldataload-test.py')
L = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(L)
P, C = L.P, L.C
C.WORK = P.WORK = L.WORK = WORK
require = C.require
DECL = '  | address : (Word 256 -> Tx) -> Tx\n'
NAMES = ('observe', 'snapshot', 'remember', 'bounded', 'sender', 'amount', 'size', 'dataword', 'fail', 'plain')


def core(errors, proofs, caller, callvalue, calldatasize, calldataload, payable, *, used=True):
    prefix = L.core(errors, proofs, caller, callvalue, calldatasize, False).split('\ndef cell', 1)[0]
    if not calldataload:
        prefix = prefix.replace(L.DECL, '')
    prefix += DECL + ('  | payable : Tx -> Tx\n' if payable else '')
    failure = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
    guard = (f'guardLe self args.0 (fun (0 p : Le self args.0) => done self) ({failure})'
             if proofs else f'le self args.0 (done self) ({failure})')
    snapshot = 'store storage.0 args.0 (done self)'
    for name, enabled in [('caller', caller), ('callvalue', callvalue), ('calldatasize', calldatasize),
                          ('calldataload args.0', calldataload), ('address', True), ('load storage.0', True)]:
        if enabled:
            snapshot = f'{name} (fun (later : Word 256) => {snapshot})'
    tails = ['done self', snapshot, 'store storage.0 self (done self)',
             f'store storage.0 self ({guard})',
             'caller (fun (v : Word 256) => done v)' if caller else 'done self',
             'callvalue (fun (v : Word 256) => done v)' if callvalue else 'done self',
             'calldatasize (fun (v : Word 256) => done v)' if calldatasize else 'done self',
             'calldataload args.0 (fun (v : Word 256) => done v)' if calldataload else 'done self',
             f'store storage.0 self ({failure})', 'done self']
    bodies = [f'address (fun (self : Word 256) => {tail})' if used else 'done (word 256 17)' for tail in tails]
    branches = '\n'.join(f'  | {i} (args : {name}) => ' +
                         (f'payable ({body})' if payable and name != 'plain' else body)
                         for i, (name, body) in enumerate(zip(NAMES, bodies)))
    declarations = ''.join(f'def {name} : Type 0 := prod (argument)\n' for name in NAMES)
    return prefix + '''
def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def argument : Type 0 := Word 256
''' + declarations + 'def Entry : Type 0 := sum (' + ', '.join(NAMES) + ''')
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) => case entry with
''' + branches + '\n'


def outcome(name, path, runtime, data, value, want, *, signed=False, address=None):
    address = int(C.D.RECEIVER, 16) if address is None else address
    argv = [C.BINARY, 'run', path, '--calldata', data, '--value', value,
            '--caller', hex(C.SENDER), '--address', hex(address)]
    for slot, stored in P.SLOTS.items():
        argv += ['--storage', f'{int(slot, 16)}={int(stored, 16)}']
    model = json.loads(C.checked('model-' + name, argv))
    require(model == want, 'ADDRESS-MODEL ' + name)
    state = C.prestate(P.SLOTS)
    evm, _ = C.evm_run(name, runtime, data, C.SENDER, slots=P.SLOTS, value=value, state=state)
    require(evm == want, 'ADDRESS-EVM ' + name)
    if signed:
        report, evidence = C.D.execute(runtime, data, state, shutil.which('evm'), value=value)
        C.save('signed-' + name, dict(report=report, evidence=evidence))
        actual = dict(status=report['status'], output=report['output'], storage=report['storage'].get(C.D.RECEIVER, {}))
        require(actual == want, 'ADDRESS-SIGNED ' + name)
    C.save('expected-' + name, want)


def live():
    selectors = {name: P.selector(name + '(uint256)') for name in NAMES}
    denied = '0x' + P.selector('Denied()')
    self = int(C.D.RECEIVER, 16)
    cases = pairs = signed = 0
    for bits in itertools.product((False, True), repeat=7):
        errors, proofs, caller, callvalue, size, load, payable = bits
        label = ''.join(str(int(bit)) for bit in bits)
        path, _, runtime = C.emit('matrix-' + label, core(*bits))
        value = 19 if payable else 0
        arguments = [4, 4, 4, self, 4, 4, 4, 4, 4, 4]
        wants = [P.expected(self), P.expected(self, stored=4), P.expected(self, stored=self),
                 P.expected(self, stored=self), P.expected(C.SENDER if caller else self),
                 P.expected(value if callvalue else self), P.expected(36 if size else self),
                 P.expected(4 if load else self), P.expected(output=denied if errors else '0x'), P.expected(self)]
        rows = [(name, selectors[name] + P.word(arg), 0 if name == 'plain' else value, want)
                for name, arg, want in zip(NAMES, arguments, wants)]
        rows += [('bound-fail', selectors['bounded'] + P.word(self - 1), value,
                  P.expected(output=denied if errors else '0x')),
                 ('plain-value', selectors['plain'] + P.word(4), 1, P.expected()),
                 ('short', '00', value, P.expected()), ('unknown', 'ffffffff', value, P.expected()),
                 ('truncated', selectors['observe'], value, P.expected())]
        for name, data, amount, want in rows:
            check_signed = all(bits)
            outcome(label + '-' + name, path, runtime, data, amount, want, signed=check_signed)
            cases += 1
            signed += check_signed
        unused = core(*bits, used=False)
        _, with_decl, _ = C.emit('unused-' + label, unused)
        declared = {name: (with_decl / name).read_bytes() for name in P.FILES}
        with_decl.rename(WORK / ('declared-' + label))
        _, without_decl, _ = C.emit('unused-' + label, unused.replace(DECL, ''))
        require(all(declared[name] == (without_decl / name).read_bytes() for name in P.FILES),
                'ADDRESS-UNUSED ' + label)
        C.save('unused-pair-' + label, {name: hashlib.sha256(data).hexdigest() for name, data in declared.items()})
        pairs += 1
    return cases, signed, pairs


def probe():
    path, output, runtime = C.emit('surface', (ROOT / 'examples/ContractAddress.asy').read_text())
    abi = json.loads((output / 'abi.json').read_text())
    entries = {row['name']: row['stateMutability'] for row in abi if row['type'] == 'function'}
    require(entries == dict(observe='view', snapshot='payable', remember='nonpayable',
                            checked='nonpayable', increment='view', fail='nonpayable'), 'ADDRESS-ABI')
    selectors = {name: P.selector(signature) for name, signature in
                 [('observe', 'observe()'), ('snapshot', 'snapshot(uint256)'), ('remember', 'remember()'),
                  ('checked', 'checked(uint256)'), ('increment', 'increment()'), ('fail', 'fail()'),
                  ('unexpected', 'Unexpected(uint256)'), ('observed', 'Observed(uint256,uint256)')]}
    old_receiver = C.D.RECEIVER
    count = 0
    try:
        for self in (0, 0x100, int(old_receiver, 16), 2**159, 2**160 - 1):
            C.D.RECEIVER = f'{self:040x}'
            rows = [('observe', selectors['observe'], 0, P.expected(self)),
                    ('snapshot', selectors['snapshot'] + P.word(4), 19, P.expected(self, stored=4)),
                    ('remember', selectors['remember'], 0, P.expected(self, stored=self)),
                    ('checked', selectors['checked'] + P.word(self), 0, P.expected(self, stored=self)),
                    ('checked-fail', selectors['checked'] + P.word(self + 1), 0,
                     P.expected(output='0x' + selectors['unexpected'] + P.word(self))),
                    ('increment', selectors['increment'], 0, P.expected(self + 1)),
                    ('fail', selectors['fail'], 0,
                     P.expected(output='0x' + selectors['observed'] + P.word(self) + P.word(C.SENDER))),
                    ('nonpayable', selectors['observe'], 1, P.expected())]
            for name, data, value, want in rows:
                outcome(f'probe-{self}-{name}', path, runtime, data, value, want, signed=True)
                count += 1
    finally:
        C.D.RECEIVER = old_receiver
    return count


def public():
    path, _, _ = C.emit('public', (ROOT / 'examples/ContractAddress.asy').read_text())
    data = P.selector('observe()')
    state = WORK / 'public-prestate.json'
    state.write_text(json.dumps(C.prestate(P.SLOTS)))
    for command in ('trace', 'diff'):
        text = C.checked('public-' + command,
            [C.BINARY, command, path, '--calldata', data, '--prestate', state])
        if command == 'diff':
            lines = text.splitlines()
            require(len(lines) == 2 and lines[1] == 'DIFF OK', 'ADDRESS-PUBLIC diff report')
            report, want = json.loads(lines[0]), '0x' + P.word(int(C.D.RECEIVER, 16))
        else:
            report, want = C.D.run_outcome(text), P.word(int(C.D.RECEIVER, 16))
        require(report['status'] == 'success' and report['output'] == want and
                report['storage'][C.D.RECEIVER] == P.SLOTS,
                'ADDRESS-PUBLIC ' + command)
    for text, expected in [('0', 0), ('0x0', 0), (str(2**160 - 1), 2**160 - 1), ('0x' + 'f' * 40, 2**160 - 1)]:
        report = json.loads(C.checked('public-model-' + text,
            [C.BINARY, 'run', path, '--calldata', data, '--address', text]))
        require(report == dict(status='success', output='0x' + P.word(expected), storage={}), 'ADDRESS-PUBLIC model')
    default = json.loads(C.checked('public-default', [C.BINARY, 'run', path, '--calldata', data]))
    require(default == dict(status='success', output='0x' + P.word(0), storage={}), 'ADDRESS-PUBLIC default')
    return 7


def refusals(only_schema=False):
    valid = core(*([True] * 7), used=False)
    rows = [('wrong-width', valid.replace(DECL, '  | address : (Word 160 -> Tx) -> Tx\n')),
            ('wrong-order', valid.replace(DECL, '').replace(L.DECL, DECL + L.DECL)),
            ('wrong-continuation', valid.replace(DECL, '  | address : Tx -> Tx\n')),
            ('extra-operand', valid.replace(DECL, '  | address : Word 256 -> (Word 256 -> Tx) -> Tx\n')),
            ('fallback', valid + 'def fallback : Tx := address (fun (v : Word 256) => abort)\n')]
    if not only_schema:
        surface = (ROOT / 'examples/ContractAddress.asy').read_text()
        rows += [('operand', surface.replace('self <- address ;', 'self <- address (word 0) ;', 1)),
                 ('pure', surface.replace('self <- address ; pure self', 'pure address', 1)),
                 ('binding', surface.replace('self <- address ; pure self', 'let self := address ; pure self', 1)),
                 ('reserved-entry', surface.replace('entry observe', 'entry address')),
                 ('reserved-local', surface.replace('self <- address ; pure self', 'address <- caller ; pure address', 1)),
                 ('constructor', surface.replace('do pure ()', 'do self <- address ; pure ()')),
                 ('surface-fallback', surface + '  fallback : Eff Sig Never := do self <- address ; revert\n')]
    for name, source in rows:
        path = WORK / ('refusal-' + name + '.asy')
        path.write_text(source)
        for command, rest in [('emit', ['-o', WORK / ('refusal-output-' + name)]), ('run', [])]:
            result = C.capture('refusal-' + command + '-' + name, [C.BINARY, command, path] + rest)
            marker = 'SURFACE_' if source.startswith('contract ') else 'closed revert' if name == 'fallback' else 'M0_PROTOCOL'
            require(result.returncode in (1, 2) and marker.lower() in result.stderr.lower() and
                    not (WORK / ('refusal-output-' + name)).exists(), 'ADDRESS-REFUSAL ' + name)
    if only_schema:
        return len(rows)
    invalid = ['', '-1', '0x', '0xg', '1_0', ' 1', '+1', str(2**160), '0x1' + '0' * 40, str(2**256)]
    for i, value in enumerate(invalid):
        result = C.capture('input-' + str(i), [C.BINARY, 'run', '/missing.asy', '--address', value])
        require(result.returncode == 64 and 'RUN_INPUT' in result.stderr, 'ADDRESS-INPUT ' + str(i))
    for i, flags in enumerate([['--address'], ['--address', '0', '--address', '1']]):
        result = C.capture('option-' + str(i), [C.BINARY, 'run', '/missing.asy'] + flags)
        require(result.returncode == 64 and result.stdout == '' and result.stderr.startswith('usage: assay'), 'ADDRESS-OPTION ' + str(i))
    return len(rows) + len(invalid) + 2


def mutants():
    rows = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-address-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, file, before, after, mode, marker in rows:
            path = copy / file
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'ADDRESS-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', '-j', '2', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'ADDRESS-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/address-test.py', mode], cwd=copy, timeout=120)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'ADDRESS-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('ADDRESS-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(rows)


def main():
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True)
    commands = dict(live=live, probe=probe, public=public, refusals=refusals,
                    schema=lambda: refusals(True), mutants=mutants)
    if sys.argv[1:]:
        require(len(sys.argv) == 2 and sys.argv[1] in commands, 'ADDRESS arguments')
        print(f'ADDRESS {sys.argv[1]} {commands[sys.argv[1]]()} OK', flush=True)
    else:
        cases, signed, pairs = live()
        probes, public_cases, invalid, killed = probe(), public(), refusals(), mutants()
        print(f'ADDRESS cases={cases} signed={signed} pairs={pairs} probes={probes} '
              f'public={public_cases} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('ADDRESS FAIL ' + str(error), flush=True)
        sys.exit(1)

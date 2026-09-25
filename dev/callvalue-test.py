#!/usr/bin/env python3
"""Check value snapshots against independent model and Cancun outcomes."""
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
WORK = ROOT / '.gatework/callvalue'
SPEC = importlib.util.spec_from_file_location('callvalue_payable', ROOT / 'dev/payable-test.py')
P = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(P)
C = P.C
P.WORK = C.WORK = WORK
require = C.require
DECL = '  | callvalue : (Word 256 -> Tx) -> Tx\n'


def core(errors, proofs, caller, payable, *, used=True):
    prefix = C.fixture(errors=errors, proofs=proofs, deployer=False).split('\ndef owner', 1)[0]
    if not caller:
        prefix = prefix.replace('  | caller : (Word 256 -> Tx) -> Tx\n', '')
    prefix += DECL + ('  | payable : Tx -> Tx\n' if payable else '')
    failure = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
    guard = (f'guardLe value args.0 (fun (0 p : Le value args.0) => done value) ({failure})'
             if proofs else f'le value args.0 (done value) ({failure})')
    sender = 'caller (fun (sender : Word 256) => done sender)' if caller else 'done value'
    bodies = [
        'callvalue (fun (value : Word 256) => done value)',
        'callvalue (fun (value : Word 256) => store storage.0 value '
        '(load storage.0 (fun (loaded : Word 256) => store storage.0 args.0 '
        '(callvalue (fun (again : Word 256) => add loaded again '
        '(fun (result : ResultWord) => case result with '
        '| 0 (total : Word 256) => done total | 1 (unused : prod ()) => abort))))))',
        f'callvalue (fun (value : Word 256) => store storage.0 value ({guard}))',
        f'callvalue (fun (value : Word 256) => store storage.0 value ({sender}))',
        f'callvalue (fun (value : Word 256) => store storage.0 value ({failure}))',
        'callvalue (fun (value : Word 256) => done value)',
    ]
    if not used:
        bodies = ['done (word 256 17)'] * len(bodies)
    bodies = [f'payable ({body})' if payable and i < 5 else body for i, body in enumerate(bodies)]
    names = ('observe', 'snapshot', 'bounded', 'sender', 'fail', 'plain')
    branches = '\n'.join(f'  | {i} (args : {name}) => {body}'
                         for i, (name, body) in enumerate(zip(names, bodies)))
    return prefix + '''
def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def amount : Type 0 := Word 256
def observe : Type 0 := (prod () : Type 0)
def snapshot : Type 0 := prod (amount)
def bounded : Type 0 := prod (amount)
def sender : Type 0 := (prod () : Type 0)
def fail : Type 0 := (prod () : Type 0)
def plain : Type 0 := (prod () : Type 0)
def Entry : Type 0 := sum (observe, snapshot, bounded, sender, fail, plain)
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) => case entry with
''' + branches + '\n'


def live():
    signatures = ('observe()', 'snapshot(uint256)', 'bounded(uint256)', 'sender()', 'fail()', 'plain()')
    selectors = [P.selector(signature) for signature in signatures]
    denied = '0x' + P.selector('Denied()')
    cases = signed = pairs = 0
    for errors, proofs, caller, payable in itertools.product((False, True), repeat=4):
        name = 'core-' + ''.join(str(int(flag)) for flag in (errors, proofs, caller, payable))
        path, output, runtime = C.emit(name, core(errors, proofs, caller, payable))
        P.abi(output, dict(zip(('observe', 'snapshot', 'bounded', 'sender', 'fail', 'plain'),
              ['payable' if payable else kind for kind in ('view', 'nonpayable', 'nonpayable', 'nonpayable', 'nonpayable')]
              + ['view'])))
        for value in (0, 1, P.MAX):
            failure = P.expected(output=denied if errors else '0x')
            outcomes = [P.expected(value),
                        P.expected(2 * value, stored=37) if value <= P.MAX // 2 else P.expected(),
                        P.expected(value, stored=value) if value <= 10 else failure,
                        P.expected(C.SENDER if caller else value, stored=value),
                        failure, P.expected(0) if value == 0 else P.expected()]
            data = [selectors[0], selectors[1] + P.word(37), selectors[2] + P.word(10), *selectors[3:]]
            for i, (calldata, want) in enumerate(zip(data, outcomes)):
                if not payable and value:
                    want = P.expected()
                signed_case = errors and proofs and caller and payable
                P.outcome(f'{name}-{value}-{i}', path, runtime, calldata, value, want, signed=signed_case)
                cases += 1
                signed += int(signed_case)
            for i, calldata in enumerate(('', 'abcdef', 'ffffffff', selectors[1])):
                P.outcome(f'{name}-dispatch-{value}-{i}', path, runtime, calldata, value, P.expected())
                cases += 1
        unused = core(errors, proofs, caller, payable, used=False)
        pair_path, with_output, _ = C.emit(name + '-unused', unused)
        pair_path.write_text(unused.replace(DECL, ''))
        without_output = WORK / (name + '-absent')
        C.checked('emit-' + name + '-absent', [C.BINARY, 'emit', pair_path, '-o', without_output])
        require(all((with_output / file).read_bytes() == (without_output / file).read_bytes()
                    for file in P.FILES), 'CALLVALUE-UNUSED ' + name)
        pairs += 1
    return cases, signed, pairs


def probe():
    path, output, runtime = C.emit('surface', (ROOT / 'examples/CallValue.asy').read_text())
    P.abi(output, dict(deposit='payable', observe='payable', sender='payable', fail='payable', zero='view'))
    observe, deposit, sender, fail, zero, large, observed = map(P.selector,
        ('observe()', 'deposit(uint256)', 'sender()', 'fail()', 'zero()', 'TooLarge(uint256)', 'Observed(uint256)'))
    rows = [
        ('observe', observe, 19, P.expected(19)),
        ('max', observe, P.MAX, P.expected(P.MAX)),
        ('deposit', deposit + P.word(37), 19, P.expected(19, stored=19)),
        ('guard', deposit + P.word(18), 19, P.expected(output='0x' + large + P.word(19))),
        ('sender', sender, 19, P.expected(C.SENDER, stored=19)),
        ('rollback', fail, 19, P.expected(output='0x' + observed + P.word(19))),
        ('zero', zero, 0, P.expected(0)),
        ('nonpayable', zero, 19, P.expected()),
        ('short', deposit, 19, P.expected()),
        ('trailing', observe + P.word(42), 19, P.expected(19)),
    ]
    for name, data, value, want in rows:
        P.outcome('cv-' + name, path, runtime, data, value, want)
    for caller in (0, 2**160 - 1):
        P.outcome('cv-caller-' + str(caller), path, runtime, sender, 19, P.expected(caller, stored=19), caller=caller)
    return len(rows) + 2


def public():
    path = ROOT / 'examples/CallValue.asy'
    data = P.selector('deposit(uint256)') + P.word(37)
    state = C.prestate(P.SLOTS)
    prestate = WORK / 'public-prestate.json'
    prestate.write_text(json.dumps(state))
    for command in ('trace', 'diff'):
        text = C.checked('public-' + command,
            [C.BINARY, command, path, '--calldata', data, '--value', '19', '--caller', hex(C.SENDER), '--prestate', prestate])
        if command == 'diff':
            lines = text.splitlines()
            require(len(lines) == 2 and lines[1] == 'DIFF OK', 'CALLVALUE-PUBLIC diff report')
            result, want = json.loads(lines[0]), '0x' + P.word(19)
        else:
            result, want = C.D.run_outcome(text), P.word(19)
        require(result['status'] == 'success' and result['output'] == want and
                result['storage'][C.D.RECEIVER] == P.expected(19, stored=19)['storage'],
                'CALLVALUE-PUBLIC ' + command)
    return 2


def refusals(only_schema=False):
    valid = core(False, False, False, True, used=False)
    rows = [('wrong-width', valid.replace(DECL, DECL.replace('Word 256', 'Word 160')))]
    if not only_schema:
        rows += [
            ('wrong-result', valid.replace(DECL, '  | callvalue : Word 256 -> Tx\n')),
            ('wrong-arity', valid.replace(DECL, '  | callvalue : (Word 256 -> Tx) -> Tx -> Tx\n')),
            ('wrong-order', valid.replace(DECL + '  | payable : Tx -> Tx\n', '  | payable : Tx -> Tx\n' + DECL)),
            ('duplicate', valid.replace(DECL, DECL + DECL)),
            ('fallback', valid + 'def fallback : Tx := callvalue (fun (value : Word 256) => abort)\n'),
        ]
        def surface(body, *, entry='observe', init='pure ()', fallback=''):
            return (f'contract Invalid where storage State := {{ cell : Word }} '
                    f'payable entry {entry} () : Eff Sig Word := do {body} '
                    f'{fallback} constructor := do {init}')
        rows += [
            ('effect-argument', surface('value <- callvalue (word 1) ; pure value')),
            ('pure-use', surface('pure callvalue')),
            ('word-binding', surface('let value := callvalue ; pure value')),
            ('reserved-entry', surface('pure (word 0)', entry='callvalue')),
            ('reserved-local', surface('callvalue <- caller ; pure callvalue')),
            ('constructor', surface('pure (word 0)', init='value <- callvalue ; pure ()')),
            ('surface-fallback', surface('pure (word 0)', fallback='fallback : Eff Sig Never := do value <- callvalue ; revert')),
        ]
    for name, source in rows:
        path = WORK / ('invalid-' + name + '.asy')
        path.write_text(source)
        output = WORK / ('invalid-' + name)
        result = C.capture('refusal-' + name, [C.BINARY, 'emit', path, '-o', output])
        marker = ('M0_PROTOCOL' if name.startswith('wrong-') or name == 'duplicate'
                  else 'closed revert' if name == 'fallback' else 'SURFACE_')
        require(result.returncode in (1, 2) and marker.lower() in result.stderr.lower() and not output.exists(),
                'CALLVALUE-REFUSAL ' + name + ': ' + result.stderr)
    return len(rows)


def mutants():
    rows = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-callvalue-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, file, before, after, mode, marker in rows:
            path = copy / file
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'CALLVALUE-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'CALLVALUE-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/callvalue-test.py', mode], cwd=copy, timeout=90)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'CALLVALUE-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('CALLVALUE-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(rows)


def main():
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True, exist_ok=True)
    commands = dict(live=live, probe=probe, public=public, refusals=refusals,
                    schema=lambda: refusals(True), mutants=mutants)
    if sys.argv[1:]:
        require(len(sys.argv) == 2 and sys.argv[1] in commands, 'CALLVALUE arguments')
        print(f'CALLVALUE {sys.argv[1]} {commands[sys.argv[1]]()} OK', flush=True)
    else:
        cases, signed, pairs = live()
        probes, public_cases, invalid, killed = probe(), public(), refusals(), mutants()
        print(f'CALLVALUE cases={cases} signed={signed} pairs={pairs} probes={probes} '
              f'public={public_cases} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('CALLVALUE FAIL ' + str(error), flush=True)
        sys.exit(1)

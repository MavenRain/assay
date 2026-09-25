#!/usr/bin/env python3
"""Check calldata lengths against independent outcomes and Cancun execution."""
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
WORK = ROOT / '.gatework/calldatasize'
SPEC = importlib.util.spec_from_file_location('calldatasize_payable', ROOT / 'dev/payable-test.py')
P = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(P)
C = P.C
P.WORK = C.WORK = WORK
require = C.require
DECL = '  | calldatasize : (Word 256 -> Tx) -> Tx\n'
NAMES = ('observe', 'snapshot', 'bounded', 'sender', 'amount', 'fail', 'plain')


def core(errors, proofs, caller, callvalue, payable, *, used=True):
    prefix = C.fixture(errors=errors, proofs=proofs, deployer=False).split('\ndef owner', 1)[0]
    if not caller:
        prefix = prefix.replace('  | caller : (Word 256 -> Tx) -> Tx\n', '')
    if callvalue:
        prefix += '  | callvalue : (Word 256 -> Tx) -> Tx\n'
    prefix += DECL + ('  | payable : Tx -> Tx\n' if payable else '')
    failure = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
    guard = (f'guardLe size args.0 (fun (0 p : Le size args.0) => done size) ({failure})'
             if proofs else f'le size args.0 (done size) ({failure})')
    sender = 'caller (fun (who : Word 256) => done who)' if caller else 'done size'
    amount = 'callvalue (fun (value : Word 256) => done value)' if callvalue else 'done size'
    bodies = [
        'calldatasize (fun (size : Word 256) => done size)',
        'calldatasize (fun (size : Word 256) => store storage.0 size '
        '(load storage.0 (fun (loaded : Word 256) => store storage.0 args.0 '
        '(calldatasize (fun (again : Word 256) => add loaded again '
        '(fun (result : ResultWord) => case result with '
        '| 0 (total : Word 256) => done total | 1 (unused : prod ()) => abort))))))',
        f'calldatasize (fun (size : Word 256) => store storage.0 size ({guard}))',
        f'calldatasize (fun (size : Word 256) => store storage.0 size ({sender}))',
        f'calldatasize (fun (size : Word 256) => store storage.0 size ({amount}))',
        f'calldatasize (fun (size : Word 256) => store storage.0 size ({failure}))',
        'calldatasize (fun (size : Word 256) => done size)',
    ] if used else ['done (word 256 17)'] * len(NAMES)
    bodies = [f'payable ({body})' if payable and i < 6 else body for i, body in enumerate(bodies)]
    declarations = ''.join(f'def {name} : Type 0 := '
                           + ('prod (limit)' if i in (1, 2) else '(prod () : Type 0)') + '\n'
                           for i, name in enumerate(NAMES))
    branches = '\n'.join(f'  | {i} (args : {name}) => {body}'
                         for i, (name, body) in enumerate(zip(NAMES, bodies)))
    return prefix + '''
def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def limit : Type 0 := Word 256
''' + declarations + 'def Entry : Type 0 := sum (' + ', '.join(NAMES) + ''')
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) => case entry with
''' + branches + '\n'


def live():
    selectors = [P.selector(name + ('(uint256)' if i in (1, 2) else '()'))
                 for i, name in enumerate(NAMES)]
    denied = '0x' + P.selector('Denied()')
    cases = signed = pairs = 0
    for flags in itertools.product((False, True), repeat=5):
        errors, proofs, caller, callvalue, payable = flags
        name = 'core-' + ''.join(str(int(flag)) for flag in flags)
        path, output, runtime = C.emit(name, core(*flags))
        P.abi(output, dict(zip(NAMES, ['payable' if payable else kind for kind in
              ('view', 'nonpayable', 'nonpayable', 'nonpayable', 'nonpayable', 'nonpayable')] + ['view'])))
        for trailing, value in itertools.product((0, 3), (0, 19)):
            length, wide = 4 + trailing, 36 + trailing
            failure = P.expected(output=denied if errors else '0x')
            outcomes = [P.expected(length), P.expected(2 * wide, stored=37),
                        P.expected(wide, stored=wide) if wide <= 36 else failure,
                        P.expected(C.SENDER if caller else length, stored=length),
                        P.expected(value if callvalue else length, stored=length),
                        failure, P.expected(length) if value == 0 else P.expected()]
            data = [selectors[0], selectors[1] + P.word(37), selectors[2] + P.word(36), *selectors[3:]]
            for i, (calldata, want) in enumerate(zip(data, outcomes)):
                if not payable and value:
                    want = P.expected()
                signed_case = all(flags)
                P.outcome(f'{name}-{trailing}-{value}-{i}', path, runtime, calldata + 'ab' * trailing,
                          value, want, signed=signed_case)
                cases += 1
                signed += int(signed_case)
        for i, data in enumerate(('', 'abcdef', 'ffffffff', selectors[1])):
            P.outcome(f'{name}-dispatch-{i}', path, runtime, data, 0, P.expected())
            cases += 1
        unused = core(*flags, used=False)
        pair_path, with_output, _ = C.emit(name + '-unused', unused)
        pair_path.write_text(unused.replace(DECL, ''))
        without_output = WORK / (name + '-absent')
        C.checked('emit-' + name + '-absent', [C.BINARY, 'emit', pair_path, '-o', without_output])
        require(all((with_output / file).read_bytes() == (without_output / file).read_bytes()
                    for file in P.FILES), 'CALLDATASIZE-UNUSED ' + name)
        pairs += 1
    return cases, signed, pairs


def probe():
    path, output, runtime = C.emit('surface', (ROOT / 'examples/CalldataSize.asy').read_text())
    P.abi(output, dict(deposit='payable', observe='payable', mixed='payable', sender='payable',
                       fail='payable', plain='view'))
    observe, deposit, mixed, sender, fail, plain, large, observed = map(P.selector,
        ('observe()', 'deposit(uint256)', 'mixed()', 'sender()', 'fail()', 'plain()',
         'TooLarge(uint256)', 'Observed(uint256)'))
    rows = [
        ('observe', observe, 19, P.expected(4)),
        ('deposit', deposit + P.word(36), 19, P.expected(36, stored=36)),
        ('guard', deposit + P.word(36) + '00', 19, P.expected(output='0x' + large + P.word(37))),
        ('mixed', mixed + '112233', 19, P.expected(7, stored=19)),
        ('sender', sender, 19, P.expected(C.SENDER, stored=4)),
        ('rollback', fail + '00', 19, P.expected(output='0x' + observed + P.word(5))),
        ('plain', plain, 0, P.expected(4)),
        ('nonpayable', plain, 19, P.expected()),
        ('short', deposit, 19, P.expected()),
    ]
    rows += [(f'length-{size}', observe + 'ab' * (size - 4), 0, P.expected(size))
             for size in (5, 31, 32, 33, 255, 256, 32768)]
    for name, data, value, want in rows:
        P.outcome('cds-' + name, path, runtime, data, value, want)
    return len(rows)


def public():
    path = ROOT / 'examples/CalldataSize.asy'
    data = P.selector('deposit(uint256)') + P.word(40) + 'aabbcc'
    prestate = WORK / 'public-prestate.json'
    prestate.write_text(json.dumps(C.prestate(P.SLOTS)))
    for command in ('trace', 'diff'):
        text = C.checked('public-' + command,
            [C.BINARY, command, path, '--calldata', data, '--value', '19', '--caller', hex(C.SENDER), '--prestate', prestate])
        if command == 'diff':
            lines = text.splitlines()
            require(len(lines) == 2 and lines[1] == 'DIFF OK', 'CALLDATASIZE-PUBLIC diff report')
            result, want = json.loads(lines[0]), '0x' + P.word(39)
        else:
            result, want = C.D.run_outcome(text), P.word(39)
        require(result['status'] == 'success' and result['output'] == want and
                result['storage'][C.D.RECEIVER] == P.expected(39, stored=39)['storage'],
                'CALLDATASIZE-PUBLIC ' + command)
    return 2


def refusals(only_schema=False):
    valid = core(False, False, False, False, True, used=False)
    rows = [('wrong-width', valid.replace(DECL, DECL.replace('Word 256', 'Word 160')))]
    if not only_schema:
        rows += [
            ('wrong-result', valid.replace(DECL, '  | calldatasize : Word 256 -> Tx\n')),
            ('wrong-arity', valid.replace(DECL, '  | calldatasize : (Word 256 -> Tx) -> Tx -> Tx\n')),
            ('wrong-order', valid.replace(DECL + '  | payable : Tx -> Tx\n', '  | payable : Tx -> Tx\n' + DECL)),
            ('duplicate', valid.replace(DECL, DECL + DECL)),
            ('fallback', valid + 'def fallback : Tx := calldatasize (fun (size : Word 256) => abort)\n'),
        ]
        def surface(body, *, entry='observe', init='pure ()', fallback=''):
            return (f'contract Invalid where storage State := {{ cell : Word }} '
                    f'payable entry {entry} () : Eff Sig Word := do {body} '
                    f'{fallback} constructor := do {init}')
        rows += [
            ('effect-argument', surface('size <- calldatasize (word 1) ; pure size')),
            ('pure-use', surface('pure calldatasize')),
            ('word-binding', surface('let size := calldatasize ; pure size')),
            ('reserved-entry', surface('pure (word 0)', entry='calldatasize')),
            ('reserved-local', surface('calldatasize <- caller ; pure calldatasize')),
            ('constructor', surface('pure (word 0)', init='size <- calldatasize ; pure ()')),
            ('surface-fallback', surface('pure (word 0)', fallback='fallback : Eff Sig Never := do size <- calldatasize ; revert')),
        ]
    for name, source in rows:
        path = WORK / ('invalid-' + name + '.asy')
        path.write_text(source)
        output = WORK / ('invalid-' + name)
        result = C.capture('refusal-' + name, [C.BINARY, 'emit', path, '-o', output])
        marker = ('M0_PROTOCOL' if name.startswith('wrong-') or name == 'duplicate'
                  else 'closed revert' if name == 'fallback' else 'SURFACE_')
        require(result.returncode in (1, 2) and marker.lower() in result.stderr.lower() and not output.exists(),
                'CALLDATASIZE-REFUSAL ' + name + ': ' + result.stderr)
    return len(rows)


def mutants():
    rows = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-calldatasize-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, file, before, after, mode, marker in rows:
            path = copy / file
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'CALLDATASIZE-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'CALLDATASIZE-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/calldatasize-test.py', mode], cwd=copy, timeout=120)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'CALLDATASIZE-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('CALLDATASIZE-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(rows)


def main():
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True, exist_ok=True)
    commands = dict(live=live, probe=probe, public=public, refusals=refusals,
                    schema=lambda: refusals(True), mutants=mutants)
    if sys.argv[1:]:
        require(len(sys.argv) == 2 and sys.argv[1] in commands, 'CALLDATASIZE arguments')
        print(f'CALLDATASIZE {sys.argv[1]} {commands[sys.argv[1]]()} OK', flush=True)
    else:
        cases, signed, pairs = live()
        probes, public_cases, invalid, killed = probe(), public(), refusals(), mutants()
        print(f'CALLDATASIZE cases={cases} signed={signed} pairs={pairs} probes={probes} '
              f'public={public_cases} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('CALLDATASIZE FAIL ' + str(error), flush=True)
        sys.exit(1)

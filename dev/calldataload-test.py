#!/usr/bin/env python3
"""Check calldata words against byte slicing and Cancun execution."""
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
WORK = ROOT / '.gatework/calldataload'
SPEC = importlib.util.spec_from_file_location('calldataload_payable', ROOT / 'dev/payable-test.py')
P = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(P)
C = P.C
P.WORK = C.WORK = WORK
require = C.require
DECL = '  | calldataload : Word 256 -> (Word 256 -> Tx) -> Tx\n'
NAMES = ('observe', 'snapshot', 'bounded', 'sender', 'amount', 'size', 'fail', 'plain')


def expected_word(data, offset):
    raw = bytes.fromhex(data)
    return int.from_bytes(raw[offset:offset + 32].ljust(32, b'\x00'), 'big')


def core(errors, proofs, caller, callvalue, calldatasize, payable, *, used=True):
    prefix = C.fixture(errors=errors, proofs=proofs, deployer=False).split('\ndef owner', 1)[0]
    if not caller:
        prefix = prefix.replace('  | caller : (Word 256 -> Tx) -> Tx\n', '')
    if callvalue:
        prefix += '  | callvalue : (Word 256 -> Tx) -> Tx\n'
    if calldatasize:
        prefix += '  | calldatasize : (Word 256 -> Tx) -> Tx\n'
    prefix += DECL + ('  | payable : Tx -> Tx\n' if payable else '')
    failure = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
    guard = (f'guardLe first (word 256 42) (fun (0 p : Le first (word 256 42)) => done first) ({failure})'
             if proofs else f'le first (word 256 42) (done first) ({failure})')
    tails = [
        'done first',
        'calldataload (word 256 0) (fun (second : Word 256) => '
        'store storage.0 args.0 (done first))',
        f'store storage.0 first ({guard})',
        'caller (fun (who : Word 256) => done who)' if caller else 'done first',
        'callvalue (fun (amount : Word 256) => done amount)' if callvalue else 'done first',
        'calldatasize (fun (size : Word 256) => done size)' if calldatasize else 'done first',
        f'store storage.0 first ({failure})',
        'done first',
    ]
    bodies = [f'calldataload args.0 (fun (first : Word 256) => {tail})' for tail in tails]
    if not used:
        bodies = ['done (word 256 17)'] * len(NAMES)
    bodies = [f'payable ({body})' if payable and i < 7 else body for i, body in enumerate(bodies)]
    declarations = ''.join(f'def {name} : Type 0 := prod (offset)\n' for name in NAMES)
    branches = '\n'.join(f'  | {i} (args : {name}) => {body}'
                         for i, (name, body) in enumerate(zip(NAMES, bodies)))
    return prefix + '''
def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def offset : Type 0 := Word 256
''' + declarations + 'def Entry : Type 0 := sum (' + ', '.join(NAMES) + ''')
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) => case entry with
''' + branches + '\n'


def live():
    selectors = [P.selector(name + '(uint256)') for name in NAMES]
    denied = '0x' + P.selector('Denied()')
    cases = signed = pairs = 0
    for flags in itertools.product((False, True), repeat=6):
        errors, proofs, caller, callvalue, calldatasize, payable = flags
        name = 'core-' + ''.join(str(int(flag)) for flag in flags)
        path, output, runtime = C.emit(name, core(*flags))
        kinds = ('view', 'nonpayable', 'nonpayable', 'view', 'view', 'view', 'nonpayable')
        P.abi(output, dict(zip(NAMES, ['payable' if payable else kind for kind in kinds] + ['view'])))
        rows = []
        for offset in (0, 1, 4, 31, 32, 35, 36, 63, 67, 68, 72, 73, 2**64, P.MAX):
            data = selectors[0] + P.word(offset) + P.word(42) + '112233aabb'
            rows.append((f'offset-{offset}', data, 0, P.expected(expected_word(data, offset))))
        for value in (0, 19):
            data = [selector + P.word(36) + P.word(42) for selector in selectors]
            failure = P.expected(output=denied if errors else '0x')
            wants = [P.expected(42), P.expected(42, stored=36), P.expected(42, stored=42),
                     P.expected(C.SENDER if caller else 42), P.expected(value if callvalue else 42),
                     P.expected(68 if calldatasize else 42), failure,
                     P.expected(42) if value == 0 else P.expected()]
            for i, (calldata, want) in enumerate(zip(data, wants)):
                if value and not payable:
                    want = P.expected()
                rows.append((f'entry-{i}-value-{value}', calldata, value, want))
        rows.append(('guard-fail', selectors[2] + P.word(36) + P.word(43), 0,
                     P.expected(output=denied if errors else '0x')))
        for i, data in enumerate(('', 'abcdef', 'ffffffff', selectors[0])):
            rows.append((f'dispatch-{i}', data, 0, P.expected()))
        for label, data, value, want in rows:
            signed_case = all(flags)
            P.outcome(f'{name}-{label}', path, runtime, data, value, want, signed=signed_case)
            cases += 1
            signed += int(signed_case)
        unused = core(*flags, used=False)
        pair_path, with_output, _ = C.emit(name + '-unused', unused)
        pair_path.write_text(unused.replace(DECL, ''))
        without_output = WORK / (name + '-absent')
        C.checked('emit-' + name + '-absent', [C.BINARY, 'emit', pair_path, '-o', without_output])
        require(all((with_output / file).read_bytes() == (without_output / file).read_bytes()
                    for file in P.FILES), 'CALLDATALOAD-UNUSED ' + name)
        pairs += 1
    return cases, signed, pairs


def probe():
    path, output, runtime = C.emit('surface', (ROOT / 'examples/CalldataWord.asy').read_text())
    P.abi(output, dict(observe='view', deposit='payable', snapshot='payable', indirect='view',
                      computed='view', stored='view', fail='nonpayable', plain='view', atEnd='view'))
    signatures = ('observe(uint256)', 'deposit(uint256,uint256)', 'snapshot(uint256)', 'indirect()',
                  'computed(uint256)', 'stored()', 'fail(uint256)', 'plain()', 'atEnd()')
    read, deposit, snapshot, indirect, computed, stored, fail, plain, end = map(P.selector, signatures)
    large, observed = map(P.selector, ('TooLarge(uint256)', 'Observed(uint256,uint256)'))
    rows = []
    for offset in (0, 1, 4, 31, 32, 35, 36, 63, 64, 2**63 - 1, 2**64, P.MAX):
        data = read + P.word(offset) + '0123456789abcdef'
        rows.append((f'read-{offset}', data, 0, P.expected(expected_word(data, offset))))
    for size in (36, 37, 63, 64, 65, 32768):
        data = read + P.word(size - 1) + 'ab' * (size - 36)
        rows.append((f'tail-{size}', data, 0, P.expected(expected_word(data, size - 1))))
    data = plain + '80'
    rows.append(('padding', data, 0, P.expected(int(data, 16) << (8 * (32 - len(data) // 2)))))
    rows += [
        ('guard', deposit + P.word(68) + P.word(42) + P.word(42), 19, P.expected(42, stored=42)),
        ('guard-fail', deposit + P.word(68) + P.word(42) + P.word(43), 19,
         P.expected(output='0x' + large + P.word(43))),
        ('snapshot', snapshot + P.word(36) + P.word(42), 19, P.expected(42, stored=19)),
        ('indirect', indirect + P.word(36) + P.word(42), 0, P.expected(42)),
        ('indirect-huge', indirect + P.word(P.MAX), 0, P.expected(0)),
        ('computed', computed + P.word(35) + P.word(42), 0, P.expected(42)),
        ('arithmetic-overflow', computed + P.word(P.MAX), 0, P.expected()),
        ('end', end + 'aabbcc', 0, P.expected(0)),
        ('nonpayable', plain, 19, P.expected()),
        ('short', read, 0, P.expected()),
    ]
    data = stored + '0102030405060708'
    rows.append(('stored', data, 0, P.expected(expected_word(data, 7))))
    data = fail + P.word(36) + P.word(42)
    rows.append(('rollback', data, 0,
                 P.expected(output='0x' + observed + P.word(42) + P.word(expected_word(data, 0)))))
    for name, data, value, want in rows:
        P.outcome('cdl-' + name, path, runtime, data, value, want)
    return len(rows)


def public():
    path = ROOT / 'examples/CalldataWord.asy'
    data = P.selector('deposit(uint256,uint256)') + P.word(68) + P.word(42) + P.word(42)
    prestate = WORK / 'public-prestate.json'
    prestate.write_text(json.dumps(C.prestate(P.SLOTS)))
    for command in ('trace', 'diff'):
        text = C.checked('public-' + command,
            [C.BINARY, command, path, '--calldata', data, '--value', '19', '--caller', hex(C.SENDER), '--prestate', prestate])
        if command == 'diff':
            lines = text.splitlines()
            require(len(lines) == 2 and lines[1] == 'DIFF OK', 'CALLDATALOAD-PUBLIC diff report')
            result, want = json.loads(lines[0]), '0x' + P.word(42)
        else:
            result, want = C.D.run_outcome(text), P.word(42)
        require(result['status'] == 'success' and result['output'] == want and
                result['storage'][C.D.RECEIVER] == P.expected(42, stored=42)['storage'],
                'CALLDATALOAD-PUBLIC ' + command)
    return 2


def refusals(only_schema=False):
    valid = core(False, False, False, False, False, True, used=False)
    rows = [('wrong-width', valid.replace(DECL, DECL.replace('Word 256 -> (', 'Word 160 -> (')))]
    if not only_schema:
        rows += [
            ('wrong-result-width', valid.replace(DECL, DECL.replace('(Word 256', '(Word 160'))),
            ('wrong-arity', valid.replace(DECL, DECL.replace('Word 256 -> (', '('))),
            ('wrong-continuation', valid.replace(DECL, '  | calldataload : Word 256 -> Tx -> Tx\n')),
            ('wrong-order', valid.replace(DECL + '  | payable : Tx -> Tx\n', '  | payable : Tx -> Tx\n' + DECL)),
            ('duplicate', valid.replace(DECL, DECL + DECL)),
            ('fallback', valid + 'def fallback : Tx := calldataload (word 256 0) (fun (v : Word 256) => abort)\n'),
        ]
        def surface(body, *, entry='observe', init='pure ()', fallback=''):
            return (f'contract Invalid where storage State := {{ cell : Word }} '
                    f'entry {entry} () : Eff Sig Word := do {body} '
                    f'{fallback} constructor := do {init}')
        rows += [
            ('missing-offset', surface('v <- calldataload ; pure v')),
            ('extra-offset', surface('v <- calldataload (word 0) (word 1) ; pure v')),
            ('unknown-offset', surface('v <- calldataload missing ; pure v')),
            ('self-offset', surface('v <- calldataload v ; pure v')),
            ('oversized-offset', surface(f'v <- calldataload (word {2**256}) ; pure v')),
            ('pure-use', surface('pure calldataload')),
            ('word-binding', surface('let v := calldataload (word 0) ; pure v')),
            ('reserved-entry', surface('pure (word 0)', entry='calldataload')),
            ('reserved-local', surface('calldataload <- caller ; pure calldataload')),
            ('constructor', surface('pure (word 0)', init='v <- calldataload (word 0) ; pure ()')),
            ('surface-fallback', surface('pure (word 0)',
             fallback='fallback : Eff Sig Never := do v <- calldataload (word 0) ; revert')),
        ]
    for name, source in rows:
        path = WORK / ('invalid-' + name + '.asy')
        path.write_text(source)
        output = WORK / ('invalid-' + name)
        result = C.capture('refusal-' + name, [C.BINARY, 'emit', path, '-o', output])
        marker = ('M0_PROTOCOL' if name.startswith('wrong-') or name == 'duplicate'
                  else 'closed revert' if name == 'fallback' else 'SURFACE_')
        require(result.returncode in (1, 2) and marker.lower() in result.stderr.lower() and not output.exists(),
                'CALLDATALOAD-REFUSAL ' + name + ': ' + result.stderr)
    return len(rows)


def mutants():
    rows = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-calldataload-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, file, before, after, mode, marker in rows:
            path = copy / file
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'CALLDATALOAD-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'CALLDATALOAD-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/calldataload-test.py', mode], cwd=copy, timeout=120)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'CALLDATALOAD-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('CALLDATALOAD-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(rows)


def main():
    if WORK.exists():
        shutil.rmtree(WORK)
    WORK.mkdir(parents=True, exist_ok=True)
    commands = dict(live=live, probe=probe, public=public, refusals=refusals,
                    schema=lambda: refusals(True), mutants=mutants)
    if sys.argv[1:]:
        require(len(sys.argv) == 2 and sys.argv[1] in commands, 'CALLDATALOAD arguments')
        print(f'CALLDATALOAD {sys.argv[1]} {commands[sys.argv[1]]()} OK', flush=True)
    else:
        cases, signed, pairs = live()
        probes, public_cases, invalid, killed = probe(), public(), refusals(), mutants()
        print(f'CALLDATALOAD cases={cases} signed={signed} pairs={pairs} probes={probes} '
              f'public={public_cases} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('CALLDATALOAD FAIL ' + str(error), flush=True)
        sys.exit(1)

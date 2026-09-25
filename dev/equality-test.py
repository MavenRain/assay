#!/usr/bin/env python3
"""Check equality sugar against explicit bounds and independent EVM outcomes."""
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
WORK = ROOT / '.gatework/equality'
spec = importlib.util.spec_from_file_location('equality_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
C.WORK = WORK
require = C.require
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')
MAX = 2**256 - 1


def single(body, extra='', init='sstore cell (word 7) ;', args='(a : Word) (b : Word)'):
    return f'''contract Equality where
  storage State := {{ cell : Word ; mirror : Word }}
  {extra}
  entry compare {args} : Eff Sig Word := do {body}
  constructor := do {init} pure ()
'''


def typed():
    return single('sstore cell (word 9) ; '
                  '(0 same : EqWord a b) <- guard Mismatch (a) (b) (eqWord a b) ; '
                  'let left : Word := subLe a b second(same) ; '
                  'let right : Word := subLe b a first(same) ; sstore cell left ; pure right',
                  'error Mismatch (a : Word) (b : Word)')


def fixtures():
    owner = (ROOT / 'examples/OwnerSurface.asy').read_text()
    return [
        ('typed', typed(), [('eqWord a b', 'both (leWord a b) (leWord b a)'),
                            ('EqWord a b', 'Both (Le a b) (Le b a)')]),
        ('plain', single('guard (eqWord (a) (b)) ; pure a'),
         [('eqWord (a) (b)', 'both (leWord a b) (leWord b a)')]),
        ('inferred', single('(0 same) <- guard (eqWord a b) ; let (0 saved) := same ; '
                            'let zero : Word := subLe a b ; pure zero'),
         [('eqWord a b', 'both (leWord a b) (leWord b a)')]),
        ('helper', single('(0 same) <- guard (equal(a, b)) ; '
                          'let (0 saved : EqWord a b) := identity(a, b, _) ; '
                          'let zero : Word := subLe b a first(saved) ; pure zero',
                          'predicate equal (0 a : Word) (0 b : Word) : Prop := EqWord a b\n'
                          'proof identity (0 a : Word) (0 b : Word) (0 p : EqWord a b) : EqWord a b := p'),
         [('EqWord a b', 'Both (Le a b) (Le b a)')]),
        ('compound', single('(0 p) <- guard (both (eqWord a b) (leWord a b)) ; '
                            'let zero : Word := subLe a b second(first(p)) ; pure zero'),
         [('eqWord a b', 'both (leWord a b) (leWord b a)')]),
        ('invariant', single('(0 same) <- guard (eqWord a b) ; sstore cell a ; sstore mirror b ; pure a',
                             'invariant same (s : State) : Prop := EqWord s.cell s.mirror', init=''),
         [('eqWord a b', 'both (leWord a b) (leWord b a)'),
          ('EqWord s.cell s.mirror', 'Both (Le s.cell s.mirror) (Le s.mirror s.cell)')]),
        ('static', single('let (0 same : EqWord (word 7) (word 7)) := pair((), ()) ; pure (word 7)', args='()'),
         [('EqWord (word 7) (word 7)', 'Both (Le (word 7) (word 7)) (Le (word 7) (word 7))')]),
        ('owner', owner, [('eqWord sender old', 'both (leWord sender old) (leWord old sender)')]),
    ]


def emit(name, source):
    path = WORK / (name + '.asy')
    path.write_text(source)
    output = WORK / name
    result = C.capture('emit-' + name, [C.BINARY, 'emit', path, '-o', output])
    require(result.returncode == 0, 'EQUALITY-EMIT ' + name + ': ' + result.stderr)
    return path, output, (output / 'runtime.hex').read_text().strip()


def pairs():
    records = []
    for name, source, expansions in fixtures():
        explicit = source
        for sugar, expanded in expansions:
            require(sugar in explicit, 'EQUALITY-PAIR missing sugar ' + name)
            explicit = explicit.replace(sugar, expanded)
        _, output, _ = emit('pair-' + name, source)
        _, reference, _ = emit('expanded-' + name, explicit)
        for file in FILES:
            require((output / file).read_bytes() == (reference / file).read_bytes(),
                    'EQUALITY-PAIR ' + name + ' ' + file)
        records.append(dict(name=name, files=list(FILES)))
    C.save('PAIRS', records)
    return len(records)


def selector(signature):
    return C.checked('selector-' + signature.split('(')[0], ['cast', 'sig', signature]).strip()[2:]


def outcome(name, path, runtime, data, caller, slots, want, value=0, signed=False):
    argv = [C.BINARY, 'run', path, '--calldata', data, '--caller', hex(caller), '--value', value]
    for slot, stored in slots.items():
        argv += ['--storage', f'{int(slot, 16)}={int(stored, 16)}']
    model = json.loads(C.checked('model-' + name, argv))
    evm, _ = C.evm_run(name, runtime, data, caller, slots=slots, value=value)
    require(model == want, 'EQUALITY-MODEL ' + name)
    require(evm == want, 'EQUALITY-EVM ' + name)
    if signed:
        require(caller == C.SENDER, 'EQUALITY-SIGNED caller ' + name)
        report, evidence = C.D.execute(runtime, data, C.prestate(slots), shutil.which('evm'), value=value)
        C.save('signed-' + name, dict(report=report, evidence=evidence))
        actual = dict(status=report['status'], output=report['output'],
                      storage=report['storage'].get(C.D.RECEIVER, {}))
        require(actual == want, 'EQUALITY-SIGNED ' + name)
    return dict(name=name, expected=want, signed=signed)


def live():
    source = single('sstore cell (word 9) ; guard Mismatch (a) (b) (eqWord a b) ; '
                    'sstore cell (word 0) ; pure (word 0)', 'error Mismatch (a : Word) (b : Word)')
    path, _, runtime = emit('live', source)
    sig, failure = selector('compare(uint256,uint256)'), selector('Mismatch(uint256,uint256)')
    cases = []
    words = (0, 1, 2**160 - 1, 2**255, MAX)
    before = {'0': '0x7', '1': '0xb'}
    for a in words:
        for b in words:
            data = sig + f'{a:064x}{b:064x}'
            want = dict(status='success' if a == b else 'revert',
                        output='0x' + ('00' * 32 if a == b else failure + f'{a:064x}{b:064x}'),
                        storage={'1': '0xb'} if a == b else before)
            cases.append(outcome(f'words-{a}-{b}', path, runtime, data, C.SENDER, before, want, signed=True))
    for name, data, value in [('value', sig + '00' * 64, 1), ('short', sig + '00' * 63, 0),
                              ('unknown', 'ffffffff', 0)]:
        want = dict(status='revert', output='0x', storage=before)
        cases.append(outcome(name, path, runtime, data, C.SENDER, before, want, value=value, signed=True))
    owner = (ROOT / 'examples/OwnerSurface.asy').read_text()
    path, output, runtime = emit('owner-live', owner)
    sig, failure = selector('set(uint256)'), selector('Denied(uint256,uint256)')
    for caller in (0, 1, 42, 2**160 - 1, C.SENDER):
        for stored in (0, 1, 42, 2**160 - 1, MAX):
            before = {'1': '0x3', **({'0': hex(stored)} if stored else {})}
            want = dict(status='success' if caller == stored else 'revert',
                        output='0x' + (f'{17:064x}' if caller == stored else failure + f'{caller:064x}{stored:064x}'),
                        storage={'0': '0x11', '1': '0x1'} if caller == stored else before)
            cases.append(outcome(f'owner-{caller}-{stored}', path, runtime, sig + f'{17:064x}',
                                 caller, before, want, signed=caller == C.SENDER))
    creates = []
    for caller in (0, 1, 42, 2**160 - 1):
        for value in (0, 1):
            name = f'create-{caller}-{value}'
            _, raw = C.evm_run(name, (output / 'init.hex').read_text().strip(), '', caller, value=value, create=True)
            stored = {'0': hex(caller)} if caller else {}
            require(raw['status'] == ('revert' if value else 'success') and
                    raw['output'] == ('' if value else runtime) and
                    list(raw['storage'].values()) == ([stored] if stored and not value else []), 'EQUALITY-CREATE ' + name)
            creates.append(dict(name=name, owner=caller, value=value))
    C.save('LIVE', cases)
    C.save('CREATES', creates)
    return len(cases), sum(row['signed'] for row in cases), len(creates)


def both(terms):
    if len(terms) == 1:
        return terms[0]
    middle = len(terms) // 2
    return f'both ({both(terms[:middle])}) ({both(terms[middle:])})'


def boundaries():
    records = []
    guard_limit = 'SURFACE_LIMIT: guard condition exceeds depth 32 or 64 bounds'
    claim_limit = 'SURFACE_LIMIT: claim nesting exceeds 32'
    widths = ((32, True, both(['eqWord a b'] * 32)),
              (33, False, both(['leWord a b'] * 63 + ['eqWord a b'])))
    for count, good, condition in widths:
        records.append((f'bounds-{count}', single(f'guard ({condition}) ; pure a'), good, guard_limit))
    for depth, good in ((31, True), (32, False)):
        condition = 'eqWord a b'
        for _ in range(depth):
            condition = f'both (leWord a b) ({condition})'
        records.append((f'depth-{depth}', single(f'guard ({condition}) ; pure a'), good, guard_limit))
        claim, proof = 'EqWord (word 0) (word 0)', 'pair((), ())'
        for _ in range(depth):
            claim, proof = f'Both (Le (word 0) (word 0)) ({claim})', f'pair((), {proof})'
        records.append((f'claim-depth-{depth}', single(f'let (0 p : {claim}) := {proof} ; pure a'), good, claim_limit))
    for name, source, good, message in records:
        path = WORK / (name + '.asy')
        path.write_text(source)
        result = C.capture(name, [C.BINARY, 'check', path])
        require(result.returncode == (0 if good else 1) and
                (good or message in result.stdout + result.stderr), 'EQUALITY-BOUNDARY ' + name)
    C.save('BOUNDARIES', [dict(name=name, accepted=good) for name, _, good, _ in records])
    return len(records)


def refusals():
    rows = [
        ('missing-operand', single('guard (eqWord a) ; pure a'), 'SURFACE_NAME'),
        ('extra-operand', single('guard (eqWord a b a) ; pure a'), 'SURFACE_SYNTAX'),
        ('unbound', single('guard (eqWord missing b) ; pure a'), 'SURFACE_SCOPE'),
        ('overflow', single(f'guard (eqWord a (word {MAX + 1})) ; pure a'), 'SURFACE_WORD'),
        ('reserved-field', single('pure a').replace('cell : Word', 'eqWord : Word'), 'SURFACE_NAME'),
        ('reserved-helper', single('pure a', 'proof EqWord (0 a : Word) : Le a a := ()'), 'SURFACE_NAME'),
        ('wrong-claim', single('(0 p : Le a b) <- guard (eqWord a b) ; pure a'), 'SURFACE_PROOF'),
        ('wrong-condition', single('(0 p : EqWord a b) <- guard (leWord a b) ; pure a'), 'SURFACE_PROOF'),
        ('false-evidence', single('let (0 p : EqWord (word 0) (word 1)) := pair((), ()) ; pure a'),
         'mismatch: a tuple needs a right former as its expected type'),
        ('missing-pair', single('let (0 p : EqWord a b) := () ; pure a'),
         'mismatch: the tuple width and the type width differ'),
        ('proof-runtime', single('(0 p) <- guard (eqWord a b) ; pure p'), 'SURFACE_PROOF'),
        ('stale-local', single('(0 p) <- guard (eqWord a b) ; let b : Word := word 99 ; '
                               'let zero : Word := subLe a b second(p) ; pure zero'),
         'and the expected type is (Elim SColl 2 (Out SPi w b Nat (APt w 99)'),
        ('stale-storage', single('old <- sload cell ; (0 p) <- guard (eqWord old a) ; '
                                 'sstore cell (word 99) ; fresh <- sload cell ; '
                                 'let zero : Word := subLe fresh a second(p) ; pure zero'),
         '(Out SPi w a Nat (APt w (Elim SMu Word [256] _assay_v0 as x return Nat '
         'with | (ACtor word) bits n => n)) natLt)'),
        ('constructor-invariant', single('pure a', 'invariant same (s : State) : Prop := EqWord s.cell s.mirror'),
         'mismatch: a tuple needs a right former as its expected type'),
        ('write-invariant', single('sstore cell a ; pure a',
                                   'invariant same (s : State) : Prop := EqWord s.cell s.mirror', init=''), 'SURFACE_INVARIANT'),
        ('error-arity', typed().replace('Mismatch (a) (b) (eqWord', 'Mismatch (a) (eqWord'), 'SURFACE_ERROR'),
        ('empty-payload', typed().replace('Mismatch (a) (b) (eqWord', 'Mismatch () (a) (b) (eqWord'), 'SURFACE_ERROR'),
    ]
    for name, source, marker in rows:
        path = WORK / (name + '.asy')
        path.write_text(source)
        output = WORK / (name + '-out')
        for command in (['check', path], ['emit', path, '-o', output], ['run', path, '--calldata', '0x']):
            result = C.capture(name + '-' + command[0], [C.BINARY, *command])
            require(result.returncode == 1 and marker in result.stdout + result.stderr and not output.exists(),
                    'EQUALITY-REFUSAL ' + name + ' ' + command[0] + ': ' + result.stderr)
    return len(rows)


def mutants():
    cases = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-equality-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        path = copy / 'src/emitter.bend'
        original = path.read_text()
        for name, before, after, witness, marker in cases:
            require(native_mutations.count(original, before) == 1, 'EQUALITY-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'EQUALITY-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/equality-test.py', witness], cwd=copy, timeout=180)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'EQUALITY-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('EQUALITY-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(cases)


def main():
    commands = dict(pairs=pairs, live=live, boundaries=boundaries, refusals=refusals, mutants=mutants)
    if sys.argv[1:] and sys.argv[1:] not in [[name] for name in commands]:
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True, exist_ok=True)
    if sys.argv[1:]:
        result = commands[sys.argv[1]]()
        print(f'EQUALITY {sys.argv[1]} {result} OK', flush=True)
    else:
        paired = pairs()
        cases, signed, creates = live()
        bounded, invalid, killed = boundaries(), refusals(), mutants()
        print(f'EQUALITY pairs={paired} cases={cases} signed={signed} creates={creates} '
              f'boundaries={bounded} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('EQUALITY FAIL ' + str(error), flush=True)
        sys.exit(1)

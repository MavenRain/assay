#!/usr/bin/env python3
"""Check every compound storage obligation against the kernel and Cancun."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/compound-invariants'
spec = importlib.util.spec_from_file_location('compound_predicates', ROOT / 'dev/predicate-test.py')
N = importlib.util.module_from_spec(spec)
spec.loader.exec_module(N)
B, H, T, G, E, M, P, C, require = N.B, N.H, N.T, N.G, N.E, N.M, N.P, N.C, N.require
TRUE, FALSE = B.TRUE, B.FALSE
ORDER, FITS = 'Le s.low s.high', 'Lt256 (add s.low s.high)'
CLAIM = f'Both ({ORDER}) ({FITS})'
LOCAL = 'Both (Le a b) (Lt256 (add a b))'
DECL = f'invariant bounded (s : State) : Prop := {CLAIM}\n'
LEFT = '(0 p : Le a b) <- guard (leWord a b) ; '
RIGHT = '(0 q : Lt256 (add a b)) <- guard (lt256 (add a b)) ; '
GUARDS = 'sstore low (word 9) ; ' + LEFT + RIGHT
STORES = 'sstore low a ; sstore high b ; pure a'
BINDING = f'let (0 bundle : {LOCAL}) := pair(p, q) ; '
NAMED = N.BELOW + N.ROOM + ('predicate Bounds (0 x : Word) (0 y : Word) : Prop := '
                           'Both (Below(x, y)) (Room(x, y))\n')


def program(declaration=DECL, body=GUARDS + STORES, definitions=''):
    return ('contract CompoundInvariants where storage State := { low : Word ; high : Word }\n' +
            declaration + definitions + 'entry set (a : Word) (b : Word) : Eff Sig Word := do ' + body + '\n')


def closed(claim, body='pure a', definitions=''):
    return program(f'invariant bounded (s : State) : Prop := {claim}\n', body, definitions)


def variants():
    nested = f'Both ({ORDER}) (Both ({FITS}) ({ORDER}))'
    pair = f'let (0 bundle : Both (Lt256 (add a b)) (Le a b)) := pair(q, p) ; '
    return [program(''), program(f'invariant ordered (s : State) : Prop := {ORDER}\n'
                                f'invariant fits (s : State) : Prop := {FITS}\n'),
            program(), program(body=GUARDS + BINDING + STORES),
            program(DECL.replace(CLAIM, 'Bounds(s.low, s.high)'), GUARDS + BINDING + STORES, NAMED),
            (ROOT / 'examples/CompoundInvariants.asy').read_text(),
            closed(nested, GUARDS + pair + STORES),
            closed(f'Both ({TRUE}) ({CLAIM})', GUARDS + BINDING + STORES)]


def live():
    captures, cases = [], 0
    pairs = [(0, 0), (4, 9), (9, 4), (0, G.MAX), (1, G.MAX), (G.MAX, G.MAX),
             (1, G.MAX - 1), (G.MAX // 2, G.MAX // 2 + 1)]
    selector = G.signature('set(uint256,uint256)')
    with tempfile.TemporaryDirectory(prefix='assay-compound-live-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(variants()):
            source, output = folder / f'variant-{index}.asy', folder / str(index)
            source.write_text(text)
            runtime, init = P.emit(source, output, f'compound-{index}')
            captures.append(H.outputs(output))
            if index == 5:
                E.creation(runtime, init, folder, expected_storage={})
                abi = json.loads(captures[-1]['abi.json'])
                require([(r['name'], len(r['inputs'])) for r in abi if r['type'] == 'function'] == [('set', 2)],
                        'COMPOUND-ABI erased')
            for a, b in pairs:
                success = a <= b and a + b <= G.MAX
                before = {'0': '0x2', '1': '0x8', '2': '0xabc'}
                row = dict(name='compound', calldata=selector + f'{a:064x}{b:064x}', value=0, before=before,
                           after={**before, '0': hex(a), '1': hex(b)} if success else before,
                           status='success' if success else 'revert', output='0x' + f'{a:064x}' if success else '0x')
                H.compare(f'compound-{index}-{cases}', source, runtime, row)
                cases += 1
        require(all(row == captures[0] for row in captures), 'COMPOUND-ERASURE five files')
        hashes = [{name: hashlib.sha256(data).hexdigest() for name, data in row.items()} for row in captures]
        (WORK / 'ERASURE.json').write_text(json.dumps(hashes, indent=2) + '\n')
    (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=2, erasure=len(captures)), indent=2) + '\n')
    print(f'COMPOUND-LIVE cases={cases} creates=2 erasure={len(captures)} OK', flush=True)
    return cases, len(captures)


def nested(depth):
    claim = TRUE
    for _ in range(depth):
        claim = f'Both ({TRUE}) ({claim})'
    return claim


def negative_cases():
    unused = ('predicate Ignore (0 x : Word) (0 y : Word) : Prop := '
              f'Both ({TRUE}) ({TRUE})\n')
    return [
        ('constructor-left', closed(f'Both ({FALSE}) ({TRUE})'), 'mismatch'),
        ('constructor-right', closed(f'Both ({TRUE}) ({FALSE})'), 'mismatch'),
        ('constructor-nested', closed(f'Both ({TRUE}) (Both ({TRUE}) ({FALSE}))'), 'mismatch'),
        ('constructor-order', program() + 'constructor := do sstore low (word 1) ; pure ()', 'mismatch'),
        ('constructor-overflow', program() + f'constructor := do sstore low (word {G.MAX}) ; '
         f'sstore high (word {G.MAX}) ; pure ()', 'mismatch'),
        ('final-left', program(body='sstore low (word 1) ; sstore high (word 0) ; pure a'), 'mismatch'),
        ('final-right', program(body=f'sstore low (word {G.MAX}) ; sstore high (word {G.MAX}) ; pure a'), 'mismatch'),
        ('right-write', closed(f'Both ({TRUE}) ({ORDER})',
                              'sstore low (word 1) ; sstore high (word 0) ; pure a'), 'mismatch'),
        ('missing-right-field', closed(f'Both ({TRUE}) ({ORDER})', 'sstore low (word 0) ; pure a'), 'SURFACE_INVARIANT'),
        ('missing-left-field', closed(f'Both ({ORDER}) ({TRUE})', 'sstore high (word 0) ; pure a'), 'SURFACE_INVARIANT'),
        ('ignored-argument', closed('Ignore(s.low, s.high)', 'sstore low (word 0) ; pure a', unused), 'SURFACE_INVARIANT'),
        ('unproved-left', program(body=GUARDS.replace(LEFT, '') + STORES), 'mismatch'),
        ('unproved-right', program(body=GUARDS.replace(RIGHT, '') + STORES), 'mismatch'),
        ('stale-store', program(body=GUARDS + BINDING + STORES.replace('pure a', 'sstore high (word 0) ; pure a')), 'mismatch'),
        ('stale-load', program(body=GUARDS + BINDING + 'a <- sload low ; ' + STORES), 'mismatch'),
        ('wrong-pair', program(body=GUARDS + BINDING.replace('pair(p, q)', 'pair(q, p)') + STORES), 'mismatch'),
        ('unit-bundle', program(body=GUARDS + BINDING.replace('pair(p, q)', '()') + STORES), 'mismatch'),
        ('bad-discarded', program(body=GUARDS + f'let (0 unused : Both ({LOCAL}) ({FALSE})) := '
                                 'pair(pair(p, q), ()) ; ' + STORES), 'mismatch'),
        ('unknown-right-field', program(DECL.replace('add s.low s.high', 'add s.low s.missing')), 'SURFACE_SLOT'),
        ('wrong-snapshot', program(DECL.replace('add s.low s.high', 'add old.low s.high')), 'SURFACE_INVARIANT'),
        ('guard-shape', program(body=GUARDS.replace(': Le a b)', f': {LOCAL})') + STORES), 'SURFACE_PROOF'),
        ('depth', closed(nested(33)), 'SURFACE_LIMIT'),
        ('expanded-depth', closed(f'Both ({TRUE}) (P31())', definitions=N.chain(32)), 'SURFACE_LIMIT'),
        ('expanded-nodes', closed('P11()', definitions=N.tree(11)), 'SURFACE_LIMIT'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(len(rows) == 1 if only is not None else bool(rows), 'COMPOUND-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-compound-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal(name, text, marker, Path(temporary))
    print(f'COMPOUND-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    forms = [closed(nested(32)), closed('P31()', definitions=N.chain(32)),
             closed('P10()', definitions=N.tree(10)),
             closed(f'Both ({TRUE}) ({TRUE})'),
             program(body='sstore low (word 0) ; sstore high (word 7) ; pure a'),
             program(body='x <- sload low ; (0 p : Le x b) <- guard (leWord x b) ; '
                          '(0 q : Lt256 (add x b)) <- guard (lt256 (add x b)) ; sstore high b ; pure x'),
             program(body='sstore low a ; revert'),
             program(body='x <- sload low ; pure x'),
             program().replace('high : Word }', 'high : Word ; spare : Word }').replace(
                 GUARDS + STORES, 'sstore spare a ; pure a'),
             closed(f'Both ({ORDER}) ({TRUE})',
                    'sstore low (word 0) ; sstore high (word 1) ; pure a')]
    with tempfile.TemporaryDirectory(prefix='assay-compound-boundaries-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(forms):
            source = folder / f'boundary-{index}.asy'
            source.write_text(text)
            P.emit(source, folder / str(index), f'boundary-{index}')
    print(f'COMPOUND-BOUNDARIES accepted={len(forms)} OK', flush=True)
    return len(forms)


def witness(name):
    if name != 'component-evidence':
        return refusals(name)
    with tempfile.TemporaryDirectory(prefix='assay-compound-evidence-') as temporary:
        folder = Path(temporary)
        source = folder / 'components.asy'
        source.write_text(program())
        P.emit(source, folder / 'out', name)


def mutants():
    resolved = 'let* ty = resolved_claim predicates state row.claim in'
    cases = [
        ('LEFT', resolved, resolved + '\n    let ty = match ty with Atomic _ -> ty | Bundle (_a, b) -> b in',
         'constructor-left', 'ERROR-REFUSAL constructor-left'),
        ('RIGHT', resolved, resolved + '\n    let ty = match ty with Atomic _ -> ty | Bundle (a, _b) -> a in',
         'constructor-right', 'ERROR-REFUSAL constructor-right'),
        ('RIGHT-FIELDS', 'Both (a, b) -> operands a @ operands b', 'Both (a, _b) -> operands a',
         'right-write', 'ERROR-REFUSAL right-write'),
        ('COMPONENT-EVIDENCE',
         'Bundle (a, b) -> "(tuple (" ^ invariant_proof evidence a ^ ", " ^ invariant_proof evidence b ^ "))"',
         'Bundle (a, _b) -> invariant_proof evidence a', 'component-evidence', 'M1-TOOL component-evidence'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-compound-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanon-replies', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'COMPOUND-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'COMPOUND-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/compound-invariant-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'COMPOUND-MUTANT ' + label)
            print('COMPOUND-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = {'live': live, 'refusals': refusals, 'boundaries': boundaries, 'mutants': mutants}
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/compound-invariant-test.py [live|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    N.WORK = B.WORK = H.WORK = T.WORK = G.WORK = E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, erased = live()
        invalid, accepted, killed = refusals(), boundaries(), mutants()
        print(f'COMPOUND-INVARIANTS cases={cases} creates=2 refusals={invalid} erasure={erased} boundaries={accepted} mutants={killed} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        print('COMPOUND-INVARIANTS-FAIL ' + str(exc))
        sys.exit(1)

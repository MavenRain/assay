#!/usr/bin/env python3
"""Check named runtime conditions, scope, expansion and erased evidence."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/named-guards'
spec = importlib.util.spec_from_file_location('compound_guards', ROOT / 'dev/compound-guard-test.py')
Q = importlib.util.module_from_spec(spec)
spec.loader.exec_module(Q)
I, N, B, H, T, G, E, M, P, C, require = Q.I, Q.N, Q.B, Q.H, Q.T, Q.G, Q.E, Q.M, Q.P, Q.C, Q.require
DEFINITIONS = ('predicate Below (0 x : Word) (0 y : Word) : Prop := Le x y\n'
               'predicate Room (0 x : Word) (0 y : Word) : Prop := Lt256 (add x y)\n'
               'predicate Bounds (0 x : Word) (0 y : Word) : Prop := Both (Below(x, y)) (Room(x, y))\n')
ALIAS = 'predicate Alias (0 x : Word) (0 y : Word) : Prop := Bounds(x, y)\n'
READY = 'predicate Ready : Prop := Le (word 0) (word 0)\n'
BOUND = ('predicate Bounds (0 x : Word) (0 y : Word) : Prop := '
         'Both (Le x y) (Lt256 (add x y))\n')


def program(condition='Bounds(a, b)', claim=Q.CLAIM, *, definitions=DEFINITIONS, **options):
    return Q.program(Q.guard(claim, condition), definitions=definitions, **options)


def forms():
    arithmetic = ('let d : Word := subLe b a first(bounds) ; '
                  'let total : Word := addLt a b second(bounds) ; '
                  'sstore low d ; sstore high total ; pure d')
    rows = [
        ('named', program(definitions=BOUND), 'set'),
        ('alias', program('Alias(a, b)', 'Bounds(a, b)', definitions=DEFINITIONS + ALIAS), 'set'),
        ('mixed', program('both (Below(a, b)) (lt256 (add a b))'), 'set'),
        ('substitution', program('Flip(b, a)', definitions=DEFINITIONS +
            'predicate Flip (0 a : Word) (0 b : Word) : Prop := Bounds(b, a)\n'), 'set'),
        ('invariant', (ROOT / 'examples/NamedGuards.asy').read_text(), 'set'),
        ('projections', program(tail=arithmetic), 'arithmetic'),
        ('snapshot', program(before='a <- sload low ; ' + Q.BEFORE), 'snapshot'),
        ('binder-shadow', Q.program(Q.guard(Q.CLAIM, 'Bounds(a, b)', name='a'), definitions=DEFINITIONS,
            tail='sstore low b ; sstore high b ; pure b'), 'shadow'),
        ('constant', program('both (Ready()) (Bounds(a, b))',
            f'Both (Le (word 0) (word 0)) ({Q.CLAIM})', definitions=DEFINITIONS + READY), 'set'),
        ('contextual', program('both(a, b)', definitions=BOUND.replace('Bounds', 'both')), 'set'),
        ('later-declaration', program(definitions='') + DEFINITIONS, 'set'),
        ('unused-argument', program('Bounds(a, b, a)', definitions=BOUND.replace(
            '(0 y : Word)', '(0 y : Word) (0 unused : Word)')), 'set'),
    ]
    return rows


def live(only=None):
    cases = 0
    selector, failure = G.signature('set(uint256,uint256)'), G.signature('Denied(uint256,uint256)')
    selected = [row for row in forms() if only is None or row[0] == only]
    require(bool(selected), 'NG-LIVE-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-named-guards-live-') as temporary:
        folder = Path(temporary)
        for name, text, behavior in selected:
            source = folder / f'{name}.asy'
            source.write_text(text)
            runtime, init = P.emit(source, folder / name, name)
            if name == 'invariant':
                E.creation(runtime, init, folder, expected_storage={})
            for index, (argument, b) in enumerate(Q.PAIRS):
                a = 2 if behavior == 'snapshot' else argument
                success = a <= b and a + b <= G.MAX
                low, high = (b - a, a + b) if behavior == 'arithmetic' else (a, b)
                if behavior == 'shadow':
                    low = b
                before = {'0': '0x2', '1': '0x8', '2': '0xabc'}
                row = dict(name=name, calldata=selector + f'{argument:064x}{b:064x}', value=0, before=before,
                    after={**before, '0': hex(low), '1': hex(high)} if success else before,
                    status='success' if success else 'revert',
                    output='0x' + f'{low:064x}' if success else failure + f'{a:064x}{b:064x}')
                H.compare(f'ng-{name}-{index}', source, runtime, row)
                cases += 1
    (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=2 if only is None else 0), indent=2) + '\n')
    print(f'NG-LIVE cases={cases} OK', flush=True)
    return cases


def erasure():
    ordinary = [Q.program(), program(), program('Alias(a, b)', definitions=DEFINITIONS + ALIAS),
                program('both (Below(a, b)) (Room(a, b))'),
                (ROOT / 'examples/NamedGuards.asy').read_text().replace('contract NamedGuards', 'contract CompoundGuards')]
    empty = [Q.program(Q.guard(failure='')), Q.program(Q.guard(condition='Bounds(a, b)', failure=''), definitions=DEFINITIONS)]
    nullary = [Q.program(Q.guard(failure='Halt ()'), errors='error Halt ()\n'),
               Q.program(Q.guard(condition='Bounds(a, b)', failure='Halt ()'),
                         definitions=DEFINITIONS, errors='error Halt ()\n'),
               Q.program(Q.guard(condition='Bounds(a, b)', failure='Halt'),
                         definitions=DEFINITIONS, errors='error Halt ()\n')]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-named-guards-erasure-') as temporary:
        folder = Path(temporary)
        for group, texts in enumerate((ordinary, empty, nullary)):
            outputs = []
            for index, text in enumerate(texts):
                source, output = folder / f'{group}-{index}.asy', folder / f'{group}-{index}'
                source.write_text(text)
                P.emit(source, output, f'erasure-{group}-{index}')
                outputs.append(H.outputs(output))
            differences = [(i, name) for i, row in enumerate(outputs) for name in row if row[name] != outputs[0].get(name)]
            require(not differences and all(row.keys() == outputs[0].keys() for row in outputs),
                    f'NG-ERASURE five files group={group} differences={differences}')
            captures.append([{name: hashlib.sha256(data).hexdigest() for name, data in row.items()} for row in outputs])
    (WORK / 'ERASURE.json').write_text(json.dumps(captures, indent=2) + '\n')
    count = sum(map(len, captures))
    print(f'NG-ERASURE variants={count} groups={len(captures)} OK', flush=True)
    return count


def wide(leaves):
    claim = Q.tree(leaves)[0]
    return f'predicate Wide (0 a : Word) (0 b : Word) : Prop := {claim}\n', claim


def chain():
    rows = ['predicate Chain0 (0 a : Word) (0 b : Word) : Prop := Le a b\n']
    rows += [f'predicate Chain{i} (0 a : Word) (0 b : Word) : Prop := Chain{i - 1}(a, b)\n' for i in range(1, 32)]
    return ''.join(rows)


def negative_cases():
    unused = BOUND.replace('(0 y : Word)', '(0 y : Word) (0 unused : Word)')
    large, large_claim = wide(65)
    half, half_claim = wide(40)
    shadow = 'let Bounds : Word := a ; ' + Q.BEFORE
    return [
        ('unknown', program('Missing(a, b)'), 'SURFACE_PREDICATE'),
        ('arity-small', program('Bounds(a)'), 'SURFACE_PREDICATE'),
        ('arity-large', program('Bounds(a, b, a)'), 'SURFACE_PREDICATE'),
        ('unknown-word', program('Bounds(a, missing)'), 'SURFACE_SCOPE'),
        ('unused-word', program('Bounds(a, b, missing)', definitions=unused), 'SURFACE_SCOPE'),
        ('proof-argument', program('Bounds(a, b, p)', definitions=unused,
            before='let (0 p : Le (word 0) (word 0)) := () ; ' + Q.BEFORE), 'SURFACE_PROOF'),
        ('word-shadow', program(before=shadow), 'SURFACE_PREDICATE'),
        ('proof-shadow', program(before='let (0 Bounds : Le (word 0) (word 0)) := () ; ' + Q.BEFORE), 'SURFACE_PREDICATE'),
        ('argument-order', program('Bounds(b, a)'), 'mismatch'),
        ('annotation', program(claim=Q.CLAIM.replace('Le a b', 'Le b a')), 'mismatch'),
        ('unused-annotation', program(claim=Q.CLAIM.replace('add a b', 'add a a'), tail='pure a'), 'mismatch'),
        ('shape', program(claim='Le a b'), 'SURFACE_PROOF'),
        ('false-proof', program(tail=f'let (0 unused : {B.FALSE}) := () ; pure a'), 'mismatch'),
        ('stale-proof', program(tail='a <- sload low ; let total : Word := addLt a b second(bounds) ; pure total'), 'mismatch'),
        ('stale-invariant', program(definitions=DEFINITIONS + I.DECL,
            tail=Q.STORES.replace('pure a', 'sstore high (word 0) ; pure a')), 'mismatch'),
        ('forward-definition', program(definitions=ALIAS + DEFINITIONS), 'SURFACE_PREDICATE'),
        ('recursive-definition', program(definitions=BOUND.split(':=', 1)[0] + ':= Bounds(x, y)\n'),
         'SURFACE_PREDICATE'),
        ('free-definition', program(definitions=BOUND.replace('Le x y', 'Le x missing')), 'SURFACE_SCOPE'),
        ('missing-close', program('Bounds(a, b'), 'SURFACE_SYNTAX'),
        ('extra-comma', program('Bounds(a, b,)'), 'SURFACE_NAME'),
        ('computation-argument', program('Bounds(add a b, b)'), 'SURFACE_NAME'),
        ('expanded-bounds', program('Wide(a, b)', large_claim, definitions=large), 'SURFACE_LIMIT'),
        ('aggregate-bounds', program('both (Wide(a, b)) (Wide(a, b))',
            f'Both ({half_claim}) ({half_claim})', definitions=half), 'SURFACE_LIMIT'),
        ('alias-depth', program('both (Chain31(a, b)) (leWord a b)',
            'Both (Le a b) (Le a b)', definitions=chain()), 'SURFACE_LIMIT'),
        ('payload-arity', Q.program(Q.guard(condition='Bounds(a, b)', failure='Denied (a)'), definitions=DEFINITIONS), 'SURFACE_ERROR'),
        ('payload-empty', Q.program(Q.guard(condition='Bounds(a, b)', failure='Denied () (a) (b)'), definitions=DEFINITIONS), 'SURFACE_ERROR'),
        ('unknown-error', Q.program(Q.guard(condition='Bounds(a, b)', failure='Missing (a) (b)'), definitions=DEFINITIONS), 'SURFACE_ERROR'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'NG-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-named-guards-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('ng-' + name, text, marker, Path(temporary))
    print(f'NG-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    large, large_claim = wide(64)
    parameters = ' '.join(f'(0 x{i} : Word)' for i in range(16))
    definition = f'predicate Many {parameters} : Prop := Le x0 x15\n'
    texts = [program('Wide(a, b)', large_claim, definitions=large),
             program('Chain31(a, b)', 'Le a b', definitions=chain()),
             program('Many(' + ', '.join(['a'] * 15 + ['b']) + ')', 'Le a b', definitions=definition),
             program('Ready()', 'Le (word 0) (word 0)', definitions=READY),
             program('both()', 'Le (word 0) (word 0)', definitions=READY.replace('Ready', 'both')),
             program('Bounds(((a)), (b))')]
    with tempfile.TemporaryDirectory(prefix='assay-named-guards-boundaries-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(texts):
            source = folder / f'boundary-{index}.asy'
            source.write_text(text)
            P.emit(source, folder / str(index), f'boundary-{index}')
    print(f'NG-BOUNDARIES accepted={len(texts)} OK', flush=True)
    return len(texts)


def witness(name):
    return live(name) if name == 'named' else refusals(name)


def mutants():
    cases = [
        ('ARGUMENT-ORDER', 'arguments [] row.words args', 'arguments [] row.words (List.rev args)',
         'named', 'M1-TOOL named'),
        ('SHADOW', 'if List.mem_assoc at.text env then fail at "PREDICATE" "a local binding shadows this predicate" else',
         'if false then fail at "PREDICATE" "a local binding shadows this predicate" else',
         'word-shadow', 'ERROR-REFUSAL ng-word-shadow'),
        ('EXPANDED-BOUNDS', 'if depth > 32 || remaining = 0 then\n      fail at "LIMIT" "expanded guard condition',
         'if depth > 32 || remaining = min_int then\n      fail at "LIMIT" "expanded guard condition',
         'expanded-bounds', 'ERROR-REFUSAL ng-expanded-bounds'),
        ('SHARED-BUDGET', 'let* remaining = budget (depth + 1) remaining a in budget (depth + 1) remaining b',
         'let* _remaining = budget (depth + 1) remaining a in budget (depth + 1) 64 b',
         'aggregate-bounds', 'ERROR-REFUSAL ng-aggregate-bounds'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-named-guards-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'NG-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'NG-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/named-guard-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'NG-MUTANT ' + label)
            print('NG-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = {'live': live, 'refusals': refusals, 'erasure': erasure, 'boundaries': boundaries, 'mutants': mutants}
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/named-guard-test.py [live|refusals|erasure|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, erased = live(), erasure()
        invalid, accepted, killed = refusals(), boundaries(), mutants()
        print(f'NAMED-GUARDS cases={cases} creates=2 refusals={invalid} erasure={erased} boundaries={accepted} mutants={killed} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        print('NAMED-GUARDS-FAIL ' + str(exc))
        sys.exit(1)

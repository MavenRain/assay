#!/usr/bin/env python3
"""Check compound guards, erased evidence and Cancun rollback behavior."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/compound-guards'
spec = importlib.util.spec_from_file_location('guard_invariants', ROOT / 'dev/compound-invariant-test.py')
I = importlib.util.module_from_spec(spec)
spec.loader.exec_module(I)
N, B, H, T, G, E, M, P, C, require = I.N, I.B, I.H, I.T, I.G, I.E, I.M, I.P, I.C, I.require
CLAIM = 'Both (Le a b) (Lt256 (add a b))'
CONDITION = 'both (leWord a b) (lt256 (add a b))'
ERROR = 'error Denied (left : Word) (right : Word)\n'
BEFORE = 'sstore low (word 9) ; '
STORES = 'sstore low a ; sstore high b ; pure a'
PAIRS = [(0, 0), (4, 9), (9, 4), (0, G.MAX), (1, G.MAX), (G.MAX, G.MAX),
         (1, G.MAX - 1), (G.MAX // 2, G.MAX // 2 + 1)]


def guard(claim=CLAIM, condition=CONDITION, failure='Denied (a) (b)', name='bounds'):
    return f'(0 {name} : {claim}) <- guard {failure} ({condition}) ; '


def program(binding=None, *, definitions='', before=BEFORE, tail=STORES, errors=ERROR):
    return ('contract CompoundGuards where storage State := { low : Word ; high : Word }\n' +
            errors + definitions + 'entry set (a : Word) (b : Word) : Eff Sig Word := do ' +
            before + (guard() if binding is None else binding) + tail + '\n')


def forms():
    right = guard(f'Both (Le a b) ({CLAIM})', f'both (leWord a b) ({CONDITION})')
    left = guard(f'Both ({CLAIM}) (Le a b)', f'both ({CONDITION}) (leWord a b)')
    arithmetic = ('let d : Word := subLe b a first(bounds) ; '
                  'let total : Word := addLt a b second(bounds) ; '
                  'sstore low d ; sstore high total ; pure d')
    return [
        ('plain', program(guard(failure='')), 'empty', 'set'),
        ('custom', program(), 'Denied(uint256,uint256)', 'set'),
        ('invariant', (ROOT / 'examples/CompoundGuards.asy').read_text(), 'Denied(uint256,uint256)', 'set'),
        ('nullary', program(guard(failure='Halt ()'), errors='error Halt ()\n'), 'Halt()', 'set'),
        ('contextual', program(guard(failure='Denied (both) (b)'),
                               before='let both : Word := a ; ' + BEFORE), 'Denied(uint256,uint256)', 'set'),
        ('error-name', program(guard(failure='both (a) (b)'), errors=ERROR.replace('Denied', 'both')),
         'both(uint256,uint256)', 'set'),
        ('nested-right', program(right), 'Denied(uint256,uint256)', 'set'),
        ('nested-left', program(left), 'Denied(uint256,uint256)', 'set'),
        ('projections', program(tail=arithmetic), 'Denied(uint256,uint256)', 'arithmetic'),
        ('snapshot', program(before='a <- sload low ; ' + BEFORE), 'Denied(uint256,uint256)', 'snapshot'),
        ('binder-shadow', program(guard(name='a'), tail='sstore low b ; sstore high b ; pure b'),
         'Denied(uint256,uint256)', 'shadow'),
    ]


def live(only=None):
    cases = 0
    selector = G.signature('set(uint256,uint256)')
    selected = [row for row in forms() if only is None or row[0] == only]
    require(bool(selected), 'CG-LIVE-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-compound-guards-live-') as temporary:
        folder = Path(temporary)
        for name, text, error, behavior in selected:
            source = folder / f'{name}.asy'
            source.write_text(text)
            runtime, init = P.emit(source, folder / name, name)
            if name == 'invariant':
                E.creation(runtime, init, folder, expected_storage={})
            failure = '0x' if error == 'empty' else G.signature(error)
            for index, (argument, b) in enumerate(PAIRS):
                a = 2 if behavior == 'snapshot' else argument
                success = a <= b and a + b <= G.MAX
                low, high = (b - a, a + b) if behavior == 'arithmetic' else (a, b)
                if behavior == 'shadow':
                    low = b
                before = {'0': '0x2', '1': '0x8', '2': '0xabc'}
                output = '0x' + f'{low:064x}' if success else failure
                if not success and error.endswith('uint256,uint256)'):
                    output += f'{a:064x}{b:064x}'
                row = dict(name=name, calldata=selector + f'{argument:064x}{b:064x}', value=0, before=before,
                           after={**before, '0': hex(low), '1': hex(high)} if success else before,
                           status='success' if success else 'revert', output=output)
                H.compare(f'cg-{name}-{index}', source, runtime, row)
                cases += 1
    (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=2 if only is None else 0), indent=2) + '\n')
    print(f'CG-LIVE cases={cases} OK', flush=True)
    return cases


def erasure():
    sequential = guard('Le a b', 'leWord a b', name='p') + guard('Lt256 (add a b)', 'lt256 (add a b)', name='q')
    named = program(guard('Bounds(a, b)'), definitions=I.NAMED + I.DECL.replace(I.CLAIM, 'Bounds(s.low, s.high)'))
    alias = program(tail=f'let (0 kept : {CLAIM}) := pair(first(bounds), second(bounds)) ; ' + STORES)
    right_claim, right_condition = f'Both (Le a b) ({CLAIM})', f'both (leWord a b) ({CONDITION})'
    groups = [[program(sequential), program(), named, alias, (ROOT / 'examples/CompoundGuards.asy').read_text()],
              [program(guard(right_claim, right_condition)),
               program(guard('Le a b', 'leWord a b', name='extra') + sequential)]]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-compound-guards-erasure-') as temporary:
        folder = Path(temporary)
        for group, texts in enumerate(groups):
            outputs = []
            for index, text in enumerate(texts):
                source, output = folder / f'{group}-{index}.asy', folder / f'{group}-{index}'
                source.write_text(text)
                P.emit(source, output, f'erasure-{group}-{index}')
                outputs.append(H.outputs(output))
            require(all(row == outputs[0] for row in outputs), 'CG-ERASURE five files')
            captures.append([{name: hashlib.sha256(data).hexdigest() for name, data in row.items()} for row in outputs])
    (WORK / 'ERASURE.json').write_text(json.dumps(captures, indent=2) + '\n')
    count = sum(map(len, captures))
    print(f'CG-ERASURE variants={count} groups={len(groups)} OK', flush=True)
    return count


def tree(leaves):
    if leaves == 1:
        return 'Le a b', 'leWord a b'
    left, right = tree(leaves // 2), tree(leaves - leaves // 2)
    return f'Both ({left[0]}) ({right[0]})', f'both ({left[1]}) ({right[1]})'


def nested(depth):
    claim, condition = 'Le a b', 'leWord a b'
    for _ in range(depth):
        claim, condition = f'Both (Le a b) ({claim})', f'both (leWord a b) ({condition})'
    return claim, condition


def negative_cases():
    return [
        ('atomic-shape', program(guard('Le a b')), 'SURFACE_PROOF'),
        ('bundle-shape', program(guard(condition='leWord a b')), 'SURFACE_PROOF'),
        ('nested-shape', program(guard(condition=f'both ({CONDITION}) (leWord a b)')), 'SURFACE_PROOF'),
        ('first-mismatch', program(guard(CLAIM.replace('Le a b', 'Le b a'))), 'mismatch'),
        ('second-mismatch', program(guard(condition=CONDITION.replace('add a b', 'add a a'))), 'mismatch'),
        ('swapped-checks', program(guard(condition='both (lt256 (add a b)) (leWord a b)')), 'mismatch'),
        ('unknown-word', program(guard(condition=CONDITION.replace('add a b', 'add a missing'))), 'SURFACE_SCOPE'),
        ('proof-operand', program(guard() + guard(condition=CONDITION.replace('add a b', 'add a bounds'))), 'SURFACE_PROOF'),
        ('proof-return', program(tail='pure bounds'), 'SURFACE_PROOF'),
        ('proof-store', program(tail='sstore low bounds ; pure a'), 'SURFACE_PROOF'),
        ('proof-payload', program(guard() + guard(failure='Denied (bounds) (b)')), 'SURFACE_PROOF'),
        ('stale-word', program(tail='a <- sload low ; let v : Word := addLt a b second(bounds) ; pure v'), 'mismatch'),
        ('stale-invariant', program(definitions=I.DECL, tail=STORES.replace('pure a', 'sstore high (word 0) ; pure a')), 'mismatch'),
        ('unused-false-proof', program(tail=f'let (0 unused : {B.FALSE}) := () ; ' + STORES), 'mismatch'),
        ('unknown-error', program(guard(failure='Unknown (a) (b)')), 'SURFACE_ERROR'),
        ('error-arity', program(guard(failure='Denied (a)')), 'SURFACE_ERROR'),
        ('empty-before-value', program(guard(failure='Denied () (a) (b)')), 'SURFACE_ERROR'),
        ('empty-after-value', program(guard(failure='Denied (a) (b) ()')), 'SURFACE_ERROR'),
        ('extra-empty', program(guard(failure='Halt () ()'), errors='error Halt ()\n'), 'SURFACE_ERROR'),
        ('missing-component', program(guard(condition='both (leWord a b)')), 'SURFACE_SYNTAX'),
        ('extra-component', program(guard(condition=CONDITION + ' (leWord a b)')), 'SURFACE_SYNTAX'),
        ('missing-parens', program(guard(condition='both leWord a b (lt256 (add a b))')), 'SURFACE_SYNTAX'),
        ('uppercase-condition', program(guard(condition=CONDITION.replace('both', 'Both'), failure='')), 'SURFACE_PROOF'),
        ('unknown-named-runtime', program(guard(condition='Unknown(a, b)', failure=''), definitions=I.NAMED), 'SURFACE_PREDICATE'),
        ('runtime-depth', program(guard(condition=nested(33)[1])), 'SURFACE_LIMIT'),
        ('runtime-bounds', program(guard(*tree(65))), 'SURFACE_LIMIT'),
    ]


def refusals():
    rows = negative_cases()
    with tempfile.TemporaryDirectory(prefix='assay-compound-guards-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('cg-' + name, text, marker, Path(temporary))
    print(f'CG-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    forms = [program(guard(*nested(32))), program(guard(*tree(64))),
             program(guard('Both (Le a b) (Le b a)', 'both (leWord a b) (leWord b a)')),
             program(guard(f'Both ({B.TRUE}) ({B.FALSE})',
                           'both (leWord (word 0) (word 1)) (leWord (word 1) (word 0))')),
             program(guard(failure='Denied ((both)) (b)'), before='let both : Word := a ; ' + BEFORE),
             program(guard(failure='Halt'), errors='error Halt ()\n'),
             program().replace('high : Word', 'both : Word').replace('sstore high b', 'sstore both b')]
    with tempfile.TemporaryDirectory(prefix='assay-compound-guards-boundaries-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(forms):
            source = folder / f'boundary-{index}.asy'
            source.write_text(text)
            P.emit(source, folder / str(index), f'boundary-{index}')
    print(f'CG-BOUNDARIES accepted={len(forms)} OK', flush=True)
    return len(forms)


def witness(name):
    if name == 'erasure':
        return erasure()
    return live(name)


def mutants():
    order = ('guards a left (local ^ "a") (fun p ->\n'
             '              guards b right (local ^ "b") (fun q ->')
    cases = [
        ('PAIR-ORDER', 'continue ("(tuple (" ^ p ^ ", " ^ q ^ "))")',
         'continue ("(tuple (" ^ q ^ ", " ^ p ^ "))")', 'custom', 'M1-TOOL custom'),
        ('ERROR-PAYLOAD', 'let* no = Option.fold ~none:(Ok "abort") ~some:(reject env) error in',
         'let* _checked_no = Option.fold ~none:(Ok "abort") ~some:(reject env) error in\n        let no = "abort" in',
         'custom', 'MODEL-EXPECTED cg-custom-2'),
        ('COMPONENT-EVIDENCE', '\n          state written (evidence_for fresh ty evidence) rest in',
         '\n          state written evidence rest in', 'invariant', 'M1-TOOL invariant'),
        ('CHECK-ORDER', order,
         'guards b right (local ^ "b") (fun q ->\n              guards a left (local ^ "a") (fun p ->',
         'erasure', 'CG-ERASURE five files'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-compound-guards-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanon-replies', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'CG-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'CG-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/compound-guard-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'CG-MUTANT ' + label)
            print('CG-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = {'live': live, 'refusals': refusals, 'erasure': erasure, 'boundaries': boundaries, 'mutants': mutants}
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/compound-guard-test.py [live|refusals|erasure|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, erased = live(), erasure()
        invalid, accepted, killed = refusals(), boundaries(), mutants()
        print(f'COMPOUND-GUARDS cases={cases} creates=2 refusals={invalid} erasure={erased} boundaries={accepted} mutants={killed} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        print('COMPOUND-GUARDS-FAIL ' + str(exc))
        sys.exit(1)

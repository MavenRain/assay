#!/usr/bin/env python3
"""Check inferred arithmetic proofs, snapshot scope and erased EVM output."""
import hashlib
import importlib.util
import json
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/inferred-arithmetic'
spec = importlib.util.spec_from_file_location('inferred_guards', ROOT / 'dev/inferred-guard-test.py')
IG = importlib.util.module_from_spec(spec)
spec.loader.exec_module(IG)
NG, Q, I, N, B, H, T, G, E, M, P, C, require = (
    IG.NG, IG.Q, IG.I, IG.N, IG.B, IG.H, IG.T, IG.G, IG.E, IG.M, IG.P, IG.C, IG.require)


def omit(text, op, term='p', a='a', b='b'):
    operation = 'addLt' if op == 'add' else 'subLe'
    before = f'{operation} {a} {b} {term}'
    require(before in text, 'IA-FORM missing arithmetic')
    return text.replace(before, f'{operation} {a} {b}')


def forms():
    rows = []
    for op in ('add', 'sub'):
        explicit = G.guarded(op)
        inferred = omit(explicit, op)
        rows.append(('bound-' + op, inferred, explicit, op, 'custom'))
        anonymous = inferred.replace(f'(0 p : {T.claim(op)}) <- ', '')
        rows.append(('anonymous-' + op, anonymous, explicit, op, 'custom'))
        empty = G.guarded(op, errors=False)
        rows.append(('empty-' + op, omit(empty, op), empty, op, 'empty'))
    helper = G.guarded('add').replace('let v : Word',
        'let (0 q : Lt256 (add a b)) := fits(a, b, p) ; let v : Word')
    helper = H.declare(helper, H.FITS).replace('addLt a b p', 'addLt a b q')
    rows.append(('helper', omit(helper, 'add', 'q'), helper, 'add', 'custom'))
    def bundle(name, binding, *, definitions='', first='first(bounds)', second='second(bounds)'):
        explicit = Q.program(binding, definitions=definitions,
            tail=f'let d : Word := subLe b a {first} ; let total : Word := addLt a b {second} ; '
                 'sstore low d ; sstore high total ; pure d')
        inferred = omit(omit(explicit, 'sub', first, 'b', 'a'), 'add', second)
        rows.append((name, inferred, explicit, 'bundle', 'custom'))

    bundle('bundle', Q.guard())
    bundle('named', Q.guard('Bounds(a, b)', 'Bounds(a, b)'), definitions=NG.BOUND)
    bundle('nested', Q.guard(f'Both (Le a b) ({Q.CLAIM})', f'both (leWord a b) ({Q.CONDITION})'),
        first='first(second(bounds))', second='second(second(bounds))')
    bundle('separate', Q.guard('Le a b', 'leWord a b', name='ordered') +
        Q.guard('Lt256 (add a b)', 'lt256 (add a b)', name='fits'), first='ordered', second='fits')
    shadow = G.guarded('add').replace('let v : Word', 'let p : Word := (word 4) ; let v : Word')
    explicit = shadow.replace('(0 p :', '(0 saved :').replace('addLt a b p', 'addLt a b saved')
    rows.append(('proof-shadow', omit(shadow, 'add'), explicit, 'add', 'custom'))
    snapshot = G.guarded('sub').replace('sstore cell (word 9)', 'a <- sload cell ; sstore cell (word 9)')
    rows.append(('snapshot', omit(snapshot, 'sub'), snapshot, 'snapshot', 'custom'))
    for op, a, b in [('add', 2, 3), ('sub', 5, 3)]:
        explicit = T.closed(op, a, b)
        rows.append(('closed-' + op, omit(explicit, op, '()', f'(word {a})', f'(word {b})'),
                     explicit, 'closed-' + op, 'custom'))
    rows.append(('counter', (ROOT / 'examples/InferredArithmetic.asy').read_text(),
        (ROOT / 'examples/CounterProofs.asy').read_text().replace('contract CounterProofs',
            'contract InferredArithmetic'), 'counter', 'custom'))
    return rows


def live(only=None):
    rows = [row for row in forms() if only is None or row[0] == only]
    require(bool(rows), 'IA-LIVE-WITNESS ' + str(only))
    selector, error = G.signature('mix(uint256,uint256)'), G.signature('Denied(uint256,uint256)')
    bundle_selector = G.signature('set(uint256,uint256)')
    cases, creates = 0, 0
    with tempfile.TemporaryDirectory(prefix='assay-inferred-arithmetic-live-') as temporary:
        folder = Path(temporary)
        for name, text, _explicit, behavior, failure in rows:
            source = folder / f'{name}.asy'
            source.write_text(text)
            runtime, init = P.emit(source, folder / name, name)
            if behavior == 'counter':
                E.creation(runtime, init, folder, expected_storage={E.D.RECEIVER: {'1': '0x64'}})
                creates += 2
                continue
            pairs = [(2, 3)] if behavior == 'closed-add' else [(5, 3)] if behavior == 'closed-sub' else G.PAIRS
            for index, (argument, b) in enumerate(pairs):
                a = 7 if behavior == 'snapshot' else argument
                if behavior == 'bundle':
                    success = a <= b and a + b <= G.MAX
                    before = {'0': '0x7', '1': '0x8', '2': '0xabc'}
                    row = dict(name=name, calldata=bundle_selector + f'{argument:064x}{b:064x}', value=0,
                        before=before, after={**before, '0': hex(b - a), '1': hex(a + b)} if success else before,
                        status='success' if success else 'revert',
                        output='0x' + f'{b-a:064x}' if success else error + f'{a:064x}{b:064x}')
                else:
                    op = 'sub' if behavior in ('sub', 'snapshot', 'closed-sub') else 'add'
                    row = G.matrix_row(op, a, b, selector, '0x' if failure == 'empty' else error)
                    row['calldata'] = selector + f'{argument:064x}{b:064x}'
                H.compare(f'ia-{name}-{index}', source, runtime, row)
                cases += 1
    (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=creates), indent=2) + '\n')
    print(f'IA-LIVE cases={cases} creates={creates} OK', flush=True)
    return cases, creates


def erasure():
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-arithmetic-erasure-') as temporary:
        folder = Path(temporary)
        for name, inferred, explicit, _behavior, _failure in forms():
            outputs = []
            for index, text in enumerate((inferred, explicit)):
                source, output = folder / f'{name}-{index}.asy', folder / f'{name}-{index}'
                source.write_text(text)
                P.emit(source, output, f'erasure-{name}-{index}')
                outputs.append(H.outputs(output))
            require(outputs[0] == outputs[1] and len(outputs[0]) == 5, 'IA-ERASURE five files ' + name)
            captures.append(dict(name=name, variants=[{file: hashlib.sha256(data).hexdigest()
                for file, data in output.items()} for output in outputs]))
    (WORK / 'ERASURE.json').write_text(json.dumps(captures, indent=2) + '\n')
    print(f'IA-ERASURE pairs={len(captures)} files=5 OK', flush=True)
    return len(captures)


def negative_cases():
    add, sub = omit(G.guarded('add'), 'add'), omit(G.guarded('sub'), 'sub')
    rows = [
        ('no-add-proof', G.program('let v : Word := addLt a b ; pure v'), 'mismatch'),
        ('no-sub-proof', G.program('let v : Word := subLe a b ; pure v'), 'mismatch'),
        ('unused-result', G.program('let v : Word := addLt a b ; pure a'), 'mismatch'),
        ('reverting-tail', G.program('let v : Word := subLe a b ; revert'), 'mismatch'),
        ('wrong-order', sub.replace('Le b a', 'Le a b').replace('leWord b a', 'leWord a b'), 'mismatch'),
        ('different-operands', add.replace('addLt a b', 'addLt a a'), 'mismatch'),
        ('different-kind', add.replace('addLt a b', 'subLe a b'), 'mismatch'),
        ('legacy-guard', G.program('guard le b a ; let v : Word := subLe a b ; pure v'), 'mismatch'),
        ('rebound-word', add.replace('let v : Word', 'let a : Word := (word 1) ; let v : Word'), 'mismatch'),
        ('reloaded-word', add.replace('let v : Word', 'a <- sload cell ; let v : Word'), 'mismatch'),
        ('new-result', add.replace('let v : Word', 'a <- add a b ; let v : Word'), 'mismatch'),
        ('alias-search', add.replace('let v : Word', 'let alias : Word := a ; let v : Word')
            .replace('addLt a b', 'addLt alias b'), 'mismatch'),
        ('explicit-invalid', G.guarded('add').replace('addLt a b p', 'addLt a b ()'), 'mismatch'),
        ('explicit-unknown', G.guarded('add').replace('addLt a b p', 'addLt a b missing'), 'SURFACE_PROOF'),
        ('false-binding', add.replace('let v : Word',
            'let (0 unused : Le (word 1) (word 0)) := () ; let v : Word'), 'mismatch'),
        ('overflow', T.closed('add', G.MAX, 1, term=''), 'mismatch'),
        ('underflow', T.closed('sub', 0, 1, term=''), 'mismatch'),
        ('unknown-word', add.replace('addLt a b', 'addLt missing b'), 'SURFACE_SCOPE'),
        ('proof-as-word', add.replace('addLt a b', 'addLt p b'), 'SURFACE_PROOF'),
        ('missing-operand', add.replace('addLt a b', 'addLt a'), 'SURFACE_NAME'),
        ('missing-semicolon', add.replace('addLt a b ;', 'addLt a b'), 'SURFACE'),
        ('constructor', add + 'constructor := do let v : Word := addLt (word 1) (word 2) ; pure ()\n',
         'SURFACE_CONSTRUCTOR'),
        ('future-proof', G.program('let v : Word := addLt a b ; '
            'guard (lt256 (add a b)) ; pure v'), 'mismatch'),
        ('entry-scope', add + 'entry other (a : Word) (b : Word) : Eff Sig Word := do '
            'let v : Word := addLt a b ; pure v\n', 'mismatch'),
    ]
    return rows


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'IA-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-inferred-arithmetic-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('ia-' + name, text, marker, Path(temporary))
    print(f'IA-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def witness(name):
    return refusals(name) if name == 'explicit-invalid' else live(name)


def mutants():
    cases = native_mutations.load(__file__)
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-arithmetic-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        path = copy / 'src/emitter.bend'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(native_mutations.count(original, before) == 1, 'IA-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'IA-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/inferred-arithmetic-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'IA-MUTANT ' + label)
                captures.append(dict(name=label, witness=case, expected_marker=marker,
                    returncode=result.returncode, source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('IA-MUTANT ' + name + ' killed control=OK', flush=True)
    (WORK / 'MUTANTS.json').write_text(json.dumps(captures, indent=2) + '\n')
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=live, erasure=erasure, refusals=refusals, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/inferred-arithmetic-test.py [live|erasure|refusals|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (IG, NG, Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, creates = live()
        erased, invalid, killed = erasure(), refusals(), mutants()
        print(f'INFERRED-ARITHMETIC cases={cases} creates={creates} refusals={invalid} '
              f'erasure_pairs={erased} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (RuntimeError, OSError, ValueError) as error:
        print('INFERRED-ARITHMETIC FAIL ' + str(error), flush=True)
        sys.exit(1)

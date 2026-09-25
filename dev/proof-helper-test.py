#!/usr/bin/env python3
"""Check reusable proof helpers, erasure, scope and arithmetic against Cancun."""
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
WORK = ROOT / '.gatework/proof-helpers'
spec = importlib.util.spec_from_file_location('helper_terms', ROOT / 'dev/proof-term-test.py')
T = importlib.util.module_from_spec(spec)
spec.loader.exec_module(T)
G, E, M, P, C, require = T.G, T.E, T.M, T.P, T.C, T.require
MAX = G.MAX
ORDER = 'proof ordered (0 x : Word) (0 y : Word) (0 q : Le x y) : Le x y := q\n'
FITS = 'proof fits (0 x : Word) (0 y : Word) (0 q : Lt256 (add x y)) : Lt256 (add x y) := q\n'
CLOSED = 'proof five : Lt256 (add (word 2) (word 3)) := ()\n'
TRUE = 'Le (word 0) (word 1)'


def declare(source, helpers):
    return source.replace('entry ', helpers + 'entry ', 1)


def guarded(op='sub', term=None):
    default = 'ordered(b, a, p)' if op == 'sub' else 'fits(a, b, p)'
    operation = 'subLe' if op == 'sub' else 'addLt'
    return declare(G.guarded(op).replace(operation + ' a b p', operation + ' a b ' + (term or default)),
                   ORDER if op == 'sub' else FITS)


def closed(helpers=CLOSED, term='five()'):
    return declare(T.closed(term=term), helpers)


def compare(name, source, runtime, row):
    M.model(name, source, row)
    P.execute(name, runtime, row)


def outputs(folder):
    return {p.name: p.read_bytes() for p in folder.iterdir()}


def live():
    count, erased = 0, 0
    selector, error = G.signature('mix(uint256,uint256)'), G.signature('Denied(uint256,uint256)')
    with tempfile.TemporaryDirectory(prefix='assay-helper-live-') as temporary:
        folder = Path(temporary)
        for op in ('add', 'sub'):
            base = folder / (op + '-base.asy')
            base.write_text(G.guarded(op))
            P.emit(base, folder / (op + '-base'), op + '-base')
            helper, args, ty = ('fits', 'a, b', 'Lt256 (add x y)') if op == 'add' else ('ordered', 'b, a', 'Le x y')
            relay = f'proof relay (0 x : Word) (0 y : Word) (0 p : {ty}) : {ty} := {helper}(x, y, (let (0 p : {ty}) := p in p))\n'
            variants = [guarded(op), guarded(op, f'{helper}({args}, {helper}({args}, p))'),
                        declare(guarded(op, f'relay({args}, p)'), relay)]
            for index, text in enumerate(variants):
                label = f'{op}-{index}'
                source = folder / (label + '.asy')
                source.write_text(text)
                runtime, _init = P.emit(source, folder / label, label)
                require(outputs(folder / label) == outputs(folder / (op + '-base')), 'HELPER-ERASURE ' + label)
                erased += 1
                for a, b in G.PAIRS:
                    compare(f'{label}-{count}', source, runtime, G.matrix_row(op, a, b, selector, error))
                    count += 1
        source = ROOT / 'examples/ProofHelpers.asy'
        runtime, init = P.emit(source, folder / 'example', 'example')
        E.creation(runtime, init, folder)
        for op, name in [('sub', 'subtract'), ('add', 'combine')]:
            entry = G.signature(name + '(uint256,uint256)')
            for a, b in G.PAIRS:
                compare(f'example-{count}', source, runtime, G.matrix_row(op, a, b, entry, error))
                count += 1
        compare('example-closed', source, runtime, P.row('closed', G.signature('closed()'), 5, after='0x5'))
        count += 1
        example = outputs(folder / 'example')
        abi = json.loads(example['abi.json'])
        functions = {row['name']: len(row['inputs']) for row in abi if row['type'] == 'function'}
        require(functions == {'closed': 0, 'subtract': 2, 'combine': 2}, 'HELPER-ABI')

        invariant = ('contract Bounds where storage State := { cell : Word ; cap : Word }\n'
                     'invariant bounded (s : State) : Prop := Le s.cell s.cap\n' + ORDER +
                     'entry set (a : Word) : Eff Sig Word := do bound <- sload cap ; '
                     '(0 p : Le a bound) <- guard (leWord a bound) ; '
                     'let (0 q : Le a bound) := ordered(a, bound, p) ; sstore cell a ; pure a\n'
                     'constructor := do sstore cap (word 100) ; pure ()')
        source = folder / 'invariant.asy'
        source.write_text(invariant)
        invariant_runtime, _init = P.emit(source, folder / 'invariant', 'invariant')
        for value in (0, 99, 100, 101, MAX):
            state = {'0': '0x7', '1': '0x64', '2': '0xabc'}
            row = dict(name='invariant', calldata=G.signature('set(uint256)') + f'{value:064x}', value=0,
                       before=state, after={**state, '0': hex(value)} if value <= 100 else state,
                       status='success' if value <= 100 else 'revert',
                       output='0x' + f'{value:064x}' if value <= 100 else '0x')
            compare(f'invariant-{value}', source, invariant_runtime, row)
            count += 1

        snapshot = guarded().replace('sstore cell (word 9) ;', 'old <- sload cell ; sstore cell a ;')
        snapshot = snapshot.replace('Le b a', 'Le b old').replace('leWord b a', 'leWord b old')
        snapshot = snapshot.replace('Denied (a) (b)', 'Denied (old) (b)')
        snapshot = snapshot.replace('subLe a b ordered(b, a, p)', 'subLe old b ordered(b, old, p)')
        snapshot = snapshot.replace('sstore cell v ; pure v', 'pure v')
        source = folder / 'snapshot.asy'
        source.write_text(snapshot)
        snapshot_runtime, _init = P.emit(source, folder / 'snapshot', 'snapshot')
        for b in (4, 8):
            row = P.row('snapshot', selector + f'{1:064x}{b:064x}', 7 - b if b <= 7 else 0,
                        after='0x1' if b <= 7 else '0x7', status='success' if b <= 7 else 'revert')
            if b > 7:
                row['output'] = error + f'{7:064x}{b:064x}'
            compare(f'snapshot-{b}', source, snapshot_runtime, row)
            count += 1
        (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=count, creates=2, guarded_erasure=erased,
            runtime_bytes=len(runtime) // 2, init_bytes=len(init) // 2,
            files={name: hashlib.sha256(data).hexdigest() for name, data in example.items()}), indent=2) + '\n')
    print(f'HELPER-LIVE cases={count} creates=2 guarded_erasure={erased} OK', flush=True)
    return count


def boundaries():
    parameters = ' '.join(f'(0 x{i} : Word)' for i in range(16))
    maximum = f'proof many {parameters} : {TRUE} := ()\n'
    members = ''.join(f'proof h{i} : {TRUE} := ()\n' for i in range(32))
    echo = f'proof echo (0 p : {TRUE}) : {TRUE} := p\n'
    base = G.program('pure a')
    return [declare(base, maximum), declare(base, members),
            declare(G.program(f'let (0 p : {TRUE}) := many(' + ', '.join(['word 0'] * 16) + ') ; pure a'), maximum),
            declare(G.program(f'let (0 p : {TRUE}) := ' + 'echo(' * 128 + '()' + ')' * 128 + ' ; pure a'), echo)]


def negative_cases():
    good = guarded()
    false = 'proof bad : Le (word 1) (word 0) := ()\n'
    false_local = f'proof bad : {TRUE} := (let (0 p : Le (word 1) (word 0)) := () in ())\n'
    no_args = closed()
    many, members, call, nested = boundaries()
    return [
        ('unused-false', declare(G.program('pure a'), false), 'mismatch'),
        ('unused-overflow', declare(G.program('pure a'), f'proof bad : Lt256 (add (word {MAX}) (word 1)) := ()\n'), 'mismatch'),
        ('unused-local', declare(G.program('pure a'), false_local), 'mismatch'),
        ('symbolic-body', good.replace(':= q\n', ':= ()\n'), 'mismatch'),
        ('wrong-result', good.replace(': Le x y := q', ': Le y x := q'), 'mismatch'),
        ('argument-claim', good.replace('ordered(b, a, p)', 'ordered(a, b, p)'), 'mismatch'),
        ('argument-unit', good.replace('ordered(b, a, p)', 'ordered(b, a, ())'), 'mismatch'),
        ('unused-argument', declare(T.closed(), 'proof ignore (0 p : Le (word 1) (word 0)) : Lt256 (add (word 2) (word 3)) := ()\n').replace('3) ()', '3) ignore(())'), 'mismatch'),
        ('argument-word', good.replace('ordered(b, a, p)', 'ordered(b, a, a)'), 'SURFACE_PROOF'),
        ('word-proof', good.replace('ordered(b, a, p)', 'ordered(p, a, p)'), 'SURFACE_PROOF'),
        ('word-expression', good.replace('ordered(b, a, p)', 'ordered((), a, p)'), 'SURFACE_PROOF'),
        ('missing-argument', good.replace('ordered(b, a, p)', 'ordered(b)'), 'SURFACE_PROOF'),
        ('extra-argument', good.replace('ordered(b, a, p)', 'ordered(b, a, p, p)'), 'SURFACE_PROOF'),
        ('empty-arguments', good.replace('ordered(b, a, p)', 'ordered()'), 'SURFACE_PROOF'),
        ('constant-argument', no_args.replace('five()', 'five(())'), 'SURFACE_PROOF'),
        ('not-applied', no_args.replace('five()', 'five'), 'SURFACE_PROOF'),
        ('unknown', good.replace('ordered(b, a, p)', 'missing(b, a, p)'), 'SURFACE_PROOF'),
        ('recursive', good.replace(':= q\n', ':= ordered(x, y, q)\n'), 'SURFACE_PROOF'),
        ('forward-helper', declare(G.program('pure a'), f'proof first : {TRUE} := later()\nproof later : {TRUE} := ()\n'), 'SURFACE_PROOF'),
        ('helper-scope', good.replace(':= q\n', ':= p\n'), 'SURFACE_PROOF'),
        ('parameter-scope', good.replace('(0 y : Word) (0 q : Le x y)', '(0 q : Le x y) (0 y : Word)'), 'SURFACE_SCOPE'),
        ('duplicate-parameter', good.replace('(0 y : Word)', '(0 x : Word)'), 'SURFACE_DUPLICATE'),
        ('duplicate-helper', declare(good, ORDER), 'SURFACE_DUPLICATE'),
        ('global-entry', good.replace('proof ordered', 'proof mix'), 'SURFACE_DUPLICATE'),
        ('global-field', good.replace('proof ordered', 'proof cell'), 'SURFACE_DUPLICATE'),
        ('global-argument', good.replace('proof ordered', 'proof a'), 'SURFACE_DUPLICATE'),
        ('word-shadow', good.replace('let v : Word', 'let ordered : Word := a ; let v : Word'), 'SURFACE_PROOF'),
        ('proof-shadow', good.replace('let v : Word', 'let (0 ordered : Le b a) := p ; let v : Word'), 'SURFACE_PROOF'),
        ('reload', good.replace('let v : Word', 'a <- sload cell ; let v : Word'), 'mismatch'),
        ('escaped-local', good.replace('ordered(b, a, p)', 'ordered(b, a, (let (0 q : Le b a) := p in q))').replace('pure v', 'let (0 r : Le b a) := q ; pure v'), 'SURFACE_PROOF'),
        ('runtime-helper', good.replace('pure v', 'pure ordered'), 'SURFACE_SCOPE'),
        ('runtime-call', good.replace('pure v', 'pure ordered(b, a, p)'), 'SURFACE_DECLARATION'),
        ('word-body', good.replace(':= q\n', ':= x\n'), 'SURFACE_PROOF'),
        ('literal-proof', no_args.replace('five()', 'word 0'), 'SURFACE_PROOF'),
        ('word-quantity', good.replace('(0 x : Word)', '(x : Word)'), 'SURFACE_SYNTAX'),
        ('proof-quantity', good.replace('(0 q : Le x y)', '(1 q : Le x y)'), 'SURFACE_SYNTAX'),
        ('reserved-helper', good.replace('proof ordered', 'proof proof'), 'SURFACE_NAME'),
        ('reserved-field', good.replace('cell : Word', 'proof : Word'), 'SURFACE_NAME'),
        ('reserved-entry', good.replace('entry mix', 'entry proof'), 'SURFACE_NAME'),
        ('reserved-argument', good.replace('entry mix (a : Word)', 'entry mix (proof : Word)'), 'SURFACE_NAME'),
        ('reserved-error', good.replace('error Denied', 'error proof'), 'SURFACE_NAME'),
        ('reserved-parameter', good.replace('(0 x : Word)', '(0 proof : Word)'), 'SURFACE_NAME'),
        ('parameters', many.replace('(0 x15 : Word)', '(0 x15 : Word) (0 x16 : Word)'), 'SURFACE_LIMIT'),
        ('helpers', declare(members, f'proof h32 : {TRUE} := ()\n'), 'SURFACE_LIMIT'),
        ('arguments', call.replace('many(word 0,', 'many(word 0, word 0,'), 'SURFACE_LIMIT'),
        ('nesting', nested.replace(':= echo(', ':= echo(echo(', 1).replace(' ; pure a', ') ; pure a'), 'SURFACE_LIMIT'),
        ('trailing-comma', good.replace('ordered(b, a, p)', 'ordered(b, a, p,)'), 'SURFACE_SYNTAX'),
        ('missing-comma', good.replace('ordered(b, a, p)', 'ordered(b a, p)'), 'SURFACE_SYNTAX'),
        ('stray-comma', G.program('pure a ,'), 'SURFACE_DECLARATION'),
        ('constructor', good + 'constructor := do let (0 p : Le (word 0) (word 1)) := () ; pure ()', 'SURFACE_CONSTRUCTOR'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'HELPER-WITNESS unknown ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-helper-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal(name, text, marker, Path(temporary))
    print(f'HELPER-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def erasure():
    variants = [T.closed(), closed(), closed(FITS, 'fits(word 2, word 3, ())'),
                closed(CLOSED + 'proof relay : Lt256 (add (word 2) (word 3)) := five()\n', 'relay()'),
                closed(term='(let (0 p : Lt256 (add (word 2) (word 3))) := five() in p)'),
                declare(T.closed(), ORDER),
                closed(CLOSED + 'proof unused : Le (word 0) (word 1) := ()\n')]
    all_outputs = []
    with tempfile.TemporaryDirectory(prefix='assay-helper-erasure-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(variants):
            source = folder / f'{index}.asy'
            source.write_text(text)
            runtime, _init = P.emit(source, folder / str(index), f'erasure-{index}')
            all_outputs.append(outputs(folder / str(index)))
            compare(f'erasure-run-{index}', source, runtime,
                    P.row('closed', G.signature('mix(uint256,uint256)') + '0' * 128, 5, after='0x5'))
        require(all(out == all_outputs[0] for out in all_outputs), 'HELPER-ERASURE closed five files')
        extras = boundaries() + [
            G.program('let v : Word := subLe (word 9) (word 4) ordered(word 4, word 9, ()) ; pure v') + ORDER,
            declare(T.closed(term='interleaved(word 2, (), word 3, ())'),
                    'proof interleaved (0 x : Word) (0 p : Le x (word 10)) (0 y : Word) '
                    '(0 q : Lt256 (add x y)) : Lt256 (add x y) := q\n')]
        for index, text in enumerate(extras):
            source = folder / f'boundary-{index}.asy'
            source.write_text(text)
            P.emit(source, folder / f'boundary-{index}', f'boundary-{index}')
        (WORK / 'ERASURE.json').write_text(json.dumps(dict(variants=len(variants), boundaries=len(extras),
            files={name: hashlib.sha256(data).hexdigest() for name, data in all_outputs[0].items()}), indent=2) + '\n')
    print(f'HELPER-ERASURE variants={len(variants)} five_files=5 boundaries={len(extras)} OK', flush=True)
    return len(variants)


def witness(name):
    if name != 'apply-order':
        return refusals(name)
    with tempfile.TemporaryDirectory(prefix='assay-helper-order-') as temporary:
        folder = Path(temporary)
        source = folder / 'order.asy'
        source.write_text(guarded())
        runtime, _init = P.emit(source, folder / 'out', 'apply-order')
        compare('apply-order', source, runtime,
                G.matrix_row('sub', 9, 4, G.signature('mix(uint256,uint256)'), G.signature('Denied(uint256,uint256)')))


def mutants():
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-helper-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        path = copy / 'src/emitter.bend'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(native_mutations.count(original, before) == 1, 'HELPER-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'HELPER-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/proof-helper-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and
                        (not mutated or marker in result.stdout), 'HELPER-MUTANT ' + label)
            print('HELPER-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    T.WORK = G.WORK = E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        witness(sys.argv[2])
    elif sys.argv[1:] in (['live'], ['refusals'], ['erasure'], ['mutants']):
        {'live': live, 'refusals': refusals, 'erasure': erasure, 'mutants': mutants}[sys.argv[1]]()
    elif not sys.argv[1:]:
        count, invalid, erased, killed = live(), refusals(), erasure(), mutants()
        print(f'PROOF-HELPERS cases={count} creates=2 refusals={invalid} erasure={erased} mutants={killed} OK')
    else:
        print('usage: dev/proof-helper-test.py [live|refusals|erasure|mutants|witness NAME]', file=sys.stderr)
        sys.exit(64)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, subprocess.TimeoutExpired, SystemExit) as exc:
        if isinstance(exc, SystemExit) and isinstance(exc.code, int):
            raise
        print(str(exc))
        sys.exit(1)

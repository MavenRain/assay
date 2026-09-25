#!/usr/bin/env python3
"""Check storage invariant obligations, erasure and Cancun correspondence."""
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
WORK = ROOT / '.gatework/invariants'
BINARY = ROOT / '_build/bin/assay'
spec = importlib.util.spec_from_file_location('invariant_guards', ROOT / 'dev/guard-test.py')
G = importlib.util.module_from_spec(spec)
spec.loader.exec_module(G)
E, M, P, C, require = G.E, G.M, G.P, G.C, G.require
MAX = G.MAX
SOURCE = ROOT / 'examples/CounterInvariant.asy'
DECL = 'invariant bounded (s : State) : Prop := Le s.cell s.cap\n'


def program(body, declaration=DECL, init='sstore cap (word 100) ; pure ()'):
    return ('contract Invariants where storage State := { cell : Word ; cap : Word }\n' +
            declaration + 'entry set (a : Word) : Eff Sig Word := do ' + body + '\n' +
            ('constructor := do ' + init if init is not None else ''))


def guarded():
    return program('bound <- sload cap ; (0 q : Le a bound) <- guard (leWord a bound) ; '
                   'sstore cell a ; pure a')


def item(name, selector, args=(), before=(0, 100), after=None, result=0, error=None, value=0):
    state = lambda pair: {'0': hex(pair[0]), '1': hex(pair[1]), '2': '0xabc'}
    return dict(name=name, calldata=selector + ''.join(f'{n:064x}' for n in args), value=value,
                before=state(before), after=state(before if after is None else after),
                status='success' if error is None else 'revert',
                output='0x' + f'{result:064x}' if error is None else error)


def rows():
    errors = {name: G.signature(name + '()') for name in ('OverflowRevert', 'UnderflowRevert')}
    bound_error = G.signature('BoundRevert(uint256,uint256)')
    samples = [(0, 100, 0), (0, 100, 1), (99, 100, 1), (100, 100, 1),
               (7, 8, 3), (MAX, MAX, 0), (MAX, MAX, 1), (8, 7, 0), (8, 7, 1)]
    result = []
    for c, bound, n in samples:
        for op in ('increment', 'decrement'):
            value = c + n if op == 'increment' else c - n
            error = None
            if value > MAX:
                error = errors['OverflowRevert']
            elif value < 0:
                error = errors['UnderflowRevert']
            elif value > bound:
                error = bound_error + f'{value:064x}{bound:064x}'
            result.append(item(f'{op}-{len(result)}', G.signature(op + '(uint256)'), [n],
                               (c, bound), (value, bound) if error is None else None, value, error))
        result.append(item(f'get-{len(result)}', G.signature('get()'), before=(c, bound), result=c))
    result.extend([
        item('short', '0x010203', error='0x'),
        item('unknown', '0xdeadbeef', error='0x'),
        item('short-argument', G.signature('increment(uint256)'), error='0x'),
        item('callvalue', G.signature('increment(uint256)'), [1], error='0x', value=1),
    ])
    return result


def compare(name, source, runtime, row):
    M.model(name, source, row)
    P.execute(name, runtime, row)


def live():
    count, erased = 0, 0
    hashes = {}
    with tempfile.TemporaryDirectory(prefix='assay-invariants-') as temporary:
        folder = Path(temporary)
        runtime, init = P.emit(SOURCE, folder / 'counter', 'counter')
        for row in rows():
            compare(row['name'], SOURCE, runtime, row)
            count += 1
        prefix = init[:-len(runtime)]
        creates = C.creation(runtime, prefix, P.listing('prefix', prefix))
        # One chain begins at the constructor state and includes a refused write.
        # Review round 2026-09-13 (B-2):  the chain classifies all three revert
        # kinds, and the bound holds over the storage the executor reports.
        state = (0, 100)
        steps = [('increment', 40), ('increment', 60), ('increment', 1),
                 ('decrement', 7), ('decrement', 93), ('decrement', 1),
                 ('increment', 40), ('increment', MAX)]
        for index, (op, n) in enumerate(steps):
            value = state[0] + n if op == 'increment' else state[0] - n
            error = (G.signature('OverflowRevert()') if value > MAX else
                     G.signature('UnderflowRevert()') if value < 0 else
                     G.signature('BoundRevert(uint256,uint256)') + f'{value:064x}{state[1]:064x}'
                     if value > state[1] else None)
            after = (value, state[1]) if error is None else state
            row = item(f'chain-{index}', G.signature(op + '(uint256)'), [n], state, after, value, error)
            M.model(row['name'], SOURCE, row)
            report, _evidence = P.execute(row['name'], runtime, row)
            count += 1
            state = after
            slots = report['storage']
            require(int(slots.get('0', '0x0'), 16) <= int(slots.get('1', '0x0'), 16),
                    'INVARIANT-CHAIN')
        # Declaring an invariant must not change any of the five artifacts.
        baseline = SOURCE.read_text()
        variants = [baseline, baseline.replace('bounded (s : State)', 'renamed (s : State)'),
                    baseline.replace('  error OverflowRevert',
                        '  invariant alsoBounded (t : State) : Prop := Le t.count t.limit\n  error OverflowRevert'),
                    baseline.replace('invariant bounded (s : State) : Prop := Le s.count s.limit', '')]
        for index, text in enumerate(variants):
            source = folder / f'erasure-{index}.asy'
            source.write_text(text)
            output = folder / f'erasure-{index}'
            P.emit(source, output, f'erasure-{index}')
            files = {path.name: hashlib.sha256(path.read_bytes()).hexdigest() for path in output.iterdir()}
            require(len(files) == 5 and (not hashes or hashes == files), 'INVARIANT-ERASURE')
            hashes = files
            erased += 1
        fixtures = [
            ('guard', guarded(), item('guard', G.signature('set(uint256)'), [9], after=(9, 100), result=9)),
            ('guard-failure', guarded(), item('guard-failure', G.signature('set(uint256)'), [101], error='0x')),
            ('literal', program('sstore cell (word 9) ; sstore cap (word 10) ; pure (word 9)'),
             item('literal', G.signature('set(uint256)'), [0], after=(9, 10), result=9)),
            ('rollback', program('sstore cell (word 101) ; revert'),
             item('rollback', G.signature('set(uint256)'), [0], error='0x')),
            ('repair', program('sstore cell (word 101) ; sstore cap (word 100) ; sstore cell (word 3) ; pure a'),
             item('repair', G.signature('set(uint256)'), [8], after=(3, 100), result=8)),
            ('unrelated', program('sstore cap (word 1) ; pure a',
                'invariant bounded (s : State) : Prop := Le s.cell (word 100)\n'),
             item('unrelated', G.signature('set(uint256)'), [8], after=(0, 1), result=8)),
            ('alias-proof', guarded().replace('sstore cell a', 'let (0 r : Le a bound) := q ; sstore cell a'),
             item('alias-proof', G.signature('set(uint256)'), [9], after=(9, 100), result=9)),
            ('shadow-proof', guarded().replace('sstore cell a', 'let q : Word := word 0 ; sstore cell a'),
             item('shadow-proof', G.signature('set(uint256)'), [9], after=(9, 100), result=9)),
            ('snapshot', guarded().replace('bound <- sload cap', 'old <- sload cell ; sstore cell (word 111) ; bound <- sload cap'),
             item('snapshot', G.signature('set(uint256)'), [9], after=(9, 100), result=9)),
            ('snapshot-rollback', guarded().replace('bound <- sload cap', 'sstore cell (word 111) ; bound <- sload cap'),
             item('snapshot-rollback', G.signature('set(uint256)'), [101], error='0x')),
            ('fits', program('sstore cell (word 2) ; sstore cap (word 3) ; pure a',
                'invariant fits (s : State) : Prop := Lt256 (add s.cell s.cap)\n'),
             item('fits', G.signature('set(uint256)'), [5], after=(2, 3), result=5)),
            ('nesting-boundary', guarded().replace('Le s.cell s.cap', 'Le ' + '(' * 128 + 's.cell' + ')' * 128 + ' s.cap'),
             item('nesting-boundary', G.signature('set(uint256)'), [9], after=(9, 100), result=9)),
            ('member-boundary', guarded().replace(DECL, ''.join(DECL.replace('bounded', f'bound{i}') for i in range(32))),
             item('member-boundary', G.signature('set(uint256)'), [9], after=(9, 100), result=9)),
        ]
        for name, text, row in fixtures:
            source = folder / (name + '.asy')
            source.write_text(text)
            code, _init = P.emit(source, folder / name, name)
            compare(name, source, code, row)
            count += 1
        (WORK / 'OUTPUTS.json').write_text(json.dumps(dict(cases=count, creates=creates, erasure=erased,
            runtime_bytes=len(runtime) // 2, init_bytes=len(init) // 2, files=hashes), indent=2) + '\n')
    print(f'INVARIANT-LIVE cases={count} creates={creates} erasure={erased} files={len(hashes)} OK', flush=True)
    return count, creates, erased


def negative_cases():
    good = guarded()
    stale = program('old <- sload cell ; bound <- sload cap ; '
                    '(0 q : Le old bound) <- guard (leWord old bound) ; sstore cell a ; pure a')
    return [
        ('constructor', program('pure a', init='sstore cell (word 101) ; sstore cap (word 100) ; pure ()'), 'mismatch'),
        ('default-constructor', program('pure a', DECL.replace('s.cell s.cap', '(word 1) s.cap'), None), 'mismatch'),
        ('constructor-overwrite', program('pure a', init='sstore cap (word 100) ; sstore cell (word 1) ; sstore cap (word 0) ; pure ()'), 'mismatch'),
        ('final', program('sstore cell (word 101) ; sstore cap (word 100) ; pure a'), 'mismatch'),
        ('missing-proof', good.replace('(0 q : Le a bound) <- guard (leWord a bound) ; ', ''), 'mismatch'),
        ('boolean-guard', good.replace('(0 q : Le a bound) <- guard (leWord a bound)', 'guard le a bound'), 'mismatch'),
        ('stale-store', stale, 'mismatch'),
        ('changed-limit', good.replace('pure a', 'sstore cap (word 0) ; pure a'), 'mismatch'),
        ('reload', good.replace('pure a', 'again <- sload cell ; pure a'), 'mismatch'),
        ('missing-field', program('sstore cell a ; pure a'), 'SURFACE_INVARIANT'),
        ('false-proof', good.replace('<- guard (leWord a bound)', ':= ()').replace('(0 q', 'let (0 q'), 'mismatch'),
        ('second', program('pure a', DECL + 'invariant bad (s : State) : Prop := Le (word 1) s.cell\n'), 'mismatch'),
        ('duplicate', program('pure a', DECL + DECL), 'SURFACE_DUPLICATE'),
        ('state-name', good.replace('invariant bounded', 'invariant State'), 'SURFACE_DUPLICATE'),
        ('entry-name', good.replace('invariant bounded', 'invariant set'), 'SURFACE_DUPLICATE'),
        ('field-name', good.replace('invariant bounded', 'invariant cell'), 'SURFACE_DUPLICATE'),
        ('argument-name', good.replace('invariant bounded', 'invariant a'), 'SURFACE_DUPLICATE'),
        ('error-name', good.replace('invariant bounded', 'error bounded ()\ninvariant bounded'), 'SURFACE_DUPLICATE'),
        ('members', program('pure a', ''.join(DECL.replace('bounded', f'bound{i}') for i in range(33))), 'SURFACE_LIMIT'),
        ('binder-type', good.replace('(s : State)', '(s : Word)'), 'SURFACE_SYNTAX'),
        ('result-type', good.replace(': Prop :=', ': Word :='), 'SURFACE_SYNTAX'),
        ('unknown-field', good.replace('s.cell', 's.missing'), 'SURFACE_SLOT'),
        ('escaped-snapshot', good.replace('s.cell', 't.cell'), 'SURFACE_INVARIANT'),
        ('bare-field', good.replace('s.cell', 'cell'), 'SURFACE_INVARIANT'),
        ('unsupported-predicate', good.replace('Le s.cell s.cap', 'Custom s.cell s.cap'), 'SURFACE_PROOF'),
        ('literal-range', good.replace('s.cell', f'(word {MAX + 1})'), 'SURFACE_WORD'),
        ('nesting', good.replace('s.cell', '(' * 129 + 's.cell' + ')' * 129), 'SURFACE_LIMIT'),
        ('overflow', program('pure a', DECL.replace('Le s.cell s.cap', 'Lt256 (add s.cell s.cap)'),
                            f'sstore cell (word {MAX}) ; sstore cap (word 1) ; pure ()'), 'mismatch'),
        # Review round 2026-09-13 (A-1):  `invariant` is reserved, so a member of
        # that name is a name refusal.
        ('reserved-word', good.replace('invariant bounded', 'error invariant ()\ninvariant bounded'), 'SURFACE_NAME'),
        # Review round 2026-09-13 (A-2):  `.` is a token everywhere, so a stray
        # projection outside a claim is a syntax refusal.
        ('stray-dot', good.replace('sstore cell a', 'sstore cell s.cap'), 'SURFACE_SYNTAX'),
    ]


def refusals(only=None):
    cases = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(cases), 'INVARIANT-WITNESS unknown ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-invariant-refusals-') as temporary:
        for name, text, marker in cases:
            E.refusal(name, text, marker, Path(temporary))
    print(f'INVARIANT-REFUSALS cases={len(cases)} OK', flush=True)
    return len(cases)


def mutants():
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-invariant-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        path = copy / 'src/emitter.bend'
        original = path.read_text()
        for name, before, after, witness in cases:
            require(native_mutations.count(original, before) == 1, 'INVARIANT-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'INVARIANT-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/invariant-test.py', 'witness', witness], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and
                        (not mutated or 'ERROR-REFUSAL ' + witness in result.stdout), 'INVARIANT-MUTANT ' + label)
            print('INVARIANT-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    G.WORK = E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        refusals(sys.argv[2])
    elif sys.argv[1:] in (['live'], ['refusals'], ['mutants']):
        {'live': live, 'refusals': refusals, 'mutants': mutants}[sys.argv[1]]()
    elif not sys.argv[1:]:
        count, creates, erased = live()
        invalid, killed = refusals(), mutants()
        print(f'INVARIANTS cases={count} creates={creates} refusals={invalid} erasure={erased} mutants={killed} OK')
    else:
        print('usage: dev/invariant-test.py [live|refusals|mutants|witness NAME]', file=sys.stderr)
        sys.exit(64)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('INVARIANTS FAIL: ' + str(error))
        sys.exit(1)

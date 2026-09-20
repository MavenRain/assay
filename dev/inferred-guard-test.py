#!/usr/bin/env python3
"""Check inferred guard evidence against explicit proofs and Cancun execution."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/inferred-guards'
spec = importlib.util.spec_from_file_location('named_guards', ROOT / 'dev/named-guard-test.py')
NG = importlib.util.module_from_spec(spec)
spec.loader.exec_module(NG)
Q, I, N, B, H, T, G, E, M, P, C, require = (
    NG.Q, NG.I, NG.N, NG.B, NG.H, NG.T, NG.G, NG.E, NG.M, NG.P, NG.C, NG.require)


def guard(condition='Bounds(a, b)', failure='Denied (a) (b)'):
    return f'guard {failure} ({condition}) ; '


def program(condition='Bounds(a, b)', *, definitions=NG.DEFINITIONS, failure='Denied (a) (b)', **options):
    return Q.program(guard(condition, failure), definitions=definitions, **options)


def forms():
    rows = []

    def add(name, condition='Bounds(a, b)', claim=Q.CLAIM, failure='Denied (a) (b)',
            error='Denied(uint256,uint256)', behavior='set', definitions=NG.DEFINITIONS, **options):
        inferred = program(condition, failure=failure, definitions=definitions, **options)
        explicit = Q.program(Q.guard(claim, condition, failure, name='checked'), definitions=definitions, **options)
        rows.append((name, inferred, explicit, error, behavior))

    add('named', definitions=NG.BOUND)
    add('inline', Q.CONDITION)
    add('mixed', 'both (Below(a, b)) (lt256 (add a b))')
    add('alias', 'Alias(a, b)', definitions=NG.DEFINITIONS + NG.ALIAS)
    add('substitution', 'Flip(b, a)', definitions=NG.DEFINITIONS +
        'predicate Flip (0 a : Word) (0 b : Word) : Prop := Bounds(b, a)\n')
    add('empty', failure='', error='empty')
    add('nullary', failure='Halt ()', errors='error Halt ()\n', error='Halt()')
    add('nullary-bare', failure='Halt', errors='error Halt ()\n', error='Halt()')
    add('contextual', 'both(a, b)', definitions=NG.BOUND.replace('Bounds', 'both'))
    add('error-name', failure='both (a) (b)', errors=Q.ERROR.replace('Denied', 'both'),
        error='both(uint256,uint256)')
    add('snapshot', before='a <- sload low ; ' + Q.BEFORE, behavior='snapshot')
    add('local-name', before='let bounds : Word := a ; ' + Q.BEFORE,
        tail=Q.STORES.replace('pure a', 'pure bounds'))
    inferred = (ROOT / 'examples/InferredGuards.asy').read_text()
    explicit = inferred.replace(guard().strip(), Q.guard(claim='Bounds(a, b)', condition='Bounds(a, b)').strip())
    rows.append(('invariant', inferred, explicit, 'Denied(uint256,uint256)', 'set'))
    conditions = ('leWord a b', 'lt256 (add a b)')
    claims = ('Le a b', 'Lt256 (add a b)')
    inferred = Q.program(''.join(guard(c) for c in conditions), definitions=NG.DEFINITIONS + I.DECL)
    explicit = Q.program(''.join(Q.guard(c, r, name=f'evidence{i}') for i, (c, r) in
        enumerate(zip(claims, conditions))), definitions=NG.DEFINITIONS + I.DECL)
    rows.append(('separate-evidence', inferred, explicit, 'Denied(uint256,uint256)', 'set'))
    return rows


def live(only=None):
    rows = [row for row in forms() if only is None or row[0] == only]
    require(bool(rows), 'IG-LIVE-WITNESS ' + str(only))
    cases, creates = 0, 0
    selector = G.signature('set(uint256,uint256)')
    with tempfile.TemporaryDirectory(prefix='assay-inferred-live-') as temporary:
        folder = Path(temporary)
        for name, text, _explicit, error, behavior in rows:
            source = folder / f'{name}.asy'
            source.write_text(text)
            runtime, init = P.emit(source, folder / name, name)
            if name == 'invariant':
                E.creation(runtime, init, folder, expected_storage={})
                creates += 2
            for index, (argument, b) in enumerate(Q.PAIRS):
                a = 2 if behavior == 'snapshot' else argument
                success = a <= b and a + b <= G.MAX
                before = {'0': '0x2', '1': '0x8', '2': '0xabc'}
                output = '0x' + f'{a:064x}' if success else ('0x' if error == 'empty' else G.signature(error))
                if not success and error.endswith('uint256,uint256)'):
                    output += f'{a:064x}{b:064x}'
                row = dict(name=name, calldata=selector + f'{argument:064x}{b:064x}', value=0, before=before,
                    after={**before, '0': hex(a), '1': hex(b)} if success else before,
                    status='success' if success else 'revert', output=output)
                H.compare(f'ig-{name}-{index}', source, runtime, row)
                cases += 1
    (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=creates), indent=2) + '\n')
    print(f'IG-LIVE cases={cases} creates={creates} OK', flush=True)
    return cases, creates


def erasure():
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-erasure-') as temporary:
        folder = Path(temporary)
        for name, inferred, explicit, _error, _behavior in forms():
            outputs = []
            for index, text in enumerate((inferred, explicit)):
                source, output = folder / f'{name}-{index}.asy', folder / f'{name}-{index}'
                source.write_text(text)
                P.emit(source, output, f'erasure-{name}-{index}')
                outputs.append(H.outputs(output))
            require(outputs[0] == outputs[1] and len(outputs[0]) == 5, 'IG-ERASURE five files ' + name)
            captures.append(dict(name=name, variants=[{file: hashlib.sha256(data).hexdigest()
                for file, data in output.items()} for output in outputs]))
    (WORK / 'ERASURE.json').write_text(json.dumps(captures, indent=2) + '\n')
    print(f'IG-ERASURE pairs={len(captures)} files=5 OK', flush=True)
    return len(captures)


def negative_cases():
    wide, _ = NG.wide(65)
    half, _ = NG.wide(40)
    unused = NG.BOUND.replace('(0 y : Word)', '(0 y : Word) (0 unused : Word)')
    return [
        ('unknown', program('Missing(a, b)'), 'SURFACE_PREDICATE'),
        ('arity', program('Bounds(a)'), 'SURFACE_PREDICATE'),
        ('unused-word', program('Bounds(a, b, missing)', definitions=unused), 'SURFACE_SCOPE'),
        ('proof-argument', program('Bounds(a, b, p)', definitions=unused,
            before='let (0 p : Le (word 0) (word 0)) := () ; ' + Q.BEFORE), 'SURFACE_PROOF'),
        ('word-shadow', program(before='let Bounds : Word := a ; ' + Q.BEFORE), 'SURFACE_PREDICATE'),
        ('proof-shadow', program(before='let (0 Bounds : Le (word 0) (word 0)) := () ; ' + Q.BEFORE),
         'SURFACE_PREDICATE'),
        ('not-bound', program(tail='let total : Word := addLt a b second(bounds) ; pure total'), 'SURFACE_PROOF'),
        ('internal-name', program(tail='let total : Word := addLt a b second(_assay_guard) ; pure total'),
         'SURFACE_NAME'),
        ('false-proof', program(tail=f'let (0 unused : {B.FALSE}) := () ; pure a'), 'mismatch'),
        ('stale-invariant', program(definitions=NG.DEFINITIONS + I.DECL,
            tail=Q.STORES.replace('pure a', 'sstore high (word 0) ; pure a')), 'mismatch'),
        ('reloaded-invariant', program(definitions=NG.DEFINITIONS + I.DECL,
            tail='a <- sload low ; ' + Q.STORES), 'mismatch'),
        ('wrong-invariant', program('Bounds(b, a)', definitions=NG.DEFINITIONS + I.DECL), 'mismatch'),
        ('missing-component', program('Below(a, b)', definitions=NG.DEFINITIONS + I.DECL), 'mismatch'),
        ('expanded-bounds', program('Wide(a, b)', definitions=wide), 'SURFACE_LIMIT'),
        ('shared-budget', program('both (Wide(a, b)) (Wide(a, b))', definitions=half), 'SURFACE_LIMIT'),
        ('depth', program('both (Chain31(a, b)) (leWord a b)', definitions=NG.chain()), 'SURFACE_LIMIT'),
        ('steps', Q.program(guard('leWord a b') * 129, before='', tail='pure a'), 'SURFACE_LIMIT'),
        ('error-arity', program(failure='Denied (a)'), 'SURFACE_ERROR'),
        ('error-empty', program(failure='Denied () (a) (b)'), 'SURFACE_ERROR'),
        ('error-mixed', program(failure='Denied (a) () (b)'), 'SURFACE_ERROR'),
        ('unknown-error', program(failure='Missing (a) (b)'), 'SURFACE_ERROR'),
        ('payload-scope', program(failure='Denied (missing) (b)'), 'SURFACE_SCOPE'),
        ('condition-required', Q.program('guard ; '), 'SURFACE_NAME'),
        ('constructor', program() + 'constructor := do guard (leWord (word 0) (word 0)) ; pure ()\n',
         'SURFACE_CONSTRUCTOR'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'IG-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-inferred-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('ig-' + name, text, marker, Path(temporary))
    print(f'IG-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    wide, _ = NG.wide(64)
    texts = [program('Wide(a, b)', definitions=wide),
             program('Chain31(a, b)', definitions=NG.chain()),
             program('both()', definitions=NG.READY.replace('Ready', 'both')),
             program('Bounds(((a)), (b))'),
             Q.program('guard le a b ; '),
             Q.program(guard('leWord a b') * 128, before='', tail='pure a')]
    with tempfile.TemporaryDirectory(prefix='assay-inferred-boundaries-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(texts):
            source = folder / f'{index}.asy'
            source.write_text(text)
            P.emit(source, folder / str(index), f'boundary-{index}')
    print(f'IG-BOUNDARIES accepted={len(texts)} OK', flush=True)
    return len(texts)


def witness(name):
    return live(name) if name in ('named', 'invariant', 'separate-evidence') else refusals(name)


def mutants():
    cases = [
        ('CLAIM', '| Check predicate -> Bound predicate',
         '| Check (Ordered (a, b)) -> Bound (Ordered (b, a))\n  | Check (Fits (a, b)) -> Bound (Fits (a, b))',
         'separate-evidence', 'M1-TOOL separate-evidence'),
        ('NAMED-ARGUMENTS', '\n  | Satisfy (name, args) -> Named (name, args)',
         '\n  | Satisfy (name, args) -> Named (name, List.rev args)', 'named', 'MODEL-EXPECTED ig-named-1'),
        ('EVIDENCE', '          state written (evidence_for fresh ty evidence) rest in',
         '          state written evidence rest in', 'invariant', 'M1-TOOL invariant'),
        ('STALE-STATE', 'obligations changed state evidence "Tx" (app "done" [v])',
         'obligations (List.filter (fun _ -> false) changed) state evidence "Tx" (app "done" [v])',
         'stale-invariant', 'ERROR-REFUSAL ig-stale-invariant'),
    ]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'IG-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'IG-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/inferred-guard-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'IG-MUTANT ' + label)
                captures.append(dict(name=label, witness=case, expected_marker=marker,
                    returncode=result.returncode, source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('IG-MUTANT ' + name + ' killed control=OK', flush=True)
    (WORK / 'MUTANTS.json').write_text(json.dumps(captures, indent=2) + '\n')
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=live, erasure=erasure, refusals=refusals, boundaries=boundaries, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/inferred-guard-test.py [live|erasure|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (NG, Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, creates = live()
        erased, invalid, accepted, killed = erasure(), refusals(), boundaries(), mutants()
        print(f'INFERRED-GUARDS cases={cases} creates={creates} refusals={invalid} erasure_pairs={erased} '
              f'boundaries={accepted} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (RuntimeError, OSError, ValueError) as error:
        print('INFERRED-GUARDS FAIL ' + str(error), flush=True)
        sys.exit(1)

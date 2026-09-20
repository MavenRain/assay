#!/usr/bin/env python3
"""Check named inferred guard evidence, scope, annotations and Cancun behavior."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/inferred-guard-bindings'
spec = importlib.util.spec_from_file_location('inferred_guards', ROOT / 'dev/inferred-guard-test.py')
IG = importlib.util.module_from_spec(spec)
spec.loader.exec_module(IG)
NG, Q, I, N, B, H, T, G, E, M, P, C, require = (
    IG.NG, IG.Q, IG.I, IG.N, IG.B, IG.H, IG.T, IG.G, IG.E, IG.M, IG.P, IG.C, IG.require)


def guard(condition='Bounds(a, b)', name='checked', claim=None, failure='Denied (a) (b)'):
    annotation = '' if claim is None else ' : ' + claim
    return f'(0 {name}{annotation}) <- guard {failure} ({condition}) ; '


def consume(term='checked', left='a'):
    return (f'let (0 ordered : Le {left} b) := first({term}) ; '
            f'let (0 fits : Lt256 (add {left} b)) := second({term}) ; ')


def program(condition='Bounds(a, b)', *, name='checked', claim=None, failure='Denied (a) (b)',
            definitions=NG.DEFINITIONS, **options):
    return Q.program(guard(condition, name, claim, failure), definitions=definitions, **options)


def forms():
    rows = []

    def add(name, condition='Bounds(a, b)', claim='Bounds(a, b)', binder='checked',
            error='Denied(uint256,uint256)', behavior='set', tail=None, **options):
        options['tail'] = consume(binder) + Q.STORES if tail is None else tail
        inferred = program(condition, name=binder, **options)
        explicit = program(condition, name=binder, claim=claim, **options)
        rows.append((name, inferred, explicit, error, behavior))

    add('named')
    add('inline', Q.CONDITION, Q.CLAIM)
    add('mixed', 'both (Below(a, b)) (lt256 (add a b))', Q.CLAIM)
    add('alias', 'Alias(a, b)', definitions=NG.DEFINITIONS + NG.ALIAS)
    add('substitution', 'Flip(b, a)', definitions=NG.DEFINITIONS +
        'predicate Flip (0 x : Word) (0 y : Word) : Prop := Bounds(y, x)\n')
    add('nested', 'both (Bounds(a, b)) (Below(a, b))', 'Both (Bounds(a, b)) (Le a b)',
        tail=consume('first(checked)') + Q.STORES)
    add('empty', failure='', error='empty')
    add('nullary', failure='Halt ()', errors='error Halt ()\n', error='Halt()')
    add('nullary-bare', failure='Halt', errors='error Halt ()\n', error='Halt()')
    add('contextual-binder', binder='both')
    add('contextual-predicate', 'both(a, b)', Q.CLAIM, definitions=NG.BOUND.replace('Bounds', 'both'))
    add('snapshot', before='a <- sload low ; ' + Q.BEFORE, behavior='snapshot')
    add('word-shadow', binder='a', before='let saved : Word := a ; ' + Q.BEFORE,
        tail=consume('a', 'saved') + 'sstore low saved ; sstore high b ; pure saved')
    add('proof-shadow', before='let (0 checked : Le (word 0) (word 0)) := () ; ' + Q.BEFORE)
    add('helper', definitions=NG.DEFINITIONS + H.ORDER + H.FITS,
        tail='let (0 lo) := ordered(a, b, first(checked)) ; '
             'let (0 hi) := fits(a, b, second(checked)) ; ' + Q.STORES)
    add('inferred-evidence', definitions=NG.DEFINITIONS + H.ORDER + H.FITS,
        tail='let (0 lo) := ordered(a, b) ; let (0 hi) := fits(a, b, _) ; ' + Q.STORES)
    add('unused', tail=Q.STORES)
    add('arithmetic', tail='let d : Word := subLe b a first(checked) ; '
        'let total : Word := addLt a b second(checked) ; ' + Q.STORES)
    guards = [('ordered', 'leWord a b', 'Le a b'), ('fits', 'lt256 (add a b)', 'Lt256 (add a b)')]
    tail = 'let (0 checked) := pair(ordered, fits) ; ' + consume() + Q.STORES
    variants = [Q.program(''.join(guard(condition, name, claim if typed else None)
                for name, condition, claim in guards), tail=tail) for typed in (False, True)]
    rows.append(('atomic', *variants, 'Denied(uint256,uint256)', 'set'))
    source = (ROOT / 'examples/InferredGuardBindings.asy').read_text()
    rows.append(('invariant', source, source.replace('(0 checked)', '(0 checked : Bounds(a, b))'),
                 'Denied(uint256,uint256)', 'set'))
    return rows


def negative_cases():
    wide, _ = NG.wide(65)
    half, _ = NG.wide(40)
    return [
        ('annotation', program(claim='Bounds(b, a)'), 'mismatch'),
        ('unused-annotation', program(claim='Bounds(b, a)', tail='pure a'), 'mismatch'),
        ('reverting-annotation', program(claim='Bounds(b, a)', tail='revert'), 'mismatch'),
        ('shape', program(claim='Le a b'), 'SURFACE_PROOF'),
        ('unknown', program('Missing(a, b)'), 'SURFACE_PREDICATE'),
        ('arity', program('Bounds(a)'), 'SURFACE_PREDICATE'),
        ('word-predicate-shadow', program(before='let Bounds : Word := a ; '), 'SURFACE_PREDICATE'),
        ('proof-predicate-shadow', program(before='let (0 Bounds) := () ; '), 'SURFACE_PREDICATE'),
        ('condition-scope', program('Bounds(checked, b)'), 'SURFACE_SCOPE'),
        ('payload-scope', program(failure='Denied (checked) (b)'), 'SURFACE_SCOPE'),
        ('proof-as-word', program(tail='pure checked'), 'SURFACE_PROOF'),
        ('wrong-projection', program(tail='let total : Word := addLt a b first(checked) ; pure total'), 'mismatch'),
        ('word-rebind', program(tail='a <- sload low ; let total : Word := addLt a b second(checked) ; pure total'),
         'mismatch'),
        ('proof-name-shadow', program(tail='let checked : Word := a ; ' + consume() + Q.STORES), 'SURFACE_PROOF'),
        ('entry-escape', program() + 'entry later (a : Word) (b : Word) : Eff Sig Word := do '
         'let total : Word := addLt a b second(checked) ; pure total\n', 'SURFACE_PROOF'),
        ('stale-invariant', program(definitions=NG.DEFINITIONS + I.DECL,
         tail=Q.STORES.replace('pure a', 'sstore high (word 0) ; pure a')), 'mismatch'),
        ('missing-component', program('Below(a, b)', definitions=NG.DEFINITIONS + I.DECL), 'mismatch'),
        ('expanded-bounds', program('Wide(a, b)', definitions=wide), 'SURFACE_LIMIT'),
        ('shared-budget', program('both (Wide(a, b)) (Wide(a, b))', definitions=half), 'SURFACE_LIMIT'),
        ('depth', program('both (Chain31(a, b)) (leWord a b)', definitions=NG.chain()), 'SURFACE_LIMIT'),
        ('steps', Q.program(guard('leWord a b') * 129, before='', tail='pure a'), 'SURFACE_LIMIT'),
        ('error-arity', program(failure='Denied (a)'), 'SURFACE_ERROR'),
        ('unknown-error', program(failure='Missing (a) (b)'), 'SURFACE_ERROR'),
        ('binder-hole', program(name='_'), 'SURFACE_NAME'),
        ('quantity', program().replace('(0 checked)', '(1 checked)'), 'SURFACE_SYNTAX'),
        ('missing-type', program().replace('(0 checked)', '(0 checked :)'), 'SURFACE_PROOF'),
        ('constructor', program() + 'constructor := do '
         '(0 checked) <- guard (leWord (word 0) (word 0)) ; pure ()\n', 'SURFACE_CONSTRUCTOR'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'IGB-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-guard-binding-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('igb-' + name, text, marker, Path(temporary))
    print(f'IGB-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    wide, claim = NG.wide(64)
    rows = [('bounds', program('Wide(a, b)', definitions=wide), claim),
            ('depth', program('Chain31(a, b)', definitions=NG.chain()), 'Le a b'),
            ('nullary', program('Ready()', definitions=NG.READY), 'Le (word 0) (word 0)'),
            ('steps', Q.program(guard('leWord a b') * 128, before='', tail='pure a'), 'Le a b')]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-guard-binding-boundaries-') as temporary:
        folder = Path(temporary)
        for name, text, claim in rows:
            outputs = []
            typed = text.replace('(0 checked)', f'(0 checked : {claim})')
            for index, variant in enumerate((text, typed)):
                source, output = folder / f'{name}-{index}.asy', folder / f'{name}-{index}'
                source.write_text(variant)
                P.emit(source, output, f'boundary-{name}-{index}')
                outputs.append(H.outputs(output))
            require(outputs[0] == outputs[1] and len(outputs[0]) == 5, 'IGB-BOUNDARY erasure ' + name)
            captures.append(dict(name=name, source_sha256=hashlib.sha256(text.encode()).hexdigest(),
                typed_sha256=hashlib.sha256(typed.encode()).hexdigest(),
                outputs={file: hashlib.sha256(data).hexdigest() for file, data in outputs[0].items()}))
    (WORK / 'BOUNDARIES.json').write_text(json.dumps(captures, indent=2) + '\n')
    print(f'IGB-BOUNDARIES accepted={len(rows)} erasure_pairs={len(rows)} OK', flush=True)
    return len(rows)


def witness(name):
    return IG.live(name) if name in ('named', 'atomic') else refusals(name)


def mutants():
    cases = [
        ('ANNOTATION', '~some:(fun claim () -> claim) annotation ()',
         '~some:(fun _claim () -> condition_claim condition) annotation ()',
         'annotation', 'ERROR-REFUSAL igb-annotation'),
        ('BINDING', '  Ok (Prove (name, claim, error, condition), rest)',
         '  Ok (Prove ({ name with text = "_assay_guard" }, claim, error, condition), rest)',
         'named', 'M1-TOOL named'),
        ('ATOMIC-CLAIM', '| Check predicate -> Bound predicate',
         '| Check (Ordered (a, b)) -> Bound (Ordered (b, a))\n  | Check (Fits (a, b)) -> Bound (Fits (a, b))',
         'atomic', 'M1-TOOL atomic'),
        ('NAMED-ARGUMENTS', '\n  | Satisfy (name, args) -> Named (name, args)',
         '\n  | Satisfy (name, args) -> Named (name, List.rev args)', 'named', 'M1-TOOL named'),
    ]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-guard-binding-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'IGB-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'IGB-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/inferred-guard-binding-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'IGB-MUTANT ' + label)
                captures.append(dict(name=label, witness=case, expected_marker=marker,
                    returncode=result.returncode, source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('IGB-MUTANT ' + name + ' killed control=OK', flush=True)
    (WORK / 'MUTANTS.json').write_text(json.dumps(captures, indent=2) + '\n')
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=IG.live, erasure=IG.erasure, refusals=refusals, boundaries=boundaries, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/inferred-guard-binding-test.py [live|erasure|refusals|boundaries|mutants|witness NAME]',
              file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (IG, NG, Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    IG.forms = forms
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, creates = IG.live()
        erased, invalid, accepted, killed = IG.erasure(), refusals(), boundaries(), mutants()
        print(f'INFERRED-GUARD-BINDINGS cases={cases} creates={creates} refusals={invalid} '
              f'erasure_pairs={erased} boundaries={accepted} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (RuntimeError, OSError, ValueError) as error:
        print('INFERRED-GUARD-BINDINGS FAIL ' + str(error), flush=True)
        sys.exit(1)

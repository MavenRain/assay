#!/usr/bin/env python3
"""Check proof products, both projection obligations, erasure and Cancun behavior."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/proof-bundles'
spec = importlib.util.spec_from_file_location('bundle_helpers', ROOT / 'dev/proof-helper-test.py')
H = importlib.util.module_from_spec(spec)
spec.loader.exec_module(H)
T, G, E, M, P, C, require = H.T, H.G, H.E, H.M, H.P, H.C, H.require
TRUE, FALSE = 'Le (word 0) (word 1)', 'Le (word 1) (word 0)'
ORDER, FITS = 'Le b a', 'Lt256 (add a b)'
CLAIM = f'Both ({ORDER}) ({FITS})'
BINDING = f'let (0 bundle : {CLAIM}) := pair(ordered, fits) ; '
PREFIX = ('sstore cell (word 9) ; '
          '(0 ordered : Le b a) <- guard Denied (a) (b) (leWord b a) ; '
          '(0 fits : Lt256 (add a b)) <- guard Denied (a) (b) (lt256 (add a b)) ; ')
ENDING = ('let difference : Word := subLe a b first(bundle) ; '
          'let total : Word := addLt a b second(bundle) ; sstore cell difference ; pure total')


def program(binding=BINDING, ending=ENDING):
    return G.program(PREFIX + binding + ending).replace('contract Guards', 'contract ProofBundles') + \
        'constructor := do sstore cell (word 7) ; pure ()\n'


def nested(depth):
    claim, term = TRUE, '()'
    for _ in range(depth):
        claim, term = f'Both ({TRUE}) ({claim})', f'pair((), {term})'
    return G.program(f'let (0 bundle : {claim}) := {term} ; pure a')


def invariant():
    return ('contract Bounds where storage State := { low : Word ; high : Word }\n'
            'invariant ordered (s : State) : Prop := Le s.low s.high\n'
            'invariant fits (s : State) : Prop := Lt256 (add s.low s.high)\n'
            'entry set (a : Word) (b : Word) : Eff Sig Word := do '
            '(0 p : Le a b) <- guard (leWord a b) ; '
            '(0 q : Lt256 (add a b)) <- guard (lt256 (add a b)) ; '
            'let x : Word := a ; let y : Word := b ; '
            'let (0 bundle : Both (Le x y) (Lt256 (add x y))) := pair(p, q) ; '
            'sstore low x ; sstore high y ; pure x')


def matrix_row(a, b, selector, error):
    success = b <= a and a + b <= G.MAX
    row = P.row('bundle', selector + f'{a:064x}{b:064x}', a + b if success else 0,
                after=hex(a - b) if success else '0x7', status='success' if success else 'revert')
    if not success:
        row['output'] = error + f'{a:064x}{b:064x}'
    return row


def live():
    selector, error = G.signature('mix(uint256,uint256)'), G.signature('Denied(uint256,uint256)')
    base = program('', ENDING.replace('first(bundle)', 'ordered').replace('second(bundle)', 'fits'))
    variants = [base, program(), (ROOT / 'examples/ProofBundles.asy').read_text(),
        program('', ENDING.replace('first(bundle)', 'first(pair(ordered, fits))')
                .replace('second(bundle)', 'second(pair(ordered, fits))')),
        program(BINDING + f'let (0 bundle : {CLAIM}) := pair(first(bundle), second(bundle)) ; '),
        program(f'let (0 bundle : {CLAIM}) := '
                f'(let (0 local : {CLAIM}) := pair(ordered, fits) in local) ; '),
        program(f'let (0 nested : Both ({TRUE}) ({CLAIM})) := pair((), pair(ordered, fits)) ; '
                f'let (0 bundle : {CLAIM}) := second(nested) ; '),
        program('', ENDING.replace('first(bundle)', f'first((pair(ordered, fits) : {CLAIM}))')
                .replace('second(bundle)', f'second((pair(ordered, fits) : {CLAIM}))'))]
    cases, captures = 0, []
    with tempfile.TemporaryDirectory(prefix='assay-bundle-live-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(variants):
            source, output = folder / f'variant-{index}.asy', folder / str(index)
            source.write_text(text)
            runtime, init = P.emit(source, output, f'bundle-{index}')
            captures.append(H.outputs(output))
            if index == 2:
                E.creation(runtime, init, folder)
                abi = json.loads(captures[-1]['abi.json'])
                require([(r['name'], len(r['inputs'])) for r in abi if r['type'] == 'function'] == [('mix', 2)],
                        'BUNDLE-ABI erased')
            for a, b in G.PAIRS:
                H.compare(f'bundle-{index}-{cases}', source, runtime, matrix_row(a, b, selector, error))
                cases += 1
        hashes = [{name: hashlib.sha256(data).hexdigest() for name, data in row.items()} for row in captures]
        (WORK / 'ERASURE.json').write_text(json.dumps(hashes, indent=2) + '\n')
        differences = [(index, name) for index, row in enumerate(captures)
                       for name, data in row.items() if data != captures[0][name]]
        require(not differences, 'BUNDLE-ERASURE five files ' + str(differences))
        source = folder / 'invariant.asy'
        source.write_text(invariant())
        runtime, _init = P.emit(source, folder / 'invariant', 'invariant')
        for a, b in [(0, 0), (4, 9), (9, 4), (0, G.MAX), (1, G.MAX), (G.MAX, G.MAX)]:
            success = a <= b and a + b <= G.MAX
            before = {'0': '0x2', '1': '0x8', '2': '0xabc'}
            row = dict(name='invariant', calldata=G.signature('set(uint256,uint256)') + f'{a:064x}{b:064x}',
                       value=0, before=before, after={**before, '0': hex(a), '1': hex(b)} if success else before,
                       status='success' if success else 'revert', output='0x' + f'{a:064x}' if success else '0x')
            H.compare(f'invariant-{cases}', source, runtime, row)
            cases += 1
        (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=2, erasure=len(variants),
            files={name: hashlib.sha256(data).hexdigest() for name, data in captures[0].items()}), indent=2) + '\n')
    print(f'BUNDLE-LIVE cases={cases} creates=2 erasure={len(variants)} OK', flush=True)
    return cases, len(variants)


def refusals(only=None):
    good = program()
    closed = lambda body: G.program(body + ' ; pure a')
    rows = [
        ('false-first', closed(f'let (0 bundle : Both ({FALSE}) ({TRUE})) := pair((), ())'), 'mismatch'),
        ('false-second', closed(f'let (0 bundle : Both ({TRUE}) ({FALSE})) := pair((), ())'), 'mismatch'),
        ('discarded-second', closed(f'let (0 p : {TRUE}) := first((pair((), ()) : Both ({TRUE}) ({FALSE})))'), 'mismatch'),
        ('discarded-first', closed(f'let (0 p : {TRUE}) := second((pair((), ()) : Both ({FALSE}) ({TRUE})))'), 'mismatch'),
        ('unused-local', closed(f'let (0 p : {TRUE}) := first(pair((), (let (0 q : {FALSE}) := () in ())))'), 'mismatch'),
        ('unused-helper', H.declare(G.program('pure a'),
         f'proof unused : Both ({TRUE}) ({FALSE}) := pair((), ())\n'), 'mismatch'),
        ('generic-helper', H.declare(G.program('pure a'),
         f'proof bad (0 x : Word) : Both (Le x (word 1)) ({TRUE}) := pair((), ())\n'), 'mismatch'),
        ('unit-bundle', good.replace('pair(ordered, fits)', '()'), 'mismatch'),
        ('pair-atomic', good.replace('first(bundle)', 'pair(ordered, ordered)'), 'SURFACE_PROOF'),
        ('wrong-first', good.replace('subLe a b first(bundle)', 'subLe b a first(bundle)'), 'mismatch'),
        ('wrong-second', good.replace('second(bundle)', 'first(bundle)'), 'mismatch'),
        ('reversed-pair', good.replace('pair(ordered, fits)', 'pair(fits, ordered)'), 'mismatch'),
        ('project-unit', good.replace('first(bundle)', 'first(())'), 'SURFACE_PROOF'),
        ('project-atomic', good.replace('first(bundle)', 'first(ordered)'), 'SURFACE_PROOF'),
        ('word-component', good.replace('pair(ordered, fits)', 'pair(a, fits)'), 'SURFACE_PROOF'),
        ('literal-component', good.replace('pair(ordered, fits)', 'pair(word 0, fits)'), 'SURFACE_PROOF'),
        ('word-project', good.replace('first(bundle)', 'first(a)'), 'SURFACE_PROOF'),
        ('unknown-project', good.replace('first(bundle)', 'first(missing)'), 'SURFACE_PROOF'),
        ('runtime-return', good.replace('pure total', 'pure bundle'), 'SURFACE_PROOF'),
        ('runtime-store', good.replace('sstore cell difference', 'sstore cell bundle'), 'SURFACE_PROOF'),
        ('runtime-payload', program(BINDING, 'revert Denied (bundle) (a)'), 'SURFACE_PROOF'),
        ('word-shadow', program(BINDING + 'let bundle : Word := a ; '), 'SURFACE_PROOF'),
        ('claim-shadow', program(BINDING + f'let (0 bundle : {TRUE}) := () ; '), 'SURFACE_PROOF'),
        ('guard-bundle', good.replace('(0 ordered : Le b a)', f'(0 ordered : {CLAIM})'), 'SURFACE_PROOF'),
        ('reload', program(BINDING + 'a <- sload cell ; '), 'mismatch'),
        ('escape-local', program(f'let (0 temporary : {CLAIM}) := (let (0 bundle : {CLAIM}) := pair(ordered, fits) in bundle) ; '), 'SURFACE_PROOF'),
        ('missing-comma', good.replace('pair(ordered, fits)', 'pair(ordered fits)'), 'SURFACE_SYNTAX'),
        ('trailing-comma', good.replace('pair(ordered, fits)', 'pair(ordered, fits,)'), 'SURFACE_SYNTAX'),
        ('extra-component', good.replace('pair(ordered, fits)', 'pair(ordered, fits, ordered)'), 'SURFACE_PROOF'),
        ('missing-component', good.replace('pair(ordered, fits)', 'pair(ordered)'), 'SURFACE_PROOF'),
        ('extra-projection', good.replace('first(bundle)', 'first(bundle, bundle)'), 'SURFACE_PROOF'),
        ('claim-parentheses', good.replace(CLAIM, f'Both {ORDER} ({FITS})'), 'SURFACE_SYNTAX'),
        ('claim-depth', nested(33), 'SURFACE_LIMIT'),
    ]
    rows.extend([
        ('reserved-Both', good.replace('cell', 'Both'), 'SURFACE_NAME'),
        ('shadow-first-operation', program(BINDING + 'let first : Word := a ; '), 'SURFACE_PROOF'),
        ('shadow-second-operation', program(BINDING + f'let (0 second : {TRUE}) := () ; '), 'SURFACE_PROOF'),
        ('shadow-pair-operation', program('let pair : Word := a ; ' + BINDING), 'SURFACE_PROOF'),
    ])
    helper = f'proof take (0 x : Word) (0 p : Both (Le x (word 9)) ({TRUE})) : Le x (word 9) := first(p)\n'
    rows.extend([
        ('argument-claim', H.declare(closed(f'let (0 p : {TRUE}) := take(word 10, pair((), ()))'), helper), 'mismatch'),
        ('argument-discarded', H.declare(closed('let (0 p : Le (word 4) (word 9)) := take(word 4, pair((), (() : Le (word 1) (word 0))))'), helper), 'mismatch'),
        ('word-argument', H.declare(closed(f'let (0 p : {TRUE}) := take(pair((), ()), pair((), ()))'), helper), 'SURFACE_PROOF'),
        ('invariant-stale', invariant().replace('sstore low x', 'x <- sload low ; sstore low x'), 'mismatch'),
    ])
    rows = [row for row in rows if only is None or row[0] == only]
    require(bool(rows), 'BUNDLE-WITNESS unknown ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-bundle-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal(name, text, marker, Path(temporary))
    print(f'BUNDLE-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    forms = [nested(0), nested(1), nested(32),
        program('', ENDING.replace('first(bundle)', '(let (0 p : Both (Le b a) (Lt256 (add a b))) := pair(ordered, fits) in first(p))')
                .replace('second(bundle)', 'second(pair(ordered, fits))')),
        G.program(f'let (0 p : {TRUE}) := first(pair((), ())) ; pure a'),
        program(BINDING + 'let shadow : Word := a ; '),
        H.declare(T.closed(term='pair()'),
                  'proof ahead (0 p : Le (word 0) (word 1)) : '
                  'Both (Le (word 0) (word 1)) (Le (word 0) (word 1)) := pair(p, p)\n'
                  'proof pair : Lt256 (add (word 2) (word 3)) := ()\n'),
        H.declare(G.program('let v : Word := subLe a b first(b, a, p) ; pure v')
                  .replace('do let v', 'do (0 p : Le b a) <- guard (leWord b a) ; let v'),
                  H.ORDER.replace('ordered', 'first')),
        ('contract Names where storage State := { pair : Word }\n'
         'error Saved (first : Word) (second : Word)\n'
         'entry save (a : Word) (b : Word) : Eff Sig Word := do '
         '(0 ordered : Le b a) <- guard Saved (a) (b) (leWord b a) ; '
         '(0 fits : Lt256 (add a b)) <- guard Saved (a) (b) (lt256 (add a b)) ; '
         f'let (0 bundle : {CLAIM}) := pair(ordered, fits) ; '
         'let difference : Word := subLe a b first(bundle) ; '
         'let total : Word := addLt a b second(bundle) ; '
         'sstore pair difference ; pure total'),
        G.program(f'let (0 first : {TRUE}) := () ; let (0 second : {TRUE}) := first ; '
                  f'let (0 pair : Both ({TRUE}) ({TRUE})) := pair(first, second) ; pure a')]
    proof = '()'
    for _ in range(64):
        proof = f'first(pair({proof}, ()))'
    forms.append(G.program(f'let (0 p : {TRUE}) := {proof} ; pure a'))
    with tempfile.TemporaryDirectory(prefix='assay-bundle-boundaries-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(forms):
            source = folder / f'boundary-{index}.asy'
            source.write_text(text)
            P.emit(source, folder / str(index), f'boundary-{index}')
        E.refusal('proof-depth', G.program(f'let (0 p : {TRUE}) := first(pair({proof}, ())) ; pure a'),
                  'SURFACE_LIMIT', folder)
    print(f'BUNDLE-BOUNDARIES accepted={len(forms)} rejected=1 OK', flush=True)
    return len(forms)


def witness(name):
    if name not in ('invariant-components', 'projection-valid'):
        return refusals(name)
    with tempfile.TemporaryDirectory(prefix='assay-bundle-evidence-') as temporary:
        folder = Path(temporary)
        source = folder / 'invariant.asy'
        source.write_text(invariant() if name == 'invariant-components' else program())
        P.emit(source, folder / 'out', name)


def mutants():
    cases = [
        ('SECOND-CHECK', 'let* b_type, b = proof ~erased helpers (depth + 1) env b_type b in',
         'let* b_type, b = proof ~erased helpers (depth + 1) env b_type (let _discarded = b in Proof_unit) in',
         'argument-discarded', 'ERROR-REFUSAL argument-discarded'),
        ('PROJECTION', '(if first then "0" else "1")', '(if first then "1" else "0")',
         'projection-valid', 'M1-TOOL projection-valid'),
        ('CLAIM-DEPTH', 'if depth > 32 then fail (here tokens) "LIMIT" "claim nesting exceeds 32"',
         'if depth > 128 then fail (here tokens) "LIMIT" "claim nesting exceeds 32"',
         'claim-depth', 'ERROR-REFUSAL claim-depth'),
        ('INVARIANT-COMPONENTS', 'evidence_for (project false term) b (evidence_for (project true term) a evidence)',
         'evidence_for term (Atomic (claim_type (Bundle (a, b)))) evidence', 'invariant-components', 'M1-TOOL invariant-components'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-bundle-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'BUNDLE-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'BUNDLE-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/proof-bundle-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and
                        (not mutated or marker in result.stdout), 'BUNDLE-MUTANT ' + label)
            print('BUNDLE-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = {'live': live, 'refusals': refusals, 'boundaries': boundaries, 'mutants': mutants}
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/proof-bundle-test.py [live|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    H.WORK = T.WORK = G.WORK = E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, erased = live()
        invalid, accepted, killed = refusals(), boundaries(), mutants()
        print(f'PROOF-BUNDLES cases={cases} creates=2 refusals={invalid} erasure={erased} boundaries={accepted} mutants={killed} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        print(str(exc))
        sys.exit(1)

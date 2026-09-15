#!/usr/bin/env python3
"""Check named claims, substitution, erasure and storage proofs against Cancun."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/predicates'
spec = importlib.util.spec_from_file_location('predicate_bundles', ROOT / 'dev/proof-bundle-test.py')
B = importlib.util.module_from_spec(spec)
spec.loader.exec_module(B)
H, T, G, E, M, P, C, require = B.H, B.T, B.G, B.E, B.M, B.P, B.C, B.require
BELOW = 'predicate Below (0 x : Word) (0 y : Word) : Prop := Le x y\n'
ROOM = 'predicate Room (0 x : Word) (0 y : Word) : Prop := Lt256 (add x y)\n'
DECLS = BELOW + ROOM + ('predicate Bounds (0 x : Word) (0 y : Word) : Prop := '
                        'Both (Below(y, x)) (Room(x, y))\n')
TRUE, FALSE = B.TRUE, B.FALSE


def closed(definitions=BELOW, claim='Below(word 0, word 1)', term='()'):
    return H.declare(G.program(f'let (0 p : {claim}) := {term} ; pure a'), definitions)


def program():
    return H.declare(B.program().replace('contract ProofBundles', 'contract Predicates')
                     .replace('Both (Le b a) (Lt256 (add a b))', 'Bounds(a, b)')
                     .replace(': Le b a)', ': Below(b, a))')
                     .replace(': Lt256 (add a b))', ': Room(a, b))'), DECLS)


def invariant():
    return (B.invariant().replace('Le s.low s.high', 'Below(s.low, s.high)')
            .replace('Lt256 (add s.low s.high)', 'Room(s.low, s.high)')
            .replace('Both (Le x y) (Lt256 (add x y))', 'StateBounds(x, y)')
            .replace(': Le a b)', ': Below(a, b))')
            .replace(': Lt256 (add a b))', ': Room(a, b))') + '\n' + DECLS +
            'predicate StateBounds (0 x : Word) (0 y : Word) : Prop := Both (Below(x, y)) (Room(x, y))\n')


def live():
    base = B.program().replace('contract ProofBundles', 'contract Predicates')
    named = program()
    variants = [base, named, (ROOT / 'examples/Predicates.asy').read_text(),
        named.replace(':= pair(ordered, fits) ;',
                      ':= (let (0 local : Bounds(a, b)) := pair(ordered, fits) in local) ;'),
        named.replace(':= pair(ordered, fits) ;', ':= (pair(ordered, fits) : Bounds(a, b)) ;')]
    captures, cases = [], 0
    with tempfile.TemporaryDirectory(prefix='assay-predicate-live-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(variants):
            source, output = folder / f'variant-{index}.asy', folder / str(index)
            source.write_text(text)
            runtime, init = P.emit(source, output, f'predicate-{index}')
            captures.append(H.outputs(output))
            if index == 2:
                E.creation(runtime, init, folder)
                abi = json.loads(captures[-1]['abi.json'])
                require([(r['name'], len(r['inputs'])) for r in abi if r['type'] == 'function'] == [('mix', 2)],
                        'PREDICATE-ABI erased')
            for a, b in G.PAIRS:
                row = B.matrix_row(a, b, G.signature('mix(uint256,uint256)'), G.signature('Denied(uint256,uint256)'))
                H.compare(f'predicate-{index}-{cases}', source, runtime, row)
                cases += 1
        require(all(row == captures[0] for row in captures), 'PREDICATE-ERASURE five files')
        invariant_outputs = []
        for index, text in enumerate([B.invariant(), invariant()]):
            source = folder / f'invariant-{index}.asy'
            source.write_text(text)
            output = folder / f'invariant-{index}'
            runtime, _init = P.emit(source, output, f'invariant-{index}')
            invariant_outputs.append(H.outputs(output))
            for a, b in [(0, 0), (4, 9), (9, 4), (0, G.MAX), (1, G.MAX), (G.MAX, G.MAX)]:
                success = a <= b and a + b <= G.MAX
                before = {'0': '0x2', '1': '0x8', '2': '0xabc'}
                row = dict(name='invariant', calldata=G.signature('set(uint256,uint256)') + f'{a:064x}{b:064x}',
                           value=0, before=before, after={**before, '0': hex(a), '1': hex(b)} if success else before,
                           status='success' if success else 'revert', output='0x' + f'{a:064x}' if success else '0x')
                H.compare(f'invariant-{index}-{cases}', source, runtime, row)
                cases += 1
        require(invariant_outputs[0] == invariant_outputs[1], 'PREDICATE-INVARIANT-ERASURE five files')
        hashes = lambda rows: [{name: hashlib.sha256(data).hexdigest() for name, data in row.items()} for row in rows]
        (WORK / 'ERASURE.json').write_text(json.dumps(dict(programs=hashes(captures),
            invariants=hashes(invariant_outputs)), indent=2) + '\n')
    (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=cases, creates=2, erasure=len(variants) + 2), indent=2) + '\n')
    print(f'PREDICATE-LIVE cases={cases} creates=2 erasure={len(variants) + 2} OK', flush=True)
    return cases, len(variants) + 2


def chain(count):
    return f'predicate P0 : Prop := {TRUE}\n' + ''.join(
        f'predicate P{i} : Prop := P{i-1}()\n' for i in range(1, count))


def tree(depth):
    return f'predicate P0 : Prop := {TRUE}\n' + ''.join(
        f'predicate P{i} : Prop := Both (P{i-1}()) (P{i-1}())\n' for i in range(1, depth + 1))


def refusals(only=None):
    const = f'predicate Always (0 x : Word) : Prop := {TRUE}\n'
    rows = [
        ('false', closed(claim='Below(word 1, word 0)'), 'mismatch'),
        ('false-component', closed(f'predicate Bad : Prop := Both ({TRUE}) ({FALSE})\n', TRUE,
                                  'first((pair((), ()) : Bad()))'), 'mismatch'),
        ('guard-order', program().replace(': Below(b, a)', ': Below(a, b)'), 'mismatch'),
        ('unknown', closed(claim='Missing(word 0, word 1)'), 'SURFACE_PREDICATE'),
        ('unused-declaration', closed('predicate Bad : Prop := Missing()\n' + BELOW), 'SURFACE_PREDICATE'),
        ('unbound-definition', closed('predicate Bad : Prop := Le missing (word 1)\n' + BELOW), 'SURFACE_SCOPE'),
        ('forward', closed('predicate First : Prop := Later()\npredicate Later : Prop := ' + TRUE + '\n' + BELOW), 'SURFACE_PREDICATE'),
        ('recursive', closed('predicate Loop : Prop := Loop()\n' + BELOW), 'SURFACE_PREDICATE'),
        ('mutual', closed('predicate Left : Prop := Right()\npredicate Right : Prop := Left()\n' + BELOW), 'SURFACE_PREDICATE'),
        ('few-arguments', closed(claim='Below(word 0)'), 'SURFACE_PREDICATE'),
        ('many-arguments', closed(claim='Below(word 0, word 1, word 2)'), 'SURFACE_PREDICATE'),
        ('empty-arguments', closed(claim='Below()'), 'SURFACE_PREDICATE'),
        ('unused-argument', closed(const, 'Always(missing)'), 'SURFACE_SCOPE'),
        ('unused-proof-argument', H.declare(G.program(f'let (0 q : {TRUE}) := () ; '
             'let (0 p : Always(q)) := () ; pure a'), const), 'SURFACE_PROOF'),
        ('unused-nested-argument', closed(const + 'predicate Outer : Prop := Always(missing)\n' + BELOW), 'SURFACE_SCOPE'),
        ('quantity', closed(BELOW.replace('(0 x', '(1 x')), 'SURFACE_SYNTAX'),
        ('parameter-type', closed(BELOW.replace('x : Word', 'x : Le (word 0) (word 1)')), 'SURFACE_SYNTAX'),
        ('duplicate-parameter', closed(BELOW.replace('(0 y : Word)', '(0 x : Word)')), 'SURFACE_DUPLICATE'),
        ('duplicate', closed(BELOW + BELOW), 'SURFACE_DUPLICATE'),
        ('global-field', closed(BELOW.replace('Below', 'cell')), 'SURFACE_DUPLICATE'),
        ('global-entry', closed(BELOW.replace('Below', 'mix')), 'SURFACE_DUPLICATE'),
        ('global-helper', closed(BELOW + f'proof Below : {TRUE} := ()\n'), 'SURFACE_DUPLICATE'),
        ('global-argument', closed(BELOW.replace('Below', 'a')), 'SURFACE_DUPLICATE'),
        ('reserved', closed(BELOW.replace('Below', 'predicate')), 'SURFACE_NAME'),
        ('word-shadow', closed().replace('do let (0 p', 'do let Below : Word := a ; let (0 p'), 'SURFACE_PREDICATE'),
        ('proof-shadow', closed().replace('do let (0 p', f'do let (0 Below : {TRUE}) := () ; let (0 p'), 'SURFACE_PREDICATE'),
        ('local-helper-shadow', closed(BELOW + 'proof bad (0 Below : Word) : Below(word 0, word 1) := ()\n'), 'SURFACE_PREDICATE'),
        ('predicate-as-proof', closed(term='Below(word 0, word 1)'), 'SURFACE_PROOF'),
        ('predicate-as-word', closed().replace('pure a', 'pure Below'), 'SURFACE_SCOPE'),
        ('trailing-comma', closed(claim='Below(word 0, word 1,)'), 'SURFACE_NAME'),
        ('leading-comma', closed(claim='Below(,word 0, word 1)'), 'SURFACE_NAME'),
        ('nested-word-call', closed(claim='Below(Below(word 0, word 1), word 1)'), 'SURFACE_SYNTAX'),
        ('guard-bundle', program().replace(': Below(b, a)', ': Bounds(a, b)'), 'SURFACE_PROOF'),
        ('invariant-bundle', invariant().replace('Below(s.low, s.high)', 'Bounds(s.high, s.low)'), 'SURFACE_INVARIANT'),
        ('constructor', invariant() + '\nconstructor := do sstore low (word 1) ; pure ()', 'mismatch'),
        ('final-state', invariant().replace('sstore low x', 'sstore low b'), 'mismatch'),
        ('reload', invariant().replace('sstore low x', 'x <- sload low ; sstore low x'), 'mismatch'),
        ('invariant-field', invariant().replace('s.low, s.high', 's.missing, s.high'), 'SURFACE_SLOT'),
        ('invariant-snapshot', invariant().replace('s.low, s.high', 'old.low, s.high'), 'SURFACE_INVARIANT'),
        ('parameters-limit', closed('predicate Wide ' + ' '.join(f'(0 w{i} : Word)' for i in range(17)) + ' : Prop := ' + TRUE + '\n' + BELOW), 'SURFACE_LIMIT'),
        ('arguments-limit', closed(claim='Below(' + ', '.join('word 0' for _ in range(17)) + ')'), 'SURFACE_LIMIT'),
        ('members-limit', closed(chain(33), 'P0()'), 'SURFACE_LIMIT'),
        ('expanded-depth', closed(chain(32), f'Both ({TRUE}) (P31())', 'pair((), ())'), 'SURFACE_LIMIT'),
        ('expanded-nodes', closed(tree(11), 'P0()'), 'SURFACE_LIMIT'),
    ]
    if only is not None:
        rows = [row for row in rows if row[0] == only]
        require(len(rows) == 1, 'PREDICATE-WITNESS ' + only)
    with tempfile.TemporaryDirectory(prefix='assay-predicate-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal(name, text, marker, Path(temporary))
    print(f'PREDICATE-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    wide = 'predicate Wide ' + ' '.join(f'(0 w{i} : Word)' for i in range(16)) + ' : Prop := Le w0 w15\n'
    forms = [closed(), closed(f'predicate Truth : Prop := {TRUE}\n', 'Truth()'),
        closed(BELOW + f'predicate Unused : Prop := {FALSE}\n'),
        closed(chain(32), 'P31()'), closed(tree(10), 'P0()'),
        closed(wide, 'Wide(' + ', '.join(f'word {i}' for i in range(16)) + ')'),
        closed().replace('Below(word 0, word 1)', 'Below((word 0), (word 1))'),
        closed().replace(BELOW, '') + '\n' + BELOW,
        closed(BELOW + 'proof copied (0 x : Word) (0 y : Word) (0 p : Below(x, y)) : Below(x, y) := p\n',
               term='copied(word 0, word 1, ())'),
        closed(BELOW + 'predicate Flipped (0 y : Word) (0 x : Word) : Prop := Below(x, y)\n',
               'Flipped(word 1, word 0)'),
        closed().replace('pure a', 'let Below : Word := a ; pure Below'),
        closed('predicate pair (0 x : Word) (0 y : Word) : Prop := Le x y\n', 'pair(word 0, word 1)')]
    with tempfile.TemporaryDirectory(prefix='assay-predicate-boundaries-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(forms):
            source = folder / f'boundary-{index}.asy'
            source.write_text(text)
            P.emit(source, folder / str(index), f'boundary-{index}')
    print(f'PREDICATE-BOUNDARIES accepted={len(forms)} OK', flush=True)
    return len(forms)


def witness(name):
    if name != 'argument-order':
        return refusals(name)
    with tempfile.TemporaryDirectory(prefix='assay-predicate-order-') as temporary:
        folder = Path(temporary)
        source = folder / 'order.asy'
        source.write_text(closed())
        P.emit(source, folder / 'out', name)


def mutants():
    cases = [
        ('UNUSED-DECLARATION', 'let* _ty = resolved_claim earlier env row.definition in Ok (row :: earlier)',
         'let* _ty = (let _unused = env in Ok (Atomic "(prod ())")) in Ok (row :: earlier)',
         'unused-declaration', 'ERROR-REFUSAL unused-declaration'),
        ('UNUSED-ARGUMENT', 'let* v = word env arg in arguments ((name.text, Word_value v) :: substitution) parameters args',
         'let* v = (let _unused = arg in Ok "(word 256 0)") in arguments ((name.text, Word_value v) :: substitution) parameters args',
         'unused-argument', 'ERROR-REFUSAL unused-argument'),
        ('ARGUMENT-ORDER', 'arguments [] row.words args', 'arguments [] row.words (List.rev args)',
         'argument-order', 'M1-TOOL argument-order'),
        ('EXPANSION', 'remaining = 0', 'remaining = min_int',
         'expanded-nodes', 'ERROR-REFUSAL expanded-nodes'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-predicate-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework',
            '.kanon-exec', '.kanon-wait', '.kanon-replies', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'PREDICATE-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'PREDICATE-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/predicate-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'PREDICATE-MUTANT ' + label)
            print('PREDICATE-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = {'live': live, 'refusals': refusals, 'boundaries': boundaries, 'mutants': mutants}
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/predicate-test.py [live|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    B.WORK = H.WORK = T.WORK = G.WORK = E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, erased = live()
        invalid, accepted, killed = refusals(), boundaries(), mutants()
        print(f'PREDICATES cases={cases} creates=2 refusals={invalid} erasure={erased} boundaries={accepted} mutants={killed} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as exc:
        print('PREDICATES-FAIL ' + str(exc))
        sys.exit(1)

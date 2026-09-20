#!/usr/bin/env python3
"""Check inferred helper arguments, lexical evidence and erased Cancun output."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/inferred-helpers'
spec = importlib.util.spec_from_file_location('inferred_arithmetic', ROOT / 'dev/inferred-arithmetic-test.py')
IA = importlib.util.module_from_spec(spec)
spec.loader.exec_module(IA)
IG, NG, Q, I, N, B, H, T, G, E, M, P, C, require = (
    IA.IG, IA.NG, IA.Q, IA.I, IA.N, IA.B, IA.H, IA.T, IA.G, IA.E, IA.M, IA.P, IA.C, IA.require)


def forms():
    rows = []
    for op in ('add', 'sub'):
        helper, args, claim = ('fits', 'a, b', 'Lt256 (add a b)') if op == 'add' else ('ordered', 'b, a', 'Le b a')
        explicit = H.guarded(op)
        inferred = explicit.replace(f'{helper}({args}, p)', f'{helper}({args})')
        rows.append(('named-' + op, inferred, explicit, op, 'custom'))
        rows.append(('anonymous-' + op, inferred.replace(f'(0 p : {claim}) <- ', ''), explicit, op, 'custom'))
        shadow = inferred.replace('let v : Word', 'let p : Word := (word 4) ; let v : Word')
        saved = shadow.replace('(0 p :', '(0 saved :').replace(f'{helper}({args})', f'{helper}({args}, saved)')
        rows.append(('shadow-' + op, shadow, saved, op, 'custom'))
        ty = 'Lt256 (add x y)' if op == 'add' else 'Le x y'
        relay = f'proof relay (0 x : Word) (0 y : Word) (0 q : {ty}) : {ty} := {helper}(x, y)\n'
        generic = H.declare(H.guarded(op, f'relay({args}, p)'), relay)
        rows.append(('helper-body-' + op, generic, generic.replace(f'{helper}(x, y)', f'{helper}(x, y, q)'), op, 'custom'))
        nested = H.guarded(op, f'{helper}({args}, {helper}({args}))')
        rows.append(('nested-' + op, nested, explicit, op, 'custom'))
        local_claim = 'Lt256 (add alias b)' if op == 'add' else 'Le b alias'
        local_args = args.replace('a', 'alias')
        local = H.guarded(op, f'(let (0 local : {local_claim}) := p in {helper}({local_args}))')
        local = local.replace('let v : Word', 'let alias : Word := a ; let v : Word')
        rows.append(('proof-local-' + op, local, local.replace(f'{helper}({local_args})', f'{helper}({local_args}, local)'), op, 'custom'))

    repeated = ('proof repeat (0 x : Word) (0 y : Word) (0 q : Lt256 (add x y)) '
                '(0 r : Lt256 (add x y)) : Lt256 (add x y) := r\n')
    supplied = H.declare(H.guarded('add', 'repeat(alias, b, p)'), repeated)
    supplied = supplied.replace('let v : Word', 'let alias : Word := a ; let v : Word')
    rows.append(('supplied-evidence', supplied, supplied.replace('repeat(alias, b, p)', 'repeat(alias, b, p, p)'), 'add', 'custom'))

    helper = ('proof certify (0 x : Word) (0 y : Word) (0 p : Le x y) '
              '(0 q : Lt256 (add x y)) : Both (Le x y) (Lt256 (add x y)) := pair(p, q)\n')
    for name, guard, definitions, first, second in [
        ('bundle', Q.guard(), '', 'first(bounds)', 'second(bounds)'),
        ('named', Q.guard('Bounds(a, b)', 'Bounds(a, b)'), NG.BOUND, 'first(bounds)', 'second(bounds)'),
        ('nested-bundle', Q.guard(f'Both (Le a b) ({Q.CLAIM})', f'both (leWord a b) ({Q.CONDITION})'), '',
         'first(second(bounds))', 'second(second(bounds))'),
        ('separate', Q.guard('Le a b', 'leWord a b', name='ordered') +
         Q.guard('Lt256 (add a b)', 'lt256 (add a b)', name='fits'), '', 'ordered', 'fits'),
    ]:
        tail = (f'let (0 checked : {Q.CLAIM}) := certify(a, b) ; '
                'let d : Word := subLe b a first(checked) ; let total : Word := addLt a b second(checked) ; '
                'sstore low d ; sstore high total ; pure d')
        inferred = Q.program(guard, definitions=definitions + helper, tail=tail)
        rows.append((name, inferred, inferred.replace('certify(a, b)', f'certify(a, b, {first}, {second})'), 'bundle', 'custom'))

    whole = ('proof certify (0 x : Word) (0 y : Word) (0 p : Bounds(x, y)) : Bounds(x, y) := p\n')
    bundled = Q.program(Q.guard(), definitions=NG.BOUND + whole,
        tail='let (0 checked : Bounds(a, b)) := certify(a, b) ; '
             'let d : Word := subLe b a first(checked) ; let total : Word := addLt a b second(checked) ; '
             'sstore low d ; sstore high total ; pure d')
    rows.append(('whole-bundle', bundled, bundled.replace('certify(a, b)', 'certify(a, b, bounds)'), 'bundle', 'custom'))
    split = bundled.replace(Q.guard(), Q.guard('Le a b', 'leWord a b', name='ordered') +
                            Q.guard('Lt256 (add a b)', 'lt256 (add a b)', name='fits'))
    rows.append(('assembled-bundle', split, split.replace('certify(a, b)', 'certify(a, b, pair(ordered, fits))'), 'bundle', 'custom'))

    snapshot = H.guarded('sub').replace('sstore cell (word 9)', 'a <- sload cell ; sstore cell (word 9)')
    rows.append(('snapshot', snapshot.replace('ordered(b, a, p)', 'ordered(b, a)'), snapshot, 'snapshot', 'custom'))
    for op, a, b, name, declaration in [('add', 2, 3, 'fits', H.FITS), ('sub', 5, 3, 'ordered', H.ORDER)]:
        args = f'word {a}, word {b}' if op == 'add' else f'word {b}, word {a}'
        explicit = H.declare(T.closed(op, a, b, term=f'{name}({args}, ())'), declaration)
        rows.append(('closed-' + op, explicit.replace(f'{name}({args}, ())', f'{name}({args})'), explicit, 'closed-' + op, 'custom'))
    interleaved = f'proof relay (0 q : {H.TRUE}) (0 x : Word) (0 y : Word) (0 p : Lt256 (add x y)) : Lt256 (add x y) := p\n'
    mixed = H.declare(H.guarded('add', 'relay((), a, b)'), interleaved)
    rows.append(('interleaved', mixed, mixed.replace('relay((), a, b)', 'relay((), a, b, p)'), 'add', 'custom'))
    example = (ROOT / 'examples/InferredHelpers.asy').read_text()
    explicit = example.replace('fits(c, n)', 'fits(c, n, p)').replace('ordered(n, c)', 'ordered(n, c, p)')
    explicit = explicit.replace('guard OverflowRevert', '(0 p : Lt256 (add c n)) <- guard OverflowRevert')
    explicit = explicit.replace('guard UnderflowRevert', '(0 p : Le n c) <- guard UnderflowRevert')
    rows.append(('counter', example, explicit, 'counter', 'custom'))
    return rows


def negative_cases():
    good = H.guarded('add', 'fits(a, b)')
    no_guard = H.declare(G.program('let v : Word := addLt a b fits(a, b) ; pure v'), H.FITS)
    discard = f'proof discard (0 x : Word) (0 y : Word) (0 p : Lt256 (add x y)) : {H.TRUE} := ()\n'
    unused = H.declare(G.program(f'let (0 q : {H.TRUE}) := discard(a, b) ; pure a'), discard)
    bad_generic = H.FITS + 'proof relay (0 x : Word) (0 y : Word) : Lt256 (add x y) := fits(x, y)\n'
    false_local = good.replace('fits(a, b)', '(let (0 q : Le (word 1) (word 0)) := () in fits(a, b))')
    local_scope = H.guarded('add', 'second(pair((let (0 q : Lt256 (add alias b)) := p in fits(alias, b)), fits(alias, b)))')
    local_scope = local_scope.replace('let v : Word', 'let alias : Word := a ; let v : Word')
    argument_scope = H.guarded('add', 'second(pair(fits(alias, b, p), fits(alias, b)))')
    argument_scope = argument_scope.replace('let v : Word', 'let alias : Word := a ; let v : Word')
    trailing_word = H.declare(G.program('let (0 p : Le a a) := trailing(a) ; pure a'),
        'proof trailing (0 x : Word) (0 p : Le x x) (0 y : Word) : Le x x := p\n')
    return [
        ('missing-evidence', no_guard, 'mismatch'),
        ('unused-argument', unused, 'mismatch'),
        ('reverting-tail', no_guard.replace('pure v', 'revert'), 'mismatch'),
        ('wrong-order', H.guarded('sub', 'ordered(a, b)'), 'mismatch'),
        ('different-operands', good.replace('fits(a, b)', 'fits(a, a)'), 'mismatch'),
        ('rebound-word', good.replace('let v : Word', 'let a : Word := (word 1) ; let v : Word'), 'mismatch'),
        ('reloaded-word', good.replace('let v : Word', 'a <- sload cell ; let v : Word'), 'mismatch'),
        ('alias-search', good.replace('let v : Word', 'let alias : Word := a ; let v : Word').replace('fits(a, b)', 'fits(alias, b)'), 'mismatch'),
        ('explicit-invalid', H.guarded('add', 'fits(a, b, ())'), 'mismatch'),
        ('explicit-unknown', H.guarded('add', 'fits(a, b, missing)'), 'SURFACE_PROOF'),
        ('missing-word', good.replace('fits(a, b)', 'fits(a)'), 'SURFACE_PROOF'),
        ('extra-argument', good.replace('fits(a, b)', 'fits(a, b, p, p)'), 'SURFACE_PROOF'),
        ('proof-as-word', good.replace('fits(a, b)', 'fits(p, b)'), 'SURFACE_PROOF'),
        ('word-as-proof', good.replace('fits(a, b)', 'fits(a, b, a)'), 'SURFACE_PROOF'),
        ('false-local', false_local, 'mismatch'),
        ('generic-body', H.declare(G.program('pure a'), bad_generic), 'mismatch'),
        ('overflow', H.declare(T.closed('add', G.MAX, 1, term=f'fits(word {G.MAX}, word 1)'), H.FITS), 'mismatch'),
        ('underflow', H.declare(T.closed('sub', 0, 1, term='ordered(word 1, word 0)'), H.ORDER), 'mismatch'),
        ('future-evidence', no_guard.replace('pure v', 'guard (lt256 (add a b)) ; pure v'), 'mismatch'),
        ('entry-scope', good + 'entry other (a : Word) (b : Word) : Eff Sig Word := do let v : Word := addLt a b fits(a, b) ; pure v\n', 'mismatch'),
        ('local-scope', local_scope, 'mismatch'),
        ('argument-scope', argument_scope, 'mismatch'),
        ('trailing-word', trailing_word, 'SURFACE_PROOF'),
        ('legacy-guard', no_guard.replace('let v : Word', 'guard le b a ; let v : Word'), 'mismatch'),
        ('helper-shadow', good.replace('let v : Word', 'let fits : Word := a ; let v : Word'), 'SURFACE_PROOF'),
        ('partial-bundle', next(row[1] for row in forms() if row[0] == 'whole-bundle').replace(Q.guard(), Q.guard('Le a b', 'leWord a b')), 'mismatch'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'IH-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-inferred-helper-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('ih-' + name, text, marker, Path(temporary))
    print(f'IH-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    parameters = ' '.join(f'(0 p{i} : {H.TRUE})' for i in range(16))
    helper = f'proof many {parameters} : {H.TRUE} := p15\n'
    text = H.declare(G.program(f'let (0 p : {H.TRUE}) := many() ; pure a'), helper)
    with tempfile.TemporaryDirectory(prefix='assay-inferred-helper-boundaries-') as temporary:
        folder = Path(temporary)
        for name, call in [('inferred', 'many()'), ('explicit', 'many(' + ', '.join(['()'] * 16) + ')')]:
            source = folder / f'{name}.asy'
            source.write_text(text.replace('many()', call))
            P.emit(source, folder / name, name)
        require(H.outputs(folder / 'inferred') == H.outputs(folder / 'explicit'), 'IH-BOUNDARY erasure')
        E.refusal('ih-boundary-false', text.replace(f'(0 p15 : {H.TRUE})', '(0 p15 : Le (word 1) (word 0))').replace(':= p15', ':= p0'), 'mismatch', folder)
        helper = f'proof echo (0 p : {H.TRUE}) (0 q : {H.TRUE}) : {H.TRUE} := q\n'
        sizes = []
        for depth in (4, 8, 16, 128):
            term = 'echo(' * depth + '()' + ')' * depth
            source = folder / f'nested-{depth}.asy'
            source.write_text(H.declare(G.program(f'let (0 q : {H.TRUE}) := {term} ; pure a'), helper))
            result = M.capture(f'nested-{depth}', [P.BINARY, 'check', '--print', source])
            require(result.returncode == 0 and not result.stderr, 'IH-NESTED check')
            size = len(result.stdout.encode())
            require(size < 65536 + 2048 * depth and (not sizes or depth == 128 or size <= 4 * sizes[-1]['core_bytes']),
                    'IH-NESTED proof expression growth')
            sizes.append(dict(depth=depth, core_bytes=size, source_sha256=hashlib.sha256(source.read_bytes()).hexdigest()))
            P.emit(source, folder / f'nested-{depth}', f'nested-{depth}')
            require(H.outputs(folder / 'inferred') == H.outputs(folder / f'nested-{depth}'), 'IH-NESTED erasure')
    (WORK / 'BOUNDARIES.json').write_text(json.dumps(dict(parameters=16, nested=sizes, positive=6, negative=1), indent=2) + '\n')
    print('IH-BOUNDARIES parameters=16 nested=128 positive=6 negative=1 OK', flush=True)
    return 6


def witness(name):
    if name == 'boundaries':
        return boundaries()
    return refusals(name) if name == 'explicit-invalid' else IA.live(name)


def mutants():
    cases = [
        ('EVIDENCE', 'let v = "(" ^ invariant_proof evidence ty ^ " : " ^ claim_type ty ^ ")" in',
         'let v = "(" ^ invariant_proof [] ty ^ " : " ^ claim_type ty ^ ")" in', 'anonymous-add', 'M1-TOOL anonymous-add'),
        ('LOCAL', '~evidence:(evidence_for fresh claim evidence)', '~evidence', 'proof-local-add', 'M1-TOOL proof-local-add'),
        ('PARAMETER', 'proof ~erased:false ~evidence helpers 0 env (Some ty) row.proof_body',
         'proof ~erased:false ~evidence:[] helpers 0 env (Some ty) row.proof_body', 'helper-body-add', 'M1-TOOL helper-body-add'),
        ('SUPPLIED', 'let* _ty, v = proof ~erased ~evidence helpers (depth + 1) env (Some ty) arg in',
         'let* _ty, v = let _ = arg in Ok (ty, invariant_proof evidence ty) in', 'explicit-invalid', 'ERROR-REFUSAL ih-explicit-invalid'),
        ('SHARING', 'let fresh = "_assay_arg" ^ string_of_int depth ^ "_" ^ string_of_int (List.length values) in\n'
         '          arguments substitution (fresh :: values) (evidence_for fresh ty evidence)\n'
         '            ((fresh, ty, value) :: bindings) parameters args',
         'arguments substitution (value :: values) (evidence_for value ty evidence) bindings parameters args',
         'boundaries', 'IH-NESTED proof expression growth'),
    ]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-helper-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'IH-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'IH-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/inferred-helper-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout), 'IH-MUTANT ' + label)
                captures.append(dict(name=label, witness=case, expected_marker=marker,
                    returncode=result.returncode, source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('IH-MUTANT ' + name + ' killed control=OK', flush=True)
    (WORK / 'MUTANTS.json').write_text(json.dumps(captures, indent=2) + '\n')
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=IA.live, erasure=IA.erasure, refusals=refusals, boundaries=boundaries, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/inferred-helper-test.py [live|erasure|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (IA, IG, NG, Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    IA.forms = forms
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, creates = IA.live()
        erased, invalid, limits, killed = IA.erasure(), refusals(), boundaries(), mutants()
        print(f'INFERRED-HELPERS cases={cases} creates={creates} refusals={invalid} '
              f'erasure_pairs={erased} boundaries={limits} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (RuntimeError, OSError, ValueError) as error:
        print('INFERRED-HELPERS FAIL ' + str(error), flush=True)
        sys.exit(1)

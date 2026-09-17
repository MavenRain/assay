#!/usr/bin/env python3
"""Check contextual proof placeholders, their scope, and erased Cancun output."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/proof-holes'
spec = importlib.util.spec_from_file_location('inferred_helpers', ROOT / 'dev/inferred-helper-test.py')
IH = importlib.util.module_from_spec(spec)
spec.loader.exec_module(IH)
IA, IG, NG, Q, I, N, B, H, T, G, E, M, P, C, require = (
    IH.IA, IH.IG, IH.NG, IH.Q, IH.I, IH.N, IH.B, IH.H, IH.T, IH.G, IH.E, IH.M, IH.P, IH.C, IH.require)
REPEAT = ('proof repeat (0 x : Word) (0 y : Word) (0 q : Lt256 (add x y)) '
          '(0 r : Lt256 (add x y)) : Lt256 (add x y) := r\n')


def forms():
    rows = []
    for op in ('add', 'sub'):
        helper, args, ty = ('fits', 'a, b', 'Lt256 (add x y)') if op == 'add' else ('ordered', 'b, a', 'Le x y')
        explicit = H.guarded(op)
        hole = explicit.replace(f'{helper}({args}, p)', f'{helper}({args}, _)')
        rows.append(('helper-' + op, hole, explicit, op, 'custom'))
        rows.append(('arithmetic-' + op, H.guarded(op, '_'), explicit, op, 'custom'))
        binding = H.guarded(op, 'q').replace('let v : Word', f'let (0 q : {T.claim(op)}) := _ ; let v : Word')
        rows.append(('binding-' + op, binding, binding.replace(':= _ ;', ':= p ;'), op, 'custom'))
        generic = explicit.replace(f': {ty} := q', f': {ty} := _')
        rows.append(('helper-body-' + op, generic, explicit, op, 'custom'))
        local_claim = 'Lt256 (add alias b)' if op == 'add' else 'Le b alias'
        local = H.guarded(op, f'{helper}({args.replace("a", "alias")}, (let (0 q : {local_claim}) := p in _))')
        local = local.replace('let v : Word', 'let alias : Word := a ; let v : Word')
        rows.append(('local-' + op, local, local.replace('in _)', 'in q)'), op, 'custom'))
        a, b = (2, 3) if op == 'add' else (5, 3)
        rows.append(('closed-' + op, T.closed(op, a, b, term='_'), T.closed(op, a, b), 'closed-' + op, 'custom'))

    interleaved = ('proof relay (0 x : Word) (0 y : Word) (0 q : Lt256 (add x y)) '
                   '(0 z : Word) (0 r : Lt256 (add x y)) : Lt256 (add x y) := r\n')
    mixed = H.declare(H.guarded('add', 'relay(a, b, _, word 7, p)'), interleaved)
    rows.append(('interleaved', mixed, mixed.replace('_, word 7', 'p, word 7'), 'add', 'custom'))
    omitted = mixed.replace('word 7, p)', 'word 7)')
    rows.append(('hole-and-omission', omitted, mixed.replace('_, word 7', 'p, word 7'), 'add', 'custom'))
    supplied = H.declare(H.guarded('add', 'repeat(alias, b, p, _)'), REPEAT)
    supplied = supplied.replace('let v : Word', 'let alias : Word := a ; let v : Word')
    rows.append(('supplied-evidence', supplied, supplied.replace('p, _)', 'p, p)'), 'add', 'custom'))
    snapshot = H.guarded('sub', '_').replace('sstore cell (word 9)', 'a <- sload cell ; sstore cell (word 9)')
    rows.append(('snapshot', snapshot, snapshot.replace('subLe a b _', 'subLe a b p'), 'snapshot', 'custom'))
    shadow = H.guarded('add', '_').replace('let v : Word', 'let p : Word := a ; let v : Word')
    saved = shadow.replace('(0 p :', '(0 saved :').replace('addLt a b _', 'addLt a b saved')
    rows.append(('shadow', shadow, saved, 'add', 'custom'))

    for name, claim, guard, term, explicit, definitions in [
        ('bundle', Q.CLAIM, Q.guard(), '_', 'bounds', ''),
        ('pair', Q.CLAIM, Q.guard(), 'pair(_, _)', 'pair(first(bounds), second(bounds))', ''),
        ('named', 'Bounds(a, b)', Q.guard(), '_', 'bounds', NG.BOUND),
        ('assembled', Q.CLAIM, Q.guard('Le a b', 'leWord a b', name='ordered') +
         Q.guard('Lt256 (add a b)', 'lt256 (add a b)', name='fits'), '_', 'pair(ordered, fits)', ''),
    ]:
        tail = (f'let (0 checked : {claim}) := {term} ; '
                'let d : Word := subLe b a first(checked) ; let total : Word := addLt a b second(checked) ; '
                'sstore low d ; sstore high total ; pure d')
        hole = Q.program(guard, definitions=definitions, tail=tail)
        rows.append((name, hole, hole.replace(f':= {term} ;', f':= {explicit} ;'), 'bundle', 'custom'))
    projection = Q.program(Q.guard(), tail=f'let d : Word := subLe b a first((_ : {Q.CLAIM})) ; '
        'let total : Word := addLt a b second(bounds) ; sstore low d ; sstore high total ; pure d')
    rows.append(('annotated-projection', projection, projection.replace(f'(_ : {Q.CLAIM})', 'bounds'), 'bundle', 'custom'))
    example = (ROOT / 'examples/ProofHoles.asy').read_text()
    explicit = example.replace(':= _\n', ':= p\n').replace('_, c, n', '(), c, n').replace('_, n, c', '(), n, c')
    explicit = explicit.replace('c, n, _)', 'c, n, p)').replace('n, c, _)', 'n, c, p)')
    explicit = explicit.replace('guard OverflowRevert', '(0 p : Lt256 (add c n)) <- guard OverflowRevert')
    explicit = explicit.replace('guard UnderflowRevert', '(0 p : Le n c) <- guard UnderflowRevert')
    rows.append(('counter', example, explicit, 'counter', 'custom'))
    return rows


def negative_cases():
    good = H.guarded('add', 'fits(a, b, _)')
    unguarded = H.declare(G.program('let v : Word := addLt a b fits(a, b, _) ; pure v'), H.FITS)
    discard = f'proof discard (0 x : Word) (0 y : Word) (0 q : Lt256 (add x y)) : {H.TRUE} := ()\n'
    unused = H.declare(G.program(f'let (0 q : {H.TRUE}) := discard(a, b, _) ; pure a'), discard)
    alias = 'let alias : Word := a ; let v : Word'
    future = H.declare(H.guarded('add', 'repeat(alias, b, _, p)'), REPEAT).replace('let v : Word', alias)
    sibling = H.guarded('add', 'second(pair((let (0 q : Lt256 (add alias b)) := p in q), fits(alias, b, _)))')
    sibling = sibling.replace('let v : Word', alias)
    bundle = next(row[1] for row in forms() if row[0] == 'bundle')
    return [
        ('missing-evidence', unguarded, 'mismatch'),
        ('unused-argument', unused, 'mismatch'),
        ('reverting-tail', unused.replace('pure a', 'revert'), 'mismatch'),
        ('unused-binding', G.program('let (0 q : Le (word 1) (word 0)) := _ ; pure a'), 'mismatch'),
        ('unused-helper', H.declare(G.program('pure a'), 'proof bad : Le (word 1) (word 0) := _\n'), 'mismatch'),
        ('generic-body', H.declare(G.program('pure a'), 'proof bad (0 x : Word) (0 y : Word) : Le x y := _\n'), 'mismatch'),
        ('wrong-order', H.guarded('sub', 'ordered(a, b, _)'), 'mismatch'),
        ('rebound-word', good.replace('let v : Word', 'let a : Word := (word 1) ; let v : Word'), 'mismatch'),
        ('reloaded-word', good.replace('let v : Word', 'a <- sload cell ; let v : Word'), 'mismatch'),
        ('alias-search', good.replace('let v : Word', alias).replace('fits(a, b, _)', 'fits(alias, b, _)'), 'mismatch'),
        ('future-argument', future, 'mismatch'),
        ('sibling-scope', sibling, 'mismatch'),
        ('future-guard', unguarded.replace('pure v', 'guard (lt256 (add a b)) ; pure v'), 'mismatch'),
        ('entry-scope', good + 'entry other (a : Word) (b : Word) : Eff Sig Word := do let v : Word := addLt a b _ ; pure v\n', 'mismatch'),
        ('explicit-invalid', H.declare(H.guarded('add', 'repeat(a, b, _, ())'), REPEAT), 'mismatch'),
        ('word-argument', good.replace('fits(a, b, _)', 'fits(_, b, _)'), 'SURFACE_PROOF'),
        ('word-value', good.replace('fits(a, b, _)', 'fits(a, _, _)'), 'SURFACE_PROOF'),
        ('runtime-word', G.program('let x : Word := _ ; pure x'), 'SURFACE_NAME'),
        ('binder-name', G.program('let (0 _ : Le a b) := _ ; pure a'), 'SURFACE_NAME'),
        ('projection-context', H.guarded('add', 'first(_)'), 'SURFACE_PROOF'),
        ('pair-context', H.guarded('add', 'second(pair(_, _))'), 'SURFACE_PROOF'),
        ('false-annotation', H.guarded('add', '(_ : Le (word 1) (word 0))'), 'mismatch'),
        ('partial-bundle', bundle.replace(Q.guard(), Q.guard('Le a b', 'leWord a b')), 'mismatch'),
        ('overflow', T.closed('add', G.MAX, 1, term='_'), 'mismatch'),
        ('underflow', T.closed('sub', 0, 1, term='_'), 'mismatch'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'PH-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-proof-hole-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('ph-' + name, text, marker, Path(temporary))
    print(f'PH-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def twinned(text, holes, explicit, count):
    require(text.count(holes) == 1, 'PH-TWIN anchor')
    require(holes.count('_') == count and explicit.count('()') == count, 'PH-TWIN placeholders')
    replaced = text.replace(holes, explicit)
    require(replaced != text and replaced.count('_') == text.count('_') - count, 'PH-TWIN rewrite')
    return replaced


def boundaries():
    parameters = ' '.join(f'(0 p{i} : {H.TRUE})' for i in range(16))
    helper = f'proof many {parameters} : {H.TRUE} := p15\n'
    call = 'many(' + ', '.join(['_'] * 16) + ')'
    explicit_call = 'many(' + ', '.join(['()'] * 16) + ')'
    text = H.declare(G.program(f'let (0 p : {H.TRUE}) := {call} ; pure a'), helper)
    with tempfile.TemporaryDirectory(prefix='assay-proof-hole-boundaries-') as temporary:
        folder = Path(temporary)
        for name, source_text in [('holes', text), ('explicit', twinned(text, call, explicit_call, 16))]:
            source = folder / f'{name}.asy'
            source.write_text(source_text)
            P.emit(source, folder / name, name)
        require(H.outputs(folder / 'holes') == H.outputs(folder / 'explicit'), 'PH-BOUNDARY erasure')
        E.refusal('ph-limit-arguments', text.replace(call, call[:-1] + ', _)'), 'SURFACE_LIMIT', folder)
        false = text.replace(f'(0 p15 : {H.TRUE})', '(0 p15 : Le (word 1) (word 0))').replace(':= p15', ':= p0')
        E.refusal('ph-limit-false', false, 'mismatch', folder)
        echo = f'proof echo (0 p : {H.TRUE}) (0 q : {H.TRUE}) : {H.TRUE} := q\n'
        sizes = []
        for depth in (4, 8, 16, 128):
            term = 'echo(' * depth + '_' + ', _)' * depth
            explicit_term = 'echo(' * depth + '()' + ', ())' * depth
            program = H.declare(G.program(f'let (0 q : {H.TRUE}) := {term} ; pure a'), echo)
            source = folder / f'nested-{depth}.asy'
            source.write_text(program)
            result = M.capture(f'nested-{depth}', [P.BINARY, 'check', '--print', source])
            require(result.returncode == 0 and not result.stderr, 'PH-NESTED check')
            size = len(result.stdout.encode())
            require(size < 65536 + 2048 * depth, 'PH-NESTED proof expression growth')
            sizes.append(dict(depth=depth, core_bytes=size, source_sha256=hashlib.sha256(source.read_bytes()).hexdigest()))
            P.emit(source, folder / f'nested-{depth}', f'nested-{depth}')
            require(H.outputs(folder / 'holes') == H.outputs(folder / f'nested-{depth}'), 'PH-NESTED erasure')
            twin = folder / f'nested-{depth}-explicit.asy'
            twin.write_text(twinned(program, term, explicit_term, depth + 1))
            P.emit(twin, folder / f'nested-{depth}-explicit', f'nested-{depth}-explicit')
            require(H.outputs(folder / f'nested-{depth}') == H.outputs(folder / f'nested-{depth}-explicit'),
                'PH-NESTED twin erasure')
    (WORK / 'BOUNDARIES.json').write_text(json.dumps(dict(parameters=16, nested=sizes, positive=6, negative=2), indent=2) + '\n')
    print('PH-BOUNDARIES parameters=16 nested=128 positive=6 negative=2 OK', flush=True)
    return 6


def mutants():
    cases = [
        ('EVIDENCE', '~some:(fun ty -> Ok (ty, invariant_proof evidence ty)) expected',
         '~some:(fun ty -> Ok (ty, invariant_proof [] ty)) expected', 'helper-add'),
        ('PAIR', '| Bundle (a, b) -> Ok (Some a, Some b)', '| Bundle (_a, _b) -> Ok (None, None)', 'pair'),
        ('LOCAL', '~evidence:(evidence_for fresh claim evidence)', '~evidence', 'local-add'),
        ('PARAMETER', 'proof ~erased:false ~evidence helpers 0 env (Some ty) row.proof_body',
         'proof ~erased:false ~evidence:[] helpers 0 env (Some ty) row.proof_body', 'helper-body-add'),
    ]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-proof-hole-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanon-replies', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case in cases:
            require(original.count(before) == 1, 'PH-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'PH-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/proof-hole-test.py', 'witness', case], cwd=copy)
                marker = 'M1-TOOL ' + case
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout), 'PH-MUTANT ' + label)
                captures.append(dict(name=label, witness=case, expected_marker=marker,
                    returncode=result.returncode, source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('PH-MUTANT ' + name + ' killed control=OK', flush=True)
    (WORK / 'MUTANTS.json').write_text(json.dumps(captures, indent=2) + '\n')
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=IA.live, erasure=IA.erasure, refusals=refusals, boundaries=boundaries, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/proof-hole-test.py [live|erasure|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (IH, IA, IG, NG, Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    IA.forms = forms
    if args[:1] == ['witness']:
        IA.live(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, creates = IA.live()
        erased, invalid, limits, killed = IA.erasure(), refusals(), boundaries(), mutants()
        print(f'PROOF-HOLES cases={cases} creates={creates} refusals={invalid} '
              f'erasure_pairs={erased} boundaries={limits} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (RuntimeError, OSError, ValueError) as error:
        print('PROOF-HOLES FAIL ' + str(error), flush=True)
        sys.exit(1)

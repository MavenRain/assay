#!/usr/bin/env python3
"""Check inferred proof bindings, lexical scope and erased Cancun output."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/inferred-bindings'
spec = importlib.util.spec_from_file_location('proof_holes', ROOT / 'dev/proof-hole-test.py')
PH = importlib.util.module_from_spec(spec)
spec.loader.exec_module(PH)
IH, IA, IG, NG, Q, I, N, B, H, T, G, E, M, P, C, require = (
    PH.IH, PH.IA, PH.IG, PH.NG, PH.Q, PH.I, PH.N, PH.B, PH.H, PH.T, PH.G, PH.E,
    PH.M, PH.P, PH.C, PH.require)


def forms():
    rows = []

    def add(name, source, typed, behavior='add'):
        rows.append((name, source, typed, behavior, 'custom'))

    for op in ('add', 'sub'):
        ty = T.claim(op)
        helper, args = ('fits', 'a, b') if op == 'add' else ('ordered', 'b, a')
        for name, value in [('name', 'p'), ('helper', f'{helper}({args})'),
                            ('hole-argument', f'{helper}({args}, _)'), ('annotation', f'(_ : {ty})')]:
            source = H.guarded(op, 'q').replace('let v : Word', f'let (0 q) := {value} ; let v : Word')
            add(name + '-' + op, source, source.replace('(0 q)', f'(0 q : {ty})'), op)
        local = H.guarded(op, '(let (0 q) := p in (let (0 q) := q in q))')
        add('local-' + op, local, local.replace('(0 q)', f'(0 q : {ty})'), op)
        generic = H.guarded(op).replace(':= q\n', ':= (let (0 saved) := q in saved)\n')
        parameter_type = 'Lt256 (add x y)' if op == 'add' else 'Le x y'
        add('helper-body-' + op, generic, generic.replace('(0 saved)', f'(0 saved : {parameter_type})'), op)

    for name, definitions, claim, value in [
        ('bundle', '', Q.CLAIM, 'bounds'),
        ('pair', '', Q.CLAIM, 'pair(first(bounds), second(bounds))'),
        ('named', NG.BOUND, 'Bounds(a, b)', '(bounds : Bounds(a, b))'),
        ('nested', '', f'Both ({Q.CLAIM}) ({Q.CLAIM})', 'pair(bounds, bounds)'),
    ]:
        projected = 'first(checked)' if name == 'nested' else 'checked'
        tail = (f'let (0 checked) := {value} ; let (0 ordered) := first({projected}) ; '
                f'let (0 fits) := second({projected}) ; let d : Word := subLe b a ordered ; '
                'let total : Word := addLt a b fits ; sstore low d ; sstore high total ; pure d')
        source = Q.program(Q.guard(), definitions=definitions, tail=tail)
        typed = source.replace('(0 checked)', f'(0 checked : {claim})')
        typed = typed.replace('(0 ordered)', '(0 ordered : Le a b)').replace('(0 fits)', '(0 fits : Lt256 (add a b))')
        add(name, source, typed, 'bundle')

    alias_claim = 'Lt256 (add alias b)'
    binding = H.guarded('add', '_').replace('let v : Word',
        f'let alias : Word := a ; let (0 checked) := (p : {alias_claim}) ; let v : Word')
    binding = binding.replace('addLt a b _', 'addLt alias b _')
    add('binding-evidence', binding, binding.replace('(0 checked)', f'(0 checked : {alias_claim})'))
    local = H.guarded('add', f'(let (0 checked) := (p : {alias_claim}) in fits(alias, b))')
    local = local.replace('let v : Word', 'let alias : Word := a ; let v : Word')
    add('local-evidence', local, local.replace('(0 checked)', f'(0 checked : {alias_claim})'))
    closed = H.closed(term='q').replace('let v : Word', 'let (0 q) := five() ; let v : Word')
    add('closed', closed, closed.replace('(0 q)', '(0 q : Lt256 (add (word 2) (word 3)))'), 'closed-add')
    shadow = H.guarded('add', 'p').replace('let v : Word', 'let (0 p) := p ; let v : Word')
    add('shadow', shadow, shadow.replace('(0 p) :=', '(0 p : Lt256 (add a b)) :='))
    example = (ROOT / 'examples/InferredBindings.asy').read_text()
    typed = example.replace('(0 checked) := p in checked', '(0 checked : Lt256 (add x y)) := p in checked', 1)
    typed = typed.replace('(0 checked) := p in checked', '(0 checked : Le x y) := p in checked')
    typed = typed.replace('(0 bounded) := fits', '(0 bounded : Lt256 (add c n)) := fits')
    typed = typed.replace('(0 bounded) := ordered', '(0 bounded : Le n c) := ordered')
    add('counter', example, typed, 'counter')
    return rows


def growing_bundle(depth, extra=False):
    bindings = ['let (0 p0) := () ;']
    bindings.extend(f'let (0 p{i}) := pair(p{i-1}, p{i-1}) ;' for i in range(1, depth + 1))
    if extra:
        bindings.append(f'let (0 overflow) := pair(p{depth}, ()) ;')
    return G.program(' '.join(bindings) + ' pure a')


def growing_spine(depth):
    bindings = ['let (0 q0) := () ;']
    bindings.extend(f'let (0 q{i}) := pair(q{i-1}, q0) ;' for i in range(1, depth + 1))
    return G.program(' '.join(bindings) + ' pure a')


def negative_cases():
    def binding(value, tail='pure a'):
        return H.declare(G.program(f'let (0 checked) := {value} ; {tail}'), H.FITS)

    false = '(() : Le (word 1) (word 0))'
    good = H.guarded('add', 'checked').replace('let v : Word', 'let (0 checked) := p ; let v : Word')
    unused_helper = f'proof unused : {H.TRUE} := (let (0 checked) := {false} in ())\n'
    return [
        ('hole', binding('_'), 'SURFACE_PROOF'),
        ('local-hole', H.guarded('add', '(let (0 checked) := _ in p)'), 'SURFACE_PROOF'),
        ('pair-hole', H.guarded('add', 'first((let (0 checked) := pair(_, p) in checked))'), 'SURFACE_PROOF'),
        ('word', binding('a'), 'SURFACE_PROOF'),
        ('literal', binding('word 2'), 'SURFACE_PROOF'),
        ('missing', binding('missing'), 'SURFACE_PROOF'),
        ('self', binding('checked'), 'SURFACE_PROOF'),
        ('missing-evidence', binding('fits(a, b)'), 'mismatch'),
        ('unused-false', binding(false), 'mismatch'),
        ('reverting-false', binding(false, 'revert'), 'mismatch'),
        ('unused-local-false', binding(f'(let (0 local) := {false} in ())'), 'mismatch'),
        ('unused-helper-false', H.declare(G.program('pure a'), unused_helper), 'mismatch'),
        ('wrong-annotation', good.replace('(0 checked) :=', '(0 checked : Le (word 1) (word 0)) :='), 'mismatch'),
        ('local-annotation', H.guarded('add', '(let (0 q : Le (word 1) (word 0)) := p in p)'), 'mismatch'),
        ('wrong-operands', good.replace('addLt a b checked', 'addLt b a checked'), 'mismatch'),
        ('word-shadow', good.replace('let v : Word', 'let checked : Word := a ; let v : Word'), 'SURFACE_PROOF'),
        ('word-rebind', good.replace('let v : Word', 'a <- sload cell ; let v : Word'), 'mismatch'),
        ('local-escape', H.guarded('add', 'fits(a, b, (let (0 q) := p in q))')
            .replace('sstore cell v', 'let (0 later) := q ; sstore cell v'), 'SURFACE_PROOF'),
        ('sibling-escape', H.guarded('add', 'second(pair((let (0 q) := p in q), q))'), 'SURFACE_PROOF'),
        ('parameter-type', H.guarded('add').replace('(0 q : Lt256 (add x y))', '(0 q)'), 'SURFACE_SYNTAX'),
        ('guard-type', G.guarded('add').replace('(0 p : Lt256 (add a b))', '(0 p : )'), 'SURFACE_PROOF'),
        ('binder-hole', binding('()').replace('(0 checked)', '(0 _)'), 'SURFACE_NAME'),
        ('bundle-expansion', growing_bundle(11, extra=True), 'SURFACE_LIMIT'),
        ('repeated-expansion', growing_bundle(20), 'SURFACE_LIMIT'),
        ('spine-depth', growing_spine(33), 'SURFACE_LIMIT'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'IB-REFUSAL-WITNESS ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-inferred-binding-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal('ib-' + name, text, marker, Path(temporary))
    print(f'IB-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def boundaries():
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-binding-boundaries-') as temporary:
        folder = Path(temporary)
        for depth in (4, 16, 64, 128):
            term, typed = 'p', 'p'
            for _ in range(depth):
                term = f'let (0 q) := p in {term}'
                typed = f'let (0 q : Lt256 (add a b)) := p in {typed}'
            for suffix, proof in [('inferred', term), ('typed', typed)]:
                source = folder / f'nested-{depth}-{suffix}.asy'
                source.write_text(G.guarded('add').replace('addLt a b p', 'addLt a b ' + proof))
                P.emit(source, folder / f'{depth}-{suffix}', f'nested-{depth}-{suffix}')
            require(H.outputs(folder / f'{depth}-inferred') == H.outputs(folder / f'{depth}-typed'), 'IB-DEPTH erasure')
            inferred = folder / f'nested-{depth}-inferred.asy'
            typed_source = folder / f'nested-{depth}-typed.asy'
            captures.append(dict(depth=depth,
                                 sha256=hashlib.sha256(inferred.read_bytes()).hexdigest(),
                                 typed_sha256=hashlib.sha256(typed_source.read_bytes()).hexdigest()))
        E.refusal('ib-depth', G.guarded('add').replace('addLt a b p', 'addLt a b let (0 q) := p in ' + term),
                  'SURFACE_LIMIT', folder)
        for name, text in [('bundle-limit', growing_bundle(11)), ('bundle-erased', G.program('pure a')),
                           ('spine-depth', growing_spine(32))]:
            source = folder / (name + '.asy')
            source.write_text(text)
            P.emit(source, folder / name, name)
        require(H.outputs(folder / 'bundle-limit') == H.outputs(folder / 'bundle-erased'), 'IB-BUNDLE erasure')
        require(H.outputs(folder / 'spine-depth') == H.outputs(folder / 'bundle-erased'), 'IB-SPINE erasure')
        captures.append(dict(bundle_nodes=4095, source_sha256=hashlib.sha256(growing_bundle(11).encode()).hexdigest()))
        captures.append(dict(spine_depth=32, source_sha256=hashlib.sha256(growing_spine(32).encode()).hexdigest()))
    (WORK / 'BOUNDARIES.json').write_text(json.dumps(captures, indent=2) + '\n')
    print('IB-BOUNDARIES nested=128 bundle_nodes=4095 spine_depth=32 positive=6 negative=1 OK', flush=True)
    return len(captures)


def witness(name):
    if name in {row[0] for row in negative_cases()}:
        refusals(name)
    else:
        IA.live(name)


def mutants():
    cases = [
        ('ENTRY-EVIDENCE', 'state written (evidence_for fresh ty evidence) rest in\n        Ok (erased_apply',
         'state written evidence rest in\n        Ok (erased_apply', 'binding-evidence', 'M1-TOOL binding-evidence'),
        ('LOCAL-EVIDENCE', '~evidence:(evidence_for fresh claim evidence)', '~evidence', 'local-evidence', 'M1-TOOL local-evidence'),
        ('ANNOTATION', '~some:(fun claim -> let* ty = resolved_claim predicates env claim in Ok (Some ty)) claim',
         '~some:(fun claim -> let* _ty = resolved_claim predicates env claim in Ok None) claim',
         'wrong-annotation', 'ERROR-REFUSAL ib-wrong-annotation'),
        ('UNUSED', 'Ok (erased_apply fresh (claim_type ty) "Tx" term next)\n      | Proven',
         'let _ = term in Ok next\n      | Proven', 'unused-false', 'ERROR-REFUSAL ib-unused-false'),
        ('BUNDLE-LIMIT', 'let* _remaining = count 0 4096 ty in Ok ty',
         'let* _remaining = count 0 8192 ty in Ok ty', 'bundle-expansion', 'ERROR-REFUSAL ib-bundle-expansion'),
        ('DEPTH-LIMIT', 'if (inferred && depth > 32) || remaining = 0 then fail at "LIMIT" "inferred proof claim',
         'if (inferred && depth > 1024) || remaining = 0 then fail at "LIMIT" "inferred proof claim',
         'spine-depth', 'ERROR-REFUSAL ib-spine-depth'),
    ]
    captures = []
    with tempfile.TemporaryDirectory(prefix='assay-inferred-binding-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanon-replies', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, case, marker in cases:
            require(original.count(before) == 1, 'IB-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'IB-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/inferred-binding-test.py', 'witness', case], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout), 'IB-MUTANT ' + label)
                captures.append(dict(name=label, witness=case, expected_marker=marker,
                    returncode=result.returncode, source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('IB-MUTANT ' + name + ' killed control=OK', flush=True)
    (WORK / 'MUTANTS.json').write_text(json.dumps(captures, indent=2) + '\n')
    return len(cases)


def main():
    args = sys.argv[1:]
    commands = dict(live=IA.live, erasure=IA.erasure, refusals=refusals, boundaries=boundaries, mutants=mutants)
    if args and args not in [[name] for name in commands] and not (len(args) == 2 and args[0] == 'witness'):
        print('usage: dev/inferred-binding-test.py [live|erasure|refusals|boundaries|mutants|witness NAME]', file=sys.stderr)
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    for module in (PH, IH, IA, IG, NG, Q, I, N, B, H, T, G, E, M, P, C):
        module.WORK = WORK
    IA.forms = forms
    if args[:1] == ['witness']:
        witness(args[1])
    elif args:
        commands[args[0]]()
    else:
        cases, creates = IA.live()
        erased, invalid, limits, killed = IA.erasure(), refusals(), boundaries(), mutants()
        print(f'INFERRED-BINDINGS cases={cases} creates={creates} refusals={invalid} '
              f'erasure_pairs={erased} boundaries={limits} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (RuntimeError, OSError, ValueError) as error:
        print('INFERRED-BINDINGS FAIL ' + str(error), flush=True)
        sys.exit(1)

#!/usr/bin/env python3
"""Check supplied proof terms, erasure, scope and arithmetic against Cancun."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/proof-terms'
spec = importlib.util.spec_from_file_location('term_guards', ROOT / 'dev/guard-test.py')
G = importlib.util.module_from_spec(spec)
spec.loader.exec_module(G)
E, M, P, C, require = G.E, G.M, G.P, G.C, G.require
MAX = G.MAX


def claim(op, a='a', b='b'):
    return f'Lt256 (add {a} {b})' if op == 'add' else f'Le {b} {a}'


def closed(op='add', a=2, b=3, term='()'):
    operation = 'addLt' if op == 'add' else 'subLe'
    return G.program(f'let v : Word := {operation} (word {a}) (word {b}) {term} ; '
                     'sstore cell v ; pure v')


def styles(op):
    ty = claim(op)
    return [f'(p : {ty})', f'(let (0 q : {ty}) := p in q)',
            f'(let (0 p : {ty}) := p in (let (0 p : {ty}) := p in p))']


def live():
    selector, error = G.signature('mix(uint256,uint256)'), G.signature('Denied(uint256,uint256)')
    count = 0
    guarded = 0
    with tempfile.TemporaryDirectory(prefix='assay-proof-terms-') as temporary:
        folder = Path(temporary)
        for op in ('add', 'sub'):
            operation = 'addLt' if op == 'add' else 'subLe'
            baseline = folder / (op + '-baseline.asy')
            baseline.write_text(G.guarded(op))
            P.emit(baseline, folder / (op + '-baseline'), op + '-baseline')
            original = {p.name: p.read_bytes() for p in (folder / (op + '-baseline')).iterdir()}
            for index, term in enumerate(styles(op)):
                label = f'{op}-{index}'
                source = folder / (label + '.asy')
                source.write_text(G.guarded(op).replace(f'{operation} a b p', f'{operation} a b {term}'))
                runtime, _init = P.emit(source, folder / label, label)
                require({p.name: p.read_bytes() for p in (folder / label).iterdir()} == original,
                        'TERM-GUARDED-ERASURE ' + label)
                guarded += 1
                for a, b in G.PAIRS:
                    item = G.matrix_row(op, a, b, selector, error)
                    name = f'{label}-{count}'
                    M.model(name, source, item)
                    P.execute(name, runtime, item)
                    count += 1
        pairs = {'add': [(0, 0), (2, 3), (MAX, 0), (MAX - 1, 1)],
                 'sub': [(0, 0), (9, 4), (MAX, MAX), (MAX, 0)]}
        for op, rows in pairs.items():
            for a, b in rows:
                label = f'closed-{count}'
                source = folder / (label + '.asy')
                source.write_text(closed(op, a, b))
                runtime, _init = P.emit(source, folder / label, label)
                result = a + b if op == 'add' else a - b
                item = P.row(label, selector + '0' * 128, result, after=hex(result))
                M.model(label, source, item)
                P.execute(label, runtime, item)
                count += 1
        scope_cases = [
            ('word-shadow', G.guarded('sub').replace('subLe a b p',
                'subLe a b (let (0 a : Le b a) := p in a)'),
             G.matrix_row('sub', 9, 4, selector, error)),
            ('nesting-boundary', G.guarded('sub').replace('subLe a b p',
                'subLe a b ' + '(' * 128 + 'p' + ')' * 128),
             G.matrix_row('sub', 9, 4, selector, error)),
            ('literal-alias', G.program(f'let a : Word := word {MAX} ; let b : Word := word 0 ; '
                'let (0 p : Lt256 (add a b)) := () ; let v : Word := addLt a b p ; sstore cell v ; pure v'),
             P.row('literal-alias', selector + '0' * 128, MAX, after=hex(MAX))),
        ]
        snapshot = G.program('old <- sload cell ; (0 p : Le b old) <- guard Denied (old) (b) (leWord b old) ; '
            'let (0 q : Le b old) := p ; sstore cell a ; let v : Word := subLe old b q ; pure v')
        for b in (4, 8):
            item = P.row(f'snapshot-{b}', selector + f'{1:064x}{b:064x}', 7 - b if b <= 7 else 0,
                         after='0x1' if b <= 7 else '0x7', status='success' if b <= 7 else 'revert')
            if b > 7:
                item['output'] = error + f'{7:064x}{b:064x}'
            scope_cases.append((f'snapshot-{b}', snapshot, item))
        for label, text, item in scope_cases:
            source = folder / (label + '.asy')
            source.write_text(text)
            runtime, _init = P.emit(source, folder / label, label)
            M.model(label, source, item)
            P.execute(label, runtime, item)
            count += 1
        source = ROOT / 'examples/ProofTerms.asy'
        runtime, init = P.emit(source, folder / 'example', 'example')
        E.creation(runtime, init, folder)
        subtract = G.signature('subtract(uint256,uint256)')
        for a, b in G.PAIRS:
            item = G.matrix_row('sub', a, b, subtract, error)
            M.model(f'example-{count}', source, item)
            P.execute(f'example-{count}', runtime, item)
            count += 1
        item = P.row('example-closed', G.signature('closed()'), 5, after='0x5')
        M.model('example-closed', source, item)
        P.execute('example-closed', runtime, item)
        count += 1
        (WORK / 'LIVE.json').write_text(json.dumps(dict(cases=count, creates=2,
            guarded_erasure=guarded, runtime_bytes=len(runtime) // 2,
            init_bytes=len(init) // 2), indent=2) + '\n')
    print(f'TERM-LIVE cases={count} creates=2 guarded_erasure={guarded} OK', flush=True)
    return count


def negative_cases():
    good = G.guarded('sub')
    unused = 'let (0 q : Le (word 1) (word 0)) := () ; '
    wrong = closed('sub', 1, 0, '(() : Le (word 1) (word 0))')
    return [
        ('false-order', closed('sub', 0, 1), 'mismatch'),
        ('overflow', closed('add', MAX, 1), 'mismatch'),
        ('symbolic-unit', good.replace('subLe a b p', 'subLe a b ()'), 'mismatch'),
        ('annotation', wrong, 'mismatch'),
        ('unused-binding', good.replace('let v : Word', unused + 'let v : Word'), 'mismatch'),
        ('unused-term', closed(term='(let (0 q : Le (word 1) (word 0)) := () in ())'), 'mismatch'),
        ('alias-claim', good.replace('let v : Word', 'let (0 q : Le a b) := p ; let v : Word'), 'mismatch'),
        ('annotated-alias', good.replace('subLe a b p', 'subLe a b (p : Le a b)'), 'mismatch'),
        ('missing', closed(term='missing'), 'SURFACE_PROOF'),
        ('self', closed(term='(let (0 q : Le (word 0) (word 1)) := q in ())'), 'SURFACE_PROOF'),
        ('forward', good.replace('let v : Word', 'let (0 q : Le b a) := later ; let (0 later : Le b a) := p ; let v : Word'), 'SURFACE_PROOF'),
        ('leaked', good.replace('let v : Word', 'let (0 q : Le b a) := (let (0 r : Le b a) := p in r) ; let v : Word').replace('subLe a b p', 'subLe a b r'), 'SURFACE_PROOF'),
        ('shadow', good.replace('let v : Word', 'let p : Word := a ; let v : Word'), 'SURFACE_PROOF'),
        ('word-term', good.replace('subLe a b p', 'subLe a b (let (0 q : Le b a) := a in q)'), 'SURFACE_PROOF'),
        ('word-reload', good.replace('let v : Word', 'let (0 q : Le b a) := p ; a <- sload cell ; let v : Word').replace('subLe a b p', 'subLe a b q'), 'mismatch'),
        ('runtime', good.replace('pure v', 'pure p'), 'SURFACE_PROOF'),
        ('store', good.replace('sstore cell v', 'sstore cell p'), 'SURFACE_PROOF'),
        ('error-payload', good.replace('pure v', 'revert Denied (p) (b)'), 'SURFACE_PROOF'),
        ('quantity', good.replace('let v : Word', 'let (1 q : Le b a) := p ; let v : Word'), 'SURFACE_SYNTAX'),
        ('term-quantity', good.replace('subLe a b p', 'subLe a b (let (1 q : Le b a) := p in q)'), 'SURFACE_SYNTAX'),
        ('reserved', good.replace('let v : Word', 'let (0 _assay_p0 : Le b a) := p ; let v : Word'), 'SURFACE_NAME'),
        ('nesting', good.replace('subLe a b p', 'subLe a b ' + '(' * 129 + 'p' + ')' * 129), 'SURFACE_LIMIT'),
        ('steps', G.program('let (0 q : Le (word 0) (word 1)) := () ; ' * 129 + 'pure a'), 'SURFACE_LIMIT'),
        ('constructor', good + 'constructor := do let (0 p : Le (word 0) (word 1)) := () ; pure ()', 'SURFACE_CONSTRUCTOR'),
        ('cross-entry', good + 'entry other () : Eff Sig Word := do let (0 q : Le (word 0) (word 1)) := p ; pure (word 0)', 'SURFACE_PROOF'),
    ]


def refusals(only=None):
    rows = [row for row in negative_cases() if only is None or row[0] == only]
    require(bool(rows), 'TERM-WITNESS unknown ' + str(only))
    with tempfile.TemporaryDirectory(prefix='assay-term-refusals-') as temporary:
        for name, text, marker in rows:
            E.refusal(name, text, marker, Path(temporary))
    print(f'TERM-REFUSALS cases={len(rows)} commands=3 OK', flush=True)
    return len(rows)


def erasure():
    ty = claim('add', '(word 2)', '(word 3)')
    variants = [closed(), closed(term=f'(() : {ty})'),
                closed(term=f'(let (0 p : {ty}) := () in p)'),
                closed(term=f'(let (0 p : {ty}) := () in (let (0 p : {ty}) := p in p))'),
                closed(term='p').replace('let v : Word', f'let (0 p : {ty}) := () ; let v : Word')]
    outputs = []
    with tempfile.TemporaryDirectory(prefix='assay-term-erasure-') as temporary:
        folder = Path(temporary)
        for index, text in enumerate(variants):
            source = folder / f'{index}.asy'
            source.write_text(text)
            runtime, _init = P.emit(source, folder / str(index), f'erasure-{index}')
            outputs.append({p.name: p.read_bytes() for p in (folder / str(index)).iterdir()})
        require(all(out == outputs[0] for out in outputs), 'TERM-ERASURE five files')
        source = folder / 'checked.asy'
        source.write_text(G.program('v <- add (word 2) (word 3) ; sstore cell v ; pure v'))
        checked, _init = P.emit(source, folder / 'checked', 'checked')
        counts = [sum(op == 'JUMPI' for _pc, op, _imm in P.listing(name, code))
                  for name, code in [('proved', runtime), ('checked', checked)]]
        require(counts[1] == counts[0] + 1, 'TERM-ERASURE removed check')
        (WORK / 'ERASURE.json').write_text(json.dumps(dict(variants=len(variants),
            files={name: hashlib.sha256(data).hexdigest() for name, data in outputs[0].items()},
            proved_jumpi=counts[0], checked_jumpi=counts[1]), indent=2) + '\n')
    print(f'TERM-ERASURE variants={len(variants)} five_files={len(outputs[0])} '
          f'removed_checks={counts[1] - counts[0]} OK', flush=True)
    return len(variants)


def mutants():
    cases = [
        ('BINDING', 'Ok (erased_apply fresh ty "Tx" term next)',
         'let _ignored = ty, term in Ok next', 'unused-binding'),
        ('ANNOTATION', '| Proof_ann (term, claim) ->\n      let* ty, _op, _a, _b = resolved_predicate env claim in proof ~erased helpers (depth + 1) env ty term',
         '| Proof_ann (term, _claim) -> proof ~erased helpers (depth + 1) env expected term', 'annotation'),
        ('SCOPE', '| Proof_value p -> Ok p | Word_value _ -> refusal) (List.assoc_opt at.text env)',
         '| Proof_value p -> Ok p | Word_value _ -> refusal) (List.assoc_opt at.text (List.rev env))', 'shadow'),
        ('NESTING', 'if depth > 128 then fail (here tokens) "LIMIT" "proof nesting exceeds 128"',
         'if depth > 8192 then fail (here tokens) "LIMIT" "proof nesting exceeds 128"', 'nesting'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-term-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework',
            '.kanon-exec', '.kanon-wait', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, witness in cases:
            require(original.count(before) == 1, 'TERM-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'TERM-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/proof-term-test.py', 'witness', witness], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and
                        (not mutated or 'ERROR-REFUSAL ' + witness in result.stdout), 'TERM-MUTANT ' + label)
            print('TERM-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True)
    G.WORK = E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        refusals(sys.argv[2])
    elif sys.argv[1:] in (['live'], ['refusals'], ['erasure'], ['mutants']):
        {'live': live, 'refusals': refusals, 'erasure': erasure, 'mutants': mutants}[sys.argv[1]]()
    elif not sys.argv[1:]:
        count, invalid = live(), refusals()
        erased = erasure()
        killed = mutants()
        print(f'PROOF-TERMS cases={count} creates=2 refusals={invalid} '
              f'erasure={erased} mutants={killed} OK')
    else:
        print('usage: dev/proof-term-test.py [live|refusals|erasure|mutants|witness NAME]', file=sys.stderr)
        sys.exit(64)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('PROOF-TERMS FAIL: ' + str(error))
        sys.exit(1)

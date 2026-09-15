#!/usr/bin/env python3
"""Check proof scope, branch behavior, arithmetic and erased guard counts."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/guards'
BINARY = ROOT / '_build/default/bin/assay.exe'
spec = importlib.util.spec_from_file_location('guard_errors', ROOT / 'dev/errors-test.py')
E = importlib.util.module_from_spec(spec)
spec.loader.exec_module(E)
M, P, C, D, require = E.M, E.P, E.C, E.D, E.require
SOURCE = ROOT / 'examples/CounterProofs.asy'
CORE = ROOT / 'examples/GuardCore.asy'
MAX = 2**256 - 1
PAIRS = [(0, 0), (0, 1), (1, 0), (2, 3), (9, 4), (MAX, 0), (0, MAX),
         (MAX, 1), (1, MAX), (MAX, MAX), (MAX - 1, 1), (MAX - 1, 2)]


def program(body, errors='error Denied (left : Word) (right : Word)'):
    return ('contract Guards where storage State := { cell : Word }\n' + errors +
            '\nentry mix (a : Word) (b : Word) : Eff Sig Word := do ' + body + '\n')


def guarded(op, *, errors=True):
    claim, condition = ('Lt256 (add a b)', 'lt256 (add a b)') if op == 'add' else ('Le b a', 'leWord b a')
    failure = 'Denied (a) (b) ' if errors else ''
    return program('sstore cell (word 9) ; (0 p : ' + claim + ') <- guard ' + failure +
                   '(' + condition + ') ; let v : Word := ' + ('addLt' if op == 'add' else 'subLe') +
                   ' a b p ; sstore cell v ; pure v', errors='' if not errors else 'error Denied (left : Word) (right : Word)')


def signature(name):
    return P.checked('sig-' + name.split('(')[0], ['cast', 'sig', name]).strip()


def matrix_row(op, a, b, selector, error):
    value = a + b if op == 'add' else a - b
    success = 0 <= value <= MAX
    item = P.row(f'{op}-{a}-{b}', selector + f'{a:064x}{b:064x}', value if success else 0,
                 after=hex(value) if success else '0x7', status='success' if success else 'revert')
    if not success:
        item['output'] = error + (f'{a:064x}{b:064x}' if error != '0x' else '')
    return item


def live():
    selector, error = signature('mix(uint256,uint256)'), signature('Denied(uint256,uint256)')
    count = 0
    with tempfile.TemporaryDirectory(prefix='assay-guards-') as temporary:
        folder = Path(temporary)
        for op in ('add', 'sub'):
            for errors in (True, False):
                name = op + ('-error' if errors else '-empty')
                source = folder / (name + '.asy')
                source.write_text(guarded(op, errors=errors))
                runtime, _init = P.emit(source, folder / name, name)
                for a, b in PAIRS:
                    item = matrix_row(op, a, b, selector, error if errors else '0x')
                    label = name + '-' + str(count)
                    M.model(label, source, item)
                    P.execute(label, runtime, item)
                    count += 1
        runtime, init = P.emit(SOURCE, folder / 'counter', 'counter')
        error_selectors = [signature(s) for s in ('OverflowRevert()', 'BoundRevert(uint256,uint256)', 'UnderflowRevert()')]
        rows = json.loads((ROOT / 'reference/counter/cases.json').read_text())
        covered = set()
        for original in rows:
            item = dict(original)
            data = item['calldata'].removeprefix('0x')
            if item['status'] == 'revert' and item['value'] == 0 and len(data) >= 72:
                n = int(data[8:72], 16)
                count_before = int(item['before'].get('0x0', item['before'].get('0', '0x0')), 16)
                limit = int(item['before'].get('0x1', item['before'].get('1', '0x0')), 16)
                if data[:8] == '7cf5dab0':
                    item['output'] = error_selectors[0] if count_before + n > MAX else error_selectors[1] + f'{count_before + n:064x}{limit:064x}'
                elif data[:8] == '3a9ebefd':
                    item['output'] = error_selectors[2]
            M.model('counter-' + item['name'], SOURCE, item)
            _report, evidence = P.execute('counter-' + item['name'], runtime, item)
            covered.update(step['pc'] for step in D.objects(evidence['run'])[:-2])
            count += 1
        instructions = P.listing('counter', runtime)
        require(covered == {pc for pc, _op, _imm in instructions}, 'GUARD-COVERAGE')
        abi = json.loads((folder / 'counter/abi.json').read_text())
        require([row['stateMutability'] for row in abi if row['type'] == 'function'] ==
                ['nonpayable', 'nonpayable', 'view'], 'GUARD-MUTABILITY')
        prefix = init[:-len(runtime)]
        C.creation(runtime, prefix, P.listing('prefix', prefix))
        M.model('no-tools', SOURCE, rows[0], env={**os.environ, 'PATH': '/nonexistent'})
        extra = [
            ('reuse', guarded('sub').replace('sstore cell v ;', 'let w : Word := subLe a b p ; sstore cell w ;')),
            ('snapshot', guarded('sub').replace('sstore cell (word 9) ;', 'old <- sload cell ; sstore cell a ;')),
            ('alias', guarded('sub').replace('subLe a b p', 'subLe a x p').replace('let v : Word', 'let x : Word := b ; let v : Word')),
        ]
        for name, text in extra:
            source = folder / (name + '.asy')
            source.write_text(text)
            runtime_extra, _init = P.emit(source, folder / name, name)
            item = matrix_row('sub', 9, 4, selector, error)
            M.model(name, source, item)
            P.execute(name, runtime_extra, item)
            count += 1
        source = folder / 'Snapshot.asy'
        source.write_text(program('old <- sload cell ; (0 p : Le b old) <- guard Denied (old) (b) (leWord b old) ; '
            'sstore cell a ; let v : Word := subLe old b p ; pure v'))
        snapshot, _init = P.emit(source, folder / 'snapshot-proof', 'snapshot-proof')
        for b in (4, 8):
            item = P.row('snapshot-' + str(b), selector + f'{1:064x}{b:064x}', 7 - b if b <= 7 else 0,
                         after='0x1' if b <= 7 else '0x7', status='success' if b <= 7 else 'revert')
            if b > 7:
                item['output'] = error + f'{7:064x}{b:064x}'
            M.model(item['name'], source, item)
            P.execute(item['name'], snapshot, item)
            count += 1
        (WORK / 'OUTPUTS.json').write_text(json.dumps(dict(runtime_bytes=len(runtime) // 2,
            init_bytes=len(init) // 2, covered=len(covered), cases=count,
            files={p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in (folder / 'counter').iterdir()}), indent=2) + '\n')
    print(f'GUARD-LIVE cases={count} creates=2 covered={len(covered)} OK', flush=True)
    return count


def refusal(name, text, marker, folder, checked=False):
    E.refusal(name, text, marker, folder, checked)


def refusals():
    good = guarded('sub')
    cases = [
        ('quantity', good.replace('(0 p', '(1 p'), 'SURFACE_SYNTAX'),
        ('claim', good.replace('Le b a)', 'Le a b)'), 'mismatch'),
        ('condition', good.replace('leWord b a)', 'leWord a b)'), 'mismatch'),
        ('operands', good.replace('subLe a b p', 'subLe b a p'), 'mismatch'),
        ('operation', good.replace('subLe a b p', 'addLt a b p'), 'mismatch'),
        ('missing', good.replace('subLe a b p', 'subLe a b missing'), 'SURFACE_PROOF'),
        ('word-proof', good.replace('subLe a b p', 'subLe a b a'), 'SURFACE_PROOF'),
        ('runtime-proof', good.replace('pure v', 'pure p'), 'SURFACE_PROOF'),
        ('shadow-proof', good.replace('let v : Word', 'let p : Word := a ; let v : Word'), 'SURFACE_PROOF'),
        ('shadow-word', good.replace('let v : Word', 'a <- sload cell ; let v : Word'), 'mismatch'),
        ('reload', program('old <- sload cell ; (0 p : Le b old) <- guard (leWord b old) ; '
                          'sstore cell a ; old <- sload cell ; let v : Word := subLe old b p ; pure v'), 'mismatch'),
        ('unknown-error', good.replace('guard Denied', 'guard Missing'), 'SURFACE_ERROR'),
        ('error-arity', good.replace('Denied (a) (b)', 'Denied (a)'), 'SURFACE_ERROR'),
        ('error-empty-last', good.replace('Denied (a) (b)', 'Denied (a) ()'), 'SURFACE_ERROR'),
        ('error-empty-first', good.replace('Denied (a) (b)', 'Denied () (b)'), 'SURFACE_ERROR'),
        ('error-scope', good.replace('Denied (a) (b)', 'Denied (p) (b)'), 'SURFACE_SCOPE'),
        ('constructor', good + 'constructor := do (0 p : Le (word 0) (word 1)) <- guard (leWord (word 0) (word 1)) ; pure ()', 'SURFACE_CONSTRUCTOR'),
        ('reserved', good.replace('storage State', 'storage Le'), 'SURFACE_NAME'),
        ('cross-entry', good + 'entry other () : Eff Sig Word := do let v : Word := subLe (word 1) (word 0) p ; pure v', 'SURFACE_PROOF'),
    ]
    core = CORE.read_text()
    bad_proof = core.replace('def safe : AddFits (word 256 2) (word 256 3) := tuple ()',
                            f'def safe : AddFits (word 256 {MAX}) (word 256 3) := tuple ()')
    cases.append(('false-proof', bad_proof, 'mismatch'))
    schemas = [
        ('meaning', core.replace('return Nat with | word 0 bits n => n', 'return Nat with | word 0 bits n => 0'), 'M1 wordNat'),
        ('polarity', core.replace('natLt (wordNat b) (wordNat a)', 'natLt (wordNat a) (wordNat b)'), 'M1 Le'),
        ('proof-type', core.replace('(0 p : Le b a) ->', '(0 p : Le a b) ->'), 'M1 Tx family'),
        ('proof-quantity', core.replace('(0 p : AddFits a b) -> (Word', '(1 p : AddFits a b) -> (Word'), 'M1 Tx family'),
        ('threshold', core.replace(str(2**256) + ' as flag', str(MAX) + ' as flag'), 'M1 AddFits'),
        ('assumption', core.replace('def safe : AddFits (word 256 2) (word 256 3) := tuple ()',
                                 'axiom safe : AddFits (word 256 2) (word 256 3)'), 'M1 proof assumption safe'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-guard-refusals-') as temporary:
        folder = Path(temporary)
        for name, text, marker in cases:
            refusal(name, text, marker, folder)
        for name, text, marker in schemas:
            refusal(name, text, marker, folder, checked=True)
    print(f'GUARD-REFUSALS surface={len(cases)} schema={len(schemas)} OK', flush=True)
    return len(cases) + len(schemas)


def erasure():
    core = CORE.read_text()
    variants = [core, core.replace(':= tuple ()\ndef main',
        ':= ((fun (0 unused : prod ()) => tuple ()) : (0 unused : prod ()) -> prod ()) (tuple ())\ndef main'),
        core.replace(':= tuple ()\ndef main', ':= (let proof : prod () := tuple () in proof)\ndef main')]
    with tempfile.TemporaryDirectory(prefix='assay-guard-erasure-') as temporary:
        folder = Path(temporary)
        outputs = []
        for index, text in enumerate(variants):
            parent = folder / str(index)
            parent.mkdir()
            source = parent / CORE.name
            source.write_text(text)
            runtime, _init = P.emit(source, parent / 'out', 'erased-' + str(index))
            item = P.row('closed', '0x6d4ce63c', 5, after='0x7')
            M.model('erased-' + str(index), source, item)
            P.execute('erased-' + str(index), runtime, item)
            outputs.append({p.name: p.read_bytes() for p in (parent / 'out').iterdir()})
        require(all(out == outputs[0] for out in outputs), 'GUARD-ERASURE five files')
        ordinary = core.replace('addLt (word 256 2) (word 256 3) safe\n    (fun (v : Word 256) => done v)',
            'add (word 256 2) (word 256 3) (fun (r : ResultWord) => case r with | 0 (v : Word 256) => done v | 1 (e : prod ()) => abort)')
        source = folder / CORE.name
        source.write_text(ordinary)
        checked, _init = P.emit(source, folder / 'checked', 'checked-arithmetic')
        counts = lambda code: sum(op == 'JUMPI' for _pc, op, _arg in P.listing('guards-' + str(len(code)), code))
        unchecked_count, checked_count = counts(runtime), counts(checked)
        require(checked_count == unchecked_count + 1, 'GUARD-COUNT redundant check')
        (WORK / 'ERASURE.json').write_text(json.dumps(dict(variants=len(variants), five_files_equal=True,
            proved_jumpi=unchecked_count, checked_jumpi=checked_count), indent=2) + '\n')
    print(f'GUARD-ERASURE variants=3 five_files=5 removed_checks=1 OK', flush=True)


def witness(name):
    with tempfile.TemporaryDirectory(prefix='assay-guard-witness-') as temporary:
        folder = Path(temporary)
        if name == 'proof':
            refusal('claim', guarded('sub').replace('Le b a)', 'Le a b)'), 'mismatch', folder)
        elif name == 'schema':
            refusal('meaning', CORE.read_text().replace('return Nat with | word 0 bits n => n',
                'return Nat with | word 0 bits n => 0'), 'M1 wordNat', folder, checked=True)
        elif name in ('sub', 'overflow', 'model'):
            op = 'add' if name == 'overflow' else 'sub'
            a, b = (MAX, 1) if op == 'add' else (9, 4)
            source = folder / 'Witness.asy'
            source.write_text(guarded(op))
            runtime, _init = P.emit(source, folder / 'out', 'witness')
            item = matrix_row(op, a, b, signature('mix(uint256,uint256)'), signature('Denied(uint256,uint256)'))
            M.model('witness', source, item)
            P.execute('witness', runtime, item)
        else:
            require(False, 'GUARD-WITNESS unknown ' + name)


def mutants():
    cases = [
        ('CLAIM', 'emit/contract.ml', '| Prove (name, claim, error, condition) ->\n        let* ty = resolved_claim env claim in',
         '| Prove (name, claim, error, condition) ->\n        let rec inferred_claim = function\n'
         '          | Check p -> Bound p\n'
         '          | Conjoin (a, b) -> Both (inferred_claim a, inferred_claim b) in\n'
         '        let* ty = resolved_claim env (inferred_claim condition) in\n        let _claim = claim in',
         'proof', 'ERROR-REFUSAL'),
        ('SCHEMA', 'emit/recognize.ml', 'Global.find name globals = Global.find name expected then Ok ()',
         '(name = "wordNat" || Global.find name globals = Global.find name expected) then Ok ()', 'schema', 'ERROR-REFUSAL'),
        ('SUB', 'emit/emit.ml', 'let op = if tag = (if errors = [] then 9 else 10) then Add else Sub in',
         'let op = if tag = (if errors = [] then 9 else 10) then Add else Add in', 'sub', 'MODEL-EXPECTED'),
        ('OVERFLOW', 'emit/emit.ml', 'if addition then Arithmetic (Add, left, right, index, yes, no)',
         'if addition then Arithmetic (Add, left, right, index, no, yes)', 'overflow', 'MODEL-EXEC'),
        ('MODEL', 'emit/model.ml', 'else transaction initial storage ((index, result) :: memory) next',
         'else transaction initial storage ((index, Z.zero) :: memory) next', 'model', 'MODEL-EXPECTED'),
        ('OPCODE', 'emit/emit.ml', '| Sub -> read_operand right @ read_operand left @ [A.Op "SUB"] in',
         '| Sub -> read_operand left @ read_operand right @ [A.Op "SUB"] in', 'sub', 'COUNTER-EXPECTED'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-guard-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        for name, relative, before, after, example, marker in cases:
            path = copy / relative
            original = path.read_text()
            expected = 2 if name == 'SCHEMA' else 1
            require(original.count(before) == expected, 'GUARD-MUTANT-ANCHOR ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = M.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'GUARD-MUTANT-BUILD ' + label)
                result = M.capture(label, ['python3', '-P', 'dev/guard-test.py', 'witness', example], cwd=copy)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout), 'GUARD-MUTANT ' + label)
            print('GUARD-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    E.WORK = M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        witness(sys.argv[2])
    elif sys.argv[1:] in (['live'], ['refusals'], ['erasure'], ['mutants']):
        {'live': live, 'refusals': refusals, 'erasure': erasure, 'mutants': mutants}[sys.argv[1]]()
    elif not sys.argv[1:]:
        count, invalid = live(), refusals()
        erasure()
        killed = mutants()
        print(f'PROOF-GUARDS cases={count} creates=2 refusals={invalid} erasure=3 mutants={killed} OK')
    else:
        print('usage: dev/guard-test.py [live|refusals|erasure|mutants|witness NAME]', file=sys.stderr)
        sys.exit(64)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('PROOF-GUARDS FAIL: ' + str(error))
        sys.exit(1)

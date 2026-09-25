#!/usr/bin/env python3
"""Check source arithmetic proofs, executable correspondence and named mutations."""
import importlib.util
import itertools
import json
from pathlib import Path
import random
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/source-proofs'
PACKAGE = ROOT / 'verification'
LEAN = PACKAGE / '.lake/build/bin/sourceModel'
BINARY = ROOT / '_build/bin/assay'
BOUND = 2**256
SELECTOR = 'b4bb58fb'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def capture(argv, cwd=ROOT, timeout=30):
    result = subprocess.run([str(arg) for arg in argv], cwd=cwd, capture_output=True,
                            text=True, timeout=timeout)
    return dict(argv=[str(arg) for arg in argv], exit=result.returncode,
                stdout=result.stdout, stderr=result.stderr)


def good(result, name):
    require(result['exit'] == 0 and not result['stderr'], name + ': ' + result['stderr'])
    return result['stdout']


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


def literal(value):
    return dict(tag='literal', value=str(value))


def memory(index):
    return dict(tag='memory', index=str(index))


def finish(value):
    return dict(tag='finish', value=value)


def store(value, tail):
    return dict(tag='store', slot='0', value=value, next=tail)


def arithmetic(op, left, right, yes, no=None, index=3):
    return dict(tag=op, left=left, right=right, index=str(index), yes=yes,
                no=dict(tag='abort') if no is None else no)


def transaction(op, *, recovery=False):
    yes = store(memory(3), finish(memory(3)))
    no = finish(literal(77)) if recovery else None
    return store(literal(9), arithmetic(op, memory(1), memory(2), yes, no))


def request(program, a, b, initial=7):
    return dict(program=program, storage=[['0', str(initial)], ['2', '2748']],
                memory=[['1', str(a)], ['2', str(b)]])


def expected(op, a, b, *, recovery=False):
    value = a + b if op == 'add' else a - b
    fits = 0 <= value < BOUND
    event = dict(op=op, left=str(a), right=str(b),
                 result='ok' if fits else 'overflow' if op == 'add' else 'underflow')
    if fits:
        event['value'] = str(value)
    answer = dict(status='success' if fits or recovery else 'revert',
                  value=value if fits else 77 if recovery else None,
                  storage={2: 2748, 0: value if fits else 9 if recovery else 7}, events=[event])
    answer['storage'] = {key: val for key, val in answer['storage'].items() if val != 0}
    return answer


def lean_result(result):
    value = json.loads(good(result, 'LEAN-EXECUTION'))
    return dict(status=value['status'], value=int(value['value']) if 'value' in value else None,
                storage={int(key): int(word) for key, word in value['storage']}, events=value['events'])


def model_result(result):
    value = json.loads(good(result, 'SOURCE-EXECUTION'))
    return dict(status=value['status'],
                value=int(value['output'], 16) if value['status'] == 'success' else None,
                storage={int(key): int(word, 16) for key, word in value['storage'].items()})


def axiom_report(text):
    expected_names = ['checked_meaning', 'checked_add_exact', 'checked_sub_exact',
                      'checked_add_rejects', 'checked_sub_rejects', 'word_bounded',
                      'execution_overflow_free', 'source_overflow_free', 'abort_restores',
                      'event_add_exact', 'event_sub_exact']
    rows = [re.fullmatch(r"'AssayProofs\.([a-z_]+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",
                         line) for line in text.splitlines()]
    return (all(rows) and [row.group(1) for row in rows] == expected_names and
            all(set(filter(None, (row.group(2) or '').split(', '))) <=
                {'propext', 'Quot.sound', 'Classical.choice'} for row in rows))


def proofs():
    require(json.loads((PACKAGE / 'lake-manifest.json').read_text())['packages'] == [], 'PROOF-DEPENDENCIES')
    result = capture(['leancho', '--warn', '-C', PACKAGE], timeout=180)
    (WORK / 'BUILD.json').write_text(json.dumps(result, indent=2) + '\n')
    require(result['exit'] == 0 and '0 errors, 0 sorries, 0 warnings' in result['stdout'], 'SOURCE-PROOF-BUILD')
    result = capture(['lake', 'env', 'lean', 'Axioms.lean'], cwd=PACKAGE, timeout=120)
    (WORK / 'AXIOMS.json').write_text(json.dumps(result, indent=2) + '\n')
    text = good(result, 'SOURCE-PROOF-AXIOMS')
    require(axiom_report(text), 'SOURCE-PROOF-AXIOMS inventory or assumptions')
    tail = '\n'.join(text.splitlines()[1:]) + '\n'
    controls = ["'AssayProofs.checked_meaning' depends on axioms: [sorryAx]\n" + tail,
                tail, text + text.splitlines()[0] + '\n',
                "'AssayProofs.checked_meaning' depends on axioms: [Unreviewed.axiom]\n" + tail]
    require(all(not axiom_report(value) for value in controls), 'SOURCE-PROOF-REPORT controls')
    return len(text.splitlines()), len(controls)


def live():
    P = module('proof_emission', 'dev/m1-emit-test.py')
    P.WORK = WORK / 'evm'
    P.WORK.mkdir(exist_ok=True)
    sources = WORK / 'sources'
    sources.mkdir(exist_ok=True)
    values = [0, 1, 2, 2**128 - 1, 2**128, 2**255 - 1, 2**255, BOUND - 2, BOUND - 1]
    pairs = list(itertools.product(values, repeat=2))
    rng = random.Random(0xA55A1)
    pairs += [(rng.getrandbits(256), rng.getrandbits(256)) for _ in range(32)]
    evm_pairs = {(0, 0), (0, 1), (1, 1), (2, 1), (BOUND - 1, 0),
                 (BOUND - 1, 1), (BOUND - 1, BOUND - 1), (2**255, 2**255)}
    executions = evm_count = recoveries = 0
    with (WORK / 'CASES.jsonl').open('w') as log, tempfile.TemporaryDirectory(prefix='assay-proof-') as temp:
        for op in ('add', 'sub'):
            path = sources / (op + '.asy')
            path.write_text('contract Checked where storage State := { cell : Word }\n'
                            'entry mix (a : Word) (b : Word) : Eff Sig Word := do\n'
                            f'  sstore cell (word 9) ; total <- {op} a b ; sstore cell total ; pure total\n')
            runtime, _init = P.emit(path, Path(temp) / op, op + '-emit')
            for index, (a, b) in enumerate(pairs):
                name = f'{op}-{index}'
                input_value = request(transaction(op), a, b)
                lean = capture([LEAN, json.dumps(input_value)])
                data = SELECTOR + f'{a:064x}{b:064x}'
                source = capture([BINARY, 'run', path, '--calldata', data,
                                  '--storage', '0=7', '--storage', '2=2748'])
                want = expected(op, a, b)
                require(lean_result(lean) == want, 'LEAN-ARITHMETIC ' + name)
                require(model_result(source) == {key: want[key] for key in ('status', 'value', 'storage')},
                        'SOURCE-ARITHMETIC ' + name)
                log.write(json.dumps(dict(name=name, request=input_value, lean=lean, source=source)) + '\n')
                executions += 1
                if (a, b) in evm_pairs:
                    row = P.row(name, data, want['value'] or 0, after=hex(want['storage'].get(0, 0)), status=want['status'])
                    P.execute(name, runtime, row)
                    evm_count += 1
            recovery = sources / (op + '-recovery.asy')
            recovery.write_text(P.program(f'''store storage.0 (word 256 9)
  ({op} args.0 args.1 (fun (result : ResultWord) =>
    case result with
    | 0 (value : Word 256) => store storage.0 value (done value)
    | 1 (err : prod ()) => done (word 256 77)))'''))
            for a, b in ((BOUND - 1, 1), (0, 1), (2, 1)):
                input_value = request(transaction(op, recovery=True), a, b)
                lean = capture([LEAN, json.dumps(input_value)])
                source = capture([BINARY, 'run', recovery, '--calldata', SELECTOR + f'{a:064x}{b:064x}',
                                  '--storage', '0=7', '--storage', '2=2748'])
                want = expected(op, a, b, recovery=True)
                require(lean_result(lean) == want and model_result(source) ==
                        {key: want[key] for key in ('status', 'value', 'storage')}, 'SOURCE-RECOVERY ' + op)
                log.write(json.dumps(dict(name=op + '-recovery', request=input_value, lean=lean, source=source)) + '\n')
                recoveries += 1
    return executions, evm_count, recoveries


def effects():
    sources = WORK / 'sources'
    load = lambda index, tail: dict(tag='load', slot='0', index=str(index), next=tail)
    snapshot = load(3, store(literal(9), load(4,
        arithmetic('add', memory(3), memory(4), finish(memory(5)), index=5))))
    snapshot_source = ('old <- sload cell ; sstore cell (word 9) ; now <- sload cell ; '
                       'value <- add old now ; pure value')
    comparison = store(literal(9), dict(tag='compare', left=memory(1), right=memory(2),
                                      yes=finish(memory(1)), no=dict(tag='abort')))
    cases = [('snapshot', snapshot_source, snapshot, 7, 0, 0, 'success', 16, 9,
              [dict(op='add', left='7', right='9', result='ok', value='16')]),
             ('snapshot-overflow', snapshot_source, snapshot, BOUND - 1, 0, 0, 'revert', None, BOUND - 1,
              [dict(op='add', left=str(BOUND - 1), right='9', result='overflow')]),
             ('compare-less', 'sstore cell (word 9) ; guard le a b ; pure a', comparison,
              7, 2, 3, 'success', 2, 9, []),
             ('compare-equal', 'sstore cell (word 9) ; guard le a b ; pure a', comparison,
              7, 3, 3, 'success', 3, 9, []),
             ('compare-greater', 'sstore cell (word 9) ; guard le a b ; pure a', comparison,
              7, 3, 2, 'revert', None, 7, []),
             ('clear', 'sstore cell (word 0) ; pure a', store(literal(0), finish(memory(1))),
              7, BOUND - 1, 1, 'success', BOUND - 1, 0, []),
             ('missing-slot', 'value <- sload cell ; pure value', load(3, finish(memory(3))),
              0, 1, 2, 'success', 0, 0, [])]
    with (WORK / 'EFFECTS.jsonl').open('w') as log:
        for name, body, program, initial, a, b, status, value, final, events in cases:
            path = sources / (name + '.asy')
            path.write_text('contract Effects where storage State := { cell : Word }\n'
                            'entry mix (a : Word) (b : Word) : Eff Sig Word := do ' + body + '\n')
            input_value = request(program, a, b, initial)
            if name == 'missing-slot':
                input_value['storage'] = [['2', '2748']]
            lean = capture([LEAN, json.dumps(input_value)])
            storage_args = [] if name == 'missing-slot' else ['--storage', '0=' + str(initial)]
            source = capture([BINARY, 'run', path, '--calldata', SELECTOR + f'{a:064x}{b:064x}',
                              *storage_args, '--storage', '2=2748'])
            want = dict(status=status, value=value, storage={2: 2748}, events=events)
            if final != 0:
                want['storage'][0] = final
            require(lean_result(lean) == want and model_result(source) ==
                    {key: want[key] for key in ('status', 'value', 'storage')}, 'SOURCE-EFFECT ' + name)
            log.write(json.dumps(dict(name=name, request=input_value, lean=lean, source=source)) + '\n')
    return len(cases)


def driver():
    base = request(transaction('add'), 1, 2)
    cases = [('', 'format'), ('{}', 'format'), (json.dumps(base).replace('"1"', '"-1"'), 'number'),
             (json.dumps(request(transaction('add'), BOUND, 1)), 'wordRange'),
             (json.dumps(request(transaction('add'), 10**78, 1)), 'number'),
             (json.dumps(dict(base, program=dict(tag='multiply'))), 'unknownNode'),
             (json.dumps(dict(base, memory=[])), 'missingMemory'),
             (json.dumps(dict(base, storage=[['0', '1'], ['0', '2']])), 'duplicate'),
             (json.dumps(dict(base, memory=[['1', '1'], ['1', '2']])), 'duplicate'),
             (json.dumps(dict(base, storage=[['0']])), 'format'),
             (json.dumps(dict(base, storage=[['0', '1']] * 1025)), 'limit'),
             (' ' * 65537, 'limit')]
    deep = finish(literal(0))
    for _ in range(129):
        deep = store(literal(1), deep)
    cases.append((json.dumps(dict(base, program=deep)), 'limit'))
    with (WORK / 'DRIVER.jsonl').open('w') as log:
        for source, marker in cases:
            result = capture([LEAN, source])
            require(result['exit'] == 2 and not result['stderr'] and
                    marker in json.loads(result['stdout'])['error'], 'PROOF-DRIVER ' + marker)
            log.write(json.dumps(result) + '\n')
    return len(cases)


def mutants():
    changes = [
        ('EXACT-ADD', 'AssayProofs/Arithmetic.lean', 'value.val = a.val + b.val :=',
         'value.val = a.val + b.val + 1 :=', 'compile'),
        ('UPPER-BOUND', 'AssayProofs/Arithmetic.lean', 'if bound : a.val + b.val < modulus then',
         'if bound : a.val + b.val ≤ modulus then', 'compile'),
        ('SUB-ORDER', 'AssayProofs/Arithmetic.lean', 'if order : b.val ≤ a.val then',
         'if order : a.val ≤ b.val then', 'compile'),
        ('TRACE', 'AssayProofs/Source.lean', 'return record op a b result tail', 'return tail', 'trace'),
        ('DISPATCH', 'Main.lean', '(if tag == "add" then .add else .sub)',
         '(if tag == "add" then .sub else .add)', 'dispatch'),
        ('ERROR-BRANCH', 'AssayProofs/Source.lean',
         '| .error .overflow | .error .underflow => executeCertified initial storage memory no',
         '| .error .overflow | .error .underflow => executeCertified initial storage memory yes', 'branch'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-proof-mutants-') as temp:
        folder = Path(temp) / 'verification'
        shutil.copytree(PACKAGE, folder)
        for name, relative, old, new, kind in changes:
            path = folder / relative
            original = path.read_text()
            require(original.count(old) == 1, 'PROOF-MUTATION site ' + name)
            path.write_text(original.replace(old, new))
            built = capture(['leancho', '--warn', '-C', folder], timeout=180)
            if kind == 'compile':
                killed = built['exit'] != 0 and 'E ' + relative + ':' in built['stdout']
                probe = None
            else:
                require(built['exit'] == 0, 'PROOF-MUTATION build ' + name)
                a, b = (BOUND - 1, 1) if kind == 'branch' else (2, 1)
                probe = capture([folder / '.lake/build/bin/sourceModel', json.dumps(request(transaction('add'), a, b))])
                if kind == 'branch':
                    killed = probe['exit'] == 2 and 'missingMemory 3' in probe['stdout']
                else:
                    observed = lean_result(probe)
                    killed = (observed['events'] == [] if kind == 'trace' else observed['value'] == 1)
            require(killed, 'PROOF-MUTATION survived ' + name)
            path.write_text(original)
            restored = capture(['leancho', '--warn', '-C', folder], timeout=180)
            require(restored['exit'] == 0 and '0 errors, 0 sorries, 0 warnings' in restored['stdout'],
                    'PROOF-MUTATION restore ' + name)
            control = capture([folder / '.lake/build/bin/sourceModel', json.dumps(request(transaction('add'), 2, 1))])
            require(lean_result(control) == expected('add', 2, 1), 'PROOF-MUTATION control ' + name)
            (WORK / ('MUTANT-' + name + '.json')).write_text(json.dumps(dict(build=built, probe=probe,
                restore=restored, control=control), indent=2) + '\n')
            print('SOURCE-PROOF-MUTANT ' + name + ' killed control=OK', flush=True)
    return len(changes)


def main():
    if sys.argv[1:]:
        return 64
    WORK.mkdir(parents=True, exist_ok=True)
    theorem_count, controls = proofs()
    arithmetic_count, evm_count, recovery_count = live()
    effect_count = effects()
    invalid = driver()
    mutation_count = mutants()
    print(f'SOURCE-PROOFS theorems={theorem_count} arithmetic={arithmetic_count} '
          f'evm={evm_count} recovery={recovery_count} effects={effect_count} invalid={invalid} '
          f'mutants={mutation_count} controls={controls} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as error:
        print('SOURCE-PROOFS FAIL ' + str(error), flush=True)
        sys.exit(1)

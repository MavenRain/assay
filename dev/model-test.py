#!/usr/bin/env python3
"""Compare the source model with frozen expectations and both EVM paths."""
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
WORK = ROOT / '.gatework/model'
BINARY = ROOT / '_build/default/bin/assay.exe'
spec = importlib.util.spec_from_file_location('model_emission', ROOT / 'dev/m1-emit-test.py')
P = importlib.util.module_from_spec(spec)
spec.loader.exec_module(P)
C, D, require = P.C, P.D, P.require


def capture(name, argv, *, cwd=ROOT, env=None, timeout=30):
    result = subprocess.run([str(arg) for arg in argv], cwd=cwd, env=env,
                            capture_output=True, text=True, timeout=timeout)
    (WORK / (name + '.json')).write_text(json.dumps(dict(argv=[str(arg) for arg in argv],
        exit=result.returncode, stdout=result.stdout, stderr=result.stderr), indent=2) + '\n')
    return result


def model(name, source, row, *, extra=(), cwd=ROOT, env=None):
    argv = [BINARY, 'run', source, '--calldata', row['calldata'], '--value', str(row['value'])]
    for key, value in row['before'].items():
        argv.extend(['--storage', str(D.word(key)) + '=' + value])
    result = capture('model-' + name, [*argv, *extra], cwd=cwd, env=env)
    require(result.returncode == 0 and not result.stderr, 'MODEL-EXEC ' + name + ': ' + result.stderr)
    out = json.loads(result.stdout, object_pairs_hook=D.unique)
    require(set(out) == {'status', 'output', 'storage'}, 'MODEL-SHAPE ' + name)
    expected = D.storage({D.RECEIVER: dict(storage=row['after'])}).get(D.RECEIVER, {})
    require(out == dict(status=row['status'], output=row['output'], storage=expected), 'MODEL-EXPECTED ' + name)
    return out


def agreement(name, source, row, folder, *, reference=None, outputs=None):
    out = model(name, source, row)
    output = folder / name
    P.checked('emit-' + name, [BINARY, 'emit', source, '-o', output])
    runtime = (output / 'runtime.hex').read_text().strip()
    if outputs is not None:
        actual = {path.name: hashlib.sha256(path.read_bytes()).hexdigest() for path in output.iterdir()}
        require(actual == outputs, 'MODEL-CORPUS outputs ' + name)
    compiled, _evidence = P.execute('compiled-' + name, runtime, row)
    want = dict(status=out['status'], output=out['output'],
                storage=D.storage({D.RECEIVER: dict(storage={hex(int(key)): value for key, value in out['storage'].items()})}))
    require(all(compiled[key] == value for key, value in want.items()), 'MODEL-DIFF ' + name)
    if reference is not None:
        other, _evidence = P.execute('reference-' + name, reference, row)
        require(all(other[key] == value for key, value in want.items()), 'MODEL-REFERENCE ' + name)


def counter_cases():
    return json.loads((ROOT / 'reference/counter/cases.json').read_text())


def variants():
    selector = 'b4bb58fb'
    # The live gate checks this literal with cast before running variants.
    calldata = selector + f'{5:064x}{2:064x}'
    arithmetic = P.program('''load storage.0 (fun (old : Word 256) =>
  store storage.0 (word 256 9)
    (add old args.0 (fun (result : ResultWord) => case result with
      | 0 (total : Word 256) => sub total args.1 (fun (difference : ResultWord) =>
          case difference with | 0 (value : Word 256) => done value
                               | 1 (err : prod ()) => done (word 256 88))
      | 1 (err : prod ()) => done (word 256 77))))''')
    snapshot = P.program('''load storage.0 (fun (old : Word 256) =>
  store storage.0 (word 256 9) (load storage.0 (fun (now : Word 256) =>
    add old now (fun (result : ResultWord) =>
      case result with | 0 (value : Word 256) => done value | 1 (err : prod ()) => abort))))''')
    return [
        ('arithmetic', arithmetic, P.row('arithmetic', calldata, 10)),
        ('add-recovery', arithmetic, P.row('add-recovery', selector + f'{1:064x}{0:064x}', 77, before=hex(2**256 - 1))),
        ('sub-recovery', arithmetic, P.row('sub-recovery', selector + f'{0:064x}{8:064x}', 88)),
        ('trailing', arithmetic, P.row('trailing', calldata + 'deadbeef', 10)),
        ('short-two', arithmetic, P.row('short-two', calldata[:-2], 0, after='0x7', status='revert')),
        ('snapshot', snapshot, P.row('snapshot', calldata, 16)),
        ('write-abort', P.program('store storage.0 (word 256 9) abort'),
         P.row('write-abort', calldata, 0, after='0x7', status='revert')),
        ('clear', P.program('store storage.0 (word 256 0) (done args.0)'),
         P.row('clear', calldata, 5, after='0x0')),
        ('missing-slot', P.program('load storage.0 (fun (x : Word 256) => done x)'),
         P.row('missing-slot', calldata, 0, after='0x0', before='0x0')),
        ('zero-selector', P.program('done (word 256 5)').replace('prod (a, b)', 'prod (a)').replace('mix', 'blockHashAskewLimitary'),
         P.row('zero-selector', '00000000' + f'{1:064x}', 5, after='0x7')),
    ]


def live():
    manifest = json.loads((ROOT / 'reference/counter/MANIFEST.json').read_text())
    for name, expected in manifest['files'].items():
        require(hashlib.sha256((ROOT / 'reference/counter' / name).read_bytes()).hexdigest() == expected,
                'MODEL-REFERENCE-HASH ' + name)
    reference = (ROOT / 'reference/counter/runtime.hex').read_text().strip()
    selector = P.checked('selector', ['cast', 'sig', 'mix(uint256,uint256)']).strip()[2:]
    require(selector == variants()[0][2]['calldata'][:8], 'MODEL-SELECTOR')
    corpus = json.loads((ROOT / 'corpus/MANIFEST.json').read_text())['cases']
    with tempfile.TemporaryDirectory(prefix='assay-model-') as temporary:
        folder = Path(temporary)
        for row in counter_cases():
            agreement(row['name'], ROOT / 'examples/Counter.asy', row, folder, reference=reference)
        for name, source, row in variants():
            path = folder / (name + '.asy')
            path.write_text(source)
            agreement(name, path, row, folder)
        for case in corpus:
            source = ROOT / case['path']
            require(hashlib.sha256(source.read_bytes()).hexdigest() == case['sha256'], 'MODEL-CORPUS hash')
            name = 'corpus-' + source.stem
            row = dict(name=name, calldata='00ff', value=0, before={},
                       after={hex(int(key)): hex(int(value)) for key, value in case['storage'].items()},
                       status='success', output='0x' + f'{int(case["answer"]):064x}')
            agreement(name, source, row, folder, outputs=case['outputs'])
    print(f'MODEL-LIVE counter={len(counter_cases())} variants={len(variants())} corpus={len(corpus)} executors=2 OK')
    return len(counter_cases()), len(variants()), len(corpus)


def witness(name):
    if name == 'm0-write':
        row = dict(calldata='', value=0, before={}, after={'0': '0x2a'},
                   status='success', output='0x' + f'{42:064x}')
        model(name, ROOT / 'examples/Ref20.asy', row)
        return
    for row in counter_cases():
        if row['name'] == name:
            model(name, ROOT / 'examples/Counter.asy', row)
            return
    for label, source, row in variants():
        if label == name:
            with tempfile.TemporaryDirectory(prefix='assay-model-witness-') as temporary:
                path = Path(temporary) / 'Witness.asy'
                path.write_text(source)
                model(name, path, row)
                return
    require(False, 'MODEL-WITNESS unknown ' + name)


def driver():
    source = ROOT / 'examples/Counter.asy'
    cases = [([], 64, 'usage:'), ([source, '--unknown'], 64, 'usage:'),
             ([source, '--calldata'], 64, 'usage:'),
             ([source, '--calldata', '0x1'], 64, 'RUN_INPUT'),
             ([source, '--calldata', '0xzz'], 64, 'RUN_INPUT'),
             ([source, '--calldata', '00' * 32769], 64, 'RUN_INPUT'),
             ([source, '--calldata', '', '--calldata', ''], 64, 'usage:'),
             ([source, '--value', '0', '--value', '1'], 64, 'usage:'),
             ([source, '--export', 'main', '--export', 'main'], 64, 'usage:'),
             ([source, '--storage', '1'], 64, 'RUN_INPUT'),
             ([source, '--storage', '1=2=3'], 64, 'RUN_INPUT'),
             ([source, '--storage', '1=0', '--storage', '0x01=3'], 64, 'duplicate storage slot'),
             ([source, '--storage', str(2**256) + '=1'], 64, 'RUN_INPUT'),
             ([source, '--storage', '0=' + str(2**256)], 64, 'RUN_INPUT'),
             ([source, '--export', 'missing'], 2, 'M1 missing'),
             ([ROOT / 'examples/m0-spine.kan'], 2, 'M0_PROTOCOL')]
    for value in ('-1', '+1', '1_0', '0x', '', '0b1', '0o7', 'ff', '1 2', str(2**256), '0x' + 'f' * 65):
        cases.append(([source, '--value', value], 64, 'RUN_INPUT'))
    cases.append(([source, *[arg for i in range(1025) for arg in ('--storage', f'{i}=0')]], 64, 'RUN_INPUT'))
    for index, (args, code, marker) in enumerate(cases):
        result = capture(f'driver-{index}', [BINARY, 'run', *args])
        require(result.returncode == code and not result.stdout and marker in result.stderr, 'MODEL-DRIVER ' + str(index))
    with tempfile.TemporaryDirectory(prefix='assay model paths ') as temporary:
        folder = Path(temporary)
        path = folder / 'Counter $literal.asy'
        path.write_text(source.read_text())
        row = next(row for row in counter_cases() if row['name'] == 'get-nonzero')
        model('no-tools', path, row, cwd=folder, env=dict(os.environ, PATH=''))
        model('uppercase', path, dict(row, calldata='0X6D4CE63C', value='0X0'))
        model('max-calldata', path, dict(row, calldata=row['calldata'] + 'ff' * (32768 - 4)))
        slots = {hex(index): '0x0' for index in range(1023)}
        slots[hex(2**256 - 1)] = hex(2**256 - 1)
        model('max-storage', path, dict(row, before=slots, after=slots, output='0x' + '0' * 64))
        result = capture('default', [BINARY, 'run', ROOT / 'examples/Ref20.asy'])
        require(result.returncode == 0 and not result.stderr and json.loads(result.stdout) ==
                dict(status='success', output='0x' + f'{42:064x}', storage={'0': '0x2a'}), 'MODEL-DEFAULT')
        path.write_text(source.read_text().replace('def main :', 'def handle :'))
        model('export', path, row, extra=['--export', 'handle'])
        require({item.name for item in folder.iterdir()} == {path.name}, 'MODEL-NO-FILES')
        good = P.program('done (word 256 5)')
        refusals = [
            (P.program('load (word 256 1) (fun (x : Word 256) => done x)'), 'STORAGE_SLOT'),
            (P.program('load args.0 (fun (x : Word 256) => done x)'), 'STORAGE_SLOT'),
            (P.program('load storage.0 (fun (x : Word 256) => case x as w in Word k return Tx with | word 0 bits value => done (word 256 value))'), 'NAT_REFUSE'),
            (good.replace('| done : Word 256 -> Tx', '| finish : Word 256 -> Tx').replace('=> done ', '=> finish '), 'M1 Tx'),
            (good.replace('ret (word 256 0)', 'read storage.0'), 'constructor must end'),
            (good.replace('ret (word 256 0)', 'ret (word 256 1)'), 'constructor must end'),
        ]
        for index, (text, marker) in enumerate(refusals):
            path.write_text(text)
            result = capture(f'checked-refusal-{index}', [BINARY, 'check', path])
            require(result.returncode == 0 and not result.stderr, 'MODEL-REFUSAL check ' + str(index))
            result = capture(f'refusal-{index}', [BINARY, 'run', path])
            require(result.returncode == 2 and marker in result.stderr and not result.stdout, 'MODEL-REFUSAL ' + str(index))
    print(f'MODEL-DRIVER invalid={len(cases)} positive=6 refusals={len(refusals)} no_tools=true OK')
    return len(cases), len(refusals)


def mutants():
    cases = [
        ('VALUE', 'not (Z.equal input.value Z.zero)', 'false', 'value-get'),
        ('OVERFLOW', 'if Z.sign result < 0 || Z.numbits result > 256\n    then transaction',
         'if Z.sign result < 0 || Z.numbits result > 257\n    then transaction', 'add-recovery'),
        ('UNDERFLOW', 'if Z.sign result < 0 || Z.numbits result > 256\n    then transaction',
         'if Z.sign result < -1 || Z.numbits result > 256\n    then transaction', 'sub-recovery'),
        ('BOUND', 'Z.leq left right', 'Z.lt left right', 'increment-at-limit'),
        ('SNAPSHOT', '(index, get storage slot)', '(index, Z.mul (get storage slot) Z.zero)', 'snapshot'),
        ('ROLLBACK', 'Ok (revert initial)', 'Ok (revert storage)', 'write-abort'),
        ('HEAD', 'String.length input.data < 8 + 64 * count', 'String.length input.data < 8', 'short-two'),
        ('M0-WRITE', 'closed (put storage slot value) next', 'closed (put storage slot (Z.mul value Z.zero)) next', 'm0-write'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-model-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/model.ml'
        original = path.read_text()
        for name, before, after, witness_name in cases:
            require(original.count(before) == 1, 'MODEL-MUTANT-ANCHOR ' + name)
            path.write_text(original.replace(before, after))
            build = capture('mutant-' + name + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
            require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'MODEL-MUTANT-BUILD ' + name)
            result = capture('mutant-' + name, ['python3', '-P', 'dev/model-test.py', 'witness', witness_name], cwd=copy)
            require(result.returncode != 0, 'MODEL-MUTANT-SURVIVED ' + name)
            require(result.returncode == 1 and 'MODEL-EXPECTED ' + witness_name in result.stdout,
                    'MODEL-MUTANT-WITNESS ' + name)
            path.write_text(original)
            build = capture('control-' + name + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
            require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'MODEL-CONTROL-BUILD ' + name)
            result = capture('control-' + name, ['python3', '-P', 'dev/model-test.py', 'witness', witness_name], cwd=copy)
            require(result.returncode == 0 and not result.stderr, 'MODEL-CONTROL ' + name)
            print('MODEL-MUTANT ' + name + ' witness=' + witness_name + ' killed control=OK', flush=True)
    print(f'MODEL-MUTANTS killed={len(cases)}/{len(cases)} controls={len(cases)} OK')
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        witness(sys.argv[2])
        return
    if sys.argv[1:] == ['driver']:
        driver()
        return
    if sys.argv[1:] == ['mutants']:
        mutants()
        return
    require(not sys.argv[1:], 'MODEL-USAGE')
    counter, extra, corpus = live()
    invalid, refusals = driver()
    killed = mutants()
    print(f'SOURCE-MODEL counter={counter} variants={extra} corpus={corpus} invalid={invalid} refusals={refusals} mutants={killed} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('SOURCE-MODEL FAIL: ' + str(error))
        sys.exit(1)

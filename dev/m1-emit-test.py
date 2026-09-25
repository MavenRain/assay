#!/usr/bin/env python3
"""Compare compiled M1 core programs with the committed counter oracle."""
import hashlib
import importlib.util
import json
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/m1-emission'
BINARY = ROOT / '_build/bin/assay'


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


C = module('emission_counter', 'dev/counter-test.py')
D = C.DIFF
require = D.require


def capture(name, argv, *, cwd=ROOT, timeout=30):
    result = subprocess.run([str(arg) for arg in argv], cwd=cwd, capture_output=True, text=True, timeout=timeout)
    (WORK / (name + '.json')).write_text(json.dumps(dict(argv=[str(arg) for arg in argv],
        exit=result.returncode, stdout=result.stdout, stderr=result.stderr), indent=2) + '\n')
    return result


def checked(name, argv):
    result = capture(name, argv)
    require(result.returncode == 0 and not result.stderr, 'M1-TOOL ' + name + ': ' + result.stderr)
    return result.stdout


def emit(source, output, name, *extra):
    checked(name, [BINARY, 'emit', source, '-o', output, *extra])
    require({path.name for path in output.iterdir()} ==
            {'runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt'}, 'M1-FIVE-FILES')
    require((output / 'axioms.txt').read_text() == 'EvmOpcodes\n', 'M1-AXIOMS')
    return (output / 'runtime.hex').read_text().strip(), (output / 'init.hex').read_text().strip()


def listing(name, runtime):
    data = checked(name + '-listing', [ROOT / '_build/test/asm_cases', 'listing', runtime])
    ours = C.ASM.normalized(data, pc_base=16)
    cast = C.ASM.normalized(checked(name + '-cast', ['cast', 'disassemble', '0x' + runtime]), pc_base=16)
    path = WORK / (name + '.hex')
    path.write_text(runtime + '\n')
    geth = C.ASM.normalized(checked(name + '-geth', ['evm', 'disasm', path]), pc_base=16, header=runtime)
    require(ours == cast == geth, 'M1-DISASM ' + name)
    return ours


def execute(name, runtime, row):
    report, evidence = D.execute(runtime, row['calldata'], C.fixture(row), shutil.which('evm'), value=row['value'])
    (WORK / (name + '.json')).write_text(json.dumps(dict(report=report, evidence=evidence), indent=2) + '\n')
    C.expected(report, row)
    return report, evidence


def counter():
    reference = ROOT / 'reference/counter'
    manifest = json.loads((reference / 'MANIFEST.json').read_text())
    for name, expected in manifest['files'].items():
        require(hashlib.sha256((reference / name).read_bytes()).hexdigest() == expected, 'M1-REFERENCE-HASH ' + name)
    cases = json.loads((reference / 'cases.json').read_text())
    reference_runtime = (reference / 'runtime.hex').read_text().strip()
    with tempfile.TemporaryDirectory(prefix='assay-m1-emit-') as temporary:
        output = Path(temporary) / 'Counter'
        runtime, init = emit(ROOT / 'examples/Counter.asy', output, 'emit-counter')
        require(init.endswith(runtime), 'M1-CREATION suffix')
        prefix = init[:-len(runtime)]
        for name in ('abi.json', 'layout.json'):
            require(json.loads((output / name).read_text()) == json.loads((reference / name).read_text()),
                    'M1-GOLD ' + name)
        rows = listing('runtime', runtime)
        prefix_rows = listing('prefix', prefix)
        declared = {pc: opcode for pc, opcode, _immediate in rows}
        covered = set()
        for row in cases:
            ours, evidence = execute('source-' + row['name'], runtime, row)
            other, _evidence = execute('reference-' + row['name'], reference_runtime, row)
            require(all(ours[key] == other[key] for key in ('status', 'output', 'storage')), 'M1-DIFF ' + row['name'])
            steps = D.objects(evidence['run'])[:-2]
            require(all(step['pc'] in declared and step['opName'] == declared[step['pc']] for step in steps),
                    'M1-PC ' + row['name'])
            covered.update(step['pc'] for step in steps)
        require(covered == set(declared), 'M1-COVERAGE missing=' + str(sorted(set(declared) - covered)))
        C.WORK = WORK
        creates = C.creation(runtime, prefix, prefix_rows)
        (WORK / 'OUTPUTS.json').write_text(json.dumps(dict(runtime_bytes=len(runtime) // 2,
            init_bytes=len(init) // 2, files={path.name: hashlib.sha256(path.read_bytes()).hexdigest()
                                          for path in sorted(output.iterdir())}), indent=2) + '\n')
    print(f'M1-DIFF cases={len(cases)} creates={creates} covered={len(covered)} five_files=5 scope=core OK')


def core():
    return (ROOT / 'examples/Counter.asy').read_text().split('-- Alias names')[0]


def program(body):
    return core() + '''def cell : Type 0 := Word 256
def Storage : Type 0 := prod (cell)
def storage : Storage := tuple (word 256 0)
def a : Type 0 := Word 256
def b : Type 0 := Word 256
def mix : Type 0 := prod (a, b)
def Entry : Type 0 := sum (mix)
def constructor : Eff := ret (word 256 0)
def main : Entry -> Tx := fun (entry : Entry) =>
  case entry with | 0 (args : mix) => ''' + body + '\n'


def row(name, calldata, result, after='0x9', status='success', before='0x7'):
    return dict(name=name, calldata=calldata, value=0, before={'0': before, '2': '0xabc'},
                after={'0': after, '2': '0xabc'}, status=status,
                output='0x' + (f'{result:064x}' if status == 'success' else ''))


def sources():
    arithmetic = program('''load storage.0 (fun (old : Word 256) =>
  store storage.0 (word 256 9)
    (add old args.0 (fun (result : ResultWord) =>
      case result with
      | 0 (total : Word 256) => sub total args.1 (fun (difference : ResultWord) =>
        case difference with | 0 (value : Word 256) => done value
                             | 1 (err : prod ()) => done (word 256 88))
      | 1 (err : prod ()) => done (word 256 77))))''')
    snapshot = program('''load storage.0 (fun (old : Word 256) =>
  store storage.0 (word 256 9) (load storage.0 (fun (now : Word 256) =>
    add old now (fun (result : ResultWord) =>
      case result with | 0 (value : Word 256) => done value | 1 (err : prod ()) => abort))))''')
    constant = program('done (word 256 5)')
    zero_name = 'blockHashAskewLimitary'
    collision_name = 'blockHashAddendsInexpansible'
    zero_selector = constant.replace('prod (a, b)', 'prod (a)').replace('mix', zero_name)
    collision = zero_selector.replace('def Entry :', f'def {collision_name} : Type 0 := prod (a)\ndef Entry :')
    collision = collision.replace(f'sum ({zero_name})', f'sum ({zero_name}, {collision_name})')
    collision += f'  | 1 (args : {collision_name}) => done (word 256 5)\n'
    for name in (zero_name, collision_name):
        signature = name + '(uint256)'
        ours = checked('collision-ours-' + name, [ROOT / '_build/test/keccak_vec', 'selector', signature.encode().hex()]).strip()
        other = checked('collision-cast-' + name, ['cast', 'sig', signature]).strip()
        require(ours == other == '0x00000000', 'M1-COLLISION fixture')
    selector = checked('mix-selector', ['cast', 'sig', 'mix(uint256,uint256)']).strip()[2:]
    calldata = lambda a, b: selector + f'{a:064x}{b:064x}'
    cases = [('success', arithmetic, row('success', calldata(5, 2), 10)),
             ('add-error', arithmetic, row('add-error', calldata(1, 0), 77, before=hex(2**256 - 1))),
             ('sub-error', arithmetic, row('sub-error', calldata(0, 8), 88)),
             ('trailing', arithmetic, row('trailing', calldata(5, 2) + 'deadbeef', 10)),
             ('short-two-args', arithmetic, row('short-two-args', calldata(5, 2)[:-2], 0, after='0x7', status='revert')),
             ('snapshot', snapshot, row('snapshot', calldata(0, 0), 16)),
             ('view', constant, row('view', calldata(0, 0), 5, after='0x7')),
             ('zero-selector', zero_selector, row('zero-selector', '00000000' + f'{1:064x}', 5, after='0x7'))]
    refusals = [
        ('slot-range', program('load (word 256 1) (fun (x : Word 256) => done x)'), 'STORAGE_SLOT'),
        ('slot-dynamic', program('load args.0 (fun (x : Word 256) => done x)'), 'STORAGE_SLOT'),
        ('runtime-nat', program('load storage.0 (fun (x : Word 256) => case x as w in Word k return Tx with | word 0 bits value => done (word 256 value))'), 'NAT_REFUSE'),
        ('schema', constant.replace('| done : Word 256 -> Tx', '| finish : Word 256 -> Tx').replace('=> done ', '=> finish '), 'M1 Tx'),
        ('word-width', constant.replace('def b : Type 0 := Word 256', 'def b : Type 0 := Word 128'), 'M1 b'),
        ('slot-gap', constant.replace('tuple (word 256 0)', 'tuple (word 256 1)'), 'STORAGE_SLOT'),
        ('constructor-read', constant.replace('ret (word 256 0)', 'read storage.0'), 'constructor must end'),
        ('constructor-return', constant.replace('ret (word 256 0)', 'ret (word 256 1)'), 'constructor must end'),
        ('export-type', constant.replace('def main : Entry -> Tx', 'def main : Entry -> Nat').replace('=> done (word 256 5)', '=> 5'), 'export must have type'),
        ('entry-repeat', constant.replace('sum (mix)', 'sum (mix, mix)').replace('case entry with | 0', 'case entry with | 1 (ignored : mix) => done (word 256 0) | 0'), 'M1 Entry'),
        ('selector-collision', collision, 'ABI_SELECTOR_COLLISION: 00000000'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-m1-sources-') as temporary:
        folder = Path(temporary)
        for name, source, expected in cases:
            path = folder / (name + '.asy')
            path.write_text(source)
            output = folder / name
            runtime, _init = emit(path, output, 'emit-' + name)
            execute('variant-' + name, runtime, expected)
            abi = json.loads((output / 'abi.json').read_text())
            require(abi[1] == dict(type='function', name=zero_name if name == 'zero-selector' else 'mix',
                inputs=[dict(name=n, type='uint256') for n in (('a',) if name == 'zero-selector' else ('a', 'b'))],
                outputs=[dict(name='', type='uint256')], stateMutability='view' if name in ('view', 'zero-selector') else 'nonpayable'), 'M1-ABI variant')
        for name, source, marker in refusals:
            path = folder / (name + '.asy')
            path.write_text(source)
            checked('check-' + name, [BINARY, 'check', path])
            output = folder / name
            result = capture('refuse-' + name, [BINARY, 'emit', path, '-o', output])
            require(result.returncode == 2 and marker in result.stderr and not output.exists(),
                    'M1-REFUSAL ' + name + ': ' + result.stderr)
        path = folder / 'alias.asy'
        path.write_text(constant.replace('def main :', 'def handle :'))
        emit(path, folder / 'alias', 'export-alias', '--export', 'handle')
        output = folder / 'missing'
        result = capture('missing-export', [BINARY, 'emit', path, '-o', output])
        require(result.returncode == 2 and not output.exists(), 'M1-EXPORT missing')
    print(f'M1-SOURCES live={len(cases)} refusals={len(refusals)} exports=2 OK')


def mutants():
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-m1-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, relative, before, after, mode, witness in cases:
            path = copy / relative
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'M1-MUTANT-ANCHOR ' + name)
            path.write_text(native_mutations.replace(original, before, after))
            build = capture('mutant-' + name + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
            require(build.returncode == 0, 'M1-MUTANT-BUILD ' + name + build.stdout)
            result = capture('mutant-' + name + '-test', ['python3', '-P', 'dev/m1-emit-test.py', mode], cwd=copy, timeout=120)
            require(result.returncode == 1 and 'M1-EMISSION FAIL: ' + witness in result.stdout, 'M1-MUTANT-SURVIVED ' + name + result.stdout)
            path.write_text(original)
            build = capture('control-' + name + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
            require(build.returncode == 0, 'M1-CONTROL-BUILD ' + name)
            result = capture('control-' + name + '-test', ['python3', '-P', 'dev/m1-emit-test.py', mode], cwd=copy, timeout=120)
            require(result.returncode == 0, 'M1-CONTROL ' + name + result.stdout)
            print('M1-MUTANT ' + name + ' killed, restored control passed', flush=True)
    print(f'M1-MUTANTS killed={len(cases)}/{len(cases)} controls={len(cases)} OK')


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    if sys.argv[1:] not in ([], ['counter'], ['sources'], ['mutants']):
        print('usage: m1-emit-test.py [counter|sources|mutants]')
        return 64
    if sys.argv[1:] == ['mutants']:
        mutants()
        return 0
    if sys.argv[1:] != ['sources']:
        counter()
    if sys.argv[1:] != ['counter']:
        sources()
    if not sys.argv[1:]:
        mutants()
        print('M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.TimeoutExpired) as error:
        print('M1-EMISSION FAIL: ' + str(error))
        sys.exit(1)

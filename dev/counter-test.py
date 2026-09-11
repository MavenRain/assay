#!/usr/bin/env python3
"""Validate the frozen counter reference before source emission targets it."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
REFERENCE = ROOT / 'reference/counter'
WORK = ROOT / '.gatework/counter'


def module(name, relative):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


DIFF = module('counter_diff', 'evm/diff.py')
REF = module('counter_reference', 'dev/reference-test.py')
ASM = module('counter_listing', 'dev/asm-test.py')
require = DIFF.require


def run(name, *argv):
    result = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True, timeout=30)
    (WORK / (name + '.json')).write_text(json.dumps(dict(argv=argv, exit=result.returncode,
                                                       stdout=result.stdout, stderr=result.stderr), indent=2) + '\n')
    require(result.returncode == 0 and not result.stderr, 'COUNTER-TOOL ' + name)
    return result.stdout


def labels(rows):
    """Derive the one label map the listing itself determines."""
    entries = [index for index, (_pc, opcode, _immediate) in enumerate(rows) if opcode == 'PUSH4']
    require(len(entries) == 3 and all([rows[index + step][1] for step in (1, 2, 3)] == ['EQ', 'PUSH2', 'JUMPI']
                                      for index in entries), 'COUNTER-LABELS dispatch shape')
    fallback = entries[-1] + 4
    require([rows[fallback][1], rows[fallback + 1][1]] == ['PUSH2', 'JUMP'], 'COUNTER-LABELS fallback shape')
    targets = [int(rows[index + 2][2], 16) for index in entries] + [int(rows[fallback][2], 16)]
    named = dict(zip(('increment', 'decrement', 'get', 'reject'), targets))
    dests = {pc for pc, opcode, _immediate in rows if opcode == 'JUMPDEST'}
    require(len(set(targets)) == 4 and set(targets) <= dests, 'COUNTER-LABELS targets')
    spare = sorted(dests - set(targets))
    require(len(spare) == 2, 'COUNTER-LABELS spare')
    named['save'], named['return'] = spare
    return named


def frozen():
    manifest = json.loads((REFERENCE / 'MANIFEST.json').read_text(), object_pairs_hook=DIFF.unique)
    require(manifest['version'] == 1 and manifest['fork'] == 'Cancun', 'COUNTER-MANIFEST')
    require(set(manifest['files']) == {'runtime.evm', 'runtime.hex', 'init-prefix.evm',
                                      'init.hex', 'abi.json', 'layout.json', 'cases.json'}, 'COUNTER-INVENTORY')
    for name, expected in manifest['files'].items():
        require(hashlib.sha256((REFERENCE / name).read_bytes()).hexdigest() == expected, 'COUNTER-HASH ' + name)
    runtime, rows = REF.source(ROOT, 'counter/runtime.evm')
    prefix, prefix_rows = REF.source(ROOT, 'counter/init-prefix.evm')
    require((REFERENCE / 'runtime.hex').read_text() == runtime + '\n'
            and (REFERENCE / 'init.hex').read_text() == prefix + runtime + '\n', 'COUNTER-BYTES')
    require(len(runtime) == 2 * manifest['runtime_bytes'] == 354
            and len(prefix) == 2 * manifest['init_prefix_bytes'] == 54, 'COUNTER-SIZE')
    require(manifest['labels'] == labels(rows)
            and set(manifest['labels'].values()) == {pc for pc, opcode, _ in rows if opcode == 'JUMPDEST'},
            'COUNTER-LABELS')
    for name, data, declared in [('runtime', runtime, rows), ('init-prefix', prefix, prefix_rows)]:
        hexfile = WORK / (name + '.hex')
        hexfile.write_text(data + '\n')
        cast = ASM.normalized(run(name + '-cast', 'cast', 'disassemble', '0x' + data), pc_base=16)
        geth = ASM.normalized(run(name + '-geth', 'evm', 'disasm', str(hexfile)), pc_base=16, header=data)
        require(declared == cast == geth, 'COUNTER-LISTING ' + name)
    abi = json.loads((REFERENCE / 'abi.json').read_text())
    require(abi[0] == dict(type='constructor', inputs=[], stateMutability='nonpayable'), 'COUNTER-ABI constructor')
    expected_selectors = {'increment(uint256)': '7cf5dab0', 'decrement(uint256)': '3a9ebefd', 'get()': '6d4ce63c'}
    require(manifest['selectors'] == expected_selectors and len(abi) == 4, 'COUNTER-ABI selectors')
    selectors = []
    for row, name in zip(abi[1:], ('increment', 'decrement', 'get')):
        require(row == dict(type='function', name=name,
                            inputs=[] if name == 'get' else [dict(name='n', type='uint256')],
                            outputs=[dict(name='', type='uint256')],
                            stateMutability='view' if name == 'get' else 'nonpayable'), 'COUNTER-ABI ' + name)
        signature = name + ('()' if name == 'get' else '(uint256)')
        ours = run(name + '-selector', str(ROOT / '_build/default/test/keccak_vec.exe'),
                   'selector', signature.encode().hex()).strip()
        other = run(name + '-cast-selector', 'cast', 'sig', signature).strip()
        require(ours == other == '0x' + expected_selectors[signature], 'COUNTER-SELECTOR ' + name)
        selectors.append(ours[2:])
    require([immediate for _pc, opcode, immediate in rows if opcode == 'PUSH4'] == selectors, 'COUNTER-DISPATCH')
    layout = json.loads((REFERENCE / 'layout.json').read_text())
    require(layout == dict(storage=[dict(astId=i, contract='Counter', label=name, offset=0,
                                         slot=str(i), type='t_uint256') for i, name in enumerate(('count', 'limit'))],
                           types=dict(t_uint256=dict(encoding='inplace', label='uint256', numberOfBytes='32'))),
            'COUNTER-LAYOUT')
    return runtime, prefix, rows, prefix_rows


def fixture(row):
    state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
    state['alloc'] = {DIFF.SENDER: dict(balance='0xa'),
                      DIFF.RECEIVER: dict(balance='0x0', storage=row['before'])}
    return state


def expected(report, row):
    want = DIFF.storage({DIFF.RECEIVER: dict(storage=row['after'])})
    require(report['status'] == row['status'] and report['output'] == row['output']
            and report['storage'] == want, 'COUNTER-EXPECTED ' + row['name'])


def execute(runtime, row, name=None):
    report, evidence = DIFF.execute(runtime, row['calldata'], fixture(row), shutil.which('evm'), value=row['value'])
    (WORK / ((name or row['name']) + '.json')).write_text(json.dumps(dict(report=report, evidence=evidence), indent=2) + '\n')
    expected(report, row)
    return report, evidence


def creation(runtime, prefix, prefix_rows):
    state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
    state['alloc'] = {DIFF.SENDER: dict(balance='0xa')}
    covered = set()
    with tempfile.TemporaryDirectory(prefix='assay-counter-create-') as directory:
        path = Path(directory) / 'prestate.json'
        path.write_text(json.dumps(state))
        for value in (0, 1):
            records = DIFF.objects(run('create-' + str(value), 'evm', '--verbosity', '0', 'run',
                                      '--prestate', str(path), '--sender', '0x' + DIFF.SENDER,
                                      '--code', prefix + runtime, '--value', str(value), '--create', '--json', '--dump'))
            outcome = DIFF.run_outcome('\n'.join(json.dumps(record) for record in records))
            require(outcome['status'] == ('success' if value == 0 else 'revert'), 'COUNTER-CREATE status')
            accounts = records[-1]['accounts']
            installed = [account for owner, account in accounts.items() if DIFF.address(owner) != DIFF.SENDER]
            if value == 0:
                require(outcome['output'] == runtime and len(installed) == 1
                        and installed[0]['code'] == '0x' + runtime, 'COUNTER-CREATE runtime')
                require(DIFF.storage({DIFF.RECEIVER: installed[0]}) == {DIFF.RECEIVER: {'1': '0x64'}},
                        'COUNTER-CREATE storage')
            else:
                require(outcome['output'] == '' and not installed, 'COUNTER-CREATE rollback')
            declared = {pc: opcode for pc, opcode, _ in prefix_rows}
            require(all(step['pc'] in declared and step['opName'] == declared[step['pc']]
                        for step in records[:-2]), 'COUNTER-CREATE trace')
            covered.update(step['pc'] for step in records[:-2])
    require(covered == {pc for pc, _opcode, _immediate in prefix_rows}, 'COUNTER-CREATE coverage')
    return 2


def mutants(runtime, rows, cases):
    # Each edit preserves instruction width and reaches a named semantic witness.
    choices = [
        ('CALLVALUE', 'CALLVALUE', 0, '5f', 'value-increment'),
        ('OVERFLOW', 'LT', 2, '11', 'increment-overflow'),
        ('BOUND', 'GT', 0, '10', 'increment-over-limit'),
        ('UNDERFLOW', 'GT', 1, '10', 'decrement-underflow'),
        ('SUBTRACTION', 'SUB', 0, '01', 'decrement-success'),
        ('STORE', 'SSTORE', 0, '50', 'increment-success'),
        ('SHORT-HEAD', 'PUSH1', 0, '6004', 'increment-short-31'),
        ('SELECTOR', 'PUSH4', 0, '637cf5dab1', 'increment-success'),
    ]
    for name, opcode, index, replacement, witness in choices:
        candidates = [pc for pc, op, immediate in rows if op == opcode
                      and (name != 'SHORT-HEAD' or immediate == '24')]
        pc = candidates[index]
        damaged = runtime[:2 * pc] + replacement + runtime[2 * pc + len(replacement):]
        require(damaged != runtime, 'COUNTER-MUTANT unchanged ' + name)
        row = next(row for row in cases if row['name'] == witness)
        try:
            execute(damaged, row, 'mutant-' + name)
        except ValueError as error:
            require(str(error) == 'COUNTER-EXPECTED ' + witness, 'COUNTER-MUTANT wrong failure ' + name + ': ' + str(error))
        else:
            raise ValueError('COUNTER-MUTANT survived ' + name)
        execute(runtime, row, 'control-' + name)
        print('COUNTER-MUTANT ' + name + ' witness=' + witness + ' killed control=OK', flush=True)
    return len(choices)


def value_checks():
    row = dict(before={}, after={}, calldata='', value=7, name='value-probe',
               status='success', output='0x' + f'{7:064x}')
    execute('345f5260205ff3', row)
    rejected = 0
    for value, message in [(-1, 'DIFF_NUMBER'), (2 ** 256, 'DIFF_NUMBER'), (True, 'DIFF_NUMBER'),
                           ('bad', 'DIFF_NUMBER'), (11, 'DIFF_VALUE')]:
        try:
            DIFF.execute('00', '', fixture(row), shutil.which('evm'), value=value)
        except ValueError as error:
            require(str(error).startswith(message), 'COUNTER-VALUE wrong rejection')
            rejected += 1
        else:
            raise ValueError('COUNTER-VALUE accepted invalid value')
    return rejected


def main():
    require(sys.argv[1:] == [], 'usage: counter-test.py')
    WORK.mkdir(parents=True, exist_ok=True)
    # The reused reference parser retains its independent listing captures here.
    (ROOT / '.gatework/reference/counter').mkdir(parents=True, exist_ok=True)
    runtime, prefix, rows, prefix_rows = frozen()
    cases = json.loads((REFERENCE / 'cases.json').read_text(), object_pairs_hook=DIFF.unique)
    require(len(cases) == 30 and len({row['name'] for row in cases}) == 30, 'COUNTER-CASES')
    covered = set()
    for row in cases:
        report, evidence = execute(runtime, row)
        steps = DIFF.objects(evidence['run'])[:-2]
        declared = {pc: opcode for pc, opcode, _ in rows}
        require(all(step['pc'] in declared and step['opName'] == declared[step['pc']] for step in steps), 'COUNTER-TRACE')
        covered.update(step['pc'] for step in steps)
        print(f'COUNTER-CASE {row["name"]} status={report["status"]} run_gas={report["run_gas"]} OK', flush=True)
    require(covered == {pc for pc, _opcode, _immediate in rows}, 'COUNTER-COVERAGE')
    creates = creation(runtime, prefix, prefix_rows)
    rejected = value_checks()
    killed = mutants(runtime, rows, cases)
    print(f'COUNTER-REFERENCE cases={len(cases)} creates={creates} mutants={killed} value_rejected={rejected} '
          f'covered={len(covered)} scope=reference OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('COUNTER-REFERENCE FAIL ' + str(error))
        sys.exit(1)

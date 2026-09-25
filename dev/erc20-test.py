#!/usr/bin/env python3
"""Check the frozen M2 reference against listings, state, ABI and event oracles."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
REFERENCE = ROOT / 'reference/erc20'
WORK = ROOT / '.gatework/erc20'


def module(name, relative):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


DIFF = module('erc20_diff', 'evm/diff.py')
REF = module('erc20_reference', 'dev/reference-test.py')
ASM = module('erc20_listing', 'dev/asm-test.py')
require = DIFF.require


def read(name):
    return json.loads((REFERENCE / name).read_text(), object_pairs_hook=DIFF.unique)


def save(name, value):
    (WORK / (name + '.json')).write_text(json.dumps(value, indent=2) + '\n')


def run(name, *argv):
    result = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True, timeout=30)
    save(name, dict(argv=argv, exit=result.returncode, stdout=result.stdout, stderr=result.stderr))
    require(result.returncode == 0 and not result.stderr, 'ERC20-TOOL ' + name)
    return result.stdout.strip()


def hash_check(name, preimage, expected):
    ours = run(name + '-ours', str(ROOT / '_build/test/keccak_vec'), 'hash', preimage[2:])
    other = run(name + '-cast', 'cast', 'keccak', preimage)
    require(ours == other == expected, 'ERC20-HASH ' + name)


def metadata(manifest):
    definitions = [
        ('name', [], 'string'), ('symbol', [], 'string'), ('decimals', [], 'uint8'),
        ('totalSupply', [], 'uint256'), ('balanceOf', [('owner', 'address')], 'uint256'),
        ('allowance', [('owner', 'address'), ('spender', 'address')], 'uint256'),
        ('transfer', [('to', 'address'), ('value', 'uint256')], 'bool'),
        ('approve', [('spender', 'address'), ('value', 'uint256')], 'bool'),
        ('transferFrom', [('from', 'address'), ('to', 'address'), ('value', 'uint256')], 'bool')]
    expected = [dict(type='constructor', inputs=[], stateMutability='nonpayable')]
    selectors = {}
    for name, inputs, output in definitions:
        expected.append(dict(type='function', name=name,
                             inputs=[dict(name=n, type=t) for n, t in inputs],
                             outputs=[dict(name='', type=output)],
                             stateMutability='nonpayable' if output == 'bool' else 'view'))
        signature = name + '(' + ','.join(t for _n, t in inputs) + ')'
        ours = run(name + '-selector', str(ROOT / '_build/test/keccak_vec'),
                   'selector', signature.encode().hex())
        other = run(name + '-cast-selector', 'cast', 'sig', signature)
        require(ours == other, 'ERC20-SELECTOR ' + name)
        selectors[signature] = ours[2:]
    for name, first, second in [('Transfer', 'from', 'to'), ('Approval', 'owner', 'spender')]:
        expected.append(dict(type='event', name=name, anonymous=False,
                             inputs=[dict(name=first, type='address', indexed=True),
                                     dict(name=second, type='address', indexed=True),
                                     dict(name='value', type='uint256', indexed=False)]))
        signature = name + '(address,address,uint256)'
        hash_check(name, '0x' + signature.encode().hex(), manifest['topics'][name])
    require(read('abi.json') == expected and manifest['selectors'] == selectors, 'ERC20-ABI')
    require(set(manifest['topics']) == {'Transfer', 'Approval'}, 'ERC20-TOPICS')
    layout = read('layout.json')
    names = [('totalSupply', 't_uint256'), ('balances', 't_mapping(t_address,t_uint256)'),
             ('allowances', 't_mapping(t_address,t_mapping(t_address,t_uint256))')]
    types = {'t_uint256': dict(encoding='inplace', label='uint256', numberOfBytes='32'),
             't_address': dict(encoding='inplace', label='address', numberOfBytes='20')}
    for type_name, value, label in [
        (names[1][1], 't_uint256', 'mapping(address => uint256)'),
        (names[2][1], names[1][1], 'mapping(address => mapping(address => uint256))')]:
        types[type_name] = dict(encoding='mapping', label=label, numberOfBytes='32', key='t_address', value=value)
    require(layout == dict(storage=[dict(astId=i, contract='ERC20', label=name, offset=0,
                                         slot=str(i), type=t) for i, (name, t) in enumerate(names)], types=types),
            'ERC20-LAYOUT')
    slots = read('slots.json')
    owners = dict(alice=int(DIFF.SENDER, 16), bob=int('2b5ad5c4795c026514f8317c7a215e218dccd6cf', 16),
                  carol=0xb0b, zero=0, maximum=2**160-1)
    expected_names = {'balance-' + name for name in owners} | {
        'allowance-alice-bob', 'allowance-bob-alice', 'allowance-alice-alice',
        'allowance-alice-zero', 'allowance-alice-maximum'}
    require(len(slots) == 10 and {r['name'] for r in slots} == expected_names, 'ERC20-SLOTS')
    for row in slots:
        kind, *people = row['name'].split('-')
        owner = owners[people[0]]
        if kind == 'balance':
            require(row['preimage'] == f'0x{owner:064x}{1:064x}', 'ERC20-SLOT balance order')
        else:
            require(row['outer_preimage'] == f'0x{owner:064x}{2:064x}', 'ERC20-SLOT outer order')
            hash_check(row['name'] + '-outer', row['outer_preimage'], row['outer_slot'])
            require(row['preimage'] == f'0x{owners[people[1]]:064x}' + row['outer_slot'][2:],
                    'ERC20-SLOT inner order')
        hash_check(row['name'], row['preimage'], row['slot'])


def frozen():
    manifest = read('MANIFEST.json')
    require(manifest['version'] == 1 and manifest['fork'] == 'Cancun', 'ERC20-MANIFEST')
    require(set(manifest['files']) == {'runtime.evm', 'runtime.hex', 'init-prefix.evm', 'init.hex',
                                      'abi.json', 'layout.json', 'slots.json', 'cases.json'}, 'ERC20-INVENTORY')
    for name, expected in manifest['files'].items():
        require(hashlib.sha256((REFERENCE / name).read_bytes()).hexdigest() == expected, 'ERC20-PIN ' + name)
    runtime, rows = REF.source(ROOT, 'erc20/runtime.evm')
    prefix, prefix_rows = REF.source(ROOT, 'erc20/init-prefix.evm')
    require((REFERENCE / 'runtime.hex').read_text() == runtime + '\n'
            and (REFERENCE / 'init.hex').read_text() == prefix + runtime + '\n', 'ERC20-BYTES')
    require(len(runtime) == 2 * manifest['runtime_bytes'] == 1596
            and len(prefix) == 2 * manifest['init_prefix_bytes'] == 214, 'ERC20-SIZE')
    require(len(rows) == manifest['runtime_instructions'] == 431
            and len(prefix_rows) == manifest['init_instructions'], 'ERC20-INSTRUCTIONS')
    require(set(manifest['labels'].values()) == {pc for pc, op, _arg in rows if op == 'JUMPDEST'}, 'ERC20-LABELS')
    for name, data, declared in [('runtime', runtime, rows), ('init-prefix', prefix, prefix_rows)]:
        path = WORK / (name + '.hex')
        path.write_text(data + '\n')
        cast = ASM.normalized(run(name + '-cast', 'cast', 'disassemble', '0x' + data), pc_base=16)
        geth = ASM.normalized(run(name + '-geth', 'evm', 'disasm', str(path)), pc_base=16, header=data)
        require(declared == cast == geth, 'ERC20-LISTING ' + name)
    metadata(manifest)
    require([arg for _pc, op, arg in rows if op == 'PUSH4'] == list(manifest['selectors'].values()), 'ERC20-DISPATCH')
    return manifest, runtime, prefix, rows, prefix_rows


def trace_logs(records, status):
    """Reconstruct this call-free reference's LOG operands from traced MSTOREs.

    Geth run omits receipt logs. Cancun t8n receipt logs are checked separately.
    No memory copying may precede a later log in this deliberately bounded decoder.
    """
    memory, logs, copied = bytearray(4096), [], False
    for step in records:
        op = step['opName']
        stack = [int(value, 16) for value in step['stack']]
        if op == 'MSTORE':
            offset = stack[-1]
            require(offset + 32 <= len(memory), 'ERC20-LOG memory bound')
            memory[offset:offset + 32] = stack[-2].to_bytes(32, 'big')
        elif op in ('CODECOPY', 'CALLDATACOPY', 'RETURNDATACOPY', 'EXTCODECOPY', 'MCOPY', 'MSTORE8'):
            copied = True
        elif op.startswith('LOG'):
            count = int(op[3:])
            offset, length = stack[-1], stack[-2]
            require(not copied and offset + length <= len(memory), 'ERC20-LOG unsupported memory')
            logs.append(dict(topics=[f'0x{stack[-3-i]:064x}' for i in range(count)],
                             data='0x' + memory[offset:offset + length].hex()))
    return [] if status == 'revert' else logs


def expected(report, evidence, row):
    want_storage = DIFF.storage({DIFF.RECEIVER: dict(storage=row['after'])})
    transition = DIFF.objects(evidence['transition'])[0]
    receipt = transition['result']['receipts'][0]
    receipt_logs = receipt.get('logs') or []
    require(all(DIFF.address(log['address']) == DIFF.RECEIVER
                and DIFF.quantity(log['logIndex']) == i and not log['removed']
                and DIFF.quantity(log['transactionIndex']) == 0
                and log['transactionHash'] == receipt['transactionHash']
                for i, log in enumerate(receipt_logs)), 'ERC20-LOG receipt metadata')
    logs = [dict(topics=log['topics'], data=log['data']) for log in receipt_logs]
    run_logs = trace_logs(DIFF.objects(evidence['run'])[:-2], report['status'])
    t8n_logs = trace_logs(DIFF.objects(next(iter(evidence['traces'].values())))[:-1], report['status'])
    require(report['status'] == row['status'] and report['output'] == row['output']
            and report['storage'] == want_storage and logs == run_logs == t8n_logs == row['logs'],
            'ERC20-EXPECTED ' + row['name'])


def execute(runtime, row, name=None):
    state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
    state['alloc'] = {row['caller'][2:]: dict(balance='0xa'),
                      DIFF.RECEIVER: dict(balance='0x0', storage=row['before'])}
    report, evidence = DIFF.execute(runtime, row['calldata'], state, shutil.which('evm'),
                                    value=row['value'], caller=row['caller'])
    save(name or row['name'], dict(report=report, evidence=evidence))
    expected(report, evidence, row)
    return report, evidence


def creation(runtime, prefix, prefix_rows, topic):
    declared = {pc: op for pc, op, _arg in prefix_rows}
    covered = set()
    creates = 0
    slots = {row['name']: row['slot'] for row in read('slots.json')}
    for owner, caller in [('alice', DIFF.SENDER), ('bob', '2b5ad5c4795c026514f8317c7a215e218dccd6cf')]:
        state = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
        state['alloc'] = {caller: dict(balance='0xa')}
        with tempfile.TemporaryDirectory(prefix='assay-erc20-create-') as directory:
            path = Path(directory) / 'prestate.json'
            path.write_text(json.dumps(state))
            for value in (0, 1):
                raw = run('create-' + owner + '-' + str(value), 'evm', '--verbosity', '0', 'run',
                          '--prestate', str(path), '--sender', '0x' + caller, '--code', prefix + runtime,
                          '--value', str(value), '--create', '--json', '--dump')
                records, outcome = DIFF.objects(raw), DIFF.run_outcome(raw)
                require(outcome['status'] == ('success' if value == 0 else 'revert'), 'ERC20-CREATE status')
                installed = [a for key, a in records[-1]['accounts'].items() if DIFF.address(key) != caller]
                logs = trace_logs(records[:-2], outcome['status'])
                if value == 0:
                    require(outcome['output'] == runtime and len(installed) == 1
                            and installed[0]['code'] == '0x' + runtime, 'ERC20-CREATE runtime')
                    want = DIFF.storage({DIFF.RECEIVER: dict(storage={'0x0': '0x3e8', slots['balance-' + owner]: '0x3e8'})})
                    require(DIFF.storage({DIFF.RECEIVER: installed[0]}) == want, 'ERC20-CREATE storage')
                    require(logs == [dict(topics=[topic, '0x' + '0' * 64, '0x' + caller.zfill(64)],
                                          data='0x' + f'{1000:064x}')], 'ERC20-CREATE mint event')
                else:
                    require(outcome['output'] == '' and not installed and logs == [], 'ERC20-CREATE rollback')
                require(all(declared.get(step['pc']) == step['opName'] for step in records[:-2]), 'ERC20-CREATE trace')
                covered.update(step['pc'] for step in records[:-2])
                creates += 1
    require(covered == set(declared), 'ERC20-CREATE coverage')
    require(creates == 4, 'ERC20-CREATE count')
    return creates


def mutants(runtime, rows, manifest, cases):
    choices = [
        ('CALLVALUE', 'callvalue', '34', '5f', 'value-transfer'),
        ('BALANCE-SLOT', 'balance-base', '6001', '6002', 'balance-alice'),
        ('ALLOWANCE-SLOT', 'approve-base', '6002', '6001', 'approve-success'),
        ('ALLOWANCE-BOUND', 'allowance-bound', '10', '11', 'transferFrom-allowance-short'),
        ('ALLOWANCE-SPEND', 'allowance-subtraction', '03', '01', 'transferFrom-success'),
        ('BALANCE-BOUND', 'balance-bound', '10', '11', 'transfer-insufficient'),
        ('OVERFLOW', 'recipient-overflow', '10', '11', 'transfer-recipient-overflow'),
        ('EVENT-TOPIC', 'transfer-topic', '7f' + manifest['topics']['Transfer'][2:],
         '7f' + f'{int(manifest["topics"]["Transfer"], 16) ^ 1:064x}', 'transfer-success'),
        ('EVENT-DATA', 'transfer-data-size', '6020', '6000', 'transfer-success'),
        ('DYNAMIC-OFFSET', 'name-offset', '6020', '6040', 'read-name'),
        ('ADDRESS-WIDTH', 'address-width', '60a0', '60a1', 'balanceOf-dirty-address-0')]
    require(set(manifest['mutation_sites']) == {site for _name, site, _old, _new, _witness in choices}, 'ERC20-SITES')
    for name, site, old, new, witness in choices:
        pc = manifest['mutation_sites'][site]
        require(pc in {pc for pc, _op, _arg in rows} and runtime[pc*2:pc*2+len(old)] == old
                and len(old) == len(new) and old != new, 'ERC20-MUTANT site ' + name)
        damaged = runtime[:pc*2] + new + runtime[pc*2+len(old):]
        row = next(row for row in cases if row['name'] == witness)
        try:
            execute(damaged, row, 'mutant-' + name)
        except ValueError as error:
            require(str(error) == 'ERC20-EXPECTED ' + witness, 'ERC20-MUTANT wrong failure ' + name + ': ' + str(error))
        else:
            raise ValueError('ERC20-MUTANT survived ' + name)
        execute(runtime, row, 'control-' + name)
        print('ERC20-MUTANT ' + name + ' witness=' + witness + ' killed control=OK', flush=True)
    return len(choices)


def main():
    require(sys.argv[1:] == [], 'usage: erc20-test.py')
    WORK.mkdir(parents=True, exist_ok=True)
    (ROOT / '.gatework/reference/erc20').mkdir(parents=True, exist_ok=True)
    manifest, runtime, prefix, rows, prefix_rows = frozen()
    cases = read('cases.json')
    require(len(cases) == manifest['cases'] == 85 and len({r['name'] for r in cases}) == 85, 'ERC20-CASES')
    declared = {pc: op for pc, op, _arg in rows}
    covered = set()
    for row in cases:
        report, evidence = execute(runtime, row)
        steps = DIFF.objects(evidence['run'])[:-2]
        require(all(declared.get(step['pc']) == step['opName'] for step in steps), 'ERC20-TRACE')
        covered.update(step['pc'] for step in steps)
        print('ERC20-CASE ' + row['name'] + ' status=' + report['status'] + ' OK', flush=True)
    require(covered == set(declared), 'ERC20-COVERAGE missing=' + str(sorted(set(declared) - covered)))
    creates = creation(runtime, prefix, prefix_rows, manifest['topics']['Transfer'])
    killed = mutants(runtime, rows, manifest, cases)
    print(f'ERC20-REFERENCE cases={len(cases)} creates={creates} mutants={killed} '
          f'covered={len(covered)} scope=reference OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, IndexError, subprocess.SubprocessError) as error:
        print('ERC20-REFERENCE FAIL ' + str(error))
        sys.exit(1)

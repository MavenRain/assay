#!/usr/bin/env python3
"""Compare two offline geth entry points on one prepared Cancun prestate."""
import argparse
import copy
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

# Public fixture key 1, used only to sign an offline, zero-price transaction.
SENDER = '7e5f4552091a69125d5dfcb7b8c2659029395bdf'
RECEIVER = '0000000000000000000000007265636569766572'
GAS = 16_777_216
ENV_SHA = 'ba2f41ea46c17853e2e22be873a2be703db19a60b59cfe1951c8e8cae44cb967'
# Block context that the two entry points cannot expose with equal values.
CONTEXT = {0x45: 'GASLIMIT', 0x48: 'BASEFEE', 0x4a: 'BLOBBASEFEE'}


def require(ok, message):
    if not ok:
        raise ValueError(message)


def unique(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'DIFF_JSON: duplicate key ' + key)
        result[key] = value
    return result


def objects(text):
    decoder = json.JSONDecoder(object_pairs_hook=unique)
    result = []
    tail = text.lstrip()
    while tail:
        value, end = decoder.raw_decode(tail)
        require(isinstance(value, dict), 'DIFF_JSON: expected object')
        result.append(value)
        tail = tail[end:].lstrip()
    return result


def byte_hex(value):
    require(isinstance(value, str), 'DIFF_HEX: expected bytes')
    value = value.lower().removeprefix('0x')
    require(re.fullmatch(r'(?:[0-9a-f]{2})*', value) is not None, 'DIFF_HEX: invalid bytes')
    return value


def quantity(value, bits=256):
    require(type(value) is int or isinstance(value, str), 'DIFF_NUMBER: invalid quantity')
    if isinstance(value, str):
        require(re.fullmatch(r'(?:0x[0-9a-fA-F]+|[0-9]+)', value) is not None,
                'DIFF_NUMBER: invalid quantity')
    number = int(value, 16 if value.startswith('0x') else 10) if isinstance(value, str) else value
    require(0 <= number < 2 ** bits, 'DIFF_NUMBER: quantity out of range')
    return number


def address(value):
    result = byte_hex(value)
    require(len(result) == 40, 'DIFF_ADDRESS: expected 20 bytes')
    return result


def word(value):
    require(isinstance(value, str), 'DIFF_STORAGE: expected hex word')
    value = value.lower().removeprefix('0x')
    require(re.fullmatch(r'[0-9a-f]{1,64}', value) is not None, 'DIFF_STORAGE: invalid word')
    return int(value, 16)


def storage(alloc):
    require(isinstance(alloc, dict), 'DIFF_STATE: missing accounts')
    result = {}
    seen = set()
    for key, account in alloc.items():
        owner = address(key)
        require(owner not in seen and isinstance(account, dict), 'DIFF_STATE: duplicate or invalid account')
        seen.add(owner)
        slots = account.get('storage', {})
        require(isinstance(slots, dict), 'DIFF_STORAGE: expected slots')
        values = {}
        for slot, value in slots.items():
            index = word(slot)
            require(index not in values, 'DIFF_STORAGE: duplicate slot')
            values[index] = word(value)
        nonzero = {str(index): hex(value) for index, value in sorted(values.items()) if value != 0}
        if nonzero:
            result[owner] = nonzero
    return result


def prepare(prestate, runtime):
    require(isinstance(prestate, dict) and isinstance(prestate.get('alloc'), dict),
            'DIFF_PRESTATE: expected Cancun genesis with alloc')
    environment = {key: value for key, value in prestate.items() if key != 'alloc'}
    digest = hashlib.sha256(json.dumps(environment, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    require(digest == ENV_SHA, 'DIFF_PRESTATE: only the pinned Cancun environment is supported')
    result = copy.deepcopy(prestate)
    alloc = {}
    for key, value in result['alloc'].items():
        owner = address(key)
        require(owner in (SENDER, RECEIVER) and owner not in alloc and isinstance(value, dict),
                'DIFF_PRESTATE: only unique fixture sender and receiver accounts are supported')
        require(set(value) <= {'balance', 'nonce', 'storage', 'code'}, 'DIFF_PRESTATE: unsupported account field')
        require(byte_hex(value.get('code', '')) == '', 'DIFF_PRESTATE: account code must be empty')
        slots = storage({owner: value}).get(owner, {})
        alloc[owner] = dict(balance=hex(quantity(value.get('balance', 0))),
                            nonce=hex(quantity(value.get('nonce', 0), 64)),
                            storage={f'0x{int(slot):064x}': f'0x{int(val, 16):064x}' for slot, val in slots.items()})
    for owner in (SENDER, RECEIVER):
        alloc.setdefault(owner, dict(balance='0x0', nonce='0x0', storage={}))
    require(quantity(alloc[SENDER]['nonce']) < 2 ** 64 - 1, 'DIFF_PRESTATE: sender nonce is exhausted')
    alloc[RECEIVER]['code'] = '0x' + byte_hex(runtime)
    result['alloc'] = alloc
    return result


def outcome(records, state):
    require(len(records) >= 1, 'DIFF_TRACE: missing summary')
    summary = records[-1]
    require('output' in summary and 'gasUsed' in summary and 'pc' not in summary,
            'DIFF_TRACE: missing execution summary')
    require(all('pc' in step and 'op' in step for step in records[:-1]), 'DIFF_TRACE: malformed step')
    errors = [row['error'] for row in records if row.get('error') not in (None, '')]
    require(all(error == 'execution reverted' for error in errors), 'DIFF_EXECUTION: EVM fault')
    gas = quantity(summary['gasUsed'])
    require(gas <= GAS, 'DIFF_TRACE: gas exceeds execution allowance')
    return dict(status='revert' if errors else 'success', output=byte_hex(summary['output']),
                storage=storage(state), gas=gas)


def run_outcome(text):
    records = objects(text)
    require(len(records) >= 2 and 'accounts' in records[-1], 'DIFF_RUN: missing state dump')
    return outcome(records[:-1], records[-1]['accounts'])


def transition_outcome(text, traces):
    records = objects(text)
    require(len(records) == 1, 'DIFF_T8N: expected one result')
    report = records[0]
    require(isinstance(report.get('result'), dict) and isinstance(report.get('alloc'), dict),
            'DIFF_T8N: missing result or alloc')
    result = report['result']
    require(not result.get('rejected'), 'DIFF_T8N: transaction rejected')
    receipts = result.get('receipts')
    require(isinstance(receipts, list) and len(receipts) == 1 and isinstance(receipts[0], dict),
            'DIFF_T8N: expected one receipt')
    receipt = receipts[0]
    require(quantity(receipt.get('transactionIndex')) == 0, 'DIFF_T8N: wrong receipt index')
    txhash = byte_hex(receipt.get('transactionHash'))
    require(len(txhash) == 64 and set(traces) == {'trace-0-0x' + txhash + '.jsonl'},
            'DIFF_T8N: missing or unrelated transaction trace')
    execution = outcome(objects(next(iter(traces.values()))), report['alloc'])
    expected = 0 if execution['status'] == 'revert' else 1
    require(quantity(receipt.get('status')) == expected, 'DIFF_T8N: receipt and trace disagree')
    return execution, quantity(receipt.get('gasUsed'))


def compare(left, right):
    for field in ('status', 'output', 'storage'):
        require(left[field] == right[field], 'DIFF_MISMATCH: ' + field)


def invoke(evm, args, data=None):
    process = subprocess.run([evm, '--verbosity', '0', *args], input=data,
                             capture_output=True, text=True, timeout=30)
    require(process.returncode == 0, f'DIFF_EXECUTOR: exit {process.returncode}: {process.stderr.strip()}')
    require(not process.stderr.strip(), 'DIFF_EXECUTOR: unexpected stderr: ' + process.stderr.strip())
    return process.stdout


def supported(runtime):
    # PUSH data is not an opcode.  The two geth entry points cannot expose
    # the same block context while preserving the same execution allowance:
    # the runner adds intrinsic gas to the t8n block gas limit and pins a
    # zero base fee and a zero excess blob gas for t8n only.
    code = bytes.fromhex(runtime)
    pc = 0
    while pc < len(code):
        opcode = code[pc]
        require(opcode not in CONTEXT,
                'DIFF_CONTEXT: ' + CONTEXT.get(opcode, 'context') + ' is not supported')
        pc += 1 + (opcode - 0x5f if 0x60 <= opcode <= 0x7f else 0)


def execute(runtime, calldata, prestate, evm, *, value=0):
    runtime, calldata = byte_hex(runtime), byte_hex(calldata)
    value = quantity(value)
    require(len(runtime) <= 49152 and len(calldata) <= 65536, 'DIFF_LIMIT: code or calldata is too large')
    supported(runtime)
    prepared = prepare(prestate, runtime)
    require(quantity(prepared['alloc'][SENDER]['balance']) >= value,
            'DIFF_VALUE: sender balance is below call value')
    intrinsic = 21000 + sum(4 if byte == 0 else 16 for byte in bytes.fromhex(calldata))
    env = dict(currentCoinbase=prepared['coinbase'], currentGasLimit=hex(GAS + intrinsic),
               currentNumber=prepared['number'], currentTimestamp=prepared['timestamp'],
               currentRandom='0x' + '00' * 32, currentBaseFee='0x0',
               currentExcessBlobGas=prepared['excessBlobGas'], withdrawals=[],
               parentBeaconBlockRoot='0x' + '00' * 32)
    tx = dict(nonce=prepared['alloc'][SENDER]['nonce'], gasPrice='0x0', gas=hex(GAS + intrinsic),
              to='0x' + RECEIVER, value=hex(value), input='0x' + calldata,
              secretKey='0x' + '0' * 63 + '1', v='0x0', r='0x0', s='0x0')
    with tempfile.TemporaryDirectory(prefix='assay-diff-') as directory:
        work = Path(directory)
        genesis = work / 'prestate.json'
        genesis.write_text(json.dumps(prepared))
        run_text = invoke(evm, ['run', '--prestate', str(genesis), '--gas', str(GAS),
                               '--sender', '0x' + SENDER, '--receiver', '0x' + RECEIVER,
                               '--code', runtime, '--input', calldata, '--value', str(value), '--json', '--dump'])
        t8n_text = invoke(evm, ['t8n', '--state.fork', 'Cancun', '--state.chainid', '1',
                               '--state.reward', '-1', '--input.alloc', 'stdin', '--input.env', 'stdin',
                               '--input.txs', 'stdin', '--output.alloc', 'stdout', '--output.result', 'stdout',
                               '--output.body', '', '--output.basedir', str(work), '--trace'],
                          json.dumps(dict(alloc=prepared['alloc'], env=env, txs=[tx])))
        traces = {path.name: path.read_text() for path in work.glob('trace-*')}
        left = run_outcome(run_text)
        right, charged_gas = transition_outcome(t8n_text, traces)
        compare(left, right)
        report = dict(fork='Cancun', status=left['status'], output='0x' + left['output'],
                      storage=left['storage'], run_gas=left['gas'], t8n_execution_gas=right['gas'],
                      t8n_transaction_gas=charged_gas, intrinsic_gas=intrinsic)
        return report, dict(run=run_text, transition=t8n_text, traces=traces)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime', required=True)
    parser.add_argument('--calldata', required=True)
    parser.add_argument('--prestate', required=True)
    parser.add_argument('--value', default='0')
    args = parser.parse_args()
    evm = next((str(Path(path) / 'evm') for path in os.environ.get('PATH', '').split(':')
                if path and shutil.which(str(Path(path) / 'evm'))), None)
    require(evm is not None, 'DIFF_TOOL: evm is not on PATH')
    records = objects(Path(args.prestate).read_text())
    require(len(records) == 1, 'DIFF_PRESTATE: expected one genesis')
    report, _evidence = execute(args.runtime, args.calldata, records[0], evm, value=args.value)
    print(json.dumps(report, sort_keys=True, separators=(',', ':')))
    print('DIFF OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('assay: diff: ' + str(error), file=sys.stderr)
        sys.exit(2)

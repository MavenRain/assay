#!/usr/bin/env python3
"""Check the source ERC20 against frozen outcomes and independent EVM handlers."""
import gzip
from concurrent.futures import ThreadPoolExecutor
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/erc20-source'
spec = importlib.util.spec_from_file_location('source_erc20_reference', ROOT / 'dev/erc20-test.py')
E = importlib.util.module_from_spec(spec)
spec.loader.exec_module(E)
C = E.module('source_erc20_context', 'dev/context-test.py')
D = E.DIFF
require = E.require
CASES_SHA256 = '62cf183de7a336f601b966237a9e96e75deabab4d6232c5be887abf2fe6dcb79'
CANONICAL_REFUSALS = {
    'read-name-trailing', 'read-symbol-trailing', 'read-decimals-trailing',
    'read-totalSupply-trailing', 'balance-alice-trailing', 'allowance-forward-trailing',
    'transfer-success-trailing', 'approve-success-trailing', 'transferFrom-success-trailing',
}
LITERAL_BOUND = 'SURFACE_ABI: String literal requires (string 0xHEX) with at most 31 bytes'
LITERAL_REFUSALS = {
    'odd': ('0x1', 'SURFACE_ABI: String literal requires even hexadecimal bytes'),
    'invalid': ('0xgg', 'SURFACE_ABI: String literal requires hexadecimal bytes'),
    'wide': ('0x' + '01' * 32, LITERAL_BOUND),
    'decimal': ('12', LITERAL_BOUND),
    'extra': ('0x01 0x02', LITERAL_BOUND),
}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def logs(records, status):
    """Reconstruct static LOG data from sparse MSTORE witnesses, before RETURN."""
    if status == 'revert':
        return []
    positions = [i for i, row in enumerate(records) if row.get('opName', '').startswith('LOG')]
    if not positions:
        return []
    memory, result = {}, []
    for row in records[:positions[-1] + 1]:
        op = row['opName']
        stack = [int(value, 16) for value in row['stack']]
        if op == 'MSTORE':
            for i, byte in enumerate(stack[-2].to_bytes(32, 'big')):
                memory[stack[-1] + i] = byte
        elif op.startswith('LOG'):
            offset, length = stack[-1], stack[-2]
            require(length <= 131072, 'ERC20-SOURCE log data bound')
            result.append(dict(topics=[f'0x{stack[-3-i]:064x}' for i in range(int(op[3:]))],
                               data='0x' + bytes(memory.get(offset + i, 0) for i in range(length)).hex()))
        else:
            require(op not in ('MSTORE8', 'MCOPY', 'CALLDATACOPY', 'CODECOPY', 'RETURNDATACOPY', 'EXTCODECOPY'),
                    'ERC20-SOURCE unsupported copy before a static log: ' + op)
    return result


def compile_source(name, source):
    output = WORK / ('compiled-' + name)
    if output.exists():
        shutil.rmtree(output)
    C.checked('check-' + name, [C.BINARY, 'check', source])
    C.checked('emit-' + name, [C.BINARY, 'emit', source, '-o', output])
    return output, (output / 'runtime.hex').read_text().strip()


def compare(source, runtime, row, *, event_schema=True):
    name = row['name']
    expected = dict(status=row['status'], output=row['output'], logs=row['logs'],
                    storage=D.storage({D.RECEIVER: dict(storage=row['after'])}).get(D.RECEIVER, {}))
    argv = [C.BINARY, 'run', source, '--calldata', row['calldata'], '--caller', row['caller'],
            '--value', str(row['value'])]
    for key, value in row['before'].items():
        argv += ['--storage', f'{key}={value}']
    result = C.capture('model-' + name, argv, timeout=90)
    require(result.returncode == 0, name + ': model tool failed: ' + result.stderr)
    modeled = json.loads(result.stdout)
    if not event_schema:
        require('logs' not in modeled, name + ': legacy model schema')
        modeled = dict(modeled, logs=[])
    require(modeled == expected, name + ': model mismatch: ' + json.dumps(modeled))
    state = C.prestate(row['before'])
    state['alloc'] = {row['caller'][2:]: dict(balance=hex(10**24)),
                      D.RECEIVER: dict(balance='0x0', storage=row['before'])}
    actual, raw = D.execute(runtime, row['calldata'], state, shutil.which('evm'),
                            value=row['value'], caller=row['caller'])
    receipt = D.objects(raw['transition'])[0]['result']['receipts'][0]
    receipt_logs = [dict(topics=log['topics'], data=log['data']) for log in receipt.get('logs') or []]
    observed = dict(status=actual['status'], output=actual['output'],
                    storage=actual['storage'].get(D.RECEIVER, {}), logs=receipt_logs)
    require(observed == expected, name + ': Cancun mismatch: ' + json.dumps(observed))
    traced = logs(D.objects(raw['run'])[:-2], actual['status'])
    require(traced == row['logs'], name + ': geth LOG mismatch')
    transition_logs = logs(D.objects(next(iter(raw['traces'].values())))[:-1], actual['status'])
    require(transition_logs == row['logs'], name + ': Cancun trace LOG mismatch')
    payload = json.dumps(dict(report=actual, evidence=raw), sort_keys=True).encode()
    (WORK / (name + '.json.gz')).write_bytes(gzip.compress(payload, mtime=0))
    return dict(name=name, expected=expected, model=modeled, cancun=observed, geth_logs=traced,
                model_schema='events' if event_schema else 'legacy',
                runtime_sha256=digest(bytes.fromhex(runtime)), evidence_sha256=digest(payload))


def creation(compiled, runtime):
    init = (compiled / 'init.hex').read_text().strip()
    slot = C.checked('genesis-slot', ['cast', 'index', 'address', '0x' + D.SENDER, '1']).strip()
    wanted = D.storage({D.RECEIVER: dict(storage={'0x0': '0x3e8', slot: '0x3e8'})})
    cases = []
    for caller in (D.SENDER, '2b5ad5c4795c026514f8317c7a215e218dccd6cf'):
        state = C.prestate()
        state['alloc'] = {caller: dict(balance='0xa')}
        with tempfile.TemporaryDirectory(prefix='assay-source-erc20-') as directory:
            path = Path(directory) / 'prestate.json'
            path.write_text(json.dumps(state))
            for value in (0, 1):
                name = 'create-' + caller + '-' + str(value)
                raw = C.checked(name, ['evm', '--verbosity', '0', 'run', '--prestate', path,
                                      '--sender', '0x' + caller, '--code', init, '--value', str(value),
                                      '--create', '--json', '--dump'])
                records, outcome = D.objects(raw), D.run_outcome(raw)
                installed = [account for key, account in records[-1]['accounts'].items()
                             if D.address(key) != caller]
                require(outcome['status'] == ('revert' if value else 'success'), name + ': status')
                if value == 0:
                    require(outcome['output'] == runtime and len(installed) == 1
                            and installed[0]['code'] == '0x' + runtime, name + ': deployed code')
                    require(D.storage({D.RECEIVER: installed[0]}) == wanted, name + ': genesis state')
                else:
                    require(outcome['output'] == '' and not installed, name + ': creation rollback')
                require(logs(records[:-2], outcome['status']) == [], name + ': closed constructor has no logs')
                cases.append(dict(name=name, status=outcome['status'], raw_sha256=digest(raw.encode())))
    return cases


def literals():
    cases = []
    # Independent ABI word construction also covers embedded zeros and UTF-8 bytes.
    for name, data in [('empty', b''), ('zero', b'\0'), ('utf8', 'A\0\u03bb'.encode()),
                       ('max', bytes(range(31)))]:
        path = WORK / ('literal-' + name + '.asy')
        path.write_text('contract Literal where storage State := { cell : Word }\n'
                        'entry get () : Eff Sig String := do sstore cell (word 9) ; pure (string 0x'
                        + data.hex() + ')\nconstructor := do pure ()\n')
        _, runtime = compile_source('literal-' + name, path)
        output = '0x' + f'{32:064x}{len(data):064x}' + data.hex().ljust(((len(data) + 31) // 32) * 64, '0')
        row = dict(name='literal-' + name, caller='0x' + D.SENDER, value=0, calldata='6d4ce63c',
                   before={}, after={'0x0': '0x9'}, status='success', output=output, logs=[])
        cases.append(compare(path, runtime, row, event_schema=False))
    path = WORK / 'string-parameter-name.asy'
    path.write_text('contract StringParameter where storage State := { cell : Word }\n'
                    'entry get (string : String) : Eff Sig String := do pure (string)\n'
                    'constructor := do pure ()\n')
    _, runtime = compile_source('string-parameter-name', path)
    data = b'x' * 40
    calldata = C.checked('string-parameter-calldata', ['cast', 'calldata', 'get(string)', data.decode()]).strip()[2:]
    output = '0x' + f'{32:064x}{len(data):064x}' + data.hex().ljust(128, '0')
    cases.append(compare(path, runtime, dict(name='string-parameter-name', caller='0x' + D.SENDER,
                         value=0, calldata=calldata, before={}, after={}, status='success', output=output, logs=[]), event_schema=False))
    sourced = {'SURFACE_ABI: ' + text for text in
               re.findall(r'"(String literal requires[^"]*)"', (ROOT / 'src/string_literal.bend').read_text())}
    require(sourced == {diagnostic for _, diagnostic in LITERAL_REFUSALS.values()},
            'literal refusals must cover each String literal diagnostic in src/string_literal.bend: '
            + repr(sorted(sourced)))
    refused = []
    for name, (literal, diagnostic) in LITERAL_REFUSALS.items():
        path = WORK / ('bad-literal-' + name + '.asy')
        path.write_text('contract BadLiteral where storage State := { cell : Word }\n'
                        'entry get () : Eff Sig String := do pure (string ' + literal + ')\n'
                        'constructor := do pure ()\n')
        for command in ('check', 'emit', 'run'):
            args = ['-o', WORK / ('refused-' + name)] if command == 'emit' else (['--calldata', '6d4ce63c'] if command == 'run' else [])
            result = C.capture(command + '-bad-' + name, [C.BINARY, command, path, *args])
            require(result.returncode != 0 and diagnostic in result.stderr,
                    name + ': literal must be refused by ' + command + ': ' + result.stderr)
            refused.append(name + ':' + command)
    return cases, refused


def zero_caller(source, runtime):
    """Pin the documented zero transfer caller difference outside the frozen corpus.

    A signed t8n transaction cannot come from the zero address, so this probe uses
    the model and plain geth runs, as an unsigned eth_call would.
    """
    zero, to = '00' * 20, '2b5ad5c4795c026514f8317c7a215e218dccd6cf'
    calldata = 'a9059cbb' + to.rjust(64, '0') + '00' * 32
    result = C.capture('model-zero-caller', [C.BINARY, 'run', source, '--calldata', calldata,
                                             '--caller', '0x' + zero, '--value', '0'], timeout=90)
    require(result.returncode == 0, 'zero-caller: model tool failed: ' + result.stderr)
    modeled = json.loads(result.stdout)
    require(modeled == dict(status='revert', output='0x', storage={}, logs=[]),
            'zero-caller: model must reject a zero transfer caller: ' + json.dumps(modeled))
    transfer = dict(topics=['0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
                            '0x' + zero.rjust(64, '0'), '0x' + to.rjust(64, '0')], data='0x' + '00' * 32)
    state = C.prestate()
    state['alloc'][zero] = dict(balance='0x0')
    path = WORK / 'zero-caller-prestate.json'
    path.write_text(json.dumps(state))
    reference = (E.REFERENCE / 'runtime.hex').read_text().strip()
    runs = []
    for name, code, wanted in [('source', runtime, ('revert', '', [])),
                               ('reference', reference, ('success', f'{1:064x}', [transfer]))]:
        raw = C.checked('zero-caller-' + name, ['evm', '--verbosity', '0', 'run', '--prestate', path,
                                                '--gas', str(D.GAS), '--sender', '0x' + zero,
                                                '--receiver', '0x' + D.RECEIVER, '--code', code,
                                                '--input', calldata, '--json', '--dump'])
        outcome = D.run_outcome(raw)
        observed = (outcome['status'], outcome['output'], logs(D.objects(raw)[:-2], outcome['status']))
        require(observed == wanted and not outcome['storage'].get(D.RECEIVER),
                'zero-caller: ' + name + ' geth run: ' + json.dumps(observed))
        runs.append(dict(name='zero-caller-' + name, status=outcome['status'], raw_sha256=digest(raw.encode())))
    return dict(model=modeled, runs=runs)


def main():
    require(shutil.which('evm') and shutil.which('cast'), 'evm and cast are required')
    WORK.mkdir(parents=True, exist_ok=True)
    C.WORK = WORK
    source = ROOT / 'examples/ERC20.asy'
    compiled, runtime = compile_source('erc20', source)
    rows = E.read('cases.json')
    require(digest((E.REFERENCE / 'cases.json').read_bytes()) == CASES_SHA256 and len(rows) == 85,
            'ERC20-SOURCE frozen oracle changed')
    require({row['name'] for row in rows if row['name'].endswith('-trailing')} == CANONICAL_REFUSALS,
            'ERC20-SOURCE explicit canonical ABI differences changed')
    # Source typed ABI requires exact tuple consumption. Preserve all other oracles.
    rows = [dict(row, status='revert', output='0x', after=row['before'], logs=[])
            if row['name'] in CANONICAL_REFUSALS else row for row in rows]
    require(len({row['name'] for row in rows}) == len(rows), 'ERC20-SOURCE distinct evidence paths')
    # Each fixture supplies its own state; subprocesses and evidence paths are isolated.
    with ThreadPoolExecutor(max_workers=3) as workers:
        cases = list(workers.map(lambda row: compare(source, runtime, row), rows))
    creates = creation(compiled, runtime)
    strings, refusals = literals()
    zero = zero_caller(source, runtime)
    report = dict(source_sha256=digest(source.read_bytes()), oracle_sha256=CASES_SHA256,
                  runtime_sha256=digest(bytes.fromhex(runtime)), runtime_bytes=len(runtime) // 2,
                  canonical_refusals=sorted(CANONICAL_REFUSALS),
                  cases=cases, creates=creates, literals=strings, refusals=refusals, zero_caller=zero)
    (WORK / 'cases.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'ERC20-SOURCE cases={len(cases)} canonical={len(CANONICAL_REFUSALS)} creates={len(creates)} literals={len(strings)} '
          f'refusals={len(refusals)} zero_caller=1 model=geth=t8n logs=OK rollback=OK OK')


if __name__ == '__main__':
    main()

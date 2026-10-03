#!/usr/bin/env python3
"""Check source results and errors against cast, the model and Cancun execution."""
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/return-abi'
spec = importlib.util.spec_from_file_location('return_abi_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)


def require(ok, message):
    if not ok:
        raise AssertionError(message)


def word(value):
    return f'{value:064x}'


def large_payload(runtime, calldata, initial):
    """Run the 65440-byte and 65472-byte duplicate fixtures outside the shared diff domain."""
    D = C.D
    require(len(calldata) in (8 + 128 + 65440 * 2, 8 + 128 + 65472 * 2) and len(runtime) <= 49152,
            'large fixture bounds')
    D.supported(runtime)
    sender, key = D.identity('0x' + D.SENDER)
    prepared = D.prepare(initial, runtime, caller='0x' + sender)
    intrinsic = 21000 + sum(4 if byte == 0 else 16 for byte in bytes.fromhex(calldata))
    env = dict(currentCoinbase=prepared['coinbase'], currentGasLimit=hex(D.GAS + intrinsic),
               currentNumber=prepared['number'], currentTimestamp=prepared['timestamp'],
               currentRandom='0x' + '00' * 32, currentBaseFee='0x0',
               currentExcessBlobGas=prepared['excessBlobGas'], withdrawals=[],
               parentBeaconBlockRoot='0x' + '00' * 32)
    tx = dict(nonce=prepared['alloc'][sender]['nonce'], gasPrice='0x0', gas=hex(D.GAS + intrinsic),
              to='0x' + D.RECEIVER, value='0x0', input='0x' + calldata,
              secretKey=f'0x{key:064x}', v='0x0', r='0x0', s='0x0')
    with tempfile.TemporaryDirectory(prefix='assay-return-cap-') as directory:
        work = Path(directory)
        genesis = work / 'prestate.json'
        genesis.write_text(json.dumps(prepared))
        run = D.invoke(shutil.which('evm'), ['run', '--prestate', str(genesis), '--gas', str(D.GAS),
                       '--sender', '0x' + sender, '--receiver', '0x' + D.RECEIVER,
                       '--code', runtime, '--input', calldata, '--json', '--dump'])
        transition = D.invoke(shutil.which('evm'), ['t8n', '--state.fork', 'Cancun', '--state.chainid', '1',
                              '--state.reward', '-1', '--input.alloc', 'stdin', '--input.env', 'stdin',
                              '--input.txs', 'stdin', '--output.alloc', 'stdout', '--output.result', 'stdout',
                              '--output.body', '', '--output.basedir', str(work), '--trace'],
                              json.dumps(dict(alloc=prepared['alloc'], env=env, txs=[tx])))
        traces = {path.name: path.read_text() for path in work.glob('trace-*')}
        left = D.run_outcome(run)
        right, _ = D.transition_outcome(transition, traces)
        D.compare(left, right)
        return dict(status=left['status'], output='0x' + left['output'], storage=left['storage']), dict(run=run, transition=transition, traces=traces)


def main():
    require(shutil.which('cast') and shutil.which('evm'), 'cast and evm are required')
    WORK.mkdir(parents=True, exist_ok=True)
    C.WORK = WORK
    source = ROOT / 'examples/ReturnData.asy'
    output = WORK / 'compiled'
    if output.is_dir():
        shutil.rmtree(output)
    C.checked('check', [C.BINARY, 'check', source])
    C.checked('emit', [C.BINARY, 'emit', source, '-o', output])
    runtime = (output / 'runtime.hex').read_text().strip()
    abi = json.loads((output / 'abi.json').read_text())
    functions = {row['name']: row for row in abi if row['type'] == 'function'}
    errors = {row['name']: row for row in abi if row['type'] == 'error'}
    expected_outputs = dict(narrow='uint8', addressOf='address', boolean='bool', wide='uint256',
                            echo='string', echoLast='string', deny='uint256', fail='uint256',
                            failPair='uint256', duplicate='uint256', narrowError='uint256', legacy='uint256')
    require(set(functions) == set(expected_outputs), 'complete function ABI')
    for name, typ in expected_outputs.items():
        require([item['type'] for item in functions[name]['outputs']] == [typ], name + ': result ABI')
    require({name: [item['type'] for item in row['inputs']] for name, row in errors.items()} ==
            dict(Denied=[], Narrow=['uint8'], Wrapped=['uint8', 'address', 'bool', 'string'],
                 Pair=['string', 'string']), 'complete custom error ABI')
    require(functions['echo']['stateMutability'] == 'nonpayable', 'echo mutability')
    require(functions['echoLast']['stateMutability'] == 'view', 'echoLast mutability')

    cases = []

    def calldata(signature, *args):
        return C.checked('cast-call-' + str(len(cases)), ['cast', 'calldata', signature, *map(str, args)]).strip()[2:]

    def encoded(types, *args):
        return C.checked('cast-result-' + str(len(cases)), ['cast', 'abi-encode', 'f(' + types + ')', *map(str, args)]).strip()

    def add(name, signature, args, payload, status='success', cell=7):
        data = calldata(signature, *args)
        cases.append((name, data, status, payload, cell))
        return data

    for value in (0, 1, 254, 255):
        add('uint8-' + str(value), 'narrow(uint256)', [value], encoded('uint8', value), cell=value)
    for value in (256, (1 << 256) - 1):
        add('uint8-overflow-' + str(value), 'narrow(uint256)', [value], '0x', 'revert')
    for value in (0, (1 << 160) - 1):
        add('address-' + str(value), 'addressOf(uint256)', [value], encoded('address', '0x' + f'{value:040x}'))
    add('address-overflow', 'addressOf(uint256)', [1 << 160], '0x', 'revert')
    for value in (0, 1):
        add('bool-' + str(value), 'boolean(uint256)', [value], encoded('bool', 'true' if value else 'false'))
    add('bool-overflow', 'boolean(uint256)', [2], '0x', 'revert')
    add('uint256-max', 'wide(uint256)', [(1 << 256) - 1], encoded('uint256', (1 << 256) - 1))
    for text in ('', 'a', 'x' * 31, 'x' * 32, 'x' * 33, 'x' * 65, 'hello 🐙'):
        echo = add('echo-' + str(len(cases)), 'echo(string)', [text], encoded('string', text), cell=9)
        add('second-' + str(len(cases)), 'echoLast(string,string)', ['ignored', text], encoded('string', text))
    add('denied', 'deny()', [], '0x' + calldata('Denied()'), 'revert')
    owner = '0x' + 'ff' * 20
    for text in ('', 'custom error 🐙', 'x' * 33):
        payload = '0x' + calldata('Wrapped(uint8,address,bool,string)', 255, owner, 'true', text)
        add('wrapped-' + str(len(cases)), 'fail(uint8,address,bool,string)', [255, owner, 'true', text], payload, 'revert')
    for first, second in (('', ''), ('a', 'b' * 33), ('x' * 33, 'y' * 65)):
        payload = '0x' + calldata('Pair(string,string)', first, second)
        add('pair-' + str(len(cases)), 'failPair(string,string)', [first, second], payload, 'revert')
    payload = '0x' + calldata('Pair(string,string)', 'same', 'same')
    add('duplicate', 'duplicate(string)', ['same'], payload, 'revert')
    for value in (0, 255):
        add('error-uint8-' + str(value), 'narrowError(uint256)', [value], '0x' + calldata('Narrow(uint8)', value), 'revert')
    add('error-overflow', 'narrowError(uint256)', [256], '0x', 'revert')
    add('legacy', 'legacy(uint256)', [42], '0x' + word(42))
    legacy = calldata('legacy(uint256)', 42)
    cases.append(('legacy-trailing-byte', legacy + '00', 'success', '0x' + word(42), 7))
    # Arbitrary bytes survive both String result and custom-error encoding.
    raw = word(32) + word(3) + '00ff80' + '00' * 29
    cases.append(('binary-result', calldata('echo(string)', '')[:8] + raw, 'success', '0x' + raw, 9))
    pair_selector = calldata('Pair(string,string)', '', '')[:8]
    binary_pair = word(64) + word(128) + word(3) + '00ff80' + '00' * 29 + word(3) + '00ff80' + '00' * 29
    cases.append(('binary-error', calldata('duplicate(string)', '')[:8] + raw, 'revert', '0x' + pair_selector + binary_pair, 7))
    for name, data in [('truncated', echo[:-2]), ('padding', echo[:-2] + '01'),
                       ('tail-extra', echo + word(0)), ('offset-zero', echo[:8] + word(0) + echo[72:]),
                       ('huge-length', echo[:72] + word((1 << 256) - 1) + echo[136:])]:
        cases.append((name, data, 'revert', '0x', 7))
    # Pair(string,string) of two L-byte strings is 4 + 64 + 2 * (32 + L) bytes with the selector.
    # L = 65440 gives 131012 bytes (accepted); L = 65472 gives 131076 bytes, which is 131072
    # without the selector, so the rejection pins that the selector counts toward the cap.
    near = '61' * 65440
    near_data = calldata('duplicate(string)', '')[:8] + word(32) + word(65440) + near
    near_payload = '0x' + pair_selector + word(64) + word(65536) + word(65440) + near + word(65440) + near
    cases.append(('duplicated-near-cap', near_data, 'revert', near_payload, 7))
    oversized = '61' * 65472
    data = calldata('duplicate(string)', '')[:8] + word(32) + word(65472) + oversized
    cases.append(('duplicated-payload-cap', data, 'revert', '0x', 7))

    def compare(name, data, status, payload, cell, program=source, code=runtime, initial=7):
        expected = dict(status=status, output=payload, storage={'0': hex(cell)} if cell else {})
        # The 65 KB cap fixtures take 5 to 15 s under load; the default 30 s cap of C.checked is too tight.
        result = C.capture('model-' + name, [C.BINARY, 'run', program, '--calldata', data, '--storage', '0=' + str(initial)], timeout=90)
        require(result.returncode == 0, 'CONTEXT-TOOL model-' + name + ': ' + result.stderr)
        modeled = json.loads(result.stdout)
        require(modeled == expected, name + ': model ' + json.dumps(modeled))
        prestate = C.prestate({'0x0': hex(initial)})
        if name.startswith('duplicated-'):
            actual, evidence = large_payload(code, data, prestate)
        else:
            actual, evidence = C.D.execute(code, data, prestate, shutil.which('evm'))
        observed = dict(status=actual['status'], output=actual['output'], storage=actual['storage'].get(C.D.RECEIVER, {}))
        require(observed == expected, name + ': Cancun ' + json.dumps(observed))
        C.save('case-' + name, dict(expected=expected, model=modeled, evm=observed, evidence=evidence))

    for row in cases:
        compare(*row)

    layout_cases = 0

    def layout(name, text, rows):
        nonlocal layout_cases
        path = WORK / (name + '.asy')
        path.write_text(text)
        emitted = WORK / name
        if emitted.is_dir():
            shutil.rmtree(emitted)
        C.checked(name + '-emit', [C.BINARY, 'emit', path, '-o', emitted])
        code = (emitted / 'runtime.hex').read_text().strip()
        for index, (data, expected, initial) in enumerate(rows):
            options = [item for key, value in initial.items() for item in ('--storage', key + '=' + str(value))]
            modeled = json.loads(C.checked(name + '-model-' + str(index), [C.BINARY, 'run', path, '--calldata', data, *options]))
            actual, evidence = C.D.execute(code, data, C.prestate({hex(int(key)): hex(value) for key, value in initial.items()}), shutil.which('evm'))
            observed = dict(status=actual['status'], output=actual['output'], storage=actual['storage'].get(C.D.RECEIVER, {}))
            require(modeled == observed == expected, name + ': layout agreement ' + json.dumps([modeled, observed]))
            C.save(name + '-case-' + str(index), dict(expected=expected, model=modeled, evm=observed, evidence=evidence))
            layout_cases += 1

    layout('packed', 'contract PackedResult where storage State := { cell : Uint8 ; neighbor : Uint8 } '
           'entry keep (value : Word) : Eff Sig Uint8 := do sstore cell value ; pure value', [
               (calldata('keep(uint256)', 255), dict(status='success', output='0x' + word(255), storage={'0': hex(255 | (3 << 8))}), {'0': 7 | (3 << 8)}),
               (calldata('keep(uint256)', 256), dict(status='revert', output='0x', storage={'0': hex(7 | (3 << 8))}), {'0': 7 | (3 << 8)}),
           ])
    key = '0x' + '00' * 19 + '01'
    slot = int(C.checked('mapping-slot', ['cast', 'index', 'address', key, '0']).strip(), 16)
    layout('mapping', 'contract MappingResult where storage State := { balances : Mapping Address Uint256 } '
           'error Refused (message : String) '
           'entry storeValue (key : Address) (amount : Uint256) : Eff Sig Uint8 := do sstore balances key amount ; value <- sload balances key ; pure value '
           'entry fail (key : Address) (message : String) : Eff Sig Word := do sstore balances key (word 99) ; revert Refused (message)', [
               (calldata('storeValue(address,uint256)', key, 255), dict(status='success', output='0x' + word(255), storage={str(slot): hex(255)}), {}),
               (calldata('storeValue(address,uint256)', key, 256), dict(status='revert', output='0x', storage={}), {}),
               (calldata('fail(address,string)', key, 'mapping error'), dict(status='revert', output='0x' + calldata('Refused(string)', 'mapping error'), storage={}), {}),
           ])

    layout('error-only', 'contract ErrorOnly where storage State := { cell : Word } '
           'error NarrowOnly (value : Uint8) '
           'entry rejectValue (value : Word) : Eff Sig Word := do sstore cell value ; revert NarrowOnly (value)', [
               (calldata('rejectValue(uint256)', 255), dict(status='revert', output='0x' + calldata('NarrowOnly(uint8)', 255), storage={'0': '0x7'}), {'0': 7}),
               (calldata('rejectValue(uint256)', 256), dict(status='revert', output='0x', storage={'0': '0x7'}), {'0': 7}),
           ])
    layout('string-error-only', 'contract StringErrorOnly where storage State := { cell : Word } '
           'error MessageOnly (message : String) '
           'entry rejectMessage (message : String) : Eff Sig Word := do revert MessageOnly (message)', [
               (calldata('rejectMessage(string)', 'isolated'), dict(status='revert', output='0x' + calldata('MessageOnly(string)', 'isolated'), storage={}), {}),
           ])

    prefix = 'contract Refusal where storage State := { cell : Word } '
    string_result = 'ABI: String results require a String parameter'
    string_error = 'ABI: String error arguments require a String parameter'
    refusals = [
        ('entry bad () : Eff Sig Bytes := do pure (word 0)',
         'ABI: unsupported function result type'),
        ('entry bad (x : Word) : Eff Sig String := do pure x', string_result),
        ('entry bad (x : String) : Eff Sig String := do size <- stringlength x ; pure size', string_result),
        ('entry bad (x : String) : Eff Sig String := do pure (word 0)', string_result),
        ('error Bad (x : String) entry bad (x : Word) : Eff Sig Word := do revert Bad (x)', string_error),
        # Pins the older String-usage rule: a raw String parameter in revert is refused before any return-ABI rule runs.
        ('error Bad (x : Uint8) entry bad (x : String) : Eff Sig Word := do revert Bad (x)',
         'ABI: String parameters require stringlength or stringdata'),
        ('error Bad (x : String) entry bad (x : String) : Eff Sig Word := do revert Bad (word 0)', string_error),
        ('error Bad (x : String) entry bad (x : String) : Eff Sig Word := do revert Bad',
         'ABI: error arguments require parentheses'),
        ('entry bad (assayResultUser : Word) : Eff Sig Uint8 := do pure assayResultUser',
         'RESERVED: assayResult and assayAbi names are reserved for ABI lowering'),
        ('entry firstEcho (x : String) : Eff Sig String := do pure x entry leakedEcho () : Eff Sig String := do pure x',
         string_result),
    ]
    for index, (body, reason) in enumerate(refusals):
        path = WORK / f'refusal-{index}.asy'
        path.write_text(prefix + body)
        for command in ('check', 'emit', 'run'):
            args = [C.BINARY, command, path]
            if command == 'emit':
                args += ['-o', WORK / f'refused-{index}']
            result = subprocess.run(list(map(str, args)), capture_output=True, text=True, timeout=90)
            require(result.returncode == 1 and reason in result.stderr and not result.stdout,
                    f'refusal {index}: {command} did not refuse for {reason}: {result.stderr}')
            (WORK / f'refusal-{index}-{command}.log').write_text(result.stdout + result.stderr)
    print(f'RETURN-ABI cases={len(cases)} layouts={layout_cases} refusals={len(refusals) * 3} cast=model=geth=t8n rollback=OK cap=OK OK')


if __name__ == '__main__':
    main()

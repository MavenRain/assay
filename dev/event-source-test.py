#!/usr/bin/env python3
"""Compare source event ABI and logs with cast, geth run and Cancun receipts."""
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/source-events'
spec = importlib.util.spec_from_file_location('event_source_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
require = C.require


def run_logs(runtime, calldata, initial, status, value=0):
    """Keep LOG witnesses while streaming the runner's full memory trace."""
    prepared = C.D.prepare(C.prestate({'0x0': hex(initial)}), runtime)
    logs = []
    with tempfile.TemporaryDirectory(prefix='assay-event-run-') as directory:
        path = Path(directory)
        genesis = path / 'prestate.json'
        genesis.write_text(json.dumps(prepared))
        argv = ['evm', 'run', '--prestate', str(genesis), '--gas', str(C.D.GAS),
                '--sender', '0x' + C.D.SENDER, '--receiver', '0x' + C.D.RECEIVER,
                '--code', runtime, '--input', calldata, '--value', str(value), '--json', '--nomemory=false']
        deadline = time.monotonic() + 90
        with (path / 'stderr').open('w') as stderr:
            with subprocess.Popen(argv, text=True, stdout=subprocess.PIPE, stderr=stderr) as process:
                try:
                    for line in process.stdout:
                        if time.monotonic() > deadline:
                            raise TimeoutError('event runner deadline')
                        if '"opName":"LOG' in line:
                            row = json.loads(line)
                            count = int(row['opName'][3:])
                            stack = row['stack']
                            start, size = int(stack[-1], 16), int(stack[-2], 16)
                            memory = row['memory'].removeprefix('0x')
                            data = memory[start * 2:(start + size) * 2]
                            require(len(data) == size * 2, 'complete LOG memory witness')
                            logs.append(dict(topics=['0x' + f'{int(stack[-3 - i], 16):064x}'
                                                     for i in range(count)], data='0x' + data))
                    require(process.wait(timeout=5) == 0, 'event runner exit')
                except BaseException:
                    process.kill()
                    process.wait()
                    raise
    return [] if status == 'revert' else logs


def receipt_logs(raw):
    results = [row['result'] for row in C.D.objects(raw['transition']) if 'result' in row]
    require(len(results) == 1 and len(results[0]['receipts']) == 1, 'one Cancun receipt')
    logs = results[0]['receipts'][0]['logs'] or []
    require(all(row['address'].removeprefix('0x') == C.D.RECEIVER for row in logs), 'log address')
    return [dict(topics=row['topics'], data=row['data']) for row in logs]


def cap_execute(runtime, calldata, initial):
    """Keep the two large event fixtures outside the shared diff input domain."""
    D = C.D
    require(len(bytes.fromhex(calldata)) in (43684, 43716) and len(runtime) <= 49152, 'event cap fixture bounds')
    D.supported(runtime)
    sender, key = D.identity('0x' + D.SENDER)
    prepared = D.prepare(initial, runtime, caller='0x' + sender)
    intrinsic = 21000 + sum(4 if byte == 0 else 16 for byte in bytes.fromhex(calldata))
    env = dict(currentCoinbase=prepared['coinbase'], currentGasLimit=hex(D.GAS + intrinsic),
               currentNumber=prepared['number'], currentTimestamp=prepared['timestamp'],
               currentRandom='0x' + '00' * 32, currentBaseFee='0x0', currentExcessBlobGas=prepared['excessBlobGas'],
               withdrawals=[], parentBeaconBlockRoot='0x' + '00' * 32)
    tx = dict(nonce=prepared['alloc'][sender]['nonce'], gasPrice='0x0', gas=hex(D.GAS + intrinsic),
              to='0x' + D.RECEIVER, value='0x0', input='0x' + calldata,
              secretKey=f'0x{key:064x}', v='0x0', r='0x0', s='0x0')
    with tempfile.TemporaryDirectory(prefix='assay-event-cap-') as directory:
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
    source = ROOT / 'examples/SourceEvents.asy'
    output = WORK / 'compiled'
    if output.exists():
        shutil.rmtree(output)
    C.checked('check', [C.BINARY, 'check', source])
    C.checked('emit', [C.BINARY, 'emit', source, '-o', output])
    runtime = (output / 'runtime.hex').read_text().strip()
    abi = json.loads((output / 'abi.json').read_text())
    schemas = dict(Transfer=[('from', 'address', True), ('to', 'address', True), ('amount', 'uint256', False)],
                   Text=[('tag', 'string', True), ('message', 'string', False)],
                   Hidden=[('first', 'uint256', True), ('second', 'address', True), ('third', 'bool', True), ('fourth', 'uint8', True)],
                   Tick=[], Data=[('amount', 'uint8', False), ('enabled', 'bool', False), ('owner', 'address', False)])
    main_events = list(schemas)

    def event_rows(names, anonymous=()):
        return [dict(type='event', name=name, anonymous=name in anonymous,
                     inputs=[dict(name=field, type=typ, indexed=indexed) for field, typ, indexed in schemas[name]])
                for name in names]

    def mutability(rows):
        return {row['name']: row['stateMutability'] for row in rows if row['type'] == 'function'}

    mutabilities = dict(transfer='nonpayable', text='nonpayable', hidden='nonpayable', tick='nonpayable',
                        data='nonpayable', twice='nonpayable', fail='nonpayable', narrowReturn='nonpayable', get='view')
    require([row for row in abi if row['type'] == 'event'] == event_rows(main_events, ('Hidden',)), 'independent event ABI')
    require([row['name'] for row in abi if row['type'] == 'error'] == ['Denied'], 'internal errors stay private')
    require(mutability(abi) == mutabilities, 'log effects and read-only mutability')
    serial = 0

    def cast(*args):
        nonlocal serial
        serial += 1
        return C.checked('cast-' + str(serial), ['cast', *map(str, args)]).strip()

    def word(value):
        return '0x' + f'{value:064x}'

    def encoded(types, *args):
        return cast('abi-encode', 'f(' + types + ')', *args)

    def event(name, values):
        fields = schemas[name]
        topics = [] if name == 'Hidden' else [cast('keccak', name + '(' + ','.join(typ for _, typ, _ in fields) + ')')]
        data_types, data_values = [], []
        for (_, typ, indexed), value in zip(fields, values, strict=True):
            if indexed:
                topics.append(cast('keccak', '0x' + value.encode().hex()) if typ == 'string' else
                              encoded(typ, value))
            else:
                data_types.append(typ)
                data_values.append(value)
        return dict(topics=topics, data=encoded(','.join(data_types), *data_values) if data_types else '0x')

    cases = []

    def compare(name, signature, args, output, logs, status='success', stored=775,
                program=source, code=runtime, initial=775, calldata=None, storage=None, value=0):
        data = calldata if calldata is not None else cast('calldata', signature, *args)[2:]
        expected = dict(status=status, output=output,
                        storage=storage if storage is not None else ({'0': hex(stored)} if stored else {}), logs=logs)
        result = C.capture('model-' + name, [C.BINARY, 'run', program, '--calldata', data,
                                           '--storage', '0=' + str(initial), '--value', str(value)], timeout=90)
        require(result.returncode == 0, name + ': model tool ' + result.stderr)
        modeled = json.loads(result.stdout)
        require(modeled == expected, name + ': model differs from the independent expected outcome')
        prestate = C.prestate({'0x0': hex(initial)})
        if name.startswith('event-cap-'):
            actual, raw = cap_execute(code, data, prestate)
        else:
            actual, raw = C.D.execute(code, data, prestate, shutil.which('evm'), value=value)
        observed = dict(status=actual['status'], output=actual['output'],
                        storage=actual['storage'].get(C.D.RECEIVER, {}), logs=receipt_logs(raw))
        require(observed == expected, name + ': Cancun receipt differs from the independent expected outcome')
        traced = run_logs(code, data, initial, actual['status'], value)
        require(traced == logs, name + ': geth LOG trace differs from the independent expected logs')
        cases.append(dict(name=name, calldata=data, initial=initial, value=value, expected=expected, model=modeled,
                          geth_logs=traced, cancun=observed,
                          runtime_sha256=hashlib.sha256(bytes.fromhex(code)).hexdigest(),
                          evidence_sha256=hashlib.sha256(json.dumps(raw, sort_keys=True).encode()).hexdigest()))

    a, b = '0x' + '00' * 19 + '01', '0x' + 'ff' * 20
    for value in (0, 1, (1 << 256) - 1):
        compare('transfer-' + str(value), 'transfer(address,address,uint256)', [a, b, value],
                word(value), [event('Transfer', [a, b, value])])
    for tag, message in (('', ''), ('tag', 'x'), ('x' * 31, 'y' * 33), ('x' * 32, 'y' * 32),
                         ('x' * 33, 'y' * 65), ('café', 'hello 世界')):
        compare('text-' + str(len(cases)), 'text(string,string)', [tag, message],
                encoded('string', message), [event('Text', [tag, message])])
    compare('anonymous-four', 'hidden(uint256,address,bool,uint8)', [(1 << 256) - 1, b, 'true', 255],
            word((1 << 256) - 1), [event('Hidden', [(1 << 256) - 1, b, 'true', 255])])
    compare('tick', 'tick()', [], word(0), [event('Tick', [])])
    compare('data', 'data(uint256,uint256,uint256)', [255, 1, (1 << 160) - 1], word(255),
            [event('Data', [255, 'true', b])])
    for args in ([256, 1, 1], [1, 2, 1], [1, 1, 1 << 160]):
        compare('scalar-overflow-' + str(len(cases)), 'data(uint256,uint256,uint256)', args, '0x', [], 'revert')
    compare('ordered-packed', 'twice(uint8)', [255], word(255),
            [event('Tick', []), event('Data', [255, 'true', '0x' + '00' * 19 + '02'])], stored=1023)
    compare('revert-discards-logs', 'fail(uint8)', [255], cast('keccak', 'Denied()')[:10], [], 'revert')
    compare('result-overflow-discards-logs', 'narrowReturn(uint256)', [256], '0x', [], 'revert')
    malformed = cast('calldata', 'text(string,string)', 'a', 'b')[2:]
    compare('bad-dynamic-padding', '', [], '0x', [], 'revert', calldata=malformed[:-2] + '01')
    compare('short-selector', '', [], '0x', [], 'revert', calldata='ff')
    compare('unknown-selector', '', [], '0x', [], 'revert', calldata='ffffffff')

    def variant(name, body, events, anonymous=(), functions=None):
        """Emit one variant and hold its abi.json to the same independent schema as the main contract."""
        path = WORK / (name + '.asy')
        path.write_text(body)
        directory = WORK / (name + '-compiled')
        if directory.exists():
            shutil.rmtree(directory)
        C.checked('emit-' + name, [C.BINARY, 'emit', path, '-o', directory])
        rows = json.loads((directory / 'abi.json').read_text())
        require([row for row in rows if row['type'] == 'event'] == event_rows(events, anonymous),
                name + ': variant event ABI differs from the independent schema')
        require(functions is None or mutability(rows) == functions, name + ': variant mutability')
        return dict(program=path, code=(directory / 'runtime.hex').read_text().strip())

    schemas['Silent'] = []
    silent = variant('anonymous-zero', '''contract Silent where
  storage State := { cell : Word }
  event Silent () anonymous
  entry silent () : Eff Sig Word := do emit Silent () ; pure (word 0)
''', ['Silent'], ('Silent',))
    compare('anonymous-zero', 'silent()', [], word(0), [dict(topics=[], data='0x')], **silent)
    schemas['Caps'] = [('a', 'uint8', True), ('b', 'bool', True), ('c', 'address', True), ('amount', 'uint256', False)]
    caps = variant('indexed-bounds', '''contract Caps where
  storage State := { cell : Word }
  event Caps (a : Uint8 indexed) (b : Bool indexed) (c : Address indexed) (amount : Word)
  entry caps (a : Word) (b : Word) (c : Word) : Eff Sig Word :=
    do sstore cell (word 9) ; emit Caps (a) (b) (c) (word 7) ; pure (word 7)
''', ['Caps'])
    compare('named-three-indexed', 'caps(uint256,uint256,uint256)', [255, 1, (1 << 160) - 1], word(7),
            [event('Caps', [255, 'true', b, 7])], stored=9, **caps)
    for args in ([256, 1, 1], [1, 2, 1], [1, 1, 1 << 160]):
        compare('indexed-overflow-' + str(len(cases)), 'caps(uint256,uint256,uint256)', args, '0x', [], 'revert', **caps)
    schemas['Changed'] = [('owner', 'address', True), ('amount', 'uint8', False)]
    mapping = variant('mapping-events', '''contract MappingEvents where
  storage State := { balances : Mapping Address Uint8 }
  event Changed (owner : Address indexed) (amount : Uint8)
  error Denied ()
  entry set (owner : Address) (value : Uint8) : Eff Sig Word :=
    do sstore balances owner value ; loaded <- sload balances owner ; emit Changed (owner) (loaded) ; pure loaded
  entry fail (owner : Address) (value : Uint8) : Eff Sig Word :=
    do sstore balances owner value ; emit Changed (owner) (value) ; revert Denied ()
''', ['Changed'])
    key = str(int(cast('keccak', encoded('address,uint256', a, 0)), 16))
    compare('mapping-read-write-log', 'set(address,uint8)', [a, 255], word(255), [event('Changed', [a, 255])],
            initial=0, storage={key: '0xff'}, **mapping)
    compare('mapping-rollback', 'fail(address,uint8)', [a, 255], cast('keccak', 'Denied()')[:10], [], 'revert',
            initial=0, stored=0, **mapping)
    payable = variant('payable-events', source.read_text().replace('entry transfer ', 'payable entry transfer '),
                      main_events, ('Hidden',), dict(mutabilities, transfer='payable'))
    compare('payable-log', 'transfer(address,address,uint256)', [a, b, 7], word(7),
            [event('Transfer', [a, b, 7])], value=7, **payable)
    schemas['Huge'] = [('first', 'string', False), ('second', 'string', False), ('third', 'string', False), ('marker', 'uint256', False)]
    huge = variant('event-cap', '''contract EventCap where
  storage State := { cell : Word }
  event Huge (first : String) (second : String) (third : String) (marker : Word)
  entry duplicate (message : String) : Eff Sig Word :=
    do sstore cell (word 9) ; emit Huge (message) (message) (message) (word 42) ; pure (word 0)
''', ['Huge'])
    message = 'x' * 43600
    compare('event-cap-below', 'duplicate(string)', [message], word(0), [event('Huge', [message] * 3 + [42])], stored=9, **huge)
    compare('event-cap-overflow', 'duplicate(string)', ['x' * 43617], '0x', [], 'revert', **huge)

    proven = variant('event-proof', '''contract EventProof where
  storage State := { cell : Word }
  event Tick ()
  invariant bounded (s : State) : Prop := Le s.cell (word 0)
  entry go () : Eff Sig Word := do
    emit Tick () ; sstore cell (word 0) ; pure (word 0)
''', ['Tick'])
    compare('event-proof-preserved', 'go()', [], word(0), [event('Tick', [])], stored=0, initial=0, **proven)

    schemas['Said'] = [('text', 'string', False)]
    padding = variant('string-padding', '''contract StringPadding where
  storage State := { cell : Word }
  event Said (text : String)
  entry say (a : String) (b : String) : Eff Sig String := do emit Said (a) ; pure b
  entry twice (a : String) (b : String) : Eff Sig String := do emit Said (a) ; emit Said (b) ; pure b
''', ['Said'])
    longer, shorter = 'x' * 40, 'y' * 33
    compare('string-padding-return', 'say(string,string)', [longer, shorter], encoded('string', shorter),
            [event('Said', [longer])], **padding)
    compare('string-padding-logs', 'twice(string,string)', [longer, shorter], encoded('string', shorter),
            [event('Said', [longer]), event('Said', [shorter])], **padding)

    text = source.read_text()
    mutants = {
        'unknown-event': text.replace('emit Tick ()', 'emit Missing ()'),
        'duplicate-event': text.replace('event Tick ()', 'event Tick ()\n  event Tick ()'),
        'indexed-overflow': text.replace('event Tick ()', 'event Tick (a : Word indexed) (b : Word indexed) (c : Word indexed) (d : Word indexed)')
        .replace('emit Tick ()', 'emit Tick (word 1) (word 1) (word 1) (word 1)'),
        'anonymous-overflow': text.replace('(fourth : Uint8 indexed) anonymous', '(fourth : Uint8 indexed) (fifth : Word indexed) anonymous')
        .replace('emit Hidden (a) (b) (c) (d)', 'emit Hidden (a) (b) (c) (d) (a)'),
        'duplicate-parameter': text.replace('(to : Address indexed)', '(from : Address indexed)'),
        'unsupported-type': text.replace('(amount : Uint256)', '(amount : Bytes32)'),
        'missing-argument': text.replace('emit Transfer (from) (to) (amount)', 'emit Transfer (from) (to)'),
        'extra-argument': text.replace('emit Tick ()', 'emit Tick (word 1)'),
        'missing-semicolon': text.replace('emit Tick () ;', 'emit Tick ()'),
        'string-expression': text.replace('emit Text (tag) (message)', 'emit Text (word 1) (message)'),
        'reserved-event': text.replace('entry get ()', 'entry assayEventUser ()'),
        'reserved-result': text.replace('entry get ()', 'entry assayResultUser ()'),
        'reserved-calldata': text.replace('entry get ()', 'entry assayAbiUser ()'),
        'bare-event': text.replace('event Tick ()', 'event Bare\n  event Tick ()'),
        'constructor-emission': text.replace('constructor := do', 'constructor := do emit Tick () ;'),
        'event-proof-leak': '''contract EventProofLeak where
  storage State := { cell : Word }
  event Tick ()
  invariant bounded (s : State) : Prop := Le s.cell (word 0)
  entry go () : Eff Sig Word := do
    emit Tick () ; sstore cell (word 1) ; pure (word 1)
''',
    }
    def position(name, needle, skip=0):
        body = mutants[name]
        index = body.index(needle) + skip
        return f'line {body.count(chr(10), 0, index) + 1}, column {index - body.rfind(chr(10), 0, index)}'

    reserved = 'SURFACE_RESERVED: assayEvent, assayResult and assayAbi names are reserved for lowering'
    arity = 'SURFACE_EVENT: wrong event argument count'
    limit = 'SURFACE_EVENT: too many indexed fields or duplicate parameter names'
    expected = {
        'unknown-event': 'SURFACE_EVENT: unknown event',
        'duplicate-event': 'SURFACE_EVENT: duplicate event name',
        'indexed-overflow': limit,
        'anonymous-overflow': limit,
        'duplicate-parameter': limit,
        'unsupported-type': 'SURFACE_EVENT: unsupported event parameter type',
        'missing-semicolon': 'SURFACE_EVENT: event emission requires a semicolon',
        'constructor-emission': 'SURFACE_EVENT: constructor event emission is not supported',
        'event-proof-leak': 'mismatch',
        'missing-argument': position('missing-argument', 'emit Transfer (from) (to)') + ': ' + arity,
        'extra-argument': position('extra-argument', 'emit Tick (word 1)') + ': ' + arity,
        'string-expression': position('string-expression', 'emit Text (word 1)')
        + ': SURFACE_EVENT: String event arguments require a String parameter',
        'reserved-event': position('reserved-event', 'assayEventUser') + ': ' + reserved,
        'reserved-result': position('reserved-result', 'assayResultUser') + ': ' + reserved,
        'reserved-calldata': position('reserved-calldata', 'assayAbiUser') + ': ' + reserved,
        'bare-event': position('bare-event', 'event Bare', len('event '))
        + ': SURFACE_EVENT: expected (name : ABI type indexed?) or ()',
    }
    require(set(expected) == set(mutants), 'every source mutant names its diagnostic')
    refusals = []
    for name, body in mutants.items():
        path = WORK / (name + '.asy')
        path.write_text(body)
        results = [C.capture('refusal-' + command + '-' + name, [C.BINARY, command, path, *extra])
                   for command, extra in (('check', []), ('emit', ['-o', WORK / ('refused-' + name)]))]
        for result in results:
            require(result.returncode == 1 and expected[name] in result.stderr and not result.stdout,
                    name + ': source mutant survived or unexpected diagnostic ' + result.stderr.strip())
        refusals.append(dict(name=name, exit=results[0].returncode, diagnostic=results[0].stderr))
    (WORK / 'cases.json').write_text(json.dumps(dict(cases=cases, refusals=refusals, abi=abi), indent=2) + '\n')
    print(f'SOURCE-EVENTS cases={len(cases)} refusals={len(refusals)} cast=model=geth=t8n logs=OK rollback=OK OK')


if __name__ == '__main__':
    main()

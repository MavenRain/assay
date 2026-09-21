#!/usr/bin/env python3
"""Check numeric spelling against decimal artifacts and independent EVM outcomes."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/hex-literals'
spec = importlib.util.spec_from_file_location('hex_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
C.WORK = WORK
require = C.require
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')
MAX = 2**256 - 1


def single(body, extra='', init='sstore cell (word 0x0A) ;', args='()'):
    return f'''contract HexLiteral where
  storage State := {{ cell : Word }}
  {extra}
  entry test {args} : Eff Sig Word := do {body}
  constructor := do {init} pure ()
'''


def values():
    return [('0x10', 16), *[(f'0x{n:x}', n) for n in range(16)],
            ('0XAbCdEf', 11259375), ('0x' + '0' * 63 + '1', 1),
            ('0x20000000000001', 9007199254740993),
            ('0x' + 'f' * 40, 2**160 - 1),
            ('0x8' + '0' * 63, 2**255), ('0x' + 'F' * 64, MAX)]


def proof_source():
    return single('guard (leWord (word 0X0A) a) ; '
                  'let result : Word := subLe a (word 00010) ; pure result', args='(a : Word)')


def fixtures():
    rows = [(f'value-{i:02}', single(f'sstore cell (word {text}) ; pure (word {text})',
                                   init=f'sstore cell (word {text}) ;'))
            for i, (text, _number) in enumerate(values())]
    rows.extend([
        ('proof-inference', proof_source()),
        ('helper', single('let (0 p : Le (word 0X0A) (word 0xff)) := identity((word 10), (word 255), ()) ; '
                          'let result : Word := subLe (word 0xFF) (word 00010) p ; pure result',
                          'proof identity (0 a : Word) (0 b : Word) (0 p : Le a b) : Le a b := p')),
        ('equality', single('(0 same : EqWord a (word 16)) <- guard (eqWord a (word 0x10)) ; '
                            'let result : Word := subLe a (word 00016) second(same) ; pure result', args='(a : Word)')),
        ('addition', single('guard (lt256 (add a (word 0x10))) ; '
                            'let result : Word := addLt a (word 00016) ; pure result', args='(a : Word)')),
        ('predicate', single('guard (bounded(a)) ; pure a',
                             'predicate bounded (0 a : Word) : Prop := Le a (word 0xFF)', args='(a : Word)')),
        ('caller', single('sender <- caller ; guard (eqWord sender (word 0x1234567890abcdef1234567890abcdef12345678)) ; '
                          'pure sender')),
        ('example', (ROOT / 'examples/HexWords.asy').read_text()),
    ])
    return rows


def decimal(source):
    return re.sub(r'\bword\s+(0[xX][0-9a-fA-F]+|[0-9]+)\b',
                  lambda m: 'word ' + str(int(m[1], 16 if m[1].lower().startswith('0x') else 10)), source)


def emit(name, source):
    path = WORK / (name + '.asy')
    path.write_text(source)
    output = WORK / name
    result = C.capture('emit-' + name, [C.BINARY, 'emit', path, '-o', output])
    require(result.returncode == 0, 'HEX-EMIT ' + name + ': ' + result.stderr)
    return path, output, (output / 'runtime.hex').read_text().strip()


def pairs():
    records = []
    for name, source in fixtures():
        _, output, _ = emit(name, source)
        _, reference, _ = emit('decimal-' + name, decimal(source))
        for file in FILES:
            require((output / file).read_bytes() == (reference / file).read_bytes(), 'HEX-PAIR ' + name + ' ' + file)
        records.append(dict(name=name, files=list(FILES)))
    C.save('PAIRS', records)
    return len(records)


def selector(signature):
    return C.checked('selector-' + signature.split('(')[0], ['cast', 'sig', signature]).strip()[2:]


def outcome(name, path, runtime, data, want, *, caller=C.SENDER, signed=False, value=0):
    before = {'0': '0x7'}
    model = json.loads(C.checked('model-' + name, [C.BINARY, 'run', path, '--calldata', data,
                                                 '--caller', hex(caller), '--storage', '0=7', '--value', value]))
    evm, _ = C.evm_run(name, runtime, data, caller, slots=before, value=value)
    require(model == want, 'HEX-MODEL ' + name)
    require(evm == want, 'HEX-EVM ' + name)
    if signed:
        require(caller == C.SENDER, 'HEX-SIGNED caller ' + name)
        report, evidence = C.D.execute(runtime, data, C.prestate(before), shutil.which('evm'), value=value)
        C.save('signed-' + name, dict(report=report, evidence=evidence))
        actual = dict(status=report['status'], output=report['output'], storage=report['storage'].get(C.D.RECEIVER, {}))
        require(actual == want, 'HEX-SIGNED ' + name)
    return dict(name=name, expected=want, signed=signed)


def live():
    records, creates = [], []
    sig = selector('test()')
    sources = dict(fixtures())
    for i, (_text, number) in enumerate(values()):
        name = f'value-{i:02}'
        path, output, runtime = emit('live-' + name, sources[name])
        want = dict(status='success', output=f'0x{number:064x}', storage={'0': hex(number)} if number else {})
        records.append(outcome(name, path, runtime, sig, want, signed=number in (0, 16, MAX, 2**160 - 1, 2**255)))
        init = (output / 'init.hex').read_text().strip()
        result, raw = C.evm_run('create-' + name, init, '', C.SENDER, create=True)
        require(result == dict(status='success', output='0x' + runtime, storage={}), 'HEX-CREATE ' + name)
        want_storage = {'0': hex(number)} if number else {}
        capture = json.loads((WORK / ('evm-create-' + name + '.json')).read_text())
        accounts = C.D.objects(capture['stdout'])[-1]['accounts']
        installed = [account for account in accounts.values() if account.get('code')]
        require(list(raw['storage'].values()) == ([want_storage] if number else []) and
                len(installed) == 1 and C.D.byte_hex(installed[0]['code']) == runtime,
                'HEX-CREATE-STORAGE ' + name)
        creates.append(dict(name=name, storage=want_storage, runtime_sha256=hashlib.sha256(bytes.fromhex(runtime)).hexdigest()))
    tests = [('proof-inference', [(10, 0), (19, 9), (9, None)]),
             ('equality', [(16, 0), (15, None), (17, None)]),
             ('addition', [(0, 16), (MAX - 16, MAX), (MAX - 15, None)]),
             ('predicate', [(255, 255), (256, None)])]
    sig = selector('test(uint256)')
    for name, cases in tests:
        path, _, runtime = emit('live-' + name, sources[name])
        for argument, result in cases:
            want = dict(status='revert' if result is None else 'success',
                        output='0x' if result is None else f'0x{result:064x}', storage={'0': '0x7'})
            records.append(outcome(f'{name}-{argument}', path, runtime, sig + f'{argument:064x}', want, signed=True))
    path, _, runtime = emit('live-helper', sources['helper'])
    records.append(outcome('helper', path, runtime, selector('test()'),
                           dict(status='success', output=f'0x{245:064x}', storage={'0': '0x7'})))
    path, _, runtime = emit('live-caller', sources['caller'])
    address = 0x1234567890abcdef1234567890abcdef12345678
    for caller in (address, address + 1):
        want = dict(status='success' if caller == address else 'revert',
                    output=f'0x{address:064x}' if caller == address else '0x', storage={'0': '0x7'})
        records.append(outcome('caller-' + str(caller), path, runtime, selector('test()'), want, caller=caller))
    path, output, runtime = emit('live-example', sources['example'])
    sig, failure = selector('set(uint256)'), selector('TooLarge(uint256,uint256)')
    for n in (0, 255, 256, MAX):
        good = n <= 255
        want = dict(status='success' if good else 'revert',
                    output=f'0x{n:064x}' if good else '0x' + failure + f'{n:064x}{255:064x}',
                    storage=({'0': hex(n)} if n else {}) if good else {'0': '0x7'})
        records.append(outcome('example-' + str(n), path, runtime, sig + f'{n:064x}', want, signed=True))
    for method, number in [('address()', address), ('mask()', MAX)]:
        records.append(outcome(method, path, runtime, selector(method),
                               dict(status='success', output=f'0x{number:064x}', storage={'0': '0x7'}), signed=True))
    for name, data, value in [('short', sig + '00' * 31, 0), ('unknown', 'ffffffff', 0), ('value', sig + '00' * 32, 1)]:
        records.append(outcome(name, path, runtime, data, dict(status='revert', output='0x', storage={'0': '0x7'}),
                               value=value, signed=True))
    C.save('LIVE', records)
    C.save('CREATES', creates)
    return len(records), sum(row['signed'] for row in records), len(creates)


def refusals():
    literals = [('empty-lower', '0x'), ('empty-upper', '0X'), ('bad-hex', '0xG'), ('hex-suffix', '0x12z'),
                ('decimal-letters', '123abc'), ('decimal-exponent', '1e1'), ('binary', '0b1'), ('octal', '0o7'),
                ('suffix', '0x1u'), ('separator', '0x1_0'), ('double-prefix', '0x0x1'),
                ('decimal-overflow', str(MAX + 1)), ('hex-overflow', '0x1' + '0' * 64),
                ('hex-width', '0x' + '0' * 65), ('decimal-width', '0' * 79), ('split-prefix', '0x 1')]
    rows = [(name, single(f'pure (word {text})'), 'SURFACE_WORD') for name, text in literals]
    rows += [('negative', single('pure (word -0x1)'), 'SURFACE_TOKEN'),
             ('positive-sign', single('pure (word +0x1)'), 'SURFACE_TOKEN'),
             ('constructor', single('pure (word 0)', init='sstore cell (word 0xZ) ;'), 'SURFACE_WORD'),
             ('invariant', single('pure (word 0)', 'invariant bad (s : State) : Prop := Le s.cell (word 0xZ)'), 'SURFACE_WORD'),
             ('helper', single('pure (word 0)', 'proof bad : Le (word 0xZ) (word 1) := ()'), 'SURFACE_WORD'),
             ('guard', single('guard (eqWord (word 0) (word 0xZ)) ; pure (word 0)'), 'SURFACE_WORD'),
             ('error', single('revert Bad (word 0xZ)', 'error Bad (value : Word)'), 'SURFACE_WORD')]
    records = []
    for name, source, marker in rows:
        path = WORK / (name + '.asy')
        path.write_text(source)
        output = WORK / (name + '-out')
        for command in (['check', path], ['emit', path, '-o', output], ['run', path, '--calldata', '0x']):
            result = C.capture(name + '-' + command[0], [C.BINARY, *command])
            require(result.returncode == 1 and marker in result.stdout + result.stderr and not output.exists(),
                    'HEX-REFUSAL ' + name + ' ' + command[0] + ': ' + result.stderr)
        records.append(dict(name=name, marker=marker))
    C.save('REFUSALS', records)
    return len(rows)


def mutants():
    cases = [
        ('RADIX', 'emit/recognize.ml', 'Z.of_string_base (if hex then 16 else 10)', 'Z.of_string_base 10',
         'pairs', 'HEX-PAIR value-00 runtime.hex'),
        ('EMPTY', 'emit/recognize.ml',
         'let digits = if hex then String.of_seq (Seq.drop 2 (String.to_seq text)) else text in',
         'let digits = if hex then String.of_seq (Seq.drop 2 (String.to_seq text)) else text in\n'
         '  let digits = if digits = "" then "0" else digits in', 'refusals', 'HEX-REFUSAL empty-lower check'),
        ('RANGE', 'emit/recognize.ml', 'if Z.numbits value > 256', 'if Z.gt value (Z.shift_left Z.one 256)',
         'refusals', 'HEX-REFUSAL decimal-overflow check'),
        ('NORMALIZE', 'emit/contract.ml', 'text = Z.to_string n',
         'text = (if String.starts_with ~prefix:"0x" (String.lowercase_ascii at.text) then Z.to_string n else at.text)',
         'pairs', 'HEX-EMIT proof-inference'),
    ]
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-hex-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.*', '_build', '.gatework',
            '.lake', 'vendor', 'validation', '__pycache__'))
        for name, file, before, after, witness, marker in cases:
            path = copy / file
            original = path.read_text()
            require(original.count(before) == 1, 'HEX-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/dune.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'HEX-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/hex-literals-test.py', witness], cwd=copy, timeout=180)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'HEX-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('HEX-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(cases)


def main():
    commands = dict(pairs=pairs, live=live, refusals=refusals, mutants=mutants)
    if sys.argv[1:] and sys.argv[1:] not in [[name] for name in commands]:
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True, exist_ok=True)
    if sys.argv[1:]:
        result = commands[sys.argv[1]]()
        print(f'HEX-LITERALS {sys.argv[1]} {result} OK', flush=True)
    else:
        paired = pairs()
        cases, signed, creates = live()
        invalid, killed = refusals(), mutants()
        print(f'HEX-LITERALS pairs={paired} cases={cases} signed={signed} creates={creates} '
              f'refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (AssertionError, OSError, ValueError, KeyError, RuntimeError, subprocess.TimeoutExpired) as error:
        print('HEX-LITERALS FAIL: ' + str(error), flush=True)
        sys.exit(1)

#!/usr/bin/env python3
"""Public trace call values, executor operands, model agreement and refusals."""
import importlib.util
import itertools
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/trace-value'
SPEC = importlib.util.spec_from_file_location('differential', ROOT / 'evm/diff.py')
DIFF = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DIFF)
MAX = 2**256 - 1
BUDGET_S = 180
WARN_S = BUDGET_S * 0.75
SENDER = '000000000000000000000000000073656e646572'
RECEIVER = DIFF.RECEIVER
SLOTS = {'0': '0xb', '7': '0x13'}
GET = '6d4ce63c'
SET = '60fe47b1'
FALLBACK = '0x59170bf0'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    binary = str(ROOT / '_build/bin/assay')
    evm = shutil.which('evm')
    require(evm is not None, 'TRACE-VALUE missing evm')
    receipts, live, faults, refused = [], [], [], []
    start = time.monotonic()

    def budget_note(name):
        spent = time.monotonic() - start
        if spent > WARN_S:
            print(f'TRACE-VALUE budget warning: {name} at {spent:.1f}s of '
                  f'{BUDGET_S:.0f}s leg deadline', file=sys.stderr)

    with tempfile.TemporaryDirectory(prefix='assay-trace-value-') as directory:
        work = Path(directory)
        source = work / 'contract with spaces; literal.asy'
        source.write_text((ROOT / 'examples/Fallback.asy').read_text())
        prestate = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
        prestate['alloc'] = {
            SENDER: dict(balance=hex(MAX)),
            RECEIVER: dict(balance='0x0', storage={f'0x{slot:064x}': f'0x{word:064x}'
                                                 for slot, word in ((0, 11), (7, 19))}),
        }
        genesis = work / 'state with spaces; literal.json'
        genesis.write_text(json.dumps(prestate))
        commands = work / 'bin'
        commands.mkdir()
        argvlog = work / 'argv.jsonl'
        wrapper = commands / 'evm'
        wrapper.write_text(
            '#!' + sys.executable + ' -P\nimport json,os,sys\n'
            'with open(os.environ["ASSAY_TRACE_ARGV"], "a") as stream: '
            'stream.write(json.dumps(sys.argv[1:])+"\\n")\n'
            'os.execv(' + repr(evm) + ', [' + repr(evm) + ', *sys.argv[1:]])\n')
        wrapper.chmod(0o755)
        env = dict(os.environ, PATH=str(commands), ASSAY_TRACE_ARGV=str(argvlog))

        def invoke(name, args, code=0, marker='', environment=env):
            result = subprocess.run([binary, *args], cwd=work, env=environment,
                                    capture_output=True, text=True, timeout=30)
            budget_note(name)
            receipts.append(dict(name=name, args=args, exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))
            (WORK / 'CASES.json').write_text(json.dumps(receipts, indent=2) + '\n')
            require(result.returncode == code and marker in result.stderr,
                    f'TRACE-VALUE {name}: {result.returncode}: {result.stdout}{result.stderr}')
            if code == 0:
                require(not result.stderr, 'TRACE-VALUE stderr: ' + name)
            return result

        def case(name, data, value, status, output, slots=SLOTS, path=source, flags=None):
            options = ['--calldata', data, '--prestate', str(genesis)]
            if value is not None:
                options += ['--value', value]
            result = invoke(name, ['trace', str(path), *(options if flags is None else flags)],
                            2 if status == 'revert' else 0,
                            'TRACE_EXECUTION:' if status == 'revert' else '')
            report = DIFF.run_outcome(result.stdout)
            expected = dict(status=status, output=output, storage=slots)
            actual = dict(status=report['status'], output='0x' + report['output'],
                          storage=report['storage'].get(RECEIVER, {}))
            require(actual == expected, 'TRACE-VALUE outcome: ' + name)
            word = value if value is not None else '0'
            amount = int(word, 16 if word.lower().startswith('0x') else 10)
            args = json.loads(argvlog.read_text().splitlines()[-1])
            canonical = word.lower() if word.lower().startswith('0x') else str(amount)
            require(args.count('--value') == 1 and args[args.index('--value') + 1] == canonical,
                    'TRACE-VALUE executor value: ' + name)
            require(args[args.index('--prestate') + 1] == str(genesis) and
                    args[args.index('--input') + 1] == data.lower().removeprefix('0x'),
                    'TRACE-VALUE literal arguments: ' + name)
            records = DIFF.objects(result.stdout)
            if path == source:
                # Fallback.asy is entry-guarded, so the emitter injects a
                # CALLVALUE check; Ref20.asy (the closed-effect-* cases
                # below) has no selector dispatch and no such check, so
                # this operand assertion does not apply there.
                reads = [right for left, right in zip(records, records[1:]) if left.get('op') == 52]
                require(len(reads) == 1 and int(reads[0]['stack'][-1], 16) == amount,
                        'TRACE-VALUE CALLVALUE operand: ' + name)
            model = subprocess.run(
                [binary, 'run', str(path), '--calldata', data, '--value', word,
                 '--storage', '0=11', '--storage', '7=19', '--caller', '0x' + SENDER],
                cwd=work, env=env, capture_output=True, text=True, timeout=30)
            budget_note(name + ' model')
            require(model.returncode == 0 and not model.stderr and json.loads(model.stdout) == expected,
                    'TRACE-VALUE source model: ' + name)
            live.append(dict(name=name, value=word, expected=expected, report=report, argv=args))
            return report

        zero = case('default-zero', GET, None, 'success', '0x' + f'{11:064x}')
        for value in ('0', '0x0', '0X00', '0000', '0' * 78, '0x' + '0' * 64):
            report = case('explicit-zero-' + value, GET, value, 'success', '0x' + f'{11:064x}')
            require(report == zero, 'TRACE-VALUE default changed')
        case('write-zero', SET + f'{23:064x}', '0', 'success', '0x' + f'{23:064x}',
             {'0': '0x17', '7': '0x13'})
        case('write-nonpayable', SET + f'{23:064x}', '1', 'revert', '0x')
        for name, data, output in [('empty', '', FALLBACK), ('short', '010203', FALLBACK),
                                   ('unknown', 'ffffffff', FALLBACK), ('truncated', SET, '0x')]:
            case(name + '-zero', data, '0', 'revert', output)
            case(name + '-nonpayable', data, '1', 'revert', '0x')
        case('trailing-zero', GET + 'ff', '0', 'success', '0x' + f'{11:064x}')
        case('trailing-nonpayable', GET + 'ff', '1', 'revert', '0x')
        for value in ('1', '0x01', '0X0A', '0007', '0009', '0010',
                      str(MAX), hex(MAX), hex(MAX).upper()):
            case('word-' + value, GET, value, 'revert', '0x')
        for value in ('0010', str(MAX)):
            case('closed-effect-' + value, '', value, 'success', '0x' + f'{42:064x}',
                 {'0': '0x2a', '7': '0x13'}, ROOT / 'examples/Ref20.asy')
        pairs = [('--calldata', GET), ('--value', '0X0A'), ('--prestate', str(genesis))]
        for index, order in enumerate(itertools.permutations(pairs)):
            flags = [item for pair in order for item in pair]
            case('option-order-' + str(index), GET, '0X0A', 'revert', '0x', flags=flags)
        require(len(argvlog.read_text().splitlines()) == len(live), 'TRACE-VALUE executor count')

        poor = json.loads(genesis.read_text())
        poor['alloc'][SENDER]['balance'] = '0xa'
        poor_path = work / 'insufficient.json'
        poor_path.write_text(json.dumps(poor))
        for name, value, flags, slots in [
                ('unfunded-default', '1', [], {}),
                ('insufficient-balance', '11', ['--prestate', str(poor_path)], SLOTS)]:
            result = invoke(name, ['trace', str(source), '--calldata', GET, '--value', value, *flags],
                            2, 'TRACE_EXECUTION:')
            records = DIFF.objects(result.stdout)
            require(len(records) == 2 and records[0].get('error') == 'insufficient balance for transfer'
                    and 'pc' not in records[0] and
                    DIFF.storage(records[1]['accounts']).get(RECEIVER, {}) == slots,
                    'TRACE-VALUE funding fault: ' + name)
            faults.append(name)

        missing = str(work / 'missing.asy')
        base = ['trace', missing, '--calldata', '']
        no_tools = dict(env, PATH='')

        def refuse(name, args, marker):
            result = invoke(name, args, 64, marker, no_tools)
            require(not result.stdout, 'TRACE-VALUE refusal printed trace: ' + name)
            refused.append(name)

        invalid = ['', '0x', '0X', '+1', '1_0', '0b1', '0o7', ' 1', '1 ', '1\n', '1.0',
                   '0xg', str(MAX + 1), '0x' + 'f' * 65, '0' * 79, '0x' + '0' * 65,
                   '; touch SENTINEL', '$(touch SENTINEL)']
        for index, value in enumerate(invalid):
            marker = 'TRACE_VALUE: word exceeds uint256' if value == str(MAX + 1) else 'TRACE_VALUE:'
            refuse('invalid-word-' + str(index), [*base, '--value', value], marker)
        bad_options = [['--calldata', ''], ['--prestate', 'a', '--prestate', 'b'],
                       ['--value', '1', '--value', '2'], ['--value'], ['--prestate'],
                       ['--unknown', '1'], ['extra'], ['--calldata'],
                       ['--prestate', '--value', '1'], ['--value', '-1'],
                       ['--value', '--prestate', 'state'], ['--calldata', '--value']]
        for index, flags in enumerate(bad_options):
            refuse('invalid-options-' + str(index), [*base, *flags], 'usage: assay')
        refuse('missing-calldata', ['trace', missing, '--value', '1'], 'usage: assay')
        refuse('missing-source', ['trace'], 'usage: assay')
        refuse('dash-source', ['trace', '-x', '--calldata', '', '--value', '1'], 'usage: assay')
        refuse('invalid-calldata', ['trace', missing, '--calldata', '0', '--value', '1'], 'CALLDATA_HEX')
        require(not (work / 'SENTINEL').exists(), 'TRACE-VALUE shell text executed')
        require(len(argvlog.read_text().splitlines()) == len(live) + len(faults),
                'TRACE-VALUE executed invalid input')
    (WORK / 'LIVE.json').write_text(json.dumps(live, indent=2) + '\n')
    print(f'TRACE-VALUE live={len(live)} funding={len(faults)} refused={len(refused)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, IndexError, subprocess.SubprocessError) as error:
        print('TRACE-VALUE FAIL ' + str(error))
        sys.exit(1)

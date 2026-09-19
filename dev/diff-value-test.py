#!/usr/bin/env python3
"""Public differential call values, signed transaction forwarding and refusals."""
import copy
import importlib.util
import itertools
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/diff-value'
SPEC = importlib.util.spec_from_file_location('differential', ROOT / 'evm/diff.py')
DIFF = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DIFF)
MAX = 2**256 - 1
SLOTS = {'0': '0xb', '7': '0x13'}
GET = '6d4ce63c'
SET = '60fe47b1'
FALLBACK = '0x59170bf0'  # Keccak-256("MalformedCalldata()")[:4].


def require(ok, message):
    if not ok:
        raise ValueError(message)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    binary = str(ROOT / '_build/default/bin/assay.exe')
    evm = shutil.which('evm')
    require(evm is not None, 'DIFF-VALUE missing evm')
    receipts, live, refused = [], [], []
    with tempfile.TemporaryDirectory(prefix='assay-diff-value-') as directory:
        work = Path(directory)
        source = work / 'contract with spaces; literal.asy'
        source.write_text((ROOT / 'examples/Fallback.asy').read_text())
        prestate = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
        prestate['alloc'] = {
            DIFF.SENDER: dict(balance=hex(MAX)),
            DIFF.RECEIVER: dict(balance='0x0', storage={'0x0': '0xb', '0x7': '0x13'}),
        }
        genesis = work / 'state with spaces; literal.json'
        genesis.write_text(json.dumps(prestate))
        commands = work / 'bin'
        commands.mkdir()
        (commands / 'python3').symlink_to(sys.executable)
        argvlog = work / 'argv.jsonl'
        wrapper = commands / 'evm'
        wrapper.write_text(
            '#!' + sys.executable + ' -P\nimport json,os,subprocess,sys\n'
            'data = sys.stdin.read() if "t8n" in sys.argv else None\n'
            'row = dict(argv=sys.argv[1:])\n'
            'if data is not None: row["txs"] = json.loads(data)["txs"]\n'
            'with open(os.environ["ASSAY_DIFF_ARGV"], "a") as stream: '
            'stream.write(json.dumps(row)+"\\n")\n'
            'sys.exit(subprocess.run([' + repr(evm) + ', *sys.argv[1:]], '
            'input=data, text=True).returncode)\n')
        wrapper.chmod(0o755)
        env = dict(os.environ, PATH=str(commands), ASSAY_DIFF_ARGV=str(argvlog))

        def invoke(name, args, code=0, marker='', environment=env):
            result = subprocess.run([binary, *args], cwd=work, env=environment,
                                    capture_output=True, text=True, timeout=75)
            receipts.append(dict(name=name, args=args, exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))
            (WORK / 'CASES.json').write_text(json.dumps(receipts, indent=2) + '\n')
            require(result.returncode == code and marker in result.stderr,
                    f'DIFF-VALUE {name}: {result.returncode}: {result.stdout}{result.stderr}')
            if code:
                require(not result.stdout, 'DIFF-VALUE failure printed success: ' + name)
                refused.append(name)
                return None
            require(not result.stderr, 'DIFF-VALUE stderr: ' + name)
            lines = result.stdout.splitlines()
            require(len(lines) == 2 and lines[1] == 'DIFF OK', 'DIFF-VALUE report: ' + name)
            return json.loads(lines[0])

        def case(name, data, value, status, output, slots=SLOTS, path=source, flags=None):
            options = ['--calldata', data, '--prestate', str(genesis)]
            if value is not None:
                options += ['--value', value]
            report = invoke(name, ['diff', str(path), *(options if flags is None else flags)])
            expected = dict(status=status, output=output, storage=slots)
            actual = dict(status=report['status'], output=report['output'],
                          storage=report['storage'].get(DIFF.RECEIVER, {}))
            require(actual == expected, 'DIFF-VALUE outcome: ' + name)
            model = subprocess.run(
                [binary, 'run', str(path), '--calldata', data, '--value', value or '0',
                 '--storage', '0=11', '--storage', '7=19', '--caller', '0x' + DIFF.SENDER],
                cwd=work, capture_output=True, text=True, timeout=30)
            require(model.returncode == 0 and not model.stderr and json.loads(model.stdout) == expected,
                    'DIFF-VALUE source model: ' + name)
            live.append(dict(name=name, value=value or '0', report=report,
                             model=json.loads(model.stdout), expected=expected))
            return report

        zero = case('default-zero', GET, None, 'success', '0x' + f'{11:064x}')
        for value in ('0', '0x0', '0X00', '0000'):
            report = case('explicit-zero-' + value, GET, value, 'success', '0x' + f'{11:064x}')
            require(report == zero, 'DIFF-VALUE default changed')
        case('write-zero', SET + f'{23:064x}', '0', 'success', '0x' + f'{23:064x}',
             {'0': '0x17', '7': '0x13'})
        case('write-nonpayable', SET + f'{23:064x}', '1', 'revert', '0x')
        for name, data, output in [('empty', '', FALLBACK), ('short', '010203', FALLBACK),
                                   ('unknown', 'ffffffff', FALLBACK), ('truncated', SET, '0x')]:
            case(name + '-zero', data, '0', 'revert', output)
            case(name + '-nonpayable', data, '1', 'revert', '0x')
        case('trailing-zero', GET + 'ff', '0', 'success', '0x' + f'{11:064x}')
        case('trailing-nonpayable', GET + 'ff', '1', 'revert', '0x')
        for value in ('1', '0x01', '0X01', '0007', str(MAX), hex(MAX), hex(MAX).upper()):
            case('word-' + value, GET, value, 'revert', '0x')
        for value in ('7', str(MAX)):
            case('closed-effect-' + value, '', value, 'success', '0x' + f'{42:064x}',
                 {'0': '0x2a', '7': '0x13'}, ROOT / 'examples/Ref20.asy')
        pairs = [('--calldata', GET), ('--value', '0X0A'), ('--prestate', str(genesis))]
        for index, order in enumerate(itertools.permutations(pairs)):
            flags = [item for pair in order for item in pair]
            case('option-order-' + str(index), GET, '0X0A', 'revert', '0x', flags=flags)

        argv = [json.loads(line) for line in argvlog.read_text().splitlines()]
        require(len(argv) == 2 * len(live), 'DIFF-VALUE executor count')
        for row, left, right in zip(live, argv[::2], argv[1::2]):
            value = int(row['value'], 16 if row['value'].lower().startswith('0x') else 10)
            args = left['argv']
            require(args[2] == 'run' and args[args.index('--value') + 1] == str(value),
                    'DIFF-VALUE run argv: ' + row['name'])
            require(right['argv'][2:5] == ['t8n', '--state.fork', 'Cancun'] and
                    len(right['txs']) == 1 and int(right['txs'][0]['value'], 16) == value,
                    'DIFF-VALUE signed transaction: ' + row['name'])

        poor = copy.deepcopy(prestate)
        poor['alloc'][DIFF.SENDER]['balance'] = '0xa'
        poor_path = work / 'insufficient.json'
        poor_path.write_text(json.dumps(poor))
        invoke('insufficient-balance', ['diff', str(source), '--calldata', GET,
               '--value', '11', '--prestate', str(poor_path)], 2, 'DIFF_VALUE: sender balance')
        invoke('unfunded-default', ['diff', str(source), '--calldata', GET, '--value', '1'],
               2, 'DIFF_VALUE: sender balance')
        require(len(argvlog.read_text().splitlines()) == len(argv), 'DIFF-VALUE executed unfunded call')

        missing = str(work / 'missing.asy')
        base = ['diff', missing, '--calldata', '']
        no_tools = dict(env, PATH='')
        invalid = ['', '0x', '0X', '+1', '1_0', '0b1', ' 1', '1 ', '1\n', '1.0',
                   '0xg', str(MAX + 1), '0x' + 'f' * 65, '0' * 79, '0x' + '0' * 65,
                   '; touch SENTINEL', '$(touch SENTINEL)']
        for index, value in enumerate(invalid):
            invoke('invalid-word-' + str(index), [*base, '--value', value], 64,
                   'DIFF_VALUE:', no_tools)
        # A dash-led word reaches the option parser, not the Word grammar,
        # so a signed spelling is a usage refusal rather than DIFF_VALUE.
        bad_options = [[], ['--calldata', ''], ['--prestate', 'a', '--prestate', 'b'],
                       ['--value', '1', '--value', '2'], ['--value'], ['--prestate'],
                       ['--unknown', '1'], ['extra'],
                       ['--prestate', '--value', '1'], ['--value', '-1']]
        for index, flags in enumerate(bad_options):
            args = ['diff', missing, '--value', '1'] if not flags else [*base, *flags]
            invoke('invalid-options-' + str(index), args, 64, 'usage: assay', no_tools)
        invoke('dash-source', ['diff', '-x', '--calldata', '', '--value', '1'],
               64, 'usage: assay', no_tools)
        invoke('invalid-calldata', ['diff', missing, '--calldata', '0', '--value', '1'],
               64, 'CALLDATA_HEX', no_tools)
        # Defence in depth. The two shell payloads in invalid are asserted
        # above to exit 64 at DIFF_VALUE validation, before the adapter or
        # any process starts, and the listing below pins the work directory
        # exactly, so this assertion cannot fail while those cases hold.
        require(not (work / 'SENTINEL').exists(), 'DIFF-VALUE shell injection')
        require(sorted(path.name for path in work.iterdir()) ==
                ['argv.jsonl', 'bin', source.name, poor_path.name, genesis.name],
                'DIFF-VALUE unexpected output file')
        (WORK / 'LIVE.json').write_text(json.dumps(live, indent=2) + '\n')
        (WORK / 'ARGV.json').write_text(json.dumps(argv, indent=2) + '\n')
    print(f'DIFF-VALUE live={len(live)} signed={len(argv) // 2} refused={len(refused)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as error:
        print('DIFF-VALUE FAIL ' + str(error), file=sys.stderr)
        sys.exit(1)

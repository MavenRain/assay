#!/usr/bin/env python3
"""Trace caller operands, access checks, funding, model agreement and refusals."""
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
WORK = ROOT / '.gatework/trace-caller'
SPEC = importlib.util.spec_from_file_location('differential', ROOT / 'evm/diff.py')
DIFF = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DIFF)
SENDER = '000000000000000000000000000073656e646572'
RECEIVER = DIFF.RECEIVER
MAX = 2**160 - 1
SLOTS = {'0': '0xb', '1': '0x13', '7': '0x17'}
GET = '6d4ce63c'
SET = '60fe47b1'
BUDGET_S = 180
SOURCE = '''contract TraceCaller where
  storage State := { owner : Word ; visits : Word }
  error Denied (sender : Word) (owner : Word)
  entry get () : Eff Sig Word := do
    first <- caller ; again <- caller ; pure again
  entry set (next : Word) : Eff Sig Word := do
    old <- sload owner ; sender <- caller ;
    sstore visits (word 99) ;
    guard Denied (sender) (old) (eqWord sender old) ;
    sstore owner next ; sstore visits (word 1) ; pure next
  constructor := do deployer owner ; pure ()
'''


def require(ok, message):
    if not ok:
        raise ValueError(message)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    binary = str(ROOT / '_build/bin/assay')
    evm = shutil.which('evm')
    require(evm is not None, 'TRACE-CALLER missing evm')
    receipts, live, faults, refused = [], [], [], []
    start = time.monotonic()
    with tempfile.TemporaryDirectory(prefix='assay-trace-caller-') as directory:
        work = Path(directory)
        source = work / 'contract with spaces; literal.asy'
        source.write_text(SOURCE)
        prestate = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
        prestate['alloc'] = {
            SENDER: dict(balance=hex(2**256 - 1)),
            f'{11:040x}': dict(balance='0x10'),
            RECEIVER: dict(balance='0x0', storage={f'0x{int(slot):064x}': f'0x{int(word, 16):064x}'
                                                 for slot, word in SLOTS.items()}),
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
            receipts.append(dict(name=name, args=args, exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))
            (WORK / 'CASES.json').write_text(json.dumps(receipts, indent=2) + '\n')
            spent = time.monotonic() - start
            if spent > BUDGET_S * 0.75:
                print(f'TRACE-CALLER budget warning: {name} at {spent:.1f}s of '
                      f'{BUDGET_S}s leg deadline', file=sys.stderr)
            require(result.returncode == code and marker in result.stderr,
                    f'TRACE-CALLER {name}: {result.returncode}: {result.stdout}{result.stderr}')
            if code == 0:
                require(not result.stderr, 'TRACE-CALLER stderr: ' + name)
            return result

        def case(name, caller, data=GET, status='success', output=None, slots=SLOTS,
                 value='0', reads=2, flags=None, state=genesis):
            word = caller if caller is not None else '0x' + SENDER
            address = int(word, 16 if word.lower().startswith('0x') else 10)
            options = ['--calldata', data, '--value', value]
            if state is not None:
                options += ['--prestate', str(state)]
            if caller is not None:
                options += ['--caller', caller]
            result = invoke(name, ['trace', str(source), *(options if flags is None else flags)],
                            2 if status == 'revert' else 0,
                            'TRACE_EXECUTION:' if status == 'revert' else '')
            report = DIFF.run_outcome(result.stdout)
            expected = dict(status=status, output=output or '0x' + f'{address:064x}', storage=slots)
            actual = dict(status=report['status'], output='0x' + report['output'],
                          storage=report['storage'].get(RECEIVER, {}))
            require(actual == expected, 'TRACE-CALLER outcome: ' + name)
            args = json.loads(argvlog.read_text().splitlines()[-1])
            require(args.count('--sender') == 1 and
                    args[args.index('--sender') + 1] == '0x' + f'{address:040x}',
                    'TRACE-CALLER executor sender: ' + name)
            require(args[args.index('--receiver') + 1] == '0x' + RECEIVER and
                    args[args.index('--input') + 1] == data.lower().removeprefix('0x'),
                    'TRACE-CALLER literal arguments: ' + name)
            if state is not None:
                require(args[args.index('--prestate') + 1] == str(state),
                        'TRACE-CALLER prestate argument: ' + name)
            records = DIFF.objects(result.stdout)
            operands = [right for left, right in zip(records, records[1:]) if left.get('op') == 51]
            require(len(operands) == reads and all(int(row['stack'][-1], 16) == address
                                                 for row in operands),
                    'TRACE-CALLER CALLER operands: ' + name)
            model_flags = [item for slot, word_value in (SLOTS.items() if state else [])
                           for item in ('--storage', slot + '=' + word_value)]
            model = invoke(name + '-model', ['run', str(source), '--calldata', data,
                                            '--value', value, '--caller', word, *model_flags])
            require(json.loads(model.stdout) == expected, 'TRACE-CALLER source model: ' + name)
            live.append(dict(name=name, caller=word, expected=expected, report=report, argv=args))
            return report

        default = case('default-caller', None)
        require(case('explicit-default', '0x' + SENDER) == default, 'TRACE-CALLER default changed')
        addresses = ('0', '0x0', '0X00', '0' * 78, '0x' + '0' * 64,
                     '1', '0009', '0010', '0XaBcDeF', str(MAX), hex(MAX), hex(MAX).upper(),
                     str(MAX).zfill(78), '0x' + '0' * 24 + 'f' * 40, '0x' + RECEIVER)
        for index, address in enumerate(addresses):
            case('address-' + str(index), address)
        case('default-prestate', '12', slots={}, state=None)
        case('owner-write', '11', SET + f'{23:064x}', output='0x' + f'{23:064x}',
             slots={'0': '0x17', '1': '0x1', '7': '0x17'}, reads=1)
        # Denied(uint256,uint256) has independently frozen selector 0x8f130409.
        case('denied-rollback', '12', SET + f'{23:064x}', status='revert',
             output='0x8f130409' + f'{12:064x}{11:064x}', reads=1)
        case('funded-nonpayable', '11', SET + f'{23:064x}', status='revert',
             output='0x', value='1', reads=0)
        pairs = [('--calldata', GET), ('--caller', '0X0B'), ('--prestate', str(genesis)), ('--value', '0')]
        for index, order in enumerate(itertools.permutations(pairs)):
            case('option-order-' + str(index), '0X0B', flags=[item for pair in order for item in pair])

        for name, caller, value in [('unfunded-caller', '12', '1'), ('insufficient-caller', '11', '17')]:
            result = invoke(name, ['trace', str(source), '--calldata', GET, '--caller', caller,
                                   '--value', value, '--prestate', str(genesis)], 2, 'TRACE_EXECUTION:')
            records = DIFF.objects(result.stdout)
            require(len(records) == 2 and records[0].get('error') == 'insufficient balance for transfer'
                    and 'pc' not in records[0] and
                    DIFF.storage(records[1]['accounts']).get(RECEIVER, {}) == SLOTS,
                    'TRACE-CALLER funding fault: ' + name)
            faults.append(name)

        missing = str(work / 'missing.asy')
        base = ['trace', missing, '--calldata', '']
        no_tools = dict(env, PATH='')

        def refuse(name, args, marker):
            result = invoke(name, args, 64, marker, no_tools)
            require(not result.stdout, 'TRACE-CALLER refusal printed trace: ' + name)
            refused.append(name)

        invalid = ['', '0x', '0X', '+1', '1_0', '0b1', '0o7', ' 1', '1 ', '1\n', '1.0',
                   '0xg', 'abcdef', str(MAX + 1), hex(MAX + 1), str(2**256 - 1), str(2**256),
                   '0x' + 'f' * 65, '0' * 79, '0x' + '0' * 65,
                   '; touch SENTINEL', '$(touch SENTINEL)']
        for index, address in enumerate(invalid):
            marker = 'TRACE_CALLER: caller exceeds uint160' if address in (
                str(MAX + 1), hex(MAX + 1), str(2**256 - 1)) else 'TRACE_CALLER:'
            refuse('invalid-address-' + str(index), [*base, '--caller', address], marker)
        bad_options = [['--caller'], ['--caller', '-1'], ['--caller', '--value', '0'],
                       ['--caller', '1', '--caller', '2'], ['--caller', '1', 'extra'],
                       ['--caller', '1', '--unknown', '0'], ['--caller', '1', '--calldata', '']]
        for index, flags in enumerate(bad_options):
            refuse('invalid-options-' + str(index), [*base, *flags], 'usage: assay')
        refuse('missing-calldata', ['trace', missing, '--caller', '1'], 'usage: assay')
        refuse('caller-before-source', ['trace', '--caller', '1', missing, '--calldata', ''], 'usage: assay')
        require(not (work / 'SENTINEL').exists(), 'TRACE-CALLER shell text executed')
        require(len(argvlog.read_text().splitlines()) == len(live) + len(faults),
                'TRACE-CALLER executor count')
    (WORK / 'LIVE.json').write_text(json.dumps(live, indent=2) + '\n')
    print(f'TRACE-CALLER live={len(live)} funding={len(faults)} refused={len(refused)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, IndexError, subprocess.SubprocessError) as error:
        print('TRACE-CALLER FAIL ' + str(error))
        sys.exit(1)

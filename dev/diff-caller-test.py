#!/usr/bin/env python3
"""Differential fixture identities, signed callers, funding and refusal boundaries."""
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
WORK = ROOT / '.gatework/diff-caller'
SPEC = importlib.util.spec_from_file_location('differential', ROOT / 'evm/diff.py')
DIFF = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DIFF)
# Independently frozen addresses of the public signing scalars 1 and 2.
FIRST = '7e5f4552091a69125d5dfcb7b8c2659029395bdf'
SECOND = '2b5ad5c4795c026514f8317c7a215e218dccd6cf'
GET = '6d4ce63c'
SET = '60fe47b1'
SLOTS = {'0': '0x' + FIRST, '1': '0x13', '7': '0x17'}
SOURCE = '''contract DifferentialCaller where
  storage State := { owner : Word ; visits : Word }
  error Denied (sender : Word) (owner : Word)
  entry get () : Eff Sig Word := do
    first <- caller ; again <- caller ; pure again
  entry set (next : Word) : Eff Sig Word := do
    old <- sload owner ; sender <- caller ; sstore visits (word 99) ;
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
    require(evm is not None, 'DIFF-CALLER missing evm')
    receipts, live, refused, rejected = [], [], [], []
    with tempfile.TemporaryDirectory(prefix='assay-diff-caller-') as directory:
        work = Path(directory)
        source = work / 'caller with spaces; literal.asy'
        source.write_text(SOURCE)
        base = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
        prestate = copy.deepcopy(base)
        prestate['alloc'] = {
            FIRST: dict(balance='0xa', nonce='0x3', storage={'0x2': '0x11'}),
            SECOND: dict(balance='0x14', nonce='0x5', storage={'0x4': '0x15'}),
            DIFF.RECEIVER: dict(balance='0x0', storage={hex(int(k)): v for k, v in SLOTS.items()}),
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
            'if data is not None: row["input"] = json.loads(data)\n'
            'with open(os.environ["ASSAY_DIFF_CALLER_ARGV"], "a") as stream: '
            'stream.write(json.dumps(row)+"\\n")\n'
            'sys.exit(subprocess.run([' + repr(evm) + ', *sys.argv[1:]], '
            'input=data, text=True).returncode)\n')
        wrapper.chmod(0o755)
        env = dict(os.environ, PATH=str(commands), ASSAY_DIFF_CALLER_ARGV=str(argvlog))
        no_tools = dict(env, PATH='')

        def invoke(name, args, code=0, marker='', environment=env):
            result = subprocess.run([binary, *args], cwd=work, env=environment,
                                    capture_output=True, text=True, timeout=75)
            receipts.append(dict(name=name, args=args, exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))
            (WORK / 'CASES.json').write_text(json.dumps(receipts, indent=2) + '\n')
            require(result.returncode == code and marker in result.stderr,
                    f'DIFF-CALLER {name}: {result.returncode}: {result.stdout}{result.stderr}')
            if code:
                require(not result.stdout, 'DIFF-CALLER failure printed success: ' + name)
                (refused if code == 64 else rejected).append(name)
                return None
            require(not result.stderr, 'DIFF-CALLER stderr: ' + name)
            lines = result.stdout.splitlines()
            require(len(lines) == 2 and lines[1] == 'DIFF OK', 'DIFF-CALLER report: ' + name)
            return json.loads(lines[0])

        def case(name, caller=None, data=GET, value='0', status='success', output=None,
                 slots=SLOTS, initial=SLOTS, state=genesis, flags=None, nonce=None):
            word = caller if caller is not None else '0x' + FIRST
            address = int(word, 16 if word.lower().startswith('0x') else 10)
            sender = f'{address:040x}'
            options = ['--calldata', data, '--value', value]
            if caller is not None:
                options += ['--caller', caller]
            if state is not None:
                options += ['--prestate', str(state)]
            report = invoke(name, ['diff', str(source), *(options if flags is None else flags)])
            expected = dict(status=status, output=output or '0x' + f'{address:064x}', storage=slots)
            actual = dict(status=report['status'], output=report['output'],
                          storage=report['storage'].get(DIFF.RECEIVER, {}))
            require(actual == expected, 'DIFF-CALLER outcome: ' + name)
            all_storage = {DIFF.RECEIVER: slots, FIRST: {'2': '0x11'}, SECOND: {'4': '0x15'}} if state else {}
            require(report['storage'] == all_storage, 'DIFF-CALLER preserved accounts: ' + name)
            model_flags = [item for slot, val in initial.items() for item in ('--storage', slot + '=' + val)]
            model = subprocess.run([binary, 'run', str(source), '--calldata', data, '--value', value,
                                    '--caller', word, *model_flags], cwd=work,
                                   capture_output=True, text=True, timeout=30)
            require(model.returncode == 0 and not model.stderr and json.loads(model.stdout) == expected,
                    'DIFF-CALLER source model: ' + name)
            live.append(dict(name=name, caller=sender, value=value, report=report, expected=expected,
                             nonce=nonce if nonce is not None else (0 if state is None else 3 if sender == FIRST else 5)))
            return report

        default = case('default-caller')
        require(case('explicit-default', '0x' + FIRST) == default, 'DIFF-CALLER default changed')
        for label, address in [('first', FIRST), ('second', SECOND)]:
            spellings = ['0x' + address, ('0x' + address).upper(), str(int(address, 16)),
                         str(int(address, 16)).zfill(78), '0x' + '0' * 24 + address]
            for index, spelling in enumerate(spellings):
                case(label + '-spelling-' + str(index), spelling)
            case(label + '-nonpayable', '0x' + address, value='1', status='revert', output='0x')
        case('default-prestate', '0x' + SECOND, slots={}, initial={}, state=None)
        case('second-selected-funds', '0x' + SECOND, value='11', status='revert', output='0x')
        case('owner-write', '0x' + FIRST, SET + f'{23:064x}', output='0x' + f'{23:064x}',
             slots={'0': '0x17', '1': '0x1', '7': '0x17'})
        # Denied(uint256,uint256) has independently frozen selector 0x8f130409.
        case('denied-rollback', '0x' + SECOND, SET + f'{23:064x}', status='revert',
             output='0x8f130409' + f'{int(SECOND, 16):064x}{int(FIRST, 16):064x}')
        second_state = copy.deepcopy(prestate)
        second_state['alloc'][DIFF.RECEIVER]['storage']['0x0'] = '0x' + SECOND
        second_path = work / 'second-owner.json'
        second_path.write_text(json.dumps(second_state))
        case('second-owner-write', '0x' + SECOND, SET + f'{29:064x}', output='0x' + f'{29:064x}',
             slots={'0': '0x1d', '1': '0x1', '7': '0x17'},
             initial=dict(SLOTS, **{'0': '0x' + SECOND}), state=second_path)
        pairs = [('--calldata', GET), ('--caller', '0X' + SECOND.upper()),
                 ('--prestate', str(genesis)), ('--value', '0')]
        for index, order in enumerate(itertools.permutations(pairs)):
            case('option-order-' + str(index), '0x' + SECOND,
                 flags=[item for pair in order for item in pair])

        exhausted = copy.deepcopy(prestate)
        exhausted['alloc'][SECOND]['nonce'] = hex(2**64 - 1)
        exhausted_path = work / 'exhausted.json'
        exhausted_path.write_text(json.dumps(exhausted))
        case('inactive-exhausted-nonce', '0x' + FIRST, state=exhausted_path)
        boundary = copy.deepcopy(prestate)
        boundary['alloc'][SECOND]['nonce'] = hex(2**64 - 2)
        boundary_path = work / 'nonce-boundary.json'
        boundary_path.write_text(json.dumps(boundary))
        case('active-nonce-boundary', '0x' + SECOND, state=boundary_path, nonce=2**64 - 2)

        argv = [json.loads(line) for line in argvlog.read_text().splitlines()]
        require(len(argv) == 2 * len(live), 'DIFF-CALLER executor count')
        for row, left, right in zip(live, argv[::2], argv[1::2]):
            args = left['argv']
            tx = right['input']['txs'][0]
            key = 1 if row['caller'] == FIRST else 2
            require(args[2] == 'run' and args[args.index('--sender') + 1] == '0x' + row['caller'],
                    'DIFF-CALLER run sender: ' + row['name'])
            require(right['argv'][2:5] == ['t8n', '--state.fork', 'Cancun'] and
                    len(right['input']['txs']) == 1 and int(tx['secretKey'], 16) == key and
                    int(tx['nonce'], 16) == row['nonce'] and int(tx['value'], 16) == int(row['value']),
                    'DIFF-CALLER signed identity: ' + row['name'])

        for label, address, value, state, marker in [
            ('first-funds', FIRST, '11', genesis, 'DIFF_VALUE: sender balance'),
            ('second-funds', SECOND, '21', genesis, 'DIFF_VALUE: sender balance'),
            ('unfunded-second', SECOND, '1', None, 'DIFF_VALUE: sender balance'),
            ('active-exhausted-nonce', SECOND, '0', exhausted_path, 'DIFF_PRESTATE: sender nonce'),
        ]:
            flags = ['--prestate', str(state)] if state else []
            invoke(label, ['diff', str(source), '--calldata', GET, '--caller', '0x' + address,
                           '--value', value, *flags], 2, marker)
        require(len(argvlog.read_text().splitlines()) == len(argv), 'DIFF-CALLER ran rejected transaction')

        missing = str(work / 'missing.asy')
        options = ['diff', missing, '--calldata', '']
        invalid = ['', '0x', '0X', '+1', '1_0', '0b1', '0o7', ' 1', '1 ', '1\n', '1.0',
                   '0xg', 'abcdef', str(2**160), hex(2**160), str(2**256 - 1), str(2**256),
                   '0x' + 'f' * 65, '0' * 79, '0x' + '0' * 65,
                   '; touch SENTINEL', '$(touch SENTINEL)', '0', '1', hex(2**160 - 1), '0x' + DIFF.RECEIVER]
        for index, caller in enumerate(invalid):
            invoke('invalid-caller-' + str(index), [*options, '--caller', caller], 64, 'DIFF_CALLER:', no_tools)
        bad_options = [['--caller'], ['--caller', '-1'], ['--caller', '--value', '0'],
                       ['--caller', '0x' + FIRST, '--caller', '0x' + SECOND],
                       ['--caller', '0x' + SECOND, 'extra'], ['--caller', '0x' + SECOND, '--unknown', '1']]
        for index, flags in enumerate(bad_options):
            invoke('invalid-options-' + str(index), [*options, *flags], 64, 'usage: assay', no_tools)
        invoke('missing-calldata', ['diff', missing, '--caller', '0x' + SECOND], 64, 'usage: assay', no_tools)
        require(not (work / 'SENTINEL').exists(), 'DIFF-CALLER shell injection')

        # DIFF_VALUE fires before DIFF_CALLER when both flags are grammar-invalid.
        combined = subprocess.run([binary, 'diff', missing, '--calldata', '', '--value', '0xg', '--caller', '0xg'],
                                  cwd=work, env=no_tools, capture_output=True, text=True, timeout=10)
        require(combined.returncode == 64 and 'DIFF_VALUE:' in combined.stderr and not combined.stdout,
                'DIFF-CALLER value before caller: invalid-value-and-caller')
        receipts.append(dict(name='invalid-value-and-caller', exit=combined.returncode, stderr=combined.stderr))
        (WORK / 'CASES.json').write_text(json.dumps(receipts, indent=2) + '\n')

        # Direct adapter callers receive the same named boundary before tool lookup.
        helper = []
        for index, caller in enumerate(['0', '0x' + DIFF.RECEIVER, '-1', '0xg', str(2**160)]):
            result = subprocess.run([sys.executable, '-P', str(ROOT / 'evm/diff.py'), '--runtime', '00',
                                     '--calldata', '', '--prestate', str(genesis), '--caller', caller],
                                    env=no_tools, capture_output=True, text=True, timeout=10)
            require(result.returncode == 2 and 'DIFF_CALLER:' in result.stderr and not result.stdout,
                    'DIFF-CALLER helper refusal: ' + caller)
            receipts.append(dict(name='helper-refusal-' + str(index), exit=result.returncode, stderr=result.stderr))
            helper.append(index)
        (WORK / 'CASES.json').write_text(json.dumps(receipts, indent=2) + '\n')
        (WORK / 'LIVE.json').write_text(json.dumps(live, indent=2) + '\n')
        (WORK / 'ARGV.json').write_text(json.dumps(argv, indent=2) + '\n')
    print(f'DIFF-CALLER live={len(live)} signed={len(argv) // 2} rejected={len(rejected)} refused={len(refused)} helper={len(helper)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('DIFF-CALLER FAIL ' + str(error), file=sys.stderr)
        sys.exit(1)

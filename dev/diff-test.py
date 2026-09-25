#!/usr/bin/env python3
"""Live executor agreement, public driver failures and damaged-capture witnesses."""
import copy
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location('differential', ROOT / 'evm/diff.py')
DIFF = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DIFF)
BASE = json.loads((ROOT / 'evm/fixtures/cancun.json').read_text())
REF20 = '602a5f55600b56fefefefe5b5f545f5260205ff3'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def fixture():
    state = copy.deepcopy(BASE)
    state['alloc'] = {DIFF.RECEIVER: dict(balance='0x0', storage={'0x0': '0x63', '0x7': '0xb'})}
    return state


def live():
    evm = shutil.which('evm')
    require(evm is not None, 'DIFF-TEST missing evm')
    receipts = []
    rows = [
        ('reference', REF20, '', BASE, 'success', 42, {'0': '0x2a'}),
        ('overwrite-preserve', REF20, '00ff', fixture(), 'success', 42, {'0': '0x2a', '7': '0xb'}),
        ('read-nonzero', '5f545f5260205ff3', '', fixture(), 'success', 99, {'0': '0x63', '7': '0xb'}),
        ('clear', '5f5f555f545f5260205ff3', '', fixture(), 'success', 0, {'7': '0xb'}),
        ('return-calldata', '5f355f5260205ff3', '00' * 31 + '17', BASE, 'success', 23, {}),
        ('revert-data', '602b5f5260205ffd', '', fixture(), 'revert', 43, {'0': '0x63', '7': '0xb'}),
        ('revert-rollback', '602a5f55602b5f5260205ffd', 'ff', fixture(), 'revert', 43, {'0': '0x63', '7': '0xb'}),
        ('caller', '335f5260205ff3', '', BASE, 'success', int(DIFF.SENDER, 16), {}),
        ('gas', '5a5f5260205ff3', '00ff', BASE, 'success', DIFF.GAS - 2, {}),
    ]
    for name, runtime, calldata, prestate, status, value, slots in rows:
        report, evidence = DIFF.execute(runtime, calldata, prestate, evm)
        require(report['status'] == status and int(report['output'], 16) == value
                and report['storage'].get(DIFF.RECEIVER, {}) == slots, 'DIFF-LIVE ' + name)
        receipts.append(dict(name=name, report=report, evidence=evidence))
        print('DIFF-LIVE ' + name + ' OK')
    binary = str(ROOT / '_build/bin/assay')
    for source in sorted((ROOT / 'corpus').glob('*/*.asy')):
        with tempfile.TemporaryDirectory(prefix='assay-diff-corpus-') as directory:
            output = Path(directory) / 'out'
            subprocess.run([binary, 'emit', str(source), '-o', str(output)], check=True,
                           capture_output=True, text=True, timeout=30)
            report, evidence = DIFF.execute((output / 'runtime.hex').read_text().strip(), '00ff', BASE, evm)
            receipts.append(dict(name=str(source.relative_to(ROOT)), report=report, evidence=evidence))
    require(len(receipts) == 20, 'DIFF-LIVE corpus inventory')
    return receipts


def driver():
    binary = str(ROOT / '_build/bin/assay')
    source = str(ROOT / 'examples/Ref20.asy')
    receipts = []
    with tempfile.TemporaryDirectory(prefix='assay-diff-driver-') as directory:
        work = Path(directory)
        commands = work / 'bin'
        commands.mkdir()
        (commands / 'python3').symlink_to(sys.executable)
        wrapper = commands / 'evm'
        argvlog = work / 'argv.jsonl'
        wrapper.write_text('#!' + sys.executable + ' -P\nimport json,os,sys\n'
                           'with open(os.environ["ASSAY_DIFF_ARGV"], "a") as stream: stream.write(json.dumps(sys.argv[1:])+"\\n")\n'
                           'os.execv(' + repr(shutil.which('evm')) + ', ["evm", *sys.argv[1:]])\n')
        wrapper.chmod(0o755)
        env = dict(os.environ, PATH=str(commands), ASSAY_DIFF_ARGV=str(argvlog))

        def invoke(name, args, code, diagnostic='', environment=env, program=binary):
            result = subprocess.run([program, *args], cwd=work, env=environment,
                                    capture_output=True, text=True, timeout=70)
            require(result.returncode == code and diagnostic in result.stderr,
                    f'DIFF-DRIVER {name}: {result.returncode}: {result.stdout}{result.stderr}')
            if code == 0:
                lines = result.stdout.splitlines()
                require(len(lines) == 2 and lines[-1] == 'DIFF OK' and not result.stderr,
                        'DIFF-DRIVER output ' + name)
                require(json.loads(lines[0])['output'] == '0x' + '00' * 31 + '2a', 'DIFF-DRIVER return')
            else:
                require(not result.stdout, 'DIFF-DRIVER failure wrote a success report')
            receipts.append(dict(name=name, args=args, exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))

        for data in ('', '0x', '00', 'ff', '00ff', '0xDEADBEEF', '00' * 32, '01' * 33):
            invoke('calldata-' + data, ['diff', source, '--calldata', data], 0)
        custom = work / 'prestate with spaces.json'
        custom.write_text(json.dumps(fixture()))
        spaced = work / 'source with spaces.asy'
        spaced.write_text(Path(source).read_text())
        invoke('explicit-prestate', ['diff', str(spaced), '--calldata', '00ff', '--prestate', str(custom)], 0)
        args = ['diff', source, '--calldata', '']
        invocations = [json.loads(line) for line in argvlog.read_text().splitlines()]
        require(len(invocations) == 18, 'DIFF-ARGV executor count')
        require(all(row[2] == 'run' and '--prestate' in row for row in invocations[::2]), 'DIFF-ARGV run')
        require(all(row[2:5] == ['t8n', '--state.fork', 'Cancun'] for row in invocations[1::2]), 'DIFF-ARGV fork')
        for name, extra, code, diagnostic in [
            ('missing-calldata', ['diff', source], 64, 'usage: assay'),
            ('odd-calldata', ['diff', source, '--calldata', '0'], 64, 'CALLDATA_HEX'),
            ('bad-calldata', ['diff', source, '--calldata', '; touch SENTINEL'], 64, 'CALLDATA_HEX'),
            ('extra-argument', [*args, 'extra'], 64, 'usage: assay'),
            ('missing-source', ['diff', str(work / 'missing.asy'), '--calldata', ''], 64, 'cannot read'),
            ('protocol', ['diff', str(ROOT / 'examples/m0-spine.kan'), '--calldata', ''], 2, 'assay: diff: M0_PROTOCOL'),
            ('missing-prestate', [*args, '--prestate', str(work / 'missing.json')], 2, 'No such file'),
        ]:
            invoke(name, extra, code, diagnostic)
        require(not (work / 'SENTINEL').exists(), 'DIFF-ARGV shell injection')
        custom.write_text('{')
        invoke('invalid-json', [*args, '--prestate', str(custom)], 2, 'assay: diff:')
        custom.write_text(json.dumps(dict(BASE, config={})))
        invoke('wrong-fork', [*args, '--prestate', str(custom)], 2, 'DIFF_PRESTATE')
        invoke('missing-python', args, 2, 'DIFF_TOOL: python3', dict(env, PATH=''))
        wrapper.chmod(0o644)
        invoke('non-executable-evm', args, 2, 'DIFF_TOOL: evm')
        wrapper.chmod(0o755)
        wrapper.write_text('#!/bin/sh\nexit 7\n')
        invoke('executor-exit', args, 2, 'DIFF_EXECUTOR: exit 7')
        wrapper.write_text('#!/bin/sh\nkill -TERM $$\n')
        invoke('executor-signal', args, 2, 'DIFF_EXECUTOR: exit -15')
        wrapper.write_text('#!/bin/sh\nprintf "{}"\n')
        invoke('malformed-executor', args, 2, 'DIFF_RUN')
        # A zero exit with stderr is the only path to the unexpected-stderr
        # guard of evm/diff.py, so the wrapper reports and then succeeds.
        wrapper.write_text('#!/bin/sh\nprintf "warning\\n" >&2\nprintf "{}"\n')
        invoke('executor-stderr', args, 2, 'DIFF_EXECUTOR: unexpected stderr')
        # A copied binary under a tree without evm/diff.py reaches the helper
        # guard of Differential in src/cli.bend. The fixture keeps the default
        # prestate readable, so only the helper is absent.
        nest = commands / 'tree'
        (nest / '_build/bin').mkdir(parents=True)
        (nest / 'evm/fixtures').mkdir(parents=True)
        shutil.copy2(ROOT / 'evm/fixtures/cancun.json', nest / 'evm/fixtures/cancun.json')
        native_mutations.copy_build(ROOT, nest)
        invoke('missing-helper', args, 2, 'DIFF_HELPER: cannot read evm/diff.py',
               program=str(nest / '_build/bin/assay'))
        # A python3 that dies by a signal reaches the WSIGNALED arm.  The
        # report must name the signal, not an encoded signal number.
        runner = commands / 'python3'
        runner.unlink()
        runner.write_text('#!/bin/sh\nkill -TERM $$\n')
        runner.chmod(0o755)
        invoke('runner-signal', args, 2, 'DIFF_RUNNER: killed by SIGTERM')
        require(sorted(path.name for path in work.iterdir()) ==
                ['argv.jsonl', 'bin', 'prestate with spaces.json', 'source with spaces.asy'],
                'DIFF-DRIVER unexpected output files')
    # Exercise the adapter command line independently of the public driver's
    # Word validation. The counter gate calls execute() with an integer.
    with tempfile.TemporaryDirectory(prefix='assay-diff-value-') as directory:
        genesis = Path(directory) / 'prestate.json'
        genesis.write_text(json.dumps(dict(BASE, alloc={DIFF.SENDER: dict(balance='0xa')})))
        argv = [sys.executable, '-P', str(ROOT / 'evm/diff.py'), '--runtime', '345f5260205ff3',
                '--calldata', '', '--prestate', str(genesis)]
        for name, value, code, marker in [('cli-value', '7', 0, 'DIFF OK'),
                                          ('cli-value-above-balance', '11', 2, 'DIFF_VALUE')]:
            result = subprocess.run([*argv, '--value', value], cwd=str(ROOT),
                                    capture_output=True, text=True, timeout=70)
            require(result.returncode == code and marker in result.stdout + result.stderr,
                    f'DIFF-DRIVER {name}: {result.returncode}: {result.stdout}{result.stderr}')
            require(code != 0 or json.loads(result.stdout.splitlines()[0])['output'] == '0x' + '00' * 31 + '07',
                    'DIFF-DRIVER value word ' + name)
            receipts.append(dict(name=name, args=['--value', value], exit=result.returncode,
                                 stdout=result.stdout, stderr=result.stderr))
    print(f'DIFF-DRIVER cases={len(receipts)} literal_argv=true OK')
    return receipts


def checks(receipts):
    good = receipts[0]['evidence']
    killed = []

    def reject(name, action, marker):
        try:
            action()
        except (ValueError, KeyError, TypeError) as error:
            require(marker in str(error), 'DIFF-CHECK wrong witness ' + name + ': ' + str(error))
            killed.append(dict(name=name, witness=str(error)))
            print('DIFF-CHECK ' + name + ' killed witness=' + str(error))
        else:
            raise ValueError('DIFF-CHECK survived ' + name)

    run = DIFF.objects(good['run'])
    transition = DIFF.objects(good['transition'])[0]
    traces = good['traces']
    left = DIFF.run_outcome(good['run'])
    right, _gas = DIFF.transition_outcome(good['transition'], traces)
    for name, key, value in [('STATUS', 'status', 'revert'), ('RETURN', 'output', '00'), ('STORAGE', 'storage', {})]:
        damaged = dict(right, **{key: value})
        reject(name, lambda: DIFF.compare(left, damaged), 'DIFF_MISMATCH: ' + key)
    for name, mutate, marker in [
        ('NO-RESULT', lambda obj: obj.pop('result'), 'DIFF_T8N'),
        ('NO-ALLOC', lambda obj: obj.pop('alloc'), 'DIFF_T8N'),
        ('REJECTED', lambda obj: obj['result'].update(rejected=[{'index': 0, 'error': 'bad tx'}]), 'transaction rejected'),
        ('NO-RECEIPT', lambda obj: obj['result'].update(receipts=[]), 'expected one receipt'),
        ('DUP-RECEIPT', lambda obj: obj['result']['receipts'].append(obj['result']['receipts'][0]), 'expected one receipt'),
        ('RECEIPT-STATUS', lambda obj: obj['result']['receipts'][0].update(status='0x0'), 'receipt and trace disagree'),
        ('RECEIPT-HASH', lambda obj: obj['result']['receipts'][0].update(transactionHash='0x' + '00' * 32), 'transaction trace'),
        ('RECEIPT-INDEX', lambda obj: obj['result']['receipts'][0].update(transactionIndex='0x1'), 'receipt index'),
        ('BAD-STORAGE', lambda obj: obj['alloc']['0x' + DIFF.RECEIVER].update(storage={'0x0': 'zz'}), 'DIFF_STORAGE'),
    ]:
        damaged = copy.deepcopy(transition)
        mutate(damaged)
        reject(name, lambda: DIFF.transition_outcome(json.dumps(damaged), traces), marker)
    reject('NO-TRACE', lambda: DIFF.transition_outcome(good['transition'], {}), 'transaction trace')
    reject('TRAILING-JSON', lambda: DIFF.run_outcome(good['run'] + '{}'), 'DIFF_RUN')
    reject('DUP-JSON', lambda: DIFF.objects('{"a":1,"a":2}'), 'duplicate key')
    reject('NO-STATE', lambda: DIFF.run_outcome('\n'.join(map(json.dumps, run[:-1]))), 'DIFF_RUN')
    damaged = copy.deepcopy(run)
    damaged[-2]['error'] = 'invalid opcode: INVALID'
    reject('EVM-FAULT', lambda: DIFF.run_outcome('\n'.join(map(json.dumps, damaged))), 'DIFF_EXECUTION')
    damaged = copy.deepcopy(run)
    damaged[-2]['gasUsed'] = hex(DIFF.GAS + 1)
    reject('EXCESS-GAS', lambda: DIFF.run_outcome('\n'.join(map(json.dumps, damaged))), 'gas exceeds')
    damaged = fixture()
    damaged['alloc']['0x' + DIFF.RECEIVER] = damaged['alloc'][DIFF.RECEIVER]
    reject('DUP-ACCOUNT', lambda: DIFF.prepare(damaged, REF20), 'DIFF_PRESTATE')
    damaged = fixture()
    damaged['alloc'][DIFF.RECEIVER]['storage']['00'] = '0x3'
    reject('DUP-SLOT', lambda: DIFF.prepare(damaged, REF20), 'duplicate slot')
    evm = shutil.which('evm')
    reject('LIVE-FAULT', lambda: DIFF.execute('fe', '', BASE, evm), 'DIFF_EXECUTION')
    reject('GASLIMIT', lambda: DIFF.execute('455f5260205ff3', '', BASE, evm), 'DIFF_CONTEXT')
    reject('BASEFEE', lambda: DIFF.execute('485f5260205ff3', '', BASE, evm), 'DIFF_CONTEXT')
    reject('BLOBBASEFEE', lambda: DIFF.execute('4a5f5260205ff3', '', BASE, evm), 'DIFF_CONTEXT')
    DIFF.supported('60456048604a00')
    DIFF.compare(left, right)
    print(f'DIFF-CHECKS killed={len(killed)}/{len(killed)} controls=1 OK')
    return killed


def main():
    work = ROOT / '.gatework'
    work.mkdir(exist_ok=True)
    receipts = live()
    drivers = driver()
    mutants = checks(receipts)
    (work / 'diff-evidence.json').write_text(json.dumps(dict(live=receipts, driver=drivers, mutants=mutants), indent=2) + '\n')
    print(f'DIFF-EXECUTOR live={len(receipts)} driver={len(drivers)} rejected={len(mutants)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('DIFF-EXECUTOR FAIL ' + str(error))
        sys.exit(1)

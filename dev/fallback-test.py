#!/usr/bin/env python3
"""Check fallback routing, typed payloads, refusal boundaries and mutations."""
import hashlib
import importlib.util
import json
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/fallback'
spec = importlib.util.spec_from_file_location('fallback_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
C.WORK = WORK
require = C.require
MAX = 2**256 - 1
BEFORE = {'0': '0x7', '8': '0xb'}
SLOTS = {'0x0': '0x7', '0x8': '0xb'}
FALLBACK = 'fallback : Eff Sig Never := revert MalformedCalldata'
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')


def signature(name):
    key = hashlib.sha256(name.encode()).hexdigest()
    return C.checked('signature-' + key, ['cast', 'sig', name]).strip()[2:]


def example():
    return (ROOT / 'examples/Fallback.asy').read_text()


def fixtures():
    source = example()
    payload = source.replace('error MalformedCalldata ()',
                             'error MalformedCalldata (code : Word) (maximum : Word)')
    payload = payload.replace(FALLBACK, FALLBACK + ' (word 0xAB) (word 0x' + 'f' * 64 + ')')
    second = source.replace(FALLBACK, 'fallback : Eff Sig Never := revert Denied (word 9)')
    return [
        ('nullary', source, '0x' + signature('MalformedCalldata()')),
        ('payload', payload, '0x' + signature('MalformedCalldata(uint256,uint256)') + f'{171:064x}{MAX:064x}'),
        ('second-error', second, '0x' + signature('Denied(uint256)') + f'{9:064x}'),
        ('empty', source.replace(FALLBACK, 'fallback : Eff Sig Never := revert'), '0x'),
        ('omitted', source.replace('  ' + FALLBACK + '\n', ''), '0x'),
    ]


def emitted(name, source):
    output = WORK / name
    if output.exists():
        shutil.rmtree(output)
    path, output, runtime = C.emit(name, source)
    C.checked('check-' + name, [C.BINARY, 'check', path])
    return path, output, runtime


def abi(name, output):
    def arg(field):
        return dict(name=field, type='uint256')
    def method(name, fields, mutability):
        return dict(type='function', name=name, inputs=[arg(field) for field in fields],
                    outputs=[arg('')], stateMutability=mutability)
    want = [dict(type='constructor', inputs=[], stateMutability='nonpayable'),
            method('get', [], 'view'), method('set', ['amount'], 'nonpayable'),
            method('fail', [], 'nonpayable'),
            dict(type='error', name='MalformedCalldata',
                 inputs=[arg('code'), arg('maximum')] if name == 'payload' else []),
            dict(type='error', name='Denied', inputs=[arg('code')])]
    if name != 'omitted':
        want.append(dict(type='fallback', stateMutability='nonpayable'))
    require(json.loads((output / 'abi.json').read_text()) == want, 'FALLBACK-ABI ' + name)


def compare(key, path, runtime, data, value, expected, *, signed=True):
    argv = [C.BINARY, 'run', path, '--calldata', data, '--value', value,
            '--caller', hex(C.SENDER), '--storage', '0=7', '--storage', '8=11']
    model = json.loads(C.checked('model-' + key, argv))
    require(model == expected, 'FALLBACK-MODEL ' + key)
    actual, _ = C.evm_run(key, runtime, data, C.SENDER, slots=SLOTS, value=value)
    require(actual == expected, 'FALLBACK-EVM ' + key)
    if signed:
        report, evidence = C.D.execute(runtime, data, C.prestate(SLOTS), shutil.which('evm'), value=value)
        C.save('signed-' + key, dict(report=report, evidence=evidence))
        actual = dict(status=report['status'], output=report['output'],
                      storage=report['storage'].get(C.D.RECEIVER, {}))
        require(actual == expected, 'FALLBACK-SIGNED ' + key)
    return dict(name=key, calldata=data, value=value, expected=expected, signed=signed)


def live(smoke=False):
    get, set_word, fail = (signature(name) for name in ('get()', 'set(uint256)', 'fail()'))
    denied = '0x' + signature('Denied(uint256)') + f'{7:064x}'
    cases, creates, artifacts = [], [], {}
    for name, source, fallback_output in fixtures()[:1] if smoke else fixtures():
        path, output, runtime = emitted(name, source)
        abi(name, output)
        artifacts[name] = {file: hashlib.sha256((output / file).read_bytes()).hexdigest() for file in FILES}
        rows = [('empty', '', 0, 'revert', fallback_output, BEFORE),
                ('unknown', 'ffffffff', 0, 'revert', fallback_output, BEFORE),
                ('short-known', set_word + '00' * 31, 0, 'revert', '0x', BEFORE),
                ('value-unknown', 'ffffffff', 1, 'revert', '0x', BEFORE)]
        if not smoke:
            rows += [('one-byte', get[:2], 0, 'revert', fallback_output, BEFORE),
                     ('two-byte', get[:4], 0, 'revert', fallback_output, BEFORE),
                     ('three-byte', get[:6], 0, 'revert', fallback_output, BEFORE),
                     ('zero-selector', '00000000', 0, 'revert', fallback_output, BEFORE),
                     ('unknown-tail', 'ffffffff' + set_word + '00' * 32, 0, 'revert', fallback_output, BEFORE),
                     ('value-empty', '', 1, 'revert', '0x', BEFORE),
                     ('value-known', get, 1, 'revert', '0x', BEFORE),
                     ('get', get, 0, 'success', f'0x{7:064x}', BEFORE),
                     ('get-tail', get + 'ff', 0, 'success', f'0x{7:064x}', BEFORE),
                     ('missing-arg', set_word, 0, 'revert', '0x', BEFORE),
                     ('set-zero', set_word + '00' * 32, 0, 'success', f'0x{0:064x}', {'8': '0xb'}),
                     ('set-max', set_word + f'{MAX:064x}', 0, 'success', f'0x{MAX:064x}', {'0': hex(MAX), '8': '0xb'}),
                     ('set-tail', set_word + f'{12:064x}' + 'abcd', 0, 'success', f'0x{12:064x}', {'0': '0xc', '8': '0xb'}),
                     ('entry-rollback', fail, 0, 'revert', denied, BEFORE)]
        for label, data, value, status, result, after in rows:
            want = dict(status=status, output=result, storage=after)
            cases.append(compare(name + '-' + label, path, runtime, data, value, want, signed=not smoke))
        if not smoke:
            init = (output / 'init.hex').read_text().strip()
            for value in (0, 1):
                key = name + '-create-' + str(value)
                _, actual = C.evm_run(key, init, '', C.SENDER, value=value, create=True)
                require(actual['status'] == ('revert' if value else 'success'), 'FALLBACK-CREATE status ' + key)
                require(actual['output'] == ('' if value else runtime), 'FALLBACK-CREATE runtime ' + key)
                require(list(actual['storage'].values()) == ([] if value else [{'0': '0x7'}]),
                        'FALLBACK-CREATE storage ' + key)
                creates.append(dict(name=key, result=actual))
    if not smoke:
        for file in ('runtime.hex', 'init.hex', 'layout.json', 'axioms.txt'):
            require(artifacts['empty'][file] == artifacts['omitted'][file], 'FALLBACK-EMPTY bytes ' + file)
    C.save('SMOKE' if smoke else 'LIVE', dict(cases=cases, creates=creates, artifacts=artifacts))
    return len(cases), sum(row['signed'] for row in cases), len(creates)


def refused(name, source, diagnostic, *, checked=False):
    path = WORK / ('refused-' + name + '.asy')
    path.write_text(source)
    output = WORK / ('refused-' + name)
    if output.exists():
        shutil.rmtree(output)
    records = []
    for command in ('check', 'emit', 'run'):
        argv = [C.BINARY, command, path] + (['-o', output] if command == 'emit' else [])
        result = C.capture('refusal-' + name + '-' + command, argv)
        expected_exit = (0 if command == 'check' else 2) if checked else 1
        require(result.returncode == expected_exit and
                ((checked and command == 'check') or diagnostic in result.stdout + result.stderr),
                'FALLBACK-REFUSAL ' + name + ' ' + command + ': ' + result.stdout + result.stderr)
        records.append(dict(command=command, exit=result.returncode, stdout=result.stdout, stderr=result.stderr))
    require(not output.exists(), 'FALLBACK-REFUSAL output ' + name)
    return dict(name=name, diagnostic=diagnostic, records=records)


def refusals():
    source = example()
    rows = [('duplicate', source + FALLBACK + '\n', 'SURFACE_DUPLICATE: duplicate fallback'),
            ('wrong-type', source.replace('Eff Sig Never', 'Eff Sig Word'), 'SURFACE_SYNTAX:'),
            ('missing-type', source.replace(' : Eff Sig Never', ''), 'SURFACE_SYNTAX:'),
            ('return', source.replace(FALLBACK, 'fallback : Eff Sig Never := pure (word 0)'), 'SURFACE_SYNTAX:'),
            ('do', source.replace(FALLBACK, 'fallback : Eff Sig Never := do revert'), 'SURFACE_SYNTAX:'),
            ('write', source.replace(FALLBACK, 'fallback : Eff Sig Never := sstore cell (word 1) ; revert'), 'SURFACE_SYNTAX:'),
            ('unknown-error', source.replace(FALLBACK, FALLBACK.replace('MalformedCalldata', 'Missing')), 'SURFACE_ERROR: unknown error Missing'),
            ('missing-arg', source.replace(FALLBACK, 'fallback : Eff Sig Never := revert Denied'), 'SURFACE_ERROR: wrong error argument count'),
            ('extra-arg', source.replace(FALLBACK, FALLBACK + ' (word 1)'), 'SURFACE_ERROR: wrong error argument count'),
            ('entry-scope', source.replace(FALLBACK, 'fallback : Eff Sig Never := revert Denied (amount)'), 'SURFACE_SCOPE: unbound word amount'),
            ('field-scope', source.replace(FALLBACK, 'fallback : Eff Sig Never := revert Denied (cell)'), 'SURFACE_SCOPE: unbound word cell'),
            ('large-word', source.replace(FALLBACK, 'fallback : Eff Sig Never := revert Denied (word ' + str(2**256) + ')'), 'SURFACE_WORD:'),
            ('negative', source.replace(FALLBACK, 'fallback : Eff Sig Never := revert Denied (word -1)'), 'SURFACE_TOKEN:'),
            ('trailing-step', source.replace(FALLBACK, FALLBACK + ' ; pure (word 0)'), 'SURFACE_DECLARATION:'),
            ('reserved-name', source.replace('entry get ()', 'entry fallback ()'), 'SURFACE_NAME:'),
            ('reserved-never', source.replace('entry get ()', 'entry Never ()'), 'SURFACE_NAME:')]
    records = [refused(*row) for row in rows]
    C.save('REFUSALS', records)
    return len(records)


def core(refuse_only=False):
    source = C.fixture(errors=True, proofs=True)
    records = []
    expressions = [('return', 'done (word 256 0)'),
                   ('write', 'store storage.0 (word 256 1) abort'),
                   ('load', 'load storage.0 (fun (x : Word 256) => abort)'),
                   ('caller', 'caller (fun (x : Word 256) => abort)'),
                   ('compare', 'le (word 256 0) (word 256 1) abort abort'),
                   ('arithmetic', 'add (word 256 0) (word 256 1) (fun (r : ResultWord) => abort)'),
                   ('proved', 'addLt (word 256 0) (word 256 1) () (fun (x : Word 256) => abort)')]
    for name, term in expressions:
        records.append(refused('core-' + name, source + '\ndef fallback : Tx := ' + term + '\n',
                               'M1_EMIT: fallback must be a closed revert', checked=True))
    C.save('CORE-REFUSALS', records)
    cases = []
    if not refuse_only:
        for proofs in (False, True):
            for errors in (False, True):
                for deployer in (False, True):
                    name = f'core-{int(proofs)}-{int(errors)}-{int(deployer)}'
                    term = 'reject (inj 0 of 1 (tuple ()) : Error)' if errors else 'abort'
                    text = C.fixture(errors=errors, proofs=proofs, deployer=deployer) + '\ndef fallback : Tx := ' + term + '\n'
                    path, output, runtime = emitted(name, text)
                    require(json.loads((output / 'abi.json').read_text())[-1] ==
                            dict(type='fallback', stateMutability='nonpayable'), 'FALLBACK-CORE ABI ' + name)
                    want = dict(status='revert', output='0x' + (signature('Denied()') if errors else ''), storage=BEFORE)
                    cases.append(compare(name, path, runtime, 'ffffffff', 0, want))
        C.save('CORE-LIVE', cases)
    return len(records), len(cases), sum(row['signed'] for row in cases)


def boundaries():
    fields = ' '.join(f'(v{i} : Word)' for i in range(32))
    values = ' '.join(f'(word {MAX if i % 2 else i})' for i in range(32))
    source = example().replace('error MalformedCalldata ()', 'error MalformedCalldata ' + fields)
    source = source.replace(FALLBACK, FALLBACK + ' ' + values)
    path, _, runtime = emitted('payload-32', source)
    payload = signature('MalformedCalldata(' + ','.join(['uint256'] * 32) + ')')
    payload += ''.join(f'{MAX if i % 2 else i:064x}' for i in range(32))
    want = dict(status='revert', output='0x' + payload, storage=BEFORE)
    good = compare('payload-32', path, runtime, '', 0, want)
    bad = refused('payload-33', source.replace(fields, fields + ' (v32 : Word)'), 'SURFACE_LIMIT:')
    rows = [good, bad]
    C.save('BOUNDARIES', rows)
    return len(rows), 1, int(good['signed'])


def mutants():
    rows = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-fallback-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, file, before, after, witness, marker in rows:
            path = copy / file
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'FALLBACK-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'FALLBACK-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/fallback-test.py', witness], cwd=copy, timeout=120)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'FALLBACK-MUTANT witness ' + label + ': ' + result.stdout + result.stderr)
                records.append(dict(name=name, mutated=mutated, exit=result.returncode, marker=marker))
            print('FALLBACK-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(rows)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    modes = dict(smoke=lambda: live(smoke=True), refusals=refusals, core=core,
                 boundaries=boundaries, mutants=mutants)
    modes['core-refusals'] = lambda: core(refuse_only=True)
    if len(sys.argv) == 2 and sys.argv[1] in modes:
        modes[sys.argv[1]]()
        return 0
    require(not sys.argv[1:], 'usage: fallback-test.py [smoke|refusals|core|core-refusals|boundaries|mutants]')
    cases, signed, creates = live()
    rejected = refusals()
    core_rejected, core_cases, core_signed = core()
    bounds, boundary_cases, boundary_signed = boundaries()
    killed = mutants()
    print(f'FALLBACK cases={cases + core_cases + boundary_cases} signed={signed + core_signed + boundary_signed} creates={creates} '
          f'refusals={rejected + core_rejected} boundaries={bounds} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, RuntimeError, subprocess.SubprocessError) as error:
        print('FALLBACK FAIL: ' + str(error), flush=True)
        sys.exit(1)

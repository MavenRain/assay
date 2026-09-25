#!/usr/bin/env python3
"""Exercise contract sugar through the public driver and the frozen EVM oracle."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/contract'
BINARY = ROOT / '_build/bin/assay'
spec = importlib.util.spec_from_file_location('contract_model', ROOT / 'dev/model-test.py')
M = importlib.util.module_from_spec(spec)
spec.loader.exec_module(M)
P, C, D, require = M.P, M.C, M.D, M.require
SOURCE = ROOT / 'examples/CounterSurface.asy'


def program(body, *, fields='cell : Word', args='(a : Word) (b : Word)', name='mix'):
    return (f'contract Surface where storage State := {{ {fields} }}\n'
            f'entry {name} {args} : Eff Sig Word := do {body}\n')


def variants():
    selector = 'b4bb58fb'
    data = selector + f'{5:064x}{2:064x}'
    arithmetic = program('old <- sload cell ; sstore cell (word 9) ; '
                         'total <- add old a ; value <- sub total b ; pure value')
    return [
        ('two-args', arithmetic, P.row('two-args', data, 10)),
        ('overflow', arithmetic, P.row('overflow', selector + f'{1:064x}{0:064x}', 0,
                                      before=hex(2**256 - 1), after=hex(2**256 - 1), status='revert')),
        ('underflow', arithmetic, P.row('underflow', selector + f'{0:064x}{8:064x}', 0,
                                       after='0x7', status='revert')),
        ('trailing', arithmetic, P.row('trailing', data + 'deadbeef', 10)),
        ('short', arithmetic, P.row('short', data[:-2], 0, after='0x7', status='revert')),
        ('snapshot', program('old <- sload cell ; sstore cell (word 9) ; '
                             'now <- sload cell ; value <- add old now ; pure value'),
         P.row('snapshot', data, 16)),
        ('revert', program('sstore cell (word 9) ; revert'),
         P.row('revert', data, 0, after='0x7', status='revert')),
        ('shadow', program('let a : Word := a ; let a : Word := b ; pure a'),
         P.row('shadow', data, 2, after='0x7')),
        ('hygiene', program('let args : Word := a ; let result : Word := b ; '
                            'value <- sub args result ; pure value'),
         P.row('hygiene', data, 3, after='0x7')),
        ('maximum', program(f'pure (word {2**256 - 1})'),
         P.row('maximum', data, 2**256 - 1, after='0x7')),
        ('shared-alias', program('pure cell', args='(cell : Word) (b : Word)'),
         P.row('shared-alias', data, 5, after='0x7')),
        ('clear', program('sstore cell (word 0) ; pure a'),
         P.row('clear', data, 5, after='0x0')),
        # Review round 2026-09-13 (B-5):  an sload binding shadows the argument
        # of the same name, so the SHADOW-LOAD mutation has a live witness.
        ('shadow-load', program('a <- sload cell ; pure a'),
         P.row('shadow-load', data, 7, after='0x7')),
    ]


def live():
    reference = ROOT / 'reference/counter'
    manifest = json.loads((reference / 'MANIFEST.json').read_text())
    for name, digest in manifest['files'].items():
        require(hashlib.sha256((reference / name).read_bytes()).hexdigest() == digest,
                'SURFACE-REFERENCE-HASH ' + name)
    reference_runtime = (reference / 'runtime.hex').read_text().strip()
    require(P.checked('selector', ['cast', 'sig', 'mix(uint256,uint256)']).strip() == '0xb4bb58fb',
            'SURFACE-SELECTOR')
    with tempfile.TemporaryDirectory(prefix='assay-contract-') as temporary:
        folder = Path(temporary)
        output, core = folder / 'surface', folder / 'core'
        runtime, init = P.emit(SOURCE, output, 'counter-emit')
        P.emit(ROOT / 'examples/Counter.asy', core, 'core-emit')
        require({path.name: path.read_bytes() for path in output.iterdir()} ==
                {path.name: path.read_bytes() for path in core.iterdir()}, 'SURFACE-CORE-FIVE-FILES')
        (WORK / 'OUTPUTS.json').write_text(json.dumps({path.name: hashlib.sha256(path.read_bytes()).hexdigest()
            for path in sorted(output.iterdir())}, indent=2) + '\n')
        rows = P.listing('runtime', runtime)
        prefix = init[:-len(runtime)]
        creates = C.creation(runtime, prefix, P.listing('prefix', prefix))
        covered = set()
        declared = {pc: opcode for pc, opcode, _immediate in rows}
        for row in M.counter_cases():
            M.model('counter-' + row['name'], SOURCE, row)
            ours, evidence = P.execute('compiled-' + row['name'], runtime, row)
            other, _evidence = P.execute('reference-' + row['name'], reference_runtime, row)
            require(all(ours[key] == other[key] for key in ('status', 'output', 'storage')),
                    'SURFACE-DIFF ' + row['name'])
            steps = D.objects(evidence['run'])[:-2]
            require(all(declared.get(step['pc']) == step['opName'] for step in steps), 'SURFACE-PC')
            covered.update(step['pc'] for step in steps)
        require(covered == set(declared), 'SURFACE-COVERAGE')
        for name, source, row in variants():
            path = folder / (name + '.asy')
            path.write_text(source)
            M.agreement(name, path, row, folder)
        # Declaration order determines slots, entry order and ABI argument order.
        reorder = SOURCE.read_text().replace('count : Word ; limit : Word', 'limit : Word ; count : Word')
        path = folder / 'renamed.asy'
        path.write_text(reorder)
        renamed = folder / 'renamed-output'
        P.emit(path, renamed, 'renamed-emit')
        layout = json.loads((renamed / 'layout.json').read_text())
        require([(row['label'], row['slot'], row['contract']) for row in layout['storage']] ==
                [('limit', '0', 'Counter'), ('count', '1', 'Counter')], 'SURFACE-LAYOUT')
        row = dict(name='reordered', calldata='6d4ce63c', value=0, before={'0': '0x64', '1': '0x7'},
                   after={'0': '0x64', '1': '0x7'}, status='success', output='0x' + f'{7:064x}')
        M.agreement('reordered', path, row, folder)
    print(f'SURFACE-LIVE counter={len(M.counter_cases())} variants={len(variants()) + 1} '
          f'creates={creates} covered={len(covered)} five_files=5 executors=2 OK', flush=True)
    return len(M.counter_cases()), len(variants()) + 1


def refusals():
    simple = program('pure a')
    counter = SOURCE.read_text()
    return [
        ('word-range', program(f'pure (word {2**256})'), 'SURFACE_WORD'),
        ('negative', program('pure (word -1)'), 'SURFACE_TOKEN'),
        ('bad-number', program('pure (word 123abc)'), 'SURFACE_WORD'),
        ('word-width', simple.replace('cell : Word', 'cell : Word 128'), 'SURFACE_SYNTAX'),
        ('field-duplicate', program('pure a', fields='cell : Word ; cell : Word'), 'SURFACE_DUPLICATE'),
        ('arg-duplicate', program('pure a', args='(a : Word) (a : Word)'), 'SURFACE_DUPLICATE'),
        ('entry-duplicate', counter + 'entry get () : Eff Sig Word := do pure (word 0)', 'SURFACE_DUPLICATE'),
        ('state-conflict', simple.replace('State', 'cell'), 'SURFACE_DUPLICATE'),
        ('entry-conflict', program('pure a', name='cell'), 'SURFACE_DUPLICATE'),
        ('reserved', program('pure a', fields='Tx : Word'), 'SURFACE_NAME'),
        ('generated-name', program('let _assay_v0 : Word := a ; pure a'), 'SURFACE_NAME'),
        ('unknown-word', program('pure missing'), 'SURFACE_SCOPE'),
        ('forward-local', program('let x : Word := y ; let y : Word := a ; pure x'), 'SURFACE_SCOPE'),
        ('unknown-slot', program('x <- sload missing ; pure x'), 'SURFACE_SLOT'),
        ('unknown-store', program('sstore missing a ; pure a'), 'SURFACE_SLOT'),
        ('unit-return', program('pure ()'), 'SURFACE_RETURN'),
        ('unknown-effect', program('x <- multiply a b ; pure x'), 'SURFACE_EFFECT'),
        ('missing-separator', program('sstore cell a pure a'), 'SURFACE_SYNTAX'),
        ('unknown-declaration', simple + 'axiom Forged : Prop', 'SURFACE_DECLARATION'),
        ('second-contract', simple + simple, 'SURFACE_DECLARATION'),
        ('proof-guard', program('(0 p : Prop) <- guard Proof ; pure a'), 'SURFACE_PROOF'),
        ('empty-storage', program('pure a', fields=''), 'SURFACE_NAME'),
        ('no-entry', 'contract Empty where storage State := { cell : Word }', 'SURFACE_ENTRY'),
        ('constructor-result', simple + 'constructor := do pure (word 0)', 'SURFACE_CONSTRUCTOR'),
        ('constructor-revert', simple + 'constructor := do revert', 'SURFACE_CONSTRUCTOR'),
        ('constructor-guard', simple + 'constructor := do guard le (word 0) (word 1) ; pure ()', 'SURFACE_CONSTRUCTOR'),
        ('constructor-load', simple + 'constructor := do x <- sload cell ; pure ()', 'SURFACE_CONSTRUCTOR'),
        ('constructor-variable', simple + 'constructor := do sstore cell a ; pure ()', 'SURFACE_CONSTRUCTOR'),
        ('constructor-duplicate', counter + 'constructor := do pure ()', 'SURFACE_DUPLICATE'),
        ('fields-limit', program('pure a', fields=' ; '.join(f'f{i} : Word' for i in range(33))), 'SURFACE_LIMIT'),
        ('args-limit', program('pure a0', args=' '.join(f'(a{i} : Word)' for i in range(33))), 'SURFACE_LIMIT'),
        ('entries-limit', 'contract Many where storage State := { cell : Word }\n' +
         '\n'.join(f'entry f{i} () : Eff Sig Word := do pure (word 0)' for i in range(33)), 'SURFACE_LIMIT'),
        ('steps-limit', program('let x : Word := a ; ' * 129 + 'pure x'), 'SURFACE_LIMIT'),
        ('nesting-limit', program('pure ' + '(' * 129 + 'a' + ')' * 129), 'SURFACE_LIMIT'),
        ('tokens-limit', simple + ' x' * 8193, 'SURFACE_LIMIT'),
        ('bytes-limit', simple + '--' + 'x' * 65536, 'SURFACE_LIMIT'),
    ]


# A refusal that carries the offending token reports that token, not the sentinel line 1, column 1.
POSITIONS = {'constructor-result': 'line 3, column 30:',
             'constructor-revert': 'line 3, column 19:',
             'constructor-guard': 'line 3, column 34:'}


def refusal(name, source, marker, folder, expected=None):
    path = folder / (name + '.asy')
    path.write_text(source)
    prefix = expected or POSITIONS.get(name) or 'line '
    for command in ('check', 'emit', 'run'):
        output = folder / (name + '-out')
        args = ['-o', output] if command == 'emit' else []
        result = M.capture('invalid-' + name + '-' + command, [BINARY, command, path, *args])
        require(result.returncode == 1 and marker + ':' in result.stderr and not result.stdout and
                result.stderr.startswith(prefix) and not output.exists(), 'SURFACE-REFUSAL ' + name)


def driver():
    with tempfile.TemporaryDirectory(prefix='assay-contract-driver-') as temporary:
        folder = Path(temporary)
        for name, source, marker in refusals():
            refusal(name, source, marker, folder)
        for mode in ([], ['--print'], ['--erased']):
            result = M.capture('check-' + str(len(mode)) + ''.join(mode), [BINARY, 'check', *mode, SOURCE])
            require(result.returncode == 0 and not result.stderr, 'SURFACE-CHECK')
            require(bool(result.stdout) == bool(mode), 'SURFACE-CHECK-OUTPUT')
            if mode == ['--print']:
                require('EvmOpcodes' in result.stdout and 'Lan SMu Tx' in result.stdout, 'SURFACE-CHECKED-CORE')
        require(P.checked('axioms', [BINARY, 'axioms', SOURCE]) == 'EvmOpcodes\n', 'SURFACE-AXIOMS')
        row = next(row for row in M.counter_cases() if row['name'] == 'get-nonzero')
        M.model('no-tools', SOURCE, row, cwd=folder, env=dict(os.environ, PATH=str(folder)))
        # Leading comments and whitespace route to the sugar lexer on both suffixes.
        source = folder / 'source.kan'
        source.write_text('\n -- contract Wrong where\n\t' + SOURCE.read_text())
        M.model('comments', source, row)
        limits = [
            program('pure (word 0)', args='()'),
            program('pure a31', fields=' ; '.join(f'f{i} : Word' for i in range(32)),
                    args=' '.join(f'(a{i} : Word)' for i in range(32))),
            'contract Many where storage State := { cell : Word }\n' +
            '\n'.join(f'entry f{i} (a : Word) : Eff Sig Word := do pure a' for i in range(32)),
            program('let x : Word := a ; ' * 128 + 'pure x'),
            program('pure ' + '(' * 128 + 'a' + ')' * 128),
        ]
        for index, source in enumerate(limits):
            path = folder / (f'limit-{index}.asy')
            path.write_text(source)
            P.emit(path, folder / f'limit-{index}-out', f'limit-{index}')
    print(f'SURFACE-DRIVER refusals={len(refusals())} commands=3 bounds={len(limits)} no_tools=true OK', flush=True)
    return len(refusals())


def witness(name):
    for row in M.counter_cases():
        if name == row['name']:
            M.model(name, SOURCE, row)
            return
    with tempfile.TemporaryDirectory(prefix='assay-contract-witness-') as temporary:
        folder = Path(temporary)
        for label, source, row in variants():
            if label == name:
                path = folder / 'Witness.asy'
                path.write_text(source)
                M.model(name, path, row)
                return
        for label, source, marker in refusals():
            if label == name:
                refusal(name, source, marker, folder)
                return
    require(False, 'SURFACE-WITNESS unknown ' + name)


def mutants():
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-contract-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        for name, before, after, example in cases:
            path = copy / ('src/emitter.bend' if name == 'LITERAL' else 'src/emitter.bend')
            original = path.read_text()
            require(native_mutations.count(original, before) == 1, 'SURFACE-MUTANT-ANCHOR ' + name)
            path.write_text(native_mutations.replace(original, before, after))
            build = M.capture('mutant-' + name + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
            require(build.returncode == 0, 'SURFACE-MUTANT-BUILD ' + name)
            result = M.capture('mutant-' + name, ['python3', '-P', 'dev/contract-test.py', 'witness', example], cwd=copy)
            marker = 'SURFACE-REFUSAL ' if name == 'LITERAL' else 'MODEL-EXPECTED '
            require(result.returncode == 1 and marker + example in result.stdout, 'SURFACE-MUTANT-WITNESS ' + name)
            path.write_text(original)
            build = M.capture('control-' + name + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
            require(build.returncode == 0, 'SURFACE-CONTROL-BUILD ' + name)
            result = M.capture('control-' + name, ['python3', '-P', 'dev/contract-test.py', 'witness', example], cwd=copy)
            require(result.returncode == 0 and not result.stderr, 'SURFACE-CONTROL ' + name)
            print(f'SURFACE-MUTANT {name} witness={example} killed control=OK', flush=True)
    print(f'SURFACE-MUTANTS killed={len(cases)}/{len(cases)} controls={len(cases)} OK', flush=True)
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    M.WORK = P.WORK = C.WORK = WORK
    if sys.argv[1:2] == ['witness'] and len(sys.argv) == 3:
        witness(sys.argv[2])
        return
    if sys.argv[1:] in (['driver'], ['live'], ['mutants']):
        {'driver': driver, 'live': live, 'mutants': mutants}[sys.argv[1]]()
        return
    require(not sys.argv[1:], 'SURFACE-USAGE')
    counter, extra = live()
    invalid = driver()
    killed = mutants()
    print(f'CONTRACT-SURFACE counter={counter} variants={extra} refusals={invalid} mutants={killed} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, StopIteration, subprocess.SubprocessError) as error:
        print('CONTRACT-SURFACE FAIL: ' + str(error))
        sys.exit(1)

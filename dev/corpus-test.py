#!/usr/bin/env python3
"""Frozen M0 execution, proof erasure, and Stage F rejection witnesses."""
from pathlib import Path
import copy
import importlib.util
import json
import shutil
import subprocess
import sys
import tempfile


def module(root, name):
    spec = importlib.util.spec_from_file_location(name.replace('-', '_'), root / 'dev' / name)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def corpus(root):
    data = module(root, 'corpus-data.py')
    emission = module(root, 'emit-test.py')
    ref = module(root, 'reference-test.py')
    frozen = data.manifest(root)
    measures = []
    with tempfile.TemporaryDirectory(prefix='assay-corpus-') as temporary:
        for row in frozen['cases']:
            directory = Path(temporary) / Path(row['path']).stem
            files = emission.emit(root, root / row['path'], directory)
            data.outputs(directory, row)
            runtime, init = files['runtime.hex'].strip(), files['init.hex'].strip()
            records = ref.execute(root, 'corpus-' + directory.name, runtime)
            steps, summary, state = ref.success(records, 'CORPUS-EXEC')
            data.require(summary['output'] == f'{int(row["answer"]):064x}', 'CORPUS-RETURN ' + row['path'])
            accounts = {key.lower(): value for key, value in state['accounts'].items()}
            data.require(set(accounts) == {ref.RECEIVER}, 'CORPUS-ACCOUNTS')
            account = accounts[ref.RECEIVER]
            slots = {str(int(key, 16)): str(int(value, 16)) for key, value in account.get('storage', {}).items()}
            data.require(slots == row['storage'] and account['code'] == '0x' + runtime, 'CORPUS-STORAGE ' + row['path'])
            declared = ref.listing(ref.run(root, 'corpus-listing-' + directory.name,
                str(root / ref.ARTIFACT), 'listing', runtime))
            cast = ref.listing(ref.run(root, 'corpus-cast-' + directory.name, 'cast', 'disassemble', '0x' + runtime))
            data.require(cast == declared, 'CORPUS-LISTING ' + row['path'])
            known = {pc: name for pc, name, _immediate in declared}
            data.require(all(step['opName'] == known.get(step['pc']) and
                             step['op'] == int(runtime[2*step['pc']:2*step['pc']+2], 16) for step in steps),
                         'CORPUS-PC ' + row['path'])
            _steps, creation, installed = ref.success(ref.execute(root, 'corpus-create-' + directory.name, init, create=True), 'CORPUS-CREATE')
            data.require(creation['output'] == runtime, 'CORPUS-CREATE-BYTES ' + row['path'])
            contracts = [value for address, value in installed['accounts'].items() if address.lower() != ref.SENDER]
            data.require(len(contracts) == 1 and contracts[0]['code'] == '0x' + runtime, 'CORPUS-INSTALLED ' + row['path'])
            measure = dict(path=row['path'], group=row['group'], runtime_bytes=len(runtime)//2,
                           init_bytes=len(init)//2, gas=int(summary['gasUsed'], 16),
                           creation_gas=int(creation['gasUsed'], 16), steps=len(steps), listing=len(declared))
            measures.append(measure)
            print('CORPUS-MEASURE ' + json.dumps(measure, sort_keys=True))
    (root / '.gatework/corpus-measures.json').write_text(json.dumps(measures, indent=2) + '\n')
    # Review round 2026-09-11 (D-1):  the printed five_files field reports a
    # module constant, so the count is required against the five names here.
    data.require(data.FILES == {'runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt'},
                 'CORPUS-FIVE-FILES')
    print(f'CORPUS cases={len(measures)} five_files={len(data.FILES)} OK')


def erased(root):
    data = module(root, 'corpus-data.py')
    emission = module(root, 'emit-test.py')
    frozen = data.manifest(root)
    rows = [row for row in frozen['cases'] if row['group'] == 'proofs']
    data.require(len(rows) == 3, 'ERASED-SEED-COUNT')
    binaries = []
    forms = []
    with tempfile.TemporaryDirectory(prefix='assay-erased-') as temporary:
        work = Path(temporary)
        for row in rows:
            source = root / row['path']
            checked = emission.checked(root, str(root / '_build/default/bin/assay.exe'), 'check', '--print', str(source))
            forms.append(checked)
            files = emission.emit(root, source, work / source.stem)
            data.outputs(work / source.stem, row)
            binaries.append((files['runtime.hex'], files['init.hex']))
        data.require(len(set(forms)) == 3, 'ERASED-SHAPE checked terms did not change')
        data.require(len(set(binaries)) == 1, 'ERASED-BYTES proof shape changed code')
        # A changed runtime payload must break the same byte equality test.
        # The baseline, application and let variants use identical declarations.
        text = (root / rows[0]['path']).read_text()
        changed = text.replace('(word 256 42)', '(word 256 43)')
        data.require(text != changed, 'ERASED-CONTROL-SITE')
        source = work / 'Control.asy'
        source.write_text(changed)
        files = emission.emit(root, source, work / 'control')
        # Review round 2026-09-11 (D-1):  every printed field is now derived
        # from the run.  mutants counts the checked shapes beyond the leaf,
        # equal counts the binary pairs that agree, and caught counts the
        # value controls that the byte equality test rejected.
        caught = [name for name, rejected in
                  [('ERASED-CONTROL', all(got != baseline for got, baseline in zip(
                      (files['runtime.hex'], files['init.hex']), binaries[0])))] if rejected]
        data.require(caught == ['ERASED-CONTROL'], 'ERASED-CONTROL equality accepted changed runtime')
        shapes, agreeing = len(set(forms)) - 1, len(binaries) - len(set(binaries))
    print(f'ERASED-BYTES mutants={shapes} caught={len(caught)} equal={agreeing} scope=M0-seed OK')


def mutations(root):
    data = module(root, 'corpus-data.py')
    emission = module(root, 'emit-test.py')
    ref = module(root, 'reference-test.py')
    ratio = module(root, 'ratio.py')
    # Review round 2026-09-11 (D-1):  the denominator of the printed line is
    # this declared roster, not the list the run happened to build, so a
    # deleted mutation lowers the numerator and fails the gate here.
    expected = ('RUNTIME-BYTE-TRACE', 'RUNTIME-BYTE-CREATE', 'CORPUS-BYTE', 'DENOMINATORS',
                'RATIO-COUNT', 'RATIO-LINES', 'RATIO-MEDIAN')
    killed = []
    controls = 0

    def reject(name, code, callback):
        try:
            callback()
        except ValueError as error:
            data.require(code in str(error), 'F-MUTANT-WITNESS ' + name + ': ' + str(error))
            killed.append(name)
            print(f'F-MUTANT {name} killed witness={code}')
            return
        raise ValueError('F-MUTANT-SURVIVED ' + name)

    frozen = data.manifest(root)
    with tempfile.TemporaryDirectory(prefix='assay-f-mutants-') as temporary:
        work = Path(temporary)
        files = emission.emit(root, root / 'corpus/contracts/Ref20.asy', work / 'out')
        runtime, init = files['runtime.hex'].strip(), files['init.hex'].strip()
        _golden, declared = ref.reference(root)
        prefix, prefix_rows = ref.source(root, 'ref20-init.evm')
        cast = ref.listing(ref.run(root, 'f-control-cast', 'cast', 'disassemble', '0x' + runtime))
        records = ref.execute(root, 'f-control-run', runtime)
        creation = ref.execute(root, 'f-control-create', init, create=True)
        # Mutate the emitted literal, execute it, and require trace validation
        # to reject the changed stack.  Freeze guards are not the witness.
        damaged = '602b' + runtime[4:]
        changed_cast = ref.listing(ref.run(root, 'f-mutant-cast', 'cast', 'disassemble', '0x' + damaged))
        changed_records = ref.execute(root, 'f-mutant-run', damaged)
        reject('RUNTIME-BYTE-TRACE', 'TRACE-STACK', lambda: ref.verify_trace(damaged, changed_cast, changed_records, changed_cast))
        # The intact constructor installs the old bytes, so it must disagree
        # with the damaged runtime artifact even though both executions pass.
        reject('RUNTIME-BYTE-CREATE', 'CREATE-BYTES', lambda: ref.verify_create(damaged, prefix, prefix_rows, creation))
        ref.verify_trace(runtime, declared, records, cast)
        controls += 1
        ref.verify_create(runtime, prefix, prefix_rows, creation)
        controls += 1
        shutil.copytree(root / 'corpus', work / 'corpus')
        (work / 'lib').mkdir()
        for row in frozen['ocaml']:
            shutil.copy2(root / row['path'], work / row['path'])
        source = work / frozen['cases'][0]['path']
        original = source.read_bytes()
        source.write_bytes(original + b'\n')
        reject('CORPUS-BYTE', 'CORPUS-HASH', lambda: data.manifest(work))
        source.write_bytes(original)
        data.manifest(work)
        controls += 1
        (work / 'dev').mkdir()
        shutil.copy2(root / 'dev/denominators.json', work / 'dev/denominators.json')
        # A scoped copy of the real hash row isolates this mutation from every
        # unrelated missing input.  The actual shasum command must fail.
        lines = (root / 'dev/DENOMINATORS.sha256').read_text().splitlines()
        selected = [line for line in lines if line.endswith('  dev/denominators.json')]
        data.require(len(selected) == 1, 'DENOMINATOR-HASH-ROW')
        (work / 'dev/DENOMINATORS.sha256').write_text(selected[0] + '\n')
        emission.checked(work, 'shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256')
        controls += 1
        with (work / 'dev/denominators.json').open('a') as output:
            output.write('\n')
        result = emission.run(work, 'shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256')
        data.require(result.returncode != 0 and 'dev/denominators.json: FAILED' in result.stdout, 'DENOMINATOR-MUTANT-SURVIVED')
        killed.append('DENOMINATORS')
        print('F-MUTANT DENOMINATORS killed witness=sha256')
    original = json.loads((root / 'dev/denominators.json').read_text())
    for name, field, value in [('RATIO-COUNT', 'runs', 4), ('RATIO-LINES', 'lines', 1),
                               ('RATIO-MEDIAN', 'median_ms', 0.0)]:
        damaged = copy.deepcopy(original)
        damaged['rows']['contracts'][field] = value
        reject(name, 'RATIO-SUMMARY', lambda: ratio.validate(damaged, frozen))
    ratio.validate(original, frozen)
    controls += 1
    # A failed timing window must preserve samples without publishing a usable report.
    with tempfile.TemporaryDirectory(prefix='assay-ratio-diagnostics-') as temporary:
        target = Path(temporary) / 'measurement.json'
        retained = []
        for seconds in (60.0, 61.0):
            damaged = copy.deepcopy(original)
            damaged['window']['seconds'] = seconds
            caught = False
            try:
                ratio.save_measurement(target, damaged)
            except ValueError as error:
                caught = 'RATIO-WINDOW' in str(error) and 'ocamlopt=' in str(error) and 'rejected_report=' in str(error)
            data.require(caught and not target.exists(), 'RATIO-DIAGNOSTICS accepted a failed window')
            paths = set(Path(temporary).glob('measurement.json.rejected-*.json')) - set(retained)
            data.require(len(paths) == 1, 'RATIO-DIAGNOSTICS missing capture')
            path = next(iter(paths))
            saved = json.loads(path.read_text())
            data.require(saved == dict(damaged, rejection='RATIO-WINDOW', window_limit_seconds=60),
                         'RATIO-DIAGNOSTICS lost samples')
            retained.append(path)
        # Review round 2026-09-12 (C-1):  a rejected capture stays unusable after an
        # edit that puts its window seconds back under the limit.
        repaired = json.loads(retained[-1].read_text())
        repaired['window']['seconds'] = 30.0
        refused = False
        try:
            ratio.validate(repaired, frozen)
        except ValueError as error:
            refused = 'RATIO-REJECTED' in str(error)
        data.require(refused, 'RATIO-DIAGNOSTICS accepted a rejected report')
        prior = [path.read_bytes() for path in retained]
        ratio.save_measurement(target, original)
        data.require(json.loads(target.read_text()) == original and
                     [path.read_bytes() for path in retained] == prior, 'RATIO-DIAGNOSTICS control')
    print('RATIO-DIAGNOSTICS rejected=2 retained=2 repaired=1 control=1 limit=60 OK')
    data.require(tuple(killed) == expected, 'F-MUTANT-ROSTER ' + str(killed))
    data.require(controls == 5, 'F-MUTANT-CONTROLS ' + str(controls))
    print(f'F-MUTANTS killed={len(killed)}/{len(expected)} controls={controls} OK')


def main():
    root = Path(__file__).resolve().parent.parent
    modes = {'corpus': corpus, 'erased': erased, 'mutants': mutations}
    if len(sys.argv) != 2 or sys.argv[1] not in modes:
        print('usage: corpus-test.py corpus|erased|mutants')
        return 64
    modes[sys.argv[1]](root)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('CORPUS-GATE FAIL ' + str(error))
        sys.exit(1)

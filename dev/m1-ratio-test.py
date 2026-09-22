#!/usr/bin/env python3
"""Exercise the public frozen M1 performance gate without running a timing window."""
from pathlib import Path
import copy
import importlib.util
import json
import shutil
import subprocess
import sys
import tempfile


def load(path):
    spec = importlib.util.spec_from_file_location(path.stem, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def main():
    root = Path(__file__).resolve().parent.parent
    ratio = load(root / 'dev/ratio.py')
    data = ratio.module(root)
    frozen = data.manifest(root)
    sources = ratio.compiler_sources(root)
    baseline = json.loads((root / 'dev/denominators.json').read_text())
    data.require(set(sources) == set(baseline['compiler_sources_sha256']),
                 'M1-RATIO-TEST inventory scope: the walk must match the frozen report')
    # Synthetic timing values test the decision boundary, never performance.
    baseline.update(stage='M1', compiler_sources_sha256=sources,
                    corpus_sha256=data.digest(root / 'corpus/MANIFEST.json'),
                    measurement_sha256=data.digest(root / 'dev/ratio.py'))
    baseline.pop('rejection', None)
    baseline.pop('window_limit_seconds', None)
    baseline['window']['seconds'] = 30.0
    controls = refusals = mutants = 0

    def boundary(multiplier):
        value = copy.deepcopy(baseline)
        for name, selected, scale in (
                ('contracts', [r for r in frozen['cases'] if r['group'] == 'contracts'], multiplier),
                ('ocamlopt', frozen['ocaml'], 1.0)):
            lines = sum(row['lines'] for row in selected)
            sample = lines * scale
            value['rows'][name] = dict(samples_ms=[sample] * 5, median_ms=sample,
                                      min_ms=sample, max_ms=sample, runs=5, lines=lines,
                                      invocations=len(selected) if name == 'contracts' else 1,
                                      ms_per_kloc=sample * 1000 / lines)
            for command in value['commands']:
                if command['workload'] == name:
                    command['elapsed_ms'] = sample
        return value

    with tempfile.TemporaryDirectory(prefix='assay-m1-ratio-test-') as temporary:
        work = Path(temporary)
        paths = set(sources) | {'dev/ratio.py', 'dev/corpus-data.py', 'corpus/MANIFEST.json'}
        paths.update(row['path'] for row in frozen['cases'] + frozen['ocaml'])
        for name in sorted(paths):
            target = work / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(root / name, target)
        program = work / 'dev/ratio.py'
        original_program = program.read_text()

        def freeze(value):
            (work / 'dev/denominators.json').write_text(json.dumps(value, indent=2) + '\n')
            protected = ('dev/denominators.json', 'dev/ratio.py', 'dev/corpus-data.py')
            (work / 'dev/DENOMINATORS.sha256').write_text(''.join(
                f'{data.digest(work / name)}  {name}\n' for name in protected))

        def invoke(value, marker, success=False, mode='--m1', sealed=True, control=True):
            nonlocal controls, refusals
            if sealed:
                freeze(value)
            command = [sys.executable, '-B', '-P', str(program)] + ([mode] if mode else [])
            result = subprocess.run(command, capture_output=True, text=True, timeout=10)
            output = result.stdout + result.stderr
            data.require((result.returncode == 0) == success and marker in output,
                         f'M1-RATIO-TEST expected {marker}: rc={result.returncode} {output}')
            if not success:
                if mode == '--m1':
                    data.require(output.startswith('M1-RATIO FAIL '), 'M1-RATIO-TEST failure milestone')
                data.require('subtraction=none OK' not in output, 'M1-RATIO-TEST false success marker')
                refusals += 1
            elif control:
                controls += 1

        for multiplier in (0.5, 1.0):
            invoke(boundary(multiplier), 'informational=false limit=1.0', success=True)
        over = boundary(1.00000001)
        invoke(over, 'RATIO-BOUND')
        invoke(over, 'informational=true', success=True, mode='')
        legacy = boundary(0.5)
        legacy['stage'] = 'M0 Stage F'
        invoke(legacy, 'RATIO-MILESTONE')
        invoke(legacy, 'M0-RATIO provenance=', success=True, mode='')

        for key, marker in (('measurement_sha256', 'RATIO-METHOD'),
                            ('corpus_sha256', 'RATIO-CORPUS')):
            value = boundary(0.5)
            value[key] = '0' * 64
            invoke(value, marker)
        stale = boundary(0.5)
        stale['compiler_sources_sha256'] = {}
        invoke(stale, 'RATIO-SOURCES')
        missing = boundary(0.5)
        del missing['compiler_sources_sha256']
        invoke(missing, 'RATIO-SOURCES')
        added = work / 'bin/m1_ratio_probe.ml'
        added.write_text('(* Source inventory mutation. *)\n')
        invoke(boundary(0.5), 'RATIO-SOURCES')
        added.unlink()
        changed = work / 'bin/assay.ml'
        original_source = changed.read_bytes()
        changed.write_bytes(original_source + b'\n(* Source identity mutation. *)\n')
        invoke(boundary(0.5), 'RATIO-SOURCES')
        changed.write_bytes(original_source)
        for seconds in (0, 60, 61):
            value = boundary(0.5)
            value['window']['seconds'] = seconds
            invoke(value, 'RATIO-WINDOW')
        value = boundary(0.5)
        value['rejection'] = 'RATIO-WINDOW'
        invoke(value, 'RATIO-REJECTED')
        value = boundary(0.5)
        value['rows']['contracts']['ms_per_kloc'] = 0
        invoke(value, 'RATIO-SUMMARY')
        value = boundary(0.5)
        value['commands'][0]['elapsed_ms'] = 0
        invoke(value, 'RATIO-TIMING')
        value = boundary(0.5)
        freeze(value)
        with (work / 'dev/denominators.json').open('a') as output:
            output.write(' ')
        invoke(value, 'dev/denominators.json: FAILED', sealed=False)

        # Each weakened program admits a report that the restored driver refuses.
        changes = (
            ('dispatch', "        require_m1(root, value)", "        pass", over),
            ('bound', "rows['contracts']['ms_per_kloc'] <= rows['ocamlopt']['ms_per_kloc']", "True", over),
            ('sources', "value.get('compiler_sources_sha256') == compiler_sources(root)", "True", stale),
            ('milestone', "value['stage'] == 'M1'", "True", legacy),
        )
        for name, before, after, fixture in changes:
            data.require(original_program.count(before) == 1, 'M1-RATIO-TEST mutation site ' + name)
            program.write_text(original_program.replace(before, after))
            value = copy.deepcopy(fixture)
            value['measurement_sha256'] = data.digest(program)
            invoke(value, 'M1-RATIO provenance=', success=True, control=False)
            mutants += 1
            program.write_text(original_program)
        invoke(boundary(1.0), 'M1-RATIO provenance=', success=True)
        print(f'M1-RATIO-TEST controls={controls} refused={refusals} mutants={mutants}')
        print('M1-RATIO-TEST OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('M1-RATIO-TEST FAIL ' + str(error))
        sys.exit(1)

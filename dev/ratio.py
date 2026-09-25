#!/usr/bin/env python3
"""Measure successful parse-through-files wall time, or report a frozen run."""
from pathlib import Path
import datetime
import importlib.util
import json
import math
import os
import platform
import shutil
import statistics
import subprocess
import sys
import tempfile
import time


def module(root):
    spec = importlib.util.spec_from_file_location('corpus_data', root / 'dev/corpus-data.py')
    data = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(data)
    return data


def checked(argv, cwd):
    result = subprocess.run(argv, cwd=cwd, capture_output=True, text=True, timeout=120)
    if result.returncode != 0 or result.stderr:
        raise ValueError(f'RATIO-COMMAND exit={result.returncode}: {argv}: {result.stdout}{result.stderr}')
    return result.stdout.strip()


def summary(samples, lines, invocations):
    median = statistics.median(samples)
    return dict(samples_ms=samples, median_ms=median, min_ms=min(samples), max_ms=max(samples),
                runs=len(samples), lines=lines, invocations=invocations,
                ms_per_kloc=median * 1000 / lines if lines else None)


def save_measurement(target, report):
    duration = report['window']['seconds']
    valid_window = 0 < duration < 60
    path = target if valid_window else target.with_name(target.name + f'.rejected-{time.time_ns()}.json')
    retained = report if valid_window else dict(report, rejection='RATIO-WINDOW', window_limit_seconds=60)
    with path.open('x') as output:
        output.write(json.dumps(retained, indent=2) + '\n')
    if not valid_window:
        totals = ' '.join(f'{name}={sum(row["samples_ms"]):.1f}ms' for name, row in report['rows'].items())
        raise ValueError(f'RATIO-WINDOW seconds={duration:.3f} limit=60 {totals}; rejected_report={path}')


def compiler_sources(root):
    paths = [root / path for path in ('assay', 'Makefile', 'dev/build.py', 'dev/build.sh', 'dev/bend_source.py', 'dev/toolchain.json')]
    paths.extend(path for path in (root / 'src').glob('*')
                 if path.is_file() and path.name not in ('tests.bend', 'test-os.js'))
    data = module(root)
    return {str(path.relative_to(root)): data.digest(path) for path in sorted(paths)}


def measure(root, target, milestone='M0'):
    data = module(root)
    data.require(not target.exists(), 'RATIO-OUTPUT exists')
    frozen = data.manifest(root)
    checked([sys.executable, '-P', 'dev/build.py', 'build', 'bin/assay'], root)
    binary = root / '_build/bin/assay'
    identities = {path: data.digest(root / path) for path in
                  ('_build/bin/assay', '_build/bend/assay.js', 'corpus/MANIFEST.json', 'dev/ratio.py', 'dev/corpus-data.py')}
    sources = compiler_sources(root)
    groups = {name: [row for row in frozen['cases'] if row['group'] == name]
              for name in ('contracts', 'proofs')}
    spec = importlib.util.spec_from_file_location('assay_build', root / 'dev/build.py')
    builder = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(builder)
    bend, node = builder.compiler(), builder.runtime()
    tools = {'bend_compile': str(bend), 'bend_check': str(bend), 'cc': shutil.which('cc')}
    data.require(tools['cc'], 'RATIO-TOOLS need a C compiler to validate the Bend outputs')
    versions = {'bend': checked([str(bend), 'version'], root), 'node': checked([node, '--version'], root)}
    native_outputs = {}
    samples = {name: [] for name in ('contracts', 'proofs', 'bend_compile', 'bend_check', 'fixed')}
    runs = []
    with tempfile.TemporaryDirectory(prefix='assay-ratio-') as temporary:
        work = Path(temporary)
        # Warm each complete workload, then interleave five measured rounds.
        for index in range(6):
            if index == 1:
                started = datetime.datetime.now(datetime.timezone.utc).isoformat()
                start_wall = time.monotonic()
                load_start = os.getloadavg()
            for name in samples:
                folder = work / f'{index}-{name}'
                folder.mkdir()
                if name in ('bend_compile', 'bend_check'):
                    elapsed, argv = 0.0, []
                    for row in frozen['bend']:
                        out = folder / (Path(row['path']).stem + '.c')
                        command = [str(bend), str(root / row['path'])]
                        command += ['-o', str(out)] if name == 'bend_compile' else ['--check-only']
                        begin = time.perf_counter_ns()
                        output = checked(command, folder)
                        elapsed += (time.perf_counter_ns() - begin) / 1e6
                        argv.append(command)
                        if name == 'bend_compile':
                            identity = data.digest(out)
                            if index == 0:
                                native_outputs[row['path']] = identity
                                executable = out.with_suffix('.native')
                                checked([tools['cc'], '-std=c11', '-O0', str(out), '-lpthread', '-lm', '-o', str(executable)], folder)
                                data.require(checked([str(executable)], folder) == row['answer'], 'RATIO-BEND-ANSWER')
                            else:
                                data.require(native_outputs[row['path']] == identity, 'RATIO-BEND-OUTPUT')
                        else:
                            data.require('All terms check' in output, 'RATIO-BEND-CHECK')
                elif name == 'fixed':
                    argv = [str(binary), 'spec-count']
                    begin = time.perf_counter_ns()
                    output = checked(argv, root)
                    elapsed = (time.perf_counter_ns() - begin) / 1e6
                    data.require(bool(output), 'RATIO-FIXED')
                else:
                    elapsed = 0.0
                    argv = []
                    for row in groups[name]:
                        out = folder / Path(row['path']).stem
                        command = [str(binary), 'emit', str(root / row['path']), '-o', str(out)]
                        begin = time.perf_counter_ns()
                        checked(command, root)
                        elapsed += (time.perf_counter_ns() - begin) / 1e6
                        # Validation is outside the timed interval.  Emit has
                        # returned only after closing all five output files.
                        data.outputs(out, row)
                        argv.append(command)
                if index:
                    samples[name].append(elapsed)
                    runs.append(dict(round=index, workload=name, argv=argv,
                                     cwd=str(folder if name in ('bend_compile', 'bend_check') else root), elapsed_ms=elapsed))
        duration = time.monotonic() - start_wall
        ended = datetime.datetime.now(datetime.timezone.utc).isoformat()
    # Recheck the inputs after the run.  No run can bless changed sources.
    data.manifest(root)
    data.require(all(data.digest(root / path) == expected for path, expected in identities.items()),
                 'RATIO-CHANGED executable, corpus or measurement code changed during timing')
    data.require(compiler_sources(root) == sources, 'RATIO-CHANGED compiler sources changed during timing')
    rows = {name: summary(values,
                sum(row['lines'] for row in groups[name]) if name in groups else
                sum(row['lines'] for row in frozen['bend']) if name != 'fixed' else 0,
                len(groups[name]) if name in groups else len(frozen['bend']) if name != 'fixed' else 1)
            for name, values in samples.items()}
    report = dict(version=2, stage='M1' if milestone == 'M1' else 'M0 Stage F', date=started[:10],
                  method='One warm run, five interleaved wall-clock runs.  Assay parses through five closed files. Bend emits C or checks the frozen paired corpus. C execution is validated outside timing. No fixed-cost subtraction.',
                  fixed_method='One spec-count invocation, process startup plus R0 formatting; an upper-bound proxy, not an empty compile.',
                  host=dict(system=platform.platform(), ncpu=os.cpu_count()),
                  window=dict(started=started, ended=ended, seconds=duration, load_start=load_start, load_end=os.getloadavg()),
                  versions=versions, executable_sha256=identities['_build/bend/assay.js'],
                  corpus_sha256=identities['corpus/MANIFEST.json'],
                  measurement_sha256=identities['dev/ratio.py'], rows=rows, commands=runs)
    if milestone == 'M1':
        report['compiler_sources_sha256'] = sources
    save_measurement(target, report)
    print(f'{milestone}-MEASURE file={target} rounds=5 window_seconds={duration:.3f}; freeze before reporting ratios')


def validate(report, frozen):
    require = module(Path(__file__).resolve().parent.parent).require
    require(report['version'] == 2 and report['stage'] in ('M0 Stage F', 'M1'), 'RATIO-VERSION')
    # Review round 2026-09-12 (C-1):  save_measurement marks a rejected window in the
    # retained report.  A report that carries the marker fails here, whatever its
    # window values say, so edited window seconds cannot publish it.
    require('rejection' not in report and 'window_limit_seconds' not in report, 'RATIO-REJECTED')
    require(0 < report['window']['seconds'] < 60, 'RATIO-WINDOW')
    for name in ('contracts', 'proofs', 'bend_compile', 'bend_check', 'fixed'):
        row = report['rows'][name]
        samples = row['samples_ms']
        require(len(samples) == 5 and all(type(v) in (float, int) and math.isfinite(v) and v > 0 for v in samples), 'RATIO-SAMPLES')
        selected = frozen['bend'] if name in ('bend_compile', 'bend_check') else [r for r in frozen['cases'] if r['group'] == name]
        lines = sum(r['lines'] for r in selected)
        invocations = 1 if name == 'fixed' else len(selected)
        require(row == summary(samples, lines, invocations), 'RATIO-SUMMARY ' + name)
    commands = report['commands']
    require(len(commands) == 25 and {(row['round'], row['workload']) for row in commands} ==
            {(i, name) for i in range(1, 6) for name in report['rows']}, 'RATIO-COMMANDS')
    for command in commands:
        require(command['elapsed_ms'] == report['rows'][command['workload']]['samples_ms'][command['round'] - 1], 'RATIO-TIMING')


def require_m1(root, value):
    require = module(root).require
    require(value['stage'] == 'M1', 'RATIO-MILESTONE need an M1 measurement')
    require(value.get('compiler_sources_sha256') == compiler_sources(root), 'RATIO-SOURCES')
    rows = value['rows']
    require(rows['contracts']['ms_per_kloc'] <= rows['bend_compile']['ms_per_kloc'],
            'RATIO-BOUND M1 limit=1.0')


def report(root, milestone='M0'):
    data = module(root)
    checked(['shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256'], root)
    frozen = data.manifest(root)
    value = json.loads((root / 'dev/denominators.json').read_text())
    validate(value, frozen)
    data.require(value['corpus_sha256'] == data.digest(root / 'corpus/MANIFEST.json'), 'RATIO-CORPUS')
    data.require(value['measurement_sha256'] == data.digest(root / 'dev/ratio.py'), 'RATIO-METHOD')
    if milestone == 'M1':
        require_m1(root, value)
    # Rebuilt binaries may differ by absolute build paths.  Source identities
    # are covered by DENOMINATORS; the original executable hash is provenance.
    rows = value['rows']
    assay = rows['contracts']['ms_per_kloc']
    native = rows['bend_compile']['ms_per_kloc']
    informational = 'false limit=1.0' if milestone == 'M1' else 'true'
    print(f'{milestone}-RATIO assay_ms_per_kloc={assay:.3f} bend_compile={native:.3f} bend_check={rows["bend_check"]["ms_per_kloc"]:.3f} '
          f'ratio={assay/native:.6f} fixed_ms={rows["fixed"]["median_ms"]:.3f} load={value["window"]["load_start"][0]:.2f} informational={informational}')
    print(f'{milestone}-PROOF-RATIO ms_per_kloc={rows["proofs"]["ms_per_kloc"]:.3f} files={rows["proofs"]["invocations"]} separate=true')
    print(f'{milestone}-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK')


def main():
    root = Path(__file__).resolve().parent.parent
    if sys.argv[1:] == []:
        report(root)
    elif sys.argv[1:] == ['--m1']:
        report(root, 'M1')
    elif len(sys.argv) == 3 and sys.argv[1] in ('--measure', '--measure-m1'):
        measure(root, Path(sys.argv[2]).absolute(), 'M1' if sys.argv[1] == '--measure-m1' else 'M0')
    else:
        print('usage: ratio.sh [--m1 | --measure NEW_JSON | --measure-m1 NEW_JSON]')
        return 64
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        milestone = 'M1' if sys.argv[1:2] in (['--m1'], ['--measure-m1']) else 'M0'
        print(f'{milestone}-RATIO FAIL ' + str(error))
        sys.exit(1)

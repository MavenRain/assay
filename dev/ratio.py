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


def measure(root, target):
    data = module(root)
    data.require(not target.exists(), 'RATIO-OUTPUT exists')
    frozen = data.manifest(root)
    binary = root / '_build/default/bin/assay.exe'
    identities = {path: data.digest(root / path) for path in
                  ('_build/default/bin/assay.exe', 'corpus/MANIFEST.json', 'dev/ratio.py', 'dev/corpus-data.py')}
    groups = {name: [row for row in frozen['cases'] if row['group'] == name]
              for name in ('contracts', 'proofs')}
    tools = {name: shutil.which(name) for name in ('ocamlopt', 'ocamlc', 'ocamldep')}
    data.require(all(tools.values()), 'RATIO-TOOLS need the zxcaml-p1 switch')
    versions = {name: checked([path, '-version'], root) for name, path in tools.items()}
    samples = {name: [] for name in ('contracts', 'proofs', 'ocamlopt', 'ocamlc', 'fixed')}
    runs = []
    with tempfile.TemporaryDirectory(prefix='assay-ratio-') as temporary:
        work = Path(temporary)
        source = work / 'ocaml'
        source.mkdir()
        for row in frozen['ocaml']:
            shutil.copy2(root / row['path'], source / Path(row['path']).name)
        order = checked([tools['ocamldep'], '-sort', *[Path(row['path']).name for row in frozen['ocaml']]], source).split()
        data.require(set(order) == {Path(row['path']).name for row in frozen['ocaml']}, 'RATIO-OCAML-ORDER')
        zarith = Path(tools['ocamlopt']).resolve().parent.parent / 'lib/zarith'
        data.require(zarith.is_dir(), 'RATIO-ZARITH')
        # Warm each complete workload, then interleave five measured rounds.
        for index in range(6):
            if index == 1:
                started = datetime.datetime.now(datetime.timezone.utc).isoformat()
                start_wall = time.monotonic()
                load_start = os.getloadavg()
            for name in samples:
                folder = work / f'{index}-{name}'
                folder.mkdir()
                if name in ('ocamlopt', 'ocamlc'):
                    for row in frozen['ocaml']:
                        shutil.copy2(source / Path(row['path']).name, folder / Path(row['path']).name)
                    argv = [tools[name], '-c', '-I', str(zarith), *order]
                    begin = time.perf_counter_ns()
                    checked(argv, folder)
                    elapsed = (time.perf_counter_ns() - begin) / 1e6
                    extension = '.cmx' if name == 'ocamlopt' else '.cmo'
                    data.require(all((folder / Path(path).with_suffix(extension)).is_file()
                                     for path in order if path.endswith('.ml')), 'RATIO-OCAML-OUTPUT')
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
                                     cwd=str(folder if name in ('ocamlopt', 'ocamlc') else root), elapsed_ms=elapsed))
        duration = time.monotonic() - start_wall
        ended = datetime.datetime.now(datetime.timezone.utc).isoformat()
        data.require(duration < 60, 'RATIO-WINDOW measured rounds exceeded one minute; rerun when host load permits')
    # Recheck the inputs after the run.  No run can bless changed sources.
    data.manifest(root)
    data.require(all(data.digest(root / path) == expected for path, expected in identities.items()),
                 'RATIO-CHANGED executable, corpus or measurement code changed during timing')
    rows = {name: summary(values,
                sum(row['lines'] for row in groups[name]) if name in groups else
                sum(row['lines'] for row in frozen['ocaml']) if name != 'fixed' else 0,
                len(groups[name]) if name in groups else 1)
            for name, values in samples.items()}
    report = dict(version=1, stage='M0 Stage F', date=started[:10],
                  method='One warm run, five interleaved wall-clock runs.  Assay parses through five closed files.  No fixed-cost subtraction.',
                  fixed_method='One spec-count invocation, process startup plus R0 formatting; an upper-bound proxy, not an empty compile.',
                  host=dict(system=platform.platform(), ncpu=os.cpu_count()),
                  window=dict(started=started, ended=ended, seconds=duration, load_start=load_start, load_end=os.getloadavg()),
                  versions=versions, executable_sha256=identities['_build/default/bin/assay.exe'],
                  corpus_sha256=identities['corpus/MANIFEST.json'],
                  measurement_sha256=identities['dev/ratio.py'], rows=rows, commands=runs)
    with target.open('x') as output:
        output.write(json.dumps(report, indent=2) + '\n')
    print(f'M0-MEASURE file={target} rounds=5 window_seconds={duration:.3f}; freeze before reporting ratios')


def validate(report, frozen):
    require = module(Path(__file__).resolve().parent.parent).require
    require(report['version'] == 1 and report['stage'] == 'M0 Stage F', 'RATIO-VERSION')
    require(0 < report['window']['seconds'] < 60, 'RATIO-WINDOW')
    for name in ('contracts', 'proofs', 'ocamlopt', 'ocamlc', 'fixed'):
        row = report['rows'][name]
        samples = row['samples_ms']
        require(len(samples) == 5 and all(type(v) in (float, int) and math.isfinite(v) and v > 0 for v in samples), 'RATIO-SAMPLES')
        selected = frozen['ocaml'] if name in ('ocamlopt', 'ocamlc') else [r for r in frozen['cases'] if r['group'] == name]
        lines = sum(r['lines'] for r in selected)
        invocations = len(selected) if name in ('contracts', 'proofs') else 1
        require(row == summary(samples, lines, invocations), 'RATIO-SUMMARY ' + name)
    commands = report['commands']
    require(len(commands) == 25 and {(row['round'], row['workload']) for row in commands} ==
            {(i, name) for i in range(1, 6) for name in report['rows']}, 'RATIO-COMMANDS')
    for command in commands:
        require(command['elapsed_ms'] == report['rows'][command['workload']]['samples_ms'][command['round'] - 1], 'RATIO-TIMING')


def report(root):
    data = module(root)
    checked(['shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256'], root)
    frozen = data.manifest(root)
    value = json.loads((root / 'dev/denominators.json').read_text())
    validate(value, frozen)
    data.require(value['corpus_sha256'] == data.digest(root / 'corpus/MANIFEST.json'), 'RATIO-CORPUS')
    data.require(value['measurement_sha256'] == data.digest(root / 'dev/ratio.py'), 'RATIO-METHOD')
    # Rebuilt binaries may differ by absolute build paths.  Source identities
    # are covered by DENOMINATORS; the original executable hash is provenance.
    rows = value['rows']
    assay = rows['contracts']['ms_per_kloc']
    native = rows['ocamlopt']['ms_per_kloc']
    print(f'M0-RATIO assay_ms_per_kloc={assay:.3f} ocamlopt={native:.3f} ocamlc={rows["ocamlc"]["ms_per_kloc"]:.3f} '
          f'ratio={assay/native:.6f} fixed_ms={rows["fixed"]["median_ms"]:.3f} load={value["window"]["load_start"][0]:.2f} informational=true')
    print(f'M0-PROOF-RATIO ms_per_kloc={rows["proofs"]["ms_per_kloc"]:.3f} files={rows["proofs"]["invocations"]} separate=true')
    print('M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK')


def main():
    root = Path(__file__).resolve().parent.parent
    if sys.argv[1:] == []:
        report(root)
    elif len(sys.argv) == 3 and sys.argv[1] == '--measure':
        measure(root, Path(sys.argv[2]).absolute())
    else:
        print('usage: ratio.sh [--measure NEW_JSON]')
        return 64
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print('M0-RATIO FAIL ' + str(error))
        sys.exit(1)

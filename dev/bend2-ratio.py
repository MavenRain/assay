#!/usr/bin/env python3
"""Compare complete, matched compilation batches against pinned Bend 2."""
from pathlib import Path
import argparse
import datetime
import hashlib
import importlib.util
import json
import math
import os
import platform
import re
import shutil
import statistics
import subprocess
import tempfile
import time


COMMIT = 'c65bcb788dbfb298bb434c1d858b47c193841dc0'
VERSIONS = {'bend': 'bend 2.0.25', 'node': 'v23.10.0'}
CASES = ('Return', 'Arithmetic', 'Pair', 'Leaf', 'Apply', 'Let')
MANIFEST = 'corpus/bend2/MANIFEST.json'
REPORT = 'dev/bend2-baseline.json'
METHOD_FILES = ('dev/bend2-ratio.py', 'dev/ratio.py', 'dev/corpus-data.py')
METHOD = dict(warmups=1, rounds=5, order='alternating-assay-first',
              cache='warm-inputs-fresh-outputs-no-incremental-cache',
              assay_endpoint='five-files-closed', bend_endpoint='C-file-closed',
              units='milliseconds-per-matched-six-file-batch', subtraction='none',
              validation='outside-timing', window_limit_seconds=60)


def require(ok, message):
    if not ok:
        raise ValueError('BEND2-' + message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_module(root, name):
    spec = importlib.util.spec_from_file_location(name.replace('-', '_'), root / ('dev/' + name + '.py'))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def unique(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'JSON-DUPLICATE ' + key)
        result[key] = value
    return result


def read_json(path):
    def invalid(value):
        raise ValueError('BEND2-JSON-NONFINITE ' + value)
    return json.loads(path.read_text(), object_pairs_hook=unique, parse_constant=invalid)


def positive(value):
    return type(value) in (int, float) and math.isfinite(value) and value > 0


def hashes(root, paths):
    return {path: digest(root / path) for path in paths}


def corpus(root):
    frozen = load_module(root, 'corpus-data').manifest(root)
    by_name = {Path(row['path']).stem: row for row in frozen['cases']}
    value = read_json(root / MANIFEST)
    require(value['version'] == 1 and value['bend_commit'] == COMMIT, 'CORPUS-VERSION')
    require([row['name'] for row in value['cases']] == list(CASES), 'CORPUS-CASES')
    require({p.name for p in (root / 'corpus/bend2').glob('*.bend')} ==
            {name + '.bend' for name in CASES}, 'CORPUS-INVENTORY')
    for row in value['cases']:
        expected = by_name[row['name']]
        require(row['assay'] == expected, 'CORPUS-ASSAY ' + row['name'])
        require(expected['storage'] == {}, 'CORPUS-STORAGE')
        path = 'corpus/bend2/' + row['name'] + '.bend'
        require(row['bend_path'] == path and row['bend_sha256'] == digest(root / path), 'CORPUS-BEND ' + path)
    return value


def identities(root):
    return dict(corpus_sha256=digest(root / MANIFEST),
                seed_sha256=digest(root / 'corpus/MANIFEST.json'),
                method_sha256=hashes(root, METHOD_FILES),
                compiler_sources_sha256=load_module(root, 'ratio').compiler_sources(root))


def totals(rounds):
    return {name: [sum(row['samples_ms'][name]) for row in rounds] for name in ('assay', 'bend2')}


def validate(root, value, binding=True):
    frozen = corpus(root)
    require(value['version'] == 1 and value['stage'] == 'M1', 'REPORT-VERSION')
    require(value['method'] == METHOD, 'METHOD')
    require(value['identities'] == identities(root), 'IDENTITIES')
    require(value['bend_commit'] == COMMIT and
            value['bend_sources_sha256'] == frozen['bend_sources_sha256'], 'BEND-PIN')
    require(value['tools']['versions'] == VERSIONS, 'TOOLCHAIN')
    require(set(value['tools']['sha256']) == {'assay', 'bend', 'node', 'cc'} and
            all(re.fullmatch('[0-9a-f]{64}', sha) for sha in value['tools']['sha256'].values()), 'TOOLS-HASH')
    require(bool(value['tools']['cc_version']) and bool(value['host']['platform']) and
            bool(value['host']['machine']), 'HOST')
    start = datetime.datetime.fromisoformat(value['started_utc'])
    require(start.utcoffset() == datetime.timedelta(0), 'TIMEZONE')
    require(value['case_order'] == list(CASES), 'CASE-ORDER')
    require(len(value['rounds']) == 5, 'ROUNDS')
    for index, row in enumerate(value['rounds']):
        order = ['assay', 'bend2'] if index % 2 == 0 else ['bend2', 'assay']
        require(row['order'] == order and set(row['samples_ms']) == set(order), 'ORDER')
        for samples in row['samples_ms'].values():
            require(len(samples) == len(CASES) and all(positive(x) for x in samples), 'SAMPLES')
    samples = totals(value['rounds'])
    duration = value['window_seconds']
    timed = sum(sum(rows) for rows in samples.values()) / 1000
    require(positive(duration) and timed <= duration < 60, 'WINDOW')
    require(set(value['outputs']) == set(CASES), 'OUTPUT-CASES')
    for row in frozen['cases']:
        output = value['outputs'][row['name']]
        require(output['assay'] == row['assay']['outputs'], 'OUTPUT-ASSAY')
        require(output['native_stdout'] == row['assay']['answer'], 'OUTPUT-NATIVE')
        require(re.fullmatch('[0-9a-f]{64}', output['bend_c_sha256']) is not None, 'OUTPUT-C')
    medians = {name: statistics.median(rows) for name, rows in samples.items()}
    ratio = medians['assay'] / medians['bend2']
    if binding:
        require(medians['assay'] <= medians['bend2'], 'BOUND limit=1.0 ratio=' + str(ratio))
    return ratio, medians


def checked(argv, cwd, env=None):
    result = subprocess.run([str(x) for x in argv], cwd=cwd, env=env,
                            capture_output=True, text=True, timeout=120)
    require(result.returncode == 0, 'COMMAND ' + repr(argv) + ': ' + result.stdout + result.stderr)
    return result.stdout.strip()


def measure(root, target, bend_root):
    require(not target.exists(), 'OUTPUT-EXISTS')
    frozen = corpus(root)
    require(checked(['git', 'rev-parse', 'HEAD'], bend_root) == COMMIT, 'BEND-COMMIT')
    require(hashes(bend_root, frozen['bend_sources_sha256']) == frozen['bend_sources_sha256'], 'BEND-SOURCES')
    tools = {name: shutil.which(name) for name in ('node', 'cc')}
    require(all(tools.values()), 'TOOLS need Node and cc')
    versions = {name: checked([tools[name], flag], root) for name, flag in
                (('node', '--version'),)}
    require(versions == {name: VERSIONS[name] for name in versions}, 'TOOLCHAIN')
    build_env = dict(os.environ, BEND=str(bend_root / 'bin/bend'))
    checked(['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], root, build_env)
    tools.update(assay=str(root / '_build/bin/assay'), bend=str(bend_root / 'bin/bend'))
    env = dict(os.environ, BEND_NO_TELEMETRY='1')
    versions['bend'] = checked([tools['bend'], 'version'], root, env)
    require(versions == VERSIONS, 'TOOLCHAIN')
    identity = identities(root)
    tool_info = dict(versions=versions, paths=tools,
                     sha256={name: digest(root / '_build/bend/assay.js' if name == 'assay' else Path(path)) for name, path in tools.items()},
                     cc_version=checked([tools['cc'], '--version'], root).splitlines()[0])
    records, outputs = [], {}
    data = load_module(root, 'corpus-data')
    with tempfile.TemporaryDirectory(prefix='assay-bend2-') as temporary:
        work = Path(temporary)
        for index in range(-1, 5):
            if index == 0:
                started = datetime.datetime.now(datetime.timezone.utc).isoformat()
                start_wall = time.monotonic()
                load_start = os.getloadavg()
            order = ['assay', 'bend2'] if index < 0 or index % 2 == 0 else ['bend2', 'assay']
            samples = {'assay': [], 'bend2': []}
            for name in order:
                for row in frozen['cases']:
                    folder = work / str(index) / name / row['name']
                    folder.mkdir(parents=True)
                    if name == 'assay':
                        out = folder / 'emit'
                        command = [tools['assay'], 'emit', str(root / row['assay']['path']), '-o', str(out)]
                    else:
                        out = folder / 'main.c'
                        command = [tools['bend'], str(root / row['bend_path']), '-o', str(out)]
                    before = time.perf_counter_ns()
                    checked(command, root, env)
                    samples[name].append((time.perf_counter_ns() - before) / 1_000_000)
                    result = outputs.setdefault(row['name'], {})
                    if name == 'assay':
                        result['assay'] = data.outputs(out, row['assay'])
                    elif index == -1:
                        result['bend_c_sha256'] = digest(out)
                        native = folder / 'native'
                        checked([tools['cc'], '-std=c11', '-O0', str(out), '-lpthread', '-lm', '-o', str(native)], root)
                        result['native_stdout'] = checked([str(native)], root)
                        require(result['native_stdout'] == row['assay']['answer'], 'OUTPUT-NATIVE ' + row['name'])
                    else:
                        require(digest(out) == result['bend_c_sha256'], 'OUTPUT-C ' + row['name'])
            if index >= 0:
                records.append(dict(order=order, samples_ms=samples))
        duration = time.monotonic() - start_wall
    require(identity == identities(root), 'SOURCES-CHANGED')
    require(hashes(bend_root, frozen['bend_sources_sha256']) == frozen['bend_sources_sha256'], 'BEND-SOURCES-CHANGED')
    require(tool_info['sha256'] == {name: digest(root / '_build/bend/assay.js' if name == 'assay' else Path(path)) for name, path in tools.items()}, 'TOOLS-CHANGED')
    report = dict(version=1, stage='M1', method=METHOD, identities=identity, bend_commit=COMMIT,
                  bend_sources_sha256=frozen['bend_sources_sha256'], tools=tool_info,
                  host=dict(platform=platform.platform(), machine=platform.machine(), load_start=load_start),
                  started_utc=started, window_seconds=duration, case_order=list(CASES), rounds=records, outputs=outputs)
    # Retain failed timing windows without allowing them into the active freeze.
    output = target if duration < 60 else target.with_name(target.name + '.rejected-window.json')
    with output.open('x') as stream:
        json.dump(report, stream, indent=2, allow_nan=False)
        stream.write('\n')
    validate(root, report, binding=False)
    print(f'BEND2-MEASURE file={output} rounds=5 cases=6 window_seconds={duration:.3f}; freeze before gating')


def report(root, binding):
    seal = (root / 'dev/BEND2.sha256').read_text().split()
    require(len(seal) == 2 and seal[1] == REPORT and seal[0] == digest(root / REPORT), 'REPORT-SEAL')
    ratio, medians = validate(root, read_json(root / REPORT), binding=binding)
    print(f'BEND2-RATIO assay_ms={medians["assay"]:.6f} bend2_ms={medians["bend2"]:.6f} '
          f'ratio={ratio:.9f} limit=1.0 informational={str(not binding).lower()}')
    print('BEND2-RATIO cases=6 rounds=5 source-pins=OK subtraction=none OK')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument('--measure', type=Path, metavar='NEW_JSON')
    mode.add_argument('--m0', action='store_true', help='report without enforcing the M1 speed bound')
    parser.add_argument('--bend-root', type=Path, help='pinned Bend 2 checkout, required for measurement')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent.parent
    if args.measure is not None:
        require(args.bend_root is not None, 'ARGUMENT need --bend-root')
        measure(root, args.measure.resolve(), args.bend_root.resolve())
    else:
        require(args.bend_root is None, 'ARGUMENT --bend-root requires --measure')
        report(root, binding=not args.m0)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError, OverflowError, subprocess.TimeoutExpired) as error:
        print('BEND2-RATIO FAIL ' + str(error))
        raise SystemExit(1)

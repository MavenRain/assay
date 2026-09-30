#!/usr/bin/env python3
"""Compare two built Assay trees on identical inputs and all five output files."""
from pathlib import Path
import hashlib
import json
import statistics
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[3]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    baseline, target = (Path(arg).resolve() for arg in sys.argv[1:])
    roots = {'before': baseline, 'after': ROOT}
    cases = json.loads((ROOT / 'corpus/bend2/MANIFEST.json').read_text())['cases']
    samples = []
    hashes = {}
    start = time.monotonic()
    with tempfile.TemporaryDirectory(prefix='assay-keywords-') as directory:
        work = Path(directory)
        for index in range(-1, 5):
            order = ['before', 'after'] if index % 2 == 0 else ['after', 'before']
            row = {'order': order, 'samples_ms': {name: [] for name in roots}}
            for name in order:
                for case in cases:
                    output = work / f'{index}-{name}-{case["name"]}'
                    command = [str(roots[name] / '_build/bin/assay'), 'emit',
                               str(ROOT / case['assay']['path']), '-o', str(output)]
                    before = time.perf_counter_ns()
                    subprocess.run(command, cwd=roots[name], capture_output=True, check=True, timeout=60)
                    row['samples_ms'][name].append((time.perf_counter_ns() - before) / 1_000_000)
                    files = {path.name: digest(path) for path in output.iterdir()}
                    if len(files) != 5 or files != hashes.setdefault(case['name'], files):
                        raise ValueError('output mismatch: ' + case['name'])
            if index >= 0:
                samples.append(row)
    medians = {name: statistics.median(sum(row['samples_ms'][name]) for row in samples) for name in roots}
    report = dict(rounds=samples, median_batch_ms=medians,
                  after_over_before=medians['after'] / medians['before'],
                  wall_seconds=time.monotonic() - start, output_sha256=hashes,
                  source_sha256={name: digest(root / 'src/frontend.bend') for name, root in roots.items()},
                  executable_sha256={name: digest(root / '_build/bend/assay.js') for name, root in roots.items()},
                  method_sha256=digest(Path(__file__)),
                  method='one warmup, five alternating rounds, six files, fresh outputs, no subtraction')
    with target.open('x') as stream:
        json.dump(report, stream, indent=2)
        stream.write('\n')
    print(f'KEYWORD-COMPARE cases={len(cases)} rounds=5 outputs=identical ratio={report["after_over_before"]:.6f}')


if __name__ == '__main__':
    main()

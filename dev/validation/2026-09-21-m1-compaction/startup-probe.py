import json
import os
from pathlib import Path
import resource
import shutil
import statistics
import subprocess
import tempfile
import time

root = Path('/Users/oobi/Documents/gpt1/assay-m1-performance')
binary = root / '_build/default/bin/assay.exe'
samples = {name: [] for name in ('true', 'native', 'stripped', 'small-heap', 'emit', 'stripped-emit')}
with tempfile.TemporaryDirectory(prefix='assay-startup-probe-') as temporary:
    work = Path(temporary)
    stripped = work / 'assay-stripped'
    shutil.copyfile(binary, stripped)
    stripped.chmod(0o755)
    subprocess.run(['/usr/bin/strip', '-S', '-x', str(stripped)], check=True)
    for round in range(16):
        for name in samples:
            command = ['/usr/bin/true'] if name == 'true' else [str(stripped if name.startswith('stripped') else binary)]
            if name.endswith('emit'):
                command += ['emit', str(root / 'corpus/contracts/Ref20.asy'), '-o', str(work / f'{name}-{round}')]
            elif name != 'true':
                command += ['spec-count']
            environment = dict(os.environ)
            if name == 'small-heap':
                environment['OCAMLRUNPARAM'] = 's=32k'
            before = resource.getrusage(resource.RUSAGE_CHILDREN)
            started = time.perf_counter_ns()
            subprocess.run(command, capture_output=True, check=True, env=environment)
            wall = (time.perf_counter_ns() - started) / 1e6
            after = resource.getrusage(resource.RUSAGE_CHILDREN)
            if round:
                samples[name].append(dict(wall_ms=wall, cpu_ms=1000 * (after.ru_utime + after.ru_stime - before.ru_utime - before.ru_stime)))
    sizes = dict(native=binary.stat().st_size, stripped=stripped.stat().st_size)
summary = {name: {key: statistics.median(row[key] for row in rows) for key in ('wall_ms', 'cpu_ms')} for name, rows in samples.items()}
Path(__file__).with_suffix('.json').write_text(json.dumps(dict(samples=samples, summary=summary, sizes=sizes), indent=2) + '\n')
print(json.dumps(dict(summary=summary, sizes=sizes), indent=2))

import json
from pathlib import Path
import resource
import statistics
import subprocess
import sys
import tempfile
import time

root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[3]
binary = str(root / '_build/default/bin/assay.exe')
samples = {name: [] for name in ('true', 'spec-count', 'check', 'emit')}
with tempfile.TemporaryDirectory(prefix='assay-startup-') as temporary:
    for round in range(11):
        for name in samples:
            command = ['/usr/bin/true'] if name == 'true' else [binary, name]
            if name in ('check', 'emit'):
                command.append(str(root / 'corpus/contracts/Ref20.asy'))
            if name == 'emit':
                command += ['-o', str(Path(temporary) / str(round))]
            before = resource.getrusage(resource.RUSAGE_CHILDREN)
            start = time.perf_counter()
            result = subprocess.run(command, capture_output=True, text=True)
            wall = (time.perf_counter() - start) * 1000
            after = resource.getrusage(resource.RUSAGE_CHILDREN)
            assert result.returncode == 0, result.stderr + result.stdout
            if round:
                samples[name].append(dict(wall_ms=wall, cpu_ms=1000 * (
                    after.ru_utime + after.ru_stime - before.ru_utime - before.ru_stime)))
Path(__file__).with_suffix('.json').write_text(json.dumps(samples, indent=2) + '\n')
print({name: {key: statistics.median(row[key] for row in rows) for key in ('wall_ms', 'cpu_ms')}
       for name, rows in samples.items()})

"""Compare the frozen compiler and current compiler on one alternating corpus pass."""
from pathlib import Path
import hashlib
import importlib.util
import json
import resource
import subprocess
import time

root = Path('/Users/oobi/Documents/gpt1/assay-m1-errors')
prior = Path('/Users/oobi/Documents/assay/_build/default/bin/assay.exe')
report = json.loads((root / 'dev/denominators.json').read_text())
if hashlib.sha256(prior.read_bytes()).hexdigest() != report['executable_sha256']:
    raise SystemExit('STOP: previous compiler does not match its frozen report')
spec = importlib.util.spec_from_file_location('assay_compare_data', root / 'dev/corpus-data.py')
data = importlib.util.module_from_spec(spec)
spec.loader.exec_module(data)
manifest = data.manifest(root)
work = root / '.gatework/timing-debug/compare'
work.mkdir(exist_ok=False)
records = []
for index, case in enumerate(manifest['cases']):
    compilers = [('prior', prior), ('current', root / '_build/default/bin/assay.exe')]
    if index % 2:
        compilers.reverse()
    for label, binary in compilers:
        output = work / (label + '-' + Path(case['path']).stem)
        before = resource.getrusage(resource.RUSAGE_CHILDREN)
        start = time.monotonic()
        result = subprocess.run([str(binary), 'emit', str(root / case['path']), '-o', str(output)],
                                capture_output=True, text=True, timeout=30)
        wall = time.monotonic() - start
        after = resource.getrusage(resource.RUSAGE_CHILDREN)
        cpu = after.ru_utime + after.ru_stime - before.ru_utime - before.ru_stime
        if result.returncode != 0:
            raise SystemExit('STOP: diagnostic compile failed: ' + result.stderr)
        data.outputs(output, case)
        records.append(dict(compiler=label, source=case['path'], wall_seconds=wall, cpu_seconds=cpu))
summary = {label: dict(wall_seconds=sum(row['wall_seconds'] for row in records if row['compiler'] == label),
                      cpu_seconds=sum(row['cpu_seconds'] for row in records if row['compiler'] == label))
           for label in ('prior', 'current')}
(work / 'RESULTS.json').write_text(json.dumps(dict(method='One alternating diagnostic corpus pass, no gate verdict.',
    prior_sha256=report['executable_sha256'], current_sha256=hashlib.sha256((root / '_build/default/bin/assay.exe').read_bytes()).hexdigest(),
    summary=summary, records=records), indent=2) + '\n')
print(json.dumps(summary, indent=2))
print('COMPARE 22 compiles; all frozen output hashes match; diagnostic only')

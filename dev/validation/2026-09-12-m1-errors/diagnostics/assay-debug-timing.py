"""One diagnostic pass with CPU accounting, without running the timing gate."""
from pathlib import Path
import importlib.util
import json
import os
import resource
import shutil
import subprocess
import time

root = Path('/Users/oobi/Documents/gpt1/assay-m1-errors')
work = root / '.gatework/timing-debug'
work.mkdir(parents=True, exist_ok=False)
spec = importlib.util.spec_from_file_location('assay_ratio_diagnostic', root / 'dev/ratio.py')
ratio = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ratio)
data = ratio.module(root)
manifest = data.manifest(root)
records = []


def capture(label, argv, cwd):
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    start = time.monotonic()
    result = subprocess.run([str(arg) for arg in argv], cwd=cwd, capture_output=True, text=True, timeout=90)
    seconds = time.monotonic() - start
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    cpu = after.ru_utime + after.ru_stime - before.ru_utime - before.ru_stime
    row = dict(label=label, argv=[str(arg) for arg in argv], cwd=str(cwd), exit=result.returncode,
               wall_seconds=seconds, cpu_seconds=cpu, cpu_over_wall=cpu / seconds,
               stdout=result.stdout, stderr=result.stderr, load=os.getloadavg())
    records.append(row)
    (work / 'RESULTS.json').write_text(json.dumps(records, indent=2) + '\n')
    print(f'{label}: exit={result.returncode} wall={seconds:.3f}s cpu={cpu:.3f}s cpu/wall={cpu / seconds:.3f}', flush=True)
    if result.returncode != 0:
        raise SystemExit('Diagnostic command failed: ' + label)
    return result.stdout


binary = root / '_build/default/bin/assay.exe'
for row in manifest['cases']:
    output = work / Path(row['path']).stem
    capture('assay-' + row['path'], [binary, 'emit', root / row['path'], '-o', output], root)
    data.outputs(output, row)
capture('fixed', [binary, 'spec-count'], root)
tools = {name: Path('/Users/oobi/.opam/zxcaml-p1/bin') / name for name in ('ocamlopt', 'ocamlc', 'ocamldep')}
zarith = tools['ocamlopt'].resolve().parent.parent / 'lib/zarith'
for name in ('ocamlopt', 'ocamlc'):
    folder = work / name
    folder.mkdir()
    for row in manifest['ocaml']:
        shutil.copy2(root / row['path'], folder / Path(row['path']).name)
    order = capture(name + '-order', [tools['ocamldep'], '-sort', *[Path(row['path']).name for row in manifest['ocaml']]], folder).split()
    capture(name, [tools[name], '-c', '-I', zarith, *order], folder)
print('DIAGNOSTIC ONLY: one pass; no gate verdict or denominator update', flush=True)

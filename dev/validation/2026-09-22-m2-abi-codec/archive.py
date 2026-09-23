from pathlib import Path
import hashlib
import json
import subprocess
import sys
import tarfile

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m2-abi-codec')
OUT = ROOT / 'dev/validation/2026-09-22-m2-abi-codec'
BASE = subprocess.check_output(['git', '-C', str(ROOT), 'rev-parse', 'HEAD'], text=True).strip()
CAPTURES = {
    'build-before-adapter-fix': ('run-SMgt1l', 0),
    'focused-before-adapter-fix': ('run-fMzLEz', 0),
    'diagnostic-witness': ('run-1IFlQn', 1),
    'diagnostic-tool-path': ('run-TdhQgL', 1),
    'measure-ocaml': ('run-K6Hsww', 0),
    'measure-bend2': ('run-pcfD2n', 0),
    'default-gates': ('run-hOLPQJ', 1),
    'house-rerun': ('run-g1Tq90', 0),
    'final-checks': (sys.argv[1], 0),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(ok, message):
    if not ok:
        raise ValueError(message)


def copy(source, target):
    target.parent.mkdir(parents=True, exist_ok=True)
    old = json.loads(subprocess.check_output(['kanon-write', 'inspect', str(target)], text=True))
    subprocess.run(['kanon-write', 'copy', str(target), '--expect', old['sha256'],
                    '--from', str(source), '--source-sha256', sha(source)], check=True,
                   stdout=subprocess.DEVNULL)


OUT.mkdir(parents=True, exist_ok=True)
for name, (directory, expected_exit) in CAPTURES.items():
    capture = ROOT / '.kanon-exec' / directory
    metadata = json.loads((capture / 'manifest.json').read_text())
    require(metadata['status'] == 'complete' and metadata['exitCode'] == expected_exit,
            'Capture did not finish as expected: ' + name)
    for source, suffix in [('manifest.json', '.json'), ('command-0001.stdout', '.log'),
                           ('command-0001.stderr', '.stderr')]:
        copy(capture / source, OUT / (name + suffix))

lines = (OUT / 'default-gates.log').read_text().splitlines()
passes = [line.split()[1] for line in lines if line.startswith('PASS ')]
failures = [line.split()[1] for line in lines if line.startswith('FAIL ')]
require(len(passes) == len(set(passes)) == 77 and failures == ['HOUSE'], 'Unexpected default verdict')
require(lines[-1] == 'STAGE-M2-ABI-CODEC FAIL', 'Missing full-run completion')
require((OUT / 'house-rerun.log').read_text().rstrip().endswith('HOUSE OK'), 'Missing HOUSE repair')
require('FINAL-CHECKS source-pins=152 HOUSE=OK budgets=OK speed=OK whitespace=OK' in
        (OUT / 'final-checks.log').read_text(), 'Missing final checks')
require('ABI-CODEC cast=48 vectors=49 reference=5 negative=26 prefixes=288 fuzz=128 mutants=10 scope=codec OK'
        in (ROOT / '.gatework/stage-m2-abi-codec/ABI-CODEC.log').read_text(), 'Missing final codec result')

entry = Path('/Users/oobi/Documents/gpt1/assay-codec-build-entry.md')
log = ROOT / 'dev/ASSAY-M2-BUILD-LOG.md'
if '### M2 typed ABI values, 2026-09-22' not in log.read_text():
    old = json.loads(subprocess.check_output(['kanon-write', 'inspect', str(log)], text=True))
    subprocess.run(['kanon-write', 'insert', str(log), '--expect', old['sha256'],
                    '--from', str(entry), '--source-sha256', sha(entry),
                    '--after', 'log or tarball was edited.'], check=True, stdout=subprocess.DEVNULL)
require(entry.read_text().strip() in log.read_text(), 'Build entry mismatch')
normalized = log.read_text().rstrip() + '\n'
if normalized != log.read_text():
    temporary = ROOT.parent / 'assay-codec-build-log-normalized.md'
    temporary.write_text(normalized)
    copy(temporary, log)

for name in ['bend2-baseline.json', 'denominators.json', 'BEND2.sha256', 'DENOMINATORS.sha256']:
    copy(ROOT / 'dev' / name, OUT / name)
copy(ROOT / '.gatework/abi-codec/GATE-COMPATIBILITY.json', OUT / 'GATE-COMPATIBILITY.json')
copy(Path('/Users/oobi/Documents/gpt1/assay-codec-gate-compatibility.py'), OUT / 'gate-compatibility.py')
copy(Path('/Users/oobi/Documents/gpt1/assay-codec-final-checks.py'), OUT / 'final-checks.py')
copy(Path(__file__).resolve(), OUT / 'archive.py')
for folder, filename in [('stage-m2-abi-codec', 'leg-logs.tar.gz'), ('abi-codec', 'codec-evidence.tar.gz')]:
    source = ROOT / '.gatework' / folder
    with tarfile.open(OUT / filename, 'w:gz') as archive:
        for path in sorted(source.rglob('*')):
            if path.is_file() and path.suffix in {'.log', '.json', '.py'}:
                archive.add(path, arcname=str(path.relative_to(source)), recursive=False)

paths = {line.split()[1] for line in (ROOT / 'dev/DENOMINATORS.sha256').read_text().splitlines()}
for line in (ROOT / 'dev/DENOMINATORS.sha256').read_text().splitlines():
    expected, relative = line.split()
    require(sha(ROOT / relative) == expected, 'Stale final pin: ' + relative)
changed = subprocess.check_output(['git', '-C', str(ROOT), 'diff', '--name-only'], text=True).splitlines()
added = subprocess.check_output(['git', '-C', str(ROOT), 'ls-files', '--others', '--exclude-standard'], text=True).splitlines()
paths.update(p for p in changed + added if not p.startswith('dev/validation/'))
paths.update(['dev/validation/2026-09-21-m1-close/gate-compatibility.py', 'reference/erc20/cases.json'])
sources = {p: sha(ROOT / p) for p in sorted(paths)}
(OUT / 'SOURCES.json').write_text(json.dumps(dict(version=1, base=BASE, sources=sources), indent=2) + '\n')
(OUT / 'RESULT.json').write_text(json.dumps(dict(
    version=1, base=BASE, default_passes=passes, default_failures=failures,
    repaired=['HOUSE'], validated_legs=sorted(passes + ['HOUSE']), count=78,
    performance_ratio=0.073514764, source_count=len(sources)), indent=2) + '\n')
(OUT / 'README.md').write_text('''# M2 ABI codec validation, 2026-09-22

Base: `1c6968f`. The complete default run passed 77 of 78 legs and failed
HOUSE on the initial adapter's list lookup and catch-all patterns.
`house-rerun.log` and `final-checks.log` validate the corrected adapter.
The ABI-CODEC leg at the end of the default run compiled and exercised
that corrected adapter. All 78 legs are validated across these runs.
`default-gates.log` retains its original failing completion marker.

`RESULT.json` records those verdicts. The two diagnostic captures retain
an initial mutation-witness mismatch and a missing Bun PATH entry, both
corrected. The early build and focused captures are preliminary checks.
The default ABI-CODEC leg and refreshed measurements cover the final
compiler implementation, as checked by the active source pins.

`leg-logs.tar.gz` contains the full 78 per-leg logs from the default run,
including the original HOUSE failure. `codec-evidence.tar.gz` contains
the final vectors, ten mutation witnesses and schedule-comparison inputs
from `.gatework/abi-codec`. These archives contain no compiled binaries.

`GATE-COMPATIBILITY.json` covers 47 old modes and five failure
classifications. The retained Python scripts are transcripts using the
isolated checkout's paths. Measurements keep the original five rounds,
six paired Bend workloads and unchanged performance bound. The ratio is
0.073514764. The two SHA-256 files retain the active measurement seals.

`SOURCES.json` pins the listed compiler, test, gate and documentation
inputs. `FILES.sha256` seals every file in this validation record except
itself. Carried Lean dependencies were reused from the preprovisioned
local cache. No dependency download was needed.
''')
files = sorted(p for p in OUT.rglob('*') if p.is_file() and p.name != 'FILES.sha256')
(OUT / 'FILES.sha256').write_text(''.join(sha(p) + '  ' + str(p.relative_to(OUT)) + '\n' for p in files))
print(json.dumps(dict(status='archived', validated=78, sources=len(sources), files=len(files), record=str(OUT))))

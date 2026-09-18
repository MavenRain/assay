"""Compare legacy artifacts with a fresh build of the committed baseline."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tarfile

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m1-fallback')
WORK = ROOT / '.gatework/fallback-compatibility'
BASE = '3e997f1bb4c69a35ee065018ac1238856cbe3b8c'
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')


def checked(argv, cwd=ROOT):
    result = subprocess.run(list(map(str, argv)), cwd=cwd, capture_output=True, text=True, timeout=120)
    if result.returncode:
        raise SystemExit(result.stdout + result.stderr)
    return result.stdout


assert checked(['git', 'rev-parse', 'HEAD']).strip() == BASE
WORK.mkdir(parents=True, exist_ok=True)
baseline = WORK / 'baseline'
if baseline.exists():
    shutil.rmtree(baseline)
baseline.mkdir()
archive = WORK / 'source.tar'
checked(['git', 'archive', '--format=tar', '--output=' + str(archive), BASE,
         'abi', 'asm', 'bin', 'emit', 'keccak', 'lib', 'surface', 'test',
         'dune', 'dune-project', 'dev/dunecho.sh', 'examples', 'corpus'])
with tarfile.open(archive) as source:
    source.extractall(baseline, filter='data')
archive.unlink()
(baseline / 'dune-workspace').write_text('(lang dune 3.0)\n')
shutil.copytree(ROOT / '_build', baseline / '_build')
build = checked(['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=baseline)
assert '0 errors, 0 warnings' in build
(WORK / 'BUILD.log').write_text(build)
sources = sorted(baseline.glob('examples/*.asy')) + sorted((baseline / 'corpus').rglob('*.asy'))
records = []
for index, source in enumerate(sources):
    relative = source.relative_to(baseline)
    outputs = []
    for label, root in [('baseline', baseline), ('current', ROOT)]:
        output = WORK / (label + '-' + str(index))
        if output.exists():
            shutil.rmtree(output)
        result = checked([root / '_build/default/bin/assay.exe', 'emit', root / relative, '-o', output])
        (WORK / (label + '-' + str(index) + '.log')).write_text(result)
        outputs.append(output)
    hashes = {}
    for file in FILES:
        original, current = ((output / file).read_bytes() for output in outputs)
        assert original == current, str(relative) + ': ' + file
        hashes[file] = hashlib.sha256(current).hexdigest()
    records.append(dict(source=str(relative), source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(), files=hashes))
assert records
result = dict(base=BASE, pairs=records, compiler_sha256={
    name: hashlib.sha256((root / '_build/default/bin/assay.exe').read_bytes()).hexdigest()
    for name, root in [('baseline', baseline), ('current', ROOT)]})
(WORK / 'COMPATIBILITY.json').write_text(json.dumps(result, indent=2) + '\n')
print(f'FALLBACK-COMPATIBILITY sources={len(records)} artifacts={len(records) * len(FILES)} byte_identical=OK')

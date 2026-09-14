"""Reuse unchanged proof artifacts with source and dependency checks."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess

source = Path('/Users/oobi/Documents/gpt1/assay-m1-invariants')
target = Path('/Users/oobi/Documents/gpt1/assay-m1-proof-helpers')
report = dict(source=str(source), target=str(target), sources={}, dependencies={})
for name in ('proofs', 'verification'):
    files = subprocess.check_output(['git', '-C', str(target), 'ls-files', '-z', name]).decode().split('\0')
    for relative in filter(None, files):
        if relative.endswith('.md'):
            continue
        before, after = (source / relative).read_bytes(), (target / relative).read_bytes()
        if before != after:
            raise SystemExit('STOP: cache source differs: ' + relative)
        report['sources'][relative] = hashlib.sha256(before).hexdigest()
    for row in json.loads((target / name / 'lake-manifest.json').read_text())['packages']:
        package = row['name'].strip('«»')
        path = source / name / '.lake/packages' / package
        head = subprocess.check_output(['git', '-C', str(path), 'rev-parse', 'HEAD']).decode().strip()
        status = subprocess.check_output(['git', '-C', str(path), 'status', '--porcelain', '--untracked-files=no'])
        if head != row['rev'] or status:
            raise SystemExit('STOP: cache dependency differs: ' + package)
        report['dependencies'][name + '/' + package] = head
    shutil.copytree(source / name / '.lake', target / name / '.lake', symlinks=True)
(target / '.gatework/CACHE.json').write_text(json.dumps(report, indent=2) + '\n')
print(f'CACHE matching_sources={len(report["sources"])} pinned_dependencies={len(report["dependencies"])}')

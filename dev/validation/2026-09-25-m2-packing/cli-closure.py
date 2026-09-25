from pathlib import Path
import hashlib
import json
import sys
import subprocess

ROOT = Path(sys.argv[1]).resolve()
BASE = 'f80689217a7557a7b3bd200f2ed865cde9d59e10'
sys.path.insert(0, str(ROOT / 'dev'))
from bend_source import bundle, declarations, reachable

def cli(base=False):
    records = []
    names = subprocess.check_output(['git', '-C', str(ROOT), 'ls-tree', '-r', '--name-only', BASE, '--', 'src']).decode().splitlines() if base else [str(p.relative_to(ROOT)) for p in sorted((ROOT / 'src').glob('*.bend'))]
    for name in names:
        if name.endswith('.bend') and name != 'src/tests.bend':
            source = subprocess.check_output(['git', '-C', str(ROOT), 'show', BASE + ':' + name]).decode() if base else (ROOT / name).read_text()
            records.extend(declarations(source, name))
    return bundle(reachable(records, 'Entry.Cli'), 'Entry.Cli')

before, after = cli(True), cli()
assert before == after, 'Compiler closure changed'
report = dict(identical=True, bytes=len(after.encode()), sha256=hashlib.sha256(after.encode()).hexdigest(),
              scope='Bundled reachable production CLI source, excluding OS imports rewritten by the builder')
(ROOT / '.gatework/layout-packed/cli-closure.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report))

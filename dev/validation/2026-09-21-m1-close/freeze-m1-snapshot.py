"""Generate the M1 snapshot, migrating the deleted wrapper entry explicitly."""
import hashlib
import importlib.util
import json
from pathlib import Path
import sys

root, target = map(Path, sys.argv[1:])
spec = importlib.util.spec_from_file_location('ratio', root / 'dev/ratio.py')
ratio = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ratio)
report = json.loads((root / 'dev/denominators.json').read_text())
assert report['stage'] == 'M1'
assert report['compiler_sources_sha256'] == ratio.compiler_sources(root)
assert report['measurement_sha256'] == hashlib.sha256((root / 'dev/ratio.py').read_bytes()).hexdigest()
prior = root / 'dev/validation/2026-09-21-m1-close/DENOMINATORS-before.sha256'
paths = {line.split('  ', 1)[1] for line in prior.read_text().splitlines()}
assert {name for name in paths if not (root / name).is_file()} == {'dev/dunecho.sh'}
# Commit 4836427 replaced this wrapper with dev/dune.sh.
paths.remove('dev/dunecho.sh')
paths.add('dev/dune.sh')
paths.update(report['compiler_sources_sha256'])
paths.update(('dev/denominators-m1-2026-09-21.json', 'dev/denominators-m1-2026-09-21-02.json',
              'dev/m1-ratio-test.py', 'dev/ratio.py',
              'dev/corpus-data.py', 'dev/stage-a-gates.py', 'dev/gates.sh'))
content = ''.join(f'{hashlib.sha256((root / name).read_bytes()).hexdigest()}  {name}\n'
                  for name in sorted(paths))
with target.open('x') as output:
    output.write(content)
print(f'M1-FREEZE paths={len(paths)} output={target}')

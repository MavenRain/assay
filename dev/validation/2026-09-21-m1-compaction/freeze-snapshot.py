import hashlib
import importlib.util
import json
from pathlib import Path

root = Path('/Users/oobi/Documents/gpt1/assay-m1-performance')
spec = importlib.util.spec_from_file_location('ratio', root / 'dev/ratio.py')
ratio = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ratio)
report = json.loads((root / 'dev/denominators.json').read_text())
assert report['stage'] == 'M1'
assert report['compiler_sources_sha256'] == ratio.compiler_sources(root)
assert report['executable_sha256'] == hashlib.sha256((root / '_build/default/bin/assay.exe').read_bytes()).hexdigest()
previous = root / 'dev/validation/2026-09-21-m1-compaction/DENOMINATORS-before.sha256'
old = dict((path, digest) for digest, path in (line.split('  ', 1) for line in previous.read_text().splitlines()))
paths = set(old) | {'dev/denominators-m1-2026-09-21-03.json', 'dev/denominators-m1-2026-09-21-04.json', 'test/asm_compact.ml'}
hashes = {path: hashlib.sha256((root / path).read_bytes()).hexdigest() for path in sorted(paths)}
assert hashes['corpus/MANIFEST.json'] == old['corpus/MANIFEST.json'] == report['corpus_sha256']
target = Path('/Users/oobi/Documents/gpt1/assay-performance-next.sha256')
with target.open('x') as output:
    output.write(''.join(f'{digest}  {path}\n' for path, digest in hashes.items()))
print(json.dumps({'paths': len(paths), 'changed': [path for path in hashes if path in old and hashes[path] != old[path]], 'added': sorted(paths - set(old)), 'output': str(target)}))

"""Refresh explicit source inventories and reuse verified test compiler outputs."""
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m2-calldata-cli')
BASE = Path('/Users/oobi/Documents/assay')
WORK = ROOT / '.gatework/calldata-preparation'
WORK.mkdir(parents=True, exist_ok=True)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inspect(path):
    result = subprocess.run(['kanon-write', 'inspect', str(path)],
                            check=True, capture_output=True, text=True)
    return json.loads(result.stdout)['sha256']


def copy(source, target):
    target.parent.mkdir(parents=True, exist_ok=True)
    expected = inspect(target)
    digest = sha(source)
    if expected == digest:
        return
    subprocess.run(['kanon-write', 'copy', str(target), '--expect', expected,
                    '--from', str(source), '--source-sha256', digest],
                   check=True, capture_output=True, text=True)


def json_set(name, data):
    source = WORK / Path(name).name
    source.write_text(json.dumps(data, indent=2) + '\n')
    target = ROOT / name
    subprocess.run(['kanon-write', 'json-set', str(target), '--expect', inspect(target),
                    '--data-file', str(source)], check=True, capture_output=True, text=True)


carry = json.loads((ROOT / 'dev/native-carry.json').read_text())
carry['carried'].pop('src/call_cli.bend', None)
carry['inventory'] = [name for name in carry['inventory'] if name != 'src/call_cli.bend']
for name in ('src/cli.bend',):
    carry['carried'][name] = sha(ROOT / name)
carry['inventory'] = sorted(set(carry['inventory']))
json_set('dev/native-carry.json', carry)

spec = importlib.util.spec_from_file_location('house', ROOT / 'dev/house.py')
house = importlib.util.module_from_spec(spec)
spec.loader.exec_module(house)
actual, gaps = house.catchalls(ROOT)
if gaps:
    raise ValueError('catch-all scan gaps: ' + str(gaps))
key = lambda row: (row['definition'], row['path'], row['arm_sha256'])
old = json.loads((ROOT / 'dev/bend-catchalls.json').read_text())
reasons = {key(row): row['reason'] for row in old}
additions = {
    'Cli.Call.typ': 'Rejects unsupported input type spellings after naming every supported ABI type.',
    'Cli.Call.boolean': 'Rejects boolean spellings other than the explicitly named true and false values.',
}
for row in actual:
    row['reason'] = reasons.get(key(row), additions.get(row['definition'], ''))
    if not row['reason']:
        raise ValueError('unreviewed catch-all: ' + row['definition'])
old_carried = {key(row) for row in old if row['definition'] not in additions}
if old_carried - {key(row) for row in actual}:
    raise ValueError('a previously named catch-all disappeared')
json_set('dev/bend-catchalls.json', actual)

manifest = ROOT / 'dev/DENOMINATORS.sha256'
names = {line.split(None, 1)[1] for line in manifest.read_text().splitlines() if line.strip()}
names.discard('src/call_cli.bend')
names.update(('dev/calldata-cli-test.py', 'dev/M2-CALLDATA-CLI.md'))
source = WORK / 'DENOMINATORS.sha256'
source.write_text(''.join(f'{sha(ROOT / name)}  {name}\n' for name in sorted(names)))
copy(source, manifest)

for name in ('tests', 'backends'):
    receipt = BASE / '_build/bend' / (name + '.json')
    data = json.loads(receipt.read_text())
    output = BASE / '_build/bend' / (name + '.js')
    if sha(output) != data['output_sha256']:
        raise ValueError('cached output changed: ' + name)
    for extension, source in (('.json', receipt), ('.js', output)):
        target = ROOT / '_build/bend/cache' / (data['inputs_sha256'] + extension)
        copy(source, target)
print(f'PREPARE carry={len(carry["inventory"])} catchalls=reviewed manifests=refreshed cached_tests=2 OK')

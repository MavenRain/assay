"""Read the frozen M0 inputs and verify emitted artifact identities."""
from pathlib import Path
import hashlib
import json
import re

FILES = {'runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt'}


def require(ok, message):
    if not ok:
        raise ValueError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def manifest(root):
    data = json.loads((root / 'corpus/MANIFEST.json').read_text())
    require(data['version'] == 2, 'CORPUS-VERSION')
    cases = data['cases']
    require(len(cases) == 11 and len({row['path'] for row in cases}) == 11, 'CORPUS-COUNT')
    require({row['group'] for row in cases} == {'contracts', 'proofs'}, 'CORPUS-GROUP')
    actual = {str(path.relative_to(root)) for path in (root / 'corpus').rglob('*.asy')}
    require(actual == {row['path'] for row in cases}, 'CORPUS-INVENTORY')
    for row in cases + data['bend']:
        path = Path(row['path'])
        require(not path.is_absolute() and '..' not in path.parts, 'CORPUS-PATH')
        require(digest(root / path) == row['sha256'], 'CORPUS-HASH ' + str(path))
        require(len((root / path).read_text().splitlines()) == row['lines'], 'CORPUS-LINES ' + str(path))
    require(len(data['bend']) == 6, 'BEND-COUNT')
    return data


def outputs(directory, row=None):
    require({p.name for p in directory.iterdir()} == FILES, 'FIVE-FILES')
    hashes = {name: digest(directory / name) for name in sorted(FILES)}
    for name in ('runtime.hex', 'init.hex'):
        require(re.fullmatch(r'(?:[0-9a-f]{2})+\n', (directory / name).read_text()) is not None,
                'OUTPUT-HEX ' + name)
    if row is not None:
        require(hashes == row['outputs'], 'OUTPUT-HASH ' + row['path'])
    return hashes

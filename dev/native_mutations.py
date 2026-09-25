"""Apply reviewed Bend mutations with exact declaration anchors."""
from pathlib import Path
import hashlib
import json
import shutil
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from bend_source import declarations


def load(script):
    name = Path(script).stem.removesuffix('-test')
    document = json.loads((Path(__file__).resolve().parent / 'mutations' / (name + '.json')).read_text())
    return document['cases']


def count(source, patches):
    records = {r.name: r for r in declarations(source, '<mutation>') if r.kind == 'def'}
    return int(bool(patches) and len({p['definition'] for p in patches}) == len(patches)
               and all(p['definition'] in records and hashlib.sha256(records[p['definition']].source.encode()).hexdigest() == p['sha256'] for p in patches))


def replace(source, patches, unused=None):
    if count(source, patches) != 1:
        raise ValueError('native mutation anchor changed or is missing')
    records = {r.name: r for r in declarations(source, '<mutation>') if r.kind == 'def'}
    for patch in patches:
        original = records[patch['definition']].source
        if source.count(original) != 1:
            raise ValueError('native mutation declaration is not unique')
        source = source.replace(original, patch['replacement'], 1)
    return source


def copy_project(root, target):
    result = shutil.copytree(root, target, ignore=shutil.ignore_patterns(
        '.*', '_build', '_typed_oracle', 'native', 'vendor', 'validation', '__pycache__'))
    copy_build(root, target)
    return result


def copy_build(root, target):
    # Scratch builds use the same pinned local compiler as the source checkout.
    # An explicit BEND setting still takes precedence in the builder.
    compiler = Path(root) / '.tools/bend'
    if compiler.is_dir():
        tools = Path(target) / '.tools'
        tools.mkdir(exist_ok=True)
        (tools / 'bend').symlink_to(compiler.resolve(), target_is_directory=True)
    # Seed only verified build products. The builder checks their input and
    # output digests before accepting them, including for restored controls.
    destination = Path(target) / '_build/bend'
    destination.mkdir(parents=True)
    for receipt in (Path(root) / '_build/bend').glob('*.json'):
        if receipt.stem not in ('assay', 'tests', 'backends') and not receipt.stem.startswith('test_'):
            continue
        output = receipt.with_suffix('.js')
        if receipt.exists() and output.exists():
            saved = json.loads(receipt.read_text())
            if hashlib.sha256(output.read_bytes()).hexdigest() != saved['output_sha256']:
                raise ValueError('baseline build receipt does not match output')
            cache = destination / 'cache' / saved['inputs_sha256']
            cache.parent.mkdir(exist_ok=True)
            shutil.copy2(receipt, cache.with_suffix('.json'))
            shutil.copy2(output, cache.with_suffix('.js'))
            shutil.copy2(receipt, destination / receipt.name)
            shutil.copy2(output, destination / output.name)
    for directory in ('bin', 'test'):
        source = Path(root) / '_build' / directory
        if source.is_dir():
            shutil.copytree(source, Path(target) / '_build' / directory, dirs_exist_ok=True)

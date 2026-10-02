"""Pin accepted CLI changes before comparing each historical CLI bundle.

Every listed declaration must match its digest and occur once in each input.
Restoring BASE bodies then leaves all other reachable CLI changes detectable.
"""
import hashlib
import json
from pathlib import Path
import subprocess

from bend_source import bundle, declarations, reachable

PINS = {
    'Lexer.ident_kind': '885331fd55467b8d6691413941c9ef60b74d616ed023c9ce330db4f4a9be8c7d',
    'Lexer.nat_of_digits': 'a9b94145490a45c9f0f48a7ee185b6d5fb2f7f258b81aa8aebcc6285ed07fbb9',
    'Lexer.go': '62a383370952042300dba1d35d5a60ed1df8f1aa7c04f158bb9435b1aeae097c',
    'Lexer.lex': '2806175b462bcf9062a7c0468519bb0a2bf1ea84e9628b5827c30b769fd569b9',
    'Contract.span': '2d90e0cb51fc9f93ea19367c3abb4920626bf24d23a8405052539b003e9b6fb2',
    'Recognize.identifier': '038f085f7238eada7da0d0ed000814cf76f5578a682a9158f918e38052ee5968',
    'Recognize.parse_word': '59e2fb372c8021f6d364d2941f87696640ba3ebf26a09571461ed9bb6ca823c1',
    'Model.segment': '2eba65ca9929ad97b158e4c5e0deb75cdc10d9a4eedbe5ed1c6cd97c3e509c09',
    'Trace.calldata': '4720188f3a75355bcb49e24bdfe1d3c5b45d27b0d5d9f8be4640bcdb7b8e1c65',
    'Trace.caller': 'a6b572114f5fbee3310f6ce88064e4c8dd9ab19bfec63e8e7a5b0318042b6a02',
    'Differential.caller': 'ddb671ef492592ec4ce0cd30b42742917eaf75b177069baacf3cb12125b04eec',
    'Trace.value': 'c64a9ea07854fe9e86c7e79f4b6d24a99c1e36d89b44ea3caf3c3db773cb37a1',
    'Trace.has_error': '555dfe081178faa255102ce03488d8aed8745fc373c7c9555524e772a2d4d802',
    # M2 source packing uses one typed source snapshot in these three adapters.
    # Semantic behavior is checked by packed-source-test.py. Exact pins preserve
    # detection of every other reachable change in the historical CLI bundles.
    'Cli.checked': 'adfee7b75ec603dacc4c0bc96310f1c99629bcb0c2b3979ba7176702cc2a41e5',
    'Cli.compile': '1f40dbef64eeb21857c8ba0e7664093a56a0332f07947219961fdf98cac65342',
    'Cli.run': '3f1ee1a1614debae113d863ef2e9e1077b3e2c33107d5983a0fd753fb982b4c2',
    # Mapping, event and calldata CLI tests check historical compatibility.
    'Cli.usage': '24d74361484dca689084886fbe24d0c9575e2ee250d411f93025650c380f054f',
    'Cli.dispatch': 'b51b6a661e15e6d8a56b25da96544f435393b2c027cc8a37a82b922b5221b078',
}
# Reports identify the complete pin manifest, with a stable serialization.
SHA256 = hashlib.sha256(json.dumps(PINS, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def only(rows, name):
    matches = [row for row in rows if row.kind == 'def' and row.name == name]
    return matches[0] if len(matches) == 1 else None


def pinned(base_rows, work_rows):
    """Restore the pinned bodies, or refuse missing, duplicate or modified bodies."""
    replacements = {}
    for name, digest in PINS.items():
        base, work = only(base_rows, name), only(work_rows, name)
        if base is None or work is None or hashlib.sha256(work.source.encode()).hexdigest() != digest:
            return None
        replacements[work.key] = base
    return [replacements.get(row.key, row) for row in work_rows]


def cli_sources(records, entry='Entry.Cli'):
    """Bundle BASE and pinned worktree rows. A failed pin gives None, which differs from each bundle."""
    rows = pinned(records[0], records[1])
    return [bundle(reachable(records[0], entry), entry),
            None if rows is None else bundle(reachable(rows, entry), entry)]


def source_records(root, base):
    """Read both source trees independently, retaining additions and deletions."""
    names = subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', base, '--', 'src'],
                                    cwd=root, text=True).splitlines()
    baseline = {name for name in names if name.endswith('.bend') and name != 'src/tests.bend'}
    current = {str(path.relative_to(root)) for path in (Path(root) / 'src').glob('*.bend')
               if path.name != 'tests.bend'}
    records = [[], []]
    for name in sorted(baseline | current):
        if name in baseline:
            text = subprocess.check_output(['git', 'show', base + ':' + name], cwd=root, text=True)
            records[0].extend(declarations(text, name))
        if name in current:
            records[1].extend(declarations((Path(root) / name).read_text(), name))
    return records

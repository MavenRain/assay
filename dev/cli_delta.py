"""Pin accepted CLI changes before comparing each historical CLI bundle.

Every listed worktree declaration must match its digest and occur once.
Restoring existing BASE bodies leaves other reachable CLI changes detectable.
Reviewed additions absent from an older BASE remain in the worktree bundle.
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
    'Cli.usage': '359dcca7a5736227c26359c2cccf11430e9b703c0df32317380fa62fbfdeca02',
    'Cli.dispatch': '708b9b7871a3f40d757af018bea22098938e4b8c62641661a7744c991fc60401',
    # Mapping runtime adds a plan to the source snapshot and excludes only
    # marked compiler temporaries from member counting. Semantic checks cover
    # ordinary identifiers, the user limit, packed programs and mapping access.
    'Case.Packed.switch_35': 'fd2d4ccc8f6ae628efc4f381d7b96771e508ff2e11fb24c0602b235424a3468c',
    'Case.Packed.switch_38': '6425d888ad1e134c26e28d451f01b102ffec8f668e7d88ebec2fa4a07b6e0676',
    'Case.Packed.switch_39': '81718f5956e21d6ceca6a9c4b1da46c5f6daeb59e6170ad3f37f8a6e4ef263b5',
    'Case.Packed.switch_40': '1f672130a9f1f27d6c76e22dec3cc749f310d0a94f6ca6a83223cff461915de7',
    'Case.Packed.switch_42': '35b679752a7683b0d64ddaa61f7bf9ae922c1409f919c61b536d1172faa97443',
    'Cli.Packed.Checked': '5c5e031fc16bd754c530ddfcb3c503b5d7e1f637f51311c413269c39ce429376',
    'Cli.Packed.Program': '4427c16a4382ce33da4a57ce90385aaf8054a8b6302cceaa3fcd4d7f2bad150b',
    'Cli.Packed.read_file': 'd122c2190d7a88d5777795bc7e0f10a3254a268d509afe416c2cd22153fb2214',
    'Contract.add_name': 'b0f9bc50ed5b13e863d6d663173672aa5c204e69bb5ecf0b66046c5a475cdd98',
}
# These helpers were introduced by source packing. Older baselines can lack
# them, but their current bodies remain pinned and any reachable addition
# still differs from the baseline bundle. A duplicate baseline is refused.
OPTIONAL_BASE = {
    'Case.Packed.switch_35', 'Case.Packed.switch_38', 'Case.Packed.switch_39',
    'Case.Packed.switch_40', 'Case.Packed.switch_42', 'Cli.Packed.Checked', 'Cli.Packed.Program',
    'Cli.Packed.read_file',
}
# Reports identify the complete pin manifest, with a stable serialization.
SHA256 = hashlib.sha256(json.dumps(dict(pins=PINS, optional_base=sorted(OPTIONAL_BASE)),
                                  sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def only(rows, name):
    matches = [row for row in rows if row.kind == 'def' and row.name == name]
    return matches[0] if len(matches) == 1 else None


def pinned(base_rows, work_rows):
    """Restore the pinned bodies, or refuse missing, duplicate or modified bodies."""
    replacements = {}
    for name, digest in PINS.items():
        base, work = only(base_rows, name), only(work_rows, name)
        if work is None or hashlib.sha256(work.source.encode()).hexdigest() != digest:
            return None
        if base is None:
            if name not in OPTIONAL_BASE or any(row.kind == 'def' and row.name == name for row in base_rows):
                return None
        else:
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

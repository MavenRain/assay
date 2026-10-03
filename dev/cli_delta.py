"""Pin accepted CLI changes before comparing each historical CLI bundle.

Every listed worktree declaration must match its digest and occur once.
A PINS declaration must also occur once in BASE, unless OPTIONAL_BASE names it.
A LATE_PINS declaration can be absent from BASE.
Restoring existing BASE bodies leaves other reachable CLI changes detectable.
Reviewed additions absent from an older BASE remain in the worktree bundle.
"""
import hashlib
import json
from pathlib import Path
import subprocess

from bend_source import bundle, declarations, reachable

PINS = {
    'Lexer.ident_kind': 'd8dcc229aacd2f4ff6d3593420d552af2cfb635325ab971951fd261d7590eeea',
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
    # M2 function ABI: Cli.run reads the source before it decodes the inputs.
    # Thus typed calldata uses the function ABI plan of that source.
    'Cli.run': '2033d214bcf2f42610b53ec4332a3ee0ba5944b5a3feaccc5fefc0d66249a671',
    # Mapping, event and calldata CLI tests check historical compatibility.
    'Cli.usage': '359dcca7a5736227c26359c2cccf11430e9b703c0df32317380fa62fbfdeca02',
    'Cli.dispatch': '708b9b7871a3f40d757af018bea22098938e4b8c62641661a7744c991fc60401',
    # Mapping runtime adds a plan to the source snapshot and excludes only
    # marked compiler temporaries from member counting. Semantic checks cover
    # ordinary identifiers, the user limit, packed programs and mapping access.
    # M2 function ABI: the source snapshot now carries
    # Mapping.Runtime.Plan.Functions, and Cli.Packed.read_file applies
    # FunctionAbi.lower. This changes switch_35, switch_38 and read_file.
    'Case.Packed.switch_35': '62a2a5565196f9e83b5fc8502cc666be07eef55e7a0ce1c32f7392d693d127ab',
    'Case.Packed.switch_38': 'f7f7c820748290405b4cc2da1012590f749f351ef5e803ca4df623d89b0ba67b',
    'Case.Packed.switch_39': '81718f5956e21d6ceca6a9c4b1da46c5f6daeb59e6170ad3f37f8a6e4ef263b5',
    'Case.Packed.switch_40': '1f672130a9f1f27d6c76e22dec3cc749f310d0a94f6ca6a83223cff461915de7',
    'Case.Packed.switch_42': '35b679752a7683b0d64ddaa61f7bf9ae922c1409f919c61b536d1172faa97443',
    'Cli.Packed.Checked': '5c5e031fc16bd754c530ddfcb3c503b5d7e1f637f51311c413269c39ce429376',
    'Cli.Packed.Program': '4427c16a4382ce33da4a57ce90385aaf8054a8b6302cceaa3fcd4d7f2bad150b',
    'Cli.Packed.read_file': '379e8310ecca19cf533319945c19abbb36c8b64588bcba1b9231b2c940725e16',
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
# The String-match workaround moves six String matches into _copy helpers.
# No BASE holds these helpers.
LATE_PINS = {
    'Lexer.ident_kind_copy': 'be4d71b5a6ff2fac7452f0c4fd4562ab8f5db3fa32ececbd62bcb1a026418410',
    'Cli.Call.typ_copy': '6b13cca96ef7bb47bcdcda2ce3a86c81144fada124c1372ea8fca4b4092ac55d',
    'Cli.Event.typ_copy': '150863038166455cdd560dabdf3a70e94a6a03e693c71b57f22d09b8fa2ea3a2',
    'Cli.EventDecode.typ_copy': '5a240e2845e163a068336140e67f636d1b272293ba47c89bc410fa55149be075',
    'Cli.Mapping.typ_copy': '18f964e5eb1b01799e4d3a285b6d9135a3a053002e2b1e8b8653b41b54fa96fa',
    'Cli.Mapping.boolean_copy': '31d5d0cebbae8673c49dd26df5e5286109ac96dce855225fe9c4f22163330910',
    # Only some BASEs hold these wrappers.
    # The BASE body replaces each wrapper that the BASE holds.
    'Cli.Call.typ': '31cff19e8e895ed62b22fecd29295b04202163c07192000ab63bd41b7df880a5',
    'Cli.Event.typ': '40473ba33635cb4eb99054c2eff14948903b4d51aab1f21253370e6e8b549823',
    'Cli.EventDecode.typ': 'd7a91f428b5c46e48eab80475fdc91fd774bc4676b7f887c99bcb9a8560c7504',
    'Cli.Mapping.typ': 'f19838a98a66e582fcd46c95460d53beeed66c2915454791a9a630f1e3a7c474',
    'Cli.Mapping.boolean': 'cc9fd7f80117f197b9b984f77dec459b83fdfa821d83207cbf727e851d4572de',
}
# Reports identify the complete pin manifest, with a stable serialization.
SHA256 = hashlib.sha256(json.dumps(dict(pins=PINS, late_pins=LATE_PINS, optional_base=sorted(OPTIONAL_BASE)),
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
    for name, digest in LATE_PINS.items():
        base, work = only(base_rows, name), only(work_rows, name)
        if work is None or hashlib.sha256(work.source.encode()).hexdigest() != digest:
            return None
        if base is not None:
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

#!/usr/bin/env python3
"""Check the revert gate extension and compiler reachability against the calldata base."""
from pathlib import Path
import contextlib
import hashlib
import io
import json
import re
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from bend_source import declarations
from carried_text import rewrite
from cli_delta import SHA256 as CLI_DELTA_SHA256, cli_sources, source_records

ROOT = Path(__file__).resolve().parent.parent
BASE = '5e00ee7'


def old(path):
    return subprocess.check_output(['git', 'show', BASE + ':' + path], cwd=ROOT, text=True)


def load(source):
    path = ROOT / 'dev/stage-a-gates.py'
    prefix = source.split('    work = root /', 1)[0]
    namespace = {'__file__': str(path), '__name__': 'schedule_probe'}
    exec(compile(prefix + '    return stage, legs, m1_names, recorded\n', str(path), 'exec'), namespace)
    return namespace


def schedule(namespace, mode):
    sys.argv = ['stage-a-gates.py'] + ([mode] if mode else [])
    stage, legs, classes, recorded = namespace['main']()
    return dict(stage=stage, legs=[(name, namespace['leg_deadline'](name, timeout, recorded), command, marker,
                                  name in classes) for name, timeout, command, marker in legs])


# User ruling M2-G8-D3 adds corpus/m2/ERC20.asy as a twelfth corpus row.
# Four carried markers count that row.
CORPUS_MARKERS = {
    'CORPUS cases=11 five_files=5 OK': 'CORPUS cases=12 five_files=5 OK',
    'DIFF-EXECUTOR live=20 driver=28 rejected=24 OK': 'DIFF-EXECUTOR live=21 driver=28 rejected=24 OK',
    'SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK':
        'SOURCE-MODEL counter=30 variants=10 corpus=12 invalid=28 refusals=6 mutants=8 OK',
    'LEXER-DIRECT cases=287 golden=4 mutants=3 rounds=5 OK': 'LEXER-DIRECT cases=288 golden=4 mutants=3 rounds=5 OK',
}


def historical_schedule(namespace, mode):
    """Apply the user's 2026-10-01 transfer of the two speed checks to M4.

    Also apply the user's ruling M2-G8-D3: CORPUS_MARKERS gives the
    current marker of the four legs that count the corpus rows.
    Only historical schedules are adjusted. Current schedules are compared
    unchanged, and milestone-speed-test.py independently checks the M4 owner.
    """
    result = schedule(namespace, mode)
    # fa19053 added the 14th stage-A mutant and 092fa7a the 15th. Thus the
    # carried MUTANTS marker is adjusted to the current count, as in
    # milestone-speed-test.py.
    # The three INFERRED legs now have an 1800 s deadline. The 128-step boundary
    # emits cost about 410 cpu s on the Bend host, and 600 s was too short.
    # D2 (group 10) adds the 23rd EMIT-CONSTRUCTORS case and closes the four
    # open M2-RECONCILE items, so both carried markers move with it.
    # D3 (ruling M2-G8-D3) adds the twelfth corpus row. CORPUS_MARKERS is
    # applied first, to the whole historical marker; the replacements follow.
    return dict(result, legs=[(leg[0], 3600 if leg[0] == "ADDRESS" else 1800 if leg[0].startswith("INFERRED-GUARD") or leg[0] == "INFERRED-BINDINGS"
                               else leg[1], leg[2], CORPUS_MARKERS.get(leg[3], leg[3])
                                   .replace('MUTANTS killed=13/13 OK', 'MUTANTS killed=15/15 OK')
                                   .replace("EMIT-CONSTRUCTORS cases=22 OK", "EMIT-CONSTRUCTORS cases=23 OK")
                                   .replace("deferred=9 tested=5 open=4", "deferred=9 tested=9 open=0"), *leg[4:])
                              for leg in result['legs']
                              if leg[0] not in ('BEND2-RATIO', 'BEND2-RATIO-TEST')])


def main():
    old_source = old('dev/stage-a-gates.py')
    before, after = load(old_source), load((ROOT / 'dev/stage-a-gates.py').read_text())
    modes = [''] + sorted(set(re.findall(r'"(--[a-z0-9-]+)"', old_source.split('    recorded, gaps, record_path =', 1)[0])))
    argv = sys.argv[:]
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            for mode in modes:
                assert historical_schedule(before, mode) == schedule(after, mode), mode
            committed = historical_schedule(before, '--m2-calldata')
            previous = schedule(after, '--m2-returndata')
            current = schedule(after, '--m2-revertdata')
    finally:
        sys.argv = argv
    assert previous['stage'] == 'M2-RETURNDATA'
    assert previous['legs'][:-1] == committed['legs']
    assert previous['legs'][-1] == ('RETURN-CODEC', 300, ('python3', '-P', 'dev/return-codec-test.py'),
                                   'RETURN-CODEC oracle=57 reference=45 negative=75 prefixes=288 refusal=13 mutants=10 scope=returndata OK', True)
    assert current['stage'] == 'M2-REVERTDATA'
    assert current['legs'][:-1] == previous['legs']
    assert current['legs'][-1][0] == 'REVERT-CODEC' and current['legs'][-1][-1]
    assert (ROOT / 'src/abi.bend').read_text().startswith(old('src/abi.bend'))
    # Later commits rewrote some carried test lines.
    # The check applies those rewrites to the BASE text first.
    carried = rewrite(old('src/tests.bend'))
    assert carried is not None and (ROOT / 'src/tests.bend').read_text().startswith(carried)
    assert (ROOT / 'dev/bend_source.py').read_text() == old('dev/bend_source.py')
    records = source_records(ROOT, BASE)
    sources = cli_sources(records)
    assert sources[0] == sources[1]
    report = dict(base=BASE, prior_modes=len(modes) + 1, new_checks=len(current['legs']),
                  appended=current['legs'][-1], existing_abi_and_tests='byte-identical prefixes',
                  cli_bundle='byte-identical', cli_bytes=len(sources[0].encode()),
                  cli_sha256=hashlib.sha256(sources[0].encode()).hexdigest(),
                  cli_delta_sha256=CLI_DELTA_SHA256)
    work = ROOT / '.gatework/revert-codec'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'compatibility.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'REVERT-COMPATIBILITY modes={len(modes) + 1} checks={len(current["legs"])} cli=identical OK')


if __name__ == '__main__':
    main()

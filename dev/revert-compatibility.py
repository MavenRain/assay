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


def historical_schedule(namespace, mode):
    """Apply the user's 2026-10-01 transfer of the two speed checks to M4.

    Only historical schedules are adjusted. Current schedules are compared
    unchanged, and milestone-speed-test.py independently checks the M4 owner.
    """
    result = schedule(namespace, mode)
    return dict(result, legs=[leg for leg in result['legs']
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
    for name in ('abi', 'tests'):
        assert (ROOT / 'src' / (name + '.bend')).read_text().startswith(old('src/' + name + '.bend'))
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

#!/usr/bin/env python3
"""Compare historical gate modes and compiler reachability with the calldata base."""
from pathlib import Path
import contextlib
import hashlib
import io
import json
import re
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from bend_source import bundle, declarations, reachable

ROOT = Path(__file__).resolve().parent.parent
BASE = '0cf7d20'


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


def main():
    old_source = old('dev/stage-a-gates.py')
    before, after = load(old_source), load((ROOT / 'dev/stage-a-gates.py').read_text())
    modes = [''] + sorted(set(re.findall(r'"(--[a-z0-9-]+)"', old_source.split('    recorded, gaps, record_path =', 1)[0])))
    argv = sys.argv[:]
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            for mode in modes:
                assert schedule(before, mode) == schedule(after, mode), mode
            previous = schedule(before, '--m2-events')
            current = schedule(after, '--m2-calldata')
    finally:
        sys.argv = argv
    assert current['stage'] == 'M2-CALLDATA'
    assert current['legs'][:-1] == previous['legs']
    assert current['legs'][-1][0] == 'CALL-CODEC' and current['legs'][-1][-1]
    for name in ('abi', 'tests'):
        assert (ROOT / 'src' / (name + '.bend')).read_text().startswith(old('src/' + name + '.bend'))
    assert (ROOT / 'dev/bend_source.py').read_text() == old('dev/bend_source.py')
    records = [[], []]
    for path in sorted((ROOT / 'src').glob('*.bend')):
        if path.name != 'tests.bend':
            name = str(path.relative_to(ROOT))
            records[0].extend(declarations(old(name), name))
            records[1].extend(declarations(path.read_text(), name))
    sources = [bundle(reachable(rows, 'Entry.Cli'), 'Entry.Cli') for rows in records]
    assert sources[0] == sources[1]
    report = dict(base=BASE, prior_modes=len(modes), new_checks=len(current['legs']),
                  appended=current['legs'][-1], existing_abi_and_tests='byte-identical prefixes',
                  cli_bundle='byte-identical', cli_bytes=len(sources[0].encode()),
                  cli_sha256=hashlib.sha256(sources[0].encode()).hexdigest())
    work = ROOT / '.gatework/call-codec'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'compatibility.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'CALL-COMPATIBILITY modes={len(modes)} checks={len(current["legs"])} cli=identical OK')


if __name__ == '__main__':
    main()

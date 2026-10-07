#!/usr/bin/env python3
"""Preserve prior gate schedules and compiler reachability while adding log decoding."""
from pathlib import Path
import argparse
import contextlib
import hashlib
import importlib.util
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
BASE = 'aa7517e'


def require(value, label):
    if not value:
        raise ValueError(label)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--base-repo', type=Path, default=ROOT, help='history source for archive-only validation copies')
    args = parser.parse_args()

    def old(path):
        return subprocess.check_output(['git', '-C', str(args.base_repo), 'show', BASE + ':' + path], text=True)

    spec = importlib.util.spec_from_file_location('schedule_helpers', ROOT / 'dev/revert-compatibility.py')
    helpers = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(helpers)
    old_source = old('dev/stage-a-gates.py')
    before, after = helpers.load(old_source), helpers.load((ROOT / 'dev/stage-a-gates.py').read_text())
    modes = [''] + sorted(set(re.findall(r'"(--[a-z0-9-]+)"', old_source.split('    recorded, gaps, record_path =', 1)[0])))
    argv = sys.argv[:]
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            for mode in modes:
                require(helpers.historical_schedule(before, mode) == helpers.schedule(after, mode), 'MODE ' + mode)
            previous = helpers.historical_schedule(before, '--m2-revertdata')
            current = helpers.schedule(after, '--m2-event-decode')
    finally:
        sys.argv = argv
    require(current['stage'] == 'M2-EVENT-DECODE', 'STAGE')
    require(current['legs'][:-1] == previous['legs'], 'PRIOR-LEGS')
    require(current['legs'][-1] == ('EVENT-DECODE', 300, ('python3', '-P', 'dev/event-decode-test.py'),
            'EVENT-DECODE oracle=71 reference=21 negative=59 refusal=8 mutants=12 scope=event-decode OK', True), 'NEW-LEG')
    require((ROOT / 'src/abi.bend').read_text().startswith(old('src/abi.bend')), 'PREFIX src/abi.bend')
    # Later commits rewrote some carried test lines.
    # The check applies those rewrites to the BASE text first.
    carried = rewrite(old('src/tests.bend'))
    require(carried is not None and (ROOT / 'src/tests.bend').read_text().startswith(carried),
            'PREFIX src/tests.bend')
    require((ROOT / 'dev/bend_source.py').read_text() == old('dev/bend_source.py'), 'BUNDLER')
    records = source_records(ROOT, BASE)
    sources = cli_sources(records)
    require(sources[0] == sources[1], 'CLI-BUNDLE')
    report = dict(base=BASE, prior_modes=len(modes), new_checks=len(current['legs']),
                  appended=current['legs'][-1], existing_abi_and_tests='byte-identical prefixes',
                  cli_bundle='byte-identical', cli_bytes=len(sources[0].encode()),
                  cli_sha256=hashlib.sha256(sources[0].encode()).hexdigest(),
                  cli_delta_sha256=CLI_DELTA_SHA256)
    work = ROOT / '.gatework/event-decode'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'compatibility.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'EVENT-DECODE-COMPATIBILITY modes={len(modes)} checks={len(current["legs"])} cli=identical OK')


if __name__ == '__main__':
    main()

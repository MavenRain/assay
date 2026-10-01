#!/usr/bin/env python3
"""Preserve the keyword-dispatch predecessor's schedules and all other CLI bodies."""
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
from cli_delta import SHA256 as CLI_DELTA_SHA256, cli_sources

ROOT = Path(__file__).resolve().parent.parent
BASE = '82f14761406f4d0cd383f284250d708595a4988e'


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
                require(helpers.schedule(before, mode) == helpers.schedule(after, mode), 'MODE ' + mode)
            previous = helpers.schedule(before, '--keyword-dispatch')
            current = helpers.schedule(after, '--lexer-direct')
    finally:
        sys.argv = argv
    require(current['stage'] == 'LEXER-DIRECT', 'STAGE')
    require(current['legs'][:-7] == previous['legs'], 'PRIOR-LEGS')
    require(current['legs'][-7] == ('LEXER-DIRECT', 600, ('python3', '-P', 'dev/lexer-direct-test.py'),
            'LEXER-DIRECT cases=287 golden=4 mutants=3 rounds=5 OK', True), 'NEW-LEG')
    require(current['legs'][-6] == ('IDENTIFIER-DIRECT', 600,
            ('python3', '-P', 'dev/identifier-direct-test.py'),
            'IDENTIFIER-DIRECT cases=1043 golden=1043 mutants=2 OK', True), 'IDENTIFIER-LEG')
    require(current['legs'][-5] == ('WORD-DIRECT', 600,
            ('python3', '-P', 'dev/word-direct-test.py'),
            'WORD-DIRECT cases=1580 golden=1580 mutants=3 OK', True), 'WORD-LEG')
    require(current['legs'][-4] == ('SEGMENT-DIRECT', 600,
            ('python3', '-P', 'dev/segment-direct-test.py'),
            'SEGMENT-DIRECT cases=1348 golden=1348 mutants=3 OK', True), 'SEGMENT-LEG')
    require(current['legs'][-3] == ('CLI-PREFIX-DIRECT', 600,
            ('python3', '-P', 'dev/cli-prefix-direct-test.py'),
            'CLI-PREFIX-DIRECT cases=2184 golden=2184 mutants=9 OK', True), 'CLI-PREFIX-LEG')
    require(current['legs'][-2] == ('CLI-VALUE-DIRECT', 600,
            ('python3', '-P', 'dev/cli-value-direct-test.py'),
            'CLI-VALUE-DIRECT cases=872 golden=872 mutants=3 OK', True), 'CLI-VALUE-LEG')
    require(current['legs'][-1] == ('CLI-ERROR-DIRECT', 600,
            ('python3', '-P', 'dev/cli-error-direct-test.py'),
            'CLI-ERROR-DIRECT cases=519 golden=519 mutants=5 OK', True), 'CLI-ERROR-LEG')
    for path in ('src/abi.bend', 'src/tests.bend'):
        require((ROOT / path).read_text() == old(path), 'UNCHANGED ' + path)
    require((ROOT / 'dev/bend_source.py').read_text() == old('dev/bend_source.py'), 'BUNDLER')
    records = [[], []]
    for path in sorted((ROOT / 'src').glob('*.bend')):
        if path.name != 'tests.bend':
            name = str(path.relative_to(ROOT))
            records[0].extend(declarations(old(name), name))
            records[1].extend(declarations(path.read_text(), name))
    sources = cli_sources(records)
    require(sources[0] == sources[1], 'CLI-BUNDLE')
    report = dict(base=BASE, prior_modes=len(modes), new_checks=len(current['legs']),
                  appended=current['legs'][-7:], existing_abi_and_tests='byte-identical',
                  cli_bundle='byte-identical', cli_bytes=len(sources[0].encode()),
                  cli_sha256=hashlib.sha256(sources[0].encode()).hexdigest(),
                  cli_delta_sha256=CLI_DELTA_SHA256)
    work = ROOT / '.gatework/lexer-direct'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'compatibility.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'LEXER-DIRECT-COMPATIBILITY modes={len(modes)} checks={len(current["legs"])} cli=identical OK')


if __name__ == '__main__':
    main()

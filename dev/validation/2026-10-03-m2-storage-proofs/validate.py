#!/usr/bin/env python3
"""Reproduce the M2 storage record from the tree with the pinned compiler.

Run from any directory:

    python3 -P dev/validation/2026-10-03-m2-storage-proofs/validate.py run
    python3 -P dev/validation/2026-10-03-m2-storage-proofs/validate.py seal

`run` executes the six regression suites one at a time with the compiler
in `.tools/bend` (its checkout must sit at the commit in dev/toolchain.json),
checks the gate inventory against the fixed base commit, and regenerates
REGRESSIONS.json, SUMMARY.json, GATE-INTEGRATION.json, EVIDENCE.tar.gz,
SOURCES.json and FILES.sha256. `seal` recomputes only SOURCES.json and
FILES.sha256, for use after a prose edit to README.md.
"""
from pathlib import Path
import gzip
import hashlib
import json
import os
import re
import subprocess
import sys
import tarfile
import tempfile
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BASELINE = '7ec1b8ac4110d4f4dd070b81f02fad9b033d08c9'
COMPILER = ROOT / '.tools/bend/bin/bend'
WORK = ROOT / '_build/storage-proofs'
TESTS = [('storage-proof', 600), ('milestone-speed', 120), ('source-proof', 900),
         ('layout-packed', 300), ('packed-source', 600), ('mapping-runtime', 900)]
SOURCES = ['Makefile', 'README.md', 'dev/ASSAY-M2-BUILD-LOG.md', 'dev/DENOMINATORS.sha256',
           'dev/LEXER-DIRECT.md', 'dev/M1-BEND2.md', 'dev/M1-CLOSE.md', 'dev/M2-ABI-CODEC.md',
           'dev/M2-ABI-SCHEMA.md', 'dev/M2-EVENT-DECODE.md', 'dev/M2-MAPPING.md',
           'dev/M2-PACKING.md', 'dev/M2-REFERENCE.md', 'dev/M2-RETURN-ABI.md',
           'dev/M2-REVERTDATA.md', 'dev/M2-SOURCE-EVENTS.md', 'dev/M2-STORAGE-PROOFS.md', 'dev/MILESTONE-GROUPS.md',
           'dev/build.py', 'dev/gates.sh', 'dev/layout-packed-test.py',
           'dev/mapping-runtime-test.py', 'dev/milestone-speed-test.py',
           'dev/packed-source-test.py', 'dev/source-proof-test.py', 'dev/stage-a-gates.py',
           'dev/storage-proof-test.py', 'dev/toolchain.json', 'examples/MappingAccess.asy',
           'src/layout.bend', 'verification/AssayProofs.lean',
           'verification/AssayProofs/Arithmetic.lean', 'verification/AssayProofs/Source.lean',
           'verification/AssayProofs/Storage.lean', 'verification/StorageAxioms.lean',
           'verification/StorageMain.lean', 'verification/lakefile.lean',
           'verification/lean-toolchain']
ABSOLUTE = re.compile(rb'/(?:Users|home|private|tmp|opt|var)/[^\s"\'\\,\]\)]*')


def fail(message):
    print('STORAGE-RECORD ' + message, flush=True)
    sys.exit(1)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git(*argv, cwd=ROOT):
    return subprocess.check_output(['git', *argv], cwd=cwd, text=True).strip()


def compiler_pin():
    pin = json.loads((ROOT / 'dev/toolchain.json').read_text())['bend']['commit']
    if not COMPILER.is_file():
        fail('missing compiler ' + str(COMPILER.relative_to(ROOT)))
    commit = git('rev-parse', 'HEAD', cwd=COMPILER.parents[1])
    if commit != pin:
        fail(f'.tools/bend is at {commit}, dev/toolchain.json pins {pin}')
    return pin


def marker(text):
    lines = [line for line in text.splitlines() if line.strip()]
    return lines[-1] if lines else ''


def suite(name, deadline, env):
    command = ['python3', '-P', f'dev/{name}-test.py']
    started = time.monotonic()
    print('RUN ' + name, flush=True)
    try:
        result = subprocess.run([sys.executable, *command[1:]], cwd=ROOT, env=env,
                                capture_output=True, text=True, timeout=deadline)
        row = dict(name=name, command=command, exit=result.returncode, marker=marker(result.stdout),
                   stdout=result.stdout, stderr=result.stderr, seconds=time.monotonic() - started)
    except subprocess.TimeoutExpired as error:
        row = dict(name=name, command=command, exit=None, timeout=True, marker='',
                   stdout=str(error.stdout or ''), stderr=str(error.stderr or ''),
                   seconds=time.monotonic() - started)
    print(json.dumps({key: row[key] for key in ('name', 'exit', 'marker', 'seconds')}), flush=True)
    return row


def regressions():
    env = os.environ | {'BEND': str(COMPILER)}
    rows = []
    for name, deadline in TESTS:
        rows.append(suite(name, deadline, env))
        (HERE / 'REGRESSIONS.json').write_text(json.dumps(rows, indent=2) + '\n')
        if rows[-1]['exit'] != 0:
            print(rows[-1]['stdout'][-2000:] + rows[-1]['stderr'][-2000:], flush=True)
            fail(name + ' failed')
    return rows


def gate_integration():
    subprocess.run([sys.executable, '-P', str(HERE / 'check-gate-integration.py'), '--write'],
                   cwd=ROOT, check=True)


def summary(rows):
    counts = json.loads((WORK / 'SUMMARY.json').read_text())
    expected = 'STORAGE-PROOFS ' + ' '.join(f'{key}={value}' for key, value in counts.items()) + ' OK'
    if rows[0]['marker'] != expected:
        fail('SUMMARY.json does not match the storage-proof marker')
    (HERE / 'SUMMARY.json').write_text(json.dumps(counts, indent=2) + '\n')


def anonymous(info):
    info.uid = info.gid = 0
    info.uname = info.gname = ''
    info.mtime = 0
    return info


def foreign_paths(archive):
    allowed = (str(ROOT), tempfile.gettempdir(), '/private' + tempfile.gettempdir())
    with tarfile.open(archive, 'r:gz') as tar:
        members = [tar.extractfile(member).read() for member in tar.getmembers() if member.isfile()]
    found = {match.decode(errors='replace') for text in members for match in ABSOLUTE.findall(text)}
    return sorted(path for path in found if not path.startswith(allowed))


def evidence():
    target = HERE / 'EVIDENCE.tar.gz'
    files = sorted(path for path in WORK.rglob('*') if path.is_file())
    with gzip.GzipFile(filename='', fileobj=target.open('wb'), mode='wb', mtime=0) as stream:
        with tarfile.open(fileobj=stream, mode='w', format=tarfile.GNU_FORMAT) as tar:
            for path in files:
                tar.add(path, arcname='storage-proofs/' + str(path.relative_to(WORK)), filter=anonymous)
    foreign = foreign_paths(target)
    if foreign:
        fail('EVIDENCE.tar.gz holds paths outside the tree: ' + ' '.join(foreign[:8]))


def sources(pin):
    provenance = dict(base=BASELINE, sources_sha256={name: sha256(ROOT / name) for name in SOURCES},
                      bend_commit=pin, bend_binary_sha256=sha256(COMPILER),
                      python=sys.version.split()[0])
    (HERE / 'SOURCES.json').write_text(json.dumps(provenance, indent=2) + '\n')


def seal():
    sources(compiler_pin())
    rows = [(path.name, sha256(path)) for path in sorted(HERE.iterdir())
            if path.is_file() and path.name != 'FILES.sha256']
    (HERE / 'FILES.sha256').write_text(''.join(f'{digest}  {name}\n' for name, digest in rows))
    print(f'STORAGE-RECORD sealed files={len(rows)} sources={len(SOURCES)}', flush=True)


def run():
    pin = compiler_pin()
    rows = regressions()
    gate_integration()
    summary(rows)
    evidence()
    sources(pin)
    seal()
    print(f'STORAGE-RECORD suites={len(rows)} OK', flush=True)


if __name__ == '__main__':
    mode = sys.argv[1] if len(sys.argv) > 1 else 'run'
    {'run': run, 'seal': seal}.get(mode, lambda: fail('unknown mode ' + mode))()

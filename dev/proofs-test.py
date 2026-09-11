#!/usr/bin/env python3
"""Check the byte-exact proof seed and its complete carried axiom report."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import sys


def require(ok, message):
    if not ok:
        raise ValueError(message)


def report_ok(text, names):
    lines = text.splitlines()
    parsed = [re.fullmatch(r"'([^']+)' depends on axioms: \[([^\]]*)\]", line) for line in lines]
    if not all(parsed) or [row.group(1) for row in parsed] != names:
        return False
    permitted = {'propext', 'Classical.choice', 'Quot.sound'}
    return all(set(filter(None, row.group(2).split(', '))) <= permitted for row in parsed)


def main():
    root = Path(__file__).resolve().parent.parent
    manifest = json.loads((root / 'dev/PROOFS-PIN.json').read_text())
    sources = manifest['sources']
    require(manifest['commit'] == 'af81c541d394bd5d7477cf35e9f4021dc1a95539' and len(sources) == 28, 'PROOF-PIN')
    for path, expected in sources.items():
        require(path.startswith('proofs/') and '..' not in Path(path).parts, 'PROOF-PATH')
        require(hashlib.sha256((root / path).read_bytes()).hexdigest() == expected, 'PROOF-CARRY ' + path)
    paths = subprocess.run(['rg', '--files', '--hidden', 'proofs', '-g', '!.lake', '-g', '!.kanon-exec', '-g', '!.kanon-wait'],
                           cwd=root, capture_output=True, text=True, check=True).stdout.splitlines()
    require(set(paths) == set(sources), 'PROOF-CARRY extra or missing sources')
    names = re.findall(r'^#print axioms (\S+)$', (root / 'proofs/Axioms.lean').read_text(), re.MULTILINE)
    require(len(names) == 42 and len(set(names)) == len(names), 'AXIOMS-INVENTORY')
    if shutil.which('elan') is None:
        print(f'AXIOMS SKIP elan absent carried_files={len(sources)}')
        return 0
    # Review round 2026-09-10 (B-2):  one require per tool, so the message
    # names the tool that is missing.
    require(shutil.which('lake') is not None, 'AXIOMS missing lake')
    require(shutil.which('leancho') is not None, 'AXIOMS missing leancho, see dev/TOOLCHAIN.md')
    # Provisioning stays with the user.  No network fetch is initiated here.
    deps = json.loads((root / 'proofs/lake-manifest.json').read_text())['packages']
    for row in deps:
        name = row['name'].strip('«»')
        path = root / 'proofs/.lake/packages' / name
        require(path.is_dir(), 'AXIOMS missing preprovisioned dependency: ' + name
                + ', see the offline provisioning recipe in dev/TOOLCHAIN.md')
        revision = subprocess.run(['git', '-C', str(path), 'rev-parse', 'HEAD'], capture_output=True, text=True, check=True).stdout.strip()
        require(revision == row['rev'], 'AXIOMS dependency revision: ' + name)
    work = root / '.gatework'
    work.mkdir(exist_ok=True)
    build = subprocess.run(['leancho', '-C', str(root / 'proofs')], capture_output=True, text=True, timeout=300)
    (work / 'proof-build.log').write_text(build.stdout + build.stderr)
    require(build.returncode == 0 and '0 errors, 0 sorries, 0 warnings' in build.stdout, 'AXIOMS-BUILD')
    result = subprocess.run(['lake', 'env', 'lean', 'Axioms.lean'], cwd=root / 'proofs', capture_output=True, text=True, timeout=120)
    (work / 'proof-report.log').write_text(result.stdout + result.stderr)
    require(result.returncode == 0 and not result.stderr and report_ok(result.stdout, names), 'AXIOMS-REPORT')
    # Review round 2026-09-10 (A-1):  the report controls are collected and
    # counted, so removing one moves the printed number.
    controls = [
        ('AXIOMS-SORRY mutant survived', result.stdout.replace('[propext', '[sorryAx, propext', 1)),
        ('AXIOMS-MISSING mutant survived', '\n'.join(result.stdout.splitlines()[1:]) + '\n'),
        ('AXIOMS-DUPLICATE mutant survived', result.stdout + result.stdout.splitlines()[0] + '\n'),
    ]
    for label, mutant in controls:
        require(not report_ok(mutant, names), label)
    print(f'AXIOMS sorryAx=0 theorems={len(names)} carried_files={len(sources)} controls={len(controls)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('AXIOMS FAIL ' + str(error))
        sys.exit(1)

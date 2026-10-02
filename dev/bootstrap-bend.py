#!/usr/bin/env python3
"""Fetch and build only the compiler revision pinned by this project."""
from pathlib import Path
import argparse
import json
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
pin = json.loads((ROOT / 'dev/toolchain.json').read_text())['bend']
checkout = ROOT / '.tools/bend'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--upgrade', action='store_true', help='move a clean existing checkout to the pinned revision')
    args = parser.parse_args()
    bun = shutil.which('bun')
    if not bun:
        raise ValueError('Bun is required to build the pinned Bend compiler')
    if not checkout.exists():
        checkout.parent.mkdir(exist_ok=True)
        subprocess.run(['git', 'clone', '--filter=blob:none', '--no-checkout', pin['repository'], str(checkout)], check=True)
        subprocess.run(['git', '-C', str(checkout), 'checkout', '--detach', pin['commit']], check=True)
    revision = subprocess.run(['git', '-C', str(checkout), 'rev-parse', 'HEAD'], capture_output=True, text=True, check=True).stdout.strip()
    if revision != pin['commit']:
        if not args.upgrade:
            raise ValueError('existing .tools/bend has a different revision; run with --upgrade or set BEND to the pinned checkout')
        changes = subprocess.run(['git', '-C', str(checkout), 'status', '--porcelain', '--untracked-files=no'], capture_output=True, text=True, check=True).stdout
        if changes:
            raise ValueError('refusing to upgrade .tools/bend with tracked local changes')
        subprocess.run(['git', '-C', str(checkout), 'fetch', '--depth', '1', pin['repository'], pin['commit']], check=True)
        subprocess.run(['git', '-C', str(checkout), 'checkout', '--detach', pin['commit']], check=True)
        revision = subprocess.run(['git', '-C', str(checkout), 'rev-parse', 'HEAD'], capture_output=True, text=True, check=True).stdout.strip()
        if revision != pin['commit']:
            raise ValueError('upgraded .tools/bend does not match the pinned revision')
    (checkout / 'bin').mkdir(exist_ok=True)
    subprocess.run([bun, 'build', '--compile', '--minify', 'bend2/main.ts', '--outfile', 'bin/bend'], cwd=checkout, check=True)
    print('BEND TOOLCHAIN ' + pin['version'] + ' ' + revision)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'BEND TOOLCHAIN FAIL: {error}', file=sys.stderr)
        raise SystemExit(1)

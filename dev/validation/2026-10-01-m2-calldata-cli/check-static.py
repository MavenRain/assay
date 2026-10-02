"""Run the carried static gates and confirm default schedule ownership."""
from pathlib import Path
import subprocess
import sys

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m2-calldata-cli')
commands = [[sys.executable, '-P', 'dev/carry-check.py'],
            ['zsh', '-f', 'dev/r0-count.sh'],
            ['zsh', '-f', 'dev/r0-audit.sh'],
            ['zsh', '-f', 'dev/house.sh'],
            ['zsh', '-f', 'dev/trusted-lines.sh'],
            [sys.executable, '-P', 'dev/milestone-speed-test.py']]
for command in commands:
    result = subprocess.run(command,
                            cwd=ROOT, capture_output=True, text=True, timeout=90)
    print(result.stdout, end='', flush=True)
    if result.returncode or result.stderr:
        print(result.stderr, end='', file=sys.stderr)
        raise SystemExit(result.returncode or 1)
result = subprocess.run(['shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256'],
                        cwd=ROOT, capture_output=True, text=True, timeout=30)
if result.returncode or result.stderr:
    print(result.stdout, end='')
    print(result.stderr, end='', file=sys.stderr)
    raise SystemExit(result.returncode or 1)
print('DENOMINATORS all-pins=OK')
result = subprocess.run(['git', 'diff', '--check'], cwd=ROOT,
                        capture_output=True, text=True, timeout=30)
if result.returncode or result.stderr:
    print(result.stdout, end='')
    print(result.stderr, end='', file=sys.stderr)
    raise SystemExit(result.returncode or 1)
print('STATIC-GATES OK')

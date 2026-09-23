from pathlib import Path
import subprocess

ROOT = Path('/Users/oobi/Documents/gpt1/assay-m2-abi-codec')
for command in [
    ['shasum', '-a', '256', '-c', 'dev/DENOMINATORS.sha256'],
    ['zsh', '-f', 'dev/house.sh'],
    ['python3', '-P', 'dev/trusted-lines.py', str(ROOT)],
    ['python3', '-P', 'dev/bend2-ratio.py'],
    ['git', 'diff', '--check'],
]:
    subprocess.run(command, cwd=ROOT, check=True)
print('FINAL-CHECKS source-pins=152 HOUSE=OK budgets=OK speed=OK whitespace=OK')

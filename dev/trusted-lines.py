#!/usr/bin/env python3
"""Count native source, including all kernel support, against ratified limits."""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from bend_source import declarations, identifiers

KERNEL_BOUND = 4000
ARTIFACTS = {'emitter': 1800, 'assembler': 600, 'keccak': 250, 'abi': 400, 'layout': 250, 'listing': 250}
RATIFIED_TOTAL = 3550
SOURCES = {'kernel', 'frontend', 'cli', 'tests'} | ARTIFACTS.keys()


def check(root):
    good = True
    counts = {}
    symbols = {}
    records = []
    for name in sorted(SOURCES):
        path = root / 'src' / (name + '.bend')
        if not path.is_file() or path.is_symlink():
            print(f'TRUSTED-LINES missing=src/{name}.bend FAIL')
            good = False
            continue
        counts[name] = path.read_bytes().count(b'\n')
        for record in declarations(path.read_text(), path.relative_to(root)):
            if record.kind != 'law':
                symbols[record.name] = name
                records.append((name, record))
    allowed_paths = {root / 'src' / (name + '.bend') for name in SOURCES} | {root / 'src/os.js', root / 'src/test-os.js'}
    for path in (root / 'src').rglob('*'):
        if path.is_file() and path not in allowed_paths:
            print('TRUSTED-LINES unpriced=' + str(path.relative_to(root)))
            good = False
    for name, bound in {'kernel': KERNEL_BOUND, **ARTIFACTS}.items():
        count = counts.get(name, 0)
        print(f'TRUSTED-LINES {name}={count}/{bound}')
        good = good and 0 < count <= bound
    # Shared support is charged to the kernel. Its dependencies stay there.
    # Artifact implementations cannot hide logic in the CLI or tests.
    for owner, record in records:
        for dependency in identifiers(record.source) & symbols.keys():
            other = symbols[dependency]
            illegal = owner == 'kernel' and other != 'kernel'
            illegal |= owner in ARTIFACTS and other in ('cli', 'tests')
            illegal |= owner == 'cli' and other == 'tests'
            if illegal:
                print(f'TRUSTED-LINES boundary FAIL: {record.name} -> {dependency} ({other})')
                good = False
    total = sum(counts.get(name, 0) for name in ARTIFACTS)
    print(f'TRUSTED-LINES total={total}/{sum(ARTIFACTS.values())} ratified={RATIFIED_TOTAL}')
    good = good and sum(ARTIFACTS.values()) == RATIFIED_TOTAL
    print('TRUSTED-LINES ' + ('OK' if good else 'FAIL'))
    return 0 if good else 1


if __name__ == '__main__':
    try:
        raise SystemExit(check(Path(sys.argv[1]).resolve()))
    except (OSError, ValueError) as error:
        print(f'TRUSTED-LINES FAIL: {error}')
        raise SystemExit(1)

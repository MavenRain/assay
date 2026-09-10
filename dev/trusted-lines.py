#!/usr/bin/env python3
"""Measure the inherited kernel and all six assay artifact budgets."""

from pathlib import Path
import sys

KERNEL = "shape term rules check value eval conv totality positivity global order bignum".split()
ARTIFACTS = (
    ("emitter", 1800, "emit", ("emit.ml", "recognize.ml")),
    ("assembler", 600, "asm", ("asm.ml",)),
    ("keccak", 250, "keccak", ("keccak.ml",)),
    ("abi", 400, "abi", ("abi.ml",)),
    ("layout", 250, "abi", ("layout.ml",)),
    ("listing", 250, "asm", ("listing.ml",)),
)


def lines(path):
    return path.read_bytes().count(b"\n")


KERNEL_WANT = 3997
KERNEL_BOUND = 4000
RATIFIED_TOTAL = 3550  # R-M0-3: the six artifact rows sum to the printed total.


def check(root):
    counts = {name: lines(root / "lib" / (name + ".ml")) for name in KERNEL}
    kernel = sum(counts.values())
    good = kernel == KERNEL_WANT
    print(f"TRUSTED-LINES kernel={kernel} want={KERNEL_WANT} bound={KERNEL_BOUND}")
    if not good:
        print(f"TRUSTED-LINES kernel FAIL: the carried kernel must stay at "
              f"{KERNEL_WANT} lines, and it measures {kernel}")
        for name, count in sorted(counts.items()):
            print(f"TRUSTED-LINES kernel-file lib/{name}.ml={count}")
    owners = set()
    measured = 0
    for name, bound, folder, names in ARTIFACTS:
        paths = [root / folder / source for source in names]
        owners.update(paths)
        present = [path for path in paths if path.exists()]
        if not present:
            print(f"TRUSTED-LINES {name}=N/{bound} pending")
        elif len(present) != len(paths):
            print(f"TRUSTED-LINES {name}=INCOMPLETE/{bound} FAIL")
            good = False
        else:
            count = sum(lines(path) for path in paths)
            print(f"TRUSTED-LINES {name}={count}/{bound}")
            measured += count
            good = good and count <= bound
    budget = sum(bound for _name, bound, _folder, _names in ARTIFACTS)
    print(f"TRUSTED-LINES total={measured}/{budget} ratified={RATIFIED_TOTAL}")
    if budget != RATIFIED_TOTAL:
        print(f"TRUSTED-LINES total FAIL: the six artifact bounds sum to "
              f"{budget} and R-M0-3 ratifies {RATIFIED_TOTAL}")
        good = False
    for folder in ("emit", "asm", "keccak", "abi"):
        for path in (root / folder).rglob("*.ml*"):
            if path not in owners:
                print("TRUSTED-LINES unpriced=" + str(path.relative_to(root)))
                good = False
    print("TRUSTED-LINES " + ("OK" if good else "FAIL"))
    return 0 if good else 1


if __name__ == "__main__":
    try:
        sys.exit(check(Path(sys.argv[1]).resolve()))
    except OSError as error:
        print(f"TRUSTED-LINES FAIL: {error}")
        sys.exit(1)

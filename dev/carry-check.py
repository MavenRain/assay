#!/usr/bin/env python3
"""Check the fixed upstream pin and the complete inherited source inventory."""

from pathlib import Path
import subprocess
import sys

PIN = "2c2e6e6831a0b2cf3107fa4aad392606109a2bcf"


def git(root, *args):
    return subprocess.run(["git", "-C", str(root), *args],
                          capture_output=True, check=True).stdout


def check(root):
    if (root / "dev/PIN").read_bytes() != (PIN + "\n").encode():
        print("PIN FAIL: dev/PIN differs from the fixed upstream commit")
        return 1
    git(root, "merge-base", "--is-ancestor", PIN, "HEAD")
    print("PIN " + PIN)
    expected = set(git(root, "ls-tree", "-r", "--name-only", PIN,
                       "--", "lib", "surface").decode().splitlines())
    actual = {str(path.relative_to(root)) for folder in ("lib", "surface")
              for path in (root / folder).rglob("*")
              if path.is_file() or path.is_symlink()}
    changed = [name for name in sorted(expected & actual)
               if (root / name).is_symlink()
               or (root / name).read_bytes() != git(root, "show", PIN + ":" + name)]
    missing = sorted(expected - actual)
    extra = sorted(actual - expected)
    for name in changed:
        print("CARRY changed " + name)
    for name in missing:
        print("CARRY missing " + name)
    for name in extra:
        print("CARRY extra " + name)
    compared = len(expected & actual)
    print(f"CARRY files={compared}/{len(expected)} diff={len(changed)} "
          f"unlisted={len(missing) + len(extra)}")
    return int(bool(changed or missing or extra))


if __name__ == "__main__":
    try:
        root = Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else Path(__file__).resolve().parent.parent
        sys.exit(check(root))
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"CARRY FAIL: {error}")
        sys.exit(1)

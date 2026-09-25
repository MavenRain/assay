#!/usr/bin/env python3
"""Check upstream provenance and the complete native kernel inventory."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys

PIN = "2c2e6e6831a0b2cf3107fa4aad392606109a2bcf"


def check(root):
    if (root / "dev/PIN").read_text() != PIN + "\n":
        print("PIN FAIL: dev/PIN differs from the fixed upstream commit")
        return 1
    subprocess.run(["git", "-C", str(root), "merge-base", "--is-ancestor", PIN, "HEAD"],
                   check=True, capture_output=True)
    manifest = json.loads((root / "dev/native-carry.json").read_text())
    if manifest["upstream_commit"] != PIN:
        print("PIN FAIL: native carry manifest has different provenance")
        return 1
    expected = set(manifest["inventory"])
    actual = {str(path.relative_to(root)) for path in (root / "src").rglob("*")
              if path.is_file() or path.is_symlink()}
    carried = manifest["carried"]
    present = sorted(expected & actual)
    unhashed = [name for name in present if name not in carried]
    changed = [name for name in present if name in carried
               and ((root / name).is_symlink()
                    or hashlib.sha256((root / name).read_bytes()).hexdigest() != carried[name])]
    missing, extra = sorted(expected - actual), sorted(actual - expected)
    stray = sorted(set(carried) - expected)
    for name in changed:
        print("CARRY changed " + name)
    for name in missing:
        print("CARRY missing " + name)
    for name in extra:
        print("CARRY extra " + name)
    for name in unhashed:
        print("CARRY unhashed " + name)
    for name in stray:
        print("CARRY unlisted-hash " + name)
    print("PIN " + PIN)
    print(f"CARRY files={len(present)}/{len(expected)} diff={len(changed)} "
          f"unlisted={len(missing) + len(extra) + len(stray)}")
    return int(bool(changed or missing or extra or unhashed or stray))


if __name__ == "__main__":
    try:
        root = Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else Path(__file__).resolve().parent.parent
        raise SystemExit(check(root))
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(f"CARRY FAIL: {error}")
        raise SystemExit(1)

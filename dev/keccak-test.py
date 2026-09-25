#!/usr/bin/env python3
"""Compare Keccak and selectors with frozen vectors and the installed cast."""

from pathlib import Path
import json
import re
import shutil
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
from bend_source import declarations, signature


def run(root, *args, timeout=30):
    return subprocess.run(args, cwd=root, capture_output=True, text=True, timeout=timeout)


def interface(root):
    """Pin the public Bend hash signatures against their frozen text."""
    source = (root / "src/keccak.bend").read_text()
    frozen = (root / "dev/keccak-iface.txt").read_text()
    sealed = '\n'.join(signature(r)[2].rstrip(':') for r in declarations(source, 'src/keccak.bend') if r.kind == 'def' and r.name.startswith('Keccak.')) + '\n'
    if sealed != frozen:
        print("KECCAK-IFACE FAIL: the public signatures of src/keccak.bend "
              "differs from dev/keccak-iface.txt")
        return 1
    print(f"KECCAK-IFACE OK lines={len(frozen.splitlines())}")
    return 0


def vectors(root, oracle=True):
    if interface(root):
        return 1
    binary = root / "_build/test/keccak_vec"
    spike = (root / "dev/SPIKE-KECCAK.md").read_text()
    rows = []
    for name, text, encoding, expected in re.findall(
            r"^\| (K\d+) \| `(.*?)`(?: \(empty\))? \| (utf8|hex) \| (0x[0-9a-f]{64}) \|$",
            spike, re.MULTILINE):
        data = text.encode() if encoding == "utf8" else bytes.fromhex(text[2:])
        rows.append(dict(id=name, mode="hash", input_hex=data.hex(), expected=expected))
    for name, signature, expected in re.findall(
            r"^\| (S\d+) \| `(.*?)` \| (0x[0-9a-f]{8}) \| K\d+ \|$", spike, re.MULTILINE):
        rows.append(dict(id=name, mode="selector", input_hex=signature.encode().hex(), expected=expected))
    if [row["id"] for row in rows] != ["K1", "K2", "K3", "K4", "K5", "K6", "S1", "S2"]:
        print("KECCAK-VEC FAIL: incomplete spike table")
        return 1
    fixture = json.loads((root / "dev/keccak-vectors.json").read_text())
    rows.extend(fixture["vectors"])
    cast = shutil.which("cast") if oracle else None
    if oracle and cast is None:
        print("KECCAK-VEC FAIL: cast is required for the live oracle")
        return 1
    if cast:
        version = run(root, cast, "--version")
        if version.returncode != 0:
            print("KECCAK-VEC FAIL: cannot read cast version")
            return 1
        print("KECCAK-ORACLE " + version.stdout.strip())
    passed = 0
    for row in rows:
        mode, hex_input, expected = row["mode"], row["input_hex"], row["expected"]
        if mode not in ("hash", "selector") or not re.fullmatch(
                r"0x[0-9a-f]{" + ("64" if mode == "hash" else "8") + "}", expected):
            print(f"KECCAK-VEC FAIL invalid fixture {row['id']}")
            return 1
        result = run(root, str(binary), mode, hex_input)
        good = result.returncode == 0 and result.stdout.strip() == expected and not result.stderr
        oracle_column = ""
        if cast:
            args = ("keccak", "0x" + hex_input) if mode == "hash" else (
                "sig", bytes.fromhex(hex_input).decode("ascii"))
            check = run(root, cast, *args)
            good = good and check.returncode == 0 and check.stdout.strip() == expected
            oracle_column = " oracle=" + (check.stdout.strip() if check.returncode == 0
                                          else f"exit{check.returncode}")
        print(f"KECCAK-VEC {row['id']} {'OK' if good else 'FAIL'} got={result.stdout.strip()} "
              f"want={expected}{oracle_column}")
        passed += int(good)
    # The test adapter must reject malformed bytes and modes, too.
    # The frozen alphabet is lowercase, so uppercase and mixed case must fail.
    bad = [("hash", "0"), ("hash", "gg"), ("unknown", "00"),
           ("hash", "00FF"), ("selector", "6aBcD1")]
    for args in bad:
        result = run(root, str(binary), *args)
        if result.returncode != 64 or result.stdout or "keccak-vec:" not in result.stderr:
            print(f"KECCAK-VEC FAIL adapter {args}")
            return 1
    print(f"KECCAK-VEC vectors={len(rows)} ok={passed} adapter={len(bad)} "
          + ("OK" if passed == len(rows) else "FAIL"))
    return int(passed != len(rows))


def mutants(root):
    original = (root / "src/keccak.bend").read_text()
    cases = native_mutations.load(__file__)
    workdir = root / ".gatework"
    workdir.mkdir(exist_ok=True)
    # Keep each control independent of the working checkout.
    with tempfile.TemporaryDirectory(prefix="assay-keccak-mutants-") as directory:
        copy = Path(directory) / "copy"
        # This executable depends only on assay_keccak.  Keep mutation builds
        # scoped to that library and the same adapter and vector gate.
        native_mutations.copy_project(root, copy)
        path = copy / "src/keccak.bend"
        for name, before, after, witness in cases:
            if native_mutations.count(original, before) != 1:
                print(f"KECCAK-MUTANT {name} FAIL: mutation site is not unique")
                return 1
            path.write_text(native_mutations.replace(original, before, after))
            build = run(copy, "zsh", "-f", "dev/build.sh", "build", "test/keccak_vec", timeout=120)
            if build.returncode != 0:
                print(f"KECCAK-MUTANT {name} FAIL: build failure is not a kill\n{build.stdout}{build.stderr}")
                return 1
            result = run(copy, sys.executable, "-P", "dev/keccak-test.py", "frozen", timeout=60)
            (workdir / ("keccak-mutant-" + name + ".log")).write_text(result.stdout + result.stderr)
            if result.returncode != 1 or f"KECCAK-VEC {witness} FAIL" not in result.stdout:
                print(f"KECCAK-MUTANT {name} FAIL: no expected vector rejection\n{result.stdout}{result.stderr}")
                return 1
            print(f"KECCAK-MUTANT {name} killed witness={witness} exit=1")
        # Restore the source and require the same frozen gate to pass.
        path.write_text(original)
        build = run(copy, "zsh", "-f", "dev/build.sh", "build", "test/keccak_vec", timeout=120)
        control = run(copy, sys.executable, "-P", "dev/keccak-test.py", "frozen", timeout=60)
        if build.returncode != 0 or control.returncode != 0:
            print(f"KECCAK-MUTANTS FAIL restored control\n{build.stdout}{build.stderr}{control.stdout}{control.stderr}")
            return 1
    print(f"KECCAK-MUTANTS killed={len(cases)}/{len(cases)} control=OK")
    return 0


if __name__ == "__main__":
    try:
        root = Path(__file__).resolve().parent.parent
        mode = sys.argv[1] if len(sys.argv) == 2 else "vectors"
        if mode not in ("vectors", "frozen", "mutants"):
            raise ValueError("expected vectors, frozen or mutants")
        sys.exit(mutants(root) if mode == "mutants" else vectors(root, oracle=mode != "frozen"))
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as error:
        print(f"KECCAK-VEC FAIL: {error}")
        sys.exit(1)

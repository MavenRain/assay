#!/usr/bin/env python3
"""Exercise the driver and prove the Stage A gates reject damaged inputs."""

from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


def run(root, *args):
    return subprocess.run(args, cwd=root, capture_output=True, text=True, timeout=60)


def driver(root):
    binary = str(root / "_build/default/bin/assay.exe")
    count = 0
    with tempfile.TemporaryDirectory(prefix="assay-driver-") as directory:
        work = Path(directory)
        source = work / "Smoke.asy"
        source.write_text("def main : Nat := 42\n")
        invalid = work / "Invalid.asy"
        invalid.write_text("def main : Nat := missingName\n")
        inherited = work / "Smoke.kan"
        inherited.write_text("def main : Nat := 42\n")
        unaccepted = work / "Smoke.txt"
        unaccepted.write_text("def main : Nat := 42\n")
        output = work / "runtime.hex"
        outdir = work / "out"
        cases = [
            (("check", str(source)), 0, "", ""),
            (("check", "--print", str(source)), 0, "def main", ""),
            (("check", "--erased", str(source)), 0, "main", ""),
            (("axioms", str(source)), 0, "", ""),
            (("check", str(invalid)), 1, "", None),
            (("check", str(work / "Missing.asy")), 64, "", "assay: cannot read"),
            (("check", str(work)), 64, "", "assay: cannot read"),
            (("check", str(source), "extra"), 64, "", "usage: assay"),
            (("check", "--print"), 64, "", "usage: assay"),
            (("axioms", str(source), "extra"), 64, "", "usage: assay"),
            (("spec-count", "extra"), 64, "", "usage: assay"),
            (("check", str(inherited)), 0, "", ""),
            (("check", str(unaccepted)), 64, "", "expected a .asy or .kan source"),
            (("trace", str(source)), 64, "", "usage: assay"),
            (("diff", str(source)), 64, "", "usage: assay"),
            (("run", str(source)), 3, "", "assay: run: PENDING"),
            (("deploy", str(source)), 3, "", "assay: deploy: PENDING"),
            (("test", str(source)), 3, "", "assay: test: PENDING"),
            (("build", str(source)), 64, "", "usage: assay"),
            (("emit", str(source), "-o", str(outdir)),
             2, "", "M0_PROTOCOL"),
            (("emit", str(source), "-o", str(output), "--export", "main"),
             2, "", "M0_PROTOCOL"),
            (("emit", str(invalid), "-o", str(output), "--export", "main"),
             1, "", None),
            (("emit", str(source)), 64, "", "usage: assay"),
            ((), 64, "", "usage: assay"),
        ]
        for args, code, stdout, stderr in cases:
            result = run(root, binary, *args)
            out_ok = result.stdout == "" if stdout == "" else stdout in result.stdout
            err_ok = bool(result.stderr) if stderr is None else (
                result.stderr == "" if stderr == "" else stderr in result.stderr)
            if result.returncode != code or not out_ok or not err_ok:
                print(f"DRIVER FAIL args={args} exit={result.returncode} stdout={result.stdout!r} stderr={result.stderr!r}")
                return 1
            count += 1
        if output.exists() or outdir.exists():
            print("DRIVER FAIL: refused emitter wrote output")
            return 1
    print(f"DRIVER cases={count} OK")
    return 0


def mutants(root):
    driver_source = (root / "bin/assay.ml").read_text()
    cases = [
        ("PIN", "dev/PIN", "0" * 40 + "\n", "carry-check.sh", "PIN FAIL"),
        ("CARRY", "lib/check.ml", (root / "lib/check.ml").read_text() + "\n", "carry-check.sh", "CARRY changed lib/check.ml"),
        ("CARRY-NEW", "lib/unlisted.ml", "let hidden = 0\n", "carry-check.sh", "CARRY extra lib/unlisted.ml"),
        ("CARRY-GONE", "lib/pp.ml", None, "carry-check.sh", "CARRY missing lib/pp.ml"),
        ("R0-COUNT", "SPEC.md", (root / "SPEC.md").read_text().replace("formers 2:", "formers 3:"), "r0-count.sh", "R0-COUNT FAIL"),
        ("R0-AUDIT", "lib/unlisted.ml", "(* SColl *)\n", "r0-audit.sh", "R0-AUDIT FAIL"),
        ("R0-AUDIT-SPEC", "SPEC.md", (root / "SPEC.md").read_text().replace("| M2 | rules.ml |", "| M2 | gone.ml |", 1), "r0-audit.sh", "cites the absent refuser gone.ml"),
        ("HOUSE", "bin/assay.ml", driver_source + "\nlet bad () = failwith \"bad\"\n", "house.sh", "HOUSE FAIL"),
        ("HOUSE-LOOP", "bin/assay.ml", driver_source + "\nlet count n = for i = 0 to n do ignore i done\n", "house.sh", "HOUSE no-loop-keyword FAIL"),
        ("HOUSE-DIVISION", "bin/assay.ml", driver_source + "\nlet half n = n / 2\n", "house.sh", "HOUSE no-bare-division FAIL"),
        ("TRUSTED-LINES", "lib/check.ml", (root / "lib/check.ml").read_text() + "\n", "trusted-lines.sh", "TRUSTED-LINES FAIL"),
        ("TRUSTED-UNPRICED", "emit/hidden.ml", "let hidden = 0\n", "trusted-lines.sh", "unpriced=emit/hidden.ml"),
        ("TRUSTED-BOUND", "keccak/keccak.ml", "\n" * 251, "trusted-lines.sh", "TRUSTED-LINES FAIL"),
    ]
    with tempfile.TemporaryDirectory(prefix="assay-mutants-") as directory:
        work = Path(directory)
        for folder in ("lib", "surface", "bin", "test", "dev"):
            shutil.copytree(root / folder, work / folder)
        shutil.copy2(root / "SPEC.md", work / "SPEC.md")
        (work / ".git").symlink_to(root / ".git", target_is_directory=True)
        (work / "_build").symlink_to(root / "_build", target_is_directory=True)
        for name, relative, text, script, marker in cases:
            path = work / relative
            previous = path.read_bytes() if path.exists() else None
            path.parent.mkdir(parents=True, exist_ok=True)
            # A text of None deletes the file, which is the deletion half
            # of the carry rule.
            path.unlink() if text is None else path.write_text(text)
            result = run(work, "zsh", "-f", str(work / "dev" / script))
            if previous is None:
                path.unlink()
            else:
                path.write_bytes(previous)
            if result.returncode != 1 or marker not in result.stdout:
                print(f"MUTANT {name} FAIL exit={result.returncode} stdout={result.stdout!r} stderr={result.stderr!r}")
                return 1
            print(f"MUTANT {name} killed exit=1")
    print(f"MUTANTS killed={len(cases)}/{len(cases)} OK")
    return 0


if __name__ == "__main__":
    try:
        root = Path(__file__).resolve().parent.parent
        mode = sys.argv[1] if len(sys.argv) == 2 else "driver"
        sys.exit(mutants(root) if mode == "mutants" else driver(root))
    except (OSError, subprocess.SubprocessError) as error:
        print(f"STAGE-A TEST FAIL: {error}")
        sys.exit(1)

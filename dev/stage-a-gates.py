#!/usr/bin/env python3
"""Run the carried battery and optional Stage B legs with finite deadlines."""

from pathlib import Path
import subprocess
import sys
import time


def main():
    root = Path(__file__).resolve().parent.parent
    if sys.argv[1:] not in ([], ["--keccak"]):
        print("usage: stage-a-gates.py [--keccak]")
        return 64
    keccak = sys.argv[1:] == ["--keccak"]
    legs = [
        ("BUILD", 120, ("zsh", "-f", "dev/dunecho.sh", "build"), "0 errors, 0 warnings"),
        ("PIN-CARRY", 30, ("zsh", "-f", "dev/carry-check.sh"), "diff=0 unlisted=0"),
        ("R0-COUNT", 10, ("zsh", "-f", "dev/r0-count.sh"), "R0-COUNT OK"),
        ("R0-AUDIT", 10, ("zsh", "-f", "dev/r0-audit.sh"), "R0-AUDIT OK"),
        ("HOUSE", 30, ("zsh", "-f", "dev/house.sh"), "HOUSE OK"),
        ("TRUSTED-LINES", 10, ("zsh", "-f", "dev/trusted-lines.sh"), "TRUSTED-LINES OK"),
        ("SUITE-KERNEL", 300, ("_build/default/test/main.exe", "test"), "SUITE-KERNEL OK"),
        ("SUITE-SURFACE", 60, ("_build/default/test/sl_surface.exe",), "SL-SURFACE OK"),
        ("DRIVER", 30, ("python3", "-P", "dev/stage-a-test.py", "driver"), "DRIVER cases=24 OK"),
        # The 13 subprocess-based checks exceed two minutes under host load 80+.
        ("MUTANTS", 300, ("python3", "-P", "dev/stage-a-test.py", "mutants"), "MUTANTS killed=13/13 OK"),
        ("DENOMINATORS", 10, ("shasum", "-a", "256", "-c", "dev/DENOMINATORS.sha256"), "dev/denominators.json: OK"),
    ]
    if keccak:
        legs.extend([
            ("KECCAK-VEC", 120, ("python3", "-P", "dev/keccak-test.py", "vectors"), "KECCAK-VEC vectors=35 ok=35 adapter=5 OK"),
            ("KECCAK-MUTANTS", 660, ("python3", "-P", "dev/keccak-test.py", "mutants"), "KECCAK-MUTANTS killed=4/4 control=OK"),
        ])
    stage = "B" if keccak else "A"
    work = root / (".gatework/stage-" + stage.lower())
    work.mkdir(parents=True, exist_ok=True)
    failed = False
    for name, timeout, command, marker in legs:
        start = time.monotonic()
        try:
            result = subprocess.run(command, cwd=root,
                                    capture_output=True, text=True, timeout=timeout)
            output = result.stdout + result.stderr
            good = result.returncode == 0 and marker in output
            code = result.returncode
        except (OSError, subprocess.TimeoutExpired) as error:
            output, good, code = str(error), False, 1
        (work / (name + ".log")).write_text(output)
        print(f"{'PASS' if good else 'FAIL'} {name} exit={code} elapsed_ms={(time.monotonic() - start) * 1000:.1f}", flush=True)
        if not good:
            print(output, flush=True)
            failed = True
            if name == "BUILD":
                break
    print("PENDING C-F: assembler, Cancun reference, EVM emission and corpus measurements"
          if keccak else "PENDING B-F: keccak, assembler, Cancun reference, EVM emission and corpus measurements")
    print("STAGE-" + stage + " " + ("FAIL" if failed else "OK"))
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())

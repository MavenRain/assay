#!/usr/bin/env python3
"""Stage C stack, disassembly, and mutation gates.  No EVM execution here."""

from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import re
import shutil
import subprocess
import sys
import tempfile


def run(root, *args, timeout=60):
    return subprocess.run(args, cwd=root, capture_output=True, text=True, timeout=timeout)


def adapter(root, *args):
    return run(root, str(root / "_build/test/asm_cases"), *args)


def effect_batch(root, probes):
    with tempfile.TemporaryDirectory(prefix="assay-effects-") as directory:
        manifest = Path(directory) / "cases"
        manifest.write_bytes(b"".join(name.encode() + b"\0" + str(height).encode() + b"\0"
                                      for name, height, _code, _want in probes))
        result = adapter(root, "effect-batch", str(manifest))
    if result.returncode or result.stderr:
        raise ValueError("STACK-HEIGHT FAIL effect batch: " + result.stderr)
    data = result.stdout
    offset = 0
    results = []
    for _ in probes:
        colon = data.find(":", offset)
        if colon < 0 or not data[offset:colon].isdigit():
            raise ValueError("STACK-HEIGHT FAIL malformed effect frame")
        length = int(data[offset:colon])
        end = colon + 1 + length
        if end > len(data):
            raise ValueError("STACK-HEIGHT FAIL truncated effect frame")
        code, separator, output = data[colon + 1:end].partition("\n")
        if not separator or code not in ("0", "2"):
            raise ValueError("STACK-HEIGHT FAIL invalid effect status")
        results.append((int(code), output))
        offset = end
    if offset != len(data):
        raise ValueError("STACK-HEIGHT FAIL trailing effect frames")
    return results


def opcodes(root):
    rows = []
    for line in (root / "dev/asm-opcodes.txt").read_text().splitlines():
        if not line or line.startswith("#"):
            continue
        byte, name, pops, pushes = line.split()
        rows.append((int(byte, 16), name, int(pops), int(pushes)))
    rows += [(0x5f + n, f"PUSH{n}", 0, 1) for n in range(33)]
    rows += [(0x7f + n, f"DUP{n}", n, n + 1) for n in range(1, 17)]
    rows += [(0x8f + n, f"SWAP{n}", n + 1, n + 1) for n in range(1, 17)]
    if len(rows) != 149 or len({row[0] for row in rows}) != len(rows):
        raise ValueError("incomplete or duplicate frozen opcode rows")
    return sorted(rows)


def stack(root):
    result = adapter(root, "suite")
    print(result.stdout, end="")
    summary = re.search(r"STACK-HEIGHT blocks=(\d+) mismatch=0 cases=(\d+) OK", result.stdout)
    if result.returncode or result.stderr or not summary or summary.groups() != ("30", "64"):
        print(("STACK-HEIGHT FAIL suite " + result.stderr).rstrip())
        return 1
    blocks, cases = summary.groups()
    rows = opcodes(root)
    metadata = adapter(root, "metadata")
    expected = "".join(f"{byte:02x} {name} {pops} {pushes}\n" for byte, name, pops, pushes in rows)
    if metadata.returncode or metadata.stderr or metadata.stdout != expected:
        print("STACK-HEIGHT FAIL opcode metadata differs from the frozen Cancun table")
        return 1
    controls = {"STOP", "JUMP", "JUMPI", "JUMPDEST", "RETURN", "REVERT", "INVALID", "SELFDESTRUCT"}
    all_probes = []
    for _byte, name, pops, pushes in rows:
        if name in controls:
            continue
        probes = [(pops, 0, f"{pushes} {max(pops, pushes)}\n")]
        if pops:
            probes.append((pops - 1, 2, f"UNDERFLOW effect {name} got={pops - 1} need={pops}\n"))
        if pushes > pops:
            probes.append((1024, 2, f"OVERFLOW effect {name} got={1024 - pops + pushes}\n"))
        else:
            probes.append((1024, 0, f"{1024 - pops + pushes} 1024\n"))
        for height, code, want in probes:
            all_probes.append((name, height, code, want))
    for (name, height, code, want), (actual_code, actual_output) in zip(all_probes, effect_batch(root, all_probes)):
        if actual_code != code or actual_output != want:
            print(f"STACK-HEIGHT FAIL effect={name} input={height} want={want.strip()} got={actual_output.strip()}")
            return 1
    # Exercise the process exit and output boundary for success and both errors.
    for name, height, code, want in (probe for probe in all_probes if probe[:2] in (("ADD", 2), ("ADD", 1), ("PUSH1", 1024))):
        result = adapter(root, "effect", name, str(height))
        if result.returncode != code or result.stdout != want or result.stderr:
            print(f"STACK-HEIGHT FAIL effect={name} input={height} want={want.strip()} got={result.stdout.strip()}")
            return 1
    count = len(all_probes)
    compact = run(root, str(root / "_build/test/asm_compact"))
    if compact.returncode or compact.stderr or compact.stdout != "ASM-COMPACT cases=618 OK\n":
        print("STACK-HEIGHT FAIL compaction " + compact.stdout + compact.stderr)
        return 1
    print(compact.stdout, end="")
    print(f"STACK-HEIGHT blocks={blocks} cases={cases} opcodes={len(rows)} effect_cases={count} OK")
    return 0


def prevrandao(code, fired):
    """Rewrite the oracle spelling DIFFICULTY only where our own bytes hold 0x44."""
    def alias(pc, name):
        hit = name == "DIFFICULTY" and code[2 * pc:2 * pc + 2].lower() == "44"
        if hit:
            fired.append(pc)
        return "PREVRANDAO" if hit else name
    return alias


def normalized(output, *, pc_base, header=None, alias=None):
    lines = output.strip().splitlines()
    if header is not None:
        if not lines or lines.pop(0) != header:
            raise ValueError("geth disassembly did not echo the supplied hex")
    rows = []
    for line in lines:
        match = re.fullmatch(r"([0-9a-fA-F]+): ([A-Z0-9]+)(?: 0x([0-9a-fA-F]+))?", line)
        if not match:
            raise ValueError("invalid disassembly row: " + line)
        pc, name, immediate = match.groups()
        offset = int(pc, pc_base)
        rows.append((offset, name if alias is None else alias(offset, name), (immediate or "").lower()))
    return rows


def disasm(root):
    cast, evm = shutil.which("cast"), shutil.which("evm")
    if not cast or not evm:
        raise ValueError("cast and evm are required")
    work = root / ".gatework/asm-disasm"
    work.mkdir(parents=True, exist_ok=True)
    for name, binary in (("cast", cast), ("evm", evm)):
        version = run(root, binary, "--version")
        if version.returncode:
            raise ValueError("cannot read " + name + " version")
        print("DISASM-ORACLE " + version.stdout.strip())
    result = adapter(root, "fixtures")
    if result.returncode or result.stderr:
        raise ValueError("assembly fixtures failed: " + result.stdout + result.stderr)
    fixtures = [tuple(line.split()) for line in result.stdout.splitlines()]
    if [row[0] for row in fixtures] != ["ref20", "diamond", "loop", "pushes", "depths"]:
        raise ValueError("incomplete assembly fixtures")
    all_bytes = "".join(f"{byte:02x}" + ("5b" * (byte - 0x5f) if 0x60 <= byte <= 0x7f else "")
                        for byte, _name, _pops, _pushes in opcodes(root))
    fixtures += [("all-opcodes", all_bytes), ("empty", "")]
    totals = {"ours": 0, "cast": 0, "evm": 0}
    for name, data in fixtures:
        hexfile = work / (name + ".hex")
        hexfile.write_text(data + "\n")
        ours = adapter(root, "listing", data)
        other = run(root, cast, "disassemble", "0x" + data)
        geth = run(root, evm, "disasm", str(hexfile))
        for label, command in (("ours", ours), ("cast", other), ("evm", geth)):
            (work / (name + "." + label + ".log")).write_text(command.stdout + command.stderr)
            if command.returncode or command.stderr:
                raise ValueError(f"{name} {label} exited {command.returncode}: {command.stderr}")
        fired = []
        a = normalized(ours.stdout, pc_base=16)
        b = normalized(other.stdout, pc_base=16, alias=prevrandao(data, fired))
        # Both tools print hex PCs.  geth uses five digits; cast uses eight.
        if not data and geth.stdout.strip():
            raise ValueError("geth printed instructions for empty bytecode")
        c = normalized(geth.stdout, pc_base=16, header=data,
                       alias=prevrandao(data, fired)) if data else []
        if not (a == b == c):
            print(f"DISASM-3WAY {name} FAIL ours={a} cast={b} evm={c}")
            return 1
        if name == "all-opcodes" and not fired:
            print("DISASM-3WAY FAIL the DIFFICULTY alias never applied at byte 0x44")
            return 1
        print(f"DISASM-3WAY {name} OK offsets={len(a)} bytes={len(data) // 2} alias={len(fired)}")
        for label, rows in (("ours", a), ("cast", b), ("evm", c)):
            totals[label] += len(rows)
    negative = [("0", "INVALID-HEX"), ("gg", "INVALID-HEX"), ("AA", "INVALID-HEX"),
                ("0x00", "INVALID-HEX"), ("1e", "UNKNOWN-OPCODE pc=0 byte=1e"),
                ("e0", "UNKNOWN-OPCODE pc=0 byte=e0")]
    negative += [(f"{0x5f + n:02x}" + "00" * (n - 1), f"TRUNCATED-PUSH pc=0 width={n} got={n - 1}")
                 for n in range(1, 33)]
    for data, want in negative:
        result = adapter(root, "listing", data)
        if result.returncode != 2 or result.stdout or result.stderr != want + "\n":
            print(f"DISASM-3WAY FAIL rejection {data}: {result.stdout}{result.stderr}")
            return 1
    print(f"DISASM-3WAY ours={totals['ours']} cast={totals['cast']} evm={totals['evm']} "
          f"fixtures={len(fixtures)} negative={len(negative)} OK")
    return 0


def mutants(root):
    cases = native_mutations.load(__file__)
    work = root / ".gatework"
    work.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="assay-asm-mutants-") as directory:
        copy = Path(directory) / "copy"
        native_mutations.copy_project(root, copy)
        for name, relative, before, after, mode, witness in cases:
            source = (root / relative).read_text()
            if native_mutations.count(source, before) != 1:
                raise ValueError(name + " mutation site is not unique")
            (copy / relative).write_text(native_mutations.replace(source, before, after))
            build = run(copy, "zsh", "-f", "dev/build.sh", "build", "test/asm_cases", "test/asm_compact", timeout=120)
            if build.returncode:
                raise ValueError(name + " build failure is not a kill: " + build.stdout + build.stderr)
            result = run(copy, sys.executable, "-P", "dev/asm-test.py", mode, timeout=240)
            (work / ("asm-mutant-" + name + ".log")).write_text(result.stdout + result.stderr)
            if result.returncode != 1 or witness not in result.stdout:
                raise ValueError(name + " was not killed by " + witness + ": " + result.stdout + result.stderr)
            print(f"ASM-MUTANT {name} killed witness={witness}", flush=True)
            (copy / relative).write_text(source)
        build = run(copy, "zsh", "-f", "dev/build.sh", "build", "test/asm_cases", "test/asm_compact", timeout=120)
        if build.returncode:
            raise ValueError("restored build failed: " + build.stdout + build.stderr)
        for mode in ("stack", "disasm"):
            result = run(copy, sys.executable, "-P", "dev/asm-test.py", mode, timeout=240)
            (work / ("asm-control-" + mode + ".log")).write_text(result.stdout + result.stderr)
            if result.returncode:
                raise ValueError("restored " + mode + " failed: " + result.stdout + result.stderr)
    print(f"ASM-MUTANTS killed={len(cases)}/{len(cases)} control=OK")
    return 0


if __name__ == "__main__":
    try:
        if len(sys.argv) != 2 or sys.argv[1] not in ("stack", "disasm", "mutants"):
            print("usage: asm-test.py stack|disasm|mutants")
            sys.exit(64)
        root = Path(__file__).resolve().parent.parent
        sys.exit({"stack": stack, "disasm": disasm, "mutants": mutants}[sys.argv[1]](root))
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print("ASM-GATE FAIL: " + str(error))
        sys.exit(1)

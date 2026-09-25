#!/usr/bin/env python3
"""Keep shape names in their owners, and keep every SPEC.md shape naming
tied to the refusal row that cites its milestone and its refusing module."""

from pathlib import Path
import re
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from bend_source import declarations

SHAPES = r"SColl|SMu|SNu|SPar|SPi"
ROW = re.compile(r"^\|\s*`(" + SHAPES + r")\b[^`]*`\s*\|\s*([^|]*?)\s*\|\s*([^|]*?)\s*\|\s*$")


def declared_shapes(root):
    """The constructor names of the carried shape sum, in declaration order."""
    source = (root / "src/kernel.bend").read_text()
    text = next(record.source for record in declarations(source, "src/kernel.bend")
                if record.kind == "type" and record.name == "Shape")
    return [match.group(1) for match in
            re.finditer(r"^\s*Shape\.(" + SHAPES + r")\{", text, re.M)]


def table_rows(spec):
    """The rows of the shape refusal table of SPEC.md section 2.1."""
    rows = []
    inside = False
    for number, line in enumerate(spec.splitlines(), 1):
        if line.startswith("### 2.1 Shapes"):
            inside = True
        elif inside and line.startswith("#"):
            inside = False
        elif inside:
            match = ROW.match(line)
            if match:
                rows.append((number, match.group(1), match.group(2), match.group(3)))
    return rows


def listed(spec, key):
    """The names printed after `key` inside the R0 counts block."""
    match = re.search(r"^" + key + r" \d+: (.*)$", spec, re.M)
    return match.group(1).split() if match else []


def audit_spec(root):
    """Every naming of a shape in SPEC.md carries its refusal citation:  a
    row that names the milestone and the module that refuses the shape."""
    spec = (root / "SPEC.md").read_text()
    rows = table_rows(spec)
    bad = []
    named = [name for _number, name, _milestone, _refuser in rows]
    for number, name, milestone, refuser in rows:
        if not re.fullmatch(r"M[0-9]", milestone):
            bad.append(f"SPEC.md:{number}: {name} names no milestone")
        if refuser != "admitted" and not (root / "src" / refuser).exists():
            bad.append(f"SPEC.md:{number}: {name} cites the absent refuser {refuser}")
        if named.count(name) != 1:
            bad.append(f"SPEC.md:{number}: {name} has more than one refusal row")
    for name in declared_shapes(root):
        if name not in named:
            bad.append(f"SPEC.md: {name} of src/kernel.bend has no refusal row")
    for name in named:
        if name not in declared_shapes(root):
            bad.append(f"SPEC.md: {name} is named with no constructor in src/kernel.bend")
    admitted = [name for _number, name, _milestone, refuser in rows
                if refuser == "admitted"]
    if listed(spec, "shapes declared") != named:
        bad.append("SPEC.md: the declared shape list differs from the refusal table")
    if listed(spec, "shapes admitted") != admitted:
        bad.append("SPEC.md: the admitted shape list differs from the refusal table")
    return bad


def check(root):
    if not (root / "src/kernel.bend").is_file():
        print("R0-AUDIT FAIL: missing native kernel")
        return 1
    allowed = {"Shape", "Rules", "Pp", "Erase", "Emit", "Recognize"}
    bad = []
    for path in (root / "src").rglob("*.bend"):
        if path.name in ("tests.bend", "cli.bend", "frontend.bend"):
            # Erasure is scanned separately below; the surface grammar may name shapes.
            if path.name != "frontend.bend":
                continue
        source = path.read_text()
        records = list(declarations(source, path.relative_to(root)))
        preamble = source.split(records[0].source, 1)[0] if records else source
        if re.search(SHAPES, preamble):
            bad.append(f"{path.relative_to(root)}: shape named outside an allowed declaration")
        for record in records:
            parts = record.name.split(".")
            owner = parts[1].split("_")[0] if parts[0] in ("Local", "Case", "Get", "Match", "Equal") else parts[0]
            if path.name == "frontend.bend" and owner != "Erase":
                continue
            if owner not in allowed:
                for number, line in enumerate(record.source.splitlines(), 1):
                    if re.search(SHAPES, line):
                        bad.append(f"{record.path}:{record.name}:{number}:{line[:200]}")
    bad.extend(audit_spec(root))
    for line in bad:
        print(line)
    print("R0-AUDIT " + ("FAIL" if bad else "OK"))
    return int(bool(bad))


if __name__ == "__main__":
    try:
        sys.exit(check(Path(sys.argv[1]).resolve()))
    except OSError as error:
        print(f"R0-AUDIT FAIL: {error}")
        sys.exit(1)

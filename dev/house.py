#!/usr/bin/env python3
"""Native source rules; OS exceptions are confined to one effect boundary."""
from pathlib import Path
import collections
import hashlib
import json
import re
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from bend_source import declarations


def code(text):
    return re.sub(r'"(?:\\.|[^"\\])*"|\x27(?:\\.|[^\x27\\])*\x27|#[^\n]*', '', text)


# A catch-all is an arm that accepts a shape without naming it. Three forms
# carry one in the native sources: a case arm whose patterns are binders only,
# a lowered `otherwise<N>` default binder, and the trailing default argument of
# a selective `Match.*.only_*` eliminator call. Every selective call gets its
# own row, the ones that forward to a lowered binder included, and the row
# digest covers the call head, so a new call site or another eliminator name
# on an old site moves the inventory.
CASE_ARM = re.compile(r'^([ \t]*)case((?:\s+(?:_\w*|[a-z]\w*))+)\s*:')
OTHERWISE_BINDER = re.compile(r'\+?(otherwise\d+)\s*=\s*\{')
ONLY_CALL = re.compile(r'Match\.[\w.]*\.only_\w+\s*\(')
DELEGATION = re.compile(r'_\s*=>\s*\(*\s*(otherwise\d+)\s*\(\s*Unit\{\}\s*\)\s*\)*')
EXCERPT = 160
ROW_FIELDS = ('definition', 'path', 'line', 'arm', 'arm_sha256', 'arity', 'reason')
OPENERS = {')': '(', '}': '{', ']': '['}


def blank(match):
    """Fill one string or comment with x, keeping its length and delimiters."""
    body = match[0]
    return 'x' * len(body) if body.startswith('#') else body[0] + 'x' * (len(body) - 2) + body[-1]


def masked(text):
    """The same text with string and comment contents blanked; offsets hold."""
    return re.sub(r'"(?:\\.|[^"\\])*"|\x27(?:\\.|[^\x27\\])*\x27|#[^\n]*', blank, text)


def region(text, start):
    """Index of the bracket that closes the one at start, or -1."""
    stack = []
    for index in range(start, len(text)):
        char = text[index]
        if char in '({[':
            stack.append(char)
        elif char in ')}]':
            if not stack or stack.pop() != OPENERS[char]:
                return -1
            if not stack:
                return index
    return -1


def arguments(text):
    """Split one argument list on its top level commas."""
    parts, depth, start = [], 0, 0
    for index, char in enumerate(text):
        if char in '({[':
            depth += 1
        elif char in ')}]':
            depth -= 1
        elif char == ',' and not depth:
            parts.append(text[start:index])
            start = index + 1
    parts.append(text[start:])
    return parts


def row(name, path, text, offset, arm, arity):
    body = '\n'.join(line.rstrip() for line in arm.splitlines()).strip()
    excerpt = ' '.join(body.split())
    return {'definition': name, 'path': path, 'line': text.count('\n', 0, offset) + 1,
            'arm': excerpt if len(excerpt) <= EXCERPT else excerpt[:EXCERPT] + ' ...',
            'arm_sha256': hashlib.sha256(body.encode()).hexdigest(), 'arity': arity, 'reason': ''}


def case_arms(probe, source):
    """Yield (offset, arm text, binder count) for every binder-only case arm."""
    lines = probe.splitlines(keepends=True)
    offsets, cursor = [], 0
    for line in lines:
        offsets.append(cursor)
        cursor += len(line)
    offsets.append(cursor)
    for index, line in enumerate(lines):
        match = CASE_ARM.match(line)
        if match:
            indent = len(match[1])
            end = index + 1
            while end < len(lines) and (not lines[end].strip() or len(lines[end]) - len(lines[end].lstrip()) > indent):
                end += 1
            yield offsets[index], source[offsets[index]:offsets[end]], len(match[2].split())


def header_lines(source):
    return {index for index, line in enumerate(source.splitlines()) if line.startswith(('def ', 'law ', 'type '))}


def scan_file(path, relative, text):
    """Rows and coverage counters for one native source file."""
    rows, sites, delegated, binders, defaults, documented = [], 0, 0, 0, 0, 0
    cursor = 0
    for record in declarations(text, relative):
        base = text.index(record.source.rstrip(), cursor)
        cursor = base
        source = record.source
        probe = masked(source)
        headers = header_lines(probe)
        names = set()
        for match in OTHERWISE_BINDER.finditer(probe):
            binders += 1
            names.add(match[1])
            end = region(probe, match.end() - 1)
            arm = source[match.end() - 1:end + 1] if end >= 0 else source[match.end() - 1:]
            rows.append(row(record.name, relative, text, base + match.start(), arm, 1))
        for offset, arm, arity in case_arms(probe, source):
            rows.append(row(record.name, relative, text, base + offset, arm, arity))
        for match in ONLY_CALL.finditer(probe):
            if probe.count('\n', 0, match.start()) in headers:
                continue
            sites += 1
            head = source[match.start():match.end()]
            end = region(probe, match.end() - 1)
            if end < 0:
                defaults += 1
                documented += 1
                rows.append(row(record.name, relative, text, base + match.start(), head, 1))
                continue
            parts = arguments(probe[match.end():end])
            arm = source[end - len(parts[-1]):end].strip()
            delegation = DELEGATION.fullmatch(parts[-1].strip())
            if delegation and delegation[1] in names:
                delegated += 1
            else:
                defaults += 1
            # The head travels with the arm, so only_zero and only_succ on the
            # same fallback are two rows and one more forwarding site is new.
            documented += 1
            rows.append(row(record.name, relative, text, base + end - len(parts[-1]), head + ' ' + arm, 1))
    return rows, {'sites': sites, 'delegated': delegated, 'binders': binders,
                  'defaults': defaults, 'documented': documented}


def catchalls(root):
    """Every catch-all of every checked native source, with its coverage gaps."""
    rows, gaps = [], []
    for path in sorted((root / 'src').glob('*.bend')) + sorted((root / 'dev').glob('*.bend')):
        text = path.read_text()
        relative = str(path.relative_to(root))
        found, counts = scan_file(path, relative, text)
        rows += found
        probe = masked(text)
        # A detector that stops matching must not leave a file silently empty.
        if 'case _' in probe and not found:
            gaps.append(relative + ' holds case _ text and no catch-all row')
        binders = len(OTHERWISE_BINDER.findall(probe))
        if binders != counts['binders']:
            gaps.append(f'{relative} holds {binders} otherwise binders and {counts["binders"]} scanned')
        headers = header_lines(probe)
        calls = sum(1 for match in ONLY_CALL.finditer(probe) if probe.count('\n', 0, match.start()) not in headers)
        if calls != counts['sites']:
            gaps.append(f'{relative} holds {calls} selective eliminator calls and {counts["sites"]} scanned')
        covered = counts['delegated'] + counts['defaults']
        if counts['sites'] != covered:
            gaps.append(f'{relative} leaves {counts["sites"] - covered} selective eliminator defaults unaccounted')
        if counts['sites'] != counts['documented']:
            gaps.append(f'{relative} leaves {counts["sites"] - counts["documented"]} selective eliminator defaults without a row')
    return rows, gaps


def check_catchalls(root):
    expected = json.loads((root / 'dev/bend-catchalls.json').read_text())
    if not isinstance(expected, list):
        raise ValueError('dev/bend-catchalls.json must hold a list of rows')
    actual, gaps = catchalls(root)
    good = not gaps
    for gap in gaps:
        print('HOUSE catch-all scan gap: ' + gap)
    key = lambda rows: collections.Counter((row.get('definition', ''), row.get('path', ''), row.get('arm_sha256', '')) for row in rows if isinstance(row, dict))
    changed = key(actual) - key(expected)
    gone = key(expected) - key(actual)
    for name, path, _digest in sorted(changed):
        print(f'HOUSE unapproved catch-all: {name} ({path})')
    for name, path, _digest in sorted(gone):
        print(f'HOUSE missing named catch-all: {name} ({path})')
    for record in expected:
        blank = [field for field in ROW_FIELDS if not isinstance(record, dict) or not str(record.get(field, '')).strip()]
        if blank:
            print('HOUSE catch-all row without ' + ', '.join(blank) + ': ' + str(record.get('definition', '?') if isinstance(record, dict) else record))
            good = False
    return good and not changed and not gone


def check(root):
    paths = sorted((root / 'src').glob('*.bend')) + sorted((root / 'dev').glob('*.bend'))
    records = [record for path in paths for record in declarations(path.read_text(), path.relative_to(root))]
    text = '\n'.join(code(path.read_text()) for path in paths)
    flags = {}
    flags['no-exception'] = not re.search(r'\b(?:throw|raise|panic|failwith|assert|try|catch)\b|\?[A-Za-z_]|\b\w+\s*\[[^\]\n]+\]', text)
    flags['named-catchalls'] = check_catchalls(root)
    flags['no-mutable-state'] = not re.search(r'\b(?:mutable|ref|set_mut|swap_mut)\b|\[[^\]\n]+\]\s*<-', text)
    boundary = (root / 'src/os.js').read_text()
    flags['one-catch-site'] = len(re.findall(r'\bcatch\s*\(', boundary)) == 1
    flags['foreign-boundary'] = True
    foreign = {'NativeIO.read_bytes', 'NativeIO.write_bytes', 'NativeIO.exit', 'NativeIO.args', 'NativeIO.stdout', 'NativeIO.die', 'NativeIO.open', 'OS.regular', 'OS.mkdir_new', 'OS.basename', 'OS.root', 'OS.executable', 'OS.run'}
    for record in records:
        test_probe = record.name == 'TestPerf.measure' and record.path == 'src/tests.bend'
        if re.search(r'^\s+import ', record.source, re.M) and record.name not in foreign and not test_probe:
            print('HOUSE unexpected foreign effect: ' + record.name)
            flags['foreign-boundary'] = False
    # Bend uses Bool patterns for eliminators and binary digits. Keep those
    # patterns in named primitives instead of spreading them through rules.
    flags['bool-dispatch'] = True
    for record in records:
        if re.search(r'^\s*case (?:True|False)\{', record.source, re.M):
            if not record.name.startswith(('Big.', 'NativeBool.', 'Native.choose', 'Match.Bool', 'TestNumber.')) and record.name not in ('Cli.when', 'Cli.read_source', 'SeqList.filter_step'):
                print('HOUSE unexpected Bool pattern: ' + record.name)
                flags['bool-dispatch'] = False
    flags['no-loop-keyword'] = not re.search(r'^\s*(?:while|loop|for)\s+', text, re.M)
    # Big.div and Big.rem return Maybe and check the denominator explicitly.
    division = re.findall(r'\b([\w.]+)\s*\(', text)
    flags['no-bare-division'] = not re.search(r'\s[/%]\s', text) and all(name in ('Big.div', 'Big.rem', 'Bignum.div', 'Bignum.rem') or name.rsplit('.', 1)[-1] not in ('div', 'mod', 'rem') for name in division)
    prose = subprocess.run(['rg', '-l', '--glob', '!vendor', '--glob', '!**/vendor/**',
                            '--glob', '!_build', '--glob', '!**/_build/**',
                            '--', chr(0x2014), '.'], cwd=root, capture_output=True, text=True)
    flags['no-em-dash'] = prose.returncode == 1
    if prose.returncode != 1:
        print(prose.stdout + prose.stderr, end='')
    for name, good in flags.items():
        print(f'HOUSE {name} {"OK" if good else "FAIL"}')
    good = bool(paths) and all(flags.values())
    print('HOUSE ' + ('OK' if good else 'FAIL'))
    return 0 if good else 1


if __name__ == '__main__':
    try:
        raise SystemExit(check(Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else Path(__file__).resolve().parent.parent))
    except (OSError, ValueError, KeyError) as error:
        print(f'HOUSE FAIL: {error}')
        raise SystemExit(1)

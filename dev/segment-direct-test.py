#!/usr/bin/env python3
"""Compare executor substrings with their predecessor and code-point goldens."""
from dataclasses import replace
from pathlib import Path
import hashlib
import json
import os
import random
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'dev'))
import build
from bend_source import bundle, declarations, reachable
from cli_delta import PINS, cli_sources, only, pinned

BASE = 'a374e662a727785b7e962f0db97953d687550843'
NAME = 'Model.segment'
WORK = ROOT / '_build/segment-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{ord(char):x}' + '}' for char in text) + '"'


def integer(value):
    expression = f'Big.of_nat({abs(value)}n)'
    return 'Big.neg(' + expression + ')' if value < 0 else expression


def golden(row):
    offset, length, text = row
    # Big.to_nat uses the magnitude, including for negative values.
    return ''.join(str(ord(char)) + ',' for char in text[abs(offset):abs(offset) + abs(length)])


def compile_and_run(records, entry, name):
    source = bundle(reachable(records + list(declarations(entry, '<segment-direct>')),
                              'SegmentDirect.main'), 'SegmentDirect.main')
    path = WORK / (name + '.bend')
    path.write_text(source.replace('import "./os.js"', 'import "../../src/os.js"'))
    compiled = subprocess.run([str(build.compiler()), str(path), '-o', str(path.with_suffix('.js'))],
                              capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(compiled.stdout + compiled.stderr)
    if compiled.returncode:
        raise ValueError(f'{name} build failed: {WORK / (name + "-build.log")}')
    launcher = WORK / name
    build.executable(launcher, build.wrapper(build.runtime(), '../segment-direct/' + name))
    result = subprocess.run([str(launcher)], capture_output=True, timeout=60)
    (WORK / (name + '.stdout')).write_bytes(result.stdout)
    if result.returncode or result.stderr:
        raise ValueError(f'{name} exit={result.returncode} stderr={result.stderr[:500]!r}')
    return result.stdout


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    records = [row for path in sorted((ROOT / 'src').glob('*.bend'))
               for row in declarations(path.read_text(), path.relative_to(ROOT))]
    current = only(records, NAME)
    if current is None or hashlib.sha256(current.source.encode()).hexdigest() != PINS[NAME]:
        raise ValueError('segment declaration does not match its pin')
    old = subprocess.check_output(['git', '-C', str(ROOT), 'show', BASE + ':src/emitter.bend'], text=True)
    predecessor = only(list(declarations(old, '<predecessor>')), NAME)
    if predecessor is None:
        raise ValueError('segment predecessor is missing or duplicated')
    control = [replace(row, source=predecessor.source) if row is current else row for row in records]
    before, after = cli_sources([control, records], NAME)
    if before != after or after is None:
        raise ValueError('segment compatibility bundle mismatch')
    for poison in (records + [current], [row for row in records if row is not current],
                   [replace(row, source=row.source + '\n') if row is current else row for row in records]):
        if pinned(control, poison) is not None:
            raise ValueError('invalid segment pin accepted')
    unrelated = [replace(row, source=row.source.replace('case SmallBig{_, value}: value', 'case SmallBig{_, value}: 0n'))
                 if row.name == 'Big.to_nat' else row for row in records]
    other_before, other_after = cli_sources([control, unrelated], NAME)
    if other_before == other_after or other_after is None:
        raise ValueError('unrelated helper change was hidden by the pin')

    bounds = [-6, -2, -1, 0, 1, 2, 3, 9, 64, 2 ** 31, 2 ** 32 - 1]
    texts = ['', 'a', 'abcd', '0x0123', '\x00\n\r\t', 'éλ😀', 'e\u0301', '１２', 'a😀b']
    rows = [(offset, length, text) for text in texts for offset in bounds for length in bounds]
    rows.extend([(1, 2, 'abcd'), (4095, 2, 'a' * 4096), (4096, 1, 'a' * 4096)])
    rng = random.Random(0x5E6)
    alphabet = '012abc\x00\n\réλ😀\u0301'
    for _ in range(256):
        text = ''.join(rng.choice(alphabet) for _ in range(rng.randrange(0, 40)))
        rows.append((rng.randrange(-48, 49), rng.randrange(-48, 49), text))
    inputs = []
    for offset, length, text in rows:
        source = 'NativeString.repeat(4096n, Char.from_u32(97))' if len(text) == 4096 else literal(text)
        inputs.append('Tup3{' + integer(offset) + ', ' + integer(length) + ', ' + source + '}')
    entry = '''@unsafe
def SegmentDirect.codes(text: String) -> String:
  match text:
    case SNil{}: ""
    case SCon{char, rest}: String.append(Big.show(Big.of_nat(U32.to_nat(Char.to_u32(char)))), String.append(",", SegmentDirect.codes(rest)))
@unsafe
def SegmentDirect.each(rows: ListOf(TupleOf3(Big, Big, String))) -> IO(Unit):
  match rows:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{row, rest}:
      match row:
        case Tup3{offset, length, text}: do IO<Unit>:
          NativeIO.print(SegmentDirect.codes(Model.segment(offset, length, text)))
          SegmentDirect.each(rest)
def SegmentDirect.main() -> IO(Unit):
  SegmentDirect.each([''' + ', '.join(inputs) + '])\n'
    expected = ''.join(golden(row) + '\n' for row in rows).encode()
    baseline = compile_and_run(control, entry, 'control')
    actual = compile_and_run(records, entry, 'native')
    if baseline != expected or actual != expected:
        raise ValueError('segment predecessor or implementation disagrees with goldens')
    mutations = [
        ('offset-ignored', 'NativeString.drop(Big.to_nat(offset_586), text_588)', 'text_588'),
        ('length-ignored', 'NativeString.take(Big.to_nat(length_587), NativeString.drop(Big.to_nat(offset_586), text_588))',
         'NativeString.drop(Big.to_nat(offset_586), text_588)'),
        ('offset-swapped', 'NativeString.drop(Big.to_nat(offset_586),', 'NativeString.drop(Big.to_nat(length_587),'),
    ]
    mutants = {}
    witness = (1, 2, 'abcd')
    for name, needle, replacement in mutations:
        if current.source.count(needle) != 1:
            raise ValueError('mutation point missing or duplicated: ' + name)
        mutant = [replace(row, source=row.source.replace(needle, replacement)) if row is current else row for row in records]
        output = compile_and_run(mutant, entry, name)
        lines = output.decode().splitlines()
        index = rows.index(witness)
        if len(lines) != len(rows) or lines[index] == golden(witness):
            raise ValueError('compiled mutant failed to produce its named wrong answer: ' + name)
        mutants[name] = dict(killed=True, case=witness, expected=golden(witness), actual=lines[index],
                             output_sha256=hashlib.sha256(output).hexdigest())
    if compile_and_run(records, entry, 'restored') != expected:
        raise ValueError('restored segment disagrees with goldens')
    report = dict(base=BASE, cases=len(rows), golden=len(rows), mutants=mutants,
                  declaration_sha256=PINS[NAME], output_sha256=hashlib.sha256(actual).hexdigest())
    (WORK / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'SEGMENT-DIRECT cases={len(rows)} golden={len(rows)} mutants={len(mutants)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('SEGMENT-DIRECT FAIL ' + str(error), file=sys.stderr)
        sys.exit(1)

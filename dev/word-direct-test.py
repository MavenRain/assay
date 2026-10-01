#!/usr/bin/env python3
"""Compare word parsing with its predecessor and independent uint256 goldens."""
from dataclasses import replace
from pathlib import Path
import hashlib
import json
import os
import random
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'dev'))
import build
from bend_source import bundle, declarations, reachable
from cli_delta import PINS, cli_sources, only, pinned

BASE = '91a27b76f4f5ad182aacbc47d6ddd29301a44ef6'
NAME = 'Recognize.parse_word'
WORK = ROOT / '_build/word-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{ord(char):x}' + '}' for char in text) + '"'


def golden(text):
    normalized = text.lower()
    hexadecimal = normalized.startswith('0x')
    digits = normalized[2:] if hexadecimal else normalized
    pattern, limit, radix = ('[0-9a-f]+', 64, 16) if hexadecimal else ('[0-9]+', 78, 10)
    if len(digits) > limit or re.fullmatch(pattern, digits) is None:
        return 'invalid'
    value = int(digits, radix)
    return 'overflow' if value >= 2 ** 256 else str(value)


def compile_and_run(records, entry, name):
    source = bundle(reachable(records + list(declarations(entry, '<word-direct>')),
                              'WordDirect.main'), 'WordDirect.main')
    path = WORK / (name + '.bend')
    path.write_text(source.replace('import "./os.js"', 'import "../../src/os.js"'))
    compiled = subprocess.run([str(build.compiler()), str(path), '-o', str(path.with_suffix('.js'))],
                              capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(compiled.stdout + compiled.stderr)
    if compiled.returncode:
        raise ValueError(f'{name} build failed: {WORK / (name + "-build.log")}')
    launcher = WORK / name
    build.executable(launcher, build.wrapper(build.runtime(), '../word-direct/' + name))
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
        raise ValueError('word parser declaration does not match its pin')
    old = subprocess.check_output(['git', '-C', str(ROOT), 'show', BASE + ':src/emitter.bend'], text=True)
    predecessor = only(list(declarations(old, '<predecessor>')), NAME)
    if predecessor is None:
        raise ValueError('word parser predecessor is missing or duplicated')
    control = [replace(row, source=predecessor.source) if row is current else row for row in records]
    before, after = cli_sources([control, records], NAME)
    if before != after or after is None:
        raise ValueError('word parser compatibility bundle mismatch')
    for poison in (records + [current], [row for row in records if row is not current],
                   [replace(row, source=row.source + '\n') if row is current else row for row in records]):
        if pinned(control, poison) is not None:
            raise ValueError('invalid word parser pin accepted')
    # Change a reachable helper while preserving the exact pinned declaration.
    unrelated = [replace(row, source=row.source.replace('NativeChar.lower', 'NativeChar.upper'))
                 if row.name == 'NativeString.lower' else row for row in records]
    other_before, other_after = cli_sources([control, unrelated], NAME)
    if other_before == other_after or other_after is None:
        raise ValueError('unrelated helper change was hidden by the pin')

    maximum = 2 ** 256 - 1
    rows = ['', '0', '00', '01', '9', '10', '0x', '0X', '0x0', '0x1', '0x10', '0XAbCd',
            '0xff', '0xFF', '0xg', '0xx1', '0x-1', '+1', '-1', ' 1', '1 ', '1\n', '\x00',
            '1_0', '1.0', '0b10', '0o10', 'é', '😀', '１２', '١٢',
            str(maximum), str(maximum + 1), str(maximum + 2), hex(maximum), hex(maximum + 1),
            '9' * 78, '0' * 78, '0' * 79, '0x' + '0' * 64, '0x' + '0' * 65,
            '0x' + 'f' * 64, '0x' + 'f' * 65, '0x' + '0' * 8192]
    rows.extend('0x' + chr(code) for code in range(256))
    rows.extend('0x1' + chr(code) for code in range(256))
    rng = random.Random(0xA55A7)
    for _ in range(256):
        value = rng.getrandbits(rng.randrange(0, 260))
        rows.extend((str(value), hex(value), '0X' + format(value, 'X')))
    alphabet = '0123456789abcdefABCDEFxX+-_ .\t\r\né😀'
    rows.extend(''.join(rng.choice(alphabet) for _ in range(rng.randrange(0, 84))) for _ in range(256))
    inputs = [literal(row) for row in rows]
    inputs[rows.index('0x' + '0' * 8192)] = 'String.append("0x", NativeString.repeat(8192n, Char.from_u32(48)))'
    entry = '''@unsafe
def WordDirect.result(value: Result<&2, &2, String, Big>) -> String:
  match value:
    case Done{word}: Big.show(word)
    case Fail{error}: error
@unsafe
def WordDirect.each(sources: List<&2, String>) -> IO(Unit):
  match sources:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{source, rest}: do IO<Unit>:
      NativeIO.print(WordDirect.result(Recognize.parse_word(&2, String, "invalid", "overflow", source)))
      WordDirect.each(rest)
def WordDirect.main() -> IO(Unit):
  WordDirect.each([''' + ', '.join(inputs) + '])\n'
    expected = ''.join(golden(row) + '\n' for row in rows).encode()
    baseline = compile_and_run(control, entry, 'control')
    actual = compile_and_run(records, entry, 'native')
    if baseline != expected or actual != expected:
        raise ValueError('word parser predecessor or implementation disagrees with goldens')
    mutants = {}
    for name, count, case in (('prefix-kept', '0n', '0x1'), ('prefix-short', '1n', '0x1'),
                              ('prefix-long', '3n', '0x10')):
        source = current.source.replace('NativeString.drop(2n,', 'NativeString.drop(' + count + ',', 1)
        if source == current.source:
            raise ValueError('mutation point missing: ' + name)
        mutant = [replace(row, source=source) if row is current else row for row in records]
        output = compile_and_run(mutant, entry, name)
        lines = output.decode().splitlines()
        index = rows.index(case)
        if len(lines) != len(rows) or lines[index] == golden(case):
            raise ValueError('compiled mutant failed to produce its named wrong answer: ' + name)
        mutants[name] = dict(killed=True, case=case, expected=golden(case), actual=lines[index],
                             output_sha256=hashlib.sha256(output).hexdigest())
    if compile_and_run(records, entry, 'restored') != expected:
        raise ValueError('restored word parser disagrees with goldens')
    report = dict(base=BASE, cases=len(rows), golden=len(rows), mutants=mutants,
                  declaration_sha256=PINS[NAME], output_sha256=hashlib.sha256(actual).hexdigest())
    (WORK / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'WORD-DIRECT cases={len(rows)} golden={len(rows)} mutants={len(mutants)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('WORD-DIRECT FAIL ' + str(error), file=sys.stderr)
        sys.exit(1)

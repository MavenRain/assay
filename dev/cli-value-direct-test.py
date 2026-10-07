#!/usr/bin/env python3
"""Compare trace value normalization with its predecessor and uint256 goldens."""
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
from cli_delta import PINS, cli_sources, only, pinned, source_records

BASE = '7af4b0478d6e1dd23ab98c0b3aa7f9e0d8d25fcd'
NAME = 'Trace.value'
WORK = ROOT / '_build/cli-value-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{ord(char):x}' + '}' for char in text) + '"'


def codes(text):
    return ''.join(str(ord(char)) + ',' for char in text)


def golden(text):
    normalized = text.lower()
    hexadecimal = normalized.startswith('0x')
    digits = normalized[2:] if hexadecimal else normalized
    pattern, limit, radix = ('[0-9a-f]+', 64, 16) if hexadecimal else ('[0-9]+', 78, 10)
    if len(digits) > limit or re.fullmatch(pattern, digits) is None or int(digits, radix) >= 2 ** 256:
        return None
    value = normalized if hexadecimal else (normalized.lstrip('0') or '0')
    return 'OK|' + codes(value)


def fixtures():
    maximum = 2 ** 256 - 1
    rows = ['', '0', '00', '000', '00102', '10020', '0x', '0X', '0x0', '0X00AB',
            '-1', '+1', '1.0', '1e2', ' 01', '01 ', '01\n', '0\t1', '\0', '٠١',
            '０１', 'é', 'e\u0301', '🦀', '0xİ', '0xK', '0xſ']
    for length in (1, 2, 63, 64, 65, 77, 78, 79, 128):
        rows.extend(('0' * length, '0' * (length - 1) + '1', '9' * length,
                     '0x' + '0' * length, '0X' + 'F' * length))
    for number in (0, 1, 10, 2 ** 160 - 1, 2 ** 160, maximum - 1, maximum, maximum + 1):
        rows.extend((str(number), '00' + str(number), '0x' + format(number, 'x'),
                     '0X' + format(number, 'X')))
    rows.extend('0' + chr(code) for code in range(256))
    rng = random.Random(20261001)
    for _ in range(128):
        number = rng.randrange(2 ** 256)
        rows.extend((str(number), '0' * rng.randrange(1, 6) + str(number),
                     '0X' + format(number, 'X')))
    alphabet = '0123456789abcdefABCDEFxX +-\n\r\t\0é🦀'
    rows.extend(''.join(rng.choice(alphabet) for _ in range(rng.randrange(0, 84))) for _ in range(128))
    return rows


ENTRY = '''@unsafe
def CliValueDirect.codes(text: String) -> String:
  match text:
    case SNil{}: ""
    case SCon{char, rest}: String.append(Big.show(Big.of_nat(U32.to_nat(Char.to_u32(char)))), String.append(",", CliValueDirect.codes(rest)))
@unsafe
def CliValueDirect.result(result: Trace.Result(String)) -> String:
  match result:
    case Done{value}: String.append("OK|", CliValueDirect.codes(value))
    case Fail{error}: String.append("ERR|", CliValueDirect.codes(Trace.error(error)))
@unsafe
def CliValueDirect.each(rows: ListOf(String)) -> IO(Unit):
  match rows:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{text, rest}: do IO<Unit>:
      NativeIO.print(CliValueDirect.result(Trace.value(text)))
      CliValueDirect.each(rest)
@unsafe
def CliValueDirect.main() -> IO(Unit):
  CliValueDirect.each(%s)
'''


def compile_and_run(records, inputs, name):
    values = '[' + ', '.join(literal(text) for text in inputs) + ']'
    entry = ENTRY % values
    source = bundle(reachable(records + list(declarations(entry, '<cli-value-direct>')),
                              'CliValueDirect.main'), 'CliValueDirect.main')
    path = WORK / (name + '.bend')
    path.write_text(source.replace('import "./os.js"', 'import "../../src/os.js"'))
    compiled = subprocess.run([str(build.compiler()), str(path), '-o', str(path.with_suffix('.js'))],
                              capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(compiled.stdout + compiled.stderr)
    if compiled.returncode:
        raise ValueError(name + ' build failed; see ' + str(WORK / (name + '-build.log')))
    result = subprocess.run([build.runtime(), str(path.with_suffix('.js'))],
                            capture_output=True, timeout=180)
    (WORK / (name + '.stdout.log')).write_bytes(result.stdout)
    (WORK / (name + '.stderr.log')).write_bytes(result.stderr)
    if result.returncode or result.stderr:
        raise ValueError(f'{name} exit={result.returncode} stderr={result.stderr[:500]!r}')
    lines = result.stdout.decode().splitlines()
    if len(lines) != len(inputs):
        raise ValueError(name + ' result count mismatch')
    return lines


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    records = [row for path in sorted((ROOT / 'src').glob('*.bend'))
               for row in declarations(path.read_text(), path.relative_to(ROOT))]
    current = only(records, NAME)
    old = list(declarations(subprocess.check_output(
        ['git', '-C', str(ROOT), 'show', BASE + ':src/cli.bend'], text=True), '<predecessor>'))
    previous = only(old, NAME)
    if current is None or previous is None or hashlib.sha256(current.source.encode()).hexdigest() != PINS[NAME]:
        raise ValueError('missing, duplicate or unpinned Trace.value')
    control = [previous if row is current else row for row in records]
    before, after = cli_sources([control, records])
    if after is None or before != after:
        raise ValueError('CLI value compatibility bundle mismatch')
    for poison in (records + [current], [row for row in records if row is not current],
                   [replace(row, source=row.source + '\n') if row is current else row for row in records]):
        if pinned(control, poison) is not None:
            raise ValueError('CLI value pin accepted missing, duplicate or modified body')
    unrelated = only(records, 'NativeString.lower')
    poisoned = [replace(row, source=row.source.replace('NativeChar.lower(c)', 'c'))
                if row is unrelated else row for row in records]
    other_before, other_after = cli_sources([control, poisoned])
    if poisoned == records or other_after is None or other_before == other_after:
        raise ValueError('CLI value pin hid an unrelated change')
    inputs = fixtures()
    # The predecessor caller and its Model.Error handler must come from one revision.
    expected = compile_and_run(source_records(ROOT, BASE)[0], inputs, 'predecessor')
    actual = compile_and_run(records, inputs, 'current')
    if actual != expected:
        raise ValueError('predecessor mismatch')
    for text, output in zip(inputs, actual):
        answer = golden(text)
        if (answer is not None and output != answer) or (answer is None and not output.startswith('ERR|')):
            raise ValueError('golden mismatch: ' + repr(text))
    mutations = (
        ('keep-zeros', 'SeqList.drop_while(&2, Char, (+local15973 => (NativeChar.equal(local15973, Char.from_u32(48)))), NativeString.to_list(scrut15968))',
         'NativeString.to_list(scrut15968)', '00102', 'OK|' + codes('00102')),
        ('drop-ones', 'Char.from_u32(48)', 'Char.from_u32(49)', '00102', 'OK|' + codes('00102')),
        ('empty-zero', '_ => ("0")', '_ => ("")', '000', 'OK|'),
    )
    receipts = []
    for name, target, replacement, text, wrong in mutations:
        if current.source.count(target) != 1:
            raise ValueError('mutation target mismatch: ' + name)
        mutated = replace(current, source=current.source.replace(target, replacement))
        result = compile_and_run([mutated if row is current else row for row in records], [text], name)
        if result != [wrong] or wrong == golden(text):
            raise ValueError('mutation was not observed: ' + name)
        receipts.append({'name': name, 'input': text, 'observed': result[0]})
    restored = compile_and_run(records, inputs, 'restored')
    if restored != actual:
        raise ValueError('restored control mismatch')
    report = {'base': BASE, 'cases': len(inputs), 'golden': len(inputs), 'mutants': receipts,
              'declaration_sha256': PINS[NAME],
              'output_sha256': hashlib.sha256(('\n'.join(actual) + '\n').encode()).hexdigest()}
    (WORK / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'CLI-VALUE-DIRECT cases={len(inputs)} golden={len(inputs)} mutants={len(receipts)} OK')


if __name__ == '__main__':
    main()

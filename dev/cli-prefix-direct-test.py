#!/usr/bin/env python3
"""Compare CLI prefix removal with its predecessor and independent input goldens."""
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

BASE = '356ce95673480c8b6290e9549a3a47153c44933f'
NAMES = ('Trace.calldata', 'Trace.caller', 'Differential.caller')
ADDRESSES = ('0x7e5f4552091a69125d5dfcb7b8c2659029395bdf',
             '0x2b5ad5c4795c026514f8317c7a215e218dccd6cf')
WORK = ROOT / '_build/cli-prefix-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{ord(char):x}' + '}' for char in text) + '"'


def codes(text):
    return ''.join(str(ord(char)) + ',' for char in text)


def golden(text, name):
    normalized = text.lower()
    hexadecimal = normalized.startswith('0x')
    digits = normalized[2:] if hexadecimal else normalized
    if name == 'Trace.calldata':
        valid = len(digits) % 2 == 0 and re.fullmatch('[0-9a-f]*', digits) is not None
        return ('OK|' + codes(digits)) if valid else 'ERR'
    pattern, limit, radix = ('[0-9a-f]+', 64, 16) if hexadecimal else ('[0-9]+', 78, 10)
    if len(digits) > limit or re.fullmatch(pattern, digits) is None:
        return 'ERR'
    value = int(digits, radix)
    if value >= 2 ** 160:
        return 'ERR'
    address = f'0x{value:040x}'
    if name == 'Differential.caller' and address not in ADDRESSES:
        return 'ERR'
    return 'OK|' + codes(address)


def fixtures():
    rows = ['', '0x', '0X', '0', '00', '0x00', '0XAf', 'aB', 'abc', '0xx0',
            '0xg0', '-1', '+1', ' 1', '1 ', '\t01', '0x\n00', '\x00', 'éλ😀',
            '１２', 'e\u0301', '0x😀0', '0xİ0']
    values = [0, 1, 2, 15, 16, 255, 256, 2 ** 160 - 1, 2 ** 160,
              2 ** 256 - 1, 2 ** 256] + [int(address, 16) for address in ADDRESSES]
    for value in values:
        rows.extend([str(value), f'0x{value:x}', f'0X{value:X}', f'{value:x}',
                     f'0x{value:040x}', f'0x{value:064x}'])
    for length in (1, 2, 39, 40, 41, 63, 64, 65, 77, 78, 79):
        for prefix in ('', '0x', '0X'):
            rows.extend([prefix + '0' * length, prefix + 'f' * length,
                         prefix + '0' * (length - 1) + '1'])
    for address in ADDRESSES:
        rows.extend([address, address.upper(), address[2:], '0x0' + address[2:],
                     '0x' + address[2:-1], address + '0', str(int(address, 16)),
                     '0' + str(int(address, 16))])
    rng = random.Random(0xC11)
    alphabet = '0123456789abcdefABCDEFxX+- \x00\n\téλ😀'
    for _ in range(128):
        rows.append(''.join(rng.choice(alphabet) for _ in range(rng.randrange(0, 84))))
        value = rng.getrandbits(160)
        rows.extend([str(value), f'0x{value:040x}', f'0X{value:040X}'])
    return rows


def compile_and_run(records, entry, name):
    source = bundle(reachable(records + list(declarations(entry, '<cli-prefix-direct>')),
                              'CliPrefixDirect.main'), 'CliPrefixDirect.main')
    path = WORK / (name + '.bend')
    path.write_text(source.replace('import "./os.js"', 'import "../../src/os.js"'))
    compiled = subprocess.run([str(build.compiler()), str(path), '-o', str(path.with_suffix('.js'))],
                              capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(compiled.stdout + compiled.stderr)
    if compiled.returncode:
        raise ValueError(f'{name} build failed: {WORK / (name + "-build.log")}')
    launcher = WORK / name
    build.executable(launcher, build.wrapper(build.runtime(), '../cli-prefix-direct/' + name))
    result = subprocess.run([str(launcher)], capture_output=True, timeout=60)
    (WORK / (name + '.stdout')).write_bytes(result.stdout)
    (WORK / (name + '.stderr')).write_bytes(result.stderr)
    if result.returncode or result.stderr:
        raise ValueError(f'{name} exit={result.returncode} stderr={result.stderr[:500]!r}')
    return result.stdout


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    records = [row for path in sorted((ROOT / 'src').glob('*.bend'))
               for row in declarations(path.read_text(), path.relative_to(ROOT))]
    current = {name: only(records, name) for name in NAMES}
    old = list(declarations(subprocess.check_output(
        ['git', '-C', str(ROOT), 'show', BASE + ':src/cli.bend'], text=True), '<predecessor>'))
    previous = {name: only(old, name) for name in NAMES}
    for name in NAMES:
        if current[name] is None or previous[name] is None:
            raise ValueError('missing or duplicate declaration: ' + name)
        if hashlib.sha256(current[name].source.encode()).hexdigest() != PINS[name]:
            raise ValueError('declaration does not match its pin: ' + name)
    control = [replace(row, source=previous[row.name].source) if row.name in NAMES else row
               for row in records]
    before, after = cli_sources([control, records])
    if before != after or after is None:
        raise ValueError('CLI prefix compatibility bundle mismatch')
    for name in NAMES:
        row = current[name]
        for poison in (records + [row], [item for item in records if item is not row],
                       [replace(item, source=item.source + '\n') if item is row else item for item in records]):
            if pinned(control, poison) is not None:
                raise ValueError('invalid pin accepted: ' + name)
    unrelated = [replace(row, source=row.source.replace('NativeString.map(+c => NativeChar.lower(c), text)', 'text'))
                 if row.name == 'NativeString.lower' else row for row in records]
    other_before, other_after = cli_sources([control, unrelated])
    if other_before == other_after or other_after is None:
        raise ValueError('unrelated lowercase helper change was hidden by the pins')

    rows = fixtures()
    entry = '''@unsafe
def CliPrefixDirect.codes(text: String) -> String:
  match text:
    case SNil{}: ""
    case SCon{char, rest}: String.append(Big.show(Big.of_nat(U32.to_nat(Char.to_u32(char)))), String.append(",", CliPrefixDirect.codes(rest)))
@unsafe
def CliPrefixDirect.calldata(result: OptionOf(String)) -> String:
  match result:
    case Some{value}: String.append("OK|", CliPrefixDirect.codes(value))
    case None{}: "ERR|"
@unsafe
def CliPrefixDirect.caller(result: Trace.Result(String)) -> String:
  match result:
    case Done{value}: String.append("OK|", CliPrefixDirect.codes(value))
    case Fail{error}: String.append("ERR|", CliPrefixDirect.codes(Trace.error(error)))
@unsafe
def CliPrefixDirect.differential(result: Differential.Result(String)) -> String:
  match result:
    case Done{value}: String.append("OK|", CliPrefixDirect.codes(value))
    case Fail{error}: String.append("ERR|", CliPrefixDirect.codes(Differential.error(error)))
@unsafe
def CliPrefixDirect.each(rows: ListOf(String)) -> IO(Unit):
  match rows:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{+text, rest}: do IO<Unit>:
      NativeIO.print(CliPrefixDirect.calldata(Trace.calldata(text)))
      NativeIO.print(CliPrefixDirect.caller(Trace.caller(text)))
      NativeIO.print(CliPrefixDirect.differential(Differential.caller(text)))
      CliPrefixDirect.each(rest)
def CliPrefixDirect.main() -> IO(Unit):
  CliPrefixDirect.each([''' + ', '.join(literal(text) for text in rows) + '])\n'
    # Compile the historical callers with their matching Model.Error handlers.
    baseline = compile_and_run(source_records(ROOT, BASE)[0], entry, 'control')
    actual = compile_and_run(records, entry, 'native')
    lines = actual.decode().splitlines()
    expected = [golden(text, name) for text in rows for name in NAMES]
    if baseline != actual or len(lines) != len(expected):
        raise ValueError('CLI predecessor output mismatch or wrong output count')
    for index, (line, answer) in enumerate(zip(lines, expected)):
        if (answer == 'ERR' and not line.startswith('ERR|')) or (answer != 'ERR' and line != answer):
            raise ValueError(f'golden mismatch at input {index // 3}, function {NAMES[index % 3]}')
    mutants = {}
    for name in NAMES:
        row = current[name]
        witness = '0x00' if name == 'Trace.calldata' else ADDRESSES[0]
        index = rows.index(witness) * 3 + NAMES.index(name)
        for count in (0, 1, 3):
            label = name.replace('.', '-') + '-drop-' + str(count)
            source = row.source.replace('NativeString.drop(2n,', f'NativeString.drop({count}n,', 1)
            if source == row.source:
                raise ValueError('mutation point missing: ' + label)
            mutant = [replace(item, source=source) if item is row else item for item in records]
            output = compile_and_run(mutant, entry, label)
            changed = output.decode().splitlines()
            if len(changed) != len(lines) or changed[index] == lines[index]:
                raise ValueError('compiled mutant did not produce its named wrong answer: ' + label)
            mutants[label] = dict(killed=True, case=witness, expected=lines[index], actual=changed[index],
                                  output_sha256=hashlib.sha256(output).hexdigest())
    if compile_and_run(records, entry, 'restored') != actual:
        raise ValueError('restored CLI outputs differ')
    report = dict(base=BASE, inputs=len(rows), cases=len(expected), golden=len(expected), mutants=mutants,
                  declaration_sha256={name: PINS[name] for name in NAMES},
                  baseline_sha256=hashlib.sha256(baseline).hexdigest(),
                  output_sha256=hashlib.sha256(actual).hexdigest())
    (WORK / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'CLI-PREFIX-DIRECT cases={len(expected)} golden={len(expected)} mutants={len(mutants)} OK')


if __name__ == '__main__':
    main()

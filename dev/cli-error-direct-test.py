#!/usr/bin/env python3
"""Compare trace error detection with its predecessor and explicit goldens."""
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

BASE = 'bacd4ba'
NAME = 'Trace.has_error'
WORK = ROOT / '_build/cli-error-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{ord(char):x}' + '}' for char in text) + '"'


def fixtures():
    rows = [('', False), ('{}', False), ('{"result":1}', False),
            ('{"error":null}', False), ('{"error":""}', False),
            ('{"error":0}', True), ('{"error":false}', True),
            ('{"error":{}}', True), ('{"error":[]}', True),
            ('{"error":"failed"}', True), ('{"Error":1}', False),
            ('{"ERROR":1}', False), ('{"errors":1}', False),
            ('{" error":1}', False), ('{"error ":1}', False),
            ('{"nested":{"error":1}}', True),
            ('{"error":null,"error":"failed"}', True),
            ('{"error":"","error":null}', False),
            ('"error"', False), ('"error":', True),
            ('"error":nulljunk', False), ('"error":nul', True),
            ('"error" junk', False), ('"error":"', False),
            ('"error" : ""', False), ('"error": "message"', True),
            ('"error":NULL', True), ('"error"\u00a0:1', False),
            ('"error"\u2003:1', False), ('"error"\0:1', False),
            ('{"error":"é🦀"}', True), ('{"é🦀":"error"}', False)]
    values = [(None, False), ('', False), ('null', True), ('failed', True),
              (0, True), (False, True), (True, True), ([], True), ({}, True)]
    for value, answer in values:
        encoded = json.dumps(value, ensure_ascii=False)
        for whitespace in ('', ' ', '\t', '\r', '\n', ' \t\r\n', '\n  \r\t '):
            rows.append(('{"error"' + whitespace + ':' + whitespace + encoded + '}', answer))
    for code in range(256):
        separator = chr(code)
        rows.append(('"error"' + separator + ':1', separator in ' \t\r\n:'))
    for prefix in ('', '{}', '"result":1,', '"error":null,', '"error":"",'):
        for suffix in ('', '}', ',"result":1', ',"error":null'):
            rows.append((prefix + '"error" \t:\r\n7' + suffix, True))
            rows.append((prefix + '"error" \t:\r\nnull' + suffix, False))
    rng = random.Random(20261002)
    for _ in range(128):
        before = ''.join(rng.choice(' \t\r\n') for _ in range(rng.randrange(32)))
        after = ''.join(rng.choice(' \t\r\n') for _ in range(rng.randrange(32)))
        value, answer = rng.choice(values)
        rows.append(('{"error"' + before + ':' + after + json.dumps(value) + '}', answer))
    return rows


ENTRY = '''@unsafe
def CliErrorDirect.each(rows: ListOf(String)) -> IO(Unit):
  match rows:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{text, rest}: do IO<Unit>:
      NativeIO.print(Native.choose(&2, String, Trace.has_error(text), _ => "true", _ => "false"))
      CliErrorDirect.each(rest)
@unsafe
def CliErrorDirect.main() -> IO(Unit):
  CliErrorDirect.each(%s)
'''


def compile_and_run(records, inputs, name):
    entry = ENTRY % ('[' + ', '.join(literal(text) for text in inputs) + ']')
    source = bundle(reachable(records + list(declarations(entry, '<cli-error-direct>')),
                              'CliErrorDirect.main'), 'CliErrorDirect.main')
    path = WORK / (name + '.bend')
    path.write_text(source.replace('import "./os.js"', 'import "../../src/os.js"'))
    compiled = subprocess.run([str(build.compiler()), str(path), '-o', str(path.with_suffix('.js'))],
                              capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(compiled.stdout + compiled.stderr)
    if compiled.returncode:
        raise ValueError(f'{name} build failed (exit={compiled.returncode}); see ' + str(WORK / (name + '-build.log')))
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
        raise ValueError('missing, duplicate or unpinned Trace.has_error')
    control = [previous if row is current else row for row in records]
    before, after = cli_sources([control, records])
    if after is None or before != after:
        raise ValueError('CLI error compatibility bundle mismatch')
    for poison in (records + [current], [row for row in records if row is not current],
                   [replace(row, source=row.source + '\n') if row is current else row for row in records]):
        if pinned(control, poison) is not None:
            raise ValueError('CLI error pin accepted missing, duplicate or modified body')
    unrelated = only(records, 'Local.Trace.scan.f16021')
    poisoned = [replace(row, source=row.source.replace('"error"', '"Error"'))
                if row is unrelated else row for row in records]
    other_before, other_after = cli_sources([control, poisoned])
    if poisoned == records or other_after is None or other_before == other_after:
        raise ValueError('CLI error pin hid an unrelated change')
    rows = fixtures()
    inputs = [text for text, _ in rows]
    expected = ['true' if answer else 'false' for _, answer in rows]
    previous_output = compile_and_run(control, inputs, 'predecessor')
    actual = compile_and_run(records, inputs, 'current')
    if actual != previous_output:
        raise ValueError('predecessor mismatch')
    for (text, _), wanted, observed in zip(rows, expected, actual):
        if wanted != observed:
            raise ValueError(f'golden mismatch: {text!r}: wanted {wanted}, got {observed}')
    mutations = (
        ('keep-space', 'Char.from_u32(32)', 'Char.from_u32(0)', '"error" :1'),
        ('keep-lf', 'Char.from_u32(10)', 'Char.from_u32(0)', '"error"\n:1'),
        ('keep-cr', 'Char.from_u32(13)', 'Char.from_u32(0)', '"error"\r:1'),
        ('keep-tab', 'Char.from_u32(9)', 'Char.from_u32(0)', '"error"\t:1'),
        ('drop-colon', 'Char.from_u32(9)', 'Char.from_u32(58)', '"error":1'),
        ('reverse-output', 'String.reverse', '(+text => text)', '"error":1'),
    )
    receipts = []
    for name, target, replacement, text in mutations:
        if current.source.count(target) != 1:
            raise ValueError('mutation target mismatch: ' + name)
        mutated = replace(current, source=current.source.replace(target, replacement))
        result = compile_and_run([mutated if row is current else row for row in records], [text], name)
        if result != ['false']:
            raise ValueError('mutation was not observed: ' + name)
        receipts.append(dict(name=name, input=text, observed=result[0], expected='true'))
    restored = compile_and_run(records, inputs, 'restored')
    if restored != actual:
        raise ValueError('restored control mismatch')
    report = dict(base=BASE, cases=len(inputs), golden=len(rows), mutants=receipts,
                  restored=True, sha256=hashlib.sha256('\n'.join(actual).encode()).hexdigest())
    (WORK / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'CLI-ERROR-DIRECT cases={len(inputs)} golden={len(rows)} mutants={len(receipts)} OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.SubprocessError) as error:
        print('CLI-ERROR-DIRECT FAIL ' + str(error), file=sys.stderr)
        raise SystemExit(1)

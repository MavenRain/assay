#!/usr/bin/env python3
"""Check native identifier conversion against its predecessor and ASCII goldens."""
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
from cli_delta import PINS, cli_sources, pinned

BASE = 'e16c842b69448b229633a592787f2a7450938c16'
NAME = 'Recognize.identifier'
WORK = ROOT / '_build/identifier-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{ord(char):x}' + '}' for char in text) + '"'


def compile_adapter(records, entry, name):
    source = bundle(reachable(records + list(declarations(entry, '<identifier-direct>')),
                              'IdentifierDirect.main'), 'IdentifierDirect.main')
    source = source.replace('import "./os.js"', 'import "../../src/os.js"')
    path = WORK / (name + '.bend')
    path.write_text(source)
    result = subprocess.run([str(build.compiler()), str(path), '-o', str(path.with_suffix('.js'))],
                            capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(result.stdout + result.stderr)
    if result.returncode:
        raise ValueError(f'{name} build failed: {WORK / (name + "-build.log")}')
    launcher = WORK / name
    build.executable(launcher, build.wrapper(build.runtime(), '../identifier-direct/' + name))
    return launcher


def run(launcher):
    result = subprocess.run([str(launcher)], capture_output=True, timeout=60)
    if result.returncode or result.stderr:
        raise ValueError(f'{launcher.name} exit={result.returncode} stderr={result.stderr[:500]!r}')
    (WORK / (launcher.name + '.stdout')).write_bytes(result.stdout)
    return result.stdout


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    records = [record for path in sorted((ROOT / 'src').glob('*.bend'))
               for record in declarations(path.read_text(), path.relative_to(ROOT))]
    current = next(row for row in records if row.name == NAME and row.kind == 'def')
    old = subprocess.check_output(['git', '-C', str(ROOT), 'show', BASE + ':src/emitter.bend'], text=True)
    predecessor = next(row for row in declarations(old, '<predecessor>') if row.name == NAME)
    control = [replace(row, source=predecessor.source) if row is current else row for row in records]
    if hashlib.sha256(current.source.encode()).hexdigest() != PINS[NAME]:
        raise ValueError('identifier pin does not match the compiled declaration')
    before, after = cli_sources([control, records], NAME)
    if before != after or after is None:
        raise ValueError('identifier compatibility bundle mismatch')
    for poison in (records + [current], [row for row in records if row is not current],
                   [replace(row, source=row.source + '\n') if row is current else row for row in records]):
        if pinned(control, poison) is not None:
            raise ValueError('invalid identifier pin accepted')
    helper = next(row for row in records if row.name == 'NativeChar.equal')
    poisoned = [replace(row, source=row.source + '// unrelated reachable change\n')
                if row is helper else row for row in records]
    before, after = cli_sources([records, poisoned], NAME)
    if before == after:
        raise ValueError('unrelated character classification change hidden')
    rows = ['', 'a', 'Z', '_', 'a0', '_9', '0', '9a', "a'", 'a-b', 'a b',
            'a\n', '\x00', 'é', 'aé', '😀', 'a😀', 'a' * 8192, 'a' * 8191 + '!']
    rows.extend(chr(byte) for byte in range(256))
    rows.extend('a' + chr(byte) for byte in range(256))
    rng = random.Random(0x1D3)
    alphabet = "abcXYZ_01239' .,:;(){}\t\r\n<-=@é😀"
    rows.extend(''.join(rng.choice(alphabet) for _ in range(rng.randrange(0, 81))) for _ in range(512))
    inputs = [literal(row) for row in rows]
    inputs[17] = 'NativeString.repeat(8192n, Char.from_u32(97))'
    inputs[18] = 'String.append(NativeString.repeat(8191n, Char.from_u32(97)), "!")'
    entry = '''@unsafe
def IdentifierDirect.result(ok: Bool) -> String:
  match ok:
    case True{}: "1"
    case False{}: "0"
@unsafe
def IdentifierDirect.each(sources: List<&2, String>) -> IO(Unit):
  match sources:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{source, rest}: do IO<Unit>:
      NativeIO.print(IdentifierDirect.result(Recognize.identifier(source)))
      IdentifierDirect.each(rest)
def IdentifierDirect.main() -> IO(Unit):
  IdentifierDirect.each([''' + ', '.join(inputs) + '])\n'
    expected = ''.join('1\n' if re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*', row) else '0\n'
                       for row in rows).encode()
    baseline = run(compile_adapter(control, entry, 'control'))
    actual = run(compile_adapter(records, entry, 'native'))
    if baseline != expected or actual != expected:
        raise ValueError('identifier results differ from the predecessor or ASCII grammar')
    mutants = {}
    for name, chars in (('empty', 'Nil{}'), ('drop-first', 'NativeString.to_list(NativeString.drop(1n, name_1109))')):
        source = current.source.replace('NativeString.to_list(name_1109)', chars)
        if source == current.source:
            raise ValueError('identifier mutant missed its target')
        mutant = [replace(row, source=source) if row is current else row for row in records]
        output = run(compile_adapter(mutant, entry, name))
        if output == expected:
            raise ValueError('identifier mutant survived: ' + name)
        mutants[name] = dict(killed=True, output_sha256=hashlib.sha256(output).hexdigest())
    report = dict(base=BASE, cases=len(rows), golden=len(rows), mutants=mutants,
                  declaration_sha256=PINS[NAME], pin_manifest_sha256=hashlib.sha256(
                      json.dumps(PINS, sort_keys=True, separators=(',', ':')).encode()).hexdigest(),
                  output_sha256=hashlib.sha256(actual).hexdigest())
    (WORK / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'IDENTIFIER-DIRECT cases={len(rows)} golden={len(rows)} mutants={len(mutants)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('IDENTIFIER-DIRECT FAIL ' + str(error), file=sys.stderr)
        sys.exit(1)

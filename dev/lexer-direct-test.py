#!/usr/bin/env python3
"""Compare lexer values, byte payloads, locations and refusals with the pinned predecessor."""
from pathlib import Path
from dataclasses import replace
import hashlib
import json
import os
import random
import statistics
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'dev'))
import build
from bend_source import bundle, declarations, reachable
from cli_delta import PINS, cli_sources, pinned

BASE = '82f14761406f4d0cd383f284250d708595a4988e'
NAMES = ('Lexer.nat_of_digits', 'Lexer.go', 'Lexer.lex')
WORK = ROOT / '_build/lexer-direct'


def literal(text):
    return '"' + ''.join('\\u{' + f'{byte:x}' + '}' for byte in text.encode()) + '"'


def cases():
    rows = ['', 'def x := 123', 'a\nb', '000001', str(2 ** 256),
            "_x'9", 'defx Prop Type', '. .1 .2 .12',
            'b"" b"00ff10"', '-- comment\ndef', '\t\r x',
            'b"0"', 'b"gg"', 'b"00', '@', 'é', 'λ', '\x00',
            'a' * 1024, '9' * 512]
    rng = random.Random(0x1E7E)
    alphabet = "abcXYZ_01239' .,:=*|()\t\r\n->"
    rows.extend(''.join(rng.choice(alphabet) for _ in range(rng.randrange(1, 81)))
                for _ in range(256))
    rows.extend(path.read_text() for path in sorted((ROOT / 'corpus').rglob('*.asy')))
    return rows


def adapter(rows):
    return '''@unsafe
def LexerDirect.kind(kind: Token.Kind) -> String:
  match kind:
    case Token.Kind.Bytes{bytes}: String.append("bytes ", String.join(SeqList.map(&2, &2, Big, String, +arg0 => Big.show(arg0), bytes), ","))
    case _: Token.describe(kind)
@unsafe
def LexerDirect.loc(loc: Token.Loc) -> String:
  match loc:
    case MkToken_Loc{line, col}: String.concat([Big.show(line), ":", Big.show(col)])
@unsafe
def LexerDirect.token(token: Token) -> String:
  match token:
    case MkToken{kind, loc}: String.concat([LexerDirect.kind(kind), "@", LexerDirect.loc(loc)])
@unsafe
def LexerDirect.result(result: CheckResult(ListOf(Token))) -> String:
  match result:
    case Done{tokens}: String.join(SeqList.map(&2, &2, Token, String, +arg0 => LexerDirect.token(arg0), tokens), "|")
    case Fail{error}: String.append("ERR ", Error.to_string(error))
@unsafe
def LexerDirect.lex(source: String) -> String:
  LexerDirect.result(Lexer.lex(source))
@unsafe
def LexerDirect.each(sources: List<&2, String>) -> IO(Unit):
  match sources:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{source, rest}: do IO<Unit>:
      NativeIO.print(NativeString.quoted(LexerDirect.lex(source)))
      LexerDirect.each(rest)
def LexerDirect.main() -> IO(Unit):
  LexerDirect.each([''' + ', '.join(literal(row) for row in rows) + '])\n'


def compile_adapter(records, entry, name):
    records = records + list(declarations(entry, '<lexer-direct-test>'))
    source = bundle(reachable(records, 'LexerDirect.main'), 'LexerDirect.main')
    source = source.replace('import "./os.js"', 'import "../../src/os.js"')
    path = WORK / (name + '.bend')
    path.write_text(source)
    result = subprocess.run([str(build.compiler()), str(path), '-o', str(WORK / (name + '.js'))],
                            capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (WORK / (name + '-build.log')).write_bytes(result.stdout + result.stderr)
    if result.returncode:
        raise ValueError(f'{name} build failed: {WORK / (name + "-build.log")}')
    launcher = WORK / name
    build.executable(launcher, build.wrapper(build.runtime(), '../lexer-direct/' + name))
    return launcher


def run(launcher):
    start = time.perf_counter()
    result = subprocess.run([str(launcher)], capture_output=True, timeout=60)
    elapsed = time.perf_counter() - start
    if result.returncode or result.stderr:
        raise ValueError(f'{launcher.name} exit={result.returncode} stderr={result.stderr[:500]!r}')
    return result.stdout, elapsed


def check_pins(control, records):
    before, after = cli_sources([control, records], 'Lexer.lex')
    if before != after or after is None:
        raise ValueError('lexer compatibility bundle mismatch')
    for name in PINS:
        row = next(row for row in records if row.kind == 'def' and row.name == name)
        poisoned = [replace(item, source=item.source + '\n') if item is row else item for item in records]
        if pinned(control, poisoned) is not None:
            raise ValueError('modified lexer pin accepted: ' + name)
        if pinned(control, [item for item in records if item is not row]) is not None:
            raise ValueError('missing lexer pin accepted: ' + name)
        if pinned(control, records + [row]) is not None:
            raise ValueError('duplicate lexer pin accepted: ' + name)
    row = next(row for row in records if row.kind == 'def' and row.name == 'Lexer.is_digit')
    poisoned = [replace(item, source=item.source + '// unrelated reachable change\n')
                if item is row else item for item in records]
    before, after = cli_sources([control, poisoned], 'Lexer.lex')
    if before == after:
        raise ValueError('unrelated reachable change hidden by normalization')


def main():
    subprocess.run([sys.executable, '-P', str(ROOT / 'dev/lexer-direct-compatibility.py')], check=True)
    WORK.mkdir(parents=True, exist_ok=True)
    rows = cases()
    entry = adapter(rows)
    records = [record for path in sorted((ROOT / 'src').glob('*.bend'))
               for record in declarations(path.read_text(), path.relative_to(ROOT))]
    old = subprocess.check_output(['git', '-C', str(ROOT), 'show', BASE + ':src/frontend.bend'], text=True)
    originals = {row.name: row for row in declarations(old, 'src/frontend.bend')
                 if row.kind == 'def' and row.name in NAMES}
    if set(originals) != set(NAMES):
        raise ValueError('missing predecessor declarations')
    control = [originals.get(row.name, row) if row.kind == 'def' and row.path == 'src/frontend.bend'
               else row for row in records]
    check_pins(control, records)
    before = compile_adapter(control, entry, 'before')
    after = compile_adapter(records, entry, 'after')
    expected, _ = run(before)
    actual, _ = run(after)
    if actual != expected or len(actual.splitlines()) != len(rows):
        raise ValueError('lexer token, payload, location or refusal mismatch')
    golden = [
        '"end of input@1:1"',
        '"\'def\'@1:1|identifier x@1:5|\':=\'@1:7|number 123@1:10|end of input@1:13"',
        '"identifier a@1:1|identifier b@2:1|end of input@2:2"',
        '"number 1@1:1|end of input@1:7"',
    ]
    if actual.decode().splitlines()[:len(golden)] != golden:
        raise ValueError('independent lexer golden mismatch')
    mutants = [
        ('digits', 'Lexer.nat_of_digits', 'NativeString.of_list(digits_445)', 'NativeString.of_list(Nil{})'),
        ('identifier', 'Lexer.go', 'NativeString.of_list(Con{p815, p847})', 'NativeString.of_list(p847)'),
        ('input', 'Lexer.lex', 'NativeString.to_list(src_932)', 'Nil{}'),
    ]
    kills = []
    for name, symbol, needle, replacement in mutants:
        row = next(row for row in records if row.kind == 'def' and row.name == symbol)
        if row.source.count(needle) != 1:
            raise ValueError('mutant replacement drift: ' + name)
        mutated = [replace(item, source=item.source.replace(needle, replacement))
                   if item is row else item for item in records]
        output, _ = run(compile_adapter(mutated, entry, 'mutant-' + name))
        differences = [index for index, pair in enumerate(zip(expected.splitlines(), output.splitlines()))
                       if pair[0] != pair[1]]
        if len(output.splitlines()) != len(rows) or not differences:
            raise ValueError('mutant did not produce a named wrong answer: ' + name)
        kills.append(dict(name=name, first_case=differences[0]))
    if run(after)[0] != expected:
        raise ValueError('restored control mismatch')
    timings = []
    for index in range(5):
        order = (before, after) if index % 2 == 0 else (after, before)
        round_times = {}
        for launcher in order:
            output, seconds = run(launcher)
            if output != expected:
                raise ValueError('timing output mismatch')
            round_times[launcher.name] = seconds
        timings.append(round_times)
    report = dict(base=BASE, cases=len(rows), golden=len(golden), mutants=kills,
                  output_sha256=hashlib.sha256(actual).hexdigest(), rounds=timings,
                  median_ratio=statistics.median(row['after'] / row['before'] for row in timings))
    (WORK / 'RESULT.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'LEXER-DIRECT cases={len(rows)} golden={len(golden)} mutants={len(kills)} rounds=5 OK')


if __name__ == '__main__':
    main()

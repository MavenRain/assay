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
CONTRACT_BASE = '42ef4be4f81a92acdf8bdb072c4b6c11af237672'
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
    before, after = cli_sources([control, records], 'Contract.lex')
    if before != after or after is None:
        raise ValueError('contract lexer compatibility bundle mismatch')
    row = next(row for row in records if row.kind == 'def' and row.name == 'Contract.word_char')
    poisoned = [replace(item, source=item.source + '// unrelated reachable change\n')
                if item is row else item for item in records]
    before, after = cli_sources([control, poisoned], 'Contract.lex')
    if before == after:
        raise ValueError('unrelated contract change hidden by normalization')


def check_contract(control, records):
    rows = ['', 'abc', 'abc def', 'a\nb', '-- comment\nabc',
            'abc:=def <- ghi', "_x'9", '123 0xabc', 'abc;',
            '\t\r abc', 'é', '\x00', 'abc' * 512,
            ';' * 8192, ';' * 8193]
    rng = random.Random(0xC07A)
    alphabet = "abcXYZ_01239' .,:;(){}\t\r\n<-=@"
    rows.extend(''.join(rng.choice(alphabet) for _ in range(rng.randrange(1, 81)))
                for _ in range(256))
    rows.extend(path.read_text() for path in sorted((ROOT / 'examples').glob('*.asy')))
    inputs = [literal(row) for row in rows]
    inputs[13] = 'NativeString.repeat(8192n, Char.from_u32(59))'
    inputs[14] = 'NativeString.repeat(8193n, Char.from_u32(59))'
    entry = '''@unsafe
def LexerDirect.token(token: Contract.Token) -> String:
  match token:
    case MkContract_Token{text, line, col}: String.concat([text, "@", Big.show(line), ":", Big.show(col)])
@unsafe
def LexerDirect.result(result: CheckResult(ListOf(Contract.Token))) -> String:
  match result:
    case Done{tokens}: String.join(SeqList.map(&2, &2, Contract.Token, String, +arg0 => LexerDirect.token(arg0), tokens), "|")
    case Fail{error}: String.append("ERR ", Error.to_string(error))
@unsafe
def LexerDirect.each(sources: List<&2, String>) -> IO(Unit):
  match sources:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{source, rest}: do IO<Unit>:
      NativeIO.print(NativeString.quoted(LexerDirect.result(Contract.lex(Series.from_string(source)))))
      LexerDirect.each(rest)
def LexerDirect.main() -> IO(Unit):
  LexerDirect.each([''' + ', '.join(inputs) + '])\n'
    before = compile_adapter(control, entry, 'contract-before')
    after = compile_adapter(records, entry, 'contract-after')
    expected, _ = run(before)
    actual, _ = run(after)
    if actual != expected or len(actual.splitlines()) != len(rows):
        raise ValueError('contract token, location, limit or refusal mismatch')
    golden = ['"@1:1"', '"abc@1:1|@1:4"',
              '"abc@1:1|def@1:5|@1:8"', '"a@1:1|b@2:1|@2:2"',
              '"abc@2:1|@2:4"']
    lines = actual.decode().splitlines()
    if lines[:len(golden)] != golden:
        raise ValueError('independent contract lexer golden mismatch')
    if not json.loads(lines[13]).endswith(';@1:8192|@1:8193') or not json.loads(lines[14]).startswith('ERR ') or 'LIMIT' not in json.loads(lines[14]):
        raise ValueError('contract token limit boundary mismatch')
    row = next(row for row in records if row.kind == 'def' and row.name == 'Contract.span')
    needle = 'NativeString.of_list(List.reverse(&2, Char, acc_502))'
    if row.source.count(needle) != 2:
        raise ValueError('contract span replacement drift')
    kills = []
    for index, name in enumerate(('eof', 'separator')):
        parts = row.source.split(needle)
        replacement = 'NativeString.of_list(Nil{})'
        source = parts[0] + (replacement if index == 0 else needle) + parts[1] + (replacement if index == 1 else needle) + parts[2]
        mutated = [replace(item, source=source) if item is row else item for item in records]
        output, _ = run(compile_adapter(mutated, entry, 'contract-mutant-' + name))
        differences = [i for i, pair in enumerate(zip(expected.splitlines(), output.splitlines()))
                       if pair[0] != pair[1]]
        if len(output.splitlines()) != len(rows) or not differences:
            raise ValueError('contract mutant did not produce a named wrong answer: ' + name)
        kills.append(dict(name=name, first_case=differences[0]))
    if run(after)[0] != expected:
        raise ValueError('restored contract control mismatch')
    timings = []
    for index in range(5):
        order = (before, after) if index % 2 == 0 else (after, before)
        times = {}
        for launcher in order:
            output, seconds = run(launcher)
            if output != expected:
                raise ValueError('contract timing output mismatch')
            times[launcher.name] = seconds
        timings.append(times)
    report = dict(base=CONTRACT_BASE, cases=len(rows), golden=len(golden), mutants=kills,
                  output_sha256=hashlib.sha256(actual).hexdigest(), rounds=timings,
                  median_ratio=statistics.median(row['contract-after'] / row['contract-before'] for row in timings))
    (WORK / 'CONTRACT-RESULT.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'CONTRACT-LEXER cases={len(rows)} golden={len(golden)} mutants={len(kills)} rounds=5 OK')


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
    old_contract = subprocess.check_output(['git', '-C', str(ROOT), 'show', CONTRACT_BASE + ':src/emitter.bend'], text=True)
    spans = [row for row in declarations(old_contract, 'src/emitter.bend')
             if row.kind == 'def' and row.name == 'Contract.span']
    if len(spans) != 1:
        raise ValueError('missing or duplicate predecessor contract span')
    originals['Contract.span'] = spans[0]
    control = [originals.get(row.name, row) if row.kind == 'def' and row.path in ('src/frontend.bend', 'src/emitter.bend')
               else row for row in records]
    check_pins(control, records)
    if sys.argv[1:] == ['--contract']:
        check_contract(control, records)
        return
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
    check_contract(control, records)
    print(f'LEXER-DIRECT cases={len(rows)} golden={len(golden)} mutants={len(kills)} rounds=5 OK')


if __name__ == '__main__':
    main()

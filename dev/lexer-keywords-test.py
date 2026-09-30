#!/usr/bin/env python3
"""Check keyword dispatch and identifier preservation against the language vocabulary."""
from pathlib import Path
import os
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'dev'))
import build
from bend_source import bundle, declarations, reachable

KEYWORDS = ('def axiom fun inj of case match as return with tuple sum prod absurd '
            'Prop Type let in natAdd natSub natMul natEq natLt auto mu mutual end nu and rec').split()


def main():
    cases = set(KEYWORDS) | {'', '_', 'x', 'Word', 'Eff', 'contract', 'storage', 'entry', 'é', 'λ'}
    for word in KEYWORDS:
        cases.update(word[:end] for end in range(len(word)))
        cases.update((word + 'x', 'x' + word, word + '_', word + '0', word.swapcase()))
    cases = sorted(cases)
    expected = ["'" + word + "'" if word in KEYWORDS else 'identifier ' + word for word in cases]
    # Bend strings carry bytes, including the UTF-8 bytes of non-ASCII identifiers.
    literals = ['"' + ''.join(chr(byte) if byte < 128 else '\\u{' + f'{byte:x}' + '}'
                              for byte in word.encode()) + '"' for word in cases]
    entry = ('@unsafe\ndef KeywordTest.each(words: List<&2, String>) -> IO(Unit):\n'
             '  match words:\n'
             '    case Nil{}: IO.pure(Unit, Unit{})\n'
             '    case Con{word, rest}: do IO<Unit>:\n'
             '      NativeIO.print(Token.describe(Lexer.ident_kind(word)))\n'
             '      KeywordTest.each(rest)\n'
             'def KeywordTest.main() -> IO(Unit):\n'
             '  KeywordTest.each([' + ', '.join(literals) + '])\n')
    records = [record for path in sorted((ROOT / 'src').glob('*.bend'))
               for record in declarations(path.read_text(), path.relative_to(ROOT))]
    records.extend(declarations(entry, '<keyword-test>'))
    source = bundle(reachable(records, 'KeywordTest.main'), 'KeywordTest.main')
    source = source.replace('import "./os.js"', 'import "../../src/os.js"')
    work = ROOT / '_build/lexer-keywords'
    work.mkdir(parents=True, exist_ok=True)
    path = work / 'main.bend'
    path.write_text(source)
    result = subprocess.run([str(build.compiler()), str(path), '-o', str(work / 'main.js')],
                            capture_output=True, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, timeout=180)
    (work / 'build.log').write_bytes(result.stdout + result.stderr)
    if result.returncode:
        raise ValueError('keyword adapter build failed: ' + str(work / 'build.log'))
    launcher = work / 'run'
    build.executable(launcher, build.wrapper(build.runtime(), '../lexer-keywords/main'))
    result = subprocess.run([str(launcher)], capture_output=True, timeout=60)
    actual = result.stdout.decode().splitlines()
    if result.returncode or result.stderr or actual != expected:
        mismatches = [(word, want, got) for word, want, got in zip(cases, expected, actual) if want != got]
        raise ValueError(f'keyword dispatch: exit={result.returncode} rows={len(actual)}/{len(expected)} '
                         f'mismatches={mismatches[:8]} stderr={result.stderr[:500]!r}')
    print(f'LEXER-KEYWORDS keywords={len(KEYWORDS)} cases={len(cases)} OK')


if __name__ == '__main__':
    main()

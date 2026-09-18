#!/usr/bin/env python3
"""Check inferred runtime bindings against typed artifacts and EVM outcomes."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/inferred-words'
spec = importlib.util.spec_from_file_location('word_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
C.WORK = WORK
require = C.require
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')
MAX = 2**256 - 1


def single(body, extra='', init='sstore cell (word 7) ;', args='(a : Word)'):
    return f'''contract InferredWords where
  storage State := {{ cell : Word }}
  {extra}
  entry test {args} : Eff Sig Word := do {body}
  constructor := do {init} pure ()
'''


def fixtures():
    return [
        ('decimal', single('let result := word 16 ; pure result')),
        ('hexadecimal', single('let result := word 0x' + 'F' * 64 + ' ; pure result')),
        ('argument', single('let result := a ; pure result')),
        ('self-shadow', single('let a := a ; pure a')),
        ('argument-shadow', single('let before := a ; let a := word 3 ; pure before')),
        ('local-shadow', single('let x := word 3 ; let x := word 4 ; pure x')),
        ('storage-snapshot', single('old <- sload cell ; let saved := old ; sstore cell (word 9) ; '
                                    'later <- sload cell ; let old := later ; pure saved')),
        ('addition', single('sstore cell (word 99) ; guard (lt256 (add a (word 10))) ; '
                            'let result := addLt a (word 10) ; sstore cell result ; pure result')),
        ('subtraction', single('sstore cell (word 99) ; guard (leWord (word 10) a) ; '
                               'let result := subLe a (word 10) ; sstore cell result ; pure result')),
        ('explicit-proof', single('(0 p : Le (word 10) a) <- guard (leWord (word 10) a) ; '
                                  'let result := subLe a (word 10) p ; pure result')),
        ('proof-hole', single('guard (leWord (word 10) a) ; let result := subLe a (word 10) _ ; pure result')),
        ('proof-helper', single('guard (leWord (word 10) a) ; '
                                'let result := subLe a (word 10) keep((word 10), a, _) ; pure result',
                                'proof keep (0 x : Word) (0 y : Word) (0 p : Le x y) : Le x y := p')),
        ('proof-bundle', single('(0 same : EqWord a (word 10)) <- guard (eqWord a (word 10)) ; '
                                'let result := subLe a (word 10) second(same) ; pure result')),
        ('predicate', single('guard (enough(a)) ; let result := subLe a (word 10) ; pure result',
                              'predicate enough (0 x : Word) : Prop := Le (word 10) x')),
        ('alias-proof', single('let floor := word 0x0A ; guard (leWord floor a) ; '
                               'let result := subLe a floor ; pure result')),
        ('invariant', single('let result := word 16 ; sstore cell result ; pure result',
                             'invariant bounded (s : State) : Prop := Le s.cell (word 255)')),
        ('custom-error', single('let floor := word 10 ; sstore cell (word 99) ; '
                                'guard TooSmall (a) (leWord floor a) ; '
                                'let result := subLe a floor ; pure result', 'error TooSmall (actual : Word)')),
        ('caller', single('who <- caller ; let sender := who ; pure sender')),
        ('mixed', single('let x : Word := word 3 ; let y := (x) ; let z : Word := y ; pure z')),
        ('nullary', single('let result := word 42 ; pure result', args='()')),
        ('example', (ROOT / 'examples/InferredWords.asy').read_text()),
    ]


def annotated(source):
    return re.sub(r'\blet\s+([A-Za-z_][A-Za-z_0-9]*)\s*:=', r'let \1 : Word :=', source)


def emit(name, source):
    path = WORK / (name + '.asy')
    path.write_text(source)
    output = WORK / name
    result = C.capture('emit-' + name, [C.BINARY, 'emit', path, '-o', output])
    require(result.returncode == 0, 'WORD-EMIT ' + name + ': ' + result.stderr)
    return path, output, (output / 'runtime.hex').read_text().strip()


def pairs():
    records = []
    for name, source in fixtures():
        _, output, _ = emit(name, source)
        reference_source = annotated(source)
        require(reference_source != source, 'WORD-PAIR-VACUOUS ' + name)
        _, reference, _ = emit('typed-' + name, reference_source)
        hashes = {}
        for file in FILES:
            content = (output / file).read_bytes()
            require(content == (reference / file).read_bytes(), 'WORD-PAIR ' + name + ' ' + file)
            hashes[file] = hashlib.sha256(content).hexdigest()
        records.append(dict(name=name, files=hashes))
    C.save('PAIRS', records)
    return len(records)


def selector(signature):
    return C.checked('selector-' + signature.split('(')[0], ['cast', 'sig', signature]).strip()[2:]


def outcome(name, path, runtime, data, want, signed):
    before = {'0': '0x7'}
    model = json.loads(C.checked('model-' + name, [C.BINARY, 'run', path, '--calldata', data,
                                                '--caller', hex(C.SENDER), '--storage', '0=7']))
    evm, _ = C.evm_run(name, runtime, data, C.SENDER, slots=before)
    require(model == want, 'WORD-MODEL ' + name + ': ' + str(model))
    require(evm == want, 'WORD-EVM ' + name + ': ' + str(evm))
    if signed:
        report, evidence = C.D.execute(runtime, data, C.prestate(before), shutil.which('evm'))
        C.save('signed-' + name, dict(report=report, evidence=evidence))
        actual = dict(status=report['status'], output=report['output'], storage=report['storage'].get(C.D.RECEIVER, {}))
        require(actual == want, 'WORD-SIGNED ' + name)
    return dict(name=name, expected=want, signed=signed)


def live():
    sources = dict(fixtures())
    tests = [('decimal', 0, 16, 7), ('hexadecimal', 0, MAX, 7),
             ('argument', 0, 0, 7), ('argument', MAX, MAX, 7),
             ('self-shadow', 19, 19, 7), ('argument-shadow', 19, 19, 7),
             ('local-shadow', 0, 4, 7), ('storage-snapshot', 0, 7, 9),
             ('addition', 0, 10, 10), ('addition', MAX - 10, MAX, MAX), ('addition', MAX - 9, None, 7),
             ('subtraction', 10, 0, 0), ('subtraction', MAX, MAX - 10, MAX - 10), ('subtraction', 9, None, 7),
             ('proof-bundle', 10, 0, 7), ('proof-bundle', 9, None, 7), ('proof-bundle', 11, None, 7),
             ('invariant', 0, 16, 16), ('custom-error', 10, 0, 99), ('custom-error', 9, None, 7),
             ('caller', 0, C.SENDER, 7), ('mixed', 0, 3, 7), ('nullary', 0, 42, 7),
             ('example', 19, 9, 9), ('example', 9, None, 7)]
    for name in ('explicit-proof', 'proof-hole', 'proof-helper', 'predicate', 'alias-proof'):
        tests.extend((name, arg, expected, 7) for arg, expected in ((10, 0), (19, 9), (9, None)))
    selectors = dict(word=selector('test(uint256)'), nullary=selector('test()'), error=selector('TooSmall(uint256)'))
    compiled = {name: emit('live-' + name, source) for name, source in sources.items()}
    records = []
    for i, (name, arg, expected, stored) in enumerate(tests):
        path, _, runtime = compiled[name]
        data = selectors['nullary'] if name == 'nullary' else selectors['word'] + f'{arg:064x}'
        error = selectors['error'] + f'{arg:064x}' if name in ('custom-error', 'example') else ''
        want = dict(status='revert' if expected is None else 'success',
                    output='0x' + error if expected is None else f'0x{expected:064x}',
                    storage={'0': hex(stored)} if stored else {})
        records.append(outcome(name + '-' + str(i), path, runtime, data, want, signed=True))
    C.save('LIVE', records)
    return len(records), sum(1 for row in records if row['signed'])


def invalid_sources():
    return [
        ('unbound', single('let result := absent ; pure result'), 'SURFACE_SCOPE: unbound word absent'),
        ('self-reference', single('let result := result ; pure result'), 'SURFACE_SCOPE: unbound word result'),
        ('wrong-annotation', single('let result : Nat := word 1 ; pure result'), 'SURFACE_SYNTAX: expected Word'),
        ('empty-annotation', single('let result : := word 1 ; pure result'), 'SURFACE_SYNTAX: expected Word'),
        ('missing-assignment', single('let result word 1 ; pure result'), 'SURFACE_SYNTAX: expected :'),
        ('missing-value', single('let result := ; pure result'), 'SURFACE_NAME:'),
        ('unit-value', single('let result := () ; pure result'), 'SURFACE_NAME:'),
        ('runtime-hole', single('let result := _ ; pure result'), 'SURFACE_NAME:'),
        ('effect-value', single('let result := caller ; pure result'), 'SURFACE_NAME:'),
        ('bad-literal', single('let result := word 0xG ; pure result'), 'SURFACE_WORD:'),
        ('erased-value', single('let (0 p : Le (word 0) (word 1)) := () ; let result := p ; pure result'),
         'SURFACE_PROOF: an erased proof is not a Word'),
        ('erased-unused', single('let (0 p : Le (word 0) (word 1)) := () ; let result := p ; revert'),
         'SURFACE_PROOF: an erased proof is not a Word'),
        ('missing-evidence', single('let result := addLt a (word 1) ; pure result'),
         'mismatch: a tuple needs a right former as its expected type'),
        ('stale-evidence', single('(0 p : Le (word 10) a) <- guard (leWord (word 10) a) ; '
                                   'let a := word 0 ; let result := subLe a (word 10) p ; pure result'),
         'and the expected type is (Lan SColl 0 (Sec SColl 0 []))'),
        ('stale-inference', single('guard (leWord (word 10) a) ; let a := word 0 ; '
                                   'let result := subLe a (word 10) ; pure result'),
         'mismatch: a tuple needs a right former as its expected type'),
        ('unused-evidence', single('let result := addLt a (word 1) ; revert'),
         'mismatch: a tuple needs a right former as its expected type'),
        ('constructor', single('pure a', init='let value := word 1 ; sstore cell value ;'),
         'SURFACE_CONSTRUCTOR: constructor accepts literal stores and deployer initialization only'),
        ('entry-scope', single('let local := a ; pure local').replace('  constructor',
                              '  entry leak () : Eff Sig Word := do let result := local ; pure result\n  constructor'),
         'SURFACE_SCOPE: unbound word local'),
        ('parameter-type', single('pure a', args='(a)'), 'SURFACE_SYNTAX: expected :'),
    ]


TUPLE_FORMER = 'mismatch: a tuple needs a right former as its expected type\n'
STALE_EVIDENCE = ('mismatch: the term has type (Elim SColl 2 (Out SPi w b Nat (APt w 10) (Out SPi w a Nat (APt w '
    '(Elim SMu Word [256] (Out SColl 1 (ALeg 0) _assay_args) as x return Nat with | (ACtor word) bits '
    'n => n)) natLt)) as flag return Type 0 with | (ALeg 0) _u => (Ran SColl 0 (Sec SColl 0 [])) | '
    '(ALeg 1) _u => (Lan SColl 0 (Sec SColl 0 []))) and the expected type is (Lan SColl 0 (Sec SColl 0 '
    '[]))\n')
EXACT = {'missing-evidence': TUPLE_FORMER, 'stale-evidence': STALE_EVIDENCE,
         'stale-inference': TUPLE_FORMER, 'unused-evidence': TUPLE_FORMER}


def refuse(name, source, marker, exact=False):
    path = WORK / (name + '.asy')
    path.write_text(source)
    output = WORK / (name + '-out')
    records = []
    for command in (['check', path], ['emit', path, '-o', output], ['run', path, '--calldata', '0x']):
        result = C.capture(name + '-' + command[0], [C.BINARY, *command])
        diagnostic = result.stdout + result.stderr
        require(result.returncode == 1 and marker in diagnostic and not output.exists(),
                'WORD-REFUSAL ' + name + ' ' + command[0] + ': ' + diagnostic)
        require(not exact or diagnostic == EXACT[name],
                'WORD-REFUSAL ' + name + ' ' + command[0] + ' exact: ' + diagnostic)
        records.append(dict(command=command[0], diagnostic=diagnostic))
    return dict(name=name, marker=marker, results=records)


def refusals():
    records = [refuse(name, source, marker, exact=name in EXACT)
               for name, source, marker in invalid_sources()]
    C.save('REFUSALS', records)
    return len(records)


def boundaries():
    records = []
    for count in (128, 129):
        source = single('let x := word 1 ; ' * count + 'pure x')
        name = 'steps-' + str(count)
        if count == 128:
            _, output, _ = emit(name, source)
            _, reference, _ = emit('typed-' + name, annotated(source))
            hashes = {}
            for file in FILES:
                content = (output / file).read_bytes()
                require(content == (reference / file).read_bytes(), 'WORD-BOUND ' + name + ' ' + file)
                hashes[file] = hashlib.sha256(content).hexdigest()
            records.append(dict(name=name, accepted=True, files=hashes))
        else:
            records.append(refuse(name, source, 'SURFACE_LIMIT: at most 128 effect steps'))
    C.save('BOUNDARIES', records)
    return len(records)


def mutants():
    annotation = 'sequence (match rest with { text = ":="; _ } :: _ -> [":="] | [] | _ :: _ -> [":"; "Word"; ":="]) rest'
    cases = [
        ('IMPLICIT', annotation, 'sequence [":"; "Word"; ":="] rest', 'pairs', 'WORD-EMIT decimal'),
        ('ANNOTATION', annotation,
         '(match rest with { text = ":"; _ } :: _ty :: rest -> expect ":=" rest | [] | _ :: _ -> expect ":=" rest)',
         'refusals', 'WORD-REFUSAL wrong-annotation check'),
        ('ERASED', 'Proof_value _ -> fail at "PROOF" "an erased proof is not a Word"',
         'Proof_value _ -> Ok "(word 256 0)"', 'refusals', 'WORD-REFUSAL erased-value check'),
        ('SHADOW', '((name.text, Word_value fresh) :: env) state written evidence rest',
         '(env @ [(name.text, Word_value fresh)]) state written evidence rest',
         'live', 'WORD-MODEL local-shadow-6'),
    ]
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-word-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(ROOT, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec',
            '.kanon-wait', '.kanon-replies', '.kanonx', '.lake', 'vendor', 'validation', '__pycache__'))
        path = copy / 'emit/contract.ml'
        original = path.read_text()
        for name, before, after, witness, marker in cases:
            require(original.count(before) == 1, 'WORD-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(original.replace(before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/dunecho.sh', 'build'], cwd=copy, timeout=120)
                require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'WORD-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/inferred-word-test.py', witness], cwd=copy, timeout=180)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'WORD-MUTANT witness ' + label + ': ' + result.stdout)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('WORD-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(cases)


def main():
    commands = dict(pairs=pairs, live=live, refusals=refusals, boundaries=boundaries, mutants=mutants)
    if sys.argv[1:] and sys.argv[1:] not in [[name] for name in commands]:
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True, exist_ok=True)
    if sys.argv[1:]:
        result = commands[sys.argv[1]]()
        print(f'INFERRED-WORDS {sys.argv[1]} {result} OK', flush=True)
    else:
        paired, (cases, signed) = pairs(), live()
        invalid, bounds, killed = refusals(), boundaries(), mutants()
        print(f'INFERRED-WORDS pairs={paired} cases={cases} signed={signed} '
              f'refusals={invalid} boundaries={bounds} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (AssertionError, OSError, ValueError, KeyError, RuntimeError, subprocess.TimeoutExpired) as error:
        print('INFERRED-WORDS FAIL: ' + str(error), flush=True)
        sys.exit(1)

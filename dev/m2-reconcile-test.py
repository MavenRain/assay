#!/usr/bin/env python3
"""Check the M2 group 8 reconciliation against the sources.

The check is static. It reads SPEC.md, the sources, the tests, the gate
entry points and the documents, and it runs no compiler. REFINED-WORD runs
the refined Word fixtures and the erasure comparison.
"""
import importlib.util
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
MODE = '--m2-reconcile'
LEGS = 110
REFINED = 'REFINED-WORD valid=2 kernel_refused=3 emitter_refused=1 OK'
EMIT = ('src/emitter.bend', '" (deferred)"')
# Deferred construct, SPEC.md text, refusal site, test evidence. A site and a test are (path, needle, ...).
# A None is an OPEN row of dev/M2-RECONCILE.md: the text, the named refusal or the test is absent.
DEFERRED = (
    ('SPar', '| `SPar{left: A, right: A}` | deferred | kernel.bend |',
     ('src/kernel.bend', '"SPar is deferred"'), ('src/tests.bend', 'Main.kneg("spar")', '"SPar is deferred"')),
    ('SNu', '| `SNu{name: String, arguments: List<A>}` | deferred | kernel.bend |',
     ('src/kernel.bend', '"SNu is deferred"'), ('src/tests.bend', 'Main.kneg("snu")', '"SNu is deferred"')),
    ('nu', 'the parser refuses it with "nu is deferred"',
     ('src/frontend.bend', '"nu is deferred"'),
     ('src/tests.bend', 'Sl_surface.parse_refusal("nu N : Type 0 :=", "nu is deferred")')),
    ('Auto', '| `Auto` | deferred |',
     ('src/kernel.bend', '"instances are deferred"'), ('test/neg/n06-auto.err', 'instances are deferred')),
    ('non-positive family', 'strictly positive is deferred`',
     ('src/kernel.bend', '"a family that is not strictly positive is deferred"'),
     ('test/neg/mu-nonpositive.err', 'not strictly positive is deferred')),
    ('right former at mu', None,
     ('src/kernel.bend', '"a right former at a mu shape is deferred"'),
     ('src/tests.bend', '"a right former at a mu shape is deferred"')),
    ('KDelay KForce', '| `KDelay KForce` | deferred | Emit in src/emitter.bend |',
     EMIT, ('src/tests.bend', 'Emit.Error.Later{"KDELAY"}', 'KForce')),
    ('RThunk', '| `RThunk` | deferred | Emit in src/emitter.bend |', EMIT,
     ('src/tests.bend', 'Emit.Error.Later{"RTHUNK"}', 'Eterm.Repr.RThunk{')),
    ('level variables', 'Level variables are deferred.', ('src/frontend.bend', '"level variables are deferred"'),
     ('src/tests.bend', 'Sl_surface.parse_refusal("axiom A : Type u", "level variables are deferred")')),
)
COUNTED = (MODE, '110')
DOCS = {
    'README.md': (MODE, 'default 110-leg gate battery', '`--m2-abi` retains its 108 legs.',
                  '[M2 closure](dev/M2-CLOSE.md) records the group 9'),
    'dev/LEXER-DIRECT.md': (MODE,),
    **{'dev/' + name + '.md': COUNTED for name in (
        'M1-BEND2', 'M1-CLOSE', 'M2-ABI-CODEC', 'M2-ABI-GOLDENS', 'M2-ABI-SCHEMA', 'M2-EVENT-DECODE',
        'M2-MAPPING', 'M2-PACKING', 'M2-RECONCILE', 'M2-REFERENCE', 'M2-RETURN-ABI', 'M2-REVERTDATA',
        'M2-SOURCE-ERC20', 'M2-SOURCE-EVENTS', 'M2-STORAGE-PROOFS')},
}
FIXTURES = ('GuardCore.asy', 'Ref20.asy', 'forged-axiom.asy', 'forged-axiom.err', 'other-value.asy',
            'other-value.err', 'out-of-range.asy', 'out-of-range.err', 'width-8.asy', 'width-8.err')


def module(name, relative):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


require = module('m2_reconcile_diff', 'evm/diff.py').require


def read(relative):
    return (ROOT / relative).read_text()


def missing(reader, evidence):
    return evidence is not None and not all(needle in reader(evidence[0]) for needle in evidence[1:])


def deferred_gaps(reader):
    spec = reader('SPEC.md')
    return ([name + ' SPEC.md' for name, text, _site, _test in DEFERRED if text is not None and text not in spec]
            + [name + ' refusal' for name, _text, site, _test in DEFERRED if missing(reader, site)]
            + [name + ' test' for name, _text, _site, test in DEFERRED if missing(reader, test)])


def doc_gaps(reader):
    return ([path + ' lacks ' + needle for path, needles in DOCS.items() for needle in needles
             if needle not in reader(path)]
            + [path + ' names a stale default' for path in DOCS
               if re.search(r'current\s+default,\s+`--m2-abi`', reader(path))])


def schedules():
    compatibility = module('m2_reconcile_schedules', 'dev/revert-compatibility.py')
    argv = sys.argv
    try:
        namespace = compatibility.load(read('dev/stage-a-gates.py'))
        return compatibility.schedule(namespace, MODE), compatibility.schedule(namespace, '--m2-abi')
    finally:
        sys.argv = argv


def main():
    gaps = deferred_gaps(read)
    require(not gaps, 'M2-RECONCILE-DEFERRED ' + '; '.join(gaps))
    gaps = doc_gaps(read)
    require(not gaps, 'M2-RECONCILE-DOCS ' + '; '.join(gaps))
    current, carried = schedules()
    names = [leg[0] for leg in current['legs']]
    require(current['stage'] == 'M2-RECONCILE' and len(names) == LEGS
            and current['legs'][:-2] == carried['legs'] and names[-2:] == ['M2-RECONCILE', 'REFINED-WORD']
            and current['legs'][-1][3] == REFINED, 'M2-RECONCILE-SCHEDULE ' + str(names[-3:]))
    makefile = read('Makefile')
    require(re.search(r'(?m)/stage-a-gates\.py ' + MODE + '$', read('dev/gates.sh'))
            and re.search(r'(?m)\bdev/stage-a-gates\.py ' + MODE + '$', makefile)
            and all('\tpython3 -P dev/' + name + '\n' in makefile
                    for name in ('m2-reconcile-test.py', 'refined-word-test.py')),
            'M2-RECONCILE-ENTRY the default gate entry points')
    table = read('dev/stage-a-test.py').split('def mutants(root):', 1)[1].split('\n    with ', 1)[0]
    mutants = re.findall(r'(?m)^        \("([A-Z0-9-]+)", ', table)
    marker = f'MUTANTS killed={len(mutants)}/{len(mutants)} OK'
    require('R0-AUDIT-MILESTONE' in mutants and marker in read('dev/stage-a-gates.py')
            and marker in read('dev/revert-compatibility.py'), 'M2-RECONCILE-MUTANTS ' + marker)
    data = ROOT / 'dev/refined-word-data'
    require(sorted(path.name for path in data.iterdir()) == sorted(FIXTURES)
            and all((data / name).read_text().strip() for name in FIXTURES)
            and all('InRange' in (data / name).read_text() for name in FIXTURES if name.endswith('.asy')),
            'M2-RECONCILE-FIXTURES dev/refined-word-data')
    controls = (
        deferred_gaps(lambda path: read(path).replace('"SPar is deferred"', '')),
        deferred_gaps(lambda path: read(path).replace('instances are deferred', '')),
        doc_gaps(lambda path: read(path).replace('110', '108')),
    )
    require(all(controls), 'M2-RECONCILE-CONTROLS a removed refusal, test or leg count was accepted')
    tested = sum(test is not None for _name, _text, _site, test in DEFERRED)
    print(f'M2-RECONCILE deferred={len(DEFERRED)} tested={tested} open={len(DEFERRED) - tested}'
          f' docs={len(DOCS)} legs={LEGS} mutants={len(mutants)} fixtures={len(FIXTURES)}'
          f' controls={len(controls)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError) as error:
        print('M2-RECONCILE FAIL ' + str(error))
        sys.exit(1)

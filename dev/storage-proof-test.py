#!/usr/bin/env python3
"""Check storage certificates against production lanes and independent bit masks."""
from pathlib import Path
import importlib.util
import json
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
PACKAGE = ROOT / 'verification'
WORK = ROOT / '_build/storage-proofs'
THEOREMS = ['refinement_exact', 'refinement_rejects', 'refined_bounded', 'field_fits',
            'read_exact', 'write_exact', 'write_readback', 'write_preserves_low',
            'write_preserves_high', 'write_bounded', 'write_total', 'cell_slot_bounded',
            'cell_value_bounded']


def require(ok, message):
    if not ok:
        raise AssertionError('STORAGE-PROOFS ' + message)


def capture(name, command, cwd=ROOT, timeout=180):
    argv = list(map(str, command))
    try:
        result = subprocess.run(argv, cwd=cwd, capture_output=True, text=True, timeout=timeout)
        record = dict(command=argv, exit=result.returncode, stdout=result.stdout, stderr=result.stderr)
    except subprocess.TimeoutExpired as error:
        record = dict(command=argv, exit=None, timeout=True,
                      stdout=str(error.stdout or ''), stderr=str(error.stderr or ''))
    (WORK / (name + '.json')).write_text(json.dumps(record, indent=2) + '\n')
    require(record['exit'] is not None, name + ' timeout')
    return record


def good(record, name):
    require(record['exit'] == 0 and not record['stderr'], name + ' failed, see ' + str(WORK))
    return record['stdout']


# write_total reuses core Nat division lemmas that carry the three standard axioms; every other
# theorem must stay axiom free. Drop the entry when write_total gets an axiom-free proof.
CLASSICAL = {'write_total': {'propext', 'Classical.choice', 'Quot.sound'}}


def axiom_row(row):
    allowed = CLASSICAL.get(row.group(1), set())
    used = set(filter(None, map(str.strip, (row.group(2) or '').split(','))))
    return row.group(2) is None or (bool(used) and used <= allowed)


def axiom_report(text):
    pattern = r"'AssayProofs\.Storage\.([a-z_]+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
    rows = [re.fullmatch(pattern, line) for line in text.splitlines()]
    return (all(rows) and [row.group(1) for row in rows] == THEOREMS and
            all(map(axiom_row, rows)))


def proofs():
    require(json.loads((PACKAGE / 'lake-manifest.json').read_text())['packages'] == [],
            'unexpected dependencies')
    built = capture('build', ['leancho', '--warn', '-C', PACKAGE])
    require(built['exit'] == 0 and '0 errors, 0 sorries, 0 warnings' in built['stdout'],
            'Lean build, see ' + str(WORK / 'build.json'))
    text = good(capture('axioms', ['lake', 'env', 'lean', 'StorageAxioms.lean'], PACKAGE), 'axioms')
    require(axiom_report(text), 'axiom inventory')
    tail = '\n'.join(text.splitlines()[1:]) + '\n'
    prefix = "'AssayProofs.Storage.refinement_exact' depends on axioms: "
    classical = re.sub(r"(write_total' depends on axioms: \[)", r"\1sorryAx, ", text)
    require(classical != text, 'write_total classical row')
    controls = [tail, text + text.splitlines()[0] + '\n',
                prefix + '[sorryAx]\n' + tail, prefix + '[Unreviewed.axiom]\n' + tail,
                prefix + '[propext]\n' + tail, prefix + '[Classical.choice]\n' + tail, classical]
    require(all(not axiom_report(value) for value in controls), 'axiom report controls')
    return len(controls)


def corpus():
    spec = importlib.util.spec_from_file_location('layout_packed', ROOT / 'dev/layout-packed-test.py')
    packed = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(packed)
    accesses, writes = packed.accesses()
    for label, typ, offset, before, value, mask in writes:
        after = (before & (packed.WORD ^ mask)) | (value << (offset * 8))
        accesses.append((label + '.readback', packed.query('read', typ, offset, packed.WORD, after),
                         f'OK {value}'))
    accesses.extend(row for row in packed.negatives()
                    if row[1].startswith(('read|', 'write|'))
                    and not (row[0].startswith('negative.value.') and row[0].endswith('.-1')))
    for typ, width in packed.WIDTHS.items():
        for offset in range(33 - width):
            accesses.append((f'zero-slot.{typ}.{offset}',
                             packed.query('write', typ, offset, 0, packed.WORD, 0),
                             f'OK {packed.WORD ^ (((1 << (8 * width)) - 1) << (8 * offset))}'))
    for offset in (0, 31):
        for value in range(256):
            accesses.append((f'byte.{offset}.{value}',
                             packed.query('read', 'uint8', offset, 0, value << (8 * offset)),
                             f'OK {value}'))
    for offset in range(32):
        for dirty in (2, 127, 255):
            accesses.append((f'dirty-bool.{offset}.{dirty}',
                             packed.query('read', 'bool', offset, 0, dirty << (8 * offset)),
                             'ERR out-of-range:bool'))
    distinct = {}
    for row in accesses:
        if row[1] in distinct:
            require(distinct[row[1]][2] == row[2], 'conflicting oracle')
        distinct[row[1]] = row
    accesses = list(distinct.values())
    refinements = []
    lexical = []
    for typ, width in packed.WIDTHS.items():
        limit = 2 if typ == 'bool' else 1 << (8 * width)
        values = set((0, 1, limit - 1, limit, limit + 1, 1 << 256))
        if typ in ('bool', 'uint8'):
            values.update(range(260))
        for value in sorted(values):
            expected = f'OK {value}' if value < limit else f'ERR out-of-range:{typ}'
            refinements.append((f'refine.{typ}.{value}', f'refine|{typ}|{value}', expected))
        lexical.append((f'lexical.refine.{typ}.-1', f'refine|{typ}|-1', 'ERR invalid-value'))
        lexical.append((f'lexical.write.{typ}.-1', packed.query('write', typ, 0, 0, 0, -1),
                        'ERR invalid-value'))
    top = (1 << 256) - 1
    lexical.extend((f'lexical.refine.uint8.{name}', f'refine|uint8|{text}', expected)
                   for name, text, expected in [('plus-one', '+1', 'ERR invalid-value'),
                                                ('abc', 'abc', 'ERR invalid-value'),
                                                ('empty', '', 'ERR invalid-value'),
                                                ('space-one', ' 1', 'ERR invalid-value'),
                                                ('padded-seven', '007', 'OK 7'),
                                                ('padded-zero-79', '0' * 79, 'OK 0')])
    lexical.extend([('lexical.refine.uint256.padded-top-79', f'refine|uint256|0{top}', f'OK {top}'),
                    ('lexical.write.uint8.padded-seven', 'write|uint8|0|0|0|007', 'OK 7'),
                    ('lexical.write.uint8.abc', 'write|uint8|0|0|0|abc', 'ERR invalid-value')])
    return packed, accesses, refinements, lexical


def lean_cases(cases, package=PACKAGE, label='live'):
    observed = []
    for start in range(0, len(cases), 64):
        batch = cases[start:start + 64]
        source = json.dumps([row[1] for row in batch])
        result = good(capture(f'{label}-{start}',
                             [package / '.lake/build/bin/storageModel', source]), label)
        rows = json.loads(result)
        require(len(rows) == len(batch), label + ' arity')
        for (name, _, expected), actual in zip(batch, rows):
            require(actual == expected, f'{name}: expected {expected!r}, observed {actual!r}')
        observed.extend(rows)
    return observed


def source_representation():
    source = (ROOT / 'examples/MappingAccess.asy').read_text()
    old = 'balances : Mapping Address Uint256'
    require(source.count(old) == 1, 'mapping fixture site')
    good(capture('mapping-control', [ROOT / 'assay', 'check', ROOT / 'examples/MappingAccess.asy']),
         'mapping control')
    for name, replacement in [('mapping-closure', 'balances : Mapping Address (Word -> Word)'),
                              ('scalar-closure', 'balances : (Word -> Word)')]:
        path = WORK / (name + '.asy')
        path.write_text(source.replace(old, replacement))
        result = capture(name, [ROOT / 'assay', 'check', path])
        require(result['exit'] != 0, name + ' accepted')
        require('SURFACE_TOKEN' in result['stderr'], name + ' refused outside the lexer')
    return 2


EXECUTABLE = ['refine', 'field', 'read', 'write']


def symbol(name):
    """Lean C symbol of AssayProofs.Storage.<name>; an underscore inside a component lowers to __."""
    return ('_AssayProofs_Storage_' + name.replace('_', '__')).encode()


def mutants():
    changes = [
        ('refinement-bound', 'if bound : value < scalar.limit then',
         'if bound : value ≤ scalar.limit then', 'compile'),
        ('field-bound', 'if fits : offset + scalar.width ≤ 32 then',
         'if fits : offset + scalar.width ≤ 33 then', 'compile'),
        ('word-bound', 'result < modulus ∧', 'result ≤ modulus ∧', 'compile'),
        ('storage-closure', '  value : Word\n', '  value : Word → Word\n', 'compile'),
        ('bool-range', '  | .bool => 2\n', '  | .bool => 256\n', 'semantic'),
        ('write-shift', '+ value.val * shift location\n',
         '+ value.val * (shift location * 256)\n', 'compile'),
        ('write-refuses', '.ok ⟨⟨result, certificate.1⟩, rfl, certificate.2⟩',
         '.error .certificateFailure', 'compile'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-storage-mutants-') as temp:
        folder = Path(temp) / 'verification'
        shutil.copytree(PACKAGE, folder)
        path = folder / 'AssayProofs/Storage.lean'
        original = path.read_text()
        for name, old, new, kind in changes:
            require(original.count(old) == 1, 'mutation site ' + name)
            path.write_text(original.replace(old, new))
            if kind == 'compile':
                result = capture(name, ['lake', 'env', 'lean', 'AssayProofs/Storage.lean'], folder)
                diagnostic = re.search(r'error(?:\([^)]*\))?:', result['stdout'])
                require(result['exit'] != 0 and diagnostic is not None, name + ' survived')
            else:
                good(capture(name + '-build', ['lake', 'build', 'storageModel'], folder), name + ' build')
                query = 'refine|bool|2' if name == 'bool-range' else 'write|uint8|1|0|0|1'
                expected = 'ERR out-of-range:bool' if name == 'bool-range' else 'OK 256'
                output = good(capture(name, [folder / '.lake/build/bin/storageModel', json.dumps([query])]), name)
                require(json.loads(output) != [expected], name + ' survived')
            path.write_text(original)
        good(capture('erasure-control-build', ['lake', 'build', 'storageModel'], folder), 'control build')
        cfile = folder / '.lake/build/ir/AssayProofs/Storage.c'
        code = cfile.read_bytes()
        missing = [name for name in EXECUTABLE if symbol(name) + b'(' not in code]
        require(missing == [], 'missing executable definitions: ' + ', '.join(missing))
        erased = [name for name in THEOREMS if symbol(name) not in code]
        require(erased == THEOREMS,
                'theorem not erased: ' + ', '.join(name for name in THEOREMS if name not in erased))
        lean_cases([('restored-bool', 'refine|bool|2', 'ERR out-of-range:bool'),
                    ('restored-write', 'write|uint8|1|0|0|1', 'OK 256')], folder, 'erasure-control')
        marker = 'end AssayProofs.Storage'
        require(original.count(marker) == 1, 'erasure probe site')
        probe = 'def erasure_probe_marker (word : Word) : Nat := word.val + 1\n\n' + marker
        path.write_text(original.replace(marker, probe))
        good(capture('erasure-probe-build', ['lake', 'build', 'storageModel'], folder), 'probe build')
        probed = cfile.read_bytes()
        require(symbol('erasure_probe_marker') in probed, 'erasure probe not lowered')
        require(b'_AssayProofs_Storage_erasure_probe_marker' not in probed, 'erasure probe spelling')
        path.write_text(original)
    return len(changes), len(erased)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    controls = proofs()
    packed, accesses, refinements, lexical = corpus()
    packed.build(ROOT)
    production = packed.check(ROOT, accesses)
    lean_cases(accesses)
    lean_cases(refinements, label='refinements')
    lean_cases(lexical, label='lexical')
    require(len(production) == len(accesses), 'production coverage')
    refusals = source_representation()
    killed, erased = mutants()
    summary = dict(theorems=len(THEOREMS), accesses=len(accesses), refinements=len(refinements),
                   lexical=len(lexical), grammar=refusals, mutants=killed, controls=controls, erasure=erased)
    (WORK / 'SUMMARY.json').write_text(json.dumps(summary, indent=2) + '\n')
    print('STORAGE-PROOFS ' + ' '.join(f'{key}={value}' for key, value in summary.items()) + ' OK')


if __name__ == '__main__':
    main()

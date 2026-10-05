#!/usr/bin/env python3
"""Compare the complete ERC20 ABI and reject invalid Lean storage witnesses."""
from copy import deepcopy
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/m2-abi'
GOLDEN = ROOT / 'reference/erc20/abi.json'
GOLDEN_SHA256 = '7715636c0342b68c68f6b93c1daf97e35d901770d2a7086055607bff8c31d3df'
spec = importlib.util.spec_from_file_location('abi_storage_proofs', ROOT / 'dev/storage-proof-test.py')
S = importlib.util.module_from_spec(spec)
spec.loader.exec_module(S)


def require(ok, message):
    if not ok:
        raise AssertionError('M2-ABI ' + message)


def capture(name, command, cwd=ROOT):
    argv = list(map(str, command))
    result = subprocess.run(argv, cwd=cwd, capture_output=True, text=True, timeout=180)
    (WORK / (name + '.json')).write_text(json.dumps(dict(
        command=argv, exit=result.returncode, stdout=result.stdout, stderr=result.stderr), indent=2) + '\n')
    return result


def good(name, command, cwd=ROOT):
    result = capture(name, command, cwd)
    require(result.returncode == 0 and not result.stderr, name + ' failed, see ' + str(WORK))
    return result.stdout


def repeated_keys(path):
    # jq keeps the last value of a repeated key, so a strict parse must see every object first.
    found = []

    def pairs(items):
        keys = [key for key, _ in items]
        found.extend(sorted({key for key in keys if keys.count(key) > 1}))
        return dict(items)

    json.loads(Path(path).read_text(encoding='utf-8'), object_pairs_hook=pairs)
    return found


def lenient(name, path):
    output = good(name, ['jq', '-S', '-c', '.', path])
    require(isinstance(json.loads(output), list), name + ' must contain one JSON array')
    return output


def canonical(name, path):
    # Every object must have unique keys. jq then sorts object keys and drops whitespace;
    # array ordering and every schema field remain binding.
    repeated = repeated_keys(path)
    require(not repeated, name + ' repeats object keys ' + ','.join(repeated))
    return lenient(name, path)


def emit(name, source):
    output = WORK / ('compiled-' + name)
    if output.exists():
        shutil.rmtree(output)
    good('check-' + name, [ROOT / 'assay', 'check', source])
    good('emit-' + name, [ROOT / 'assay', 'emit', source, '-o', output])
    return output / 'abi.json'


def reordered(value):
    if isinstance(value, dict):
        return {key: reordered(item) for key, item in reversed(list(value.items()))}
    if isinstance(value, list):
        return list(map(reordered, value))
    return value


def abi_gold():
    digest = hashlib.sha256(GOLDEN.read_bytes()).hexdigest()
    manifest = json.loads((GOLDEN.parent / 'MANIFEST.json').read_text())
    require(digest == GOLDEN_SHA256 and manifest['files']['abi.json'] == digest, 'golden provenance pin')
    expected = canonical('golden', GOLDEN)
    emitted = emit('erc20', ROOT / 'examples/ERC20.asy')
    require(canonical('emitted', emitted) == expected, 'ERC20 ABI differs from the pinned golden')
    rows = json.loads(expected)
    require(len(rows) == 12, 'golden inventory')
    path = WORK / 'reordered.json'
    path.write_text(json.dumps(reordered(rows), indent=3) + '\n')
    require(canonical('reordered', path) == expected, 'object order or whitespace changed equality')
    mutations = []

    def change(name, edit):
        value = deepcopy(rows)
        edit(value)
        mutations.append((name, value))

    change('missing-function', lambda xs: xs.pop(5))
    change('extra-function', lambda xs: xs.append(deepcopy(xs[5])))
    change('function-order', lambda xs: xs.reverse())
    change('function-name', lambda xs: xs[5].update(name='balances'))
    change('input-name', lambda xs: xs[5]['inputs'][0].update(name='account'))
    change('input-type', lambda xs: xs[5]['inputs'][0].update(type='uint256'))
    change('input-order', lambda xs: xs[9]['inputs'].reverse())
    change('output-type', lambda xs: xs[7]['outputs'][0].update(type='uint256'))
    change('output-name', lambda xs: xs[1]['outputs'][0].update(name='result'))
    change('mapping-mutability', lambda xs: xs[5].update(stateMutability='nonpayable'))
    change('write-mutability', lambda xs: xs[7].update(stateMutability='view'))
    change('constructor-value', lambda xs: xs[0].update(stateMutability='payable'))
    change('event-index', lambda xs: xs[10]['inputs'][0].update(indexed=False))
    change('event-anonymous', lambda xs: xs[11].update(anonymous=True))
    change('missing-event', lambda xs: xs.pop())
    for name, value in mutations:
        path = WORK / ('abi-' + name + '.json')
        path.write_text(json.dumps(value) + '\n')
        require(canonical(name, path) != expected, name + ' survived')
    # A conflicting stateMutability key ahead of the real one: jq keeps the last value and
    # matches the golden, so only the strict duplicate-key parse can reject it.
    require(rows[5]['name'] == 'balanceOf' and rows[5]['stateMutability'] == 'view',
            'duplicate-key control target')
    forged = '{"stateMutability": "nonpayable", ' + json.dumps(rows[5])[1:]
    path = WORK / 'abi-duplicate-key.json'
    path.write_text('[' + ', '.join(forged if index == 5 else json.dumps(row)
                                    for index, row in enumerate(rows)) + ']\n')
    require(lenient('duplicate-key-jq', path) == expected, 'duplicate-key control must fool jq alone')
    require(repeated_keys(path) == ['stateMutability'], 'duplicate-key survived')
    return len(rows), len(mutations) + 1


MUTABILITY_SOURCE = '''contract AbiMutability where
  storage State := { counter : Uint8 ; balances : Mapping Address Uint256 ;
    allowances : Mapping Address (Mapping Address Uint256) }
  EVENT
  entry lookup (owner : Address) : Eff Sig Uint256 := do
    value <- sload balances owner ; pure value
  entry nested (owner : Address) (spender : Address) : Eff Sig Uint256 := do
    value <- sload allowances owner spender ; pure value
  entry guarded (owner : Address) : Eff Sig Uint256 := do
    value <- sload balances owner ; guard le (word 0) value ;
    result <- add value (word 1) ; pure result
  entry scalarAfter (owner : Address) : Eff Sig Uint256 := do
    value <- sload balances owner ; sstore counter (word 1) ; pure value
  entry scalarBefore (owner : Address) : Eff Sig Uint256 := do
    sstore counter (word 1) ; value <- sload balances owner ; pure value
  entry mappingWrite (owner : Address) : Eff Sig Uint256 := do
    value <- sload balances owner ; sstore balances owner (word 1) ; pure value
  entry nestedWrite (owner : Address) (spender : Address) : Eff Sig Uint256 := do
    sstore allowances owner spender (word 1) ; pure (word 1)
  payable entry payableRead (owner : Address) : Eff Sig Uint256 := do
    value <- sload balances owner ; pure value
  payable entry payableWrite (owner : Address) : Eff Sig Uint256 := do
    sstore balances owner (word 1) ; pure (word 1)
  entry eventRead (owner : Address) : Eff Sig Uint256 := do
    value <- sload balances owner ; LOG pure value
  constructor := do sstore counter (word 0) ; pure ()
'''


def mutability():
    expected = dict(lookup='view', nested='view', guarded='view', scalarAfter='nonpayable',
                    scalarBefore='nonpayable', mappingWrite='nonpayable', nestedWrite='nonpayable',
                    payableRead='payable', payableWrite='payable', eventRead='view')
    for name, event, log in [('plain', '', ''),
                             ('events', 'event Seen (owner : Address indexed) (value : Uint256)',
                              'emit Seen (owner) (value) ;')]:
        source = WORK / (name + '.asy')
        source.write_text(MUTABILITY_SOURCE.replace('EVENT', event).replace('LOG', log))
        rows = json.loads(emit(name, source).read_text())
        actual = {row['name']: row['stateMutability'] for row in rows if row['type'] == 'function'}
        require(actual == (expected | dict(eventRead='nonpayable') if log else expected), name + ' mutability')
    return len(expected) * 2


def lean_negatives():
    source = ROOT / 'verification/test/AbiControls.lean'
    original = source.read_text()
    good('lean-control', ['lake', 'env', 'lean', source], S.PACKAGE)
    changes = [
        ('uint8-overflow', '⟨255,', '⟨256,'),
        ('uint256-overflow', '⟨modulus - 1,', '⟨modulus,'),
        ('address-overflow', '⟨2 ^ 160 - 1,', '⟨2 ^ 160,'),
        ('bool-overflow', '⟨1,', '⟨2,'),
        ('packed-overrun', '⟨.uint8, 31,', '⟨.uint8, 32,'),
        ('slot-closure', 'def slotCell : Cell := { slot := zero,',
         'def slotCell : Cell := { slot := fun x => x,'),
        ('value-closure', 'def valueCell : Cell := { slot := zero, value := zero }',
         'def valueCell : Cell := { slot := zero, value := fun x => x }'),
        ('forged-refinement', '(refine .uint8 256).val = .error (.outOfRange .uint8) := rfl',
         '∃ refined, (refine .uint8 256).val = .ok refined := ⟨_, rfl⟩'),
    ]
    for name, old, new in changes:
        require(original.count(old) == 1, name + ' mutation site')
        path = WORK / (name + '.lean')
        path.write_text(original.replace(old, new))
        result = capture(name, ['lake', 'env', 'lean', path], S.PACKAGE)
        line = original[:original.index(old)].count('\n') + 1
        require(result.returncode != 0 and not result.stderr and
                re.search(re.escape(str(path)) + rf':{line}:\d+: error(?:\([^)]*\))?:', result.stdout)
                and 'type mismatch' in result.stdout.lower(), name + ' lacked its type rejection')
    good('lean-restored-control', ['lake', 'env', 'lean', source], S.PACKAGE)
    return len(changes)


def main():
    require(shutil.which('jq') and shutil.which('lake'), 'jq and lake are required')
    WORK.mkdir(parents=True, exist_ok=True)
    entries, abi_controls = abi_gold()
    classified = mutability()
    S.WORK = WORK / 'storage'
    S.WORK.mkdir(exist_ok=True)
    axiom_controls = S.proofs()
    negatives = lean_negatives()
    storage_mutants, erased = S.mutants()
    summary = dict(entries=entries, abi_controls=abi_controls, mutability=classified,
                   lean_negatives=negatives, storage_mutants=storage_mutants,
                   axiom_controls=axiom_controls, erasure=erased, golden_sha256=GOLDEN_SHA256)
    (WORK / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    print('M2-ABI ' + ' '.join(f'{key}={value}' for key, value in summary.items() if key != 'golden_sha256')
          + ' jq_sorted=equal OK')


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""Check typed metadata against frozen ABI, selector and event-topic oracles."""
from pathlib import Path
import json
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/abi-schema'
TARGET = 'test/abi_schema.exe'


def require(ok, label):
    if not ok:
        raise ValueError(label)


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    require(result.returncode == 0 and not result.stderr,
            'TOOL ' + ' '.join(command) + '\n' + result.stdout + result.stderr)
    return result.stdout


def argument(name, typ):
    return dict(name=name, type=typ)


def inspect(root):
    text = run(root, str(root / '_build/default' / TARGET))
    actual = json.loads(text)
    golden = ROOT / 'reference/erc20/abi.json'
    # jq checks the exact canonicalization used by M2-ABI, including array order.
    emitted = root / '.gatework/abi-schema/emitted.json'
    emitted.parent.mkdir(parents=True, exist_ok=True)
    emitted.write_text(json.dumps(actual['erc20']) + '\n')
    require(run(root, 'jq', '-S', '-c', '.', str(emitted)) ==
            run(root, 'jq', '-S', '-c', '.', str(golden)), 'ERC20-JSON')
    manifest = json.loads((ROOT / 'reference/erc20/MANIFEST.json').read_text())
    require(actual['selectors'] == manifest['selectors'], 'SELECTORS')
    require(actual['topics'] == manifest['topics'], 'TOPICS')
    ctor = dict(type='constructor', inputs=[], stateMutability='nonpayable')
    legacy = [ctor]
    escaped = 'line\n"\\\x01'
    for name, inputs, mutability in [('read', [], 'view'),
                                     ('write', ['amount', 'to'], 'nonpayable'),
                                     ('pay', [escaped], 'payable')]:
        legacy.append(dict(type='function', name=name,
                           inputs=[argument(p, 'uint256') for p in inputs],
                           outputs=[argument('', 'uint256')], stateMutability=mutability))
    legacy.extend([dict(type='error', name='Stopped', inputs=[]),
                   dict(type='error', name='Bounds', inputs=[argument('actual', 'uint256'),
                                                           argument('limit', 'uint256')]),
                   dict(type='fallback', stateMutability='nonpayable')])
    # The historical printer escapes every control byte as a Unicode escape.
    compact = lambda value: json.dumps(value, ensure_ascii=False, separators=(',', ':')).replace('\\n', '\\u000a') + '\n'
    require(actual['legacy'] == compact(legacy), 'LEGACY-BYTES')
    require(actual['legacy_empty'] == compact([ctor]), 'LEGACY-EMPTY')
    require(actual['legacy_signatures'] == dict(read='read()', write='write(uint256,uint256)',
                                              pay='pay(uint256)'), 'LEGACY-SIGNATURES')
    require(actual['error_signatures'] == dict(Stopped='Stopped()', Bounds='Bounds(uint256,uint256)'),
            'ERROR-SIGNATURES')
    edge = [dict(type='constructor', inputs=[argument('owner', 'address')], stateMutability='payable'),
            dict(type='function', name='write', inputs=[argument(n, t) for n, t in
                 zip(['a', 'b', 'c', 'd', escaped], ['uint8', 'uint256', 'address', 'bool', 'string'])],
                 outputs=[], stateMutability='payable'),
            dict(type='function', name='pair', inputs=[],
                 outputs=[argument('owner', 'address'), argument('count', 'uint8')], stateMutability='view'),
            dict(type='error', name='Rejected', inputs=[argument('reason', 'bool'), argument('caller', 'address')]),
            dict(type='event', name='Anonymous', anonymous=True,
                 inputs=[dict(argument('text', 'string'), indexed=False),
                         dict(argument('key', 'uint256'), indexed=True)]),
            dict(type='fallback', stateMutability='payable'),
            dict(type='fallback', stateMutability='nonpayable')]
    require(actual['edge'] == edge, 'EDGE-JSON')
    require(actual['empty'] == '[]\n', 'EMPTY')
    require(actual['invariant'] == actual['changed'] == 'same(address,uint256)', 'SIGNATURE-INVARIANCE')
    return text


MUTANTS = [
    ('UINT8', 'Uint8 -> "uint8"', 'Uint8 -> "uint256"', 'ERC20-JSON'),
    ('ADDRESS', 'Address -> "address"', 'Address -> "uint256"', 'ERC20-JSON'),
    ('BOOL', 'Bool -> "bool"', 'Bool -> "uint256"', 'ERC20-JSON'),
    ('STRING', 'String -> "string"', 'String -> "bytes"', 'ERC20-JSON'),
    ('INDEXED', 'string_of_bool p.indexed', 'string_of_bool (not p.indexed)', 'ERC20-JSON'),
    ('OUTPUTS', 'parameters fn.outputs', 'parameters []', 'ERC20-JSON'),
    ('SIGNATURE', 'signature fn.name fn.inputs', 'signature fn.name (fn.inputs @ fn.outputs)', 'SELECTORS'),
    ('ANONYMOUS', 'string_of_bool anonymous', 'string_of_bool (not anonymous)', 'ERC20-JSON'),
]


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    run(ROOT, 'dune', 'build', TARGET)
    (WORK / 'control.json').write_text(inspect(ROOT))
    source = (ROOT / 'abi/abi.ml').read_text()
    killed = 0
    for name, old, new, witness in MUTANTS:
        require(source.count(old) == 1, 'MUTANT-PATTERN ' + name)
        with tempfile.TemporaryDirectory(prefix='assay-abi-') as temporary:
            work = Path(temporary)
            for relative in ('dune', 'dune-project', 'abi/dune', 'abi/abi.ml', 'abi/layout.ml',
                             'keccak/dune', 'keccak/keccak.ml', 'test/abi_schema.ml'):
                target = work / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(ROOT / relative, target)
            (work / 'test/dune').write_text('(executable (name abi_schema) (modules abi_schema) (libraries assay_abi assay_keccak))\n')
            (work / 'abi/abi.ml').write_text(source.replace(old, new))
            # A compile error never counts as killing a semantic mutant.
            run(work, 'dune', 'build', TARGET)
            try:
                inspect(work)
            except ValueError as error:
                require(str(error) == witness, 'MUTANT-WITNESS ' + name + ': ' + str(error))
            else:
                raise ValueError('MUTANT-SURVIVED ' + name)
            (WORK / (name + '.log')).write_text('killed witness=' + witness + '\n')
            print('ABI-SCHEMA-MUTANT ' + name + ' killed witness=' + witness, flush=True)
            killed += 1
    control = json.loads((WORK / 'control.json').read_text())
    print('ABI-SCHEMA functions=%d events=%d edges=%d legacy=%d mutants=%d scope=metadata OK'
          % (len(control['selectors']), len(control['topics']), len(control['edge']),
             sum(1 for d in json.loads(control['legacy']) if d['type'] != 'constructor'), killed))


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError, subprocess.TimeoutExpired) as error:
        print('ABI-SCHEMA FAIL ' + str(error))
        raise SystemExit(1)

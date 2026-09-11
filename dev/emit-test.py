#!/usr/bin/env python3
"""Stage E source emission, independent execution, JSON and mutation gates."""
from pathlib import Path
import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import tempfile


def module(root, filename):
    spec = importlib.util.spec_from_file_location(filename.replace('-', '_'), root / 'dev' / filename)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def require(ok, message):
    if not ok:
        raise ValueError(message)


def run(root, *argv, timeout=120):
    return subprocess.run(argv, cwd=root, capture_output=True, text=True, timeout=timeout)


def checked(root, *argv, timeout=120):
    result = run(root, *argv, timeout=timeout)
    require(result.returncode == 0 and not result.stderr,
            f'TOOL {argv} exit={result.returncode}: {result.stdout}{result.stderr}')
    return result.stdout


def emit(root, source, directory, *extra):
    checked(root, str(root / '_build/default/bin/assay.exe'), 'emit', str(source), '-o', str(directory), *extra)
    names = {'runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt'}
    require({path.name for path in directory.iterdir()} == names, 'EMIT-FILES')
    files = {name: (directory / name).read_text() for name in names}
    for name in ('runtime.hex', 'init.hex'):
        require(re.fullmatch(r'(?:[0-9a-f]{2})+\n', files[name]) is not None, 'EMIT-HEX ' + name)
    return files


def trace(root):
    ref = module(root, 'reference-test.py')
    with tempfile.TemporaryDirectory(prefix='assay-emitted-') as temporary:
        files = emit(root, root / 'examples/Ref20.asy', Path(temporary) / 'out')
        runtime, init = files['runtime.hex'].strip(), files['init.hex'].strip()
        golden, declared = ref.reference(root)
        prefix, prefix_rows = ref.source(root, 'ref20-init.evm')
        require(runtime == golden, 'EMITTED-RUNTIME differs from committed reference')
        require(init == prefix + golden, 'EMITTED-INIT differs from committed reference')
        cast = ref.listing(ref.run(root, 'emitted-cast', 'cast', 'disassemble', '0x' + runtime))
        steps, summary, skipped, storage, output = ref.verify_trace(
            runtime, declared, ref.execute(root, 'emitted-run', runtime), cast)
        creation, installed = ref.verify_create(runtime, prefix, prefix_rows,
            ref.execute(root, 'emitted-create', init, create=True))
        print(f'M0-TRACE scope=emitted bytes={len(runtime)//2} listing={len(declared)} cast={len(cast)} '
              f'evm={len(steps)} skipped={len(skipped)} storage={int(storage,16)} return={int(output,16)} OK')
        print(f'CREATE-EQ scope=emitted bytes={len(runtime)//2} returned={len(creation["output"])//2} '
              f'installed={len(installed)} OK')
        print(f'EMIT-MEASURE runtime_bytes={len(runtime)//2} init_bytes={len(init)//2} gas={int(summary["gasUsed"],16)}')


def canonical(root, value):
    result = subprocess.run(['jq', '-S', '-c', '.'], cwd=root, input=json.dumps(value),
                            capture_output=True, text=True, timeout=10)
    require(result.returncode == 0 and not result.stderr, 'ABI-JQ')
    return result.stdout


def abi(root):
    provenance = (root / 'dev/ABI-PROVENANCE.md').read_text()
    require(all(name in provenance for name in ('reference/abi.json', 'reference/layout.json', 'R-Q5a')),
            'ABI-PROVENANCE')
    with tempfile.TemporaryDirectory(prefix='assay-abi-') as temporary:
        files = emit(root, root / 'examples/Ref20.asy', Path(temporary) / 'out')
        golden = json.loads((root / 'reference/abi.json').read_text())
        actual = json.loads(files['abi.json'])
        require(canonical(root, actual) == canonical(root, golden), 'ABI-GOLD mismatch')
        layout = json.loads(files['layout.json'])
        require(canonical(root, layout) == canonical(root, json.loads((root / 'reference/layout.json').read_text())),
                'LAYOUT-GOLD mismatch')
        disclosure = checked(root, str(root / '_build/default/bin/assay.exe'), 'axioms', 'examples/Ref20.asy')
        require(files['axioms.txt'] == disclosure == 'EvmOpcodes\n', 'AXIOM-DISCLOSURE')
        # M0 has an empty ABI.  The nonempty synthetic row tests the comparator,
        # without claiming that M0 emits a function dispatcher.
        # Review round 2026-09-10 (A-1):  the controls are collected and counted
        # here, so deleting one moves the printed number and fails the pinned
        # marker.  The count was literal text before.
        row = {'type': 'function', 'name': 'sample', 'inputs': [], 'outputs': [], 'stateMutability': 'pure'}
        reordered = dict(reversed(list(row.items())))
        escaped = json.loads(checked(root, str(root / '_build/default/test/emit_cases.exe'), 'layout'))
        controls = [
            ('ABI-ORDER control', canonical(root, [row]) == canonical(root, [reordered])),
            ('ABI-RENAME survived', canonical(root, [row]) != canonical(root, [{**row, 'name': 'renamed'}])),
            ('JSON-ESCAPE', escaped['storage'][0]['contract'] == 'Q"\\\n' and escaped['storage'][0]['label'] == 'a\t'),
            ('LAYOUT-ORDER', escaped['storage'][1]['slot'] == '1'),
        ]
        for label, ok in controls:
            require(ok, label)
    print(f'ABI-GOLD jq_sorted=equal provenance=dev/ABI-PROVENANCE.md controls={len(controls)} OK')


def source_cases(root):
    ref = module(root, 'reference-test.py')
    original = (root / 'examples/Ref20.asy').read_text()
    prelude = original.split('def Storage')[0]
    storage = 'def Storage : Type 0 := prod (Word 256)\ndef storage : Storage := tuple (word 256 0)\n'
    def source(main, extra='', schema=storage):
        return prelude + schema + extra + '\ndef main : Eff := ' + main + '\n'
    boolean = ('def Bool : Type 0 := sum ((prod () : Type 0), (prod () : Type 0))\n'
               'def pick : (b : Bool) -> Nat := fun (b : Bool) => case b with '
               '| 0 (x : prod ()) => 8 | 1 (y : prod ()) => 9\n')
    maximum = 2**256 - 1
    cases = [
        ('reference', original, 42, {0:42}),
        ('different', source('put storage.0 (word 256 7) (read storage.0)'), 7, {0:7}),
        ('zero', source('put storage.0 (word 256 0) (read storage.0)'), 0, {}),
        ('maximum', source(f'put storage.0 (word 256 {maximum}) (read storage.0)'), maximum, {0:maximum}),
        ('return', source('ret (word 256 37)'), 37, {}),
        ('let', source('let x : Word 256 := word 256 19 in ret x'), 19, {}),
        ('first-order', source('ret (twice 21)', 'def twice : Nat -> Word 256 := fun (n : Nat) => word 256 (natMul n 2)\n'), 42, {}),
        ('pair', source('ret (word 256 pair.2)', 'def pair : Nat * Nat := (3, 4)\n'), 4, {}),
        ('equal', source('ret (word 256 (pick (natEq 4 4)))', boolean), 9, {}),
        ('not-equal', source('ret (word 256 (pick (natEq 4 5)))', boolean), 8, {}),
        ('less', source('ret (word 256 (pick (natLt 4 5)))', boolean), 9, {}),
        ('not-less', source('ret (word 256 (pick (natLt 5 4)))', boolean), 8, {}),
        ('two-slots', source('put storage.0 (word 256 11) (put storage.1 (word 256 22) (read storage.1))',
            schema='def Storage : Type 0 := prod (Word 256, Word 256)\ndef storage : Storage := tuple (word 256 0, word 256 1)\n'), 22, {0:11, 1:22}),
        ('wide-label', source('put storage.0 (word 256 1) (' * 30 + 'read storage.0' + ')' * 30), 1, {0:1}),
        ('quantity-zero', source('ret (withProof witness (word 256 42))',
            'axiom witness : EvmOpcodes\ndef withProof : (0 p : EvmOpcodes) -> Word 256 -> Word 256 := fun (0 p : EvmOpcodes) (x : Word 256) => x\n'), 42, {}),
    ]
    refusals = [
        ('overflow', source(f'ret (word 256 {2**256})'), 'WORD_UNBOX_RANGE'),
        ('bad-slot', source('read (word 256 1)'), 'STORAGE_SLOT'),
        ('slot-gap', original.replace('tuple (word 256 0)', 'tuple (word 256 1)'), 'STORAGE_SLOT'),
        ('storage-width', source('ret (word 256 0)', schema=storage.replace('Word 256', 'Word 128').replace('word 256', 'word 128')), 'STORAGE_SHAPE'),
        ('storage-closure', source('ret (word 256 0)', schema='def Storage : Type 0 := prod (Nat -> Nat)\ndef storage : Storage := tuple (fun (n : Nat) => n)\n'), 'STORAGE_NOCLOS'),
        ('higher-order', source('ret (word 256 (apply (fun (n : Nat) => n) 3))', 'def apply : (Nat -> Nat) -> Nat -> Nat := fun (f : Nat -> Nat) (n : Nat) => f n\n'), 'EMIT_HIGHER_ORDER'),
        ('postulate', source('ret unknown', 'axiom unknown : Word 256\n'), 'EMIT_POSTULATE'),
        ('protocol', original.replace('axiom EvmOpcodes : Prop', 'axiom EvmOpcodes : Type 0'), 'M0_PROTOCOL'),
        ('runtime-nat', prelude + storage + 'def main : Nat := 42\n', 'NAT_REFUSE'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-source-cases-') as temporary:
        work = Path(temporary)
        for name, text, answer, expected_storage in cases:
            path = work / (name + '.asy')
            path.write_text(text)
            files = emit(root, path, work / name)
            runtime = files['runtime.hex'].strip()
            _steps, summary, state = ref.success(ref.execute(root, 'emitted-' + name, runtime), 'EMIT-EXEC')
            require(summary['output'] == f'{answer:064x}', 'EMIT-ANSWER ' + name)
            account = {key.lower(): value for key, value in state['accounts'].items()}[ref.RECEIVER]
            actual = {int(key,16): int(value,16) for key, value in account.get('storage', {}).items()}
            require(actual == expected_storage, 'EMIT-STORAGE ' + name)
            _steps, creation, state = ref.success(ref.execute(root, 'emitted-create-' + name,
                files['init.hex'].strip(), create=True), 'EMIT-CREATE')
            require(creation['output'] == runtime, 'EMIT-CREATE ' + name)
            installed = [account for address, account in state['accounts'].items() if address.lower() != ref.SENDER]
            require(len(installed) == 1 and installed[0]['code'] == '0x' + runtime, 'EMIT-INSTALLED ' + name)
            print('EMIT-SOURCE ' + name + ' OK')
        for name, text, marker in refusals:
            path = work / (name + '.asy')
            path.write_text(text)
            checked(root, str(root / '_build/default/bin/assay.exe'), 'check', str(path))
            directory = work / name
            result = run(root, str(root / '_build/default/bin/assay.exe'), 'emit', str(path), '-o', str(directory))
            require(result.returncode == 2 and marker in result.stderr and not directory.exists(), 'EMIT-REFUSE ' + name + ': ' + result.stderr)
            print('EMIT-REFUSE ' + name + ' OK')
        # Review round 2026-09-10 (A-1):  the driver checks are collected and
        # counted, so deleting one moves the printed number.
        path = root / 'examples/Ref20.asy'
        alias = emit(root, path, work / 'alias', '--export', 'main')
        driver = [('EXPORT-ALIAS', alias['runtime.hex'] == (work / 'reference/runtime.hex').read_text())]
        directory = work / 'alias'
        before = {p.name: p.read_bytes() for p in directory.iterdir()}
        result = run(root, str(root / '_build/default/bin/assay.exe'), 'emit', str(path), '-o', str(directory))
        driver.append(('OUTPUT-EXISTS', result.returncode == 64 and 'OUTPUT_PATH' in result.stderr and
                       before == {p.name: p.read_bytes() for p in directory.iterdir()}))
        result = run(root, str(root / '_build/default/bin/assay.exe'), 'emit', str(path), '-o', str(work / 'missing'), '--export', 'gone')
        driver.append(('EXPORT-MISSING', result.returncode == 2 and 'EMIT_MISSING' in result.stderr
                       and not (work / 'missing').exists()))
        for label, ok in driver:
            require(ok, label)
    print(f'EMIT-SOURCES success={len(cases)} refusal={len(refusals)} driver={len(driver)} OK')


def mutants(root):
    cases = [
        ('WORD-BOX', 'emit/recognize.ml', 'else Ok (Word n)', 'else Ok (Struct (word_tid, [Nat n]))',
         'words', 'word-zero'),
        ('WORD-RANGE', 'emit/recognize.ml', 'Z.numbits n > 256', 'Z.numbits n > 257', 'words', 'word-overflow'),
        ('STORAGE-CLOSURE', 'emit/recognize.ml', '| Eterm.KClos _ | Eterm.KTail _ -> Error Storage_closure',
         '| Eterm.KClos _ | Eterm.KTail _ -> Ok ()', 'storage', 'storage-closure'),
        ('STORAGE-ALIAS', 'emit/recognize.ml', '~some:(fun body -> no_closure lookup (name :: seen) body)',
         '~some:(fun _body -> Ok ())', 'storage', 'storage-hidden'),
        ('GLOBAL-APP', 'emit/emit.ml', 'else eval env (List.rev args) fuel fn.body',
         'else eval env (List.rev args) fuel (Eterm.KLit (Literal.LInt Z.zero))', 'constructors', 'app'),
        ('ABI-ENTRY', 'abi/abi.ml', 'let empty = "[]\\n"',
         'let empty = "[{}]\\n"', 'abi', 'ABI-GOLD mismatch'),
        ('LAYOUT-SLOT', 'abi/layout.ml', '(string_of_int index))) fields',
         '(string_of_int (index + 1)))) fields', 'abi', 'LAYOUT-GOLD mismatch'),
    ]
    with tempfile.TemporaryDirectory(prefix='assay-emit-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        shutil.copytree(root, copy, ignore=shutil.ignore_patterns('.git', '_build', '.gatework', '.kanon-exec', '.kanon-wait', '.lake', 'vendor', 'validation'))
        logs = root / '.gatework'
        logs.mkdir(exist_ok=True)
        for name, relative, before, after, mode, marker in cases:
            path = copy / relative
            original = path.read_text()
            require(original.count(before) == 1, 'MUTANT-ANCHOR ' + name)
            path.write_text(original.replace(before, after))
            build = run(copy, 'zsh', '-f', 'dev/dunecho.sh', 'build')
            require(build.returncode == 0 and '0 errors, 0 warnings' in build.stdout, 'MUTANT-BUILD ' + name + build.stdout + build.stderr)
            result = (run(copy, 'python3', '-P', 'dev/emit-test.py', mode) if mode == 'abi'
                      else run(copy, str(copy / '_build/default/test/emit_cases.exe'), mode))
            (logs / ('emit-mutant-' + name + '.log')).write_text(build.stdout + result.stdout + result.stderr)
            witness = ('EMIT-GATE FAIL ' if mode == 'abi' else 'EMIT-CASES FAIL ') + marker
            require(result.returncode == 1 and witness in result.stdout + result.stderr, 'MUTANT-SURVIVED ' + name)
            path.write_text(original)
            print('EMIT-MUTANT ' + name + ' killed by ' + marker)
        build = run(copy, 'zsh', '-f', 'dev/dunecho.sh', 'build')
        require(build.returncode == 0, 'EMIT-CONTROL-BUILD')
        # Review round 2026-09-10 (A-1):  the restored controls are counted, so
        # removing one moves the printed number.
        controls = []
        for mode in ('words', 'storage', 'constructors'):
            output = checked(copy, str(copy / '_build/default/test/emit_cases.exe'), mode)
            (logs / ('emit-control-' + mode + '.log')).write_text(output)
            controls.append(mode)
        output = checked(copy, 'python3', '-P', 'dev/emit-test.py', 'abi')
        (logs / 'emit-control-abi.log').write_text(output)
        controls.append('abi')
    print(f'EMIT-MUTANTS killed={len(cases)}/{len(cases)} controls={len(controls)} OK')


def main():
    root = Path(__file__).resolve().parent.parent
    modes = {'trace': trace, 'sources': source_cases, 'abi': abi, 'mutants': mutants}
    if len(sys.argv) != 2 or sys.argv[1] not in modes:
        print('usage: emit-test.py trace|sources|abi|mutants')
        return 64
    modes[sys.argv[1]](root)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.TimeoutExpired) as error:
        print('EMIT-GATE FAIL ' + str(error))
        sys.exit(1)

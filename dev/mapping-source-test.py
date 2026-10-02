#!/usr/bin/env python3
"""Check source mapping schemas and physical layout against explicit goldens."""
from functools import reduce
from pathlib import Path
import hashlib
import importlib.util
import json
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'dev'))
from cli_delta import cli_sources, source_records
from native_mutations import copy_project

BINARY = ROOT / '_build/bin/assay'


def scalar(name, typ, slot, offset, width):
    return dict(name=name, slot=str(slot), offset=offset, bytes=width, type=typ)


def mapping(key, value):
    return dict(mapping=dict(key=key, value=value))


def mapped(name, typ, slot):
    return dict(name=name, slot=str(slot), offset=0, bytes=32, type=typ)


def schema(fields):
    return 'contract Schema where storage State := { ' + fields + ' }'


def success_cases():
    return [
        ('empty', schema(''), []),
        ('scalar', schema('a : Uint8 ; b : Bool ; c : Address ; d : Uint256 ; e : Word'), [
            scalar('a', 'uint8', 0, 0, 1), scalar('b', 'bool', 0, 1, 1),
            scalar('c', 'address', 0, 2, 20), scalar('d', 'uint256', 1, 0, 32),
            scalar('e', 'uint256', 2, 0, 32)]),
        ('erc20', schema('balances : Mapping Address Uint256 ; allowances : Mapping Address (Mapping Address Uint256) ; total : Uint256'), [
            mapped('balances', mapping('address', 'uint256'), 0),
            mapped('allowances', mapping('address', mapping('address', 'uint256')), 1),
            scalar('total', 'uint256', 2, 0, 32)]),
        ('partial-before-mapping', schema('a : Uint8 ; m : Mapping Bool Uint8 ; b : Uint8'), [
            scalar('a', 'uint8', 0, 0, 1), mapped('m', mapping('bool', 'uint8'), 1),
            scalar('b', 'uint8', 2, 0, 1)]),
        ('spill-before-mapping', schema('a : Address ; b : Address ; m : Mapping Uint8 Bool ; c : Bool'), [
            scalar('a', 'address', 0, 0, 20), scalar('b', 'address', 1, 0, 20),
            mapped('m', mapping('uint8', 'bool'), 2), scalar('c', 'bool', 3, 0, 1)]),
        ('consecutive-mappings', schema('a : Mapping Uint256 Address ; b : Mapping Word Word ;'), [
            mapped('a', mapping('uint256', 'address'), 0),
            mapped('b', mapping('uint256', 'uint256'), 1)]),
        ('nested-prefix', schema('m : Mapping Bool Mapping Uint8 Mapping Address Bool'), [
            mapped('m', mapping('bool', mapping('uint8', mapping('address', 'bool'))), 0)]),
        ('grouped-scalar', schema('m : (Mapping Address (Uint8))'), [
            mapped('m', mapping('address', 'uint8'), 0)]),
        ('max-depth', schema('x : ' + '(' * 63 + 'Bool' + ')' * 63), [
            scalar('x', 'bool', 0, 0, 1)]),
        ('body-is-separate', schema('m : Mapping Address Uint256') + ' entry zero () : Eff Sig Word := do pure 0', [
            mapped('m', mapping('address', 'uint256'), 0)]),
        ('payable-entry', schema('x : Bool') + ' payable entry pay () : Eff Sig Word := do pure 0', [
            scalar('x', 'bool', 0, 0, 1)]),
        ('max-mapping-depth', schema('m : ' + 'Mapping Bool ' * 63 + 'Bool'), [
            mapped('m', reduce(lambda value, _: mapping('bool', value), range(63), 'bool'), 0)]),
        ('max-source', schema('x : Bool').ljust(65536), [
            scalar('x', 'bool', 0, 0, 1)]),
    ]


def refusal_cases():
    fields = [
        ('missing-type', 'x :', 'MAPPING_SOURCE_TYPE'),
        ('unsupported', 'x : String', 'MAPPING_SOURCE_TYPE'),
        ('unsupported-key', 'x : Mapping String Uint256', 'MAPPING_SOURCE_TYPE'),
        ('mapping-key', 'x : Mapping Mapping Address Uint256 Uint8', 'MAPPING_SOURCE_TYPE'),
        ('missing-value', 'x : Mapping Address', 'MAPPING_SOURCE_TYPE'),
        ('missing-key', 'x : Mapping', 'MAPPING_SOURCE_TYPE'),
        ('lowercase', 'x : mapping Address Uint256', 'MAPPING_SOURCE_TYPE'),
        ('unsupported-leaf', 'x : Mapping Address Uint16', 'MAPPING_SOURCE_TYPE'),
        ('missing-group-end', 'x : Mapping Address (Mapping Bool Uint8', 'SYNTAX'),
        ('extra-group-end', 'x : Uint8 )', 'MAPPING_SOURCE_STORAGE'),
        ('extra-type', 'x : Mapping Address Uint8 Uint256', 'MAPPING_SOURCE_STORAGE'),
        ('missing-semicolon', 'x : Bool y : Uint8', 'MAPPING_SOURCE_STORAGE'),
        ('double-semicolon', 'x : Bool ;;', 'SURFACE_NAME'),
        ('duplicate', 'x : Mapping Address Uint256 ; x : Bool', 'invalid storage layout'),
        ('too-deep', 'x : ' + '(' * 64 + 'Bool' + ')' * 64, 'MAPPING_SOURCE_DEPTH'),
        ('too-deep-mapping', 'm : ' + 'Mapping Bool ' * 64 + 'Bool', 'MAPPING_SOURCE_DEPTH'),
        ('too-deep-group', 'm : ' + 'Mapping Bool (' * 32 + 'Bool' + ')' * 32, 'MAPPING_SOURCE_DEPTH'),
    ]
    rows = [(name, schema(body), marker) for name, body, marker in fields]
    rows.extend([
        ('empty-source', '', 'SYNTAX'),
        ('missing-header', 'storage State := {}', 'SYNTAX'),
        ('missing-where', 'contract Schema storage State := {}', 'SYNTAX'),
        ('missing-storage', 'contract Schema where entry f', 'SYNTAX'),
        ('unclosed-storage', 'contract Schema where storage State := { x : Bool', 'MAPPING_SOURCE_STORAGE'),
        ('missing-name', 'contract Schema where storage := {}', 'SURFACE_NAME'),
        ('second-storage', schema('x : Bool') + ' storage Other := { y : Bool }', 'MAPPING_SOURCE_STORAGE'),
        ('trailing-junk', schema('x : Bool ;') + ' ))) junk', 'MAPPING_SOURCE_STORAGE'),
        ('source-limit', schema('x : Bool').ljust(65537), 'SURFACE_LIMIT'),
    ])
    return rows


def call(binary, path, command='mapping-layout'):
    args = [str(binary)] + ([command] if command else []) + [str(path)]
    return subprocess.run(args, cwd=ROOT,
                          text=True, capture_output=True, timeout=30)


def cases(binary, directory, command='mapping-layout'):
    passed = []
    for name, source, fields in success_cases():
        path = directory / (name + '.asy')
        path.write_text(source)
        result = call(binary, path, command)
        expected = dict(contract='Schema', storage=fields)
        if result.returncode or result.stderr or json.loads(result.stdout) != expected:
            raise ValueError(f'MAPPING-SOURCE golden {name}: {result.returncode}: {result.stdout!r} {result.stderr!r}')
        passed.append(dict(name=name, expected=expected))
    for name, source, marker in refusal_cases():
        path = directory / (name + '.asy')
        path.write_text(source)
        result = call(binary, path, command)
        if result.returncode != 1 or result.stdout or marker not in result.stderr:
            raise ValueError(f'MAPPING-SOURCE refusal {name}: {result.returncode}: {result.stdout!r} {result.stderr!r}')
    return passed


def mutants(directory):
    source = (ROOT / 'src/frontend.bend').read_text()
    # Each mutant must fail its named witness golden. Every golden before the
    # witness must pass on the mutant build, which shows the harness works.
    patches = [
        ('mapping-width', 'case Mapping.Source.Type.Mapping{_, _}: Abi.Schema.Value_type.Uint256{}',
         'case Mapping.Source.Type.Mapping{_, _}: Abi.Schema.Value_type.Uint8{}', 'erc20'),
        ('mapping-key', 'Done{Tup2{Mapping.Source.Type.Mapping{key, value}, tail}}',
         'Done{Tup2{Mapping.Source.Type.Mapping{Abi.Schema.Value_type.Bool{}, value}, tail}}', 'erc20'),
    ]
    killed = []
    for name, before, after, witness in patches:
        if source.count(before) != 1:
            raise ValueError('MAPPING-SOURCE mutation anchor: ' + name)
        root = copy_project(ROOT, directory / name)
        (root / 'src/frontend.bend').write_text(source.replace(before, after))
        driver = root / 'dev/mapping-source-mutant-build.py'
        driver.write_text('from pathlib import Path\nimport sys\nsys.path.insert(0, str(Path(__file__).resolve().parent))\nimport build\nbuild.ENTRIES["mapping_source"] = "Cli.MappingSource.run(args)"\nnode = build.runtime()\nbuild.build("test_mapping_source", build.compiler(), node)\nbuild.executable(build.ROOT / "_build/bin/assay", build.wrapper(node, "test_mapping_source"))\n')
        result = subprocess.run([sys.executable, '-P', str(driver)],
                                cwd=root, text=True, capture_output=True, timeout=600)
        if result.returncode:
            raise ValueError('MAPPING-SOURCE mutant must compile: ' + name + result.stderr)
        work = directory / ('cases-' + name)
        work.mkdir()
        try:
            cases(root / '_build/bin/assay', work, command=None)
        except ValueError as error:
            assertion = str(error).split(':', 1)[0]
            if assertion != 'MAPPING-SOURCE golden ' + witness:
                raise ValueError('MAPPING-SOURCE mutant ' + name + ' failed ' + assertion + ' not ' + witness) from error
            killed.append(dict(name=name, assertion=assertion))
        else:
            raise ValueError('MAPPING-SOURCE mutant survived: ' + name)
    return killed


def schedules():
    spec = importlib.util.spec_from_file_location('mapping_source_schedules', ROOT / 'dev/revert-compatibility.py')
    helper = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(helper)
    module = helper.load((ROOT / 'dev/stage-a-gates.py').read_text())
    carried = helper.schedule(module, '--m2-source-packing')
    current = helper.schedule(module, '--m2-mapping-source')
    expected = carried['legs'] + [
        ('MAPPING-SOURCE', 600, ('python3', '-P', 'dev/mapping-source-test.py'),
         'MAPPING-SOURCE cases=39 goldens=13 refusals=26 mutants=2 OK', True),
    ]
    if len(carried['legs']) != 99 or current != dict(stage='M2-MAPPING-SOURCE', legs=expected):
        raise ValueError('MAPPING-SOURCE changed a carried gate or the new gate deadline')


def main():
    if len(sys.argv) != 1:
        raise ValueError('usage: mapping-source-test.py')
    before, after = cli_sources(source_records(ROOT, 'af364d5'))
    if before != after:
        raise ValueError('MAPPING-SOURCE historical CLI changed')
    schedules()
    with tempfile.TemporaryDirectory(prefix='assay-mapping-source-') as temporary:
        directory = Path(temporary)
        controls = directory / 'controls'
        controls.mkdir()
        goldens = cases(BINARY, controls)
        killed = mutants(directory)
        cases(BINARY, controls)
        bad = [[], ['a', 'b'], [str(directory / 'missing.asy')], [str(directory)]]
        for args in bad:
            result = subprocess.run([str(BINARY), 'mapping-layout', *args], cwd=ROOT,
                                    text=True, capture_output=True, timeout=30)
            if result.returncode != 64 or result.stdout:
                raise ValueError('MAPPING-SOURCE usage or file refusal')
    report = dict(version=1, positive=len(goldens), refused=len(refusal_cases()),
                  mutants=killed, cases=goldens, compatibility='OK',
                  sources={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                           for p in [ROOT / 'src/frontend.bend', ROOT / 'src/cli.bend',
                                     ROOT / 'src/layout.bend', Path(__file__)]})
    work = ROOT / '.gatework/mapping-source'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(f'MAPPING-SOURCE cases={len(goldens) + len(refusal_cases())} goldens={len(goldens)} refusals={len(refusal_cases())} mutants={len(killed)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('MAPPING-SOURCE FAIL: ' + str(error), file=sys.stderr)
        raise SystemExit(1)

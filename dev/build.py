#!/usr/bin/env python3
"""Build the native Bend sources with the pinned compiler."""
from pathlib import Path
import hashlib
import json
import os
import shlex
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'dev'))
from bend_source import bundle, declarations, reachable

PIN = json.loads((ROOT / 'dev/toolchain.json').read_text())
OUT = ROOT / '_build/bend'
ADAPTERS = ('sl_surface', 'abi_codec', 'abi_schema', 'layout_packed', 'keccak_vec', 'asm_cases', 'asm_compact', 'emit_cases', 'contract_route', 'one_paths', 'export_mu', 'roundtrip')
BACKENDS = ('abi_codec', 'abi_schema', 'layout_packed', 'keccak_vec', 'asm_cases', 'asm_compact')
ENTRIES = {
    'sl_surface': 'Tests.surface(Sl_surface.cases(), 0n)',
    'abi_codec': 'Tests.adapter(Abi_codec.main("abi_codec" <> args))',
    'abi_schema': 'NativeIO.print(Abi_schema.output())',
    'layout_packed': 'Tests.adapter(Packed_layout.main(args))',
    'keccak_vec': 'Tests.keccak(Keccak_vec.dispatch("keccak_vec" <> args))',
    'asm_cases': 'Tests.asm_cases(args)',
    'asm_compact': 'Tests.compact_all()',
    'emit_cases': 'Tests.emit_cases(args)',
    'contract_route': 'Tests.contract_route(args)',
    'one_paths': 'Tests.one_paths(One_paths.run(Unit{}))',
    'export_mu': 'Tests.export_mu(args)',
    'roundtrip': 'Tests.roundtrip(args)',
}
# Oracles fixed by the Ethereum ABI and keccak specifications, not by this tree.
ABI_ONE_TRUE = '0000000000000000000000000000000000000000000000000000000000000001' * 2
KECCAK_EMPTY = '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
TRANSFER_SIGNATURE = '7472616e7366657228616464726573732c75696e7432353629'
# One row per command that `dev/build.py runtest` runs, covering every adapter in ADAPTERS.
# The third field selects the verdict: None = the adapter asserts and exits nonzero on a failure,
# so its own output goes to the log; a string = compare the whole stdout with it; the empty
# string = the adapter prints data, not a verdict, so read the exit code and drop the output.
RUNTEST = (
    ('sl_surface', (), None),
    ('abi_codec', ('encode', 'uint256,bool', '1', 'true'), 'OK ' + ABI_ONE_TRUE),
    ('abi_codec', ('decode', 'uint256,bool', ABI_ONE_TRUE), 'OK ["1","true"]'),
    ('abi_schema', (), ''),
    ('layout_packed', ('write|uint8|1|0|65535|0', 'read|uint8|1|0|65535'), 'OK 255\nOK 255'),
    ('keccak_vec', ('hash', ''), KECCAK_EMPTY),
    ('keccak_vec', ('selector', TRANSFER_SIGNATURE), '0xa9059cbb'),
    ('asm_cases', ('suite',), None),
    ('asm_cases', ('fixtures',), ''),
    ('asm_compact', (), None),
    ('emit_cases', ('constructors',), None),
    ('emit_cases', ('words',), None),
    ('emit_cases', ('storage',), None),
    ('contract_route', (), None),
    ('one_paths', (), None),
    ('export_mu', ('--tree', 'test/meta/mu-tree-bridge.kan'), ''),
    ('export_mu', ('--vector', 'test/meta/mu-vector-bridge.kan'), ''),
    ('roundtrip', ('corpus/contracts/Return.asy',), None),
)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def compiler():
    candidate = os.environ.get('BEND') or str(ROOT / '.tools/bend/bin/bend')
    resolved = shutil.which(candidate)
    if not resolved:
        raise ValueError('Bend 2 is missing. Run python3 -P dev/bootstrap-bend.py, or set BEND to the pinned checkout bin/bend.')
    path = Path(resolved).resolve()
    revision = subprocess.run(['git', '-C', str(path.parent.parent), 'rev-parse', 'HEAD'], capture_output=True, text=True, check=False)
    if revision.returncode or revision.stdout.strip() != PIN['bend']['commit']:
        raise ValueError('BEND must belong to the checkout pinned in dev/toolchain.json')
    return path


def runtime():
    node = shutil.which(os.environ.get('NODE', 'node'))
    if not node:
        raise ValueError('Node.js is missing')
    version = subprocess.run([node, '--version'], capture_output=True, text=True, check=True).stdout.strip()
    if int(version.removeprefix('v').split('.')[0]) < PIN['node_minimum_major']:
        raise ValueError(f'Node.js {PIN["node_minimum_major"]} or newer is required')
    return str(Path(node).resolve())


def executable(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)
    path.chmod(0o755)


def wrapper(node, target, extra=''):
    launch = ("const { Worker } = require('node:worker_threads'); "
              "const worker = new Worker(process.argv[1], { argv: process.argv.slice(2), execArgv: [], "
              f"resourceLimits: {{ stackSizeMb: {PIN['stack_kib'] / 1024} }} }}); "
              "worker.on('error', error => { process.stderr.write(String(error.stack || error) + '\\n'); process.exitCode = 1; }); "
              "worker.on('exit', code => { process.exitCode = code || process.exitCode || 0; });")
    return ('#!/bin/sh\nset -eu\n'
            'ASSAY_ROOT=$(CDPATH= cd -- "${0%/*}/../.." && pwd)\nexport ASSAY_ROOT\n'
            ': "${NODE_COMPILE_CACHE:=$ASSAY_ROOT/_build/bend/node-cache}"\nexport NODE_COMPILE_CACHE\n'
            f'exec {shlex.quote(node)} -e {shlex.quote(launch)} '
            f'"$ASSAY_ROOT/_build/bend/{target}.js" {extra} "$@"\n')


def build(target, bend, node):
    records = []
    paths = [p for p in sorted((ROOT / 'src').glob('*.bend')) if target != 'assay' or p.name != 'tests.bend']
    for path in paths:
        records.extend(declarations(path.read_text(), path.relative_to(ROOT)))
    entry = 'Entry.Tests' if target == 'tests' else 'Entry.Cli'
    if target == 'backends':
        entry = 'Entry.Backends'
        bridge = '@unsafe\ndef Entry.Backends.args(input: List<&2, String>) -> IO(Unit):\n  match input:\n'
        for adapter in BACKENDS:
            bridge += '    case Con{' + json.dumps(adapter) + ', args}: ' + ENTRIES[adapter] + '\n'
        bridge += '    case _: NativeIO.die(Unit, 64, "unknown backend adapter")\n'
        bridge += 'def Entry.Backends() -> IO(Unit): IO.bind(List<&1, String>, Unit, NativeIO.args(), args => Entry.Backends.args(Tests.arguments(args)))\n'
        records.extend(declarations(bridge, '<backend-entry>'))
    if target.startswith('test_'):
        adapter = target.removeprefix('test_')
        entry = 'Entry.Adapter'
        bridge = ('@unsafe\ndef Entry.Adapter.args(args: List<&2, String>) -> IO(Unit):\n  ' + ENTRIES[adapter] + '\n'
                  'def Entry.Adapter() -> IO(Unit): IO.bind(List<&1, String>, Unit, NativeIO.args(), args => Entry.Adapter.args(Tests.arguments(args)))\n')
        records.extend(declarations(bridge, '<adapter-entry>'))
    source = bundle(reachable(records, entry), entry)
    source = source.replace('import "./os.js"', 'import "../../src/os.js"')
    source = source.replace('import "./test-os.js"', 'import "../../src/test-os.js"')
    OUT.mkdir(parents=True, exist_ok=True)
    source_path = OUT / (target + '.bend')
    output_path = OUT / (target + '.js')
    receipt = OUT / (target + '.json')
    inputs = source.encode() + (ROOT / 'src/os.js').read_bytes() + (ROOT / 'dev/toolchain.json').read_bytes() + bend.read_bytes()
    if target != 'assay':
        inputs += (ROOT / 'src/test-os.js').read_bytes()
    identity = digest(inputs)
    cache = OUT / 'cache' / identity
    if cache.with_suffix('.json').exists() and cache.with_suffix('.js').exists():
        saved = json.loads(cache.with_suffix('.json').read_text())
        if saved.get('inputs_sha256') == identity and digest(cache.with_suffix('.js').read_bytes()) == saved.get('output_sha256'):
            shutil.copy2(cache.with_suffix('.js'), output_path)
            shutil.copy2(cache.with_suffix('.json'), receipt)
    if receipt.exists() and output_path.exists():
        previous = json.loads(receipt.read_text())
        if previous.get('inputs_sha256') == identity and previous.get('output_sha256') == digest(output_path.read_bytes()):
            previous['node'] = node
            receipt.write_text(json.dumps(previous, indent=2) + '\n')
            print(f'BEND BUILD {target} cached')
            return
    source_path.write_text(source)
    log = OUT / (target + '.log')
    temporary = OUT / (target + '.new.js')
    with log.open('w') as stream:
        result = subprocess.run([str(bend), str(source_path), '-o', str(temporary)], stdout=stream, stderr=subprocess.STDOUT, env=os.environ | {'BEND_NO_TELEMETRY': '1'}, cwd=ROOT)
    if result.returncode:
        print('\n'.join(log.read_text().splitlines()[:35]), file=sys.stderr)
        raise ValueError(f'Bend compilation failed, full log: {log}')
    temporary.replace(output_path)
    receipt.write_text(json.dumps({'inputs_sha256': identity, 'output_sha256': digest(output_path.read_bytes()), 'compiler_commit': PIN['bend']['commit'], 'node': node}, indent=2) + '\n')
    cache.parent.mkdir(exist_ok=True)
    shutil.copy2(output_path, cache.with_suffix('.js'))
    shutil.copy2(receipt, cache.with_suffix('.json'))
    print(f'BEND BUILD {target} OK')


def main():
    args = sys.argv[1:]
    action = args.pop(0) if args and args[0] in ('build', 'runtest') else 'build'
    tests = action == 'runtest' or not args or any('test' in arg or arg == '@all' for arg in args)
    test_only = bool(args) and all(arg == 'test' or arg.startswith(('test/', '_build/test/')) for arg in args)
    bend, node = compiler(), runtime()
    if not test_only:
        build('assay', bend, node)
        executable(ROOT / '_build/bin/assay', wrapper(node, 'assay'))
    if tests:
        selected = [Path(arg).name.removesuffix('.exe') for arg in args if arg.startswith(('test/', '_build/test/'))]
        if selected and all(name in ADAPTERS for name in selected):
            for adapter in dict.fromkeys(selected):
                target = 'test_' + adapter
                build(target, bend, node)
                executable(ROOT / '_build/test' / adapter, wrapper(node, target))
        else:
            build('tests', bend, node)
            build('backends', bend, node)
            for adapter in ADAPTERS:
                argument = 'surface' if adapter == 'sl_surface' else adapter
                target = 'backends' if adapter in BACKENDS else 'tests'
                executable(ROOT / '_build/test' / adapter, wrapper(node, target, shlex.quote(argument)))
            executable(ROOT / '_build/test/main', '#!/bin/sh\nset -eu\n' + f'exec {shlex.quote(sys.executable)} -P "${{0%/*}}/../../dev/kernel-suite.py" "$@"\n')
    if action == 'runtest':
        uncovered = [adapter for adapter in ADAPTERS if adapter not in {row[0] for row in RUNTEST}]
        if uncovered:
            raise ValueError('dev/build.py RUNTEST runs no command for: ' + ', '.join(uncovered))
        subprocess.run([sys.executable, '-P', str(ROOT / 'dev/kernel-suite.py')], cwd=ROOT, check=True)
        for adapter, arguments, expected in RUNTEST:
            command = [str(ROOT / '_build/test' / adapter), *arguments]
            if expected is None:
                subprocess.run(command, cwd=ROOT, check=True)
            else:
                output = subprocess.run(command, cwd=ROOT, check=True, capture_output=True, text=True).stdout.strip()
                if expected and output != expected:
                    raise ValueError(f'RUNTEST {adapter} {" ".join(arguments)} wanted {expected!r}, read {output[:120]!r}')
            print(f'RUNTEST {adapter} {" ".join(arguments)} OK', flush=True)
        print(f'RUNTEST adapters={len(ADAPTERS)} commands={len(RUNTEST)} OK', flush=True)


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'BEND BUILD FAIL: {error}', file=sys.stderr)
        raise SystemExit(1)

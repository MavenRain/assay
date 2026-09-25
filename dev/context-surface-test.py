#!/usr/bin/env python3
"""Check surface context lowering, execution, constructor state and refusals."""
import hashlib
import importlib.util
import json
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/context-surface'
spec = importlib.util.spec_from_file_location('core_context', ROOT / 'dev/context-test.py')
C = importlib.util.module_from_spec(spec)
spec.loader.exec_module(C)
C.WORK = WORK
require = C.require
FILES = ('runtime.hex', 'init.hex', 'abi.json', 'layout.json', 'axioms.txt')


def program(errors=False, proofs=False, deployer=True):
    error = 'error Denied ()' if errors else ''
    failure = 'Denied () ' if errors else ''
    guard = f'guard {failure}(leWord sender bound)' if proofs else 'guard le sender bound'
    init = 'deployer owner ;' if deployer else ''
    return f'''contract SurfaceContext where
  storage State := {{ owner : Word ; last : Word }}
  {error}
  entry who () : Eff Sig Word := do
    old <- sload owner ; sender <- caller ; later <- sload last ; again <- caller ; pure sender
  entry remember () : Eff Sig Word := do
    sender <- caller ; sstore last sender ; pure sender
  entry bounded (bound : Word) : Eff Sig Word := do
    sender <- caller ; sstore last sender ; {guard} ; pure sender
  constructor := do sstore owner (word 7) ; {init} sstore last (word 9) ; pure ()
'''


def single(body='sender <- caller ; pure sender', init='deployer owner ;', extra='', args=''):
    return f'''contract SingleContext where
  storage State := {{ owner : Word ; cell : Word ; limit : Word }}
  {extra}
  entry get ({args}) : Eff Sig Word := do {body}
  constructor := do {init} pure ()
'''


def outcome(name, path, runtime, data, caller, want, *, value=0, slots=None):
    slots = {'0': '0x7', '1': '0x9'} if slots is None else slots
    argv = [C.BINARY, 'run', path, '--calldata', data, '--caller', hex(caller), '--value', value]
    for slot, stored in slots.items():
        argv += ['--storage', f'{int(slot, 16)}={int(stored, 16)}']
    model = json.loads(C.checked('model-' + name, argv))
    actual, _ = C.evm_run(name, runtime, data, caller, slots=slots, value=value)
    require(model == want, 'SURFACE-CONTEXT-MODEL ' + name)
    require(actual == want, 'SURFACE-CONTEXT-EVM ' + name)


def live(only=False):
    sig = C.selectors()
    cases, pairs, creates, signed = [], [], [], 0
    for errors in (False, True):
        for proofs in (False, True):
            for deployer in (False, True):
                name = f'layout-{int(errors)}-{int(proofs)}-{int(deployer)}'
                source = program(errors, proofs, deployer)
                if errors and proofs and deployer:
                    source = (ROOT / 'examples/ContextSurface.asy').read_text()
                path, output, runtime = C.emit(name, source)
                core = C.fixture(errors, proofs, deployer)
                if errors and not proofs:
                    core = core.replace('reject (inj 0 of 1 (tuple ()) : Error)', 'abort')
                core_dir = WORK / (name + '-source')
                core_dir.mkdir()
                contract = 'ContextSurface' if errors and proofs and deployer else 'SurfaceContext'
                core_path = core_dir / (contract + '.asy')
                core_path.write_text(core)
                reference = WORK / (name + '-core')
                C.checked('emit-' + name + '-core', [C.BINARY, 'emit', core_path, '-o', reference])
                for file in FILES:
                    require((output / file).read_bytes() == (reference / file).read_bytes(),
                            'SURFACE-CONTEXT-PAIR ' + name + ' ' + file)
                pairs.append(name)
                if only:
                    continue
                abi = json.loads((output / 'abi.json').read_text())
                require({row['name']: row['stateMutability'] for row in abi if row['type'] == 'function'} ==
                        dict(who='view', remember='nonpayable', bounded='nonpayable'), 'SURFACE-CONTEXT-ABI')
                for caller in (0, 1, C.SENDER, 2**160 - 1):
                    word = f'0x{caller:064x}'
                    before = {'0': '0x7', '1': '0x9'}
                    written = {'0': '0x7', **({'1': hex(caller)} if caller else {})}
                    failure = '0x' + sig['denied'] if errors and proofs else '0x'
                    rows = [('who', sig['who'], 0, 'success', word, before),
                            ('remember', sig['remember'], 0, 'success', word, written),
                            ('equal', sig['bounded'] + f'{caller:064x}', 0, 'success', word, written),
                            ('zero', sig['bounded'] + '00' * 32, 0, 'revert' if caller else 'success',
                             failure if caller else word, before if caller else written),
                            ('value', sig['who'], 1, 'revert', '0x', before),
                            ('short', sig['bounded'] + '00' * 31, 0, 'revert', '0x', before),
                            ('unknown', 'ffffffff', 0, 'revert', '0x', before)]
                    for label, data, value, status, result, after in rows:
                        key = f'{name}-{caller}-{label}'
                        want = dict(status=status, output=result, storage=after)
                        outcome(key, path, runtime, data, caller, want, value=value)
                        if caller == C.SENDER:
                            report, evidence = C.D.execute(runtime, data, C.prestate(before),
                                                          shutil.which('evm'), value=value)
                            C.save('signed-' + key, dict(report=report, evidence=evidence))
                            actual = dict(status=report['status'], output=report['output'],
                                          storage=report['storage'].get(C.D.RECEIVER, {}))
                            require(actual == want, 'SURFACE-CONTEXT-SIGNED ' + key)
                            signed += 1
                        cases.append(dict(name=key, expected=want))
                    for value in (0, 1):
                        key = f'{name}-create-{caller}-{value}'
                        init = (output / 'init.hex').read_text().strip()
                        _, raw = C.evm_run(key, init, '', caller, value=value, create=True)
                        owner = caller if deployer else 7
                        storage = {**({'0': hex(owner)} if owner else {}), '1': '0x9'}
                        require(raw['status'] == ('revert' if value else 'success') and
                                raw['output'] == ('' if value else runtime) and
                                list(raw['storage'].values()) == ([] if value else [storage]),
                                'SURFACE-CONTEXT-CREATE ' + key)
                        creates.append(dict(name=key, result=raw))
    C.save('LIVE', dict(cases=cases, signed=signed, creates=creates, pairs=pairs))
    return len(cases), signed, len(creates), len(pairs)


def composition():
    invariant = 'invariant bounded (s : State) : Prop := Le s.cell s.limit'
    helper = 'proof ordered (0 a : Word) (0 b : Word) (0 p : Le a b) : Le a b := p'
    body = ('sender <- caller ; bound <- sload limit ; (0 p) <- guard (leWord sender bound) ; '
            'let (0 q) := ordered(sender, bound) ; let rest : Word := subLe bound sender q ; '
            'sstore cell sender ; pure rest')
    source = single(body, 'deployer owner ; sstore limit (word 100) ;', invariant + '\n' + helper)
    path, output, runtime = C.emit('invariant', source)
    data = C.checked('selector-get', ['cast', 'sig', 'get()']).strip()[2:]
    records = []
    for caller in (0, 42, 100, 101, 2**160 - 1):
        before = {'0': '0x7', '1': '0x9', '2': '0x64'}
        success = caller <= 100
        after = {'0': '0x7', '2': '0x64', **({'1': hex(caller)} if caller else {})} if success else before
        want = dict(status='success' if success else 'revert',
                    output=f'0x{100 - caller:064x}' if success else '0x', storage=after)
        outcome('invariant-' + str(caller), path, runtime, data, caller, want, slots=before)
        records.append(dict(caller=caller, expected=want))
    shadow = single('sender <- caller ; let saved : Word := sender ; sender <- sload cell ; '
                    'again <- caller ; pure saved', args='sender : Word')
    path, _, runtime = C.emit('shadow', shadow)
    data_arg = C.checked('selector-arg', ['cast', 'sig', 'get(uint256)']).strip()[2:] + f'{999:064x}'
    shadow_want = dict(status='success', output=f'0x{42:064x}', storage={'0': '0x7', '1': '0x9'})
    outcome('shadow', path, runtime, data_arg, 42, shadow_want)
    records.append(dict(caller=42, expected=shadow_want))
    # Context-free entry tables must also work with the optional creation effect.
    orders = []
    for name, init, owner, cell in [('deployer-only', 'deployer cell ;', 0, 42),
                                  ('overwrite', 'deployer owner ; sstore owner (word 8) ;', 8, 0),
                                  ('repeat', 'deployer owner ; sstore owner (word 8) ; deployer owner ;', 42, 0),
                                  ('invariant-overwrite', 'deployer cell ; sstore cell (word 0) ;', 0, 0)]:
        extra = invariant if name == 'invariant-overwrite' else ''
        _, output, runtime = C.emit(name, single('pure (word 0)', init, extra))
        _, raw = C.evm_run(name + '-create', (output / 'init.hex').read_text().strip(), '', 42, create=True)
        want = {**({'0': hex(owner)} if owner else {}), **({'1': hex(cell)} if cell else {})}
        require(raw['status'] == 'success' and raw['output'] == runtime and
                list(raw['storage'].values()) == ([want] if want else []), 'SURFACE-CONTEXT-ORDER ' + name)
        orders.append(dict(name=name, owner=owner, cell=cell))
    C.save('COMPOSITION', records)
    return len(records), len(orders)


def negative_cases():
    invariant = 'invariant bounded (s : State) : Prop := Le s.owner (word 0)'
    return [
        ('entry-deployer', single('deployer owner ; pure (word 0)'), 'SURFACE_EFFECT'),
        ('constructor-caller', single(init='sender <- caller ;'), 'SURFACE_CONSTRUCTOR'),
        ('constructor-local', single(init='let sender : Word := word 1 ; sstore owner sender ;'), 'SURFACE_CONSTRUCTOR'),
        ('unknown-slot', single(init='deployer missing ;'), 'SURFACE_SLOT'),
        ('missing-slot', single(init='deployer ;'), 'SURFACE_NAME'),
        ('caller-argument', single('sender <- caller (word 1) ; pure sender'), 'SURFACE_SYNTAX'),
        ('caller-unbound', single('pure sender'), 'SURFACE_SCOPE'),
        ('caller-proof', single('sender <- caller ; let (0 p : Le sender sender) := sender ; pure sender'), 'SURFACE_PROOF'),
        ('reserved-field', single().replace('owner : Word', 'caller : Word'), 'SURFACE_NAME'),
        ('reserved-binding', single('deployer <- caller ; pure deployer'), 'SURFACE_NAME'),
        ('reserved-contract', single().replace('SingleContext', 'caller'), 'SURFACE_NAME'),
        ('deployer-return', single(init='deployer owner ;').replace('pure ()', 'pure (word 0)'), 'SURFACE_CONSTRUCTOR'),
        ('dynamic-invariant', single(extra=invariant), 'SURFACE_INVARIANT'),
        ('stale-invariant', single(init='sstore owner (word 0) ; deployer owner ;', extra=invariant), 'SURFACE_INVARIANT'),
        ('compound-invariant', single(extra='invariant both (s : State) : Prop := Both (Le s.cell s.limit) (Le s.owner (word 0))'), 'SURFACE_INVARIANT'),
        ('named-invariant', single(extra='predicate Zero (0 x : Word) : Prop := Le x (word 0)\n'
                                  'invariant bounded (s : State) : Prop := Zero(s.owner)'), 'SURFACE_INVARIANT'),
        ('caller-invariant', single('sender <- caller ; sstore cell sender ; pure sender',
                                   extra='invariant bounded (s : State) : Prop := Le s.cell s.limit'), 'SURFACE_INVARIANT'),
    ]


def refusals(only=None):
    rows = negative_cases()
    require(only is None or only in {name for name, _source, _marker in rows},
            'SURFACE-CONTEXT-REFUSAL unknown ' + str(only))
    checked = 0
    for name, source, marker in rows:
        if only is not None and name != only:
            continue
        path = WORK / (name + '.asy')
        path.write_text(source)
        output = WORK / (name + '-out')
        for command in (['check', path], ['emit', path, '-o', output], ['run', path, '--calldata', '0x']):
            result = C.capture(name + '-' + command[0], [C.BINARY, *command])
            require(result.returncode == 1 and marker in result.stdout + result.stderr and not output.exists(),
                    'SURFACE-CONTEXT-REFUSAL ' + name + ' ' + command[0])
        checked += 1
    return checked


def mutants():
    cases = native_mutations.load(__file__)
    records = []
    with tempfile.TemporaryDirectory(prefix='assay-surface-context-mutants-') as temporary:
        copy = Path(temporary) / 'copy'
        native_mutations.copy_project(ROOT, copy)
        path = copy / 'src/emitter.bend'
        original = path.read_text()
        for name, before, after, witness, marker in cases:
            require(native_mutations.count(original, before) == 1, 'SURFACE-CONTEXT-MUTANT anchor ' + name)
            for mutated in (True, False):
                path.write_text(native_mutations.replace(original, before, after) if mutated else original)
                label = ('mutant-' if mutated else 'control-') + name
                build = C.capture(label + '-build', ['zsh', '-f', 'dev/build.sh', 'build', 'bin/assay'], cwd=copy, timeout=120)
                require(build.returncode == 0, 'SURFACE-CONTEXT-MUTANT build ' + label)
                result = C.capture(label, ['python3', '-P', 'dev/context-surface-test.py', witness], cwd=copy, timeout=180)
                require(result.returncode == (1 if mutated else 0) and (not mutated or marker in result.stdout),
                        'SURFACE-CONTEXT-MUTANT witness ' + label)
                records.append(dict(name=label, exit=result.returncode, marker=marker,
                                    source_sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('SURFACE-CONTEXT-MUTANT ' + name + ' killed control=OK', flush=True)
    C.save('MUTANTS', records)
    return len(cases)


def main():
    commands = dict(live=live, pairs=lambda: live(only=True), composition=composition, refusals=refusals, mutants=mutants,
                    **{'stale-invariant': lambda: refusals('stale-invariant')})
    if sys.argv[1:] and sys.argv[1:] not in [[name] for name in commands]:
        return 64
    shutil.rmtree(WORK, ignore_errors=True)
    WORK.mkdir(parents=True, exist_ok=True)
    if sys.argv[1:]:
        result = commands[sys.argv[1]]()
        print(f'SURFACE-CONTEXT {sys.argv[1]} {result} OK', flush=True)
    else:
        cases, signed, creates, pairs = live()
        composition_cases, order = composition()
        invalid, killed = refusals(), mutants()
        print(f'SURFACE-CONTEXT cases={cases} signed={signed} creates={creates} pairs={pairs} '
              f'composition={composition_cases} order={order} refusals={invalid} mutants={killed} OK', flush=True)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('SURFACE-CONTEXT FAIL ' + str(error), flush=True)
        sys.exit(1)

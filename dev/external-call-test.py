#!/usr/bin/env python3
"""Keep checked external calls out of deployable bytecode until lowering exists."""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
BINARY = ROOT / 'assay'
REFUSAL = 'CALL: external call lowering is not available until M3 group 3'


def run(*args):
    return subprocess.run([str(BINARY), *map(str, args)], capture_output=True,
                          text=True, timeout=30)


def main():
    routes = {
        'plain': ('count : Word', '', '', 'Word'),
        'packed': ('count : Uint8', '', '', 'Word'),
        'mapping': ('balances : Mapping Address Uint256', '', '', 'Word'),
        'function': ('count : Word', '', '(value : Uint256)', 'Word'),
        'return': ('count : Word', '', '', 'Uint256'),
        'event': ('count : Word', 'event Tick ()', '', 'Word'),
    }
    effects = {
        'raw': 'ok <- call (word 1) (word 0)',
        'selector': 'ok <- call (word 1) (word 0) 0x12345678 (word 7)',
        'returndata': 'ok <- returndata',
        'nested': 'sender <- caller ; guard Denied () (leWord sender (word 10)) ; ok <- call sender (word 0)',
    }
    checked = 0
    with tempfile.TemporaryDirectory(prefix='assay-external-call-') as directory:
        work = Path(directory)
        for route, (storage, event, params, result) in routes.items():
            for effect, body in effects.items():
                source = work / f'{route}-{effect}.asy'
                source.write_text(f'contract CallProbe where\n'
                                  f'  storage State := {{ {storage} }}\n'
                                  f'  {event}\n'
                                  f'  error Denied ()\n'
                                  f'  entry send {params or "()"} : Eff Sig {result} :=\n'
                                  f'    do {body} ; pure ok\n')
                check = run('check', source)
                if check.returncode:
                    raise AssertionError(f'{source.name}: check: {check.stderr}')
                output = work / source.stem
                emit = run('emit', source, '-o', output)
                if emit.returncode == 0 or REFUSAL not in emit.stderr:
                    raise AssertionError(f'{source.name}: expected explicit refusal, '
                                         f'got exit={emit.returncode} {emit.stderr!r}')
                if output.exists() and any(output.iterdir()):
                    raise AssertionError(f'{source.name}: refused emission wrote artifacts')
                checked += 1
        control = work / 'control.asy'
        control.write_text('contract Control where\n'
                           '  storage State := { count : Word }\n'
                           '  entry get () : Eff Sig Word := do pure (word 7)\n')
        emitted = run('emit', control, '-o', work / 'control')
        if emitted.returncode:
            raise AssertionError(f'call-free control: {emitted.stderr}')
    print(f'EXTERNAL-CALL checked={checked} refused={checked} control=1 OK')


if __name__ == '__main__':
    main()

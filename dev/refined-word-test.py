#!/usr/bin/env python3
"""Check the refined M0 Word protocol: a Prop-valued InRange witness on `word`.

The kernel checks the witness by the literal fast path, the emitter erases it,
and the refined contracts emit the same bytes as the unrefined ones.
"""
import importlib.util
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / 'dev/refined-word-data'
ASSAY = ROOT / 'assay'
OUTPUTS = ('abi.json', 'axioms.txt', 'init.hex', 'layout.json', 'runtime.hex')
# Refined fixture -> unrefined original with the same stem (layout.json labels the contract by stem).
VALID = (('Ref20.asy', 'corpus/contracts/Ref20.asy'), ('GuardCore.asy', 'examples/GuardCore.asy'))
# Negative fixtures refused by the kernel: the .err text is the whole stderr of `assay check`.
KERNEL = ('out-of-range', 'other-value', 'width-8')
# Negative fixture accepted by the kernel (an axiom witness) and refused by the emitter range check.
EMITTER = ('forged-axiom',)


def module(name, relative):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


require = module('refined_word_diff', 'evm/diff.py').require


def run(*argv):
    return subprocess.run((str(ASSAY),) + argv, cwd=ROOT, capture_output=True, text=True, timeout=120)


def check(path):
    result = run('check', str(path))
    return result.returncode, result.stderr.strip()


def emit(source, target):
    shutil.rmtree(target, ignore_errors=True)
    result = run('emit', str(source), '-o', str(target))
    return result.returncode, result.stderr.strip()


def accepted(name):
    code, stderr = check(DATA / name)
    require(code == 0 and stderr == '', 'REFINED-WORD-CHECK ' + name + ' ' + stderr)
    print('REFINED-WORD-CHECK ' + name + ' accepted OK', flush=True)


def refused_by_kernel(stem):
    code, stderr = check(DATA / (stem + '.asy'))
    expected = (DATA / (stem + '.err')).read_text().strip()
    require(code != 0 and stderr == expected, 'REFINED-WORD-REFUSE ' + stem + ' ' + stderr)
    print('REFINED-WORD-REFUSE ' + stem + ' kernel OK', flush=True)


def refused_by_emitter(stem, work):
    code, stderr = check(DATA / (stem + '.asy'))
    require(code == 0 and stderr == '', 'REFINED-WORD-AXIOM ' + stem + ' kernel refused ' + stderr)
    code, stderr = emit(DATA / (stem + '.asy'), work / stem)
    expected = (DATA / (stem + '.err')).read_text().strip()
    require(code != 0 and stderr.endswith(expected), 'REFINED-WORD-REFUSE ' + stem + ' ' + stderr)
    print('REFINED-WORD-REFUSE ' + stem + ' emitter OK', flush=True)


def identical(name, original, work):
    stem = Path(name).stem
    refined, unrefined = work / ('refined-' + stem), work / ('unrefined-' + stem)
    code, stderr = emit(DATA / name, refined)
    require(code == 0 and stderr == '', 'REFINED-WORD-EMIT ' + name + ' ' + stderr)
    code, stderr = emit(ROOT / original, unrefined)
    require(code == 0 and stderr == '', 'REFINED-WORD-EMIT ' + original + ' ' + stderr)
    require(sorted(path.name for path in refined.iterdir()) == list(OUTPUTS), 'REFINED-WORD-FILES ' + name)
    same = [(refined / output).read_bytes() == (unrefined / output).read_bytes() for output in OUTPUTS]
    require(all(same), 'REFINED-WORD-BYTES ' + name + ' ' + str(dict(zip(OUTPUTS, same))))
    print('REFINED-WORD-BYTES ' + name + ' identical to ' + original + ' OK', flush=True)


def legacy_helpers(work):
    canonical = (DATA / 'Ref20.asy').read_text().split('mu Word', 1)[0]
    for name, original in VALID:
        baseline = work / ('legacy-baseline-' + Path(name).stem)
        code, stderr = emit(ROOT / original, baseline)
        require(code == 0 and stderr == '', 'REFINED-WORD-LEGACY ' + original + ' ' + stderr)
        for label, helper in (('unrelated', 'def InRange : Nat := 1\n'), ('canonical', canonical)):
            directory = work / (label + '-' + Path(name).stem)
            directory.mkdir()
            source = directory / name
            source.write_text(helper + (ROOT / original).read_text())
            target = directory / 'emitted'
            code, stderr = emit(source, target)
            require(code == 0 and stderr == '', 'REFINED-WORD-LEGACY ' + label + '/' + name + ' ' + stderr)
            require(sorted(path.name for path in target.iterdir()) == list(OUTPUTS),
                    'REFINED-WORD-LEGACY-FILES ' + label + '/' + name)
            require(all((target / output).read_bytes() == (baseline / output).read_bytes() for output in OUTPUTS),
                    'REFINED-WORD-LEGACY-BYTES ' + label + '/' + name)
    print('REFINED-WORD legacy_helpers=4 OK', flush=True)


def main():
    require(ASSAY.exists(), 'REFINED-WORD-BUILD ./assay is missing')
    with tempfile.TemporaryDirectory(prefix='refined-word-') as scratch:
        work = Path(scratch)
        for name, _original in VALID:
            accepted(name)
        for stem in KERNEL:
            refused_by_kernel(stem)
        for stem in EMITTER:
            refused_by_emitter(stem, work)
        for name, original in VALID:
            identical(name, original, work)
        legacy_helpers(work)
    print(f'REFINED-WORD valid={len(VALID)} kernel_refused={len(KERNEL)} emitter_refused={len(EMITTER)} OK')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('REFINED-WORD FAIL ' + str(error))
        sys.exit(1)

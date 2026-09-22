#!/usr/bin/env python3
"""Exercise the frozen Bend comparison, including its fail-closed boundary."""
from pathlib import Path
import copy
import importlib.util
import json
import subprocess
import tempfile
import types


def require(ok, message):
    if not ok:
        raise ValueError('BEND2-RATIO-TEST ' + message)


def exercise(module, root, baseline):
    def boundary(ratio):
        value = copy.deepcopy(baseline)
        for row, scale in zip(value['rounds'], (0.5, 0.8, 1.0, 1.5, 3.0)):
            weights = (0.5, 0.5, 1.0, 1.0, 1.5, 1.5)
            row['samples_ms'] = {'assay': [10 * ratio * scale * w for w in weights],
                                 'bend2': [10.0] * 6}
        value['window_seconds'] = 2.0
        return value

    controls, refused = 0, 0
    for ratio, binding in ((0.99, True), (1.0, True), (1.01, False)):
        observed, _ = module.validate(root, boundary(ratio), binding=binding)
        require(abs(observed - ratio) < 1e-12, 'control ratio')
        controls += 1

    def reject(value, marker):
        nonlocal refused
        try:
            module.validate(root, value)
        except ValueError as error:
            require(marker in str(error), 'wrong refusal: ' + str(error))
            refused += 1
        else:
            raise ValueError('BEND2-RATIO-TEST accepted ' + marker)

    reject(boundary(1.000000000001), 'BOUND')
    changes = [
        (('stage',), 'M0', 'REPORT-VERSION'),
        (('method', 'subtraction'), 'startup', 'METHOD'),
        (('identities', 'corpus_sha256'), '0' * 64, 'IDENTITIES'),
        (('identities', 'method_sha256', 'dev/bend2-ratio.py'), '0' * 64, 'IDENTITIES'),
        (('identities', 'compiler_sources_sha256'), {}, 'IDENTITIES'),
        (('bend_commit',), '0' * 40, 'BEND-PIN'),
        (('bend_sources_sha256',), {}, 'BEND-PIN'),
        (('tools', 'versions', 'bend'), 'bend 1.0', 'TOOLCHAIN'),
        (('tools', 'sha256', 'bend'), 'unmeasured', 'TOOLS-HASH'),
        (('started_utc',), '2026-09-22T00:00:00', 'TIMEZONE'),
        (('case_order',), [], 'CASE-ORDER'),
        (('rounds',), [], 'ROUNDS'),
        (('version',), 2, 'REPORT-VERSION'),
        (('method', 'rounds'), 4, 'METHOD'),
        (('rounds', 0, 'samples_ms', 'native'), [1.0] * 6, 'ORDER'),
        (('rounds', 0, 'order'), ['bend2', 'assay'], 'ORDER'),
        (('rounds', 0, 'samples_ms', 'assay'), [1.0], 'SAMPLES'),
        (('window_seconds',), 60.0, 'WINDOW'),
        (('window_seconds',), 0.01, 'WINDOW'),
        (('outputs',), {}, 'OUTPUT-CASES'),
        (('outputs', 'Return', 'assay'), {}, 'OUTPUT-ASSAY'),
        (('outputs', 'Return', 'native_stdout'), '38', 'OUTPUT-NATIVE'),
        (('outputs', 'Return', 'bend_c_sha256'), '', 'OUTPUT-C'),
    ]
    for path, replacement, marker in changes:
        value = boundary(1.0)
        slot = value
        for key in path[:-1]:
            slot = slot[key]
        slot[path[-1]] = replacement
        reject(value, marker)
    for count in (4, 6):
        value = boundary(1.0)
        value['rounds'] = (value['rounds'] * 2)[:count]
        reject(value, 'ROUNDS')
    for number in (0, -1, True, '1', float('nan'), float('inf')):
        value = boundary(1.0)
        value['rounds'][0]['samples_ms']['assay'][0] = number
        reject(value, 'SAMPLES')
    return controls, refused


def main():
    root = Path(__file__).resolve().parent.parent
    source = root / 'dev/bend2-ratio.py'
    spec = importlib.util.spec_from_file_location('bend2_ratio', source)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    baseline = module.read_json(root / module.REPORT)
    controls, refused = exercise(module, root, baseline)
    program = source.read_text()
    mutants = [
        ("medians['assay'] <= medians['bend2']", "medians['assay'] < medians['bend2']"),
        ("if binding:", "if False:"),
        ("value['identities'] == identities(root)", "True"),
        ("all(positive(x) for x in samples)", "True"),
        ("statistics.median(rows)", "statistics.mean(rows)"),
        ("sum(row['samples_ms'][name])", "max(row['samples_ms'][name])"),
    ]
    for before, after in mutants:
        require(program.count(before) == 1, 'mutation site ' + before)
        mutant = types.ModuleType('bend2_mutant')
        exec(compile(program.replace(before, after), str(source), 'exec'), mutant.__dict__)
        try:
            exercise(mutant, root, baseline)
        except ValueError:
            pass
        else:
            raise ValueError('BEND2-RATIO-TEST surviving mutation ' + before)
    with tempfile.TemporaryDirectory(prefix='bend2-refusals-') as temporary:
        work = Path(temporary)
        bad = work / 'invalid.json'
        for text in ('{"x": 1, "x": 2}', '{"x": NaN}', '{"x": Infinity}'):
            bad.write_text(text)
            try:
                module.read_json(bad)
            except ValueError:
                refused += 1
            else:
                raise ValueError('BEND2-RATIO-TEST accepted invalid JSON')
        (work / 'dev').mkdir()
        (work / 'dev/bend2-ratio.py').write_text(program)
        for seal, reason in ((None, 'dev/BEND2.sha256'),
                             ('0' * 64 + '  dev/bend2-baseline.json\n', 'BEND2-REPORT-SEAL')):
            if seal is not None:
                (work / 'dev/BEND2.sha256').write_text(seal)
                (work / 'dev/bend2-baseline.json').write_text(json.dumps(baseline))
            result = subprocess.run(['python3', '-P', str(work / 'dev/bend2-ratio.py')],
                                    capture_output=True, text=True, timeout=10)
            require(result.returncode == 1 and result.stdout.startswith('BEND2-RATIO FAIL ') and
                    reason in result.stdout and 'subtraction=none OK' not in result.stdout,
                    'missing or changed freeze accepted: ' + reason)
            refused += 1
    print(f'BEND2-RATIO-TEST controls={controls} refused={refused} mutants={len(mutants)} OK')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError) as error:
        print('BEND2-RATIO-TEST FAIL ' + str(error))
        raise SystemExit(1)

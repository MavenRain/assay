#!/usr/bin/env python3
"""Check typed log decoding against independent event bytes and malformed logs."""
from pathlib import Path
import importlib.util
import json
import re
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/event-decode'
spec = importlib.util.spec_from_file_location('event_oracles', ROOT / 'dev/event-codec-test.py')
events = importlib.util.module_from_spec(spec)
spec.loader.exec_module(events)


def build(root):
    events.run(root, sys.executable, '-P', 'dev/build.py', 'build', 'test/event_decode')


def query(name, anonymous=False, types=(), flags=(), topics=(), data=''):
    return '|'.join((name, str(int(anonymous)), ','.join(types),
                     ','.join(str(int(flag)) for flag in flags), ','.join(topics), data))


def invert(rows):
    result = []
    for row in rows:
        name, anon, types, flags, _, *values = row['query'].split('|')
        ts, fs = types.split(',') if types else [], flags.split(',') if flags else []
        topics, data = row['want'][3:].split('|')
        values = [('hash:' + events.keccak(bytes.fromhex(value)))
                  if typ == 'string' and flag == '1' else value
                  for typ, flag, value in zip(ts, fs, values, strict=True)]
        result.append(dict(name=row['name'], query='|'.join((name, anon, types, flags, topics, data)),
                           want='OK ' + '|'.join(values)))
    return result


def word(n):
    return f'{n:064x}'


def negatives():
    rows = []

    def add(name, error, **kwargs):
        rows.append(dict(name=name, query=query('Bad', **kwargs), want='ERR ' + error))

    signature = events.keccak(b'Bad()')
    add('missing-signature', 'Topic_count')
    add('extra-topic', 'Topic_count', topics=[signature, word(1)])
    add('wrong-signature', 'Wrong_signature', topics=[word(0)])
    add('missing-indexed', 'Topic_count', anonymous=True, types=['uint8'], flags=[1])
    add('anonymous-extra', 'Topic_count', anonymous=True, topics=[word(0)])
    add('named-limit', 'Too_many_topics', types=['uint8']*4, flags=[1]*4, topics=[word(0)]*5)
    add('anonymous-limit', 'Too_many_topics', anonymous=True, types=['uint8']*5, flags=[1]*5, topics=[word(0)]*5)
    # The topic count is also wrong here, so the limit must be checked first.
    add('limit-before-count', 'Too_many_topics', types=['uint8']*4, flags=[1]*4, topics=[word(0)]*2)
    add('anonymous-limit-before-count', 'Too_many_topics', anonymous=True, types=['uint8']*5, flags=[1]*5)
    # These named logs match the signature, so the error comes from the fields.
    add('named-scalar-trailing', 'TRAILING-DATA', types=['uint256'], flags=[0],
        topics=[events.keccak(b'Bad(uint256)')], data=word(1)+'00')
    add('named-uint8-range-1', 'RANGE-uint8', types=['uint8'], flags=[1],
        topics=[events.keccak(b'Bad(uint8)'), word(256)])
    # A single empty topic serializes as no topics, so the empty signature has a second topic.
    add('signature-size-0', 'Topic_size', types=['uint8'], flags=[1], topics=['', word(0)])
    for size in (1, 31, 33, 64):
        add(f'signature-size-{size}', 'Topic_size', topics=['00'*size])
        for typ in ('uint8', 'uint256', 'address', 'bool', 'string'):
            add(f'{typ}-topic-size-{size}', 'Topic_size', anonymous=True, types=[typ], flags=[1], topics=['00'*size])
    # Empty topics within a list are preserved by the adapter.
    add('empty-indexed-topic', 'Topic_size', anonymous=True, types=['string', 'uint8'], flags=[1, 1], topics=['', word(1)])
    for typ, n, error in (('uint8', 256, 'RANGE-uint8'), ('address', 2**160, 'RANGE-address'), ('bool', 2, 'INVALID-BOOL')):
        for flag in (0, 1):
            add(f'{typ}-range-{flag}', error, anonymous=True, types=[typ], flags=[flag],
                topics=[word(n)] if flag else [], data='' if flag else word(n))
    add('scalar-truncated', 'TRUNCATED', anonymous=True, types=['uint256'], flags=[0], data='00'*31)
    add('scalar-trailing', 'TRAILING-DATA', anonymous=True, types=['uint256'], flags=[0], data=word(1)+'00')
    add('empty-data-trailing', 'TRAILING-DATA', anonymous=True, data='00')
    for offset in (0, 1, 31, 33, 64, 2**256-1):
        add(f'offset-{offset}', 'INVALID-OFFSET', anonymous=True, types=['string'], flags=[0], data=word(offset)+word(0))
    add('string-truncated', 'TRUNCATED', anonymous=True, types=['string'], flags=[0], data=word(32)+word(1))
    add('string-padding', 'NONZERO-PADDING', anonymous=True, types=['string'], flags=[0], data=word(32)+word(1)+'61'+'00'*30+'01')
    add('string-trailing', 'TRAILING-DATA', anonymous=True, types=['string'], flags=[0], data=word(32)+word(0)+word(0))
    add('count-before-size', 'Topic_count', anonymous=True, topics=['ff'])
    add('size-before-signature', 'Topic_size', types=['uint8'], flags=[1], topics=[word(0), 'ff'])
    add('signature-before-data', 'Wrong_signature', types=['uint8'], flags=[0], topics=[word(0)], data='ff')
    add('data-before-scalar-topic', 'TRUNCATED', anonymous=True, types=['bool', 'uint8'], flags=[1, 0], topics=[word(2)])
    return rows


ERRORS = {'Too_many_topics', 'Topic_count', 'Topic_size', 'Wrong_signature',
          'RANGE-uint8', 'RANGE-uint256', 'RANGE-address', 'RANGE-bool', 'RANGE-string',
          'TOO-LARGE', 'TRUNCATED', 'INVALID-BOOL', 'INVALID-OFFSET', 'NONZERO-PADDING', 'TRAILING-DATA'}


def check(root, rows):
    output = events.run(root, str(root / '_build/test/event_decode'), *(row['query'] for row in rows)).splitlines()
    if len(output) != len(rows):
        raise ValueError('OUTPUT row count')
    for row, actual in zip(rows, output, strict=True):
        if actual.startswith('ERR '):
            valid = actual[4:] in ERRORS
        else:
            valid = actual.startswith('OK ') and all(re.fullmatch(r'(hash:[0-9a-f]{64}|[0-9a-f]*|true|false)', field)
                                                     for field in actual[3:].split('|'))
        if not valid:
            raise ValueError('OUTPUT malformed')
        if actual != row['want']:
            raise ValueError('ANSWER ' + row['name'] + ': ' + actual + ' != ' + row['want'])


def refusals(root):
    rows = [('bad', 'ADAPTER-USAGE'), ('Bad|2||||', 'ADAPTER-FLAG'),
            ('Bad|1|bytes|0||', 'ADAPTER-TYPE'), ('Bad|1|uint8|||', 'ADAPTER-ARITY'),
            ('Bad|1|uint8|2||', 'ADAPTER-FLAG'), ('Bad|1|||zz|', 'ADAPTER-HEX'),
            ('Bad|1||||f', 'ADAPTER-HEX'), ('Bad|1|||||extra', 'ADAPTER-USAGE')]
    for command, error in rows:
        result = subprocess.run([str(root / '_build/test/event_decode'), command], cwd=root,
                                capture_output=True, text=True, timeout=30)
        if (result.returncode, result.stdout, result.stderr.strip()) != (64, '', error):
            raise ValueError('REFUSAL ' + command + ': ' + repr((result.returncode, result.stdout, result.stderr)))
    return len(rows)


def mutants(rows):
    cases = native_mutations.load(__file__)
    with tempfile.TemporaryDirectory(prefix='assay-event-decode-') as directory:
        root = Path(directory) / 'copy'
        native_mutations.copy_project(ROOT, root)
        for case in cases:
            target = root / case['path']
            original = target.read_text()
            try:
                target.write_text(native_mutations.replace(original, case['patches']))
                build(root)
                witnesses = [row for row in rows if row['name'] in case['witnesses']]
                if len(witnesses) != len(case['witnesses']):
                    raise ValueError('MUTANT missing witness')
                try:
                    check(root, witnesses)
                except ValueError as error:
                    if not str(error).startswith('ANSWER '):
                        raise
                    print('MUTANT ' + case['name'] + ' killed: ' + str(error).split(':')[0])
                else:
                    raise ValueError('MUTANT survived: ' + case['name'])
            finally:
                target.write_text(original)
        build(root)
        check(root, rows)
        refusals(root)
    return len(cases)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    build(ROOT)
    positive, frozen, negative = invert(events.vectors()), invert(events.reference()), negatives()
    rows = positive + frozen + negative
    check(ROOT, rows)
    refused = refusals(ROOT)
    (WORK / 'vectors.json').write_text(json.dumps(rows, indent=2) + '\n')
    killed = mutants(rows)
    print(f'EVENT-DECODE oracle={len(positive)} reference={len(frozen)} negative={len(negative)} refusal={refused} mutants={killed} scope=event-decode OK')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.TimeoutExpired) as error:
        print('EVENT-DECODE FAIL ' + str(error), file=sys.stderr)
        raise SystemExit(1)

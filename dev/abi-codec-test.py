#!/usr/bin/env python3
"""Check ABI tuple bytes, strict decoding, frozen returns and semantic mutants."""
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations
import json
import random
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / '.gatework/abi-codec'
TARGET = 'test/abi_codec'


def require(ok, label):
    if not ok:
        raise ValueError(label)


def run(root, *command):
    result = subprocess.run(command, cwd=root, capture_output=True, text=True, timeout=60)
    require(result.returncode == 0 and not result.stderr,
            'TOOL ' + ' '.join(command) + '\n' + result.stdout + result.stderr)
    return result.stdout.rstrip('\n')


def call(root, mode, types, *args):
    return run(root, str(root / '_build' / TARGET), mode, ','.join(types) or '-', *args)


def word(n):
    return n.to_bytes(32, 'big').hex()


def fixtures():
    cases = [([], []), (['bool'], ['false']), (['bool'], ['true'])]
    for typ, bits in [('uint8', 8), ('uint256', 256), ('address', 160)]:
        cases.extend(([typ], [str(n)]) for n in [0, 1, (1 << bits) - 1])
    texts = ['', 'a', 'x' * 31, 'x' * 32, 'x' * 33, 'x' * 63, 'x' * 64, 'x' * 65,
             'caf\u00e9', '\u03bb\U0001f331']
    cases.extend((['string'], [text.encode().hex()]) for text in texts)
    cases.extend([
        (['uint8', 'string', 'address', 'bool', 'uint256', 'string'],
         ['255', texts[-1].encode().hex(), str((1 << 160) - 1), 'true', str(1 << 255), '']),
        (['string', 'string', 'string'], ['', '61', '62' * 32]),
    ])
    rng = random.Random(20260922)
    for _ in range(24):
        types = rng.choices(['uint8', 'uint256', 'address', 'bool', 'string'], k=rng.randrange(1, 8))
        args = []
        for typ in types:
            if typ == 'string':
                args.append(('ab' * rng.randrange(40)).encode().hex())
            elif typ == 'bool':
                args.append(rng.choice(['false', 'true']))
            else:
                args.append(str(rng.getrandbits({'uint8': 8, 'uint256': 256, 'address': 160}[typ])))
        cases.append((types, args))
    rows = []
    for types, args in cases:
        cast_args = [bytes.fromhex(v).decode() if t == 'string' else
                     '0x' + format(int(v), '040x') if t == 'address' else v
                     for t, v in zip(types, args)]
        encoded = run(ROOT, 'cast', 'abi-encode', 'f(' + ','.join(types) + ')', *cast_args)
        require(encoded.startswith('0x'), 'CAST-HEX')
        rows.append((types, args, encoded[2:]))
    # Raw string bytes are preserved, including NUL and non-UTF-8 bytes.
    raw = '0001ff80' + '00' * 28
    rows.append((['string'], [raw], word(32) + word(32) + raw))
    return rows, len(cases)


def negatives():
    rows = []
    for typ, bits in [('uint8', 8), ('address', 160)]:
        rows.append(('decode', [typ], [word(1 << bits)], 'RANGE-' + typ, 'DECODE-' + typ.upper() + '-RANGE'))
    for n in [2, (1 << 256) - 1]:
        rows.append(('decode', ['bool'], [word(n)], 'INVALID-BOOL', 'DECODE-BOOL'))
    for offset in [0, 1, 31, 33, 64, (1 << 256) - 1]:
        rows.append(('decode', ['string'], [word(offset) + word(0)], 'INVALID-OFFSET', 'DECODE-OFFSET'))
    rows.extend([
        ('decode', ['string'], [word(32)], 'TRUNCATED', 'DECODE-LENGTH'),
        ('decode', ['string'], [word(32) + word((1 << 256) - 1)], 'TRUNCATED', 'DECODE-HUGE-LENGTH'),
        ('decode', ['string'], [word(32) + word(2) + '61'], 'TRUNCATED', 'DECODE-DATA'),
        ('decode', ['string'], [word(32) + word(1) + '61' + '00' * 30], 'TRUNCATED', 'DECODE-PAD-SHORT'),
        ('decode', ['string'], [word(32) + word(1) + '61' + '00' * 30 + '01'], 'NONZERO-PADDING', 'DECODE-PADDING'),
        ('decode', ['string', 'string'], [word(64) + word(64) + word(0)], 'INVALID-OFFSET', 'DECODE-ALIAS'),
        ('decode', ['string', 'string'], [word(96) + word(64) + word(0) + word(0)], 'INVALID-OFFSET', 'DECODE-ORDER'),
        ('decode', ['uint256'], [word(0) + '00'], 'TRAILING-DATA', 'DECODE-SUFFIX'),
        ('decode', ['string'], [word(32) + word(0) + word(0)], 'TRAILING-DATA', 'DECODE-SUFFIX'),
        ('decode', [], ['00'], 'TRAILING-DATA', 'DECODE-EMPTY-SUFFIX'),
    ])
    for typ, bits in [('uint8', 8), ('uint256', 256), ('address', 160)]:
        for n in [-1, 1 << bits]:
            rows.append(('encode', [typ], [str(n)], 'RANGE-' + typ, 'ENCODE-' + typ.upper() + '-RANGE'))
    return rows


def inspect(root, rows):
    for types, args, encoded in rows:
        require(call(root, 'encode', types, *args) == 'OK ' + encoded, 'ENCODE-BYTES')
        actual = call(root, 'decode', types, encoded)
        require(actual.startswith('OK ') and json.loads(actual[3:]) == args, 'DECODE-VALUES')
    for mode, types, args, error, label in negatives():
        require(call(root, mode, types, *args) == 'ERROR ' + error, label)


def reference(root):
    rows = {r['name']: r for r in json.loads((ROOT / 'reference/erc20/cases.json').read_text())}
    checks = [('read-name', 'string', 'Assay Test'.encode().hex()),
              ('read-symbol', 'string', 'ASY'.encode().hex()),
              ('read-decimals', 'uint8', '18'), ('read-totalSupply', 'uint256', '1000'),
              ('balance-alice', 'uint256', '900')]
    for name, typ, value in checks:
        encoded = rows[name]['output'].removeprefix('0x')
        require(call(root, 'encode', [typ], value) == 'OK ' + encoded, 'REFERENCE-ENCODE-' + name)
        require(json.loads(call(root, 'decode', [typ], encoded).removeprefix('OK ')) == [value],
                'REFERENCE-DECODE-' + name)
    return len(checks)


def draw(rng, typ):
    draws = {'uint8': lambda: str(rng.randrange(256)),
             'uint256': lambda: str(rng.getrandbits(256)),
             'address': lambda: str(rng.getrandbits(160)),
             'bool': lambda: rng.choice(['false', 'true']),
             'string': lambda: rng.randbytes(rng.randrange(40)).hex()}
    return draws[typ]()


def perturb(rng, types, data):
    """Apply exactly one perturbation to a valid encoding of the given types."""
    heads = [index * 32 for index, typ in enumerate(types) if typ == 'string']
    dynamic = heads + [int.from_bytes(data[head:head + 32], 'big') for head in heads]

    def flip():
        index = rng.randrange(len(data))
        return data[:index] + bytes([data[index] ^ rng.randrange(1, 256)]) + data[index + 1:]

    def overwrite():
        index = rng.choice(dynamic)
        return data[:index] + rng.getrandbits(256).to_bytes(32, 'big') + data[index + 32:]

    options = [(len(data) > 0, flip),
               (len(data) >= 32, lambda: data[:-32]),
               (True, lambda: data + bytes([rng.randrange(256)])),
               (True, lambda: data + bytes(32)),
               (bool(dynamic), overwrite)]
    return rng.choice([apply for viable, apply in options if viable])()


def malformed(root, rows):
    types, _, encoded = rows[22]
    require(types == ['uint8', 'string', 'address', 'bool', 'uint256', 'string'], 'PREFIX-FIXTURE')
    prefixes = len(encoded) // 2
    for length in range(prefixes):
        require(call(root, 'decode', types, encoded[:length * 2]).startswith('ERROR '), 'TRUNCATED-PREFIX')
    rng = random.Random(0xAB1)
    trials = 128
    accepted = 0
    for _ in range(trials):
        types = rng.choices(['uint8', 'uint256', 'address', 'bool', 'string'], k=rng.randrange(6))
        encoded = call(root, 'encode', types, *[draw(rng, typ) for typ in types])
        require(encoded.startswith('OK '), 'FUZZ-ENCODE')
        data = bytes.fromhex(encoded[3:])
        wire = (perturb(rng, types, data) if rng.random() < 0.5 else data).hex()
        result = call(root, 'decode', types, wire)
        require(result.startswith(('OK ', 'ERROR ')), 'DECODE-RESULT')
        if result.startswith('OK '):
            require(call(root, 'encode', types, *json.loads(result[3:])) == 'OK ' + wire, 'CANONICAL-ROUNDTRIP')
            accepted += 1
    print('FUZZ trials=%d accepted=%d' % (trials, accepted), flush=True)
    require(accepted >= 32, 'FUZZ-ACCEPTED')
    return prefixes, trials


MUTANTS = native_mutations.load(__file__)


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    run(ROOT, sys.executable, '-P', 'dev/build.py', 'build', TARGET)
    rows, cast_count = fixtures()
    (WORK / 'vectors.json').write_text(json.dumps(rows, indent=2) + '\n')
    inspect(ROOT, rows)
    reference_count = reference(ROOT)
    prefixes, fuzz = malformed(ROOT, rows)
    source = (ROOT / 'src/abi.bend').read_text()
    killed = 0
    for name, old, new, witness in MUTANTS:
        require(native_mutations.count(source, old) == 1, 'MUTANT-PATTERN ' + name)
        with tempfile.TemporaryDirectory(prefix='assay-codec-') as temporary:
            work = Path(temporary) / "copy"
            native_mutations.copy_project(ROOT, work)
            (work / 'src/abi.bend').write_text(native_mutations.replace(source, old, new))
            run(work, sys.executable, '-P', 'dev/build.py', 'build', TARGET)
            try:
                inspect(work, rows)
            except ValueError as error:
                require(str(error) == witness, 'MUTANT-WITNESS ' + name + ': ' + str(error))
            else:
                raise ValueError('MUTANT-SURVIVED ' + name)
            (WORK / (name + '.log')).write_text('killed witness=' + witness + '\n')
            print('ABI-CODEC-MUTANT ' + name + ' killed witness=' + witness, flush=True)
            killed += 1
    inspect(ROOT, rows)
    print('ABI-CODEC cast=%d vectors=%d reference=%d negative=%d prefixes=%d fuzz=%d mutants=%d scope=codec OK'
          % (cast_count, len(rows), reference_count, len(negatives()), prefixes, fuzz, killed))


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError, subprocess.TimeoutExpired) as error:
        print('ABI-CODEC FAIL ' + str(error))
        raise SystemExit(1)

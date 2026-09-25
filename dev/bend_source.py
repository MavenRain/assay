"""Read Bend declarations and derive forward signatures for source modules.

The bundle contains the source bodies verbatim. Forward signatures only let
independent files refer to each other. Bend checks each declaration according
to its safety annotation; an @unsafe definition does not certify its body.
"""
from dataclasses import dataclass
import re


@dataclass(frozen=True)
class Declaration:
    kind: str
    name: str
    source: str
    path: str

    @property
    def key(self):
        return self.kind + ' ' + self.name


def declarations(text, path):
    lines = text.splitlines(keepends=True)
    starts = []
    for index, line in enumerate(lines):
        match = re.match(r'^(def|type|law) ([\w.]+)', line)
        if match:
            start = index - 1 if index and lines[index - 1].startswith('@') else index
            starts.append((start, match[1], match[2]))
    for index, (start, kind, name) in enumerate(starts):
        end = starts[index + 1][0] if index + 1 < len(starts) else len(lines)
        yield Declaration(kind, name, ''.join(lines[start:end]).rstrip() + '\n', str(path))


def split_parameters(text):
    parts = []
    depth = 0
    start = 0
    for index, char in enumerate(text):
        if char in '(<[{':
            depth += 1
        elif char in ')>]}':
            # Function arrows contain > without opening a type argument.
            if char != '>' or index == 0 or text[index - 1] != '-':
                depth -= 1
        elif char == ',' and depth == 0:
            parts.append(text[start:index].strip())
            start = index + 1
    if text[start:].strip():
        parts.append(text[start:].strip())
    return parts


def signature(declaration):
    line = next(line for line in declaration.source.splitlines() if line.startswith('def '))
    start = line.index('(')
    depth = 1
    end = start + 1
    while depth:
        if line[end] == '(':
            depth += 1
        elif line[end] == ')':
            depth -= 1
        end += 1
    parameters = split_parameters(line[start + 1:end - 1])
    rest = line[end:]
    if not rest.startswith(' -> '):
        return parameters, None, line[:end]
    result, separator, _body = rest[4:].partition(':')
    if not separator:
        raise ValueError(f'{declaration.path}: missing return type for {declaration.name}')
    return parameters, result.strip(), line[:end] + ' -> ' + result + ':'


def identifiers(text):
    code = re.sub(r'"(?:\\.|[^"\\])*"|\x27(?:\\.|[^\x27\\])*\x27|#[^\n]*', '', text)
    return set(re.findall(r'(?<![\w.])[A-Za-z_][\w.]*', code))


def reachable(records, entry):
    """Keep the entry's declarations, signatures, datatypes, and constructors."""
    by_name = {}
    constructors = {}
    for record in records:
        by_name.setdefault(record.name, []).append(record)
        if record.kind == 'type':
            code = re.sub(r'"(?:\\.|[^"\\])*"|#[^\n]*', '', record.source)
            for constructor in re.findall(r'(?<![\w.])([A-Za-z_][\w.]*)\s*\{', code):
                constructors[constructor] = record.name
    needed = set()
    pending = [entry]
    while pending:
        name = pending.pop()
        owner = constructors.get(name)
        if owner is not None and owner != name:
            pending.append(owner)
        if name in needed or name not in by_name:
            continue
        needed.add(name)
        for record in by_name[name]:
            pending.extend(identifiers(record.source) - needed)
            for monad in re.findall(r'\bdo\s+([\w.]+)\s*<', record.source):
                pending.extend((monad + '.bind', monad + '.pure'))
    if entry not in needed:
        raise ValueError('missing entry declaration: ' + entry)
    return [record for record in records if record.name in needed]


def type_dependencies(record):
    text = record.source
    if record.kind == 'type':
        text = re.sub(r'^\s+[\w.]+\{', '{', text, flags=re.M)
    return identifiers(text)


def bundle(records, entry):
    records = list(records)
    by_key = {}
    for record in records:
        if record.key in by_key:
            raise ValueError(f'duplicate declaration {record.key}')
        by_key[record.key] = record
    prelude = {}
    functions = []
    laws = {r.name: r for r in records if r.kind == 'law'}
    for record in records:
        if record.kind == 'type':
            prelude[record.name] = record
        elif record.kind == 'def':
            _parameters, result, _header = signature(record)
            if result in ('Data', 'Type', 'Quant'):
                prelude[record.name] = record
            else:
                functions.append(record)
    output = ['import Base\n']
    emitted = set()
    while len(emitted) < len(prelude):
        ready = [r for name, r in prelude.items() if name not in emitted and not ((type_dependencies(r) & prelude.keys()) - emitted - {name})]
        if not ready:
            raise ValueError('cyclic type declarations: ' + ', '.join(prelude.keys() - emitted))
        for record in ready:
            output.append(record.source)
            emitted.add(record.name)
    function_map = {record.name: record for record in functions}
    ordered = []
    pending = dict(function_map)
    dependencies = {name: (identifiers(record.source) & function_map.keys()) - {name} for name, record in pending.items()}
    while pending:
        ready = [record for name, record in pending.items() if not dependencies[name] & pending.keys()]
        if not ready:
            # Only explicitly unsafe source bodies can cross a recursion cycle.
            ready = [record for record in pending.values() if record.source.startswith('@unsafe\n')][:1]
            if not ready:
                raise ValueError('recursive functions require explicit @unsafe in their source')
        for record in ready:
            ordered.append(record)
            del pending[record.name]
    bodies = []
    for record in ordered:
        parameters, result, header = signature(record)
        if record.name in laws:
            output.append(laws[record.name].source)
        elif result is not None:
            typed = [p if ':' in p else '-' + p + ': Quant' for p in parameters]
            output.append('law ' + record.name + ': ' + ''.join('for ' + p + ' ' for p in typed) + result + '\n')
        else:
            raise ValueError(f'{record.path}: untyped function {record.name}')
        names = [p.split(':', 1)[0].strip().lstrip('+-~') for p in parameters]
        short = 'def ' + record.name + '(' + ', '.join(names) + ')'
        # An existing law already has a short definition header.
        replacement = short + ':' if result is not None else short
        bodies.append(record.source.replace(header, replacement, 1))
    output.extend(bodies)
    output.append('def main() -> IO(Unit): ' + entry + '()\n')
    return '\n'.join(output)

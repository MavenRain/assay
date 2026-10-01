#!/usr/bin/env python3
"""Resume the unchanged lexer suite's completed compile prefix after a timeout."""
from pathlib import Path
import hashlib
import importlib.util
import json
import sys

ROOT = Path('/Users/oobi/Documents/gpt1/assay-segment-direct')
sys.path.insert(0, str(ROOT / 'dev'))
spec = importlib.util.spec_from_file_location('lexer_direct', ROOT / 'dev/lexer-direct-test.py')
suite = importlib.util.module_from_spec(spec)
spec.loader.exec_module(suite)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    # In run-V7XpGZ, execution reached the input mutant's compiler call.
    # These four earlier calls therefore completed, including their runtime checks.
    names = ('before', 'after', 'mutant-digits', 'mutant-identifier')
    compiler = suite.build.compiler()
    compiler_sha = sha(compiler)
    frozen = {}
    for name in names:
        source = suite.WORK / (name + '.bend')
        output = suite.WORK / (name + '.js')
        launcher = suite.WORK / name
        if not all(path.is_file() for path in (source, output, launcher)):
            raise ValueError('completed compile prefix is missing: ' + name)
        frozen[name] = dict(source_sha256=sha(source), output_sha256=sha(output),
                            launcher_sha256=sha(launcher), compiler_sha256=compiler_sha)
    original = suite.compile_adapter
    reused = []

    def compile_adapter(records, entry, name):
        if name not in frozen:
            return original(records, entry, name)
        source = suite.bundle(suite.reachable(records + list(suite.declarations(entry, '<lexer-direct-test>')),
                                             'LexerDirect.main'), 'LexerDirect.main')
        source = source.replace('import "./os.js"', 'import "../../src/os.js"')
        paths = {kind: suite.WORK / (name + suffix) for kind, suffix in
                 [('source', '.bend'), ('output', '.js'), ('launcher', '')]}
        if (paths['source'].read_text() != source or sha(compiler) != compiler_sha
                or any(sha(path) != frozen[name][kind + '_sha256'] for kind, path in paths.items())):
            raise ValueError('completed compile prefix changed: ' + name)
        reused.append(name)
        print('LEXER-RESUME reused=' + name, flush=True)
        return paths['launcher']

    suite.compile_adapter = compile_adapter
    receipt = ROOT / '_build/lexer-direct/resume-prefix.json'
    receipt.write_text(json.dumps(dict(capture='run-V7XpGZ', capture_exit=2,
                                       complete_prefix=frozen, fresh_compile_timeout_seconds=180), indent=2) + '\n')
    sys.argv = [str(ROOT / 'dev/lexer-direct-test.py')]
    suite.main()
    print('LEXER-RESUME complete reused=' + str(len(reused)), flush=True)


if __name__ == '__main__':
    main()

"""Pin lexer optimizations before comparing the rest of each historical CLI bundle.

Every listed declaration must match its digest and occur once in each input.
Restoring BASE bodies then leaves all other reachable CLI changes detectable.
"""
import hashlib
import json

from bend_source import bundle, reachable

PINS = {
    'Lexer.ident_kind': '885331fd55467b8d6691413941c9ef60b74d616ed023c9ce330db4f4a9be8c7d',
    'Lexer.nat_of_digits': 'a9b94145490a45c9f0f48a7ee185b6d5fb2f7f258b81aa8aebcc6285ed07fbb9',
    'Lexer.go': '62a383370952042300dba1d35d5a60ed1df8f1aa7c04f158bb9435b1aeae097c',
    'Lexer.lex': '2806175b462bcf9062a7c0468519bb0a2bf1ea84e9628b5827c30b769fd569b9',
}
# Reports identify the complete pin manifest, with a stable serialization.
SHA256 = hashlib.sha256(json.dumps(PINS, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def only(rows, name):
    matches = [row for row in rows if row.kind == 'def' and row.name == name]
    return matches[0] if len(matches) == 1 else None


def pinned(base_rows, work_rows):
    """Restore the pinned lexer bodies, or refuse missing, duplicate or modified bodies."""
    replacements = {}
    for name, digest in PINS.items():
        base, work = only(base_rows, name), only(work_rows, name)
        if base is None or work is None or hashlib.sha256(work.source.encode()).hexdigest() != digest:
            return None
        replacements[work.key] = base
    return [replacements.get(row.key, row) for row in work_rows]


def cli_sources(records, entry='Entry.Cli'):
    """Bundle BASE and pinned worktree rows. A failed pin gives None, which differs from each bundle."""
    rows = pinned(records[0], records[1])
    return [bundle(reachable(records[0], entry), entry),
            None if rows is None else bundle(reachable(rows, entry), entry)]

"""Pin the one permitted Entry.Cli change after the M2 compatibility bases.

The KEYWORD-DISPATCH slice replaces the Lexer.ident_kind body with a 30-case
string match and a catch-all. Before the CLI-BUNDLE compare, the worktree
Lexer.ident_kind record is replaced with the BASE record. Lexer.keywords is
then reachable again in the same way as at BASE. The worktree record must
equal the staged text exactly, so each other CLI change still fails the
compare.
"""
import hashlib

from bend_source import bundle, reachable

NAME = 'Lexer.ident_kind'
# SHA-256 of the staged src/frontend.bend Lexer.ident_kind declaration text,
# as bend_source.declarations extracts it (1191 bytes, 34 lines).
SHA256 = '885331fd55467b8d6691413941c9ef60b74d616ed023c9ce330db4f4a9be8c7d'


def only(rows):
    matches = [row for row in rows if row.kind == 'def' and row.name == NAME]
    return matches[0] if len(matches) == 1 else None


def pinned(base_rows, work_rows):
    """Return the worktree rows with the BASE ident_kind, or None if the pin fails."""
    base, work = only(base_rows), only(work_rows)
    good = (base is not None and work is not None
            and hashlib.sha256(work.source.encode()).hexdigest() == SHA256)
    return [base if row is work else row for row in work_rows] if good else None


def cli_sources(records, entry='Entry.Cli'):
    """Bundle BASE and pinned worktree rows. A failed pin gives None, which differs from each bundle."""
    rows = pinned(records[0], records[1])
    return [bundle(reachable(records[0], entry), entry),
            None if rows is None else bundle(reachable(rows, entry), entry)]

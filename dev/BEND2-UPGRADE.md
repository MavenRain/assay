# Bend 2.0.28

This slice pinned Bend 2.0.28 at
`bc178404f4778704fa5584a73fcdf72bcdf9f32c`, the upstream `v2.0.28` tag.
The current pin is in `dev/toolchain.json`; see [Bend 2.0.32](#bend-2032).
The compiler still emits JavaScript for the pinned Node runtime.

For a fresh checkout, run `python3 -P dev/bootstrap-bend.py`. To upgrade an
existing compiler checkout, run `python3 -P dev/bootstrap-bend.py --upgrade`.
The upgrade fetches the exact pin, checks out that revision without forcing,
verifies HEAD and rebuilds `bin/bend`. It refuses tracked local changes before
fetching or changing the checkout. Git refuses the checkout if it would
overwrite an untracked file. Git does not protect ignored files, such as files
in `.claude/` or `.tmp/`. Move them out of the checkout before an upgrade.
The fetch uses depth 1, so the upgraded checkout is shallow. `BEND` can still
select a separate checkout, whose HEAD must match the pin.
`python3 -P dev/bootstrap-control-test.py` runs the bootstrap with mocked Git
and Bun. It checks that an upgrade needs `--upgrade`, that tracked changes are
refused and that a clean upgrade fetches, checks out and builds the pin.
The frozen speed record pins the Makefile, so `make test` does not run this
check. Run it by hand after a change to `dev/bootstrap-bend.py`.

Bend 2.0.28 requires each JavaScript effect source to register its handlers
with `io_eff`. `src/os.js` registers all thirteen OS and argument handlers;
`src/test-os.js` registers the allocation probe. These sources use literal
qualified effect keys because individual Assay bundles can prune other
declarations from the same effect source. A `CID` reference to such a pruned
declaration fails compilation. The handlers retain byte strings and literal
argument vectors, and the generated runtime checks every reachable effect
registration before execution.

The live Bend corpus manifest and paired speed runner now pin 2.0.28.
Earlier measurement records retain their original compiler identities and
timings. The paired measurement protocol, Node pin and M4 ratio limit of 1.0
remain unchanged. See [M4-SPEED.md](M4-SPEED.md) for the deferred speed gate.

The same slice adds the [return-data commands](M2-RETURNDATA-CLI.md).
Validation evidence is recorded in
[the upgrade record](validation/2026-10-02-bend-upgrade-returndata-cli/README.md).

## Bend 2.0.32

`dev/toolchain.json` pins Bend 2.0.32 at
`573002f01ec6c52416d44489543f69a9625facf8`, the upstream `v2.0.32` tag.
The `io_eff` registration above is unchanged. The live Bend corpus manifest
and the paired speed runner stay on 2.0.28 until the next paired measurement.

# Frozen M0 corpus

`MANIFEST.json` pins eight contracts and three proof variants.  It records
the physical line count, SHA-256, expected return word, final storage and
the hashes of all five emitted files for each source.  Each file is a
complete module.  The repeated protocol declarations are part of the input
and count toward its size.  No comment padding is added for measurement.

The contract group covers the reference, a pure return, a zero write,
the maximum word, arithmetic, pair projection, two slots and two-byte
jump labels.  The zero write is witnessed by the frozen source hash, the
frozen runtime hash and the listing only.  The geth state dump omits a
slot whose value is zero, so `MANIFEST.json` records empty storage for
that case and the executed storage oracle compares two empty maps.  A
pinned store count for that case needs a new freeze of `MANIFEST.json`.
The proof group uses a leaf, application and let expression
as the erased argument.  These have distinct checked term shapes and
identical runtime and creation bytes.  All declarations are identical
across the proof group.  This is a small M0 seed, not an M2 proof suite.

The OCaml denominator is the 24-file, 6215-line kernel corpus used by the
Stage 0 spike.  Its files remain in `lib/` and are hash-pinned here.
The native and bytecode compilers compile those real OCaml inputs.  Assay
compiles the contract inputs.  The ratio compares wall time per kloc on
these distinct corpora; it does not claim equivalent compiler workloads.

Run `zsh -f dev/ratio.sh` to verify and report the frozen measurements.
Run `zsh -f dev/ratio.sh --measure NEW.json` after a build to collect a new
dated measurement without replacing the frozen run.  That command prints
no ratio.  A new freeze must update the source and measurement hashes
before a ratio is reported.  Do not compare measurements from different
corpus versions as a compiler speedup.

Regenerate the freeze from the repository root with one command, which
keeps the 74 paths of `dev/DENOMINATORS.sha256` and their order:
`shasum -a 256 $(awk '{print $2}' dev/DENOMINATORS.sha256) >
dev/DENOMINATORS.sha256.new && mv dev/DENOMINATORS.sha256.new
dev/DENOMINATORS.sha256`.  A change to `dev/ratio.py` also needs a fresh
`dev/denominators.json`, because RATIO-METHOD pins the digest of the
measurement script.

The method uses one warm run and five interleaved measured rounds in
less than one minute.  Each assay interval starts before process launch
and ends after emission closes the five output files.  File validation
and temporary-directory setup sit outside those intervals.  Each OCaml
interval includes one compiler process and all 24 sources in dependency
order, with outputs checked after timing.  All subprocesses must succeed.

`fixed_ms` measures one `spec-count` process, including R0 formatting.
It is an upper-bound proxy for startup, reported per invocation.  It is
not subtracted from any result.  The contract timing uses eight separate
processes.  The eight contract processes total 78.5 ms against eight
fixed-cost proxies of 10.07 ms each, so the measured interval is no
larger than the declared startup proxy and the ratio does not isolate
parse or emission work.  Proof timings use three and print separately.
The three proof processes total 31.2 ms against three proxies of
10.07 ms each.  Host load,
sample vectors, versions and complete commands are in the dated report.

The ratio is informational at M0.  M1 owns its performance threshold.
Gas figures are execution gas from geth under the explicit Cancun
fixture.  They exclude transaction intrinsic gas and deployment fees.

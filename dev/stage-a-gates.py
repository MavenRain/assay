#!/usr/bin/env python3
"""Run the carried battery and optional emission and executor legs with finite deadlines."""

from pathlib import Path
import shutil
import subprocess
import sys
import time


def main():
    root = Path(__file__).resolve().parent.parent
    if sys.argv[1:] not in ([], ["--keccak"], ["--asm"], ["--reference"], ["--emit"], ["--m0"], ["--m1-executor"], ["--m1-counter"], ["--m1-emission"], ["--m1-run"], ["--m1-surface"], ["--m1-proofs"], ["--m1-nullary"], ["--m1-errors"], ["--m1-guards"], ["--m1-proof-terms"], ["--m1-invariants"], ["--m1-proof-helpers"], ["--m1-proof-bundles"], ["--m1-predicates"], ["--m1-compound-invariants"], ["--m1-compound-guards"], ["--m1-named-guards"], ["--m1-inferred-guards"], ["--m1-inferred-arithmetic"], ["--m1-inferred-helpers"], ["--m1-proof-holes"], ["--m1-inferred-bindings"], ["--m1-inferred-guard-bindings"], ["--m1-context"], ["--m1-context-surface"], ["--m1-equality"], ["--m1-hex-literals"], ["--m1-inferred-words"], ["--m1-fallback"], ["--m1-diff-value"], ["--m1-trace-value"]):
        print("usage: stage-a-gates.py [--keccak|--asm|--reference|--emit|--m0|--m1-executor|--m1-counter|--m1-emission|--m1-run|--m1-surface|--m1-proofs|--m1-nullary|--m1-errors|--m1-guards|--m1-proof-terms|--m1-invariants|--m1-proof-helpers|--m1-proof-bundles|--m1-predicates|--m1-compound-invariants|--m1-compound-guards|--m1-named-guards|--m1-inferred-guards|--m1-inferred-arithmetic|--m1-inferred-helpers|--m1-proof-holes|--m1-inferred-bindings|--m1-inferred-guard-bindings|--m1-context|--m1-context-surface|--m1-equality|--m1-hex-literals|--m1-inferred-words|--m1-fallback|--m1-diff-value|--m1-trace-value]")
        return 64
    trace_value = sys.argv[1:] == ["--m1-trace-value"]
    diff_value = trace_value or sys.argv[1:] == ["--m1-diff-value"]
    fallback = diff_value or sys.argv[1:] == ["--m1-fallback"]
    inferred_words = fallback or sys.argv[1:] == ["--m1-inferred-words"]
    hex_literals = inferred_words or sys.argv[1:] == ["--m1-hex-literals"]
    equality = hex_literals or sys.argv[1:] == ["--m1-equality"]
    context_surface = equality or sys.argv[1:] == ["--m1-context-surface"]
    context = context_surface or sys.argv[1:] == ["--m1-context"]
    inferred_guard_bindings = context or sys.argv[1:] == ["--m1-inferred-guard-bindings"]
    inferred_bindings = inferred_guard_bindings or sys.argv[1:] == ["--m1-inferred-bindings"]
    proof_holes = inferred_bindings or sys.argv[1:] == ["--m1-proof-holes"]
    inferred_helpers = proof_holes or sys.argv[1:] == ["--m1-inferred-helpers"]
    inferred_arithmetic = inferred_helpers or sys.argv[1:] == ["--m1-inferred-arithmetic"]
    inferred_guards = inferred_arithmetic or sys.argv[1:] == ["--m1-inferred-guards"]
    named_guards = inferred_guards or sys.argv[1:] == ["--m1-named-guards"]
    compound_guards = named_guards or sys.argv[1:] == ["--m1-compound-guards"]
    compound = compound_guards or sys.argv[1:] == ["--m1-compound-invariants"]
    predicates = compound or sys.argv[1:] == ["--m1-predicates"]
    bundles = predicates or sys.argv[1:] == ["--m1-proof-bundles"]
    helpers = bundles or sys.argv[1:] == ["--m1-proof-helpers"]
    invariants = helpers or sys.argv[1:] == ["--m1-invariants"]
    proof_terms = invariants or sys.argv[1:] == ["--m1-proof-terms"]
    guards = proof_terms or sys.argv[1:] == ["--m1-guards"]
    errors = guards or sys.argv[1:] == ["--m1-errors"]
    nullary = errors or sys.argv[1:] == ["--m1-nullary"]
    proofs = nullary or sys.argv[1:] == ["--m1-proofs"]
    surface = proofs or sys.argv[1:] == ["--m1-surface"]
    model = surface or sys.argv[1:] == ["--m1-run"]
    m1_emission = model or sys.argv[1:] == ["--m1-emission"]
    counter = m1_emission or sys.argv[1:] == ["--m1-counter"]
    executor = counter or sys.argv[1:] == ["--m1-executor"]
    corpus = executor or sys.argv[1:] == ["--m0"]
    emission = corpus or sys.argv[1:] == ["--emit"]
    reference = emission or sys.argv[1:] == ["--reference"]
    assembler = reference or sys.argv[1:] == ["--asm"]
    keccak = assembler or sys.argv[1:] == ["--keccak"]
    legs = [
        ("BUILD", 120, ("zsh", "-f", "dev/dunecho.sh", "build"), "0 errors, 0 warnings"),
        ("PIN-CARRY", 30, ("zsh", "-f", "dev/carry-check.sh"), "diff=0 unlisted=0"),
        ("R0-COUNT", 10, ("zsh", "-f", "dev/r0-count.sh"), "R0-COUNT OK"),
        ("R0-AUDIT", 10, ("zsh", "-f", "dev/r0-audit.sh"), "R0-AUDIT OK"),
        ("HOUSE", 30, ("zsh", "-f", "dev/house.sh"), "HOUSE OK"),
        ("TRUSTED-LINES", 10, ("zsh", "-f", "dev/trusted-lines.sh"), "TRUSTED-LINES OK"),
        ("SUITE-KERNEL", 300, ("_build/default/test/main.exe", "test"), "SUITE-KERNEL OK"),
        ("SUITE-SURFACE", 60, ("_build/default/test/sl_surface.exe",), "SL-SURFACE OK"),
        ("DRIVER", 30, ("python3", "-P", "dev/stage-a-test.py", "driver"), "DRIVER cases=24 OK"),
        # The 13 subprocess-based checks exceed two minutes under host load 80+.
        ("MUTANTS", 300, ("python3", "-P", "dev/stage-a-test.py", "mutants"), "MUTANTS killed=13/13 OK"),
        ("DENOMINATORS", 10, ("shasum", "-a", "256", "-c", "dev/DENOMINATORS.sha256"), "dev/denominators.json: OK"),
    ]
    if keccak:
        legs.extend([
            ("KECCAK-VEC", 120, ("python3", "-P", "dev/keccak-test.py", "vectors"), "KECCAK-VEC vectors=35 ok=35 adapter=5 OK"),
            ("KECCAK-MUTANTS", 660, ("python3", "-P", "dev/keccak-test.py", "mutants"), "KECCAK-MUTANTS killed=4/4 control=OK"),
        ])
    if assembler:
        legs.extend([
            ("STACK-HEIGHT", 240, ("python3", "-P", "dev/asm-test.py", "stack"),
             "STACK-HEIGHT blocks=30 cases=64 opcodes=149 effect_cases=370 OK"),
            ("DISASM-3WAY", 120, ("python3", "-P", "dev/asm-test.py", "disasm"),
             "DISASM-3WAY ours=272 cast=272 evm=272 fixtures=7 negative=38 OK"),
            ("ASM-MUTANTS", 1200, ("python3", "-P", "dev/asm-test.py", "mutants"), "ASM-MUTANTS killed=6/6 control=OK"),
        ])
    if reference:
        legs.extend([
            ("FORK-DRIFT", 120, ("zsh", "-f", "dev/fork-check.sh"),
             "FORK-DRIFT push0=OK tload=OK tstore=OK mcopy=OK clz=INVALID OK"),
            ("M0-TRACE", 120, ("python3", "-P", "dev/reference-test.py", "trace"),
             "M0-TRACE scope=reference bytes=20 listing=17 cast=17 evm=13 skipped=4 storage=42 return=42 OK"),
            ("CREATE-EQ", 120, ("python3", "-P", "dev/reference-test.py", "create"),
             "CREATE-EQ bytes=20 returned=20 installed=1 OK"),
            ("REFERENCE-CHECKS", 180, ("python3", "-P", "dev/reference-test.py", "checks"),
             "REFERENCE-CHECKS cases=32 controls=2 OK"),
            ("REFERENCE-MUTANTS", 1200, ("python3", "-P", "dev/reference-test.py", "mutants"),
             "REFERENCE-MUTANTS killed=8/8 controls=3 OK"),
        ])
    if emission:
        legs.extend([
            ("EMIT-CONSTRUCTORS", 30, ("_build/default/test/emit_cases.exe", "constructors"),
             "EMIT-CONSTRUCTORS cases=22 OK"),
            ("WORD-UNBOX", 30, ("_build/default/test/emit_cases.exe", "words"),
             "WORD-UNBOX ktag=0 kstruct=0 words=3 cases=9 OK"),
            ("STORAGE-NOCLOS", 30, ("_build/default/test/emit_cases.exe", "storage"),
             "STORAGE-NOCLOS kclos=0 ktail=0 fields=2 cases=9 OK"),
            ("ABI-GOLD", 60, ("zsh", "-f", "dev/abi-gold.sh"),
             "ABI-GOLD jq_sorted=equal provenance=dev/ABI-PROVENANCE.md controls=4 OK"),
            ("EMITTED-TRACE", 120, ("python3", "-P", "dev/emit-test.py", "trace"),
             "M0-TRACE offsets=13 listing=17 cast=17 evm=13 five_files=5 OK" if corpus else
             "M0-TRACE scope=emitted bytes=20 listing=17 cast=17 evm=13 skipped=4 storage=42 return=42 OK"),
            ("EMIT-SOURCES", 600, ("python3", "-P", "dev/emit-test.py", "sources"),
             "EMIT-SOURCES success=15 refusal=9 driver=3 OK"),
            ("EMIT-MUTANTS", 1200, ("python3", "-P", "dev/emit-test.py", "mutants"),
             "EMIT-MUTANTS killed=7/7 controls=4 OK"),
            ("AXIOMS", 480, ("python3", "-P", "dev/proofs-test.py"),
             "AXIOMS sorryAx=0 theorems=42 carried_files=28 controls=3 OK"),
        ])
    if corpus:
        legs.extend([
            ("TRACE-DRIVER", 120, ("python3", "-P", "dev/trace-test.py"),
             "TRACE-DRIVER cases=20 explicit_prestate=true literal_argv=true OK"),
            ("CORPUS", 600, ("python3", "-P", "dev/corpus-test.py", "corpus"),
             "CORPUS cases=11 five_files=5 OK"),
            ("ERASED-BYTES", 120, ("python3", "-P", "dev/corpus-test.py", "erased"),
             "ERASED-BYTES mutants=2 caught=1 equal=2 scope=M0-seed OK"),
            ("M0-RATIO", 60, ("zsh", "-f", "dev/ratio.sh"),
             "M0-RATIO provenance=dev/denominators.json fixed=spec-count-proxy subtraction=none OK"),
            ("F-MUTANTS", 180, ("python3", "-P", "dev/corpus-test.py", "mutants"),
             "F-MUTANTS killed=7/7 controls=5 OK"),
        ])
    if executor:
        legs.append(("DIFF-EXECUTOR", 180, ("python3", "-P", "dev/diff-test.py"),
                     "DIFF-EXECUTOR live=20 driver=28 rejected=24 OK"))
    if counter:
        legs.append(("COUNTER-REFERENCE", 300, ("python3", "-P", "dev/counter-test.py"),
                     "COUNTER-REFERENCE cases=30 creates=2 mutants=8 value_rejected=5 covered=120 scope=reference OK"))
    if m1_emission:
        legs.append(("M1-EMISSION", 600, ("python3", "-P", "dev/m1-emit-test.py"),
                     "M1-EMISSION counter=30 sources=8 refusals=11 mutants=8 OK"))
    if model:
        legs.append(("SOURCE-MODEL", 600, ("python3", "-P", "dev/model-test.py"),
                     "SOURCE-MODEL counter=30 variants=10 corpus=11 invalid=28 refusals=6 mutants=8 OK"))
    if surface:
        legs.append(("CONTRACT-SURFACE", 600, ("python3", "-P", "dev/contract-test.py"),
                     "CONTRACT-SURFACE counter=30 variants=14 refusals=36 mutants=8 OK"))
    if proofs:
        legs.extend([
            ("CONTRACT-ROUTE", 30, ("_build/default/test/contract_route.exe",), "bound=131072 OK"),
            ("SOURCE-PROOFS", 600, ("python3", "-P", "dev/source-proof-test.py"),
             "SOURCE-PROOFS theorems=11 arithmetic=226 evm=16 recovery=6 effects=7 invalid=13 mutants=6 controls=4 OK"),
        ])
    if nullary:
        legs.append(("NULLARY-ENTRIES", 600, ("python3", "-P", "dev/nullary-test.py"),
                     "NULLARY-ENTRIES cases=53 creates=2 refusals=4 mutants=3 OK"))
    if errors:
        legs.append(("CUSTOM-ERRORS", 600, ("python3", "-P", "dev/errors-test.py"),
                     "CUSTOM-ERRORS cases=66 creates=2 refusals=26 mutants=5 OK"))
    if guards:
        legs.append(("PROOF-GUARDS", 600, ("python3", "-P", "dev/guard-test.py"),
                     "PROOF-GUARDS cases=83 creates=2 refusals=26 erasure=3 mutants=6 OK"))
    if proof_terms:
        legs.append(("PROOF-TERMS", 600, ("python3", "-P", "dev/proof-term-test.py"),
                     "PROOF-TERMS cases=98 creates=2 refusals=25 erasure=5 mutants=4 OK"))
    if invariants:
        legs.append(("INVARIANTS", 600, ("python3", "-P", "dev/invariant-test.py"),
                     "INVARIANTS cases=52 creates=2 refusals=30 erasure=4 mutants=4 OK"))
    if helpers:
        legs.append(("PROOF-HELPERS", 600, ("python3", "-P", "dev/proof-helper-test.py"),
                     "PROOF-HELPERS cases=104 creates=2 refusals=50 erasure=7 mutants=4 OK"))
    if bundles:
        legs.append(("PROOF-BUNDLES", 600, ("python3", "-P", "dev/proof-bundle-test.py"),
                     "PROOF-BUNDLES cases=102 creates=2 refusals=41 erasure=8 boundaries=11 mutants=4 OK"))
    if predicates:
        legs.append(("PREDICATES", 600, ("python3", "-P", "dev/predicate-test.py"),
                     "PREDICATES cases=72 creates=2 refusals=44 erasure=7 boundaries=12 mutants=4 OK"))
    if compound:
        legs.append(("COMPOUND-INVARIANTS", 600, ("python3", "-P", "dev/compound-invariant-test.py"),
                     "COMPOUND-INVARIANTS cases=64 creates=2 refusals=24 erasure=8 boundaries=10 mutants=4 OK"))
    if compound_guards:
        legs.append(("COMPOUND-GUARDS", 600, ("python3", "-P", "dev/compound-guard-test.py"),
                     "COMPOUND-GUARDS cases=88 creates=2 refusals=26 erasure=7 boundaries=7 mutants=4 OK"))
    if named_guards:
        legs.append(("NAMED-GUARDS", 600, ("python3", "-P", "dev/named-guard-test.py"),
                     "NAMED-GUARDS cases=96 creates=2 refusals=27 erasure=10 boundaries=6 mutants=4 OK"))
    if inferred_guards:
        legs.append(("INFERRED-GUARDS", 600, ("python3", "-P", "dev/inferred-guard-test.py"),
                     "INFERRED-GUARDS cases=112 creates=2 refusals=24 erasure_pairs=14 boundaries=6 mutants=4 OK"))
    if inferred_arithmetic:
        legs.append(("INFERRED-ARITHMETIC", 600, ("python3", "-P", "dev/inferred-arithmetic-test.py"),
                     "INFERRED-ARITHMETIC cases=158 creates=2 refusals=24 erasure_pairs=16 mutants=4 OK"))
    if inferred_helpers:
        legs.append(("INFERRED-HELPERS", 600, ("python3", "-P", "dev/inferred-helper-test.py"),
                     "INFERRED-HELPERS cases=254 creates=2 refusals=26 erasure_pairs=24 boundaries=6 mutants=5 OK"))
    if proof_holes:
        legs.append(("PROOF-HOLES", 600, ("python3", "-P", "dev/proof-hole-test.py"),
                     "PROOF-HOLES cases=242 creates=2 refusals=25 erasure_pairs=23 boundaries=6 mutants=4 OK"))
    if inferred_bindings:
        legs.append(("INFERRED-BINDINGS", 600, ("python3", "-P", "dev/inferred-binding-test.py"),
                     "INFERRED-BINDINGS cases=229 creates=2 refusals=25 erasure_pairs=21 boundaries=6 mutants=6 OK"))
    if inferred_guard_bindings:
        legs.append(("INFERRED-GUARD-BINDINGS", 600, ("python3", "-P", "dev/inferred-guard-binding-test.py"),
                     "INFERRED-GUARD-BINDINGS cases=160 creates=2 refusals=27 erasure_pairs=20 boundaries=4 mutants=4 OK"))
    if context:
        legs.append(("EVM-CONTEXT", 600, ("python3", "-P", "dev/context-test.py"),
                     "EVM-CONTEXT cases=224 signed=56 creates=64 refusals=7 inputs=7 nested=2 independent=6 mutants=6 OK"))
    if context_surface:
        legs.append(("SURFACE-CONTEXT", 600, ("python3", "-P", "dev/context-surface-test.py"),
                     "SURFACE-CONTEXT cases=224 signed=56 creates=64 pairs=8 composition=6 order=4 refusals=17 mutants=4 OK"))
    if equality:
        legs.append(("WORD-EQUALITY", 600, ("python3", "-P", "dev/equality-test.py"),
                     "EQUALITY pairs=8 cases=53 signed=33 creates=8 boundaries=6 refusals=17 mutants=4 OK"))
    if hex_literals:
        legs.append(("HEX-LITERALS", 600, ("python3", "-P", "dev/hex-literals-test.py"),
                     "HEX-LITERALS pairs=30 cases=46 signed=25 creates=23 refusals=23 mutants=4 OK"))
    if inferred_words:
        legs.append(("INFERRED-WORDS", 600, ("python3", "-P", "dev/inferred-word-test.py"),
                     "INFERRED-WORDS pairs=21 cases=40 signed=40 refusals=19 boundaries=2 mutants=4 OK"))
    if fallback:
        legs.append(("FALLBACK", 600, ("python3", "-P", "dev/fallback-test.py"),
                     "FALLBACK cases=99 signed=99 creates=10 refusals=23 boundaries=2 mutants=6 OK"))
    if diff_value:
        legs.append(("DIFF-VALUE", 180, ("python3", "-P", "dev/diff-value-test.py"),
                     "DIFF-VALUE live=32 signed=32 refused=31 OK"))
    if trace_value:
        legs.append(("TRACE-VALUE", 180, ("python3", "-P", "dev/trace-value-test.py"),
                     "TRACE-VALUE live=36 funding=2 refused=34 OK"))
    # Review round 2026-09-11 (D-1):  the M0 verdict reads the legs of
    # M0-PLAN section 8 only.  A leg that this mode appends is an M1 leg,
    # so its failure moves the stage line and the exit code, not M0.
    m1_names = {"DIFF-EXECUTOR", "COUNTER-REFERENCE", "M1-EMISSION", "SOURCE-MODEL", "CONTRACT-SURFACE", "CONTRACT-ROUTE", "SOURCE-PROOFS", "NULLARY-ENTRIES", "CUSTOM-ERRORS", "PROOF-GUARDS", "PROOF-TERMS", "INVARIANTS", "PROOF-HELPERS", "PROOF-BUNDLES", "PREDICATES", "COMPOUND-INVARIANTS", "COMPOUND-GUARDS", "NAMED-GUARDS", "INFERRED-GUARDS", "INFERRED-ARITHMETIC", "INFERRED-HELPERS"}
    stage = "M1-INFERRED-HELPERS" if inferred_helpers else "M1-INFERRED-ARITHMETIC" if inferred_arithmetic else "M1-INFERRED-GUARDS" if inferred_guards else "M1-NAMED-GUARDS" if named_guards else "M1-COMPOUND-GUARDS" if compound_guards else "M1-COMPOUND-INVARIANTS" if compound else "M1-PREDICATES" if predicates else "M1-PROOF-BUNDLES" if bundles else "M1-PROOF-HELPERS" if helpers else "M1-INVARIANTS" if invariants else "M1-PROOF-TERMS" if proof_terms else "M1-GUARDS" if guards else "M1-ERRORS" if errors else "M1-NULLARY" if nullary else "M1-PROOFS" if proofs else "M1-SURFACE" if surface else "M1-RUN" if model else "M1-EMISSION" if m1_emission else "M1-COUNTER" if counter else "M1-EXECUTOR" if executor else "F" if corpus else "E" if emission else "D" if reference else "C" if assembler else "B" if keccak else "A"
    if proof_holes:
        stage = "M1-PROOF-HOLES"
        m1_names.add("PROOF-HOLES")
    if inferred_bindings:
        stage = "M1-INFERRED-BINDINGS"
        m1_names.add("INFERRED-BINDINGS")
    if inferred_guard_bindings:
        stage = "M1-INFERRED-GUARD-BINDINGS"
        m1_names.add("INFERRED-GUARD-BINDINGS")
    if context:
        stage = "M1-CONTEXT"
        m1_names.add("EVM-CONTEXT")
    if context_surface:
        stage = "M1-CONTEXT-SURFACE"
        m1_names.add("SURFACE-CONTEXT")
    if equality:
        stage = "M1-EQUALITY"
        m1_names.add("WORD-EQUALITY")
    if hex_literals:
        stage = "M1-HEX-LITERALS"
        m1_names.add("HEX-LITERALS")
    if inferred_words:
        stage = "M1-INFERRED-WORDS"
        m1_names.add("INFERRED-WORDS")
    if fallback:
        stage = "M1-FALLBACK"
        m1_names.add("FALLBACK")
    if diff_value:
        stage = "M1-DIFF-VALUE"
        m1_names.add("DIFF-VALUE")
    if trace_value:
        stage = "M1-TRACE-VALUE"
        m1_names.add("TRACE-VALUE")
    work = root / (".gatework/stage-" + stage.lower())
    work.mkdir(parents=True, exist_ok=True)
    failed = False
    failed_m1 = False
    for name, timeout, command, marker in legs:
        start = time.monotonic()
        try:
            result = subprocess.run(command, cwd=root,
                                    capture_output=True, text=True, timeout=timeout)
            output = result.stdout + result.stderr
            # Review round 2026-09-10 (A-3):  the ladder reads the host itself.
            # The leg no longer decides that it may be skipped:  the SKIP line
            # of plan correction 5 is honored only where elan is absent.
            skip_allowed = shutil.which("elan") is None
            declared_skip = (name == "AXIOMS" and skip_allowed
                             and "AXIOMS SKIP elan absent carried_files=28" in output)
            good = result.returncode == 0 and (marker in output or declared_skip)
            if name == "AXIOMS":
                # The leg log records which of the two sanctioned paths the host
                # allows, so a SKIP line can be read against the host that ran.
                output = output + "AXIOMS-HOST " + ("elan absent, skip allowed"
                                                    if skip_allowed else "elan present, skip refused") + "\n"
            code = result.returncode
        except (OSError, subprocess.TimeoutExpired) as error:
            # Review round 2026-09-10 (B-1):  TimeoutExpired carries the output
            # the killed leg had already produced.  Keep it, so the leg log
            # names the case that hung instead of holding one exception line.
            streams = (getattr(error, "stdout", None), getattr(error, "stderr", None))
            partial = "".join(text if isinstance(text, str) else text.decode("utf-8", "replace")
                              for text in streams if text)
            output, good, code = partial + str(error) + "\n", False, 1
        (work / (name + ".log")).write_text(output)
        print(f"{'PASS' if good else 'FAIL'} {name} exit={code} elapsed_ms={(time.monotonic() - start) * 1000:.1f}", flush=True)
        if not good:
            print(output, flush=True)
            failed_m1 = failed_m1 or name in m1_names
            failed = failed or name not in m1_names
            if name == "BUILD":
                break
    pending = ("F: frozen corpus, ratio and ERASED-BYTES seed" if emission
               else "E-F: EVM emission, five output files, recognizers, proof seed and corpus measurements" if reference
               else "D-F: Cancun reference, EVM emission and corpus measurements" if assembler
               else "C-F: assembler, Cancun reference, EVM emission and corpus measurements" if keccak
               else "B-F: keccak, assembler, Cancun reference, EVM emission and corpus measurements")
    if corpus:
        print("M0-VALIDATION " + ("FAIL" if failed else "OK") + "; M0-EXIT requires the user commit and ratification")
    else:
        print("PENDING " + pending)
    print("STAGE-" + stage + " " + ("FAIL" if failed or failed_m1 else "OK"))
    return int(failed or failed_m1)


if __name__ == "__main__":
    sys.exit(main())

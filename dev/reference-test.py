#!/usr/bin/env python3
"""Stage D reference execution under an explicit geth Cancun prestate."""

from pathlib import Path
import copy
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_mutations

RUNTIME = "602a5f55600b56fefefefe5b5f545f5260205ff3"
RECEIVER = "0x0000000000000000000000007265636569766572"
SENDER = "0x000000000000000000000000000073656e646572"
GAS = 16777216
TRACE_PCS = [0, 2, 3, 4, 6, 11, 12, 13, 14, 15, 16, 18, 19]
TRACE_STACKS = [[], [42], [42, 0], [], [11], [], [], [0], [42], [42, 0], [], [32], [32, 0]]
# Review round 2026-09-10 (B-3):  the inner budgets are shares of the leg
# deadlines in dev/stage-a-gates.py, so an inner hang is reported by its own
# named check before the outer leg deadline discards the transcript.
# REFERENCE-CHECKS runs 10 oracle calls under 180 s, FORK-DRIFT runs 8 under
# 120 s:  10 * 12 = 120 and 8 * 12 = 96.  REFERENCE-MUTANTS runs 8 mutant
# clones and 3 restored controls under 1200 s:  11 * 100 = 1100, and the two
# in-mutation plain controls fit in the remainder.
ORACLE_TIMEOUT = 12
CLONE_TIMEOUT = 100
ARTIFACT = "_build/test/asm_cases"


class GateError(ValueError):
    def __init__(self, code, detail):
        super().__init__(f"{code} {detail}")
        self.code = code


def require(condition, code, detail):
    if not condition:
        raise GateError(code, detail)


def unique_object(pairs):
    result = {}
    for name, value in pairs:
        require(name not in result, "JSON-DUPLICATE", name)
        result[name] = value
    return result


def objects(text):
    """Read trace JSON values and the final multiline state dump, in order."""
    decoder = json.JSONDecoder(object_pairs_hook=unique_object)
    result = []
    text = text.lstrip()
    while text:
        value, end = decoder.raw_decode(text)
        require(isinstance(value, dict), "JSON-SHAPE", "expected an object")
        result.append(value)
        text = text[end:].lstrip()
    return result


def run(root, name, *args):
    result = subprocess.run(args, cwd=root, capture_output=True, text=True, timeout=ORACLE_TIMEOUT)
    folder = root / ".gatework/reference"
    folder.mkdir(parents=True, exist_ok=True)
    receipt = dict(argv=list(args), exit=result.returncode, stdout=result.stdout, stderr=result.stderr)
    (folder / (name + ".json")).write_text(json.dumps(receipt, indent=2) + "\n")
    require(result.returncode == 0 and not result.stderr, "TOOL",
            f"{name} exit={result.returncode} stderr={result.stderr.strip()}")
    return result.stdout


def execute(root, name, code, *, create=False, plain=False):
    # All executions, including controls, name a prestate.  No default fork.
    prestate = root / "evm/fixtures/cancun.json"
    require(prestate.is_file(), "PRESTATE", "missing evm/fixtures/cancun.json")
    args = ["evm", "--verbosity", "0", "run", "--prestate", str(prestate),
            "--gas", str(GAS), "--sender", SENDER, "--receiver", RECEIVER, "--code", code]
    if not plain:
        args += ["--json", "--dump"]
    if create:
        args += ["--create"]
    output = run(root, name, *args)
    return output if plain else objects(output)


def split_execution(records):
    require(len(records) >= 3, "TRACE-SHAPE", "missing steps, summary or state")
    steps, summary, state = records[:-2], records[-2], records[-1]
    require(all("pc" in row and "op" in row and "opName" in row and "output" not in row
                and type(row.get("pc")) is int and type(row.get("op")) is int
                and row.get("depth") == 1 and isinstance(row.get("stack"), list) for row in steps),
            "TRACE-SHAPE", "invalid step or record ordering")
    require("output" in summary and "gasUsed" in summary and "pc" not in summary,
            "TRACE-SHAPE", "missing execution summary")
    require(isinstance(state.get("accounts"), dict) and "output" not in state,
            "TRACE-SHAPE", "missing state dump")
    require(isinstance(summary["output"], str) and re.fullmatch(r"(?:[0-9a-f]{2})*", summary["output"]),
            "TRACE-SHAPE", "invalid output bytes")
    require(isinstance(summary["gasUsed"], str) and re.fullmatch(r"0x[0-9a-f]+", summary["gasUsed"]),
            "TRACE-SHAPE", "invalid gas value")
    require(0 <= int(summary["gasUsed"], 16) <= GAS, "TRACE-SHAPE", "gas outside supplied limit")
    return steps, summary, state


def success(records, code):
    steps, summary, state = split_execution(records)
    errors = [row["error"] for row in records if row.get("error")]
    require(not errors, code, "; ".join(str(error) for error in errors))
    return steps, summary, state


def listing(text):
    rows = []
    for line in text.splitlines():
        if not line.strip():
            continue
        match = re.fullmatch(r"([0-9a-f]+): ([A-Z0-9]+)(?: 0x([0-9a-f]+))?", line)
        require(match is not None, "REFERENCE-LISTING", f"invalid row: {line}")
        pc, name, immediate = match.groups()
        rows.append((int(pc, 16), name, immediate or ""))
    return rows


def source(root, filename):
    rows, chunks, pc = [], [], 0
    for number, line in enumerate((root / "reference" / filename).read_text().splitlines(), 1):
        if not line.strip() or line.lstrip().startswith(";"):
            continue
        code, separator, comment = line.partition(";")
        require(separator and comment.strip(), "REFERENCE-COMMENT", f"{filename}:{number}")
        match = re.fullmatch(r"([0-9a-f]+) ([0-9a-f]+) ([A-Z0-9]+)(?: 0x([0-9a-f]+))?\s*", code)
        require(match is not None, "REFERENCE-SYNTAX", f"{filename}:{number}")
        offset, data, mnemonic, immediate = match.groups()
        require(len(data) % 2 == 0, "REFERENCE-SYNTAX", "odd byte string")
        require(int(offset, 16) == pc, "REFERENCE-PC", f"{filename}:{number} got={offset} want={pc:x}")
        rows.append((pc, mnemonic, immediate or ""))
        chunks.append(data)
        pc += len(data) // 2
    data = "".join(chunks)
    require(bool(rows), "REFERENCE-SYNTAX", "empty reference")
    ours = run(root, filename + "-listing", str(root / ARTIFACT), "listing", data)
    require(listing(ours) == rows, "REFERENCE-LISTING", f"{filename} annotations differ from decoded bytes")
    return data, rows


# Review round 2026-09-10 (A-2):  the checked-block comparison is a named
# function, so checks() can feed it a damaged fixture row and prove that the
# REFERENCE-ASSEMBLER require can fail.
def verify_assembler(output, data):
    fixture_rows = [line.split() for line in output.splitlines()]
    matches = [parts[1] for parts in fixture_rows if len(parts) == 2 and parts[0] == "ref20"]
    require(matches == [data], "REFERENCE-ASSEMBLER", "checked block assembly differs from the reference")


def reference(root):
    data, rows = source(root, "ref20.evm")
    require(data == RUNTIME and len(rows) == 17, "REFERENCE-BYTES", "reference differs from the frozen Stage 0 runtime")
    verify_assembler(run(root, "assembler-fixtures", str(root / ARTIFACT), "fixtures"), data)
    return data, rows


def verify_trace(data, declared, records, cast_rows):
    require(cast_rows == declared, "TRACE-CAST", "cast rows differ from the decoded listing")
    steps, summary, state = success(records, "TRACE-EXEC")
    pcs = [row["pc"] for row in steps]
    require(pcs == TRACE_PCS, "TRACE-PC", f"got={pcs} want={TRACE_PCS}")
    known = {pc: (name, immediate) for pc, name, immediate in declared}
    for row, stack in zip(steps, TRACE_STACKS):
        pc = row["pc"]
        require(row["opName"] == known[pc][0] and row["op"] == int(data[2 * pc:2 * pc + 2], 16),
                "TRACE-OP", f"opcode differs at pc={pc}")
        require(all(isinstance(value, str) and re.fullmatch(r"0x[0-9a-f]+", value) for value in row["stack"]),
                "TRACE-STACK", f"malformed stack at pc={pc}")
        require([int(value, 16) for value in row["stack"]] == stack, "TRACE-STACK", f"stack differs at pc={pc}")
    require(summary["output"] == "00" * 31 + "2a", "TRACE-RETURN", "expected the 32-byte value 42")
    # Review round 2026-09-10 (A-1):  geth dumps EIP-55 checksummed addresses.
    # Index the dump by the lowercased address, the way verify_create does.
    accounts = {address.lower(): account for address, account in state["accounts"].items()}
    require(set(accounts) == {RECEIVER}, "TRACE-ACCOUNT", "unexpected runtime account set")
    account = accounts[RECEIVER]
    require(account.get("code") == "0x" + data, "TRACE-CODE", "dumped code differs from runtime")
    slot = "0x" + "00" * 32
    storage = account.get("storage")
    require(storage == {slot: "2a"}, "TRACE-STORAGE", "expected only slot zero = 42")
    require(account.get("nonce") == 0 and account.get("balance") == "0", "TRACE-ACCOUNT", "runtime changed nonce or balance")
    # Review round 2026-09-10 (A-3):  the skipped set is a function of the pinned
    # listing and the pinned program counters, so a require on it cannot fail.
    # The list stays as the source of the printed skipped= count.
    skipped = [pc for pc, _name, _immediate in declared if pc not in pcs]
    # Review round 2026-09-10 (A-5):  return the accepted storage word and the
    # accepted output word, so the trace marker prints measured values.
    return steps, summary, skipped, storage[slot], summary["output"]


def trace(root):
    data, declared = reference(root)
    cast_rows = listing(run(root, "ref20-cast", "cast", "disassemble", "0x" + data))
    records = execute(root, "ref20-run", data)
    steps, summary, skipped, storage, output = verify_trace(data, declared, records, cast_rows)
    print(f"REFERENCE-MEASURE runtime_bytes={len(data) // 2} gas={int(summary['gasUsed'], 16)}")
    # Review round 2026-09-10 (A-5):  storage= and return= are read back from the
    # values the checks accepted, not written as literals.
    print(f"M0-TRACE scope=reference bytes={len(data) // 2} listing={len(declared)} cast={len(cast_rows)} "
          f"evm={len(steps)} skipped={len(skipped)} storage={int(storage, 16)} return={int(output, 16)} OK")
    return data, declared, records, cast_rows


def verify_create(data, prefix, prefix_rows, records):
    steps, summary, state = success(records, "CREATE-EXEC")
    require([row["pc"] for row in steps] == [pc for pc, _name, _immediate in prefix_rows],
            "CREATE-PC", "creation did not execute exactly the prefix")
    require([row["opName"] for row in steps] == [name for _pc, name, _immediate in prefix_rows],
            "CREATE-OP", "creation trace differs from prefix listing")
    require(all(row["op"] == int(prefix[2 * row["pc"]:2 * row["pc"] + 2], 16) for row in steps),
            "CREATE-OP", "creation opcode byte differs from prefix")
    require(summary["output"] == data, "CREATE-BYTES", "creation returned different runtime bytes")
    accounts = state["accounts"]
    created = [account for address, account in accounts.items() if address.lower() != SENDER]
    sender = [account for address, account in accounts.items() if address.lower() == SENDER]
    require(len(created) == 1 and len(sender) == 1, "CREATE-ACCOUNT", "expected sender and one created contract")
    require(sender[0].get("nonce") == 1 and sender[0].get("balance") == "0", "CREATE-ACCOUNT", "invalid sender state")
    contract = created[0]
    require(contract.get("code") == "0x" + data, "CREATE-INSTALLED", "installed code differs from runtime")
    require(contract.get("nonce") == 1 and contract.get("balance") == "0" and not contract.get("storage"),
            "CREATE-ACCOUNT", "unexpected constructor state")
    # Review round 2026-09-10 (A-5):  return the accepted account list, so the
    # create marker prints the counted installation.
    return summary, created


def create(root):
    data, _rows = reference(root)
    prefix, prefix_rows = source(root, "ref20-init.evm")
    records = execute(root, "ref20-create", prefix + data, create=True)
    summary, created = verify_create(data, prefix, prefix_rows, records)
    digest = hashlib.sha256(bytes.fromhex(data)).hexdigest()
    returned = hashlib.sha256(bytes.fromhex(summary["output"])).hexdigest()
    print(f"CREATE-MEASURE init_bytes={len(prefix + data) // 2} gas={int(summary['gasUsed'], 16)} "
          f"runtime_sha={digest} returned_sha={returned}")
    print(f"CREATE-EQ bytes={len(data) // 2} returned={len(summary['output']) // 2} installed={len(created)} OK")
    return data, prefix, prefix_rows, records


def fork(root):
    probes = [
        ("PUSH0", "5f00", [0, 1], [0]),
        ("TLOAD", "5f5c00", [0, 1, 2], [0]),
        ("TSTORE", "602a5f5d5f5c00", [0, 2, 3, 4, 5, 6], [42]),
        ("MCOPY", "602a5f5260205f60205e60205100", [0, 2, 3, 4, 6, 7, 9, 10, 12, 13], [42]),
    ]
    # Review round 2026-09-10 (A-5):  each probe records its own verdict, and the
    # drift line is formatted from the recorded verdicts in the pinned order.
    results = {}
    for name, code, pcs, final_stack in probes:
        records = execute(root, "fork-" + name, code)
        steps, summary, _state = success(records, "FORK-" + name)
        require([row["pc"] for row in steps] == pcs and steps[-1]["opName"] == "STOP", "FORK-" + name, "unexpected execution path")
        require(summary["output"] == "" and [int(value, 16) for value in steps[-1]["stack"]] == final_stack,
                "FORK-" + name, "unexpected stack effect")
        require(any(row["opName"] == name for row in steps), "FORK-" + name, "probe did not execute its opcode")
        results[name.lower()] = "OK"
        print(f"FORK-PROBE {name} OK steps={len(steps)} gas={int(summary['gasUsed'], 16)}")
    invalid = "invalid opcode: opcode 0x1e not defined"
    records = execute(root, "fork-CLZ", "5f1e00")
    steps, summary, _state = split_execution(records)
    require(summary.get("error") == invalid and summary["output"] == "" and
            [row["pc"] for row in steps] == [0, 1, 1] and steps[-1].get("error") == invalid and
            steps[-1]["op"] == 0x1e and steps[-1]["opName"] == "opcode 0x1e not defined",
            "FORK-CLZ", "expected the frozen invalid-opcode result")
    plain = execute(root, "fork-CLZ-plain", "5f1e00", plain=True)
    require(plain.strip() == "error: " + invalid, "FORK-CLZ", "plain diagnostic differs")
    results["clz"] = "INVALID"
    print("FORK-PROBE CLZ INVALID " + invalid)
    fields = ("push0", "tload", "tstore", "mcopy", "clz")
    print("FORK-DRIFT " + " ".join(f"{field}={results[field]}" for field in fields) + " OK")


def checks(root):
    """Prove the validators reject corrupted captures from live control runs."""
    data, declared, runtime_records, cast_rows = trace(root)
    create_data, prefix, prefix_rows, create_records = create(root)
    created_address = next(address for address in create_records[-1]["accounts"] if address.lower() != SENDER)
    # Review round 2026-09-10 (A-1):  the dump keys are checksummed, so the edits
    # below address the receiver and the sender by their matched raw keys.
    receiver_key = next(address for address in runtime_records[-1]["accounts"] if address.lower() == RECEIVER)
    sender_address = next(address for address in create_records[-1]["accounts"] if address.lower() == SENDER)
    # Review round 2026-09-10 (A-2):  a runtime dump that holds the real receiver
    # and one extra account keeps every other trace fact true, so only the
    # account-set require can reject it.
    extra_accounts = copy.deepcopy({receiver_key: runtime_records[-1]["accounts"][receiver_key],
                                    "0x" + "11" * 20: {"balance": "0", "nonce": 0}})
    edits = [
        ("TRACE-PC", "trace", (0, "pc"), 1),
        ("TRACE-OP", "trace", (0, "op"), 0),
        ("TRACE-OP", "trace", (0, "opName"), "STOP"),
        ("TRACE-STACK", "trace", (1, "stack"), ["0x2b"]),
        ("TRACE-RETURN", "trace", (-2, "output"), "00" * 31 + "2b"),
        ("TRACE-EXEC", "trace", (-2, "error"), "out of gas"),
        ("TRACE-EXEC", "trace", (0, "error"), "out of gas"),
        ("TRACE-STORAGE", "trace", (-1, "accounts", receiver_key, "storage"), {}),
        ("TRACE-CODE", "trace", (-1, "accounts", receiver_key, "code"), "0x00"),
        ("TRACE-ACCOUNT", "trace", (-1, "accounts", receiver_key, "balance"), "1"),
        ("TRACE-SHAPE", "trace", (-2, "gasUsed"), "invalid"),
        ("TRACE-SHAPE", "trace", (-1, "accounts"), []),
        ("CREATE-BYTES", "create", (-2, "output"), data[:-2]),
        ("CREATE-INSTALLED", "create", (-1, "accounts", created_address, "code"), "0x00"),
        ("CREATE-ACCOUNT", "create", (-1, "accounts", created_address, "nonce"), 0),
        ("CREATE-PC", "create", (0, "pc"), 1),
        ("CREATE-OP", "create", (0, "op"), 0),
        ("CREATE-OP", "create", (0, "opName"), "STOP"),
        ("CREATE-EXEC", "create", (0, "error"), "execution reverted"),
        ("CREATE-EXEC", "create", (-2, "error"), "execution reverted"),
        # Review round 2026-09-10 (A-2):  cover the account-set require of the
        # trace and the sender-nonce require of the creation.
        ("TRACE-ACCOUNT", "trace", (-1, "accounts"), extra_accounts),
        ("CREATE-ACCOUNT", "create", (-1, "accounts", sender_address, "nonce"), 0),
    ]
    # Review round 2026-09-10 (A-2):  the printed cases= count is incremented by
    # the rejection path itself, so a new case cannot be forgotten in the count.
    counted = 0

    def rejected(name, code, callback):
        nonlocal counted
        try:
            callback()
        except GateError as error:
            require(error.code == code, "CHECK-WITNESS", f"{name}: want={code} got={error}")
            counted += 1
            print(f"REFERENCE-CHECK {name} rejected={code}")
            return
        raise GateError("CHECK-SURVIVED", name)

    for index, (code, mode, path, replacement) in enumerate(edits):
        records = copy.deepcopy(runtime_records if mode == "trace" else create_records)
        node = records
        for key in path[:-1]:
            node = node[key]
        node[path[-1]] = replacement
        validate = (lambda: verify_trace(data, declared, records, cast_rows)) if mode == "trace" else (
            lambda: verify_create(create_data, prefix, prefix_rows, records))
        rejected(f"{mode}-{index + 1}", code, validate)
    # Missing, duplicate and reordered records must not count as a valid trace.
    damaged = [
        ("missing-step", "TRACE-PC", runtime_records[1:]),
        ("duplicate-step", "TRACE-PC", [runtime_records[0]] + runtime_records),
        ("reordered-steps", "TRACE-PC", [runtime_records[1], runtime_records[0]] + runtime_records[2:]),
        ("missing-summary", "TRACE-SHAPE", runtime_records[:-2] + runtime_records[-1:]),
        ("duplicate-summary", "TRACE-SHAPE", runtime_records[:-1] + runtime_records[-2:]),
    ]
    for name, code, records in damaged:
        rejected(name, code, lambda: verify_trace(data, declared, records, cast_rows))
    rejected("cast-truncated", "TRACE-CAST", lambda: verify_trace(data, declared, runtime_records, cast_rows[:-1]))
    changed_cast = [(0, "PUSH1", "2b")] + cast_rows[1:]
    rejected("cast-immediate", "TRACE-CAST", lambda: verify_trace(data, declared, runtime_records, changed_cast))
    rejected("json-duplicate", "JSON-DUPLICATE", lambda: objects('{"pc":0,"pc":1}'))
    rejected("json-scalar", "JSON-SHAPE", lambda: objects('[]'))
    # Review round 2026-09-10 (A-2):  the fixture table captured by the live
    # assembler run is damaged in its reference row, so the checked-block
    # require is proved able to fail.  No mutant can reach it:  every in-tree
    # edit of reference/ref20.evm fails at REFERENCE-BYTES first, and the
    # fixture column comes from src/tests.bend, which is outside the mutants()
    # copy list and needs a native rebuild.
    receipt = json.loads((root / ".gatework/reference/assembler-fixtures.json").read_text())
    fixtures = receipt["stdout"]
    rejected("assembler-row", "REFERENCE-ASSEMBLER",
             lambda: verify_assembler(fixtures.replace(data, data[:-2] + "00"), data))
    controls = 0
    verify_trace(data, declared, runtime_records, cast_rows)
    controls += 1
    verify_create(create_data, prefix, prefix_rows, create_records)
    controls += 1
    print(f"REFERENCE-CHECKS cases={counted} controls={controls} OK")


def unchanged(relative, changed, original):
    """Decide whether a mutation is a no-op, by value for JSON and by text else."""
    if relative.endswith(".json"):
        return json.loads(changed) == json.loads(original)
    return changed == original


def alive(text):
    """Report whether a clone name suffix names a live process of this machine."""
    if not text.isdigit():
        return False
    try:
        os.kill(int(text), 0)
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    return True


def mutants(root):
    # Review round 2026-09-10 (A-4):  a damaged prestate fixture must fail with a
    # gate code that names the file and the missing key, not with a bare decoder
    # message or a bare key error.
    fixture = "evm/fixtures/cancun.json"
    text = (root / fixture).read_text()
    try:
        prestate = json.loads(text)
    except json.JSONDecodeError as error:
        require(False, "PRESTATE-SYNTAX", f"{fixture}: {error}")
    require("config" in prestate, "PRESTATE-KEY", f"{fixture}: config")
    no_cancun = copy.deepcopy(prestate)
    require("cancunTime" in no_cancun["config"], "PRESTATE-KEY", f"{fixture}: cancunTime")
    no_cancun["config"].pop("cancunTime")
    no_shanghai = copy.deepcopy(no_cancun)
    require("shanghaiTime" in no_shanghai["config"], "PRESTATE-KEY", f"{fixture}: shanghaiTime")
    no_shanghai["config"].pop("shanghaiTime")
    runtime = (root / "reference/ref20.evm").read_text()
    prefix = (root / "reference/ref20-init.evm").read_text()
    cases = [
        ("CANCUN-OFF", "evm/fixtures/cancun.json", json.dumps(no_cancun), "fork", "FORK-TLOAD invalid opcode: TLOAD"),
        ("SHANGHAI-OFF", "evm/fixtures/cancun.json", json.dumps(no_shanghai), "fork", "FORK-PUSH0 invalid opcode: PUSH0"),
        ("REFERENCE-BYTE", "reference/ref20.evm", runtime.replace("602a PUSH1 0x2a", "602b PUSH1 0x2b"), "trace", "REFERENCE-BYTES"),
        ("REFERENCE-PC", "reference/ref20.evm", runtime.replace("03 55", "04 55"), "trace", "REFERENCE-PC"),
        ("REFERENCE-NAME", "reference/ref20.evm", runtime.replace("55 SSTORE", "55 SLOAD"), "trace", "REFERENCE-LISTING"),
        ("INIT-OFFSET", "reference/ref20-init.evm", prefix.replace("600a PUSH1 0x0a", "600b PUSH1 0x0b"), "create", "CREATE-BYTES"),
        ("INIT-LENGTH", "reference/ref20-init.evm", prefix.replace("6014 PUSH1 0x14", "6013 PUSH1 0x13"), "create", "CREATE-BYTES"),
        ("INIT-REVERT", "reference/ref20-init.evm", prefix.replace("f3 RETURN", "fd REVERT"), "create", "CREATE-EXEC execution reverted"),
    ]
    work = root / ".gatework"
    # Review round 2026-09-10 (ND-1-1):  the clone lives inside the tree under
    # review and carries the pid of this process.  A killed run therefore leaves
    # exactly one named directory, the next run of this process removes it, and
    # a concurrent run on another copy can never delete a live clone.
    clone = work / ("mutants-" + str(os.getpid()))
    shutil.rmtree(clone, ignore_errors=True)
    clone.mkdir(parents=True)
    # Review round 2026-09-10 (B-1):  a leg deadline kills this process before
    # the cleanup below runs.  The clone of a dead pid of this tree is removed
    # here; the clone of a live pid, which a concurrent run owns, is kept.
    for stale in work.glob("mutants-*"):
        if not alive(stale.name[len("mutants-"):]):
            shutil.rmtree(stale, ignore_errors=True)
    try:
        paths = ["dev/reference-test.py", "dev/native_mutations.py", "dev/bend_source.py", "reference/ref20.evm", "reference/ref20-init.evm",
                 "evm/fixtures/cancun.json", ARTIFACT]
        for relative in paths:
            target = clone / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(root / relative, target)
        native_mutations.copy_build(root, clone)
        for name, relative, changed, mode, witness in cases:
            original = (root / relative).read_text()
            # B-4: the two prestate cases are reserialized JSON, whose text
            # always differs from the fixture file, so they are compared by
            # value and an empty mutation fails at its own named check.
            require(not unchanged(relative, changed, original), "MUTATION-SITE", name)
            (clone / relative).write_text(changed)
            result = subprocess.run([sys.executable, "-P", str(clone / "dev/reference-test.py"), mode],
                                    cwd=clone, capture_output=True, text=True, timeout=CLONE_TIMEOUT)
            (work / ("reference-mutant-" + name + ".log")).write_text(result.stdout + result.stderr)
            require(result.returncode == 1 and witness in result.stdout and not result.stderr,
                    "MUTANT-SURVIVED", f"{name} exit={result.returncode}: {result.stdout}{result.stderr}")
            print(f"REFERENCE-MUTANT {name} killed witness={witness}", flush=True)
            if name == "CANCUN-OFF":
                # The literal Stage D recipe leaves Shanghai enabled.
                plain = execute(clone, "control-shanghai", "5f00", plain=True)
                require(not plain.strip(), "CONTROL-SHANGHAI", "PUSH0 must survive Cancun-only removal")
            if name == "SHANGHAI-OFF":
                plain = execute(clone, "control-no-shanghai", "5f00", plain=True)
                require(plain.strip() == "error: invalid opcode: PUSH0", "CONTROL-SHANGHAI", "missing PUSH0 diagnostic")
            (clone / relative).write_text(original)
        # Review round 2026-09-10 (A-5):  count the restored controls that pass.
        controls = 0
        for mode in ("fork", "trace", "create"):
            result = subprocess.run([sys.executable, "-P", str(clone / "dev/reference-test.py"), mode],
                                    cwd=clone, capture_output=True, text=True, timeout=CLONE_TIMEOUT)
            (work / ("reference-control-" + mode + ".log")).write_text(result.stdout + result.stderr)
            require(result.returncode == 0 and not result.stderr, "CONTROL", mode + ": " + result.stdout + result.stderr)
            controls += 1
    finally:
        shutil.rmtree(clone, ignore_errors=True)
    print(f"REFERENCE-MUTANTS killed={len(cases)}/{len(cases)} controls={controls} OK")


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("trace", "create", "fork", "checks", "mutants"):
        print("usage: reference-test.py trace|create|fork|checks|mutants")
        return 64
    root = Path(__file__).resolve().parent.parent
    mode = sys.argv[1]
    for tool in ("evm", "cast"):
        require(shutil.which(tool) is not None, "TOOL-MISSING", tool)
    # Review round 2026-09-10 (C-3):  four of the five modes read the Stage C
    # listing artifact.  Name the missing build instead of failing later with a
    # bare file error that carries no gate code.
    require(mode == "fork" or (root / ARTIFACT).is_file(), "BUILD-MISSING",
            "run zsh -f dev/build.sh build")
    print("REFERENCE-ORACLE " + run(root, "evm-version", "evm", "--version").strip())
    print("REFERENCE-ORACLE " + run(root, "cast-version", "cast", "--version").strip())
    {"trace": trace, "create": create, "fork": fork, "checks": checks, "mutants": mutants}[mode](root)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, IndexError, subprocess.SubprocessError) as error:
        print("REFERENCE-GATE FAIL " + str(error))
        sys.exit(1)

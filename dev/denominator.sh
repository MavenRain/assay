#!/bin/zsh
# dev/denominator.sh.  assay M0 Stage 0, spike (c), date 2026-09-10.
#
# It measures three denominator rows over ONE frozen OCaml corpus, in the same
# minute, as the median of five timed runs after one warm run, with a fresh
# scratch output directory for every timed run.
#
#   ocamlopt_ms_per_kloc  wall time of "ocamlopt -c" over the corpus
#   ocamlc_ms_per_kloc    wall time of "ocamlc -c" over the same corpus
#   assay_ms_per_kloc     wall time of the pin executable over the same corpus
#
# The third row is a PLACEHOLDER.  At Stage 0 no assay front end exists, so the
# row times the kanon executable built at the pin 2c2e6e6 by spike (b), called
# directly by its absolute path and never through kanoncho, because the
# distiller adds overhead and its backend is not the pin.  Stage F replaces the
# row with the assay front end over the frozen contract corpus.
#
# It prints one line per row:
#   DENOM <row> value=<n> median_ms=<n> min_ms=<n> max_ms=<n> runs=5 lines=<n>
# and it prints "uptime" beside the run.  value is median_ms divided by lines,
# multiplied by 1000, so the unit is ms per 1000 lines.  No ratio prints here.
#
# Usage:
#   zsh dev/denominator.sh [--root DIR] [--scratch DIR] [--kanon PATH]
#                          [--runs N] [--json OUT]
# Every timed run writes only under --scratch.  Nothing writes in the source
# checkout /Users/oobi/Documents/kanon.

set -eu
zmodload zsh/datetime

ROOT=/Users/oobi/Documents/assay
SCRATCH=/Users/oobi/Documents/assay-m0/spikes/denom/scratch
KANON=/Users/oobi/Documents/assay/_build/default/bin/kanon.exe
OCAMLOPT=/Users/oobi/.opam/zxcaml-p1/bin/ocamlopt
OCAMLC=/Users/oobi/.opam/zxcaml-p1/bin/ocamlc
OCAMLDEP=/Users/oobi/.opam/zxcaml-p1/bin/ocamldep
ZARITH=/Users/oobi/.opam/zxcaml-p1/lib/zarith
RUNS=5
JSON=""
PROVISIONAL=2135.8
PIN=2c2e6e6831a0b2cf3107fa4aad392606109a2bcf

usage() {
  print -r -- "usage: denominator.sh [--root DIR] [--scratch DIR] [--kanon PATH] [--runs N] [--json OUT]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --scratch) SCRATCH="$2"; shift 2 ;;
    --kanon) KANON="$2"; shift 2 ;;
    --runs) RUNS="$2"; shift 2 ;;
    --json) JSON="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 4 ;;
  esac
done

# The corpus.  S0-D3: every .ml file of lib/ at the pin, with the two .mli
# interfaces that lib/ carries, because ocamlopt needs an interface before its
# implementation.  The set is frozen by name, so a rerun compiles the same
# lines at every milestone.
CORPUS_DIR="$ROOT/lib"
CORPUS=()
for f in "$CORPUS_DIR"/*.ml "$CORPUS_DIR"/*.mli; do
  CORPUS+=("$f")
done
CORPUS=("${(@o)CORPUS}")

LINES=0
for f in "${CORPUS[@]}"; do
  n=$(wc -l < "$f" | tr -d ' ')
  LINES=$(( LINES + n ))
done

if [ "$LINES" -le 0 ]; then
  print -r -- "DENOM FAIL empty corpus under $CORPUS_DIR"
  exit 1
fi

CORPUS_SHA=$(cat "${CORPUS[@]}" | /usr/bin/shasum -a 256 | cut -d' ' -f1)

mkdir -p "$SCRATCH"

# stage_corpus DIR.  It copies the corpus into a fresh directory and prints the
# compile order.  It runs OUTSIDE every timed window.
stage_corpus() {
  local d="$1"
  mkdir -p "$d"
  cp "${CORPUS[@]}" "$d"/
  local ord
  ord=$("$OCAMLDEP" -sort "$d"/*.ml)
  local files=""
  local f
  for f in ${=ord}; do
    if [ -f "${f}i" ]; then
      files="$files ${f}i"
    fi
    files="$files $f"
  done
  print -r -- "$files"
}

# time_ocaml COMPILER DIR FILES.  It prints the wall time in ms.
time_ocaml() {
  local cc="$1" d="$2" files="$3" t0 t1 rc
  t0=$EPOCHREALTIME
  set +e
  "$cc" -c -I "$d" -I "$ZARITH" ${=files} >"$d/compile.log" 2>&1
  rc=$?
  set -e
  t1=$EPOCHREALTIME
  if [ "$rc" -ne 0 ]; then
    print -r -- "DENOM FAIL $cc exited $rc: $(head -n 1 "$d/compile.log")" >&2
    exit 1
  fi
  printf '%.1f' $(( (t1 - t0) * 1000 ))
}

# time_kanon DIR.  It prints the wall time in ms of the pin executable over the
# same corpus, one call per file.  The pin front end reads Kanon source, so an
# OCaml file stops at the first lexical error;  the row is the placeholder
# Stage F replaces, and a non-zero exit is expected and is not a failure.
time_kanon() {
  local d="$1" t0 t1 f
  t0=$EPOCHREALTIME
  set +e
  for f in "$d"/*.ml "$d"/*.mli; do
    "$KANON" check "$f" >>"$d/kanon.log" 2>&1 # [raw-kanon-ok]
  done
  set -e
  t1=$EPOCHREALTIME
  printf '%.1f' $(( (t1 - t0) * 1000 ))
}

# median_of LIST.  It prints median, min and max, separated by spaces.
median_of() {
  local sorted mid
  sorted=($(printf '%s\n' "$@" | sort -n))
  mid=$(( ${#sorted[@]} / 2 + 1 ))
  print -r -- "${sorted[$mid]} ${sorted[1]} ${sorted[${#sorted[@]}]}"
}

value_of() {
  printf '%.1f' $(( $1 * 1000.0 / LINES ))
}

emit_row() {
  local row="$1" value="$2" median="$3" min="$4" max="$5"
  printf 'DENOM %s value=%s median_ms=%s min_ms=%s max_ms=%s runs=%s lines=%s\n' \
    "$row" "$value" "$median" "$min" "$max" "$RUNS" "$LINES"
}

run_row() {
  local kind="$1"
  local warm d files t
  local -a samples
  warm="$SCRATCH/warm.$kind.$$"
  rm -rf "$warm"
  files=$(stage_corpus "$warm")
  case "$kind" in
    ocamlopt) t=$(time_ocaml "$OCAMLOPT" "$warm" "$files") ;;
    ocamlc) t=$(time_ocaml "$OCAMLC" "$warm" "$files") ;;
    assay) t=$(time_kanon "$warm") ;;
    *) exit 4 ;;
  esac
  rm -rf "$warm"
  local i
  for i in {1..$RUNS}; do
    d="$SCRATCH/run.$kind.$$.$i"
    rm -rf "$d"
    files=$(stage_corpus "$d")
    case "$kind" in
      ocamlopt) t=$(time_ocaml "$OCAMLOPT" "$d" "$files") ;;
      ocamlc) t=$(time_ocaml "$OCAMLC" "$d" "$files") ;;
      assay) t=$(time_kanon "$d") ;;
      *) exit 4 ;;
    esac
    samples+=("$t")
    rm -rf "$d"
  done
  print -r -- "${samples[@]}"
}

STARTED=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
LOAD=$(uptime)
print -r -- "UPTIME $LOAD"

OPT_STATS=($(median_of ${=$(run_row ocamlopt)}))
OC_STATS=($(median_of ${=$(run_row ocamlc)}))

KANON_STATUS=ok
KANON_REASON=""
if [ ! -x "$KANON" ]; then
  KANON_STATUS=skip
  KANON_REASON="kanon build failed: no executable at $KANON"
fi

OPT_VALUE=$(value_of "${OPT_STATS[1]}")
emit_row ocamlopt_ms_per_kloc "$OPT_VALUE" "${OPT_STATS[1]}" "${OPT_STATS[2]}" "${OPT_STATS[3]}"
OC_VALUE=$(value_of "${OC_STATS[1]}")
emit_row ocamlc_ms_per_kloc "$OC_VALUE" "${OC_STATS[1]}" "${OC_STATS[2]}" "${OC_STATS[3]}"

AS_VALUE=""
AS_STATS=()
if [ "$KANON_STATUS" = ok ]; then
  AS_STATS=($(median_of ${=$(run_row assay)}))
  AS_VALUE=$(value_of "${AS_STATS[1]}")
  emit_row assay_ms_per_kloc "$AS_VALUE" "${AS_STATS[1]}" "${AS_STATS[2]}" "${AS_STATS[3]}"
else
  print -r -- "DENOM assay_ms_per_kloc SKIP $KANON_REASON"
fi

ENDED=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
LOAD_END=$(uptime)
print -r -- "UPTIME $LOAD_END"
print -r -- "WINDOW started=$STARTED ended=$ENDED"

if [ -z "$JSON" ]; then
  exit 0
fi

OPT_VERSION=$("$OCAMLOPT" -version)
OC_VERSION=$("$OCAMLC" -version)
KANON_VERSION="$KANON_REASON"
if [ "$KANON_STATUS" = ok ]; then
  KANON_VERSION=$("$KANON" --help 2>&1 | head -n 1) # [raw-kanon-ok]
fi
ARCH=$(uname -m)
NCPU=$(getconf _NPROCESSORS_ONLN)
MACOS=$(sw_vers -productVersion)

CORPUS_JSON=""
for f in "${CORPUS[@]}"; do
  rel="${f#$ROOT/}"
  n=$(wc -l < "$f" | tr -d ' ')
  if [ -n "$CORPUS_JSON" ]; then
    CORPUS_JSON="$CORPUS_JSON,"
  fi
  CORPUS_JSON="$CORPUS_JSON{\"path\":\"$rel\",\"lines\":$n}"
done

row_json() {
  local name="$1" value="$2" median="$3" min="$4" max="$5" cmd="$6" method="$7" extra="$8"
  printf '{"value":%s,"median_ms":%s,"min_ms":%s,"max_ms":%s,"runs":%s,"lines":%s,"command":"%s","method":"%s","load":"%s"%s}' \
    "$value" "$median" "$min" "$max" "$RUNS" "$LINES" "$cmd" "$method" "$LOAD" "$extra"
}

OPT_CMD="$OCAMLOPT -c -I <fresh scratch dir> -I $ZARITH <corpus in ocamldep -sort order, every .mli before its .ml>"
OC_CMD="$OCAMLC -c -I <fresh scratch dir> -I $ZARITH <corpus in ocamldep -sort order, every .mli before its .ml>"
AS_CMD="$KANON check <file> for every corpus file in the fresh scratch dir"
METHOD="One frozen OCaml corpus, one warm run, then $RUNS timed runs in the same minute, a fresh scratch output directory per timed run, wall clock from zsh EPOCHREALTIME, value = median_ms * 1000 / lines."

OPT_ROW=$(row_json ocamlopt_ms_per_kloc "$OPT_VALUE" "${OPT_STATS[1]}" "${OPT_STATS[2]}" "${OPT_STATS[3]}" "$OPT_CMD" "$METHOD  Row: native compilation of the corpus to .cmx." ",\"provisional_reference\":{\"value\":$PROVISIONAL,\"unit\":\"ms per kloc\",\"source\":\"assay-ocaml-denominators-provisional.json, load 58 to 64\",\"status\":\"PROVISIONAL, replaced at Stage F\"}")
OC_ROW=$(row_json ocamlc_ms_per_kloc "$OC_VALUE" "${OC_STATS[1]}" "${OC_STATS[2]}" "${OC_STATS[3]}" "$OC_CMD" "$METHOD  Row: bytecode compilation of the same corpus to .cmo." "")

if [ "$KANON_STATUS" = ok ]; then
  AS_ROW=$(row_json assay_ms_per_kloc "$AS_VALUE" "${AS_STATS[1]}" "${AS_STATS[2]}" "${AS_STATS[3]}" "$AS_CMD" "$METHOD  Row: the kanon front end at the pin over the same corpus, one call per file, called by absolute path and never through kanoncho.  The pin front end reads Kanon source, so every call stops at the first lexical error of the OCaml file;  the number is a floor of process start plus read plus lex, not a compile." ",\"status\":\"PLACEHOLDER, replaced at Stage F by the assay front end over the frozen contract corpus\"")
else
  AS_ROW="{\"status\":\"SKIP\",\"reason\":\"$KANON_REASON\"}"
fi

cat > "$JSON" <<JSONEOF
{
  "date": "2026-09-10",
  "kanon_pin": "$PIN",
  "stage": "M0 Stage 0, spike (c)",
  "noisy": true,
  "note": "No ratio prints at Stage 0.  M0-RATIO is printed and gated at no milestone at M0 (R-Q1a).  A re-measurement is a new dated file and never an overwrite of this one.",
  "versions": {
    "ocamlopt": "$OPT_VERSION",
    "ocamlc": "$OC_VERSION",
    "kanon": "$KANON_VERSION",
    "kanon_path": "$KANON"
  },
  "host": {"arch": "$ARCH", "ncpu": $NCPU, "macos": "$MACOS"},
  "load": "$LOAD",
  "window": {"started": "$STARTED", "ended": "$ENDED", "load_end": "$LOAD_END"},
  "corpus": {
    "root": "$ROOT",
    "dir": "lib",
    "files": [$CORPUS_JSON],
    "total_lines": $LINES,
    "sha256_of_concatenation": "$CORPUS_SHA",
    "order": "ocamldep -sort over the .ml files, every .mli placed before its .ml"
  },
  "rerun": "zsh $ROOT/dev/denominator.sh --root $ROOT --scratch <scratch dir>",
  "rows": {
    "ocamlopt_ms_per_kloc": $OPT_ROW,
    "ocamlc_ms_per_kloc": $OC_ROW,
    "assay_ms_per_kloc": $AS_ROW
  }
}
JSONEOF

print -r -- "JSON $JSON"
exit 0

/* runtime_test.c: checks runtime.c against Python (Nat) and Node (path.posix) vectors, plus the
 * string, list, closure, IO and OS layers. Exit 0 only when every check is GREEN.
 * Build: tcc -Wall -Werror -o rt runtime.c runtime_test.c */
#include "assay.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include "runtime_test_vectors.h"

static int checks, fails;

static void check(int ok, const char *what, const char *detail) {
  checks++;
  if (ok) return;
  fails++;
  if (fails <= 40) printf("FAIL %s %s\n", what, detail ? detail : "");
}

static V S(const char *s) { return str_cstr(s); }
static int seq(V s, const char *lit) { return str_eq_lit(s, lit, strlen(lit)); }

/* Canonical Nat: small below 2^63, Big otherwise with no leading zero limb. */
static int canon(V x) {
  if (NAT_IS_SMALL(x)) return 1;
  Big *b = (Big *)x;
  return b->tag == TAG_BIG && b->n >= 2 && b->d[b->n - 1] && !(b->n == 2 && b->d[1] < 0x80000000u);
}

static void check_nat(V got, const char *want, const char *what, const char *a) {
  check(seq(nat_show(got), want) && canon(got) && nat_cmp(got, nat_lit(want)) == 0, what, a);
}

static void test_nat(void) {
  for (size_t i = 0; i < sizeof nat_vecs / sizeof nat_vecs[0]; i++) {
    const NatVec *t = &nat_vecs[i];
    V a = nat_lit(t->a), b = nat_lit(t->b), q, r;
    check_nat(a, t->a, "nat lit/show", t->a);
    check_nat(nat_add(a, b), t->sum, "nat add", t->a);
    check_nat(nat_sub(a, b), t->diff, "nat sub", t->a);
    check_nat(nat_mul(a, b), t->prod, "nat mul", t->a);
    nat_divmod2(a, b, &q, &r);
    check_nat(q, t->q, "nat div", t->a);
    check_nat(r, t->r, "nat mod", t->a);
    V p = nat_divmod(a, b);
    check(nat_cmp(FLD(p, 0), q) == 0 && nat_cmp(FLD(p, 1), r) == 0, "nat divmod pair", t->a);
    check(nat_cmp(a, b) == t->cmp, "nat cmp", t->a);
    check(nat_to_u32(a) == t->lo, "nat to_u32", t->a);
    check(nat_cmp(nat_max(a, b), t->cmp < 0 ? b : a) == 0, "nat max", t->a);
  }
  for (size_t i = 0; i < sizeof hex_vecs / sizeof hex_vecs[0]; i++)
    check_nat(nat_lit(hex_vecs[i].hex), hex_vecs[i].dec, "nat hex lit", hex_vecs[i].hex);
  check(nat_of_u64(UINT64_MAX) != NAT_SMALL(0) && seq(nat_show(nat_of_u64(UINT64_MAX)), "18446744073709551615"),
        "nat of_u64 max", 0);
  check(nat_to_u64_sat(nat_lit("18446744073709551616")) == UINT64_MAX, "nat to_u64_sat", 0);
  check(nat_pred(NAT_ZERO) == NAT_ZERO && nat_pred(NAT_SMALL(5)) == NAT_SMALL(4), "nat pred", 0);
  check(nat_is_zero(nat_sub(nat_lit("0x10000000000000000"), nat_lit("18446744073709551616"))), "nat sub eq", 0);
  check(u32_shln(1, NAT_SMALL(31)) == 0x80000000u && u32_shln(1, NAT_SMALL(32)) == 0 &&
            u32_shln(3, nat_lit("99999999999999999999")) == 0, "u32 shln", 0);
  check(u32_shrn(0x80000000u, NAT_SMALL(31)) == 1 && u32_shrn(0xffffffffu, NAT_SMALL(32)) == 0, "u32 shrn", 0);
  check(seq(u32_show(0xffffffffu), "4294967295") && seq(u32_show(0), "0"), "u32 show", 0);
}

static void test_str(void) {
  V r = SNIL;
  for (int i = 0; i < 100000; i++) r = str_append(r, str_cons((V)('a' + i % 26), SNIL));
  check(str_len(r) == 100000 && ((Str *)r)->tag == TAG_CAT, "rope builds", 0);
  Str *f = str_flat(r);
  check((V)f == r && f->tag == TAG_STR && f->u.p[0] == 'a' && f->u.p[25] == 'z' && f->u.p[26] == 'a',
        "rope flatten in place", 0);
  V right = SNIL;
  for (int i = 0; i < 100000; i++) right = str_append(S("0123456789abcdefghijklmnopqrstuvwxyz"), right);
  check(str_len(right) == 3600000 && str_flat(right)->u.p[3599999] == 'z', "right rope flatten", 0);
  V hello = str_append(S("hello, "), S("world, this string is longer than thirty-two bytes"));
  check(str_order(S("abc"), S("abd")) == CMP_OF(-1) && str_order(S("abd"), S("abc")) == CMP_OF(1) &&
            str_order(S("ab"), S("abc")) == CMP_OF(-1) && str_order(S("abc"), S("ab")) == CMP_OF(1) &&
            str_order(SNIL, S("")) == CMP_OF(0) && str_order(SNIL, S("a")) == CMP_OF(-1),
        "str order flat", 0);
  check(str_order(hello, str_append(S("hello, world, this string"), S(" is longer than thirty-two bytes"))) == CMP_OF(0) &&
            str_order(S("\xe9"), S("z")) == CMP_OF(1) && str_order(S("a\xe9"), hello) == CMP_OF(-1),
        "str order rope/latin1", 0);
  check(str_eq(hello, S("hello, world, this string is longer than thirty-two bytes")), "str eq rope/flat", 0);
  check(!str_eq(S("abc"), S("abd")) && !str_eq(S("abc"), S("ab")) && str_eq(SNIL, S("")), "str neq", 0);
  check(str_starts_with(hello, S("hello")) && !str_starts_with(S("he"), S("hello")) && str_starts_with(S("x"), SNIL),
        "str starts_with", 0);
  check(str_ends_with(hello, S("bytes")) && !str_ends_with(hello, S("byte")) && str_ends_with(SNIL, SNIL),
        "str ends_with", 0);
  check(seq(str_reverse(S("abc")), "cba") && seq(str_reverse(SNIL), ""), "str reverse", 0);
  check(str_length(hello) == NAT_SMALL(57), "str length", 0);
  V c = str_cons(0x141, S("x"));
  check(str_head(c) == 0x41 && seq(c, "Ax"), "SCon low 8 bits", 0);
  Str *h = str_flat(hello);
  V t = str_tail(hello);
  check(((Str *)t)->u.p == h->u.p + 1 && seq(t, "ello, world, this string is longer than thirty-two bytes"),
        "str tail O(1)", 0);
  V xs = CON(S("a"), CON(S("b"), CON(S("c"), NIL)));
  check(seq(str_join(xs, S(", ")), "a, b, c") && seq(str_join(NIL, S(",")), ""), "str join", 0);
  check(seq(str_concat(xs), "abc"), "str concat", 0);
  check(seq(str_of((const uint8_t *)"\xff\x00z", 3), "\xff") == 0 && str_len(str_of((const uint8_t *)"\xff\x00z", 3)) == 3,
        "str latin1 bytes", 0);
}

static void test_list(void) {
  V a = CON(NAT_SMALL(1), CON(NAT_SMALL(2), NIL)), b = CON(NAT_SMALL(3), NIL);
  V ab = list_append(a, b);
  check(list_length(ab) == NAT_SMALL(3) && FLD(FLD(FLD(ab, 1), 1), 0) == NAT_SMALL(3), "list append", 0);
  check(FLD(list_reverse(ab), 0) == NAT_SMALL(3) && list_reverse(NIL) == NIL, "list reverse", 0);
  V cc = list_concat(CON(a, CON(NIL, CON(b, NIL))));
  check(list_length(cc) == NAT_SMALL(3) && FLD(cc, 0) == NAT_SMALL(1), "list concat", 0);
  V rep = list_replicate(NAT_SMALL(4), TRUE_V);
  check(list_length(rep) == NAT_SMALL(4) && list_replicate(NAT_ZERO, 1) == NIL, "list replicate", 0);
  check(maybe_default(NONE, 7) == 7 && maybe_default(SOME(8), 7) == 8 && maybe_is_some(SOME(0)), "maybe", 0);
}

static V add3_fn(V *env, V *args) { return nat_add(nat_add(args[0], args[1]), nat_add(args[2], env[0])); }
static V adder_fn(V *env, V *args) {
  V c = clo_new(add3_fn, 3, 1);
  CLO_ENV(c)[0] = args[0];
  return c;
}
static V inc_io_fn(V *env, V *args) { return io_pure(nat_add(args[0], NAT_SMALL(1))); }
static V loop_io_fn(V *env, V *args) {
  if (nat_is_zero(args[0])) return io_pure(NAT_SMALL(42));
  V k = clo_new(loop_io_fn, 1, 0);
  return io_bind(io_pure(nat_pred(args[0])), k);
}

static void test_closure_io(void) {
  V adder = clo_new(adder_fn, 1, 0);
  V add3 = ap(adder, NAT_SMALL(100));
  V p1 = ap(add3, NAT_SMALL(1)), p2 = ap(p1, NAT_SMALL(2));
  check(((Obj *)p2)->tag == TAG_PAP && ap(p2, NAT_SMALL(3)) == NAT_SMALL(106), "closure pap", 0);
  check(ap2(p1, NAT_SMALL(2), NAT_SMALL(3)) == NAT_SMALL(106), "closure pap ap2", 0);
  V xs[4] = {NAT_SMALL(10), NAT_SMALL(1), NAT_SMALL(2), NAT_SMALL(3)};
  check(apn(adder, 4, xs) == NAT_SMALL(16), "closure over-application", 0);
  V m = io_pure(NAT_ZERO), inc = clo_new(inc_io_fn, 1, 0);
  for (int i = 0; i < 1000000; i++) m = io_bind(m, inc);
  check(io_run(m) == NAT_SMALL(1000000), "io left-nested bind 1e6", 0);
  check(io_run(io_bind(io_pure(NAT_SMALL(1000000)), clo_new(loop_io_fn, 1, 0))) == NAT_SMALL(42),
        "io right-nested bind 1e6", 0);
}

static V observe_fn(V *env, V *args) {
  return rt_ctor4(0, TRUE_V, args[0], args[0], CON(str_append(args[0], S("!")), NIL));
}

static void test_paths(void) {
  for (size_t i = 0; i < sizeof path_vecs / sizeof path_vecs[0]; i++) {
    const PathVec *t = &path_vecs[i];
    V a = S(t->a);
    V got = t->fn == 'b' ? path_basename(a) : t->fn == 'e' ? path_extname(a) : t->fn == 'd' ? path_dirname(a)
          : t->fn == 'o' ? io_run(os_basename(a)) : path_join2(a, S(t->b));
    char what[16] = "path x";
    what[5] = t->fn;
    char detail[200];
    snprintf(detail, sizeof detail, "(\"%s\", \"%s\") want \"%s\"", t->a, t->b, t->out);
    check(seq(got, t->out), what, detail);
  }
}

static char *cz(V s, char *buf, size_t cap) {
  snprintf(buf, cap, "%.*s", (int)str_len(s), (const char *)str_flat(s)->u.p);
  return buf;
}

static void cleanup(V dir) {
  char b[1100];
  unlink(cz(str_append(dir, S("/f.txt")), b, sizeof b));
  rmdir(cz(dir, b, sizeof b));
}

static void test_os(const char *tmp) {
  V sh = S("sh");
  V r = io_run(os_run(sh, CON(S("-c"), CON(S("printf hi; exit 3"), NIL))));
  check(FLD(r, 0) == 0 && FLD(r, 1) == 3 && seq(FLD(r, 2), "") && seq(FLD(r, 3), "hi"), "OS.run exit code + output", 0);
  r = io_run(os_run(sh, CON(S("-c"), CON(S("printf x; kill -TERM $$"), NIL))));
  check(FLD(r, 0) == 1 && FLD(r, 1) == 127 && seq(FLD(r, 2), "SIGTERM") && seq(FLD(r, 3), "x"), "OS.run signal", 0);
  r = io_run(os_run(S("/nonexistent/assay-prog"), NIL));
  check(FLD(r, 0) == 2 && FLD(r, 1) == 127 && seq(FLD(r, 3), ""), "OS.run spawn error", 0);
  V exe = io_run(os_executable(sh));
  check(exe != NONE && str_ends_with(FLD(exe, 0), S("/sh")), "OS.executable sh", 0);
  check(io_run(os_executable(S("assay-no-such-program-xyz"))) == NONE, "OS.executable missing", 0);
  V dir = str_append(S(tmp), S("/assay-rt-test-dir"));
  cleanup(dir);
  check(io_run(os_mkdir_new(dir)) == TRUE_V && io_run(os_mkdir_new(dir)) == FALSE_V, "OS.mkdir_new", 0);
  check(io_run(os_mkdir_new(str_append(dir, S("/no/such")))) == FALSE_V, "OS.mkdir_new no parent", 0);
  check(io_run(os_regular(dir)) == FALSE_V, "OS.regular dir", 0);
  V file = str_append(dir, S("/f.txt"));
  V o = io_run(nio_open(file, S("w")));
  check(tag_of(o) == 1, "NativeIO.open w", 0);
  V w = io_run(nio_write_bytes(FLD(o, 0), str_append(S("abc"), S("\xe9z"))));
  check(tag_of(FLD(w, 1)) == 1, "NativeIO.write_bytes", 0);
  io_run(file_close(FLD(o, 0)));
  check(io_run(os_regular(file)) == TRUE_V, "OS.regular file", 0);
  o = io_run(nio_open(file, S("r")));
  V rd = io_run(nio_read_bytes(FLD(o, 0), 3));
  check(tag_of(FLD(rd, 1)) == 1 && seq(FLD(FLD(rd, 1), 0), "abc"), "NativeIO.read_bytes max", 0);
  rd = io_run(nio_read_bytes(FLD(o, 0), 100));
  check(seq(FLD(FLD(rd, 1), 0), "\xe9z"), "NativeIO.read_bytes rest", 0);
  rd = io_run(nio_read_bytes(FLD(o, 0), 100));
  check(seq(FLD(FLD(rd, 1), 0), ""), "NativeIO.read_bytes eof", 0);
  io_run(file_close(FLD(o, 0)));
  V missing = str_append(dir, S("/missing"));
  o = io_run(nio_open(missing, S("r")));
  check(tag_of(o) == 0 && FLD(FLD(o, 0), 0) == 2 &&
            str_eq(FLD(FLD(o, 0), 1), str_concat(CON(S("ENOENT: no such file or directory, open '"),
                                                     CON(missing, CON(S("'"), NIL))))),
        "NativeIO.open ENOENT text", 0);
  cleanup(dir);
  V args = io_run(nio_args());
  check(list_length(args) == NAT_SMALL(2) && seq(FLD(args, 0), "one"), "NativeIO.args", 0);
  check(str_len(io_run(os_root())) > 0, "OS.root", 0);
  V route = clo_new(observe_fn, 1, 0);
  V ins = CON(str_append(S("aaaaaaaaaaaaaaaaaaaa"), S("bbbbbbbbbbbbbbbbbbbbbb")), CON(S("x"), CON(S("y"), NIL)));
  V m = io_run(testperf_measure(ins, route));
  check(FLD(m, 0) == TRUE_V && FLD(m, 1) > 0 && FLD(m, 1) < 4096, "TestPerf.measure ok + bytes", 0);
  m = io_run(testperf_measure(CON(S("x"), NIL), route));
  check(FLD(m, 0) == FALSE_V, "TestPerf.measure needs 3 inputs", 0);
}

/* collector: a list on the stack and a value reachable only from an rt_root slot survive
 * collections forced by 384 MB of garbage under a 256 MB cap; a heap Nat computed once into a
 * rooted static (the c/gen closed-constant form) keeps its value */
static V gc_memo;
static V gc_k;
static int gc_k_ok;
static V gc_k_get(void) {
  return gc_k_ok ? gc_k : (gc_k = nat_add(nat_of_u64(UINT64_MAX), nat_of_u64(UINT64_MAX)), rt_root(&gc_k), gc_k_ok = 1, gc_k);
}
static void gc_tests(int *checks, int *fails) {
  rt_init(0, 0);
  rt_arena_limit((uint64_t)256 << 20);
  V keep = NIL;
  for (uint32_t i = 0; i < 100000; i++) keep = CON(NAT_SMALL(i), keep);
  gc_memo = CON(str_cstr("memo"), NIL);
  rt_root(&gc_memo);
  int k_once = gc_k_get() == gc_k_get() && !NAT_IS_SMALL(gc_k);
  uint64_t runs = rt_gc_runs(), sum = 0, n = 0;
  for (int r = 0; r < 40; r++) {
    V junk = NIL;
    for (int i = 0; i < 400000; i++) junk = CON(NAT_SMALL(i), junk);
  }
  rt_gc();
  for (V p = keep; p != NIL; p = FLD(p, 1)) sum += FLD(p, 0) >> 1, n++;
  V k_want = nat_add(nat_of_u64(UINT64_MAX), nat_of_u64(UINT64_MAX));
  int ok[5] = {rt_gc_runs() > runs + 1, n == 100000 && sum == 4999950000ull, str_eq_lit(FLD(gc_memo, 0), "memo", 4),
               k_once, gc_k_ok && nat_cmp(gc_k_get(), k_want) == 0};
  for (int i = 0; i < 5; i++) {
    ++*checks;
    if (!ok[i]) ++*fails, printf("FAIL gc check %d\n", i);
  }
  rt_arena_limit((uint64_t)2560 << 20);
}

/* Bool lists, least significant bit first: B("1101") is 11 */
static V B(const char *s) {
  V xs = NIL;
  for (size_t i = strlen(s); i-- > 0;) xs = CON(s[i] == '1' ? TRUE_V : FALSE_V, xs);
  return xs;
}

static int bits_is(V xs, const char *s) {
  for (; *s; s++, xs = FLD(xs, 1))
    if (xs == NIL || FLD(xs, 0) != (*s == '1' ? TRUE_V : FALSE_V)) return 0;
  return xs == NIL;
}

static void test_bits(void) {
  char two63[65];
  memset(two63, '0', 63), two63[63] = '1', two63[64] = 0;
  V big = nat_lit("0x1234567890abcdef1234567890abcdef"), lsb = nat_to_bits(big), msb = NIL;
  for (V p = lsb; p != NIL; p = FLD(p, 1)) msb = CON(FLD(p, 0), msb);
  check(bits_to_nat(B("")) == NAT_ZERO && bits_to_nat(B("1101")) == NAT_SMALL(11) &&
            bits_to_nat(B("11010")) == NAT_SMALL(11) &&
            nat_cmp(bits_to_nat(B(two63)), nat_lit("9223372036854775808")) == 0 &&
            nat_cmp(bits_to_nat(lsb), big) == 0 && list_length(lsb) == NAT_SMALL(125),
        "bits_to_nat", "");
  check(nat_to_bits(NAT_ZERO) == NIL && bits_is(nat_to_bits(NAT_SMALL(6)), "011") &&
            bits_is(nat_to_bits(nat_lit("9223372036854775808")), two63),
        "nat_to_bits", "");
  check(bits_is(bits_add(B("11"), B("1"), 0), "001") && bits_is(bits_add(B("10"), B(""), 1), "01") &&
            bits_is(bits_add(B("100"), B("1"), 0), "010") && bits_is(bits_add(B(""), B(""), 1), "1") &&
            bits_add(B(""), B(""), 0) == NIL,
        "bits_add", "");
  check(bits_is(bits_sub(B("001"), B("1"), 0), "11") && bits_sub(B("11"), B("11"), 0) == NIL &&
            bits_is(bits_sub(B("1"), B("01"), 0), "1") && bits_is(bits_sub(B("01"), B(""), 1), "1") &&
            bits_is(bits_sub(B("0"), B("1"), 0), "1") && bits_sub(B(""), B("1"), 0) == NIL,
        "bits_sub", "");
  check(bits_cmp(B("1"), B("01")) == CMP_OF(-1) && bits_cmp(B("0"), B("")) == CMP_OF(1) &&
            bits_cmp(B("101"), B("011")) == CMP_OF(-1) && bits_cmp(B("111"), B("011")) == CMP_OF(1) &&
            bits_cmp(B("011"), B("011")) == CMP_OF(0) && bits_cmp(B(""), B("")) == CMP_OF(0),
        "bits_cmp", "");
  V t = B("101");
  check(bits_is(bits_shl(NAT_SMALL(2), B("1")), "001") && bits_shl(NAT_ZERO, t) == t &&
            bits_is(bits_shl(NAT_SMALL(1), B("")), "0") && bits_trim(t) == t &&
            bits_is(bits_trim(B("1100")), "11") && bits_trim(B("000")) == NIL && bits_trimmed(B("")) &&
            bits_trimmed(t) && !bits_trimmed(B("10")),
        "bits_shl, bits_trim", "");
  V q = bits_divide(B("1101"), B("11")), w = bits_divide(msb, B("0101"));
  check(bits_is(bits_mul(B("11"), B("101")), "1111") && bits_mul(B("0"), B("1")) == NIL &&
            bits_is(bits_mul(B("01"), B("1")), "01") && bits_divide_ok(B("11"), NIL, NIL) &&
            !bits_divide_ok(B("10"), NIL, NIL) && !bits_divide_ok(NIL, NIL, NIL) &&
            !bits_divide_ok(B("1"), B("1"), NIL) && bits_is(FLD(q, 0), "001") && bits_is(FLD(q, 1), "1") &&
            nat_cmp(nat_add(nat_mul(bits_to_nat(FLD(w, 0)), NAT_SMALL(10)), bits_to_nat(FLD(w, 1))), big) == 0 &&
            nat_cmp(bits_to_nat(FLD(w, 1)), NAT_SMALL(10)) < 0,
        "bits_mul, bits_divide", "");
}

/* Big.fits_int and Big.shift_left; the constructor tags are parameters: SmallBig 1, Big 0 here */
static V SB(V neg, V v) { return rt_ctor2(1, neg, v); }
static V BG(V neg, const char *s) { return rt_ctor2(0, neg, B(s)); }
static int fit(V v) { return big_fits_int(v, 1) != FALSE_V; }
static V shl(V v, uint64_t k) { return big_shift_left(v, NAT_SMALL(k), 1, 0); }
static int sb_is(V r, V neg, uint64_t v) { return tag_of(r) == 1 && FLD(r, 0) == neg && nat_cmp(FLD(r, 1), NAT_SMALL(v)) == 0; }
static int bg_is(V r, V neg, const char *s) { return tag_of(r) == 0 && FLD(r, 0) == neg && bits_is(FLD(r, 1), s); }

/* head, then k copies of fill, then tail (bits least significant first) */
static char *bp(char *buf, const char *head, char fill, int k, const char *tail) {
  size_t h = strlen(head);
  memcpy(buf, head, h);
  memset(buf + h, fill, (size_t)k);
  strcpy(buf + h + k, tail);
  return buf;
}

/* Big.hex on a SmallBig{False, v}: the digits printf gives for llx / llX */
static int hex_is(uint64_t v, int upper) {
  char want[24];
  if (upper)
    snprintf(want, sizeof want, "%llX", (unsigned long long)v);
  else
    snprintf(want, sizeof want, "%llx", (unsigned long long)v);
  return str_eq_lit(big_hex_small(SB(FALSE_V, NAT_SMALL(v)), upper ? TRUE_V : FALSE_V), want, strlen(want));
}

static int hex_all(void) {
  int ok = 1;
  for (uint64_t v = 0; v <= 4096; v++) ok &= hex_is(v, (int)(v & 1));
  for (int k = 1; k < 62; k++)
    ok &= hex_is((uint64_t)1 << k, k & 1) & hex_is(((uint64_t)1 << k) - 1, !(k & 1)) &
          hex_is(((uint64_t)1 << k) + 1, k & 1);
  return ok;
}

/* Big.add / Big.sub: a SmallBig operand of Big.add is Big.add_bits on Big{neg, Big.bits.of_nat(v)},
 * so big_add on that Big (the list path) is the reference; Big.sub is Big.add on Big.neg (neg_ref:
 * Big.small or Big.make of the flipped sign). Results compared cell by cell. */
static int cmp_is(V a, V b, int want); /* Session 26 C2 checks (defined before main) */
static int cmp_grid(void);
static int big_same(V x, V y) {
  if (tag_of(x) != tag_of(y) || FLD(x, 0) != FLD(y, 0)) return 0;
  if (tag_of(x) == 1) return nat_cmp(FLD(x, 1), FLD(y, 1)) == 0;
  V p = FLD(x, 1), q = FLD(y, 1);
  for (; p != NIL && q != NIL; p = FLD(p, 1), q = FLD(q, 1))
    if (FLD(p, 0) != FLD(q, 0)) return 0;
  return p == q;
}

static V as_list(V x) { return tag_of(x) == 1 ? rt_ctor2(0, FLD(x, 0), nat_to_bits(FLD(x, 1))) : x; }

static V neg_ref(V x) {
  V n = FLD(x, 0) == FALSE_V ? TRUE_V : FALSE_V, v = FLD(x, 1);
  uint32_t len = 0;
  if (tag_of(x) == 1)
    return nat_cmp(v, NAT_SMALL(BIG_SMALL_LIMIT)) < 0 ? SB(nat_cmp(v, NAT_ZERO) ? n : FALSE_V, v) : rt_ctor2(0, n, nat_to_bits(v));
  for (V p = v; p != NIL; p = FLD(p, 1)) len++;
  if (len >= BIG_SMALL_CELLS) return rt_ctor2(0, n, v);
  v = bits_to_nat(v);
  return SB(nat_cmp(v, NAT_ZERO) ? n : FALSE_V, v);
}

/* xs with pad False bits after the last cell (untrimmed when pad > 0) */
static V pad_bits(V xs, int pad) {
  if (xs != NIL) return CON(FLD(xs, 0), pad_bits(FLD(xs, 1), pad));
  for (; pad > 0; pad--) xs = CON(FALSE_V, xs);
  return xs;
}

/* SmallBig x + (or -) SmallBig y: the signed sum, a SmallBig below BIG_SMALL_LIMIT (zero not negative), else a Big */
static int add_small_is(int64_t x, int64_t y, int sub) {
  int64_t s = sub ? x - y : x + y;
  uint64_t m = (uint64_t)(s < 0 ? -s : s);
  V neg = s < 0 ? TRUE_V : FALSE_V, a = SB(x < 0 ? TRUE_V : FALSE_V, NAT_SMALL((uint64_t)(x < 0 ? -x : x))),
    b = SB(y < 0 ? TRUE_V : FALSE_V, NAT_SMALL((uint64_t)(y < 0 ? -y : y)));
  V want = m < BIG_SMALL_LIMIT ? SB(neg, NAT_SMALL(m)) : rt_ctor2(0, neg, nat_to_bits(NAT_SMALL(m)));
  return big_same(sub ? big_sub(a, b, 1, 0) : big_add(a, b, 1, 0), want);
}

static int add_small_grid(void) {
  static const int64_t xs[] = {0, 1, 2, 3, 255, 256, 1 << 23, (1 << 24) - 2, (1 << 24) - 1, 1 << 24, (1 << 24) + 1, (int64_t)1 << 40,
                                   (int64_t)1 << 61, ((int64_t)1 << 62) - 2, ((int64_t)1 << 62) - 1};
  int ok = 1, n = (int)(sizeof xs / sizeof *xs);
  for (int i = 0; i < 2 * n; i++)
    for (int j = 0; j < 2 * n; j++) {
      int64_t x = i < n ? xs[i] : -xs[i - n], y = j < n ? xs[j] : -xs[j - n];
      ok &= add_small_is(x, y, 0) & add_small_is(x, y, 1);
    }
  return ok;
}

static int add_grid(void) {
  static const uint64_t mags[] = {0, 1, 2, 3, 5, 255, 256, 1u << 23, (1u << 24) - 2, (1u << 24) - 1, 1u << 24, (1u << 24) + 1,
                                  1ull << 40, (1ull << 62) - 2, (1ull << 62) - 1};
  static const uint64_t vals[] = {0, 1, 5, (1u << 24) - 1, 1u << 24, (1u << 24) + 1, (1u << 25) - 1, 1u << 25,
                                  (1u << 25) + (1u << 24), (1ull << 40) + 12345, (1ull << 62) - 1, 1ull << 62, (1ull << 62) + 1};
  V smalls[32], bigs[80];
  int ns = 0, nb = 0, ok = 1;
  for (int s = 0; s < 2; s++) {
    V neg = s ? TRUE_V : FALSE_V;
    for (size_t i = 0; i < sizeof mags / sizeof *mags; i++) smalls[ns++] = SB(neg, NAT_SMALL(mags[i]));
    smalls[ns++] = SB(neg, nat_lit("18446744073709551616"));
    for (size_t i = 0; i < sizeof vals / sizeof *vals; i++)
      for (int pad = 0; pad < 5; pad += 2) bigs[nb++] = rt_ctor2(0, neg, pad_bits(nat_to_bits(NAT_SMALL(vals[i])), pad));
    bigs[nb++] = rt_ctor2(0, neg, nat_to_bits(nat_lit("18446744073709551616")));
  }
  for (int i = 0; i < ns; i++)
    for (int j = 0; j < nb; j++) {
      V x = smalls[i], y = bigs[j];
      ok &= big_same(big_add(x, y, 1, 0), big_add(as_list(x), y, 1, 0)) & big_same(big_add(y, x, 1, 0), big_add(y, as_list(x), 1, 0));
      ok &= big_same(big_sub(x, y, 1, 0), big_add(x, neg_ref(y), 1, 0)) & big_same(big_sub(y, x, 1, 0), big_add(y, neg_ref(x), 1, 0));
    }
  for (int i = 0; i < nb; i++)
    for (int j = 0; j < nb; j++) ok &= big_same(big_sub(bigs[i], bigs[j], 1, 0), big_add(bigs[i], neg_ref(bigs[j]), 1, 0));
  for (int i = 0; i < ns; i++)
    for (int j = 0; j < ns; j++) ok &= big_same(big_sub(smalls[i], smalls[j], 1, 0), big_add(smalls[i], neg_ref(smalls[j]), 1, 0));
  return ok;
}

/* (a) a wide SmallBig (magnitude in [2^24, 2^62)) against the integer of R's 2^24 world (logs/T.md
 * Session 27 item 4): SmallBig{neg, m}, zero not negative */
static int wide_is(V r, int neg, uint64_t m) { return big_same(r, SB(neg && m ? TRUE_V : FALSE_V, NAT_SMALL(m))); }

static int shr_grid(void) {
  static const uint64_t ks[] = {0, 31, 32, 61, 62, 200}, want[] = {(1ull << 61) + 5, 1ull << 30, 1ull << 29, 1, 0, 0};
  int ok = 1;
  for (int s = 0; s < 2; s++)
    for (int i = 0; i < 6; i++)
      ok &= wide_is(big_shift_right_wide(SB(s ? TRUE_V : FALSE_V, NAT_SMALL((1ull << 61) + 5)), NAT_SMALL(ks[i]), 1), s, want[i]);
  return ok;
}

static int unsigned_grid(void) {
  static const uint64_t ws[] = {0, 8, 24, 32, 61, 62, 63}, ms[] = {1ull << 40, (1ull << 40) + 0x123456789ull};
  static const uint64_t want[2][7] = {{0, 0, 0, 0, 1ull << 40, 1ull << 40, 1ull << 40},
                                      {0, 0x89, 0x456789, 0x23456789, (1ull << 40) + 0x123456789ull,
                                       (1ull << 40) + 0x123456789ull, (1ull << 40) + 0x123456789ull}};
  int ok = 1;
  for (int j = 0; j < 2; j++)
    for (int i = 0; i < 7; i++) ok &= wide_is(big_unsigned_wide(NAT_SMALL(ws[i]), SB(FALSE_V, NAT_SMALL(ms[j])), 1), 0, want[j][i]);
  return ok;
}

static int signed_grid(void) {
  static const uint64_t ws[] = {25, 40, 41, 42, 63, 64};
  V p = SB(FALSE_V, NAT_SMALL(1ull << 40)), n = SB(TRUE_V, NAT_SMALL(1ull << 40));
  int ok = wide_is(big_signed_wide(NAT_SMALL(25), p, 1), 0, (1ull << 40) - (1ull << 25)) &&
           wide_is(big_signed_wide(NAT_SMALL(40), p, 1), 0, 0) && wide_is(big_signed_wide(NAT_SMALL(41), p, 1), 1, 1ull << 40) &&
           big_signed_wide(NAT_SMALL(42), p, 1) == p && big_signed_wide(NAT_SMALL(63), p, 1) == p &&
           big_signed_wide(NAT_SMALL(64), p, 1) == p;
  for (int i = 0; i < 6; i++) ok &= big_signed_wide(NAT_SMALL(ws[i]), n, 1) == n;
  return ok;
}

static void test_big(void) {
  V F = FALSE_V, T = TRUE_V, lim = nat_lit("4611686018427387904"), two64 = nat_lit("18446744073709551616");
  char b[80], b2[80];
  check(fit(SB(F, NAT_ZERO)) && fit(SB(T, NAT_ZERO)) && fit(SB(T, NAT_SMALL(5))) && fit(SB(F, NAT_SMALL(BIG_SMALL_LIMIT - 1))),
        "big_fits_int SmallBig", "");
  check(big_hex_ok(SB(F, NAT_ZERO), 1) && big_hex_ok(SB(F, NAT_SMALL(255)), 1) && !big_hex_ok(SB(T, NAT_SMALL(255)), 1) &&
            !big_hex_ok(SB(F, two64), 1) && !big_hex_ok(BG(F, "1111"), 1),
        "big_hex_ok: SmallBig{False, small Nat} only", "");
  check(hex_all(), "big_hex_small digits = printf llx / llX (0..4096, 2^k, 2^k - 1, 2^k + 1)", "");
  check(str_eq_lit(big_hex_small(SB(F, NAT_SMALL(0xa5)), F), "a5", 2) && str_eq_lit(big_hex_small(SB(F, NAT_ZERO), T), "0", 1) &&
            str_eq_lit(big_hex_small(SB(F, NAT_SMALL(0xbeef)), T), "BEEF", 4),
        "big_hex_small a5, 0, BEEF", "");
  {
    V one = SB(F, NAT_SMALL(1)), m1 = SB(T, NAT_SMALL(1)), lim1 = NAT_SMALL(BIG_SMALL_LIMIT - 1);
    V P62 = rt_ctor2(0, F, nat_to_bits(NAT_SMALL(BIG_SMALL_LIMIT))), N62 = rt_ctor2(0, T, nat_to_bits(NAT_SMALL(BIG_SMALL_LIMIT)));
    V L63 = rt_ctor2(0, F, nat_to_bits(NAT_SMALL((1ull << 63) - 1))), P63 = rt_ctor2(0, F, nat_to_bits(nat_lit("9223372036854775808")));
    check(big_same(big_add(L63, one, 1, 0), P63) && big_same(big_add(one, L63, 1, 0), P63),
          "big_add carry through 63 bits: Big 2^63 - 1 + 1 = Big 2^63", "");
    check(big_same(big_sub(P63, one, 1, 0), L63) && big_same(big_add(P63, m1, 1, 0), L63) &&
              big_same(big_sub(m1, P63, 1, 0), rt_ctor2(0, T, nat_to_bits(nat_lit("9223372036854775809")))),
          "big_sub borrow through 63 bits: Big 2^63 - 1 = Big 2^63 - 1", "");
    check(big_same(big_add(P62, m1, 1, 0), SB(F, lim1)) && big_same(big_add(N62, one, 1, 0), SB(T, lim1)),
          "big_add Big 2^62 + SmallBig -1 = SmallBig 2^62 - 1 (and the negation)", "");
    check(big_same(big_add(rt_ctor2(0, T, nat_to_bits(NAT_SMALL(5))), SB(F, NAT_SMALL(5)), 1, 0), SB(F, NAT_ZERO)) &&
              big_same(big_sub(SB(T, NAT_ZERO), SB(F, NAT_ZERO), 1, 0), SB(F, NAT_ZERO)) &&
              big_same(big_add(SB(T, NAT_ZERO), SB(F, NAT_SMALL(5)), 1, 0), SB(F, NAT_SMALL(5))),
          "big_add / big_sub zero: equal magnitudes and SmallBig 0 give SmallBig{False, 0}", "");
    check(big_same(big_add(SB(F, lim1), one, 1, 0), P62) && big_same(big_sub(SB(T, lim1), one, 1, 0), N62) &&
              big_same(big_add(SB(F, NAT_SMALL(BIG_SMALL_LIMIT - 2)), one, 1, 0), SB(F, lim1)) &&
              big_same(big_add(SB(F, NAT_SMALL((1u << 24) - 1)), one, 1, 0), SB(F, NAT_SMALL(1u << 24))),
          "big_add / big_sub SmallBig limit: 2^62 - 1 + 1 = Big 2^62, -(2^62 - 1) - 1 = Big -2^62 (2^24 a SmallBig)", "");
    check(big_same(big_sub(SB(F, NAT_ZERO), P62, 1, 0), N62) && big_same(big_sub(one, SB(T, lim1), 1, 0), P62) &&
              big_same(big_sub(SB(F, NAT_ZERO), rt_ctor2(0, F, nat_to_bits(lim1)), 1, 0), SB(T, lim1)),
          "big_sub inline Big.neg at 2^62: a Big of 63 cells stays a Big, a Big of 62 cells reads as a SmallBig", "");
    check(add_small_grid(), "big_add / big_sub SmallBig pairs = signed sums (magnitudes to 2^62 - 1)", "");
    check(add_grid(), "big_add / big_sub with a Big = Big.add_bits on Big.bits.of_nat (untrimmed lists, 2^64)", "");
  }
  check(fit(SB(F, nat_lit("4611686018427387903"))) && !fit(SB(F, lim)) && fit(SB(T, lim)) &&
            !fit(SB(T, nat_lit("4611686018427387905"))) && !fit(SB(F, two64)) && !fit(SB(T, two64)),
        "big_fits_int SmallBig 2^62 edges", "");
  check(fit(BG(F, bp(b, "", '1', 62, ""))) && fit(BG(T, bp(b, "", '1', 62, ""))) && !fit(BG(F, bp(b, "", '0', 62, "1"))) &&
            fit(BG(T, bp(b, "", '0', 62, "1"))) && !fit(BG(T, bp(b, "1", '0', 61, "1"))) &&
            !fit(BG(F, bp(b, "1", '0', 61, "1"))),
        "big_fits_int Big 2^62 edges", "");
  check(fit(BG(F, bp(b, "", '1', 62, "0"))) && fit(BG(T, bp(b, "", '1', 62, "0"))) &&
            !fit(BG(F, bp(b, "", '0', 62, "10"))) && !fit(BG(T, bp(b, "", '0', 62, "10"))) && fit(BG(F, "1000")) &&
            fit(BG(F, "")) && fit(BG(T, "")) && fit(BG(T, "000")),
        "big_fits_int untrimmed and zero", "");
  check(big_bound_ok(SB(F, NAT_ZERO), 1) && big_bound_ok(SB(T, NAT_SMALL(5)), 1) && big_bound_ok(SB(F, two64), 1) &&
            big_bound_ok(BG(F, ""), 1) && big_bound_ok(BG(T, "000"), 1) && big_bound_ok(BG(F, bp(b, "", '1', 62, "")), 1) &&
            big_bound_ok(BG(T, bp(b, "", '0', 61, "1")), 1),
        "big_bound_ok: SmallBig and Big under 63 cells (NativeInt.bound returns the argument)", "");
  check(!big_bound_ok(BG(F, bp(b, "", '1', 62, "1")), 1) && !big_bound_ok(BG(T, bp(b, "", '0', 62, "1")), 1) &&
            !big_bound_ok(BG(F, bp(b, "", '0', 63, "")), 1) && !big_bound_ok(BG(F, bp(b, "", '1', 70, "")), 1),
        "big_bound_ok: Big at 63 cells or more (NativeInt.bound: the Bend body, Big.wrap)", "");
  check(cmp_is(SB(F, NAT_SMALL(1)), BG(F, "10"), -1) && cmp_is(BG(F, "10"), SB(F, NAT_SMALL(1)), 1) &&
            cmp_is(SB(F, NAT_ZERO), BG(F, ""), 0) && cmp_is(SB(F, NAT_ZERO), BG(F, "0"), -1) &&
            cmp_is(SB(F, nat_lit("4611686018427387903")), BG(F, bp(b, "", '0', 62, "1")), -1) &&
            cmp_is(SB(F, lim), BG(F, bp(b, "", '0', 62, "1")), 0) && cmp_is(SB(F, two64), BG(F, bp(b, "", '0', 64, "1")), 0) &&
            cmp_is(SB(F, two64), BG(F, bp(b, "", '0', 64, "10")), -1),
        "big_cmp SmallBig / Big: Big.bits.of_nat length first (untrimmed lists), then the top bit", "");
  check(cmp_is(SB(T, NAT_ZERO), SB(F, NAT_ZERO), -1) && cmp_is(SB(F, NAT_ZERO), SB(T, NAT_ZERO), 1) &&
            cmp_is(SB(T, NAT_SMALL(5)), BG(T, "101"), 0) && cmp_is(SB(T, NAT_SMALL(5)), BG(T, "011"), 1) &&
            cmp_is(SB(F, NAT_SMALL(5)), BG(F, "011"), -1) && cmp_is(BG(F, "1"), SB(T, NAT_SMALL(7)), 1) &&
            cmp_is(BG(T, ""), SB(F, NAT_ZERO), -1) && cmp_is(SB(T, NAT_SMALL(3)), SB(T, NAT_SMALL(2)), -1),
        "big_cmp signs: True False is LT, False True is GT, True True flips (zero keeps its sign)", "");
  check(cmp_grid(), "big_cmp = Big.cmp on Big.bits.of_nat lists (every pair of a SmallBig / Big grid)", "");
  check(sb_is(shl(SB(F, NAT_ZERO), 100), F, 0) && sb_is(shl(SB(T, NAT_ZERO), 3), F, 0) &&
            sb_is(shl(SB(T, NAT_SMALL(5)), 2), T, 20) && sb_is(shl(SB(F, NAT_SMALL(1)), 23), F, 1 << 23) &&
            sb_is(shl(SB(F, NAT_SMALL(3)), 22), F, 3 << 22) && sb_is(shl(SB(F, NAT_SMALL(7)), 0), F, 7) &&
            sb_is(shl(SB(F, NAT_SMALL(1)), 61), F, 1ull << 61) && sb_is(shl(SB(T, NAT_SMALL(3)), 60), T, 3ull << 60) &&
            sb_is(shl(SB(F, NAT_SMALL(1)), 24), F, 1u << 24) && sb_is(shl(SB(T, NAT_SMALL((1 << 24) - 1)), 1), T, ((1u << 24) - 1) << 1),
        "big_shift_left SmallBig under 63 bits (to 62 bits: 2^61, 3 * 2^60; 2^24 and 2^25 - 2 are SmallBig)", "");
  check(bg_is(shl(SB(F, NAT_SMALL(1)), 62), F, bp(b, "", '0', 62, "1")) &&
            bg_is(shl(SB(T, NAT_SMALL(3)), 61), T, bp(b, "", '0', 61, "11")) &&
            bg_is(shl(SB(F, NAT_SMALL(1)), 70), F, bp(b, "", '0', 70, "1")) &&
            bg_is(shl(SB(T, NAT_SMALL(BIG_SMALL_LIMIT - 1)), 1), T, bp(b, "0", '1', 62, "")),
        "big_shift_left SmallBig at 63 bits", "");
  check(bg_is(shl(BG(F, bp(b, "", '0', 62, "1")), 1), F, bp(b2, "", '0', 63, "1")) &&
            bg_is(shl(BG(T, bp(b, "", '0', 62, "100")), 0), T, bp(b2, "", '0', 62, "1")) &&
            sb_is(shl(BG(F, bp(b, "", '0', 24, "1")), 1), F, 1u << 25) &&
            sb_is(shl(BG(F, "1000"), 1), F, 2) && sb_is(shl(BG(T, "000"), 5), F, 0) && sb_is(shl(BG(T, ""), 4), F, 0) &&
            sb_is(shl(BG(T, bp(b, "", '1', 23, "00")), 1), T, ((1 << 23) - 1) << 1),
        "big_shift_left Big and untrimmed", "");
  check(!big_wide(SB(F, NAT_SMALL((1 << 24) - 1)), 1) && big_wide(SB(T, NAT_SMALL(1 << 24)), 1) &&
            big_wide(SB(F, NAT_SMALL(BIG_SMALL_LIMIT - 1)), 1) && !big_wide(SB(F, NAT_SMALL(BIG_SMALL_LIMIT)), 1) &&
            !big_wide(SB(F, two64), 1) && !big_wide(BG(F, bp(b, "", '0', 40, "1")), 1),
        "big_wide: a SmallBig of a small Nat in [2^24, 2^62) (else the Bend body: {bend})", "");
  check(big_wide_pos(SB(F, NAT_SMALL(1ull << 40)), 1) && !big_wide_pos(SB(T, NAT_SMALL(1ull << 40)), 1) &&
            !big_wide_pos(SB(F, NAT_SMALL(255)), 1) && big_signed_ok(NAT_SMALL(25), SB(T, NAT_SMALL(1ull << 40)), 1) &&
            !big_signed_ok(NAT_SMALL(24), SB(F, NAT_SMALL(1ull << 40)), 1) &&
            !big_signed_ok(NAT_SMALL(40), SB(F, NAT_SMALL(5)), 1),
        "big_wide_pos (Big.unsigned: not negative) and big_signed_ok (Big.signed: width >= 25), else {bend}", "");
  check(shr_grid(), "big_shift_right_wide: 2^61 + 5 >> 0, 31, 32, 61, 62, 200 (both signs, zero not negative)", "");
  check(unsigned_grid(), "big_unsigned_wide: 2^40 and 2^40 + 0x123456789 at widths 0, 8, 24, 32, 61, 62, 63", "");
  check(signed_grid(), "big_signed_wide: 2^40 and -(2^40) at widths 25, 40, 41, 42, 63, 64", "");
  V x = B("1111"), y = B("0011"), r = bits_sub(x, B("1"), 0), q = bits_add(B("1"), y, 0);
  check(bits_is(r, "0111") && FLD(r, 1) == FLD(x, 1) && bits_is(q, "1011") && FLD(q, 1) == FLD(y, 1) &&
            bits_is(bits_sub(y, B("1"), 0), "1101") && bits_is(bits_sub(B("1100"), B("1"), 0), "01") &&
            bits_sub(B("1000"), B("1"), 0) == NIL && bits_is(bits_add(B("1"), B("100"), 0), "010") &&
            bits_is(bits_add(B("11"), B("1"), 0), "001") && bits_is(bits_sub(B("0101"), B("1"), 0), "1001"),
        "bits_add, bits_sub share the rest", "");
}

/* Big.cmp as the Bend text reads it (Big.cmp_small, Big.cmp_bits), with Big.bits.of_nat lists */
static int cmp_ref(V a, V b) {
  int an = FLD(a, 0) != FALSE_V, bn = FLD(b, 0) != FALSE_V, c;
  V xs = tag_of(a) == 1 ? nat_to_bits(FLD(a, 1)) : FLD(a, 1), ys = tag_of(b) == 1 ? nat_to_bits(FLD(b, 1)) : FLD(b, 1);
  if (an != bn) return an ? -1 : 1;
  c = tag_of(a) == 1 && tag_of(b) == 1 ? nat_cmp(FLD(a, 1), FLD(b, 1)) : (int)bits_cmp(xs, ys) - 1;
  c = (c > 0) - (c < 0);
  return an ? -c : c;
}
static int cmp_is(V a, V b, int want) { return big_cmp(a, b, 1) == CMP_OF(want) && cmp_ref(a, b) == want; }
/* every ordered pair of a SmallBig / Big grid (signs, zero, untrimmed lists, 2^24 to 2^64): the
 * C body against cmp_ref, both ways */
static int cmp_grid(void) {
  char b[80];
  V F = FALSE_V, T = TRUE_V, g[22];
  int n = 0, ok = 1;
  g[n++] = SB(F, NAT_ZERO); g[n++] = SB(T, NAT_ZERO); g[n++] = SB(F, NAT_SMALL(1)); g[n++] = SB(T, NAT_SMALL(1));
  g[n++] = SB(F, NAT_SMALL(5)); g[n++] = SB(T, NAT_SMALL(5)); g[n++] = SB(F, NAT_SMALL((1u << 24) - 1));
  g[n++] = SB(F, nat_lit("1099511627776")); g[n++] = SB(T, nat_lit("4611686018427387903"));
  g[n++] = SB(F, nat_lit("18446744073709551616")); g[n++] = BG(F, ""); g[n++] = BG(T, ""); g[n++] = BG(F, "000");
  g[n++] = BG(F, "1"); g[n++] = BG(F, "10"); g[n++] = BG(T, "101"); g[n++] = BG(F, "0001");
  g[n++] = BG(F, bp(b, "", '1', 62, "")); g[n++] = BG(F, bp(b, "", '1', 62, "0")); g[n++] = BG(T, bp(b, "", '0', 62, "1"));
  g[n++] = BG(F, bp(b, "", '0', 64, "1")); g[n++] = BG(F, bp(b, "1", '0', 23, "1"));
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      ok &= big_cmp(g[i], g[j], 1) == CMP_OF(cmp_ref(g[i], g[j])) && big_cmp(g[j], g[i], 1) == CMP_OF(-cmp_ref(g[i], g[j]));
  return ok && n == 22;
}

int main(void) {
  char *argv[] = {"runtime_test", "one", "two", NULL};
  rt_init(3, argv);
  const char *tmp = getenv("TMPDIR");
  char buf[1024];
  snprintf(buf, sizeof buf, "%s", tmp && *tmp ? tmp : "/tmp");
  size_t n = strlen(buf);
  if (n > 1 && buf[n - 1] == '/') buf[n - 1] = 0;
  test_nat();
  test_str();
  test_list();
  test_bits();
  test_big();
  test_closure_io();
  test_paths();
  test_os(buf);
  gc_tests(&checks, &fails);
  printf("runtime_test: %d checks, %d failed, arena %llu bytes\n", checks, fails,
         (unsigned long long)rt_arena_bytes());
  if (!fails) printf("ALL GREEN\n");
  return fails != 0;
}

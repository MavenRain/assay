/* assay.h: runtime for the C host of assay (generated from the Bend 2 host by bend2c.py).
 * Spec: K/BUILTINS.md `## C representation`. All values are one word `V`.
 *  - Immediate: U32, Char (code), Bool (0/1), Cmp (LT 0, EQ 1, GT 2), Unit (0), File (fd),
 *    every nullary constructor (its index). Immediates are below IMM_LIMIT when they are
 *    constructor values, so tag_of() can tell them from objects.
 *  - Nat: small n < 2^63 is (n << 1) | 1; larger n is a Big object (low bit 0).
 *  - Objects live in a bump arena (never freed): constructors {tag, n, f[n]}, Big, Str,
 *    closures {fn, arity, env} and partial applications. */
#ifndef ASSAY_H
#define ASSAY_H
#include <stddef.h>
#include <stdint.h>

typedef uintptr_t V;
typedef V (*Fn)(V *env, V *args);

#define IMM_LIMIT 4096u
enum { TAG_BIG = 0x7f000001u, TAG_STR, TAG_CAT, TAG_CLO, TAG_PAP, TAG_RAW, TAG_FREE };

typedef struct Obj { uint32_t tag, n; V f[]; } Obj;
typedef struct Big { uint32_t tag, n; uint32_t d[]; } Big;
typedef struct Str { uint32_t tag, len; union { const uint8_t *p; V lr[2]; } u; } Str;
typedef struct Clo { uint32_t tag, nenv; Fn fn; uint32_t arity, pad; V env[]; } Clo;
typedef struct Pap { uint32_t tag, n; V clo; V args[]; } Pap;

/* ---- arena ---- */
extern uint8_t *rt_hp, *rt_hl;
void *rt_alloc_slow(size_t n);
static inline void *rt_alloc(size_t n) {
  n = (n + 7) & ~(size_t)7;
  if ((size_t)(rt_hl - rt_hp) < n) return rt_alloc_slow(n);
  void *p = rt_hp;
  rt_hp += n;
  return p;
}
uint64_t rt_arena_bytes(void);
/* collector roots: a static slot (memo value, nat literal pool) or a malloc'd V array */
void rt_root(V *slot);
void rt_roots_push(V **base, size_t *len);
void rt_roots_pop(void);
void rt_gc(void);
uint64_t rt_gc_runs(void);
void rt_arena_limit(uint64_t bytes);
void rt_panic(const char *msg);
void rt_init(int argc, char **argv);

/* ---- constructors ---- */
#define UNIT ((V)0)
#define FALSE_V ((V)0)
#define TRUE_V ((V)1)
#define NIL ((V)0)
#define NONE ((V)0)
#define FLD(v, i) (((Obj *)(v))->f[i])
static inline uint32_t tag_of(V v) { return v < IMM_LIMIT ? (uint32_t)v : ((Obj *)v)->tag; }
static inline Obj *rt_ctor(uint32_t tag, uint32_t n) {
  Obj *o = (Obj *)rt_alloc(sizeof(Obj) + sizeof(V) * (size_t)n);
  o->tag = tag;
  o->n = n;
  return o;
}
V rt_ctor1(uint32_t tag, V a);
V rt_ctor2(uint32_t tag, V a, V b);
V rt_ctor3(uint32_t tag, V a, V b, V c);
V rt_ctor4(uint32_t tag, V a, V b, V c, V d);
#define CON(h, t) rt_ctor2(1, (h), (t))
#define SOME(x) rt_ctor1(1, (x))
#define FAIL(e) rt_ctor1(0, (e))
#define DONE(x) rt_ctor1(1, (x))
#define PAIR(a, b) rt_ctor2(0, (a), (b))
#define CMP_OF(c) ((V)((c) + 1)) /* c in {-1, 0, 1} */
static inline V cmp_u(V a, V b) { return (V)((a > b) - (a < b) + 1); } /* U32, Bool */

/* ---- Nat (JS BigInt semantics, never negative) ---- */
#define NAT_IS_SMALL(v) ((v) & 1u)
#define NAT_SMALL(n) ((V)(((uint64_t)(n) << 1) | 1u))
#define NAT_ZERO NAT_SMALL(0)
/* (a) the C host SmallBig limit: a SmallBig magnitude is below 2^62, a canonical Big list has 63 cells
 * or more (runtime.c big_small, big_make, big_shift_left, big_sub); R's Bend bodies (JS host) keep 2^24 */
#define BIG_SMALL_LIMIT (1ull << 62)
#define BIG_SMALL_CELLS 63
V nat_of_u64(uint64_t x);
V nat_lit(const char *text); /* decimal, or hex with a 0x prefix */
int nat_cmp(V a, V b);       /* -1, 0, 1 */
int nat_is_zero(V a);
V nat_add(V a, V b);
V nat_sub(V a, V b); /* saturates at 0 */
V nat_mul(V a, V b);
void nat_divmod2(V a, V b, V *q, V *r); /* b = 0 gives (0, a) */
V nat_divmod(V a, V b);                 /* pair (q, r) */
V nat_max(V a, V b);
V nat_pred(V a); /* a - 1, saturating */
V nat_show(V a); /* decimal String */
uint32_t nat_to_u32(V a);       /* a mod 2^32 */
uint64_t nat_to_u64_sat(V a);   /* min(a, 2^64 - 1) */
/* Big.bits kernels (C_DEFS in bend2c.py): Bool lists, least significant bit first */
V bits_to_nat(V xs);
V nat_to_bits(V n);              /* no trailing False */
V bits_add(V xs, V ys, V carry); /* carry: U32 */
V bits_sub(V xs, V ys, V borrow);
V bits_cmp(V xs, V ys);          /* Cmp: the longer list is greater, then by value */
V bits_shl(V n, V bits);
V bits_trim(V xs);
V big_fits_int(V value, uint32_t small_tag); /* Big.fits_int */
int big_bound_ok(V value, uint32_t small_tag); /* NativeInt.bound: the argument is the value */
V big_cmp(V a, V b, uint32_t small_tag); /* Big.cmp */
V big_small(V neg, V v, uint32_t small_tag, uint32_t big_tag);   /* Big.small (C_DEFS) */
V big_make(V neg, V bits, uint32_t small_tag, uint32_t big_tag); /* Big.make (C_DEFS) */
int big_wide(V value, uint32_t small_tag);                        /* a SmallBig magnitude in [2^24, 2^62) */
int big_wide_pos(V value, uint32_t small_tag);                    /* wide, not negative (Big.unsigned) */
int big_signed_ok(V width, V value, uint32_t small_tag);          /* wide, width >= 25 (Big.signed) */
V big_shift_right_wide(V value, V n, uint32_t small_tag);         /* Big.shift_right of a wide SmallBig */
V big_unsigned_wide(V width, V value, uint32_t small_tag);        /* Big.unsigned of a wide SmallBig */
V big_signed_wide(V width, V value, uint32_t small_tag);          /* Big.signed of a wide SmallBig */
V big_shift_left(V value, V n, uint32_t small_tag, uint32_t big_tag); /* Big.shift_left */
int big_hex_ok(V value, uint32_t small_tag); /* Big.hex: a SmallBig{False, small Nat} */
V big_hex_small(V value, V upper);           /* Big.hex on such a value */
V big_add(V a, V b, uint32_t small_tag, uint32_t big_tag); /* Big.add */
V big_sub(V a, V b, uint32_t small_tag, uint32_t big_tag); /* Big.sub */
int bits_trimmed(V xs);           /* Nil, or the last bit is True */
V bits_mul(V xs, V ys);           /* ys trimmed */
int bits_divide_ok(V divisor, V rem, V quot);
V bits_divide(V bits, V divisor); /* bits most significant first; a Big.Quotient */

/* ---- U32, Char, Bool ---- */
V u32_show(V a);
V u32_shln(V a, V n);
V u32_shrn(V a, V n);

/* ---- strings: latin1 bytes, flat leaf (offset share) or concat node (rope) ---- */
extern Str rt_empty_str;
#define SNIL ((V)&rt_empty_str)
V str_of(const uint8_t *p, size_t len);   /* copies into the arena */
V str_view(const uint8_t *p, size_t len); /* shares p (static or arena bytes) */
V str_cstr(const char *s);
Str *str_flat(V s);
static inline uint32_t str_len(V s) { return ((Str *)s)->len; }
static inline int str_is_nil(V s) { return ((Str *)s)->len == 0; }
V str_head(V s); /* Char code of byte 0 */
V str_tail(V s);
V str_cons(V ch, V s); /* SCon: low 8 bits of the code */
V str_append(V a, V b);
V str_concat(V xs);
V str_join(V xs, V sep);
int str_eq(V a, V b);
int str_eq_lit(V a, const char *p, size_t len);
int str_starts_with(V s, V p);
int str_ends_with(V s, V p);
V str_order(V a, V b); /* Cmp: byte order (Latin1 code order), a prefix first */
V str_reverse(V s);
V str_length(V s); /* Nat */

/* ---- lists ---- */
V list_append(V xs, V ys);
V list_reverse_go(V xs, V acc);
V list_reverse(V xs);
V list_length(V xs); /* Nat */
V list_concat(V xss);
V list_replicate(V n, V x);
static inline int maybe_is_some(V m) { return m != NONE; }
static inline V maybe_default(V m, V d) { return m == NONE ? d : FLD(m, 0); }

/* ---- closures ---- */
V clo_new(Fn fn, uint32_t arity, uint32_t nenv);
#define CLO_ENV(v) (((Clo *)(v))->env)
V apn(V f, uint32_t n, V *xs);
V ap(V f, V x);
V ap2(V f, V a, V b);
V ap3(V f, V a, V b, V c);

/* ---- IO: arity-0 closures run by io_run (a trampoline over bind) ---- */
V io_pure(V x);
V io_bind(V m, V f);
V io_run(V t);

/* ---- native OS layer (os.js, test-os.js); each returns an IO thunk ---- */
V nio_read_bytes(V file, V max);
V nio_write_bytes(V file, V bytes);
V nio_exit(V code);
V nio_args(void);
V nio_stdout(V text);
V nio_die(V code, V text);
V nio_open(V path, V mode);
V os_regular(V path);
V os_mkdir_new(V path);
V os_basename(V path);
V os_root(void);
V os_executable(V name);
V os_run(V program, V args);
V file_close(V file);
V testperf_measure(V inputs, V route);

/* Node posix path rules (pure, exposed for tests) */
V path_basename(V p);
V path_extname(V p);
V path_dirname(V p);
V path_join2(V a, V b);

#endif

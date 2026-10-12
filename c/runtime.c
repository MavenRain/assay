/* runtime.c: hand runtime for the assay C host. OS layer: src/os.js. */
#define _DARWIN_C_SOURCE
#define _GNU_SOURCE
#include "assay.h"
#include <errno.h>
#include <pthread.h>
#include <setjmp.h>
#include <fcntl.h>
#include <signal.h>
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

extern char **environ;

/* ---------------- arena ---------------- */
#define CHUNK ((size_t)64 << 20)
uint8_t *rt_hp, *rt_hl;
static uint64_t bytes_done;
static int rt_argc;
static char **rt_argv;

static void put_err(const char *p, size_t n) {
  while (n) {
    ssize_t k = write(2, p, n);
    if (k < 0 && errno == EINTR) continue;
    if (k <= 0) return;
    p += k;
    n -= (size_t)k;
  }
}

void rt_panic(const char *msg) {
  put_err("assay runtime: ", 15);
  put_err(msg, strlen(msg));
  put_err("\n", 1);
  exit(70);
}

/* Arena cap (ASSAY_ARENA_MB, default 2560): a runaway run stops here, not in swap. */
static uint64_t arena_max = (uint64_t)2560 << 20, arena_mapped;

/* ---------------- allocation profile (ASSAY_PROFILE=1) ----------------
 * Every allocation takes rt_alloc_slow (rt_hl stays at rt_hp). An allocation's tag is read at
 * the next allocation, after its header is written. A site is 5 return addresses from the frame
 * records; K/scratch/prof.py resolves them with nm. The report goes to stderr at exit. The GC
 * runs as in a normal run: span_close puts the real region limit (prof_hl) back first. */
static int prof_on;
static uint8_t *prof_hl, *prof_last;
static size_t prof_last_n;
#define PROF_TAGS 4096
#ifndef PROF_SITES_LG
#define PROF_SITES_LG 16
#endif
#define PROF_SITES (1 << PROF_SITES_LG)
#ifndef PROF_RA
#define PROF_RA 5
#endif
typedef struct { uint64_t key, bytes, count; } ProfTag;
typedef struct { uintptr_t ra[PROF_RA]; uint64_t bytes, count; } ProfSite;
static ProfTag *prof_tag;
static ProfSite *prof_site;
static uint64_t prof_drop_n, prof_drop_bytes; /* samples lost when PROF_SITES is full */

static uint64_t prof_class(const uint8_t *p, size_t n) {
  uint32_t c = 0xffffffffu, t = n >= 8 ? ((const uint32_t *)p)[0] : 0, m = n >= 8 ? ((const uint32_t *)p)[1] : 0;
  if (n >= 8 && t < IMM_LIMIT && 8 + 8 * (size_t)m == n) c = t;
  if (n >= 8 && t == TAG_BIG && ((8 + 4 * (size_t)m + 7) & ~(size_t)7) == n) c = t;
  if (n >= 8 && t >= TAG_STR && t <= TAG_PAP) c = t;
  uint64_t lg = 0;
  while (((uint64_t)1 << (lg + 1)) <= n) lg++;
  return (uint64_t)c << 32 | (n <= 256 ? n : 256 + lg);
}

static void prof_tag_add(uint64_t key, uint64_t bytes) {
  uint64_t h = (key * 0x9E3779B97F4A7C15ull) >> 52;
  while (prof_tag[h].count && prof_tag[h].key != key) h = (h + 1) & (PROF_TAGS - 1);
  prof_tag[h].key = key;
  prof_tag[h].bytes += bytes;
  prof_tag[h].count++;
}

static void prof_note(size_t n) {
  if (prof_last) prof_tag_add(prof_class(prof_last, prof_last_n), prof_last_n);
  prof_last = 0;
  prof_last_n = n;
  uintptr_t ra[PROF_RA] = {0}, *fp = (uintptr_t *)__builtin_frame_address(0), h = 0;
  if (fp) fp = (uintptr_t *)fp[0]; /* skip rt_alloc_slow's own return into rt_alloc */
  for (int i = 0; i < PROF_RA && fp && !((uintptr_t)fp & 7); i++) {
    ra[i] = fp[1];
    h = h * 31 + ra[i];
    fp = (uintptr_t *)fp[0];
  }
  h = (h * 0x9E3779B97F4A7C15ull) >> (64 - PROF_SITES_LG);
  for (int k = 0; k < PROF_SITES; k++, h = (h + 1) & (PROF_SITES - 1)) {
    ProfSite *s = &prof_site[h];
    if (s->count && memcmp(s->ra, ra, sizeof ra)) continue;
    memcpy(s->ra, ra, sizeof ra);
    s->bytes += n;
    s->count++;
    return;
  }
  prof_drop_n++;
  prof_drop_bytes += n;
}

static int prof_cmp_tag(const void *a, const void *b) {
  uint64_t x = ((const ProfTag *)a)->bytes, y = ((const ProfTag *)b)->bytes;
  return (x < y) - (x > y);
}

static void prof_dump(void) {
  if (prof_last) prof_tag_add(prof_class(prof_last, prof_last_n), prof_last_n);
  prof_last = 0;
  qsort(prof_tag, PROF_TAGS, sizeof(ProfTag), prof_cmp_tag);
  fprintf(stderr, "PROF base %p total %llu\n", (void *)&rt_init, (unsigned long long)rt_arena_bytes());
  fprintf(stderr, "PROF dropped %llu bytes %llu\n", (unsigned long long)prof_drop_n, (unsigned long long)prof_drop_bytes);
  for (int i = 0; i < 40 && prof_tag[i].count; i++)
    fprintf(stderr, "PROF tag %u size %llu bytes %llu count %llu\n", (unsigned)(prof_tag[i].key >> 32),
            (unsigned long long)(prof_tag[i].key & 0xffffffffu), (unsigned long long)prof_tag[i].bytes,
            (unsigned long long)prof_tag[i].count);
  for (int i = 0; i < PROF_SITES; i++) {
    ProfSite *s = &prof_site[i];
    if (!s->count) continue;
    fprintf(stderr, "PROF site %llu %llu", (unsigned long long)s->bytes, (unsigned long long)s->count);
    for (int k = 0; k < PROF_RA; k++) fprintf(stderr, " %p", (void *)s->ra[k]);
    fputc('\n', stderr);
  }
}


static void *xmalloc(size_t n) {
  void *p = malloc(n ? n : 1);
  if (!p) rt_panic("out of memory");
  return p;
}

static void *xrealloc(void *p, size_t n) {
  void *q = realloc(p, n ? n : 1);
  if (!q) rt_panic("out of memory");
  return q;
}

/* ---------------- collector ----------------
 * Mark-sweep over the arena chunks. Every allocation starts with a header (tag, n) that gives
 * its size, so a chunk is a sequence of objects and TAG_FREE spans. Roots are conservative: the
 * run thread's stack from the current sp to its top (registers via setjmp), the rt_root slots
 * (memo values, nat literal pool) and the rt_roots_push ranges (io_run's continuation stack).
 * Heap fields are traced by tag, and every candidate word is checked against the chunks, so a
 * stale field or an interior pointer (a string leaf into a byte buffer) is safe. The sweep turns
 * dead runs into TAG_FREE spans, and allocation bumps through the spans. */
typedef struct { uint8_t *base; size_t size; uint64_t *start, *mark; } Chunk;
typedef struct { uint8_t *p; size_t n; } Span;
typedef struct { V **base; size_t *len; } RootRange;
static Chunk *chunks;
static Span *spans;
static RootRange *ranges;
static V **root_slots;
static uint8_t **mstack, *span_base;
static size_t nchunks, chunks_cap, nspans, spans_at, spans_cap, nranges, ranges_cap, nroot_slots, root_slots_cap, msp, mcap;
static uintptr_t heap_lo = UINTPTR_MAX, heap_hi, stack_top;
static uint64_t gc_next = (uint64_t)256 << 20, gc_runs;
static int gc_log;

#define GROW(p, n, cap) \
  if ((n) == (cap)) (p) = xrealloc((p), ((cap) = (cap) ? (cap) * 2 : 64) * sizeof *(p))

void rt_root(V *slot) {
  GROW(root_slots, nroot_slots, root_slots_cap);
  root_slots[nroot_slots++] = slot;
}
void rt_roots_push(V **base, size_t *len) {
  GROW(ranges, nranges, ranges_cap);
  ranges[nranges].base = base;
  ranges[nranges++].len = len;
}
void rt_roots_pop(void) { nranges--; }
uint64_t rt_gc_runs(void) { return gc_runs; }
void rt_arena_limit(uint64_t bytes) { arena_max = bytes; }
uint64_t rt_arena_bytes(void) { return bytes_done + (uint64_t)(rt_hp - span_base); }

static size_t big_bytes(uint32_t n) { return (8 + 4 * (size_t)n + 7) & ~(size_t)7; }

static void put_free(uint8_t *p, size_t n) {
  ((uint32_t *)p)[0] = TAG_FREE;
  ((uint32_t *)p)[1] = (uint32_t)(n >> 3);
}

static uint8_t *raw_alloc(size_t len) {
  uint32_t *h = rt_alloc(8 + len);
  h[0] = TAG_RAW;
  h[1] = (uint32_t)len;
  return (uint8_t *)(h + 2);
}

static size_t obj_size(const uint8_t *o) {
  uint32_t t = ((const uint32_t *)o)[0], n = ((const uint32_t *)o)[1];
  switch (t) {
  case TAG_BIG: return big_bytes(n);
  case TAG_STR:
  case TAG_CAT: return sizeof(Str);
  case TAG_CLO: return sizeof(Clo) + 8 * (size_t)n;
  case TAG_PAP: return sizeof(Pap) + 8 * (size_t)n;
  case TAG_RAW: return (8 + (size_t)n + 7) & ~(size_t)7;
  case TAG_FREE: return 8 * (size_t)n;
  default:
    if (t >= IMM_LIMIT) rt_panic("gc: bad object header");
    return 8 + 8 * (size_t)n;
  }
}

static Chunk *chunk_find(uintptr_t w) {
  size_t lo = 0, hi = nchunks;
  while (lo < hi) {
    size_t m = (lo + hi) / 2;
    if (w < (uintptr_t)chunks[m].base) hi = m;
    else lo = m + 1;
  }
  Chunk *c = lo ? &chunks[lo - 1] : 0;
  return c && w < (uintptr_t)c->base + c->size ? c : 0;
}

static int top_bit(uint64_t x) {
  int r = 0;
  for (int s = 32; s; s >>= 1)
    if (x >> s) {
      r += s;
      x >>= s;
    }
  return r;
}

static void mark_word(uintptr_t w) {
  if (w < heap_lo || w >= heap_hi) return;
  Chunk *c = chunk_find(w);
  if (!c) return;
  size_t i = (w - (uintptr_t)c->base) >> 3, k = i >> 6;
  uint64_t bits = c->start[k] & (~(uint64_t)0 >> (63 - (i & 63)));
  while (!bits) {
    if (!k) return;
    bits = c->start[--k];
  }
  size_t s = k * 64 + (size_t)top_bit(bits);
  uint8_t *o = c->base + s * 8;
  if (((uint32_t *)o)[0] == TAG_FREE || (c->mark[s >> 6] >> (s & 63) & 1)) return;
  c->mark[s >> 6] |= (uint64_t)1 << (s & 63);
  GROW(mstack, msp, mcap);
  mstack[msp++] = o;
}

static void trace(const uint8_t *o) {
  uint32_t t = ((const uint32_t *)o)[0], n = ((const uint32_t *)o)[1];
  const V *f = 0;
  size_t m = 0;
  switch (t) {
  case TAG_BIG:
  case TAG_RAW:
  case TAG_FREE: return;
  case TAG_STR: mark_word((uintptr_t)((const Str *)o)->u.p); return;
  case TAG_CAT: f = ((const Str *)o)->u.lr, m = 2; break;
  case TAG_CLO: f = ((const Clo *)o)->env, m = n; break;
  case TAG_PAP: mark_word(((const Pap *)o)->clo), f = ((const Pap *)o)->args, m = n; break;
  default: f = ((const Obj *)o)->f, m = n; break;
  }
  for (size_t i = 0; i < m; i++) mark_word(f[i]);
}

static void scan_range(const V *p, const V *e) {
  for (; p < e; p++) mark_word(*p);
}

/* close the bump region: its unused tail becomes a TAG_FREE span */
static void span_close(void) {
  if (prof_on) rt_hl = prof_hl, prof_hl = 0;
  if (rt_hp < rt_hl) put_free(rt_hp, (size_t)(rt_hl - rt_hp));
  if (span_base) bytes_done += (uint64_t)(rt_hp - span_base);
  span_base = rt_hp = rt_hl = 0;
}

static void add_span(uint8_t *p, uint8_t *e) {
  put_free(p, (size_t)(e - p));
  if (e - p < 64) return;
  GROW(spans, nspans, spans_cap);
  spans[nspans].p = p;
  spans[nspans++].n = (size_t)(e - p);
}

static void sweep(void) {
  uint64_t live = 0, freed = 0;
  size_t j = 0, spare = 0;
  nspans = spans_at = 0;
  for (size_t i = 0; i < nchunks; i++) {
    Chunk c = chunks[i];
    uint8_t *run = 0, *p = c.base, *e = c.base + c.size;
    while (p < e) {
      size_t sz = obj_size(p), s = (size_t)(p - c.base) >> 3;
      int marked = c.mark[s >> 6] >> (s & 63) & 1;
      if (marked && run) add_span(run, p);
      if (marked) run = 0, live += sz;
      if (!marked && !run) run = p;
      p += sz;
    }
    size_t words = (c.size / 8 + 63) / 64;
    memset(c.start, 0, words * 8);
    memset(c.mark, 0, words * 8);
    if (run == c.base && spare++ >= 2) { /* a whole free chunk: give it back (keep 2) */
      free(c.base), free(c.start), free(c.mark);
      arena_mapped -= c.size, freed += c.size;
      continue;
    }
    if (run) add_span(run, e);
    chunks[j++] = c;
  }
  nchunks = j;
  heap_lo = nchunks ? (uintptr_t)chunks[0].base : UINTPTR_MAX;
  heap_hi = nchunks ? (uintptr_t)chunks[nchunks - 1].base + chunks[nchunks - 1].size : 0;
  gc_next = 2 * live + 4 * CHUNK > ((uint64_t)256 << 20) ? 2 * live + 4 * CHUNK : (uint64_t)256 << 20;
  if (gc_log)
    fprintf(stderr, "gc %llu: live %llu MB, mapped %llu MB, released %llu MB, spans %zu\n", (unsigned long long)gc_runs,
            (unsigned long long)(live >> 20), (unsigned long long)(arena_mapped >> 20),
            (unsigned long long)(freed >> 20), nspans);
}

void rt_gc(void) {
  if (!stack_top) return;
  if (prof_last) prof_tag_add(prof_class(prof_last, prof_last_n), prof_last_n);
  prof_last = 0;
  span_close();
  for (size_t i = 0; i < nchunks; i++) {
    Chunk *c = &chunks[i];
    for (uint8_t *p = c->base, *e = c->base + c->size; p < e; p += obj_size(p)) {
      size_t s = (size_t)(p - c->base) >> 3;
      c->start[s >> 6] |= (uint64_t)1 << (s & 63);
    }
  }
  jmp_buf jb;
  setjmp(jb);
  volatile V here = 0;
  uintptr_t lo = (uintptr_t)&here < (uintptr_t)&jb ? (uintptr_t)&here : (uintptr_t)&jb;
  scan_range((const V *)(lo & ~(uintptr_t)7), (const V *)stack_top);
  scan_range((const V *)&jb, (const V *)(&jb + 1));
  for (size_t i = 0; i < nroot_slots; i++) mark_word(*root_slots[i]);
  for (size_t i = 0; i < nranges; i++) scan_range(*ranges[i].base, *ranges[i].base + *ranges[i].len);
  while (msp) trace(mstack[--msp]);
  gc_runs++;
  sweep();
}

static void chunk_add(uint8_t *c, size_t size) {
  size_t words = (size / 8 + 63) / 64, at = nchunks;
  GROW(chunks, nchunks, chunks_cap);
  while (at && chunks[at - 1].base > c) at--;
  memmove(&chunks[at + 1], &chunks[at], (nchunks - at) * sizeof(Chunk));
  chunks[at].base = c, chunks[at].size = size;
  chunks[at].start = calloc(words, 8);
  chunks[at].mark = calloc(words, 8);
  if (!chunks[at].start || !chunks[at].mark) rt_panic("out of memory");
  nchunks++;
  if ((uintptr_t)c < heap_lo) heap_lo = (uintptr_t)c;
  if ((uintptr_t)c + size > heap_hi) heap_hi = (uintptr_t)c + size;
}

void *rt_alloc_slow(size_t n) {
  if (prof_on) {
    prof_note(n);
    if ((size_t)(prof_hl - rt_hp) >= n) {
      void *p = rt_hp;
      rt_hp += n;
      rt_hl = rt_hp;
      prof_last = p;
      return p;
    }
  }
  for (int collected = 0;; collected = 1) {
    span_close();
    while (spans_at < nspans) {
      Span sp = spans[spans_at++];
      if (sp.n < n) continue;
      span_base = sp.p, rt_hp = sp.p + n, rt_hl = sp.p + sp.n;
      if (prof_on) prof_hl = rt_hl, rt_hl = rt_hp, prof_last = sp.p;
      return sp.p;
    }
    size_t size = n > CHUNK ? n : CHUNK;
    int soft = arena_mapped + size > gc_next, hard = arena_mapped + size > arena_max;
    if (!collected && stack_top && (soft || hard)) {
      rt_gc();
      continue;
    }
    if (hard) rt_panic("arena limit (ASSAY_ARENA_MB) reached");
    uint8_t *c = malloc(size);
    if (!c) rt_panic("out of memory");
    arena_mapped += size;
    chunk_add(c, size);
    span_base = c, rt_hp = c + n, rt_hl = c + size;
    if (prof_on) {
      prof_hl = rt_hl;
      rt_hl = rt_hp;
      prof_last = c;
    }
    return c;
  }
}

V rt_ctor1(uint32_t tag, V a) {
  Obj *o = rt_ctor(tag, 1);
  o->f[0] = a;
  return (V)o;
}
V rt_ctor2(uint32_t tag, V a, V b) {
  Obj *o = rt_ctor(tag, 2);
  o->f[0] = a;
  o->f[1] = b;
  return (V)o;
}
V rt_ctor3(uint32_t tag, V a, V b, V c) {
  Obj *o = rt_ctor(tag, 3);
  o->f[0] = a;
  o->f[1] = b;
  o->f[2] = c;
  return (V)o;
}
V rt_ctor4(uint32_t tag, V a, V b, V c, V d) {
  Obj *o = rt_ctor(tag, 4);
  o->f[0] = a;
  o->f[1] = b;
  o->f[2] = c;
  o->f[3] = d;
  return (V)o;
}

/* ---------------- Nat: small (n << 1 | 1, n < 2^63) or Big (32-bit limbs, little endian) ---------------- */
#define SMALL_LIMIT ((uint64_t)1 << 63)

static Big *big_new(uint32_t n) {
  Big *b = (Big *)rt_alloc(sizeof(Big) + 4 * (size_t)n);
  b->tag = TAG_BIG;
  b->n = n;
  return b;
}

/* Canonical form: every value below 2^63 is small. */
static V big_fin(Big *b) {
  uint32_t n = b->n;
  size_t was = big_bytes(n);
  while (n && !b->d[n - 1]) n--;
  b->n = n;
  if (was > big_bytes(n)) put_free((uint8_t *)b + big_bytes(n), was - big_bytes(n));
  if (n == 0) return NAT_ZERO;
  if (n == 1) return NAT_SMALL(b->d[0]);
  if (n == 2 && b->d[1] < 0x80000000u) return NAT_SMALL(((uint64_t)b->d[1] << 32) | b->d[0]);
  return (V)b;
}

static const uint32_t *limbs(V a, uint32_t *n, uint32_t tmp[2]) {
  if (NAT_IS_SMALL(a)) {
    uint64_t x = (uint64_t)a >> 1;
    tmp[0] = (uint32_t)x;
    tmp[1] = (uint32_t)(x >> 32);
    *n = tmp[1] ? 2 : tmp[0] ? 1 : 0;
    return tmp;
  }
  *n = ((Big *)a)->n;
  return ((Big *)a)->d;
}

V nat_of_u64(uint64_t x) {
  if (x < SMALL_LIMIT) return NAT_SMALL(x);
  Big *b = big_new(2);
  b->d[0] = (uint32_t)x;
  b->d[1] = (uint32_t)(x >> 32);
  return (V)b;
}

int nat_is_zero(V a) { return a == NAT_ZERO; }

int nat_cmp(V a, V b) {
  if (NAT_IS_SMALL(a) && NAT_IS_SMALL(b)) return a < b ? -1 : a > b;
  uint32_t na, nb, ta[2], tb[2];
  const uint32_t *x = limbs(a, &na, ta), *y = limbs(b, &nb, tb);
  if (na != nb) return na < nb ? -1 : 1;
  for (uint32_t i = na; i-- > 0;)
    if (x[i] != y[i]) return x[i] < y[i] ? -1 : 1;
  return 0;
}

V nat_add(V a, V b) {
  if (NAT_IS_SMALL(a) && NAT_IS_SMALL(b)) return nat_of_u64(((uint64_t)a >> 1) + ((uint64_t)b >> 1));
  uint32_t na, nb, ta[2], tb[2];
  const uint32_t *x = limbs(a, &na, ta), *y = limbs(b, &nb, tb);
  if (na < nb) {
    const uint32_t *t = x;
    uint32_t tn = na;
    x = y, na = nb, y = t, nb = tn;
  }
  Big *r = big_new(na + 1);
  uint64_t c = 0;
  for (uint32_t i = 0; i < na; i++) {
    c += (uint64_t)x[i] + (i < nb ? y[i] : 0);
    r->d[i] = (uint32_t)c;
    c >>= 32;
  }
  r->d[na] = (uint32_t)c;
  return big_fin(r);
}

V nat_sub(V a, V b) {
  if (nat_cmp(a, b) <= 0) return NAT_ZERO;
  if (NAT_IS_SMALL(a)) return NAT_SMALL(((uint64_t)a >> 1) - ((uint64_t)b >> 1));
  uint32_t na, nb, ta[2], tb[2];
  const uint32_t *x = limbs(a, &na, ta), *y = limbs(b, &nb, tb);
  Big *r = big_new(na);
  int64_t borrow = 0;
  for (uint32_t i = 0; i < na; i++) {
    int64_t t = (int64_t)x[i] - (int64_t)(i < nb ? y[i] : 0) - borrow;
    r->d[i] = (uint32_t)t;
    borrow = t < 0;
  }
  return big_fin(r);
}

V nat_mul(V a, V b) {
  if (NAT_IS_SMALL(a) && NAT_IS_SMALL(b)) {
    uint64_t x = (uint64_t)a >> 1, y = (uint64_t)b >> 1;
    if (x < 0x80000000u && y < 0x80000000u) return NAT_SMALL(x * y);
  }
  uint32_t na, nb, ta[2], tb[2];
  const uint32_t *x = limbs(a, &na, ta), *y = limbs(b, &nb, tb);
  if (!na || !nb) return NAT_ZERO;
  Big *r = big_new(na + nb);
  memset(r->d, 0, 4 * (size_t)(na + nb));
  for (uint32_t i = 0; i < na; i++) {
    uint64_t c = 0;
    for (uint32_t j = 0; j < nb; j++) {
      c += (uint64_t)x[i] * y[j] + r->d[i + j];
      r->d[i + j] = (uint32_t)c;
      c >>= 32;
    }
    r->d[i + nb] = (uint32_t)c;
  }
  return big_fin(r);
}

static int clz32(uint32_t x) {
  int n = 0;
  while (!(x & 0x80000000u)) x <<= 1, n++;
  return n;
}

/* Knuth algorithm D (Hacker's Delight divmnu): u has m limbs, v has n >= 2 limbs, m >= n. */
static void knuth_d(const uint32_t *u, uint32_t m, const uint32_t *v, uint32_t n, uint32_t *q, uint32_t *r) {
  const uint64_t B = (uint64_t)1 << 32;
  int s = clz32(v[n - 1]);
  uint32_t *vn = xmalloc(4 * (size_t)n), *un = xmalloc(4 * ((size_t)m + 1));
  for (uint32_t i = n - 1; i > 0; i--) vn[i] = (v[i] << s) | (s ? v[i - 1] >> (32 - s) : 0);
  vn[0] = v[0] << s;
  un[m] = s ? u[m - 1] >> (32 - s) : 0;
  for (uint32_t i = m - 1; i > 0; i--) un[i] = (u[i] << s) | (s ? u[i - 1] >> (32 - s) : 0);
  un[0] = u[0] << s;
  for (int64_t j = (int64_t)m - n; j >= 0; j--) {
    uint64_t num = ((uint64_t)un[j + n] << 32) | un[j + n - 1];
    uint64_t qhat = num / vn[n - 1], rhat = num % vn[n - 1];
    while (qhat >= B || qhat * vn[n - 2] > ((rhat << 32) | un[j + n - 2])) {
      qhat--;
      rhat += vn[n - 1];
      if (rhat >= B) break;
    }
    int64_t k = 0, t;
    for (uint32_t i = 0; i < n; i++) {
      uint64_t p = qhat * vn[i];
      t = (int64_t)un[i + j] - k - (int64_t)(p & 0xffffffffu);
      un[i + j] = (uint32_t)t;
      k = (int64_t)(p >> 32) - (t >> 32);
    }
    t = (int64_t)un[j + n] - k;
    un[j + n] = (uint32_t)t;
    q[j] = (uint32_t)qhat;
    if (t < 0) {
      q[j]--;
      k = 0;
      for (uint32_t i = 0; i < n; i++) {
        t = (int64_t)un[i + j] + vn[i] + k;
        un[i + j] = (uint32_t)t;
        k = t >> 32;
      }
      un[j + n] += (uint32_t)k;
    }
  }
  for (uint32_t i = 0; i + 1 < n; i++) r[i] = (un[i] >> s) | (s ? un[i + 1] << (32 - s) : 0);
  r[n - 1] = un[n - 1] >> s;
  free(vn);
  free(un);
}

void nat_divmod2(V a, V b, V *q, V *r) {
  if (nat_is_zero(b) || nat_cmp(a, b) < 0) {
    *q = NAT_ZERO;
    *r = a;
    return;
  }
  if (NAT_IS_SMALL(a) && NAT_IS_SMALL(b)) {
    uint64_t x = (uint64_t)a >> 1, y = (uint64_t)b >> 1;
    *q = NAT_SMALL(x / y);
    *r = NAT_SMALL(x % y);
    return;
  }
  uint32_t na, nb, ta[2], tb[2];
  const uint32_t *x = limbs(a, &na, ta), *y = limbs(b, &nb, tb);
  Big *qq = big_new(na - nb + 1);
  if (nb == 1) {
    uint64_t rem = 0;
    for (uint32_t i = na; i-- > 0;) {
      uint64_t cur = (rem << 32) | x[i];
      qq->d[i] = (uint32_t)(cur / y[0]);
      rem = cur % y[0];
    }
    *q = big_fin(qq);
    *r = NAT_SMALL(rem);
    return;
  }
  Big *rr = big_new(nb);
  knuth_d(x, na, y, nb, qq->d, rr->d);
  *q = big_fin(qq);
  *r = big_fin(rr);
}

V nat_divmod(V a, V b) {
  V q, r;
  nat_divmod2(a, b, &q, &r);
  return PAIR(q, r);
}

V nat_max(V a, V b) { return nat_cmp(a, b) < 0 ? b : a; }
V nat_pred(V a) { return nat_sub(a, NAT_SMALL(1)); }

uint32_t nat_to_u32(V a) { return NAT_IS_SMALL(a) ? (uint32_t)((uint64_t)a >> 1) : ((Big *)a)->d[0]; }

uint64_t nat_to_u64_sat(V a) {
  if (NAT_IS_SMALL(a)) return (uint64_t)a >> 1;
  Big *b = (Big *)a;
  return b->n == 2 ? ((uint64_t)b->d[1] << 32) | b->d[0] : UINT64_MAX;
}

V nat_show(V a) {
  char small[24];
  if (NAT_IS_SMALL(a)) {
    int k = snprintf(small, sizeof small, "%llu", (unsigned long long)((uint64_t)a >> 1));
    return str_of((const uint8_t *)small, (size_t)k);
  }
  Big *b = (Big *)a;
  uint32_t n = b->n;
  uint32_t *t = xmalloc(4 * (size_t)n);
  memcpy(t, b->d, 4 * (size_t)n);
  size_t cap = (size_t)n * 10 + 10, at = cap;
  char *out = xmalloc(cap);
  while (n) {
    uint64_t rem = 0;
    for (uint32_t i = n; i-- > 0;) {
      uint64_t cur = (rem << 32) | t[i];
      t[i] = (uint32_t)(cur / 1000000000u);
      rem = cur % 1000000000u;
    }
    while (n && !t[n - 1]) n--;
    for (int k = 0; k < 9; k++) {
      out[--at] = (char)('0' + rem % 10);
      rem /= 10;
      if (!n && !rem) break;
    }
  }
  V s = str_of((const uint8_t *)out + at, cap - at);
  free(t);
  free(out);
  return s;
}

V nat_lit(const char *text) {
  size_t len = strlen(text);
  uint32_t base = 10;
  if (len > 2 && text[0] == '0' && (text[1] == 'x' || text[1] == 'X')) base = 16, text += 2, len -= 2;
  Big *b = big_new((uint32_t)(len / 2 + 2));
  uint32_t n = 0;
  for (size_t i = 0; i < len; i++) {
    char c = text[i];
    uint32_t d = c >= '0' && c <= '9' ? (uint32_t)(c - '0')
               : c >= 'a' && c <= 'f' ? (uint32_t)(c - 'a' + 10)
               : c >= 'A' && c <= 'F' ? (uint32_t)(c - 'A' + 10) : 99;
    if (c == '_') continue;
    if (d >= base) rt_panic("nat_lit: bad digit");
    uint64_t carry = d;
    for (uint32_t j = 0; j < n; j++) {
      uint64_t cur = (uint64_t)b->d[j] * base + carry;
      b->d[j] = (uint32_t)cur;
      carry = cur >> 32;
    }
    if (carry) b->d[n++] = (uint32_t)carry;
  }
  b->n = n;
  return big_fin(b);
}

/* ---------------- U32 ---------------- */
V u32_show(V a) {
  char buf[16];
  int k = snprintf(buf, sizeof buf, "%u", (unsigned)(uint32_t)a);
  return str_of((const uint8_t *)buf, (size_t)k);
}
V u32_shln(V a, V n) {
  uint64_t s = nat_to_u64_sat(n);
  return s >= 32 ? 0 : (V)(uint32_t)((uint32_t)a << s);
}
V u32_shrn(V a, V n) {
  uint64_t s = nat_to_u64_sat(n);
  return s >= 32 ? 0 : (V)((uint32_t)a >> s);
}

/* ---------------- strings ---------------- */
#define FLAT_MAX 32
Str rt_empty_str = {TAG_STR, 0, {(const uint8_t *)""}};
static uint8_t byte_tab[256];
static Str char_str[256];

static Str *leaf_new(const uint8_t *p, uint32_t len) {
  Str *s = (Str *)rt_alloc(sizeof(Str));
  s->tag = TAG_STR;
  s->len = len;
  s->u.p = p;
  return s;
}

V str_view(const uint8_t *p, size_t len) {
  if (!len) return SNIL;
  if (len > UINT32_MAX) rt_panic("string too long");
  return (V)leaf_new(p, (uint32_t)len);
}

V str_of(const uint8_t *p, size_t len) {
  if (!len) return SNIL;
  uint8_t *b = raw_alloc(len);
  memcpy(b, p, len);
  return str_view(b, len);
}

V str_cstr(const char *s) { return str_of((const uint8_t *)s, strlen(s)); }

/* Flatten a rope in place (the node becomes a leaf); iterative, so deep ropes are safe. */
Str *str_flat(V v) {
  Str *s = (Str *)v;
  if (s->tag == TAG_STR) return s;
  uint8_t *buf = raw_alloc(s->len);
  size_t at = 0, sp = 0, cap = 64;
  V *stack = xmalloc(cap * sizeof(V)), node = v;
  for (;;) {
    Str *t = (Str *)node;
    if (t->tag == TAG_CAT) {
      if (sp == cap) stack = xrealloc(stack, (cap *= 2) * sizeof(V));
      stack[sp++] = t->u.lr[1];
      node = t->u.lr[0];
      continue;
    }
    memcpy(buf + at, t->u.p, t->len);
    at += t->len;
    if (!sp) break;
    node = stack[--sp];
  }
  free(stack);
  s->tag = TAG_STR;
  s->u.p = buf;
  return s;
}

V str_head(V s) { return (V)str_flat(s)->u.p[0]; }

V str_tail(V s) {
  Str *f = str_flat(s);
  return str_view(f->u.p + 1, f->len - 1);
}

V str_append(V a, V b) {
  uint64_t la = str_len(a), lb = str_len(b);
  if (!la) return b;
  if (!lb) return a;
  if (la + lb > UINT32_MAX) rt_panic("string too long");
  if (la + lb <= FLAT_MAX) {
    uint8_t *buf = raw_alloc(la + lb);
    memcpy(buf, str_flat(a)->u.p, la);
    memcpy(buf + la, str_flat(b)->u.p, lb);
    return str_view(buf, la + lb);
  }
  Str *s = (Str *)rt_alloc(sizeof(Str));
  s->tag = TAG_CAT;
  s->len = (uint32_t)(la + lb);
  s->u.lr[0] = a;
  s->u.lr[1] = b;
  return (V)s;
}

V str_cons(V ch, V s) { return str_append((V)&char_str[(uint32_t)ch & 255], s); }

V str_concat(V xs) {
  V acc = SNIL;
  for (V p = xs; p != NIL; p = FLD(p, 1)) acc = str_append(acc, FLD(p, 0));
  return acc;
}

V str_join(V xs, V sep) {
  V acc = SNIL;
  for (V p = xs; p != NIL; p = FLD(p, 1)) acc = str_append(p == xs ? acc : str_append(acc, sep), FLD(p, 0));
  return acc;
}

int str_eq(V a, V b) {
  if (a == b) return 1;
  if (str_len(a) != str_len(b)) return 0;
  return memcmp(str_flat(a)->u.p, str_flat(b)->u.p, str_len(a)) == 0;
}

int str_eq_lit(V a, const char *p, size_t len) {
  return str_len(a) == len && memcmp(str_flat(a)->u.p, p, len) == 0;
}

/* NativeString.order: compare the flat bytes in place (no SCon/leaf per step) */
V str_order(V a, V b) {
  Str *x = str_flat(a), *y = str_flat(b);
  uint32_t n = x->len < y->len ? x->len : y->len;
  int c = n ? memcmp(x->u.p, y->u.p, n) : 0;
  int d = c ? c : (x->len > y->len) - (x->len < y->len);
  return CMP_OF((d > 0) - (d < 0));
}

int str_starts_with(V s, V p) {
  uint32_t lp = str_len(p);
  return lp <= str_len(s) && memcmp(str_flat(s)->u.p, str_flat(p)->u.p, lp) == 0;
}

int str_ends_with(V s, V p) {
  uint32_t lp = str_len(p), ls = str_len(s);
  return lp <= ls && memcmp(str_flat(s)->u.p + (ls - lp), str_flat(p)->u.p, lp) == 0;
}

V str_reverse(V s) {
  Str *f = str_flat(s);
  if (f->len < 2) return s;
  uint8_t *b = raw_alloc(f->len);
  for (uint32_t i = 0; i < f->len; i++) b[i] = f->u.p[f->len - 1 - i];
  return str_view(b, f->len);
}

V str_length(V s) { return NAT_SMALL(str_len(s)); }

/* ---------------- lists ---------------- */
V list_append(V xs, V ys) {
  V head = ys, *slot = &head;
  for (V p = xs; p != NIL; p = FLD(p, 1)) {
    Obj *c = rt_ctor(1, 2);
    c->f[0] = FLD(p, 0);
    *slot = (V)c;
    slot = &c->f[1];
  }
  *slot = ys;
  return head;
}

V list_reverse_go(V xs, V acc) {
  for (V p = xs; p != NIL; p = FLD(p, 1)) acc = CON(FLD(p, 0), acc);
  return acc;
}

V list_reverse(V xs) { return list_reverse_go(xs, NIL); }

V list_length(V xs) {
  uint64_t n = 0;
  for (V p = xs; p != NIL; p = FLD(p, 1)) n++;
  return nat_of_u64(n);
}

V list_concat(V xss) {
  V rev = list_reverse(xss), acc = NIL;
  for (V p = rev; p != NIL; p = FLD(p, 1)) acc = list_append(FLD(p, 0), acc);
  return acc;
}

V list_replicate(V n, V x) {
  uint64_t k = nat_to_u64_sat(n);
  if (k > ((uint64_t)1 << 40)) rt_panic("List.replicate: count too large");
  V acc = NIL;
  while (k--) acc = CON(x, acc);
  return acc;
}

/* ---------------- closures ---------------- */
V clo_new(Fn fn, uint32_t arity, uint32_t nenv) {
  Clo *c = (Clo *)rt_alloc(sizeof(Clo) + sizeof(V) * (size_t)nenv);
  c->tag = TAG_CLO;
  c->nenv = nenv;
  c->fn = fn;
  c->arity = arity;
  c->pad = 0;
  return (V)c;
}

V apn(V f, uint32_t n, V *xs) {
  while (n) {
    if (f < IMM_LIMIT) rt_panic("apply: not a function");
    V clo = f;
    uint32_t have = 0;
    const V *held = NULL;
    if (((Obj *)f)->tag == TAG_PAP) {
      Pap *p = (Pap *)f;
      clo = p->clo, have = p->n, held = p->args;
    } else if (((Obj *)f)->tag != TAG_CLO) {
      rt_panic("apply: not a function");
    }
    Clo *c = (Clo *)clo;
    if (!c->arity) rt_panic("apply: arity 0");
    uint32_t need = c->arity - have;
    if (n < need) {
      Pap *p = (Pap *)rt_alloc(sizeof(Pap) + sizeof(V) * (size_t)(have + n));
      p->tag = TAG_PAP;
      p->n = have + n;
      p->clo = clo;
      if (have) memcpy(p->args, held, sizeof(V) * have);
      memcpy(p->args + have, xs, sizeof(V) * n);
      return (V)p;
    }
    V r;
    if (!have) {
      r = c->fn(c->env, xs);
    } else {
      V buf[c->arity]; /* on the stack: the collector sees it */
      memcpy(buf, held, sizeof(V) * have);
      memcpy(buf + have, xs, sizeof(V) * need);
      r = c->fn(c->env, buf);
    }
    xs += need;
    n -= need;
    f = r;
  }
  return f;
}

V ap(V f, V x) { return apn(f, 1, &x); }
V ap2(V f, V a, V b) {
  V xs[2] = {a, b};
  return apn(f, 2, xs);
}
V ap3(V f, V a, V b, V c) {
  V xs[3] = {a, b, c};
  return apn(f, 3, xs);
}

/* ---------------- IO ---------------- */
static V io_pure_fn(V *env, V *args) { return env[0]; }
static V io_bind_fn(V *env, V *args) { return io_run(ap(env[1], io_run(env[0]))); }

V io_pure(V x) {
  V c = clo_new(io_pure_fn, 0, 1);
  CLO_ENV(c)[0] = x;
  return c;
}

V io_bind(V m, V f) {
  V c = clo_new(io_bind_fn, 0, 2);
  CLO_ENV(c)[0] = m;
  CLO_ENV(c)[1] = f;
  return c;
}

/* Trampoline: left-nested binds push their continuation, so long IO loops use no C stack. */
V io_run(V t) {
  size_t sp = 0, cap = 0;
  V *ks = NULL;
  rt_roots_push(&ks, &sp);
  for (;;) {
    Clo *c = (Clo *)t;
    if (t < IMM_LIMIT || c->tag != TAG_CLO || c->arity) rt_panic("io_run: not an IO action");
    if (c->fn == io_bind_fn) {
      if (sp == cap) ks = xrealloc(ks, (cap = cap ? cap * 2 : 16) * sizeof(V));
      ks[sp++] = c->env[1];
      t = c->env[0];
      continue;
    }
    V r = c->fn(c->env, NULL);
    if (!sp) {
      rt_roots_pop();
      free(ks);
      return r;
    }
    t = ap(ks[--sp], r);
  }
}

static V thunk2(Fn fn, V a, V b) {
  V c = clo_new(fn, 0, 2);
  CLO_ENV(c)[0] = a;
  CLO_ENV(c)[1] = b;
  return c;
}

/* ---------------- native OS layer (os.js) ---------------- */
static const struct { int no; const char *name, *text; } err_tab[] = {
    {EPERM, "EPERM", "operation not permitted"},     {ENOENT, "ENOENT", "no such file or directory"},
    {EIO, "EIO", "i/o error"},                       {EBADF, "EBADF", "bad file descriptor"},
    {EAGAIN, "EAGAIN", "resource temporarily unavailable"}, {ENOMEM, "ENOMEM", "not enough memory"},
    {EACCES, "EACCES", "permission denied"},         {EBUSY, "EBUSY", "resource busy or locked"},
    {EEXIST, "EEXIST", "file already exists"},       {EXDEV, "EXDEV", "cross-device link not permitted"},
    {ENOTDIR, "ENOTDIR", "not a directory"},         {EISDIR, "EISDIR", "illegal operation on a directory"},
    {EINVAL, "EINVAL", "invalid argument"},          {ENFILE, "ENFILE", "file table overflow"},
    {EMFILE, "EMFILE", "too many open files"},       {ETXTBSY, "ETXTBSY", "text file is busy"},
    {EFBIG, "EFBIG", "file too large"},              {ENOSPC, "ENOSPC", "no space left on device"},
    {ESPIPE, "ESPIPE", "invalid seek"},              {EROFS, "EROFS", "read-only file system"},
    {EPIPE, "EPIPE", "broken pipe"},                 {ENAMETOOLONG, "ENAMETOOLONG", "name too long"},
    {ELOOP, "ELOOP", "too many symbolic links encountered"}, {EINTR, "EINTR", "interrupted system call"},
    {ENXIO, "ENXIO", "no such device or address"},
};

/* Node error text: "<CODE>: <libuv text>, <syscall>" plus " '<path>'" when a path is given. */
static V err_msg(int no, const char *syscall, V path) {
  char head[200];
  int k = -1;
  for (size_t i = 0; i < sizeof err_tab / sizeof err_tab[0]; i++)
    if (err_tab[i].no == no) k = snprintf(head, sizeof head, "%s: %s, %s", err_tab[i].name, err_tab[i].text, syscall);
  if (k < 0) k = snprintf(head, sizeof head, "Unknown system error -%d: Unknown system error -%d, %s", no, no, syscall);
  V msg = str_of((const uint8_t *)head, (size_t)k);
  return path ? str_append(str_append(msg, str_append(str_cstr(" '"), path)), str_cstr("'")) : msg;
}

static V io_fail(int no, const char *syscall, V path) {
  return FAIL(PAIR((V)(uint32_t)(no ? no : 5), err_msg(no ? no : 5, syscall, path)));
}

/* NUL-terminated copy of a string, or NULL when it holds a NUL byte (Node rejects those paths). */
static char *cpath(V s) {
  Str *f = str_flat(s);
  if (memchr(f->u.p, 0, f->len)) return NULL;
  char *c = xmalloc((size_t)f->len + 1);
  memcpy(c, f->u.p, f->len);
  c[f->len] = 0;
  return c;
}

static int stat_path(V path, struct stat *st) {
  char *c = cpath(path);
  int ok = c && stat(c, st) == 0;
  free(c);
  return ok;
}

static V read_fn(V *env, V *args) {
  static uint8_t buf[65536];
  uint32_t max = (uint32_t)env[1];
  size_t want = max < sizeof buf ? max : sizeof buf;
  ssize_t k;
  do k = read((int)env[0], buf, want);
  while (k < 0 && errno == EINTR);
  if (k < 0) return PAIR(env[0], io_fail(errno, "read", 0));
  return PAIR(env[0], DONE(str_of(buf, (size_t)k)));
}
V nio_read_bytes(V file, V max) { return thunk2(read_fn, file, max); }

static V write_fn(V *env, V *args) {
  Str *s = str_flat(env[1]);
  size_t at = 0;
  while (at < s->len) {
    ssize_t k = write((int)env[0], s->u.p + at, s->len - at);
    if (k < 0 && errno == EINTR) continue;
    if (k < 0) return PAIR(env[0], io_fail(errno, "write", 0));
    at += (size_t)k;
  }
  return PAIR(env[0], DONE(UNIT));
}
V nio_write_bytes(V file, V bytes) { return thunk2(write_fn, file, bytes); }

/* nativeio_output: retry EAGAIN/EINTR after 1 ms; any other error exits 1 (message to fd 2). */
static void out_all(int fd, V text) {
  Str *s = str_flat(text);
  size_t at = 0;
  while (at < s->len) {
    ssize_t k = write(fd, s->u.p + at, s->len - at);
    if (k > 0) {
      at += (size_t)k;
      continue;
    }
    if (k == 0 || errno == EAGAIN || errno == EINTR) {
      struct timespec ts = {0, 1000000};
      nanosleep(&ts, NULL);
      continue;
    }
    if (fd != 2) out_all(2, str_append(err_msg(errno, "write", 0), str_cstr("\n")));
    exit(1);
  }
}

static V exit_fn(V *env, V *args) { exit((int)(uint32_t)env[0]); }
V nio_exit(V code) { return thunk2(exit_fn, code, 0); }

static V args_fn(V *env, V *args) {
  V xs = NIL;
  for (int i = rt_argc - 1; i >= 1; i--) xs = CON(str_cstr(rt_argv[i]), xs);
  return xs;
}
V nio_args(void) { return thunk2(args_fn, 0, 0); }

static V stdout_fn(V *env, V *args) {
  out_all(1, env[0]);
  return UNIT;
}
V nio_stdout(V text) { return thunk2(stdout_fn, text, 0); }

static V die_fn(V *env, V *args) {
  out_all(2, str_append(env[1], str_cstr("\n")));
  exit((int)(uint32_t)env[0]);
}
V nio_die(V code, V text) { return thunk2(die_fn, code, text); }

static V open_fn(V *env, V *args) {
  Str *m = str_flat(env[1]);
  int flags = m->len == 1 && m->u.p[0] == 'r'   ? O_RDONLY
              : m->len == 1 && m->u.p[0] == 'w' ? O_WRONLY | O_CREAT | O_TRUNC
              : m->len == 1 && m->u.p[0] == 'a' ? O_WRONLY | O_CREAT | O_APPEND
                                                : -1;
  if (flags < 0) rt_panic("NativeIO.open: unsupported mode");
  char *c = cpath(env[0]);
  if (!c)
    return FAIL(PAIR(5, str_cstr("The argument 'path' must be a string, Uint8Array, or URL without null bytes.")));
  int fd;
  do fd = open(c, flags | O_CLOEXEC, 0644);
  while (fd < 0 && errno == EINTR);
  int no = errno;
  free(c);
  return fd < 0 ? io_fail(no, "open", env[0]) : DONE((V)(uint32_t)fd);
}
V nio_open(V path, V mode) { return thunk2(open_fn, path, mode); }

static V close_fn(V *env, V *args) {
  close((int)env[0]);
  return UNIT;
}
V file_close(V file) { return thunk2(close_fn, file, 0); }

static V regular_fn(V *env, V *args) {
  struct stat st;
  return stat_path(env[0], &st) && !S_ISDIR(st.st_mode) ? TRUE_V : FALSE_V;
}
V os_regular(V path) { return thunk2(regular_fn, path, 0); }

static V mkdir_fn(V *env, V *args) {
  struct stat st;
  if (stat_path(env[0], &st)) return FALSE_V;
  if (!stat_path(path_dirname(env[0]), &st) || !S_ISDIR(st.st_mode)) return FALSE_V;
  char *c = cpath(env[0]);
  int ok = c && mkdir(c, 0755) == 0;
  free(c);
  return ok ? TRUE_V : FALSE_V;
}
V os_mkdir_new(V path) { return thunk2(mkdir_fn, path, 0); }

static V basename_fn(V *env, V *args) {
  V base = path_basename(env[0]);
  return str_view(str_flat(base)->u.p, str_len(base) - str_len(path_extname(base)));
}
V os_basename(V path) { return thunk2(basename_fn, path, 0); }

static V root_fn(V *env, V *args) {
  const char *r = getenv("ASSAY_ROOT");
  if (r && *r) return str_cstr(r);
  for (size_t cap = 256;; cap *= 2) {
    char *b = xmalloc(cap);
    if (getcwd(b, cap)) {
      V s = str_cstr(b);
      free(b);
      return s;
    }
    free(b);
    if (errno != ERANGE) rt_panic("OS.root: getcwd failed");
  }
}
V os_root(void) { return thunk2(root_fn, 0, 0); }

static V executable_fn(V *env, V *args) {
  const char *path = getenv("PATH");
  for (const char *p = path ? path : ""; *p;) {
    const char *e = strchr(p, ':');
    size_t n = e ? (size_t)(e - p) : strlen(p);
    if (n) {
      V file = path_join2(str_of((const uint8_t *)p, n), env[0]);
      struct stat st;
      if (stat_path(file, &st) && !S_ISDIR(st.st_mode) && (st.st_mode & 0111)) return SOME(file);
    }
    p += n + (e != NULL);
  }
  return NONE;
}
V os_executable(V name) { return thunk2(executable_fn, name, 0); }

static const struct { int no; const char *name; } sig_tab[] = {
    {SIGHUP, "SIGHUP"},   {SIGINT, "SIGINT"},       {SIGQUIT, "SIGQUIT"},   {SIGILL, "SIGILL"},
    {SIGTRAP, "SIGTRAP"}, {SIGABRT, "SIGABRT"},     {SIGBUS, "SIGBUS"},     {SIGFPE, "SIGFPE"},
    {SIGKILL, "SIGKILL"}, {SIGUSR1, "SIGUSR1"},     {SIGSEGV, "SIGSEGV"},   {SIGUSR2, "SIGUSR2"},
    {SIGPIPE, "SIGPIPE"}, {SIGALRM, "SIGALRM"},     {SIGTERM, "SIGTERM"},   {SIGCHLD, "SIGCHLD"},
    {SIGCONT, "SIGCONT"}, {SIGSTOP, "SIGSTOP"},     {SIGTSTP, "SIGTSTP"},   {SIGTTIN, "SIGTTIN"},
    {SIGTTOU, "SIGTTOU"}, {SIGURG, "SIGURG"},       {SIGXCPU, "SIGXCPU"},   {SIGXFSZ, "SIGXFSZ"},
    {SIGVTALRM, "SIGVTALRM"}, {SIGPROF, "SIGPROF"}, {SIGWINCH, "SIGWINCH"},
#ifdef SIGPOLL
    {SIGPOLL, "SIGPOLL"},
#endif
    {SIGIO, "SIGIO"},     {SIGSYS, "SIGSYS"},
#ifdef SIGEMT
    {SIGEMT, "SIGEMT"},
#endif
#ifdef SIGINFO
    {SIGINFO, "SIGINFO"},
#endif
#ifdef SIGPWR
    {SIGPWR, "SIGPWR"},
#endif
};

static V process(uint32_t kind, uint32_t code, V signal, V output) {
  return rt_ctor4(0, (V)kind, (V)code, signal, output);
}

/* spawnSync(program, argv, {stdio: [inherit, pipe, inherit], maxBuffer: 1 GB}). */
static V run_fn(V *env, V *args) {
  size_t argn = 1;
  for (V p = env[1]; p != NIL; p = FLD(p, 1)) argn++;
  char **argv = xmalloc(sizeof(char *) * (argn + 1));
  int bad = !(argv[0] = cpath(env[0]));
  size_t i = 1;
  for (V p = env[1]; p != NIL; p = FLD(p, 1), i++) bad |= !(argv[i] = cpath(FLD(p, 0)));
  argv[argn] = NULL;
  int fds[2] = {-1, -1};
  pid_t pid = 0;
  int err = bad || pipe(fds) != 0;
  if (!err) {
    fcntl(fds[0], F_SETFD, FD_CLOEXEC);
    fcntl(fds[1], F_SETFD, FD_CLOEXEC);
    posix_spawn_file_actions_t fa;
    posix_spawnattr_t at;
    sigset_t all, none;
    sigfillset(&all);
    sigemptyset(&none);
    posix_spawn_file_actions_init(&fa);
    posix_spawn_file_actions_adddup2(&fa, fds[1], 1);
    posix_spawnattr_init(&at);
    posix_spawnattr_setsigdefault(&at, &all);
    posix_spawnattr_setsigmask(&at, &none);
    posix_spawnattr_setflags(&at, POSIX_SPAWN_SETSIGDEF | POSIX_SPAWN_SETSIGMASK);
    err = posix_spawnp(&pid, argv[0], &fa, &at, argv, environ) != 0;
    posix_spawn_file_actions_destroy(&fa);
    posix_spawnattr_destroy(&at);
    close(fds[1]);
  }
  for (size_t j = 0; j < argn; j++) free(argv[j]);
  free(argv);
  if (err) {
    if (fds[0] >= 0) close(fds[0]);
    return process(2, 127, SNIL, SNIL);
  }
  size_t len = 0, cap = 65536;
  uint8_t *out = xmalloc(cap);
  int killed = 0;
  for (;;) {
    if (len == cap) {
      if (cap >= ((size_t)1 << 30)) {
        if (!killed) kill(pid, SIGTERM);
        killed = 1;
        len = 0;
      } else {
        out = xrealloc(out, cap *= 2);
      }
    }
    ssize_t k = read(fds[0], out + len, cap - len);
    if (k < 0 && errno == EINTR) continue;
    if (k <= 0) break;
    if (!killed) len += (size_t)k;
  }
  close(fds[0]);
  int st = 0;
  while (waitpid(pid, &st, 0) < 0 && errno == EINTR) {}
  V output = str_of(out, killed ? 0 : len);
  free(out);
  if (WIFSIGNALED(st)) {
    const char *name = "";
    for (size_t j = 0; j < sizeof sig_tab / sizeof sig_tab[0]; j++)
      if (sig_tab[j].no == WTERMSIG(st) && !*name) name = sig_tab[j].name;
    return process(1, 127, str_cstr(name), output);
  }
  return process(0, WIFEXITED(st) ? (uint32_t)WEXITSTATUS(st) : 127, SNIL, output);
}
V os_run(V program, V args) { return thunk2(run_fn, program, args); }

/* TestPerf.measure (test-os.js). OPEN-2: `bytes` counts arena bytes of the 3 sampled runs, not V8
 * heap bytes. `ok` needs exactly 3 inputs and each Observation{ok, source, output, allocation}
 * to carry ok and the very input object (pointer identity, as JS `===` on boxed strings). */
static V measure_fn(V *env, V *args) {
  size_t n = 0, i = 0;
  for (V p = env[0]; p != NIL; p = FLD(p, 1)) n++;
  V *samples = xmalloc(sizeof(V) * n);
  size_t nsamples = (size_t)n;
  rt_roots_push(&samples, &nsamples);
  for (V p = env[0]; p != NIL; p = FLD(p, 1)) samples[i++] = (V)str_flat(FLD(p, 0));
  for (int warm = 0; warm < 20; warm++)
    for (i = 0; i < n; i++) ap(env[1], samples[i]);
  int same = n == 3;
  uint64_t before = rt_arena_bytes();
  for (i = 0; i < n; i++) {
    V o = ap(env[1], samples[i]);
    same = same && FLD(o, 0) == TRUE_V && FLD(o, 1) == samples[i] && FLD(o, 2) == samples[i];
  }
  uint64_t used = rt_arena_bytes() - before;
  rt_roots_pop();
  free(samples);
  return rt_ctor2(0, same ? TRUE_V : FALSE_V, (V)(used > 0xffffffffu ? 0xffffffffu : used));
}
V testperf_measure(V inputs, V route) { return thunk2(measure_fn, inputs, route); }

/* ---------------- Node posix path rules (lib/path.js) ---------------- */
V path_basename(V v) {
  Str *s = str_flat(v);
  const uint8_t *p = s->u.p;
  int64_t start = 0, end = -1;
  int matched = 1;
  for (int64_t i = (int64_t)s->len - 1; i >= 0; i--) {
    if (p[i] == '/') {
      if (!matched) {
        start = i + 1;
        break;
      }
    } else if (end == -1) {
      matched = 0;
      end = i + 1;
    }
  }
  return end == -1 ? SNIL : str_view(p + start, (size_t)(end - start));
}

V path_extname(V v) {
  Str *s = str_flat(v);
  const uint8_t *p = s->u.p;
  int64_t start_dot = -1, start_part = 0, end = -1;
  int matched = 1, pre_dot = 0;
  for (int64_t i = (int64_t)s->len - 1; i >= 0; i--) {
    if (p[i] == '/') {
      if (!matched) {
        start_part = i + 1;
        break;
      }
      continue;
    }
    if (end == -1) matched = 0, end = i + 1;
    if (p[i] == '.') {
      if (start_dot == -1) start_dot = i;
      else if (pre_dot != 1) pre_dot = 1;
    } else if (start_dot != -1) {
      pre_dot = -1;
    }
  }
  int empty = start_dot == -1 || end == -1 || pre_dot == 0 ||
              (pre_dot == 1 && start_dot == end - 1 && start_dot == start_part + 1);
  return empty ? SNIL : str_view(p + start_dot, (size_t)(end - start_dot));
}

V path_dirname(V v) {
  Str *s = str_flat(v);
  const uint8_t *p = s->u.p;
  if (!s->len) return str_cstr(".");
  int root = p[0] == '/', matched = 1;
  int64_t end = -1;
  for (int64_t i = (int64_t)s->len - 1; i >= 1; i--) {
    if (p[i] == '/') {
      if (!matched) {
        end = i;
        break;
      }
    } else {
      matched = 0;
    }
  }
  if (end == -1) return str_cstr(root ? "/" : ".");
  if (root && end == 1) return str_cstr("//");
  return str_view(p, (size_t)end);
}

static int64_t last_slash(const uint8_t *r, size_t n) {
  for (size_t i = n; i-- > 0;)
    if (r[i] == '/') return (int64_t)i;
  return -1;
}

/* normalizeString + normalize (posix). */
static V path_normalize(const uint8_t *p, size_t n) {
  if (!n) return str_cstr(".");
  int abs = p[0] == '/', trail = p[n - 1] == '/', dots = 0;
  uint8_t *res = raw_alloc(n + 4), code = 0;
  size_t rl = 0;
  int64_t last_seg = 0, last = -1;
  for (size_t i = 0; i <= n; i++) {
    if (i < n) code = p[i];
    else if (code == '/') break;
    else code = '/';
    if (code == '/') {
      if (last == (int64_t)i - 1 || dots == 1) {
      } else if (dots == 2) {
        if (rl < 2 || last_seg != 2 || res[rl - 1] != '.' || res[rl - 2] != '.') {
          if (rl > 2) {
            int64_t k = last_slash(res, rl);
            if (k == -1) {
              rl = 0, last_seg = 0;
            } else {
              rl = (size_t)k;
              last_seg = (int64_t)rl - 1 - last_slash(res, rl);
            }
            last = (int64_t)i, dots = 0;
            continue;
          } else if (rl) {
            rl = 0, last_seg = 0, last = (int64_t)i, dots = 0;
            continue;
          }
        }
        if (!abs) {
          if (rl) res[rl++] = '/';
          res[rl++] = '.', res[rl++] = '.';
          last_seg = 2;
        }
      } else {
        size_t seg = i - (size_t)(last + 1);
        if (rl) res[rl++] = '/';
        memcpy(res + rl, p + last + 1, seg);
        rl += seg;
        last_seg = (int64_t)seg;
      }
      last = (int64_t)i, dots = 0;
    } else if (code == '.' && dots != -1) {
      dots++;
    } else {
      dots = -1;
    }
  }
  if (!rl) return str_cstr(abs ? "/" : trail ? "./" : ".");
  V body = str_view(res, rl);
  if (trail) body = str_append(body, str_cstr("/"));
  return abs ? str_append(str_cstr("/"), body) : body;
}

V path_join2(V a, V b) {
  uint32_t la = str_len(a), lb = str_len(b);
  if (!la && !lb) return str_cstr(".");
  V joined = !la ? b : !lb ? a : str_append(a, str_append(str_cstr("/"), b));
  Str *j = str_flat(joined);
  return path_normalize(j->u.p, j->len);
}

/* ---------------- init ---------------- */
void rt_init(int argc, char **argv) {
  const char *mb = getenv("ASSAY_ARENA_MB");
  rt_argc = argc;
  rt_argv = argv;
#ifdef __APPLE__
  stack_top = (uintptr_t)pthread_get_stackaddr_np(pthread_self());
#else
  pthread_attr_t at;
  void *sa;
  size_t ss;
  if (!pthread_getattr_np(pthread_self(), &at) && !pthread_attr_getstack(&at, &sa, &ss)) stack_top = (uintptr_t)sa + ss;
#endif
  const char *gl = getenv("ASSAY_GC_LOG");
  gc_log = gl && *gl && *gl != '0';
  if (mb && *mb) arena_max = (uint64_t)strtoull(mb, 0, 10) << 20;
  const char *pf = getenv("ASSAY_PROFILE");
  if (pf && *pf && *pf != '0') {
    prof_tag = calloc(PROF_TAGS, sizeof(ProfTag));
    prof_site = calloc(PROF_SITES, sizeof(ProfSite));
    if (!prof_tag || !prof_site) rt_panic("out of memory");
    prof_on = 1;
    prof_hl = rt_hl, rt_hl = rt_hp;
    atexit(prof_dump);
  }
  for (int i = 0; i < 256; i++) {
    byte_tab[i] = (uint8_t)i;
    char_str[i].tag = TAG_STR;
    char_str[i].len = 1;
    char_str[i].u.p = &byte_tab[i];
  }
  signal(SIGPIPE, SIG_IGN);
}

/* ---- Big.bits kernels (C_DEFS in bend2c.py) ----
 * Bool lists, least significant bit first (kernel.bend `type Big`). Each function returns the
 * same list as its Bend body for every input it accepts, so the goldens hold. */
V bits_to_nat(V xs) {
  uint32_t len = 0, i = 0;
  for (V p = xs; p != NIL; p = FLD(p, 1)) len++;
  if (len < 64) {
    uint64_t x = 0;
    for (V p = xs; p != NIL; p = FLD(p, 1), i++) x |= (uint64_t)FLD(p, 0) << i;
    return nat_of_u64(x);
  }
  Big *b = big_new((len + 31) / 32);
  memset(b->d, 0, 4 * (size_t)b->n);
  for (V p = xs; p != NIL; p = FLD(p, 1), i++) b->d[i >> 5] |= (uint32_t)FLD(p, 0) << (i & 31);
  return big_fin(b);
}

/* the same, most significant bit first */
static V bits_to_nat_msb(V xs) {
  uint32_t len = 0;
  for (V p = xs; p != NIL; p = FLD(p, 1)) len++;
  if (len < 64) {
    uint64_t x = 0;
    for (V p = xs; p != NIL; p = FLD(p, 1)) x = x << 1 | (uint64_t)FLD(p, 0);
    return nat_of_u64(x);
  }
  Big *b = big_new((len + 31) / 32);
  memset(b->d, 0, 4 * (size_t)b->n);
  for (V p = xs; p != NIL; p = FLD(p, 1)) len--, b->d[len >> 5] |= (uint32_t)FLD(p, 0) << (len & 31);
  return big_fin(b);
}

V nat_to_bits(V n) {
  uint32_t k, t[2], nb;
  const uint32_t *d = limbs(n, &k, t);
  if (!k) return NIL;
  nb = 32 * (k - 1);
  for (uint32_t top = d[k - 1]; top; top >>= 1) nb++;
  V acc = NIL;
  while (nb-- > 0) acc = CON(d[nb >> 5] >> (nb & 31) & 1 ? TRUE_V : FALSE_V, acc);
  return acc;
}

/* append one cell at *tail (a fresh list, built front to back) */
static V *bits_put(V *tail, V bit) {
  V c = CON(bit, NIL);
  *tail = c;
  return &FLD(c, 1);
}

V bits_add(V xs, V ys, V carry) {
  uint32_t c = (uint32_t)carry;
  V head = NIL, *tail = &head;
  while (xs != NIL || ys != NIL) {
    if (!c && (xs == NIL || ys == NIL)) { /* no carry left: the rest is the longer list itself */
      *tail = xs != NIL ? xs : ys;
      return head;
    }
    uint32_t s = c;
    if (xs != NIL) s += (uint32_t)FLD(xs, 0), xs = FLD(xs, 1);
    if (ys != NIL) s += (uint32_t)FLD(ys, 0), ys = FLD(ys, 1);
    tail = bits_put(tail, s & 1 ? TRUE_V : FALSE_V);
    c = s >> 1;
  }
  if (c) bits_put(tail, TRUE_V);
  return head;
}

/* Big.bits.cons drops trailing False bits: hold them until a True bit follows. With ys done and
 * no borrow, a trimmed rest of xs is the rest of the result: share it (tested once, since every
 * suffix of an untrimmed list is untrimmed) */
V bits_sub(V xs, V ys, V borrow) {
  uint32_t b = (uint32_t)borrow, zeros = 0, tried = 0;
  V head = NIL, *tail = &head;
  for (; xs != NIL; xs = FLD(xs, 1)) {
    if (ys == NIL && !b && !tried) {
      tried = 1;
      if (bits_trimmed(xs)) {
        for (; zeros; zeros--) tail = bits_put(tail, FALSE_V);
        *tail = xs;
        return head;
      }
    }
    uint32_t d = 2 + (uint32_t)FLD(xs, 0) - b;
    if (ys != NIL) d -= (uint32_t)FLD(ys, 0), ys = FLD(ys, 1);
    b = d < 2;
    if (!(d & 1)) {
      zeros++;
      continue;
    }
    for (; zeros; zeros--) tail = bits_put(tail, FALSE_V);
    tail = bits_put(tail, TRUE_V);
  }
  return head;
}

V bits_cmp(V xs, V ys) {
  int r = 0;
  for (; xs != NIL && ys != NIL; xs = FLD(xs, 1), ys = FLD(ys, 1))
    if (FLD(xs, 0) != FLD(ys, 0)) r = FLD(xs, 0) < FLD(ys, 0) ? -1 : 1;
  if (xs != NIL) return CMP_OF(1);
  if (ys != NIL) return CMP_OF(-1);
  return CMP_OF(r);
}

V bits_shl(V n, V bits) {
  for (uint64_t k = nat_to_u64_sat(n); k; k--) bits = CON(FALSE_V, bits);
  return bits;
}

V bits_trim(V xs) {
  V last = NIL, head = NIL, *tail = &head;
  for (V p = xs; p != NIL; p = FLD(p, 1))
    if (FLD(p, 0) != FALSE_V) last = p;
  if (last == NIL) return NIL;
  if (FLD(last, 1) == NIL) return xs;
  for (V p = xs; p != last; p = FLD(p, 1)) tail = bits_put(tail, FLD(p, 0));
  bits_put(tail, TRUE_V);
  return head;
}

int bits_trimmed(V xs) {
  V last = TRUE_V;
  for (; xs != NIL; xs = FLD(xs, 1)) last = FLD(xs, 0);
  return last != FALSE_V;
}

/* Big.bits.mul with ys trimmed is the trimmed product */
V bits_mul(V xs, V ys) { return nat_to_bits(nat_mul(bits_to_nat(xs), bits_to_nat(ys))); }

/* Big.bits.divide from rem = quot = Nil by a trimmed divisor is trimmed long division */
int bits_divide_ok(V divisor, V rem, V quot) {
  return rem == NIL && quot == NIL && divisor != NIL && bits_trimmed(divisor);
}

V bits_divide(V bits, V divisor) {
  V q, r;
  nat_divmod2(bits_to_nat_msb(bits), bits_to_nat(divisor), &q, &r);
  q = nat_to_bits(q);
  r = nat_to_bits(r);
  return rt_ctor2(0, q, r); /* Big.Quotient{quotient, remainder} */
}

/* Big.make: under BIG_SMALL_CELLS (63) cells a SmallBig (negative only when nonzero), else
 * Big{negative, bits}; R's Bend body (the JS host) keeps 25 */
V big_make(V neg, V bits, uint32_t small_tag, uint32_t big_tag) {
  uint32_t len = 0;
  for (V p = bits; p != NIL && len < BIG_SMALL_CELLS; p = FLD(p, 1)) len++;
  if (len >= BIG_SMALL_CELLS) return rt_ctor2(big_tag, neg, bits);
  V v = bits_to_nat(bits);
  return rt_ctor2(small_tag, nat_cmp(v, NAT_SMALL(0)) ? neg : FALSE_V, v);
}

/* Big.shift_left: Big.make(negative, Big.bits.trim(Big.bits.shl(n, bits))), a SmallBig's bits from
 * Big.bits.of_nat; a SmallBig result skips the lists */
V big_shift_left(V value, V n, uint32_t small_tag, uint32_t big_tag) {
  V neg = FLD(value, 0), bits = FLD(value, 1);
  if (tag_of(value) == small_tag) {
    uint64_t v = nat_to_u64_sat(bits), k = nat_to_u64_sat(n), b = 0;
    if (!v) return rt_ctor2(small_tag, FALSE_V, NAT_SMALL(0));
    for (uint64_t t = v; t; t >>= 1) b++;
    if (k < BIG_SMALL_CELLS && b + k < BIG_SMALL_CELLS) return rt_ctor2(small_tag, neg, NAT_SMALL(v << k));
    bits = nat_to_bits(bits);
  }
  return big_make(neg, bits_trim(bits_shl(n, bits)), small_tag, big_tag);
}

/* Big.fits_int: -2^62 <= value < 2^62 as Big.is_le / Big.is_lt decide it, with Big.bits.cmp
 * against the 63 bits of 2^62 (length first, then the most significant difference) */
V big_fits_int(V value, uint32_t small_tag) {
  int c;
  if (tag_of(value) == small_tag) {
    uint64_t a = nat_to_u64_sat(FLD(value, 1)), lim = (uint64_t)1 << 62;
    c = a < lim ? -1 : a > lim;
  } else {
    uint32_t len = 0;
    int low = 0, top = 0;
    for (V p = FLD(value, 1); p != NIL; p = FLD(p, 1), len++) {
      if (len < 62) low |= FLD(p, 0) != FALSE_V;
      if (len == 62) top = FLD(p, 0) != FALSE_V;
    }
    c = len != 63 ? (len < 63 ? -1 : 1) : !top ? -1 : low;
  }
  return FLD(value, 0) != FALSE_V ? (V)(c <= 0) : (V)(c < 0);
}

/* NativeInt.bound: the Bend body rebuilds a SmallBig, or a Big with fewer than 63 list cells, from
 * the same fields. No C code writes a ctor field after construction, so the argument itself is that
 * value. 0 for a Big of 63 or more cells (the Bend body: Big.wrap(63n, value)) */
int big_bound_ok(V value, uint32_t small_tag) {
  uint32_t len = 0;
  if (tag_of(value) == small_tag) return 1;
  for (V p = FLD(value, 1); p != NIL && len < 63; p = FLD(p, 1)) len++;
  return len < 63;
}

/* Big.bits.cmp(Big.bits.of_nat(n), ys) without the list: nat_to_bits(n) has nb cells (the bit
 * length of n, Nil for 0), so the longer one is greater, then the most significant difference */
static int bits_cmp_nat(V n, V ys) {
  uint32_t k, t[2], nb = 0, i = 0;
  const uint32_t *d = limbs(n, &k, t);
  int r = 0;
  if (k) {
    nb = 32 * (k - 1);
    for (uint32_t top = d[k - 1]; top; top >>= 1) nb++;
  }
  for (; ys != NIL && i < nb; ys = FLD(ys, 1), i++) {
    int x = d[i >> 5] >> (i & 31) & 1, y = FLD(ys, 0) != FALSE_V;
    if (x != y) r = x < y ? -1 : 1;
  }
  if (i < nb) return 1;
  if (ys != NIL) return -1;
  return r;
}

/* Big.cmp: the signs first (Big.cmp_small and Big.cmp_bits: True False is LT, False True is GT, True
 * True flips), then Nat.cmp of two SmallBig magnitudes, or Big.bits.cmp of the two lists with a
 * SmallBig's Big.bits.of_nat list read from its Nat (bits_cmp_nat) */
V big_cmp(V a, V b, uint32_t small_tag) {
  int an = FLD(a, 0) != FALSE_V, bn = FLD(b, 0) != FALSE_V, c = 0;
  if (an != bn) return CMP_OF(an ? -1 : 1);
  switch ((tag_of(a) == small_tag) * 2 + (tag_of(b) == small_tag)) {
  case 3: c = nat_cmp(FLD(a, 1), FLD(b, 1)); break;
  case 2: c = bits_cmp_nat(FLD(a, 1), FLD(b, 1)); break;
  case 1: c = -bits_cmp_nat(FLD(b, 1), FLD(a, 1)); break;
  case 0: c = (int)bits_cmp(FLD(a, 1), FLD(b, 1)) - 1; break;
  }
  c = (c > 0) - (c < 0);
  return CMP_OF(an ? -c : c);
}

/* (a) 2^62 SmallBig: a wide SmallBig has a small Nat magnitude m, 2^24 <= m < 2^62 (in R's 2^24 world
 * the Big{negative, Big.bits.of_nat(m)}). The Bend bodies of Big.shift_right, Big.unsigned and
 * Big.signed read a SmallBig as a value under 2^24 (U32.from_nat, the width >= 24 / 25 rows), so their
 * C_DEFS route a wide SmallBig here; a Big, a heap Nat or m < 2^24 takes the Bend body ({bend}).
 * big_wide_mag: m for a wide SmallBig, else 0 */
static uint64_t big_wide_mag(V value, uint32_t small_tag) {
  uint64_t m = tag_of(value) == small_tag && NAT_IS_SMALL(FLD(value, 1)) ? nat_to_u64_sat(FLD(value, 1)) : 0;
  return m >= (1ull << 24) && m < BIG_SMALL_LIMIT ? m : 0;
}
int big_wide(V value, uint32_t small_tag) { return big_wide_mag(value, small_tag) != 0; }
int big_wide_pos(V value, uint32_t small_tag) { return big_wide(value, small_tag) && FLD(value, 0) == FALSE_V; }
int big_signed_ok(V width, V value, uint32_t small_tag) { return big_wide(value, small_tag) && nat_to_u64_sat(width) >= 25; }
/* Big.shift_right(value, k) of a wide SmallBig: the 2^24 world's Big.make(n, Big.bits.drop(k, of_nat
 * m)), the magnitude m >> k (0 from k = 62 on: m < 2^62), negative only when nonzero */
V big_shift_right_wide(V value, V n, uint32_t small_tag) {
  uint64_t k = nat_to_u64_sat(n), r = k >= 62 ? 0 : big_wide_mag(value, small_tag) >> k;
  return rt_ctor2(small_tag, r ? FLD(value, 0) : FALSE_V, NAT_SMALL(r));
}
/* Big.unsigned(width, value) of a wide SmallBig{False, m}: the 2^24 world's Big.unsigned_bits, m mod
 * 2^width (m itself from width 62 on), for every width */
V big_unsigned_wide(V width, V value, uint32_t small_tag) {
  uint64_t w = nat_to_u64_sat(width), m = big_wide_mag(value, small_tag);
  return rt_ctor2(small_tag, FALSE_V, NAT_SMALL(w >= 62 ? m : m & ((1ull << w) - 1)));
}
/* Big.signed(width, value) of a wide SmallBig, width >= 25: the 2^24 world's Big.signed_bits on the
 * integer z: z itself when width >= 63 or z < 2^(width - 1), else z - 2^width (|z - 2^width| < 2^62) */
V big_signed_wide(V width, V value, uint32_t small_tag) {
  uint64_t w = nat_to_u64_sat(width), m = big_wide_mag(value, small_tag);
  int64_t z = FLD(value, 0) != FALSE_V ? -(int64_t)m : (int64_t)m, r;
  if (w >= 63 || z < ((int64_t)1 << (w - 1))) return value;
  r = z - ((int64_t)1 << w);
  return rt_ctor2(small_tag, r < 0 ? TRUE_V : FALSE_V, NAT_SMALL(r < 0 ? (uint64_t)-r : (uint64_t)r));
}

/* Big.hex on a SmallBig{False, n} with a small Nat n: Big.unsigned(63n, value) is the value itself
 * (width 63 >= 24), so Big.hex_go reads Big.bits.of_nat(n) four bits at a time and prepends each
 * digit: the hex digits of n, most significant first, no leading zero; "0" for 0 (Big.is_zero) */
int big_hex_ok(V value, uint32_t small_tag) {
  return tag_of(value) == small_tag && FLD(value, 0) == FALSE_V && NAT_IS_SMALL(FLD(value, 1));
}

V big_hex_small(V value, V upper) {
  const char *digits = upper != FALSE_V ? "0123456789ABCDEF" : "0123456789abcdef";
  uint64_t v = nat_to_u64_sat(FLD(value, 1));
  uint8_t buf[16];
  int i = 16;
  do {
    buf[--i] = (uint8_t)digits[v & 15];
    v >>= 4;
  } while (v);
  return str_of(buf + i, (size_t)(16 - i));
}

/* Big.add and Big.sub (kernel.bend) without the Big.bits.of_nat list of a SmallBig operand: the
 * list stays a word w (bit i = w >> i & 1) that bits_add_w, bits_cmp_w, bits_sub_w and bits_w_sub
 * read step for step like bits_add, bits_cmp and bits_sub read the list; where those share the
 * rest of the list, these build Big.bits.of_nat of the rest of the word. Two SmallBigs take
 * Big.add_small (Nat arithmetic, then Big.small). The results are the lists of the Bend bodies. */
static uint32_t word_bits(uint64_t w) {
  uint32_t n = 0;
  for (; w; w >>= 1) n++;
  return n;
}
/* Big.small: below BIG_SMALL_LIMIT (2^62) a SmallBig (negative only when nonzero), else
 * Big{negative, of_nat}; R's Bend body (the JS host) keeps 2^24 */
V big_small(V neg, V v, uint32_t small_tag, uint32_t big_tag) {
  if (nat_cmp(v, NAT_SMALL(BIG_SMALL_LIMIT)) < 0) return rt_ctor2(small_tag, nat_cmp(v, NAT_ZERO) ? neg : FALSE_V, v);
  return rt_ctor2(big_tag, neg, nat_to_bits(v));
}
/* bits_add(xs, Big.bits.of_nat(w), 0) */
static V bits_add_w(V xs, uint64_t w) {
  uint32_t c = 0, i = 0, n = word_bits(w);
  V head = NIL, *tail = &head;
  while (xs != NIL || i < n) {
    if (!c && (xs == NIL || i >= n)) { /* no carry left: the rest is the longer list itself */
      *tail = xs != NIL ? xs : nat_to_bits(NAT_SMALL(w >> i));
      return head;
    }
    uint32_t s = c;
    if (xs != NIL) s += (uint32_t)FLD(xs, 0), xs = FLD(xs, 1);
    if (i < n) s += (uint32_t)(w >> i & 1), i++;
    tail = bits_put(tail, s & 1 ? TRUE_V : FALSE_V);
    c = s >> 1;
  }
  if (c) bits_put(tail, TRUE_V);
  return head;
}
/* bits_cmp(xs, Big.bits.of_nat(w)) as -1, 0 or 1 */
static int bits_cmp_w(V xs, uint64_t w) {
  uint32_t i = 0, n = word_bits(w);
  int r = 0;
  for (; xs != NIL && i < n; xs = FLD(xs, 1), i++) {
    V y = (V)(w >> i & 1);
    if (FLD(xs, 0) != y) r = FLD(xs, 0) < y ? -1 : 1;
  }
  if (xs != NIL) return 1;
  if (i < n) return -1;
  return r;
}
/* bits_sub(xs, Big.bits.of_nat(w), 0) */
static V bits_sub_w(V xs, uint64_t w) {
  uint32_t b = 0, zeros = 0, tried = 0, i = 0, n = word_bits(w);
  V head = NIL, *tail = &head;
  for (; xs != NIL; xs = FLD(xs, 1)) {
    if (i >= n && !b && !tried) {
      tried = 1;
      if (bits_trimmed(xs)) {
        for (; zeros; zeros--) tail = bits_put(tail, FALSE_V);
        *tail = xs;
        return head;
      }
    }
    uint32_t d = 2 + (uint32_t)FLD(xs, 0) - b;
    if (i < n) d -= (uint32_t)(w >> i & 1), i++;
    b = d < 2;
    if (!(d & 1)) {
      zeros++;
      continue;
    }
    for (; zeros; zeros--) tail = bits_put(tail, FALSE_V);
    tail = bits_put(tail, TRUE_V);
  }
  return head;
}
/* bits_sub(Big.bits.of_nat(w), ys, 0): every suffix of Big.bits.of_nat(w) is trimmed, so the first
 * time ys is done with no borrow, the rest of the word is the rest of the result */
static V bits_w_sub(uint64_t w, V ys) {
  uint32_t b = 0, zeros = 0, n = word_bits(w);
  V head = NIL, *tail = &head;
  for (uint32_t i = 0; i < n; i++) {
    if (ys == NIL && !b) {
      for (; zeros; zeros--) tail = bits_put(tail, FALSE_V);
      *tail = nat_to_bits(NAT_SMALL(w >> i));
      return head;
    }
    uint32_t d = 2 + (uint32_t)(w >> i & 1) - b;
    if (ys != NIL) d -= (uint32_t)FLD(ys, 0), ys = FLD(ys, 1);
    b = d < 2;
    if (!(d & 1)) {
      zeros++;
      continue;
    }
    for (; zeros; zeros--) tail = bits_put(tail, FALSE_V);
    tail = bits_put(tail, TRUE_V);
  }
  return head;
}
/* Big.add_bits(an, xs, bn, ys) with Big.difference; xw (yw) not NULL: xs (ys) is
 * Big.bits.of_nat(*xw) (*yw). bits_add is symmetric, bits_cmp antisymmetric. */
static V big_add_bits(V an, V xs, const uint64_t *xw, V bn, V ys, const uint64_t *yw, uint32_t st, uint32_t bt) {
  if (an == bn) return big_make(an, xw ? bits_add_w(ys, *xw) : yw ? bits_add_w(xs, *yw) : bits_add(xs, ys, 0), st, bt);
  int order = xw ? -bits_cmp_w(ys, *xw) : yw ? bits_cmp_w(xs, *yw) : (int)bits_cmp(xs, ys) - 1;
  if (!order) return rt_ctor2(st, FALSE_V, NAT_ZERO); /* EQ: Big.zero() */
  if (order > 0) return big_make(an, xw ? bits_w_sub(*xw, ys) : yw ? bits_sub_w(xs, *yw) : bits_sub(xs, ys, 0), st, bt);
  return big_make(an == FALSE_V ? TRUE_V : FALSE_V, xw ? bits_sub_w(ys, *xw) : yw ? bits_w_sub(*yw, xs) : bits_sub(ys, xs, 0),
                  st, bt);
}
/* Big.add on (an, a) and (bn, b): a is a SmallBig magnitude when as, else a Big bits list */
static V big_add_of(V an, int as, V a, V bn, int bs, V b, uint32_t st, uint32_t bt) {
  uint64_t aw = 0, bw = 0;
  if (as && bs) { /* Big.add_small */
    if (an == bn) return big_small(an, nat_add(a, b), st, bt);
    if (nat_cmp(a, b) < 0) return big_small(bn, nat_sub(b, a), st, bt);
    return big_small(an, nat_sub(a, b), st, bt);
  }
  if (as && !NAT_IS_SMALL(a)) a = nat_to_bits(a), as = 0; /* a heap Nat magnitude: the list itself */
  if (bs && !NAT_IS_SMALL(b)) b = nat_to_bits(b), bs = 0;
  if (as) aw = nat_to_u64_sat(a);
  if (bs) bw = nat_to_u64_sat(b);
  return big_add_bits(an, a, as ? &aw : NULL, bn, b, bs ? &bw : NULL, st, bt);
}
V big_add(V a, V b, uint32_t small_tag, uint32_t big_tag) {
  return big_add_of(FLD(a, 0), tag_of(a) == small_tag, FLD(a, 1), FLD(b, 0), tag_of(b) == small_tag, FLD(b, 1), small_tag,
                    big_tag);
}
/* Big.sub(a, b) = Big.add(a, Big.neg(b)); Big.neg(b) read in place: Big.small (a SmallBig) or
 * Big.make (a Big) of the flipped sign */
V big_sub(V a, V b, uint32_t small_tag, uint32_t big_tag) {
  V bn = FLD(b, 0) == FALSE_V ? TRUE_V : FALSE_V, v = FLD(b, 1);
  int small = tag_of(b) == small_tag, bs = small;
  uint32_t len = 0;
  if (small && nat_cmp(v, NAT_SMALL(BIG_SMALL_LIMIT)) >= 0) v = nat_to_bits(v), bs = 0; /* Big{not bn, of_nat} */
  for (V p = v; !small && p != NIL && len < BIG_SMALL_CELLS; p = FLD(p, 1)) len++;
  if (!small && len < BIG_SMALL_CELLS) v = bits_to_nat(v), bs = 1; /* Big.make: Big.small(not bn, to_nat) */
  if (bs && !nat_cmp(v, NAT_ZERO)) bn = FALSE_V;
  return big_add_of(FLD(a, 0), tag_of(a) == small_tag, FLD(a, 1), bn, bs, v, small_tag, big_tag);
}

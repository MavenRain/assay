/* tests_main.c: the test adapters on the C host (dev/build.py ADAPTERS and ENTRIES).
 * `tests ADAPTER ARGS...` runs one ENTRIES row, the same as the Bend `backends` target
 * (Entry.Backends) or a `test_ADAPTER` target. Any other first argument (or none) runs
 * Entry.Tests, the Bend `tests` target. 1 GB stack, as in main.c. */
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include "assay.h"
#include "gen/assay_gen.h"

static int g_argc;
static char **g_argv;

static V lit(const char *s) { return str_view((const uint8_t *)s, strlen(s)); }

/* One row of ENTRIES: the IO value for the adapter `name`, applied to `args`. */
static int entry(const char *name, V args, V *io) {
  V r = 0;
  if (!strcmp(name, "event_decode")) r = d_Tests_dadapter(d_Event_udecode_dmain(args));
  else if (!strcmp(name, "revert_codec")) r = d_Tests_dadapter(d_Revert_ucodec_dmain(args));
  else if (!strcmp(name, "return_codec")) r = d_Tests_dadapter(d_Return_ucodec_dmain(args));
  else if (!strcmp(name, "call_codec")) r = d_Tests_dadapter(d_Call_ucodec_dmain(args));
  else if (!strcmp(name, "event_codec")) r = d_Tests_dadapter(d_Event_ucodec_dmain(args));
  else if (!strcmp(name, "sl_surface")) r = d_Tests_dsurface(d_Sl_usurface_dcases(), NAT_SMALL(0));
  else if (!strcmp(name, "abi_codec")) r = d_Tests_dadapter(d_Abi_ucodec_dmain(CON(lit("abi_codec"), args)));
  else if (!strcmp(name, "abi_schema")) r = d_NativeIO_dprint(d_Abi_uschema_doutput());
  else if (!strcmp(name, "layout_packed")) r = d_Tests_dadapter(d_Packed_ulayout_dmain(args));
  else if (!strcmp(name, "layout_mapping")) r = d_Tests_dadapter(d_Mapping_ulayout_dmain(args));
  else if (!strcmp(name, "keccak_vec")) r = d_Tests_dkeccak(d_Keccak_uvec_ddispatch(CON(lit("keccak_vec"), args)));
  else if (!strcmp(name, "asm_cases")) r = d_Tests_dasm_ucases(args);
  else if (!strcmp(name, "asm_compact")) r = d_Tests_dcompact_uall();
  else if (!strcmp(name, "emit_cases")) r = d_Tests_demit_ucases(args);
  else if (!strcmp(name, "contract_route")) r = d_Tests_dcontract_uroute(args);
  else if (!strcmp(name, "one_paths")) r = d_Tests_done_upaths(d_One_upaths_drun(UNIT));
  else if (!strcmp(name, "export_mu")) r = d_Tests_dexport_umu(args);
  else if (!strcmp(name, "roundtrip")) r = d_Tests_droundtrip(args);
  else return 0;
  *io = r;
  return 1;
}

static void *run(void *unused) {
  V args, io;
  (void)unused;
  rt_init(g_argc, g_argv);
  args = d_Tests_darguments(io_run(nio_args()));
  if (g_argc >= 2 && entry(g_argv[1], FLD(args, 1), &io)) io_run(io);
  else io_run(d_Entry_dTests());
  return 0;
}

int main(int argc, char **argv) {
  pthread_attr_t attr;
  pthread_t th;
  g_argc = argc;
  g_argv = argv;
  if (pthread_attr_init(&attr) || pthread_attr_setstacksize(&attr, (size_t)1 << 30) ||
      pthread_create(&th, &attr, run, 0)) {
    fputs("assay tests: cannot start the main thread\n", stderr);
    return 70;
  }
  pthread_join(th, 0);
  return 0;
}

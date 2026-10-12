/* main.c: the `assay` CLI on the C host (dev/build.py target `assay`, entry Entry.Cli).
 * The generated code recurses deeply, so the program runs on a thread with a 1 GB stack. */
#include <pthread.h>
#include <stdio.h>
#include "assay.h"
#include "gen/assay_gen.h"

static int g_argc;
static char **g_argv;

static void *run(void *unused) {
  (void)unused;
  rt_init(g_argc, g_argv);
  io_run(d_Entry_dCli());
  return 0;
}

int main(int argc, char **argv) {
  pthread_attr_t attr;
  pthread_t th;
  g_argc = argc;
  g_argv = argv;
  if (pthread_attr_init(&attr) || pthread_attr_setstacksize(&attr, (size_t)1 << 30) ||
      pthread_create(&th, &attr, run, 0)) {
    fputs("assay: cannot start the main thread\n", stderr);
    return 70;
  }
  pthread_join(th, 0);
  return 0;
}

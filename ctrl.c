#define _POSIX_C_SOURCE 200809L
#include <janet.h>
#include <signal.h>
#include <sys/signalfd.h>

static Janet ignore(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 1);
  signal(SIGINT, janet_getboolean(argv, 0) ? SIG_IGN : SIG_DFL);
  return janet_wrap_nil();
}

static Janet mask(int32_t argc, Janet *argv) {
  sigset_t mask;

  janet_fixarity(argc, 1);
  sigemptyset(&mask);
  sigaddset(&mask, SIGINT);
  if (pthread_sigmask(janet_getboolean(argv, 0) ? SIG_BLOCK : SIG_UNBLOCK, &mask, NULL))
    janet_panic("unable to mask signal");
  return janet_wrap_nil();
}

static Janet stream(int32_t argc, Janet *argv) {
  int sfd;
  sigset_t mask;

  (void)argv;
  janet_fixarity(argc, 0);
  sigemptyset(&mask);
  sigaddset(&mask, SIGINT);
  
  sfd = signalfd(-1, &mask, SFD_NONBLOCK|SFD_CLOEXEC);
  if (sfd == -1)
     janet_panic("unable to create signal fd");
  
  return janet_wrap_abstract(janet_stream(sfd, JANET_STREAM_READABLE, NULL));
}

static const JanetReg cfuns[] = {
    {"ignore", ignore,  
     "(ctrl-c/ignore bool)\n\n"
     "Ignore or reset the SIGINT handler."},
    {"mask", mask,
     "(ctrl-c/mask bool)\n\n"
     "Mask or unmask the SIGINT handler."},
    {"stream", stream, "create a low level signalfd stream that reads sigint events, each event is 128 bytes of data."},
    {NULL, NULL, NULL}};

JANET_MODULE_ENTRY(JanetTable *env) {
  janet_cfuns(env, "ctrl-c", cfuns);
}

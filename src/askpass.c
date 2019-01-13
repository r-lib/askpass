#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <unistd.h>
#include <stdlib.h>

/* We don't use this anymore */

SEXP pw_entry_dialog(SEXP prompt){
#ifndef _WIN32
  const char *text = CHAR(STRING_ELT(prompt, 0));
  const char *pass = getpass(text);
  if(pass != NULL)
    return Rf_mkString(pass);
#endif
  return R_NilValue;
}

static const R_CallMethodDef CallEntries[] = {
  {"pw_entry_dialog", (DL_FUNC) &pw_entry_dialog, 1},
  {NULL, NULL, 0}
};

void R_init_askpass(DllInfo *dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}

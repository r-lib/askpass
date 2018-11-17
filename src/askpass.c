#include <Rinternals.h>
#include <unistd.h>

static SEXP safe_char(const char *x){
  if(x == NULL)
    return NA_STRING;
  return Rf_mkCharCE(x, CE_UTF8);
}

SEXP pw_entry_dialog(SEXP prompt){
  const char *text = CHAR(STRING_ELT(prompt, 0));
#ifndef _WIN32
  return Rf_ScalarString(safe_char(getpass(text)));
#else
  return R_NilValue;
#endif
}

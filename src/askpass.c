#include <Rinternals.h>
#include <unistd.h>

SEXP pw_entry_dialog(SEXP prompt){
#ifndef _WIN32
  const char *text = CHAR(STRING_ELT(prompt, 0));
  const char *pass = getpass(text);
  if(pass != NULL)
    return Rf_mkString(pass);
#endif
  return R_NilValue;
}

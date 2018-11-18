#include <windows.h>
#include <wincred.h>
#include <stdio.h>

static const char *formatError(DWORD res){
  static char buf[1000], *p;
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                NULL, res,
                MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                buf, 1000, NULL);
  p = buf+strlen(buf) -1;
  if(*p == '\n') *p = '\0';
  p = buf+strlen(buf) -1;
  if(*p == '\r') *p = '\0';
  p = buf+strlen(buf) -1;
  if(*p == '.') *p = '\0';
  return buf;
}

int main( int argc, const char* argv[] ){
  const char *prompt = argc > 1 ? argv[1] : "Please enter password";
  const char *user = argc > 2 ? argv[2] : "NA";
  CREDUI_INFO cui;
  TCHAR pszPwd[CREDUI_MAX_PASSWORD_LENGTH+1];
  BOOL fSave;
  DWORD dwErr;

  cui.cbSize = sizeof(CREDUI_INFO);
  cui.hwndParent = GetActiveWindow();
  cui.pszMessageText = TEXT(prompt);
  cui.pszCaptionText = TEXT("Password Entry");
  cui.hbmBanner = NULL;
  fSave = FALSE;
  SecureZeroMemory(pszPwd, sizeof(pszPwd));
  dwErr = CredUIPromptForCredentials(
    &cui,                         // CREDUI_INFO structure
    TEXT("TheServer"),            // Target for credentials
    NULL,                         // Reserved
    0,                            // Reason
    (char*) user,                      // User name
    0, // Max number of char for user name
    pszPwd,                       // Password
    CREDUI_MAX_PASSWORD_LENGTH+1, // Max number of char for password
    &fSave,                       // State of save check box
    CREDUI_FLAGS_GENERIC_CREDENTIALS |  // flags
    CREDUI_FLAGS_KEEP_USERNAME |
    CREDUI_FLAGS_PASSWORD_ONLY_OK |
    CREDUI_FLAGS_ALWAYS_SHOW_UI |
    CREDUI_FLAGS_DO_NOT_PERSIST);

  if(!dwErr) {
    fprintf( stdout, "%s\n", pszPwd);

    return 0;
  } else {
    fprintf( stderr, "%s\n", formatError(GetLastError()));
    return 1;
  }
}

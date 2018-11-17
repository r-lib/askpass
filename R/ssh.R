#' ASKPASS CMD TOOL
#'
#' This returns the path to the native askpass executable which can be used
#' by git-credential or ssh-agent. Most users don't have worry about this.
#'
#' On Windows and MacOS the package automatically sets the `SSH_ASKPASS` and
#' `GIT_ASKPASS` variables on load (if not already set). If these are set
#' you should be able to run e.g. `sys::exec_wait("ssh-add")` and you should
#' be prompted for a passphrase if your key is protected.
#'
#' @export
ssh_askpass <- function(){
  askpass_path(simple = FALSE)
}

#' SSH ASKPASS
#'
#' This returns the path to the native askpass executable which can be
#' used by git or ssh-agent. On Windows and MacOS the package uses this
#' to automatically set the `SSH_ASKPASS` and `GIT_ASKPASS` variables on
#' load (if not already set). Users don't have worry about this.
ssh_askpass <- function(){
  askpass_path()
}

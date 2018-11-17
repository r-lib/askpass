.onLoad <- function(libname, pkgname){
  # This is mostly for RGui and R.app (tty could mean MacOS server)
  if(is_windows() || (is_macos() && !isatty(stdin()))){
    askpass_bin = askpass_path()
    if(is.na(Sys.getenv('GIT_ASKPASS', NA))){
      Sys.setenv("GIT_ASKPASS" = askpass_bin)
    }
    if(is.na(Sys.getenv('SSH_ASKPASS', NA))){
      Sys.setenv("SSH_ASKPASS" = askpass_bin)
    }
  }

  # Try to put 'rpostback-askpass' on the path in RStudio if needed
  # See: https://github.com/rstudio/rstudio/issues/3805
  rs_path <- Sys.getenv('RS_RPOSTBACK_PATH')
  git_askpass <- Sys.getenv('GIT_ASKPASS')
  if(nchar(rs_path) && !nchar(Sys.which(git_askpass))){
    PATH <- Sys.getenv("PATH")
    rs_path <- unique(c(rs_path, sub("rpostback", 'postback', rs_path)))
    Sys.setenv(PATH = paste(c(PATH, rs_path), collapse = .Platform$path.sep))
  }
}

.onLoad <- function(libname, pkgname){
  setup_askpass_vars()
}

setup_askpass_vars <- function(){
  if(nchar(Sys.getenv('RSTUDIO'))){
    fix_rstudio_path()
  } else {
    # This is mostly for RGui and R.app (tty could mean MacOS server)
    if(is_windows() || (is_macos() && !isatty(stdin()))){
      askpass_bin = ssh_askpass()
      if(is.na(Sys.getenv('GIT_ASKPASS', NA))){
        Sys.setenv("GIT_ASKPASS" = askpass_bin)
      }
      if(is.na(Sys.getenv('SSH_ASKPASS', NA))){
        Sys.setenv("SSH_ASKPASS" = askpass_bin)
      }
    }
  }
}

# Try to put 'rpostback-askpass' on the path in RStudio if needed
# See: https://github.com/rstudio/rstudio/issues/3805
fix_rstudio_path <- function(){
  rs_path <- Sys.getenv('RS_RPOSTBACK_PATH')
  git_askpass <- Sys.getenv('GIT_ASKPASS', 'rpostback-askpass')
  if(nchar(rs_path) && !cmd_exists(git_askpass)){
    PATH <- Sys.getenv("PATH")
    if(!grepl(normalizePath(rs_path, mustWork = FALSE), PATH, fixed = TRUE)){
      rs_path <- unique(c(rs_path, sub("rpostback", 'postback', rs_path)))
      Sys.setenv(PATH = paste(c(PATH, normalizePath(rs_path, mustWork = FALSE)),
                              collapse = .Platform$path.sep))
    }
  }
}

cmd_exists <- function(cmd){
  nchar(Sys.which(cmd)) > 0
}

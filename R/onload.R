.onLoad <- function(libname, pkgname){
  setup_askpass_vars()
}

setup_askpass_vars <- function(){
  if(var_exists('RSTUDIO')){
    fix_rstudio_path()
  } else {
    # This is mostly for RGui and R.app (tty could mean MacOS server)
    if(is_windows() || (is_macos() && !isatty(stdin()))){
      askpass_bin = ssh_askpass()
      if(!var_exists('GIT_ASKPASS')){
        Sys.setenv("GIT_ASKPASS" = askpass_bin)
      }
      if(!var_exists('SSH_ASKPASS')){
        Sys.setenv("SSH_ASKPASS" = askpass_bin)
      }
    }
  }
}

# Try to put 'rpostback-askpass' on the path in RStudio if needed
# See: https://github.com/rstudio/rstudio/issues/3805
fix_rstudio_path <- function(){
  rs_path <- Sys.getenv('RS_RPOSTBACK_PATH')
  git_askpass <- Sys.getenv('GIT_ASKPASS')
  if(nchar(rs_path) && !cmd_exists(git_askpass)){
    PATH <- Sys.getenv("PATH")
    if(!grepl(normalizePath(rs_path, mustWork = FALSE), PATH, fixed = TRUE)){
      rs_path <- unique(c(rs_path, sub("rpostback", 'postback', rs_path)))
      Sys.setenv(PATH = paste(c(PATH, normalizePath(rs_path, mustWork = FALSE)),
                              collapse = .Platform$path.sep))
    }
  }
}

var_exists <- function(var){
  nchar(Sys.getenv(var)) > 0
}

cmd_exists <- function(cmd){
  nchar(Sys.which(cmd)) > 0
}

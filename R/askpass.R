#' Password Prompt Utility
#'
#' Function to prompt the user for a password to read a protected private key.
#' Frontends can provide a custom password entry widget by setting the \code{askpass}
#' option. If no such option is specified we default to \code{\link{readline}}.
#'
#' @export
#' @param prompt the string printed when prompting the user for input.
askpass <- function(prompt = "Please enter your password: "){
  if(!interactive())
    return(NULL)
  FUN <- getOption("askpass", ask_password_default)
  FUN(prompt)
}

ask_password_default <- function(prompt){
  if(is_windows()){
    windows_askpass(prompt)
  } else if(is_macos() && !isatty(stdin())){
    applescript_password(prompt)
  } else {
    readline_silent(prompt)
  }
}

windows_askpass <- function(prompt){
  arch <- .Machine$sizeof.pointer * 8;
  win_askpass <- system.file(paste0('win-askpass', arch),
                             package = 'openssl', mustWork = TRUE)
  res <- sys::exec_internal(win_askpass, prompt, timeout = 120)
  out_without_eol(res$stdout)
}

applescript_password <- function(prompt){
  mac_askpass <- system.file('mac-askpass', package = 'openssl', mustWork = TRUE)
  res <- sys::exec_internal(mac_askpass, prompt, timeout = 120)
  out_without_eol(res$stdout)
}

readline_silent <- function(prompt){
  if(is_unix() && isatty(stdin())){
    if(system('stty -echo') == 0){
      on.exit(system('stty echo'))
    }
  }
  cat(prompt, "\n")
  out <- base::readline("\U0001f511 ")
  cat(" OK\n")
  out
}

readline_bash <- function(prompt){
  args <- sprintf('-s -p "%s" password && echo $password', prompt)
  on.exit({system('stty echo'); cat("\n")})
  system2('read', args, stdout = TRUE)
}

is_unix <- function(){
  .Platform$OS.type == "unix"
}

is_windows <- function(){
  .Platform$OS.type == "windows"
}

is_macos <- function(){
  identical(tolower(Sys.info()[['sysname']]), "darwin")
}

out_without_eol <- function(x){
  sub("\r?\n$", "", rawToChar(x))
}

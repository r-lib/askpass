#' Password Prompt Utility
#'
#' Prompt the user for a password to authhenticate or read a protected key.
#' By default, this function automatically uses the most appropriate method
#' based on the user platform and front-end. Users or IDEs can override this
#' and set a custom password entry function via the `askpass` option.
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
    askpass_windows(prompt)
  } else if(is_macos() && !isatty(stdin())){
    askpass_mac(prompt)
  } else {
    readline_silent(prompt)
  }
}

askpass_path <- function(){
  if(is_windows()){
    arch <- .Machine$sizeof.pointer * 8;
    system.file(sprintf('win-askpass%d.exe', arch),
                               package = 'askpass', mustWork = TRUE)
  } else if(is_macos()){
    system.file('mac-askpass', package = 'askpass', mustWork = TRUE)
  } else {
    stop("No custom password entry app for your platform")
  }
}

askpass_windows <- function(prompt, user = "NA"){
  res <- sys::exec_internal(askpass_path(), c(prompt, user), timeout = 120)
  out_without_eol(res$stdout)
}

askpass_mac <- function(prompt){
  res <- sys::exec_internal(askpass_path(), prompt, timeout = 120)
  out_without_eol(res$stdout)
}

readline_silent <- function(prompt, icon = "\U0001f511 "){
  if(is_unix() && isatty(stdin())){
    if(system('stty -echo') == 0){
      on.exit(system('stty echo'))
    }
  }
  cat(prompt, "\n")
  out <- base::readline(icon)
  cat(" OK\n")
  out
}

is_windows <- function(){
  .Platform$OS.type == 'windows'
}

is_unix <- function(){
  .Platform$OS.type == "unix"
}

is_macos <- function(){
  identical(tolower(Sys.info()[['sysname']]), "darwin")
}

out_without_eol <- function(x){
  sub("\r?\n$", "", rawToChar(x))
}

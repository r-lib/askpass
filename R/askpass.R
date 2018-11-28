#' Password Prompt Utility
#'
#' Prompt the user for a password to authenticate or read a protected key.
#' By default, this function automatically uses the most appropriate method
#' based on the user platform and front-end. Users or IDEs can override this
#' and set a custom password entry function via the `askpass` option.
#'
#' @export
#' @param prompt the string printed when prompting the user for input.
#' @examples \donttest{
#' # Prompt user for passwd
#' pw <- askpass("Please enter your password")
#' }
askpass <- function(prompt = "Please enter your password: "){
  FUN <- getOption("askpass", ask_password_default)
  FUN(prompt)
}

ask_password_default <- function(prompt){
  if(!interactive())
    return(NULL)
  if(is_windows()){
    askpass_windows(prompt)
  } else if(is_macos() && !isatty(stdin())){
    askpass_mac(prompt)
  } else {
    readline_silent(prompt)
  }
}

askpass_path <- function(simple = TRUE){
  if(is_windows()){
    arch <- .Machine$sizeof.pointer * 8;
    system.file(sprintf('win-askpass%d.exe', arch),
                               package = 'askpass', mustWork = TRUE)
  } else if(is_macos()){
    prog <- ifelse(isTRUE(simple), 'mac-simplepass', 'mac-askpass')
    system.file(prog, package = 'askpass', mustWork = TRUE)
  }
}

askpass_windows <- function(prompt, user = names(prompt)){
  tryCatch({
    res <- sys::exec_internal(askpass_path(), c(prompt, user), timeout = 120)
    out_without_eol(res$stdout)
  }, error = function(e){
    message(e$message)
  })
}

askpass_mac <- function(prompt){
  tryCatch({
    res <- sys::exec_internal(askpass_path(), prompt, timeout = 120)
    out_without_eol(res$stdout)
  }, error = function(e){
    message(e$message)
  })
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

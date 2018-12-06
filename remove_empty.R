# Load this func from the `janitor` package by Sam Firke, licensed under the MIT
# license: https://github.com/sfirke/janitor/blob/master/LICENSE.md
# Code: https://github.com/sfirke/janitor/blob/master/R/remove_empties.R
remove_empty <- function(dat, which = c("rows", "cols")) {
  if (missing(which) && !missing(dat)) {
    message("value for \"which\" not specified, defaulting to
            c(\"rows\", \"cols\")")
    which <- c("rows", "cols")
  }
  if ((sum(which %in% c("rows", "cols")) != length(which)) && !missing(dat)) {
    stop("\"which\" must be one of \"rows\", \"cols\", or
         c(\"rows\", \"cols\")")
  }
  if ("rows" %in% which) {
    dat <- dat[rowSums(is.na(dat)) != ncol(dat), , drop = FALSE]
  }
  if ("cols" %in% which) {
    dat <- dat[,colSums(!is.na(dat)) > 0, drop = FALSE]
  }
  dat
}

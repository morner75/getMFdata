#' EcosTerm function
#'
#' This function returns a character string containing a time value in a specified format
#' suitable for use as `start_time` or `end_time` arguments in ECOS API functions.
#'
#' @param time A time object (e.g. [base::Date], [base::POSIXct], or a string coercible to Date).
#' @param type A character string that specifies the desired output format. One of:
#'   \describe{
#'     \item{`"A"`}{Annual — returns 4-digit year (e.g. `"2023"`)}
#'     \item{`"Q"`}{Quarterly — returns year and quarter (e.g. `"2023Q1"`)}
#'     \item{`"M"`}{Monthly — returns year and month (e.g. `"202301"`)}
#'     \item{`"D"`}{Daily — returns full date (e.g. `"20230101"`)}
#'   }
#'   Default is `"A"`.
#'
#' @return A character string containing the time value in the specified format.
#'
#' @examples
#' EcosTerm(as.Date("2023-03-15"), type = "A")  # "2023"
#' EcosTerm(as.Date("2023-03-15"), type = "Q")  # "2023Q1"
#' EcosTerm(as.Date("2023-03-15"), type = "M")  # "202303"
#' EcosTerm(as.Date("2023-03-15"), type = "D")  # "20230315"
#'
#' @export
EcosTerm <- function(time, type = c("A", "Q", "M", "D")){
  type <- match.arg(type)
  switch(
    type,
    A = as.character(lubridate::year(time)),
    Q = as.yearqtr(time) %>% format(., "%YQ%q"),
    M = as.yearmon(time) %>% format(., "%Y%m"),
    D = as.Date(time) %>% format(., "%Y%m%d")
  )
}

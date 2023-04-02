#' EcosTerm function
#'
#' This function returns a character string containing a time value in a specified format.
#'
#' @param time A time object.
#' @param type A character string that specifies the desired output format. It must be one of the following: "A" for annual, "Q" for quarterly, "M" for monthly, or "D" for daily. Default is "A".
#'
#' @return A character string containing the time value in the specified format.
#'
#' @export
EcosTerm <- function(time,type=c("A","Q","M","D")){
  type=match.arg(type)
  switch(
    type,
    A = as.character(lubridate::year(time)),
    Q = as.yearqtr(time) %>% format(.,"%YQ%q"),
    M = as.yearmon(time) %>% format(.,"%Y%m"),
    D = as.Date(time) %>% format(.,"%Y%m%d")
  )
}

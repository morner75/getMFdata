#' Get OECD Database
#'
#' This function retrieves data from an OECD database, formatted as a JSON object,
#' given a specific starting time.
#'
#' @param url The URL of the OECD database API
#' @param startTime The starting time from which to retrieve data
#'
#' @return a list containing the structure and dataSets of the OECD database
#'
#'
#' @export
getOecdDB <- function(url,startTime){
  OECDDB_url <- paste0(url,"?startTime=",startTime)
  html <- GET(OECDDB_url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)
  list(structure=json_all$structure,
       dataSets=json_all$dataSets)
}

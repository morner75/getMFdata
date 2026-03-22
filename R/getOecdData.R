#' Get OECD Database
#'
#' This function retrieves data from an OECD SDMX-JSON API endpoint and returns
#' the structure and dataset components.
#'
#' @param url The full URL of the OECD SDMX-JSON API endpoint
#'   (e.g. `"https://stats.oecd.org/SDMX-JSON/data/QNA/KOR.B1_GE.LNBQRSA.Q/all?startTime=2000-Q1"`)
#'
#' @return a list with two elements:
#'   \describe{
#'     \item{structure}{metadata describing dimensions, attributes, and annotations}
#'     \item{dataSets}{the actual data observations}
#'   }
#'
#' @examples
#' \dontrun{
#' url <- "https://stats.oecd.org/SDMX-JSON/data/QNA/KOR.B1_GE.LNBQRSA.Q/all?startTime=2000-Q1"
#' result <- getOecdDB(url)
#' str(result$structure)
#' }
#'
#' @export
getOecdDB <- function(url){
  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)
  list(structure = json_all$structure,
       dataSets  = json_all$dataSets)
}

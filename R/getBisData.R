#' Function to extract data from Bank for International Settlements database
#'
#' This function extracts data from the Bank for International Settlements database and returns it as a tibble.
#'
#' @return a tibble with columns `name` (dataset name) and `url` (download URL) for each
#'   available dataset in the BIS full data sets page
#' @examples
#' \dontrun{
#' db <- getBisDB()
#' head(db)
#' }
#' @export
getBisDB <- function(){
  bisDB_url <- 'https://www.bis.org/statistics/full_data_sets.htm'
  bisDB_nodes <- bisDB_url %>%
    xml2::read_html() %>%
    rvest::html_nodes(xpath = "//a[contains(@href, 'zip')]")
  tibble::tibble(name = rvest::html_text(bisDB_nodes), url = str_c('https://data.bis.org', rvest::html_attr(bisDB_nodes, "href")))
}

#' Download and extract a BIS database file
#'
#' This function downloads and extracts a BIS database file, then reads it into R as a CSV file.
#'
#' @param url the URL of the BIS database ZIP file to be downloaded (obtain from [getBisDB()])
#' @param ... additional arguments passed to [utils::download.file()] (e.g. `quiet = TRUE`)
#' @return a data frame with the contents of the downloaded CSV file
#' @examples
#' \dontrun{
#' db <- getBisDB()
#' # Download the first available dataset
#' df <- getBisData(db$url[1])
#' head(df)
#' }
#' @export
getBisData <- function (url, ...) {
  tmp_dir <- tempdir()
  tmp_file <- tempfile(fileext = ".zip")
  utils::download.file(url, tmp_file, mode = "wb", ...)
  filename <- utils::unzip(tmp_file, list = TRUE)
  utils::unzip(tmp_file, exdir = tmp_dir)
  path <- file.path(tmp_dir, filename$Name[1])
  readr::read_csv(path, show_col_types = FALSE)
}

#' Function to extract data from Bank for International Settlements database
#'
#' This function extracts data from the Bank for International Settlements database and returns it as a tibble.
#'
#' @return a tibble with the name and URL of each available dataset in the BIS database
#' @export
getBisDB <- function(){
  bisDB_url <- 'https://www.bis.org/statistics/full_data_sets.htm'
  bisDB_nodes <- bisDB_url %>%
    xml2::read_html() %>%
    rvest::html_nodes(xpath = "//a[contains(@href, 'zip')]")
  tibble(name = rvest::html_text(bisDB_nodes), url = str_c('https://www.bis.org',rvest::html_attr(bisDB_nodes,"href")))
}

#' Download and extract a BIS database file
#'
#' This function downloads and extracts a BIS database file, then reads it into R as a csv file.
#'
#' @param url the URL of the BIS database file to be downloaded
#' @param ... other arguments delivered to download.file function
#' @return a data frame with the contents of the downloaded file
#' @export
getBisData <- function (url, ...) {
  tmp_dir <- tempdir()
  tmp_file <- tempfile(fileext = ".zip")
  utils::download.file(url, tmp_file, mode = "wb", ...)
  filename <- utils::unzip(tmp_file, list = TRUE)
  utils::unzip(tmp_file, exdir = tmp_dir)
  path=file.path(tmp_dir, filename$Name)
  readr::read_csv(path,show_col_types = FALSE)
}


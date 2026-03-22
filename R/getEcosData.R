#' Function to retrieve data from Bank of Korea's ECOS system
#'
#' This function utilizes Bank of Korea's ECOS API to retrieve statistical data
#' based on user input.
#'
#' @param ECOS_key character string containing user's unique API key
#' @param stat_code character string containing specific statistical code
#' @param period character string containing period of data (e.g. `'DD'` for daily, `'MM'` for monthly)
#' @param start_time character string containing start date of data (YYYYMMDD)
#' @param end_time character string containing end date of data (YYYYMMDD)
#' @param item_code1 character string containing first item code (use `"?"` for all items)
#' @param item_code2 character string containing second item code (use `""` if not needed)
#' @param item_code3 character string containing third item code (use `""` if not needed)
#' @param lang character string containing language of data (`'kr'` for Korean, `'en'` for English)
#' @return data frame containing TIME and DATA_VALUE columns of requested data
#' @examples
#' \dontrun{
#' key <- Sys.getenv("ECOS_key")
#' getEcosData(key, "722Y001", "MM", "202001", "202312", "0", "DDD", "", "")
#' }
#' @export
getEcosData <- function(ECOS_key, stat_code, period, start_time, end_time, item_code1,
                        item_code2, item_code3, lang="kr"){

  url <- paste("https://ecos.bok.or.kr/api/StatisticSearch", ECOS_key, "json", lang, "1/10000",
               stat_code, period, start_time, end_time, item_code1, item_code2, item_code3, "", sep = "/")
  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)

  if (!is.null(json_all$RESULT)){

    code <- json_all$RESULT$CODE
    msg  <- json_all$RESULT$MESSAGE

    stop(paste0(code, "\n ", msg))

  }
  json_all[[1]][[2]] %>%  dplyr::select(TIME, DATA_VALUE)
}


#' Retrieve statistics table list from ECOS
#'
#' @param ECOS_key ECOS API key. Defaults to the `ECOS_key` environment variable
#'   (`Sys.getenv("ECOS_key")`).
#' @param lang language code (`'kr'` for Korean, `'en'` for English; default is `'kr'`)
#'
#' @return A tibble containing the statistics table list with columns: STAT_CODE,
#'   P_STAT_CODE, STAT_NAME, CYCLE, ORG_NAME, SRCH_YN
#' @examples
#' \dontrun{
#' getEcosList(Sys.getenv("ECOS_key"))
#' getEcosList(Sys.getenv("ECOS_key"), lang = "en")
#' }
#' @export
#'
getEcosList <- function(ECOS_key = Sys.getenv("ECOS_key"), lang = "kr"){
  url <- paste0("https://ecos.bok.or.kr/api/StatisticTableList/", ECOS_key, "/json/", lang, "/1/1000/")
  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)

  if (!is.null(json_all$RESULT)){
    code <- json_all$RESULT$CODE
    msg  <- json_all$RESULT$MESSAGE
    stop(paste0(code, "\n ", msg))

  }
  json_all[[1]][[2]] %>%  as_tibble() %>%
           select(STAT_CODE,
                  P_STAT_CODE,
                  STAT_NAME,
                  CYCLE,
                  ORG_NAME,
                  SRCH_YN)
}


#' Retrieve statistical item codes from ECOS
#'
#' This function retrieves statistical item codes from the ECOS database by sending a GET request to the ECOS API.
#'
#' @param ECOS_key An ECOS API key. Defaults to the `ECOS_key` environment variable
#'   (`Sys.getenv("ECOS_key")`).
#' @param STAT_CODE A statistical table code (e.g. `"722Y001"`)
#' @param lang The language of the returned data (`'kr'` for Korean, `'en'` for English; default: `"kr"`)
#'
#' @return A tibble containing item codes and metadata for the given statistical table
#'
#' @examples
#' \dontrun{
#' getEcosCode(Sys.getenv("ECOS_key"), "722Y001")
#' }
#' @export
getEcosCode <- function(ECOS_key = Sys.getenv("ECOS_key"), STAT_CODE, lang = "kr"){
  url <- paste0("https://ecos.bok.or.kr/api/StatisticItemList/", ECOS_key, "/json/", lang, "/1/1000/", STAT_CODE)
  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)

  if (!is.null(json_all$RESULT)){
    code <- json_all$RESULT$CODE
    msg  <- json_all$RESULT$MESSAGE
    stop(paste0(code, "\n ", msg))

  }
  json_all[[1]][[2]] %>% tibble::as_tibble() %>%
    dplyr::select(STAT_CODE,
                  STAT_NAME,
                  GRP_CODE,
                  GRP_NAME,
                  P_ITEM_CODE,
                  ITEM_CODE,
                  ITEM_NAME,
                  CYCLE,
                  START_TIME,
                  END_TIME,
                  DATA_CNT,
                  WEIGHT)
}

# ECOS statistics and code search
#' Search for ECOS statistical codes
#'
#' This function searches for ECOS statistical codes in a preloaded dataset by matching
#' keywords provided by the user. The dataset (`EcosStatsList.rds`) must be present in
#' `inst/Rdata/` within the installed package.
#'
#' @param x A character vector containing search keywords (matched with AND logic)
#'
#' @return A tibble containing the matching statistical codes
#'
#' @examples
#' \dontrun{
#' ecosSearch(c("GDP", "실질"))
#' ecosSearch("소비자물가")
#' }
#' @export
ecosSearch <- function(x) {
  path <- system.file("Rdata", "EcosStatsList.rds", package = "getMFdata")
  if (!nzchar(path)) {
    stop("EcosStatsList.rds not found. Place the file in inst/Rdata/ and reinstall the package.")
  }
  data <- readRDS(path)
  search <- data %>%
    dplyr::transmute(search = stringr::str_c(STAT_NAME, ITEM_NAME, STAT_NAME_EN, ITEM_NAME_EN, sep = " ")) %>%
    dplyr::pull()
  flag <- purrr::map(x, ~stringr::str_detect(search, .x)) %>%
    purrr::reduce(magrittr::multiply_by) %>%
    as.logical()
  data %>%
    dplyr::filter(flag) %>%
    dplyr::distinct()
}

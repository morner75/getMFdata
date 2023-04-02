#' Function to retrieve data from Bank of Korea's ECOS system
#'
#' This function utilizes Bank of Korea's ECOS API to retrieve statistical data
#' based on user input.
#'
#' @param ECOS_key character string containing user's unique API key
#' @param stat_code character string containing specific statistical code
#' @param period character string containing period of data (ex. 'DD', 'MM')
#' @param start_time character string containing start date of data (YYYYMMDD)
#' @param end_time character string containing end date of data (YYYYMMDD)
#' @param item_code1 character string containing first item code
#' @param item_code2 character string containing second item code
#' @param item_code3 character string containing third item code
#' @param lang character string containing language of data ('kr' for Korean, 'en' for English)
#' @return data frame containing TIME and DATA_VALUE columns of requested data
#' @export
getEcosData <- function(ECOS_key, stat_code, period, start_time, end_time, item_code1,
                        item_code2, item_code3, lang="kr"){

  url <- paste("http://ecos.bok.or.kr/api/StatisticSearch",ECOS_key,"json",lang,"1/10000",
               stat_code,period, start_time, end_time, item_code1, item_code2, item_code3,"", sep = "/")
  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)

  if (!is.null(json_all$RESULT)){

    code <- json_all$RESULT$CODE
    msg  <- json_all$RESULT$MESSAGE

    stop(paste0(code, "\n ", msg))

  }
  json_all[[1]][[2]] %>%  dplyr::select(TIME,DATA_VALUE)
}


#' retrieving stats list from ECOS
#'
#' @param ECOS_key ECOS API key
#' @param lang language code (default is 'kr')
#'
#' @return A tibble containing the statistics table list
#' @export
#'
getEcosList <- function(ECOS_key=ECOS_key,lang="kr"){
  url <- paste0("https://ecos.bok.or.kr/api/StatisticTableList/",ECOS_key,"/json/",lang,"/1/1000/")
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


#' Retrieve statistical codes from ECOS database
#'
#' This function retrieves statistical codes from the ECOS database by sending a GET request to the ECOS API.
#'
#' @param ECOS_key An ECOS API key
#' @param STAT_CODE A statistical code
#' @param lang The language of the returned data (default: "kr")
#'
#' @return A tibble containing the retrieved statistical codes
#'
#' @export
getEcosCode <- function(ECOS_key=ECOS_key,STAT_CODE,lang="kr"){
  url <- paste0("http://ecos.bok.or.kr/api/StatisticItemList/",ECOS_key,"/json/",lang,"/1/1000/",STAT_CODE)
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
                  STAT_NAME	,
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
#' This function searches for ECOS statistical codes in a preloaded dataset by matching keywords provided by the user.
#'
#' @param x A character vector containing search keywords
#'
#' @return A tibble containing the matching statistical codes
#'
#' @importFrom magrittr multiply_by
#' @importFrom dplyr filter distinct
#' @importFrom purrr map reduce
#' @import stringr
#' @import tibble
#'
#' @export
ecosSearch <- function(x) {
  data <- readRDS("Rdata/EcosStatsList.rds")
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


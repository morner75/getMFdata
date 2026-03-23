#' Function to retrieve FSIS information
#'
#' Get information from FSIS API.
#'
#' @param api_key FSIS API key
#' @param info_name Character string. Name of information to retrieve. One of
#'   `'companySearch'`, `'statisticsListSearch'`, or `'accountListSearch'`.
#' @param item_code Character string. Code for the search parameter.
#'   For `companySearch`: partition division code (default `"A"` for all).
#'   For `statisticsListSearch`: large category code (default `"A"`).
#'   For `accountListSearch`: statistics list number (5-digit code, e.g. `"SA053"`).
#' @return A data frame with the retrieved information.
#' @examples
#' \dontrun{
#' key <- Sys.getenv("FISIS_key")
#' getFsisInfos(key, "companySearch")
#' getFsisInfos(key, "statisticsListSearch", item_code = "A")
#' getFsisInfos(key, "accountListSearch", item_code = "SA053")
#' }
#' @export
getFsisInfos <- function(api_key, info_name = c("companySearch", "statisticsListSearch", "accountListSearch"),
                         item_code = "A"){
  info_name <- match.arg(info_name)

  if (info_name == "companySearch"){
    url <- paste0("http://fisis.fss.or.kr/openapi/", info_name, ".json?lang=kr&auth=",
                  api_key, "&partDiv=", item_code)
  } else if (info_name == "statisticsListSearch"){
    url <- paste0("http://fisis.fss.or.kr/openapi/", info_name, ".json?lang=kr&auth=",
                  api_key, "&lrgDiv=", item_code)
  } else {
    url <- paste0("http://fisis.fss.or.kr/openapi/", info_name, ".json?lang=kr&auth=",
                  api_key, "&listNo=", item_code)
  }
  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)
  if (json_all$result$err_cd != "000"){
    code <- json_all$result$err_cd
    msg  <- json_all$result$err_msg
    stop(paste0(code, "\n ", msg))
  }
  json_all[[1]][[4]]
}


#' Function to retrieve financial data from the Financial Supervisory Service Information System (FSIS)
#'
#' This function retrieves financial data from the Financial Supervisory Service Information System (FSIS) using the FSIS Open API.
#'
#' @param api_key API key for FSIS Open API
#' @param finance_cd Financial institution code (defaults to `"0010001"` for banks)
#' @param list_no Financial data type code (defaults to `"SA053"` for bank balance sheets)
#' @param account_cd Account item code (optional; defaults to `"B"` for balance sheet accounts)
#' @param term Time period for data (`"Y"` for annual, `"H"` for semi-annual, `"Q"` for quarterly; defaults to `"Y"`)
#' @param start_month Starting month for data in YYYYMM format (defaults to `"200801"`)
#' @param end_month Ending month for data in YYYYMM format (defaults to `"202012"`)
#' @return a data frame with the requested financial data
#' @examples
#' \dontrun{
#' key <- Sys.getenv("FISIS_key")
#' getFsisData(key, finance_cd = "0010001", list_no = "SA053", term = "Y",
#'             start_month = "200801", end_month = "202012")
#' }
#' @export
getFsisData <- function(api_key, finance_cd = "0010001", list_no = "SA053", account_cd = "B", term = "Y",
                        start_month = "200801", end_month = "202012"){
  url <- paste0("http://fisis.fss.or.kr/openapi/statisticsInfoSearch.json?lang=kr&auth=", api_key,
                "&financeCd=", finance_cd, "&listNo=", list_no, "&accountCd=", account_cd,
                "&term=", term, "&startBaseMm=", start_month, "&endBaseMm=", end_month)

  html <- GET(url)
  res <- rawToChar(html$content)
  Encoding(res) <- "UTF-8"
  json_all <- fromJSON(res)

  if (json_all$result$err_cd != "000"){
    code <- json_all$result$err_cd
    msg  <- json_all$result$err_msg
    stop(paste0(code, "\n ", msg))
  }
  json_all[[1]][[7]]
}

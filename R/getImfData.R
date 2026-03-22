
#' Function to retrieve financial data from the International Monetary Fund (IMF)
#'
#' This function retrieves financial data from the International Monetary Fund (IMF) using the IMF Data Services API.
#'
#' @param indicator_code Indicator code for the financial data to be retrieved
#'   (e.g. `"PCPI_PC_CP_A_PT"` for CPI inflation)
#' @param countries Character vector of ISO 2-letter country codes
#'   (e.g. `c("KR", "US")`). Multiple countries are concatenated with `+`.
#' @param start_date Starting date for the data in `"YYYY-MM-DD"` format
#' @param end_date Ending date for the data in `"YYYY-MM-DD"` format
#' @param frequency Time frequency for the data: `"A"` for annual, `"Q"` for quarterly,
#'   `"M"` for monthly
#' @return a list with the requested financial data (IMF SDMX-JSON structure)
#' @examples
#' \dontrun{
#' imf_raw <- getImfData("PCPI_PC_CP_A_PT", c("KR", "US"), "2015-01-01", "2022-01-01", "A")
#' df <- processImfData(imf_raw)
#' }
#' @export
getImfData <- function(indicator_code, countries, start_date, end_date, frequency) {

  base_url <- "https://dataservices.imf.org/REST/SDMX_JSON.svc"
  # Concatenate countries separated by '+'
  country_codes <- paste(countries, collapse = "+")

  # Create the URL for the API request
  api_url <- paste0(base_url, "/CompactData/IFS/", frequency, ".", country_codes, ".", indicator_code,
                    "?startPeriod=", start_date, "&endPeriod=", end_date)

  # Send the API request and parse the response
  response <- GET(api_url)
  response_content <- content(response, "text")
  response_json <- fromJSON(response_content, flatten = TRUE)

  return(response_json)
}

#' Process IMF data retrieved from the IMF API
#'
#' This function processes the financial data retrieved from the IMF API using the [getImfData()] function.
#' It extracts the time series observations and returns them as a tidy data frame.
#'
#' @param IMFdata A list of financial data retrieved from the IMF API using [getImfData()]
#' @return a data frame with columns: `country` (ISO 2-letter code), `time` (period string),
#'   `value` (observed value as character)
#' @examples
#' \dontrun{
#' imf_raw <- getImfData("PCPI_PC_CP_A_PT", c("KR", "US"), "2015-01-01", "2022-01-01", "A")
#' df <- processImfData(imf_raw)
#' head(df)
#' }
#' @export
processImfData <- function(IMFdata) {

  ref_area <- IMFdata$CompactData$DataSet$Series$`@REF_AREA`
  observations <- IMFdata$CompactData$DataSet$Series$Obs %>% set_names(ref_area)
  res_df <-
    map_dfr(observations, function (df) df, .id="country") %>%
    transmute(
      country,
      time = `@TIME_PERIOD`,
      value = `@OBS_VALUE`)

  return(res_df)
}

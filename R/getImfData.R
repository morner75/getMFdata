
#' Function to retrieve financial data from the International Monetary Fund (IMF)
#'
#' This function retrieves financial data from the International Monetary Fund (IMF) using the IMF Data Services API.
#'
#' @param indicator_code Indicator code for the financial data to be retrieved
#' @param countries List of ISO country codes for the countries to be included in the data
#' @param start_date Starting date for the data (in the format "YYYY-MM-DD")
#' @param end_date Ending date for the data (in the format "YYYY-MM-DD")
#' @param frequency Time frequency for the data (e.g. "A" for annual, "Q" for quarterly)
#' @return a list with the requested financial data
#' @export
getImfData <- function(indicator_code, countries, start_date, end_date, frequency) {

  base_url <- "http://dataservices.imf.org/REST/SDMX_JSON.svc"
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
#' This function processes the financial data retrieved from the IMF API using the getImfdata function.
#'
#' @param IMFdata A list of financial data retrieved from the IMF API using the getImfdata function
#' @return a data frame with the processed IMF data
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

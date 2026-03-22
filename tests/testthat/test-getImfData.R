skip_if_imf_offline <- function() {
  result <- tryCatch(
    httr::GET("https://dataservices.imf.org", httr::timeout(5)),
    error = function(e) NULL
  )
  if (is.null(result) || httr::http_error(result)) {
    skip("IMF API is not reachable")
  }
}

test_that("getImfData returns a list with CompactData element", {
  skip_on_cran()
  skip_if_imf_offline()
  result <- getImfData("PCPI_PC_CP_A_PT", "KR", "2018-01-01", "2022-01-01", "A")
  expect_type(result, "list")
  expect_true("CompactData" %in% names(result))
})

test_that("getImfData supports multiple countries", {
  skip_on_cran()
  skip_if_imf_offline()
  result <- getImfData("PCPI_PC_CP_A_PT", c("KR", "US"), "2020-01-01", "2022-01-01", "A")
  expect_type(result, "list")
})

test_that("processImfData returns a data frame with country, time, value columns", {
  skip_on_cran()
  skip_if_imf_offline()
  raw <- getImfData("PCPI_PC_CP_A_PT", c("KR", "US"), "2018-01-01", "2022-01-01", "A")
  df <- processImfData(raw)
  expect_true(is.data.frame(df))
  expect_named(df, c("country", "time", "value"))
  expect_gt(nrow(df), 0)
})

test_that("processImfData country values match requested countries", {
  skip_on_cran()
  skip_if_imf_offline()
  raw <- getImfData("PCPI_PC_CP_A_PT", c("KR", "US"), "2018-01-01", "2022-01-01", "A")
  df <- processImfData(raw)
  expect_true(all(df$country %in% c("KR", "US")))
})

test_that("getOecdDB returns a list with structure and dataSets keys", {
  skip_on_cran()
  url <- "https://stats.oecd.org/SDMX-JSON/data/QNA/KOR.B1_GE.LNBQRSA.Q/all?startTime=2020-Q1&endTime=2022-Q4"
  result <- getOecdDB(url)
  expect_type(result, "list")
  expect_true("structure" %in% names(result))
  expect_true("dataSets" %in% names(result))
})

# NOTE: The OECD SDMX-JSON API (stats.oecd.org) has migrated to a new response
# format (meta/data/errors) that no longer includes top-level 'structure' or
# 'dataSets' keys. getOecdDB() will return NULL for both until it is updated
# to handle the new OECD API format.
test_that("getOecdDB returns a non-error response from OECD", {
  skip_on_cran()
  url <- "https://stats.oecd.org/SDMX-JSON/data/QNA/KOR.B1_GE.LNBQRSA.Q/all?startTime=2020-Q1&endTime=2022-Q4"
  expect_no_error(getOecdDB(url))
})

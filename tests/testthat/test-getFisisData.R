fisis_key <- Sys.getenv("FISIS_key")

# --- getFsisInfos input validation (no API needed) ---

test_that("getFsisInfos rejects invalid info_name", {
  expect_error(getFsisInfos("dummy_key", "invalidType"))
})

test_that("getFsisInfos accepts valid info_name values", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  # Should not error on valid type (may error on API side for invalid key, that's ok)
  result <- tryCatch(
    getFsisInfos(fisis_key, "companySearch"),
    error = function(e) e
  )
  # Either returns data or errors with API message (not argument validation error)
  if (inherits(result, "error")) {
    expect_false(grepl("arg.*should be one of", result$message))
  }
})

# --- getFsisInfos live tests ---

test_that("getFsisInfos companySearch returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  result <- getFsisInfos(fisis_key, "companySearch")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisInfos statisticsListSearch returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  result <- getFsisInfos(fisis_key, "statisticsListSearch")
  expect_true(is.data.frame(result))
})

# --- getFsisData live tests ---

test_that("getFsisData returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  result <- getFsisData(fisis_key)
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

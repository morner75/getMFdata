fisis_key <- Sys.getenv("FISIS_key")

# --- getFsisInfos input validation (no API needed) ---

test_that("getFsisInfos rejects invalid info_name", {
  expect_error(getFsisInfos("dummy_key", "invalidType"))
})

test_that("getFsisInfos accepts valid info_name values without arg validation error", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  for (nm in c("companySearch", "statisticsListSearch", "accountListSearch")) {
    result <- tryCatch(getFsisInfos(fisis_key, nm), error = function(e) e)
    if (inherits(result, "error")) {
      expect_false(grepl("arg.*should be one of", result$message),
                   label = paste("arg validation error for", nm))
    }
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
  expect_gt(nrow(result), 0)
})

test_that("getFsisInfos accountListSearch returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  result <- getFsisInfos(fisis_key, "accountListSearch")
  expect_true(is.data.frame(result))
})

# --- getFsisData live tests ---

test_that("getFsisData returns a data frame with default parameters", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  result <- getFsisData(fisis_key)
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisData returns a data frame with custom parameters", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  result <- getFsisData(fisis_key, finance_cd = "0010001", list_no = "SA053",
                        account_cd = "B", term = "Y",
                        start_month = "201501", end_month = "202312")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisData stops with informative message on bad key", {
  skip_on_cran()
  expect_error(getFsisData("INVALID_KEY_000"))
})

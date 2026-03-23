fisis_key <- Sys.getenv("FISIS_key")

skip_if_fisis_offline <- function() {
  result <- tryCatch(
    httr::GET("http://fisis.fss.or.kr/openapi/companySearch.json",
              httr::timeout(5)),
    error = function(e) NULL
  )
  if (is.null(result)) skip("FISIS server is not reachable")
}

# --- getFsisInfos input validation (no API needed) ---

test_that("getFsisInfos rejects invalid info_name", {
  expect_error(getFsisInfos("dummy_key", "invalidType"))
})

# --- getFsisInfos live tests ---

test_that("getFsisInfos companySearch returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  skip_if_fisis_offline()
  result <- getFsisInfos(fisis_key, "companySearch")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisInfos statisticsListSearch returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  skip_if_fisis_offline()
  result <- getFsisInfos(fisis_key, "statisticsListSearch")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisInfos accountListSearch returns a data frame", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  skip_if_fisis_offline()
  result <- getFsisInfos(fisis_key, "accountListSearch", item_code = "SA053")
  expect_true(is.data.frame(result))
})

# --- getFsisData live tests ---

test_that("getFsisData returns a data frame with default parameters", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  skip_if_fisis_offline()
  result <- getFsisData(fisis_key)
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisData returns a data frame with custom parameters", {
  skip_if(fisis_key == "", "FISIS_key not set")
  skip_on_cran()
  skip_if_fisis_offline()
  result <- getFsisData(fisis_key, finance_cd = "0010001", list_no = "SA053",
                        account_cd = "B", term = "Y",
                        start_month = "201501", end_month = "202312")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("getFsisData stops with informative message on bad key", {
  skip_on_cran()
  skip_if_fisis_offline()
  expect_error(getFsisData("INVALID_KEY_000"))
})

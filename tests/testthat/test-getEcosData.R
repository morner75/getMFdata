ecos_key <- Sys.getenv("ECOS_key")

# --- ecosSearch ---

test_that("ecosSearch errors when RDS file is missing from installed package", {
  path <- system.file("Rdata", "EcosStatsList.rds", package = "getMFdata")
  skip_if(nzchar(path), "EcosStatsList.rds is present; skipping missing-file test")
  expect_error(ecosSearch("GDP"), "EcosStatsList.rds not found")
})

test_that("ecosSearch returns a tibble when RDS file is present", {
  path <- system.file("Rdata", "EcosStatsList.rds", package = "getMFdata")
  skip_if(!nzchar(path), "EcosStatsList.rds not installed; skipping")
  result <- ecosSearch("GDP")
  expect_s3_class(result, "tbl_df")
})

# --- getEcosList ---

test_that("getEcosList returns a tibble with expected columns", {
  skip_if(ecos_key == "", "ECOS_key not set")
  skip_on_cran()
  result <- getEcosList(ecos_key)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("STAT_CODE", "STAT_NAME", "CYCLE", "ORG_NAME") %in% names(result)))
  expect_gt(nrow(result), 0)
})

test_that("getEcosList stops with informative message on bad key", {
  skip_on_cran()
  expect_error(getEcosList("INVALID_KEY_000"))
})

# --- getEcosCode ---

test_that("getEcosCode returns a tibble with expected columns", {
  skip_if(ecos_key == "", "ECOS_key not set")
  skip_on_cran()
  result <- getEcosCode(ecos_key, "722Y001")
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("STAT_CODE", "ITEM_CODE", "ITEM_NAME", "CYCLE") %in% names(result)))
})

# --- getEcosData ---

test_that("getEcosData returns a data frame with TIME and DATA_VALUE", {
  skip_if(ecos_key == "", "ECOS_key not set")
  skip_on_cran()
  # "722Y001": 통화량 통계, "MM": 월별, item_code1="0", item_code2="DDD"
  result <- getEcosData(ecos_key, "722Y001", "MM", "202001", "202012", "0", "DDD", "", "")
  expect_true(is.data.frame(result))
  expect_true(all(c("TIME", "DATA_VALUE") %in% names(result)))
  expect_gt(nrow(result), 0)
})

test_that("getEcosData stops with informative message on bad key", {
  skip_on_cran()
  expect_error(getEcosData("INVALID_KEY", "722Y001", "MM", "202001", "202012", "0", "DDD", "", ""))
})

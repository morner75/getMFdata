test_that("getBisDB returns a tibble with name and url columns", {
  skip_on_cran()
  db <- getBisDB()
  expect_s3_class(db, "tbl_df")
  expect_true(all(c("name", "url") %in% names(db)))
  expect_gt(nrow(db), 0)
})

test_that("getBisDB urls contain zip extension", {
  skip_on_cran()
  db <- getBisDB()
  expect_true(all(grepl("\\.zip$", db$url, ignore.case = TRUE)))
})

test_that("getBisData downloads and returns a data frame", {
  skip_on_cran()
  db <- getBisDB()
  skip_if(nrow(db) == 0, "No BIS datasets found")
  # BIS files are large; skip gracefully on download failure (timeout, network)
  result <- tryCatch(
    getBisData(db$url[1], quiet = TRUE),
    error = function(e) {
      skip(paste("BIS download failed:", conditionMessage(e)))
    }
  )
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

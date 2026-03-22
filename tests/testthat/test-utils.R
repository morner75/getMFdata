test_that("EcosTerm returns correct annual format", {
  d <- as.Date("2023-03-15")
  expect_equal(EcosTerm(d, "A"), "2023")
})

test_that("EcosTerm returns correct quarterly format", {
  d <- as.Date("2023-03-15")
  expect_equal(EcosTerm(d, "Q"), "2023Q1")
})

test_that("EcosTerm returns correct monthly format", {
  d <- as.Date("2023-03-15")
  expect_equal(EcosTerm(d, "M"), "202303")
})

test_that("EcosTerm returns correct daily format", {
  d <- as.Date("2023-03-15")
  expect_equal(EcosTerm(d, "D"), "20230315")
})

test_that("EcosTerm defaults to annual format", {
  d <- as.Date("2022-01-01")
  expect_equal(EcosTerm(d), "2022")
})

test_that("EcosTerm rejects invalid type", {
  expect_error(EcosTerm(as.Date("2023-01-01"), "X"))
})

test_that("EcosTerm works with POSIXct input", {
  dt <- as.POSIXct("2023-06-30 12:00:00")
  expect_equal(EcosTerm(dt, "A"), "2023")
  expect_equal(EcosTerm(dt, "M"), "202306")
})

test_that("EcosTerm handles Q4 correctly", {
  d <- as.Date("2023-12-01")
  expect_equal(EcosTerm(d, "Q"), "2023Q4")
})

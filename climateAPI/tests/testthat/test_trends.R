library(testthat)

#Test that is works
test_that("Function runs without errors", {
  expect_no_error(temp_trends(3047))
})

#make sure that all results are numeric
test_that("Returned result contains expected elements and data types", {
  result <- temp_trends(3047)
  expect_type(result['Station_ID'], "double")
  expect_type(result['Intercept'], "double")
  expect_type(result['Slope'], "double")
  expect_type(result['PValue'], "double")
})

#make sure pvalue is between 0 and 1
test_that("P-value falls within the range [0, 1]", {
  result <- temp_trends(3047)
  expect_true(result['PValue'] >= 0 && result['PValue'] <= 1)
})
